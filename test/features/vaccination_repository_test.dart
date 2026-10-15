import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:gestavi_mobile/features/vaccinations/vaccination_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _vaccination(
  int id, {
  int flockId = 1,
  int farmId = 1,
  String status = 'pending',
  bool overdue = false,
}) => {
  'id': id,
  'flock_id': flockId,
  'flock_code': 'LOT-00$flockId',
  'farm_id': farmId,
  'treatment_name': 'Vaccin $id',
  'treatment_type': 'vaccin',
  'scheduled_date': overdue ? '2026-10-10' : '2026-10-20',
  'status': status,
  'is_overdue': overdue,
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late SyncQueueRepository queue;
  late VaccinationRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    queue = SyncQueueRepository(db: db, api: api);
    repository = VaccinationRepository(db: db, api: api, queue: queue);
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [
          _vaccination(1, overdue: true),
          _vaccination(2),
          _vaccination(3, flockId: 2, farmId: 2),
        ],
        'meta': {'last_page': 1},
      },
    );
  });

  tearDown(() => db.close());

  test('rafraîchit les vaccinations à faire et les relit par bande', () async {
    expect(
      await repository.refresh(
        organisationId: 7,
        organisationSlug: 'ferme-demo',
      ),
      3,
    );

    final flockOne = await repository
        .watchTodo(organisationId: 7, flockId: 1)
        .first;
    expect(flockOne.map((v) => v.id), [1, 2]);
    expect(flockOne.first.isOverdue, isTrue);
    expect(flockOne.first.flockCode, 'LOT-001');

    final farmTwo = await repository
        .watchTodo(organisationId: 7, farmId: 2)
        .first;
    expect(farmTwo.single.id, 3);
  });

  test('marquer faite met la validation en file et retire la vaccination des « à faire », même après rafraîchissement', () async {
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    final todo = await repository
        .watchTodo(organisationId: 7, flockId: 1)
        .first;

    await repository.markDone(
      organisationId: 7,
      vaccination: todo.first,
      administeredDate: DateTime(2026, 10, 15),
      birdsTreated: 980,
    );

    final pending = await queue.pending(7);
    final payload = decodePayload(pending.single.payload);
    expect(pending.single.type, 'vaccination_done');
    expect(payload['vaccination_id'], 1);
    expect(payload['administered_date'], '2026-10-15');
    expect(payload['birds_treated'], 980);
    expect(payload.containsKey('observations'), isFalse);

    expect(
      (await repository.watchTodo(organisationId: 7, flockId: 1).first).map(
        (v) => v.id,
      ),
      [2],
    );

    // Le serveur ne sait pas encore : au rafraîchissement, la validation locale prime
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    expect(
      (await repository.watchTodo(organisationId: 7, flockId: 1).first).map(
        (v) => v.id,
      ),
      [2],
    );
  });

  test('la validation part en lot sur /sync avec les relevés', () async {
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    final todo = await repository.watchTodo(organisationId: 7).first;
    await repository.markDone(
      organisationId: 7,
      vaccination: todo.first,
      administeredDate: DateTime(2026, 10, 15),
    );
    when(
      () =>
          api.post('/organisations/ferme-demo/sync', body: any(named: 'body')),
    ).thenAnswer((invocation) async {
      final entries =
          (invocation.namedArguments[#body] as Map<String, dynamic>)['entries']
              as List<dynamic>;

      return {
        'results': [
          for (final entry in entries.cast<Map<String, dynamic>>())
            {
              'client_uuid': entry['client_uuid'],
              'status': 'created',
              'message': 'Vaccination enregistrée.',
              'id': 1,
            },
        ],
      };
    });

    expect(
      await queue.push(organisationId: 7, organisationSlug: 'ferme-demo'),
      1,
    );
    expect(await queue.pending(7), isEmpty);
  });
}
