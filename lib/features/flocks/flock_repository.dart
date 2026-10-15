import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/db/app_database.dart';

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

  /// Met le cache à jour après un relevé saisi localement, sans attendre la synchronisation.
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
          (flock.quantityCurrent - losses).clamp(0, flock.quantityCurrent),
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

final flockRepositoryProvider = Provider<FlockRepository>(
  (ref) => FlockRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
  ),
);

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
