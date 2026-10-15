import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/features/flocks/flock_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _flock(int id, {int farmId = 1, String? lastRecord}) => {
  'id': id,
  'code': 'LOT-00$id',
  'name': 'Bande $id',
  'status': 'active',
  'farm_id': farmId,
  'farm': 'Ferme $farmId',
  'kind': 'layer',
  'tracks_eggs': true,
  'tracks_weight': false,
  'quantity_current': 1000 * id,
  'age_days': 30,
  'last_record_date': lastRecord,
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late FlockRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    repository = FlockRepository(db: db, api: api);
  });

  tearDown(() => db.close());

  test(
    'rafraîchit le cache depuis l\'API, page par page, et le relit par ferme',
    () async {
      when(() => api.get(any(), query: any(named: 'query'))).thenAnswer((
        invocation,
      ) async {
        final page =
            (invocation.namedArguments[#query] as Map<String, dynamic>)['page']
                as int;

        return page == 1
            ? {
                'data': [_flock(1), _flock(2, farmId: 2)],
                'meta': {'last_page': 2},
              }
            : {
                'data': [_flock(3, farmId: 2, lastRecord: '2026-10-14')],
                'meta': {'last_page': 2},
              };
      });

      expect(
        await repository.refresh(
          organisationId: 7,
          organisationSlug: 'ferme-demo',
        ),
        3,
      );

      final all = await repository.watch(organisationId: 7).first;
      final farmTwo = await repository
          .watch(organisationId: 7, farmId: 2)
          .first;

      expect(all.map((f) => f.code), ['LOT-001', 'LOT-002', 'LOT-003']);
      expect(farmTwo.map((f) => f.id), [2, 3]);
      expect(farmTwo.last.lastRecordDate, '2026-10-14');
      expect(all.first.tracksEggs, isTrue);
    },
  );

  test('sans réseau, le cache précédent reste lisible', () async {
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [_flock(1)],
        'meta': {'last_page': 1},
      },
    );
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');

    when(() => api.get(any(), query: any(named: 'query')))
        .thenThrow(const ApiException('Pas de connexion'));

    await expectLater(
      () =>
          repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo'),
      throwsA(isA<ApiException>()),
    );
    expect(
      (await repository.watch(organisationId: 7).first).single.code,
      'LOT-001',
    );
  });

  test('un relevé local décrémente l\'effectif et avance la date du dernier relevé', () async {
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [_flock(1, lastRecord: '2026-10-10')],
        'meta': {'last_page': 1},
      },
    );
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');

    await repository.applyLocalRecord(
      flockId: 1,
      recordDate: '2026-10-15',
      losses: 12,
    );

    final flock = await repository.find(1);
    expect(flock?.quantityCurrent, 988);
    expect(flock?.lastRecordDate, '2026-10-15');

    // Un relevé antérieur ne fait pas reculer la date
    await repository.applyLocalRecord(
      flockId: 1,
      recordDate: '2026-10-01',
      losses: 0,
    );
    expect((await repository.find(1))?.lastRecordDate, '2026-10-15');
  });
}
