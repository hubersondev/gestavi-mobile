import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';

/// Vaccinations et traitements à faire, en cache par bande. Marquer une vaccination effectuée
/// hors-ligne la passe en « done » localement et met la validation en file (`vaccination_done`,
/// envoyée par lot sur `/sync`).
class VaccinationRepository {
  VaccinationRepository({
    required AppDatabase db,
    required ApiClient api,
    required SyncQueueRepository queue,
  }) : _db = db,
       _api = api,
       _queue = queue;

  final AppDatabase _db;
  final ApiClient _api;
  final SyncQueueRepository _queue;

  /// À faire (en attente ou reportées), les plus urgentes d'abord.
  Stream<List<CachedVaccination>> watchTodo({
    required int organisationId,
    int? farmId,
    int? flockId,
  }) {
    final query = _db.select(_db.cachedVaccinations)
      ..where(
        (v) =>
            v.organisationId.equals(organisationId) &
            v.status.isIn(const ['pending', 'delayed']),
      )
      ..orderBy([
        (v) => OrderingTerm.asc(v.scheduledDate),
        (v) => OrderingTerm.asc(v.id),
      ]);

    if (farmId != null) {
      query.where((v) => v.farmId.equals(farmId));
    }

    if (flockId != null) {
      query.where((v) => v.flockId.equals(flockId));
    }

    return query.watch();
  }

  /// Recharge les vaccinations à faire depuis l'API ; celles validées localement et pas encore
  /// envoyées restent « done » pour ne pas réapparaître.
  Future<int> refresh({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final rows = <CachedVaccinationsCompanion>[];
    var page = 1;

    while (true) {
      final response = await _api.get(
        '/organisations/$organisationSlug/vaccinations',
        query: {'per_page': 500, 'page': page},
      );

      for (final item
          in (response['data'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        rows.add(_fromServer(organisationId, item));
      }

      final lastPage =
          ((response['meta'] as Map<String, dynamic>?)?['last_page'] as int?) ??
          1;

      if (page >= lastPage) {
        break;
      }

      page++;
    }

    final pendingIds = (await _queue.pending(organisationId))
        .where((e) => e.type == 'vaccination_done')
        .map((e) => decodePayload(e.payload)['vaccination_id'] as int)
        .toSet();

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedVaccinations,
      )..where((v) => v.organisationId.equals(organisationId))).go();
      await _db.batch(
        (batch) => batch.insertAll(
          _db.cachedVaccinations,
          rows
              .map(
                (row) => pendingIds.contains(row.id.value)
                    ? row.copyWith(status: const Value('done'))
                    : row,
              )
              .toList(),
          mode: InsertMode.insertOrReplace,
        ),
      );
    });

    return rows.length;
  }

  /// Marque la vaccination effectuée : file de synchronisation puis statut local.
  Future<String> markDone({
    required int organisationId,
    required CachedVaccination vaccination,
    required DateTime administeredDate,
    int? birdsTreated,
    String? observations,
  }) async {
    final payload = <String, dynamic>{
      'vaccination_id': vaccination.id,
      'administered_date': isoDate(administeredDate),
      'birds_treated': birdsTreated,
      'observations': observations,
    }..removeWhere((_, value) => value == null);

    final clientUuid = await _queue.enqueue(
      organisationId: organisationId,
      type: 'vaccination_done',
      payload: payload,
      recordedAt: DateTime.now(),
    );

    await (_db.update(
      _db.cachedVaccinations,
    )..where((v) => v.id.equals(vaccination.id))).write(
      CachedVaccinationsCompanion(
        status: const Value('done'),
        administeredDate: Value(isoDate(administeredDate)),
        isOverdue: const Value(false),
      ),
    );

    return clientUuid;
  }

  CachedVaccinationsCompanion _fromServer(
    int organisationId,
    Map<String, dynamic> item,
  ) => CachedVaccinationsCompanion.insert(
    id: Value(item['id'] as int),
    organisationId: organisationId,
    flockId: item['flock_id'] as int,
    farmId: Value(item['farm_id'] as int?),
    flockCode: Value(item['flock_code'] as String?),
    treatmentName: item['treatment_name'] as String,
    treatmentType: Value(item['treatment_type'] as String?),
    administrationRoute: Value(item['administration_route'] as String?),
    dosage: Value(item['dosage'] as String?),
    scheduledDate: item['scheduled_date'] as String? ?? '',
    administeredDate: Value(item['administered_date'] as String?),
    status: item['status'] as String? ?? 'pending',
    isOverdue: Value(item['is_overdue'] as bool? ?? false),
  );

  static String isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

final vaccinationRepositoryProvider = Provider<VaccinationRepository>(
  (ref) => VaccinationRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
    queue: ref.watch(syncQueueProvider),
  ),
);

/// Vaccinations à faire d'une ferme (farmId null = toutes) ou d'une bande.
final vaccinationsTodoProvider =
    StreamProvider.family<
      List<CachedVaccination>,
      ({int organisationId, int? farmId, int? flockId})
    >(
      (ref, scope) => ref
          .watch(vaccinationRepositoryProvider)
          .watchTodo(
            organisationId: scope.organisationId,
            farmId: scope.farmId,
            flockId: scope.flockId,
          ),
    );

/// Libellé du type de traitement de l'API.
String treatmentTypeLabel(String? type) => switch (type) {
  'vaccin' => 'Vaccin',
  'vitamine' || 'vitamin' => 'Vitamines',
  'antibiotique' || 'antibiotic' => 'Antibiotique',
  'vermifuge' || 'dewormer' => 'Vermifuge',
  'antiparasitaire' => 'Antiparasitaire',
  null => 'Traitement',
  _ => type,
};
