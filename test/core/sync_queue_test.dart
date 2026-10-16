import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

void main() {
  late AppDatabase db;
  late _MockApi api;
  late SyncQueueRepository queue;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    queue = SyncQueueRepository(db: db, api: api);
  });

  tearDown(() => db.close());

  test(
    'met une saisie en attente avec un identifiant unique et la compte',
    () async {
      final uuid = await queue.enqueue(
        organisationId: 1,
        type: 'daily_record',
        payload: {'flock_id': 7, 'mortality': 2},
      );

      expect(uuid, hasLength(36));
      expect(await queue.watchPendingCount(1).first, 1);
      expect(await queue.watchPendingCount(2).first, 0);
    },
  );

  test(
    'envoie les saisies en attente et conserve le verdict de chacune',
    () async {
      final first = await queue.enqueue(
        organisationId: 1,
        type: 'daily_record',
        payload: {'flock_id': 7, 'mortality': 2},
      );
      final second = await queue.enqueue(
        organisationId: 1,
        type: 'daily_record',
        payload: {'flock_id': 8, 'mortality': 0},
      );

      when(() => api.post(any(), body: any(named: 'body'))).thenAnswer(
        (invocation) async => {
          'results': [
            {
              'client_uuid': first,
              'status': 'created',
              'message': 'Relevé enregistré.',
              'id': 41,
            },
            {
              'client_uuid': second,
              'status': 'rejected',
              'message': 'Bande inconnue.',
              'id': null,
            },
          ],
        },
      );

      final processed = await queue.push(
        organisationId: 1,
        organisationSlug: 'ferme-demo',
      );

      expect(processed, 2);
      expect(await queue.watchPendingCount(1).first, 0);

      final rejected = await queue.rejected(1);
      expect(rejected.single.clientUuid, second);
      expect(rejected.single.message, 'Bande inconnue.');

      final sent = verify(
        () => api.post(captureAny(), body: captureAny(named: 'body')),
      ).captured;
      expect(sent.first, '/organisations/ferme-demo/sync');
      expect((sent.last as Map<String, dynamic>)['entries'], hasLength(2));
    },
  );

  test('organisation en lecture seule (423) : la saisie reste en attente, pas refusée', () async {
    await queue.enqueue(
      organisationId: 1,
      type: 'daily_record',
      payload: {'flock_id': 7},
    );
    when(() => api.post(any(), body: any(named: 'body'))).thenThrow(
      const ApiException('Organisation en lecture seule', statusCode: 423),
    );

    expect(
      await queue.pushQuietly(
        organisationId: 1,
        organisationSlug: 'ferme-demo',
      ),
      0,
    );
    expect(await queue.watchPendingCount(1).first, 1);
    expect(await queue.rejected(1), isEmpty);
  });

  test(
    'sans réseau, la file reste intacte et pushQuietly n\'échoue pas',
    () async {
      await queue.enqueue(
        organisationId: 1,
        type: 'daily_record',
        payload: {'flock_id': 7},
      );
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Pas de connexion'));

      expect(
        await queue.pushQuietly(
          organisationId: 1,
          organisationSlug: 'ferme-demo',
        ),
        0,
      );
      expect(await queue.watchPendingCount(1).first, 1);
    },
  );
}
