import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';

/// Bandes visibles par l'éleveur : rafraîchies depuis l'API quand le réseau le permet,
/// toujours lues depuis le cache local pour fonctionner sans réseau.
class FlockRepository {
  FlockRepository({required AppDatabase db, required ApiClient api})
    : _db = db,
      _api = api;

  final AppDatabase _db;
  final ApiClient _api;

  /// Bandes actives de l'organisation (et de la ferme si précisée), depuis le cache.
  Stream<List<CachedFlock>> watch({required int organisationId, int? farmId}) {
    final query = _db.select(_db.cachedFlocks)
      ..where(
        (f) =>
            f.organisationId.equals(organisationId) & f.status.equals('active'),
      )
      ..orderBy([
        (f) => OrderingTerm.asc(f.farmName),
        (f) => OrderingTerm.asc(f.code),
      ]);

    if (farmId != null) {
      query.where((f) => f.farmId.equals(farmId));
    }

    return query.watch();
  }

  Future<CachedFlock?> find(int flockId) => (_db.select(
    _db.cachedFlocks,
  )..where((f) => f.id.equals(flockId))).getSingleOrNull();

  /// Remplace le cache de l'organisation par la liste renvoyée par l'API.
  /// Sans réseau, lève une [ApiException] réseau : l'appelant garde le cache.
  Future<int> refresh({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final rows = <CachedFlocksCompanion>[];
    var page = 1;

    while (true) {
      final response = await _api.get(
        '/organisations/$organisationSlug/flocks',
        query: {'status': 'active', 'per_page': 200, 'page': page},
      );

      for (final item
          in (response['data'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        rows.add(_companionFrom(organisationId, item));
      }

      final meta = response['meta'] as Map<String, dynamic>?;
      final lastPage = (meta?['last_page'] as int?) ?? 1;

      if (page >= lastPage) {
        break;
      }

      page++;
    }

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedFlocks,
      )..where((f) => f.organisationId.equals(organisationId))).go();
      await _db.batch(
        (batch) => batch.insertAll(
          _db.cachedFlocks,
          rows,
          mode: InsertMode.insertOrReplace,
        ),
      );
    });

