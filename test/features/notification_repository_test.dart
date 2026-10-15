import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/features/alerts/notification_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _notification(String id, {bool read = false}) => {
  'id': id,
  'title': 'Stock bas',
  'body': 'Aliment ponte : 80 kg restants.',
  'status': 'warning',
  'url': null,
  'read_at': read ? '2026-10-15T08:00:00+00:00' : null,
  'created_at': '2026-10-15T07:00:00+00:00',
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late NotificationRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    repository = NotificationRepository(db: db, api: api);
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [_notification('a'), _notification('b', read: true)],
      },
    );
  });

  tearDown(() => db.close());

  test('rafraîchit le cache et compte les non lues', () async {
    expect(await repository.refresh(), 2);
    expect((await repository.watch().first).length, 2);
    expect(await repository.watchUnreadCount().first, 1);
  });

  test('marquer lue appelle l\'API puis met le cache à jour', () async {
    await repository.refresh();
    when(() => api.post(any())).thenAnswer((_) async => {'message': 'ok'});

    await repository.markAsRead('a');

    verify(() => api.post('/notifications/a/read')).called(1);
    expect(await repository.watchUnreadCount().first, 0);
  });

  test('sans réseau, le cache reste intact et l\'erreur remonte', () async {
    await repository.refresh();
    when(() => api.post(any()))
        .thenThrow(const ApiException('Pas de connexion'));

    await expectLater(repository.markAllAsRead, throwsA(isA<ApiException>()));
    expect(await repository.watchUnreadCount().first, 1);
  });
}
