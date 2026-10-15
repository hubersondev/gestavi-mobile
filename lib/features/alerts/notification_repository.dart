import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_database.dart';

/// Notifications de l'utilisateur (stock bas, relevés manquants, factures échues…), rafraîchies
/// depuis `GET /notifications` et lisibles sans réseau. Marquer lu exige le réseau.
class NotificationRepository {
  NotificationRepository({required AppDatabase db, required ApiClient api})
    : _db = db,
      _api = api;

  final AppDatabase _db;
  final ApiClient _api;

  Stream<List<CachedNotification>> watch() => (_db.select(
    _db.cachedNotifications,
  )..orderBy([(n) => OrderingTerm.desc(n.createdAt)])).watch();

  Stream<int> watchUnreadCount() => (_db.select(
    _db.cachedNotifications,
  )..where((n) => n.readAt.isNull())).watch().map((rows) => rows.length);

  /// Les notifications les plus récentes remplacent le cache.
  Future<int> refresh() async {
    final response = await _api.get('/notifications', query: {'per_page': 100});
    final rows = (response['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (item) => CachedNotificationsCompanion.insert(
            id: item['id'] as String,
            title: Value(item['title'] as String?),
            body: Value(item['body'] as String?),
            status: Value(item['status'] as String?),
            url: Value(item['url'] as String?),
            readAt: Value(_date(item['read_at'])),
            createdAt: _date(item['created_at']) ?? DateTime.now(),
          ),
        )
        .toList();

    await _db.transaction(() async {
      await _db.delete(_db.cachedNotifications).go();
      await _db.batch(
        (batch) => batch.insertAll(
          _db.cachedNotifications,
          rows,
          mode: InsertMode.insertOrReplace,
        ),
      );
    });

    return rows.length;
  }

  Future<void> markAsRead(String id) async {
    await _api.post('/notifications/$id/read');
    await (_db.update(_db.cachedNotifications)..where((n) => n.id.equals(id)))
        .write(CachedNotificationsCompanion(readAt: Value(DateTime.now())));
  }

  Future<void> markAllAsRead() async {
    await _api.post('/notifications/read-all');
    await (_db.update(_db.cachedNotifications)..where((n) => n.readAt.isNull()))
        .write(CachedNotificationsCompanion(readAt: Value(DateTime.now())));
  }

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
  ),
);

final notificationsProvider = StreamProvider<List<CachedNotification>>(
  (ref) => ref.watch(notificationRepositoryProvider).watch(),
);

final unreadNotificationsCountProvider = StreamProvider<int>(
  (ref) => ref.watch(notificationRepositoryProvider).watchUnreadCount(),
);