    return rows.length;
  }

  /// Relevés des derniers jours depuis l'API ; les saisies locales en attente sont conservées.
  Future<int> refreshDailyRecords({
    required int organisationId,
    required String organisationSlug,
    int days = 7,
  }) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final response = await _api.get(
      '/organisations/$organisationSlug/daily-records',
      query: {'since': since.toIso8601String(), 'per_page': 500},
    );
    final rows = (response['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (item) => CachedDailyRecordsCompanion.insert(
            key: recordKey(
              item['flock_id'] as int,
              item['record_date'] as String,
            ),
            organisationId: organisationId,
            flockId: item['flock_id'] as int,
            recordDate: item['record_date'] as String,
            serverId: Value(item['id'] as int?),
            mortality: Value(item['mortality'] as int? ?? 0),
            culls: Value(item['culls'] as int? ?? 0),
            eggsCollected: Value(item['eggs_collected'] as int?),
            eggsBroken: Value(item['eggs_broken'] as int?),
            feedKg: Value((item['feed_consumed_kg'] as num?)?.toDouble()),
            waterL: Value((item['water_consumed_l'] as num?)?.toDouble()),
            averageWeightG: Value(
              (item['average_weight_g'] as num?)?.toDouble(),
            ),
            birdsWeighed: Value(item['birds_weighed'] as int?),
            notes: Value(item['notes'] as String?),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();

    await _db.transaction(() async {
      // Les relevés serveur remplacent le cache, sauf les saisies locales pas encore envoyées
      await (_db.delete(_db.cachedDailyRecords)..where(
            (r) =>
                r.organisationId.equals(organisationId) & r.clientUuid.isNull(),
          ))
          .go();
      for (final row in rows) {
        final local = await findRecord(row.flockId.value, row.recordDate.value);

        if (local == null || local.clientUuid == null) {
          await _db.into(_db.cachedDailyRecords).insertOnConflictUpdate(row);
        }
      }
    });

    return rows.length;
  }

  Future<CachedDailyRecord?> findRecord(int flockId, String recordDate) =>
      (_db.select(_db.cachedDailyRecords)
            ..where((r) => r.key.equals(recordKey(flockId, recordDate))))
          .getSingleOrNull();

  /// Conserve localement un relevé saisi sur le téléphone (ou complété), pour le pré-remplir ensuite.
  Future<void> upsertLocalRecord({
    required int organisationId,
    required int flockId,
    required String recordDate,
    required Map<String, dynamic> payload,
    required String? clientUuid,
    int? serverId,
  }) => _db
      .into(_db.cachedDailyRecords)
      .insertOnConflictUpdate(
        CachedDailyRecordsCompanion.insert(
          key: recordKey(flockId, recordDate),
          organisationId: organisationId,
          flockId: flockId,
          recordDate: recordDate,
          serverId: Value(serverId),
          clientUuid: Value(clientUuid),
          mortality: Value(payload['mortality'] as int? ?? 0),
          culls: Value(payload['culls'] as int? ?? 0),
          eggsCollected: Value(payload['eggs_collected'] as int?),
          eggsBroken: Value(payload['eggs_broken'] as int?),
          feedKg: Value((payload['feed_consumed_kg'] as num?)?.toDouble()),
          waterL: Value((payload['water_consumed_l'] as num?)?.toDouble()),
          averageWeightG: Value(
            (payload['average_weight_g'] as num?)?.toDouble(),
          ),
          birdsWeighed: Value(payload['birds_weighed'] as int?),
          notes: Value(payload['notes'] as String?),
          updatedAt: DateTime.now(),
        ),
      );

  /// Après synchronisation d'un relevé local, il devient un relevé serveur.
  Future<void> markRecordSynced(String clientUuid, int? serverId) =>
      (_db.update(
        _db.cachedDailyRecords,
      )..where((r) => r.clientUuid.equals(clientUuid))).write(
        CachedDailyRecordsCompanion(
          clientUuid: const Value(null),
          serverId: Value(serverId),
        ),
      );

  static String recordKey(int flockId, String recordDate) =>
      '${flockId}_$recordDate';

  /// Met le cache à jour après un relevé saisi localement, sans attendre la synchronisation.
  /// [losses] est l'écart de pertes par rapport à ce qui était déjà compté pour ce jour.
  Future<void> applyLocalRecord({
    required int flockId,
    required String recordDate,
    required int losses,
  }) async {
    final flock = await find(flockId);

    if (flock == null) {
      return;
    }

    await (_db.update(
      _db.cachedFlocks,
    )..where((f) => f.id.equals(flockId))).write(
      CachedFlocksCompanion(
        quantityCurrent: Value(
          (flock.quantityCurrent - losses).clamp(0, 1 << 30),
        ),
        lastRecordDate: Value(
          flock.lastRecordDate == null ||
                  recordDate.compareTo(flock.lastRecordDate!) > 0
              ? recordDate
              : flock.lastRecordDate,
        ),
      ),
    );
  }

  CachedFlocksCompanion _companionFrom(
    int organisationId,
    Map<String, dynamic> json,
  ) => CachedFlocksCompanion.insert(
    id: Value(json['id'] as int),
    organisationId: organisationId,
    farmId: Value(json['farm_id'] as int?),
    code: json['code'] as String,
    name: Value(json['name'] as String?),
    farmName: Value(json['farm'] as String?),
    kind: json['kind'] as String? ?? 'meat',
    tracksEggs: Value(json['tracks_eggs'] as bool? ?? false),
    tracksWeight: Value(json['tracks_weight'] as bool? ?? false),
    quantityCurrent: Value(json['quantity_current'] as int? ?? 0),
    ageDays: Value(json['age_days'] as int?),
    lastRecordDate: Value(json['last_record_date'] as String?),
    status: json['status'] as String? ?? 'active',
  );
}

final flockRepositoryProvider = Provider<FlockRepository>((ref) {
  final repository = FlockRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
  );

  // Un relevé envoyé devient un relevé serveur dans le cache (plus de saisie en attente)
  ref.watch(syncQueueProvider).onSynced['daily_record'] = (
    organisationId,
    clientUuid,
    result,
  ) => repository.markRecordSynced(clientUuid, result['id'] as int?);

  return repository;
});

/// Bandes du contexte de travail, depuis le cache (mise à jour en continu).
final flocksProvider =
    StreamProvider.family<
      List<CachedFlock>,
      ({int organisationId, int? farmId})
    >(
      (ref, scope) => ref
          .watch(flockRepositoryProvider)
          .watch(organisationId: scope.organisationId, farmId: scope.farmId),
    );

/// Message d'erreur réseau lisible, ou null si l'exception n'est pas réseau.
String? networkMessage(Object error) =>
    error is ApiException && error.isNetwork ? error.message : null;
