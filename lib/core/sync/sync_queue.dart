import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../db/app_database.dart';

/// File des saisies hors-ligne : mise en attente locale, puis envoi par lots à l'API
/// (`POST /organisations/{slug}/sync`), dont chaque verdict (created, duplicate, rejected)
/// est conservé. Une saisie refusée reste visible pour correction, jamais rejouée en boucle.
class SyncQueueRepository {
  SyncQueueRepository({
    required AppDatabase db,
    required ApiClient api,
    Uuid? uuid,
  }) : _db = db,
       _api = api,
       _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final ApiClient _api;
  final Uuid _uuid;

  static const int batchSize = 50;

  /// Met une saisie en attente et retourne son identifiant client.
  Future<String> enqueue({
    required int organisationId,
    required String type,
    required Map<String, dynamic> payload,
    DateTime? recordedAt,
    String? clientUuid,
  }) async {
    clientUuid ??= _uuid.v4();

    await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion.insert(
            clientUuid: clientUuid,
            organisationId: organisationId,
            type: type,
            payload: jsonEncode(payload),
            recordedAt: recordedAt ?? DateTime.now(),
          ),
        );

    return clientUuid;
  }

  Stream<int> watchPendingCount(int organisationId) {
    final query = _db.select(_db.syncQueue)
      ..where(
        (q) =>
            q.organisationId.equals(organisationId) &
            q.status.equals('pending'),
      );

    return query.watch().map((rows) => rows.length);
  }

  Future<List<SyncQueueData>> pending(int organisationId) =>
      (_db.select(_db.syncQueue)
            ..where(
              (q) =>
                  q.organisationId.equals(organisationId) &
                  q.status.equals('pending'),
            )
            ..orderBy([(q) => OrderingTerm.asc(q.recordedAt)]))
          .get();

  Future<List<SyncQueueData>> rejected(int organisationId) =>
      (_db.select(_db.syncQueue)
            ..where(
              (q) =>
                  q.organisationId.equals(organisationId) &
                  q.status.equals('rejected'),
            )
            ..orderBy([(q) => OrderingTerm.desc(q.recordedAt)]))
          .get();

  /// Envoie les saisies en attente de l'organisation, par lots. Retourne le nombre traité.
  /// Sans réseau, la file reste intacte et l'erreur remonte pour affichage.
  Future<int> push({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final entries = await pending(organisationId);

    if (entries.isEmpty) {
      return 0;
    }

    var processed = 0;

    // Les ventes passent une par une sur leur point d'entrée idempotent (POST /sales)
    final sales = entries.where((e) => e.type == 'sale').toList();
    final batched = entries.where((e) => e.type != 'sale').toList();

    for (final entry in sales) {
      processed += await _pushSale(entry, organisationSlug);
    }

    for (var offset = 0; offset < batched.length; offset += batchSize) {
      final batch = batched.sublist(
        offset,
        (offset + batchSize).clamp(0, batched.length),
      );

      final response = await _api.post(
        '/organisations/$organisationSlug/sync',
        body: {
          'entries': batch
              .map(
                (entry) => {
                  'client_uuid': entry.clientUuid,
                  'type': entry.type,
                  'payload': jsonDecode(entry.payload),
                  'recorded_at': entry.recordedAt.toIso8601String(),
                },
              )
              .toList(),
        },
      );

      final results = (response['results'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();

      for (final result in results) {
        await (_db.update(_db.syncQueue)..where(
              (q) => q.clientUuid.equals(result['client_uuid'] as String),
            ))
            .write(
              SyncQueueCompanion(
                status: Value(result['status'] as String? ?? 'rejected'),
                message: Value(result['message'] as String?),
                subjectId: Value(result['id'] as int?),
                attempts: Value(
                  batch
                          .firstWhere(
                            (e) => e.clientUuid == result['client_uuid'],
                          )
                          .attempts +
                      1,
                ),
                syncedAt: Value(DateTime.now()),
              ),
            );
        processed++;
      }
    }

    return processed;
  }

  /// Envoie une vente ; 201/200 → created, refus métier (422/403) → rejected, réseau → l'erreur remonte.
  Future<int> _pushSale(SyncQueueData entry, String organisationSlug) async {
    String status;
    String? message;
    int? subjectId;

    try {
      final response = await _api.post(
        '/organisations/$organisationSlug/sales',
        body: jsonDecode(entry.payload) as Map<String, dynamic>,
      );
      final data = response['data'] as Map<String, dynamic>? ?? response;
      status = 'created';
      subjectId = data['id'] as int?;
      await onSaleSynced?.call(entry.organisationId, entry.clientUuid, data);
    } on ApiException catch (e) {
      if (e.isNetwork) {
        rethrow;
      }

      status = 'rejected';
      message = e.message;
    }

    await (_db.update(
      _db.syncQueue,
    )..where((q) => q.clientUuid.equals(entry.clientUuid))).write(
      SyncQueueCompanion(
        status: Value(status),
        message: Value(message),
        subjectId: Value(subjectId),
        attempts: Value(entry.attempts + 1),
        syncedAt: Value(DateTime.now()),
      ),
    );

    return 1;
  }

  /// Rappel après l'envoi réussi d'une vente (le cache des ventes prend l'identité serveur).
  Future<void> Function(
    int organisationId,
    String clientUuid,
    Map<String, dynamic> serverSale,
  )?
  onSaleSynced;

  /// Variante tolérante pour la synchronisation en tâche de fond : avale les erreurs réseau.
  Future<int> pushQuietly({
    required int organisationId,
    required String organisationSlug,
  }) async {
    try {
      return await push(
        organisationId: organisationId,
        organisationSlug: organisationSlug,
      );
    } on ApiException catch (e) {
      if (e.isNetwork) {
        return 0;
      }

      rethrow;
    }
  }
}

final syncQueueProvider = Provider<SyncQueueRepository>(
  (ref) => SyncQueueRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
  ),
);
