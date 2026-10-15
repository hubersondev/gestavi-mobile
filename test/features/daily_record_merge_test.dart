import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:gestavi_mobile/features/auth/auth_controller.dart';
import 'package:gestavi_mobile/features/auth/models.dart';
import 'package:gestavi_mobile/features/flocks/daily_record_screen.dart';
import 'package:gestavi_mobile/features/flocks/flock_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

/// Session connectée, sans réseau ni stockage.
class _ConnectedController extends AuthController {
  @override
  Future<AuthState> build() async => Authenticated(
    profile: UserProfile(
      id: 1,
      name: 'Jean',
      email: 'jean@ferme-demo.ci',
      memberships: [_membership],
    ),
    membership: _membership,
    farmId: 1,
    farmResolved: true,
  );
}

final _membership = Membership(
  organisationId: 7,
  slug: 'ferme-demo',
  name: 'Fermes Kouassi & Fils',
  role: 'employee',
  roleLabel: 'Employé',
  allFarms: false,
  farmIds: const [1],
  permissions: const {'daily_records.create'},
);

const _flock = CachedFlock(
  id: 3,
  organisationId: 7,
  farmId: 1,
  code: 'LOT-003',
  name: 'Pondeuses',
  farmName: 'Ferme A',
  kind: 'layer',
  tracksEggs: true,
  tracksWeight: false,
  quantityCurrent: 997,
  ageDays: 120,
  lastRecordDate: null,
  status: 'active',
);

String _today() {
  final now = DateTime.now();

  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 20));
}

void main() {
  late AppDatabase db;
  late _MockApi api;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    await db.into(db.cachedFlocks).insert(_flock);
    when(() => api.post(any(), body: any(named: 'body')))
        .thenThrow(const ApiException('Pas de connexion'));
  });

  tearDown(() => db.close());

  // Une clé distincte force un nouvel arbre : un second pumpWidget identique réutiliserait le
  // navigateur dont la route a déjà été fermée par l'enregistrement
  Widget app({Key? key}) => ProviderScope(
    key: key,
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      apiClientProvider.overrideWithValue(api),
      authControllerProvider.overrideWith(_ConnectedController.new),
    ],
    child: const MaterialApp(home: DailyRecordScreen(flock: _flock)),
  );

  test('les relevés récents du serveur se mettent en cache, sans écraser une saisie locale', () async {
    final repository = FlockRepository(db: db, api: api);
    await repository.upsertLocalRecord(
      organisationId: 7,
      flockId: 3,
      recordDate: '2026-10-14',
      payload: const {'mortality': 1, 'culls': 0, 'eggs_collected': 500},
      clientUuid: 'local-uuid',
    );
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 41,
            'flock_id': 3,
            'record_date': '2026-10-14',
            'mortality': 9,
            'culls': 0,
            'eggs_collected': 100,
          },
          {
            'id': 42,
            'flock_id': 3,
            'record_date': '2026-10-15',
            'mortality': 3,
            'culls': 0,
            'eggs_collected': 400,
            'feed_consumed_kg': 118.5,
          },
        ],
      },
    );

    expect(
      await repository.refreshDailyRecords(
        organisationId: 7,
        organisationSlug: 'ferme-demo',
      ),
      2,
    );

    final local = await repository.findRecord(3, '2026-10-14');
    expect(local?.eggsCollected, 500);
    expect(local?.clientUuid, 'local-uuid');

    final server = await repository.findRecord(3, '2026-10-15');
    expect(server?.serverId, 42);
    expect(server?.feedKg, 118.5);

    await repository.markRecordSynced('local-uuid', 41);
    expect((await repository.findRecord(3, '2026-10-14'))?.clientUuid, isNull);
    expect((await repository.findRecord(3, '2026-10-14'))?.serverId, 41);
  });

  testWidgets(
    'un relevé serveur du jour est pré-rempli, puis complété avec le drapeau merge et l\'écart de pertes',
    (tester) async {
      await FlockRepository(db: db, api: api).upsertLocalRecord(
        organisationId: 7,
        flockId: 3,
        recordDate: _today(),
        payload: const {'mortality': 3, 'culls': 0, 'eggs_collected': 400},
        clientUuid: null,
        serverId: 42,
      );

      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text('400'), findsOneWidget);
      expect(
        find.textContaining('Relevé déjà enregistré ce jour'),
        findsOneWidget,
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mortalité'),
        '5',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Œufs collectés'),
        '850',
      );
      await tester.scrollUntilVisible(
        find.text('Enregistrer le relevé'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer le relevé'));
      await tester.pumpAndSettle();

      final pending = await SyncQueueRepository(db: db, api: api).pending(7);
      final payload = decodePayload(pending.single.payload);
      expect(payload['merge'], isTrue);
      expect(payload['mortality'], 5);
      expect(payload['eggs_collected'], 850);

      // Seul l'écart de pertes (5 − 3) sort de l'effectif en cache
      final flock = await (db.select(
        db.cachedFlocks,
      )..where((f) => f.id.equals(3))).getSingle();
      expect(flock.quantityCurrent, 995);

      final cached = await FlockRepository(
        db: db,
        api: api,
      ).findRecord(3, _today());
      expect(cached?.eggsCollected, 850);
      expect(cached?.serverId, 42);
      expect(cached?.clientUuid, pending.single.clientUuid);

      await _unmount(tester);
    },
  );

  testWidgets(
    'deux saisies le même jour sur ce téléphone ne font qu\'une seule saisie en attente',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Œufs collectés'),
        '400',
      );
      await tester.scrollUntilVisible(
        find.text('Enregistrer le relevé'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer le relevé'));
      await tester.pumpAndSettle();

      // Première saisie bien conservée localement, une seule en attente
      final first = await SyncQueueRepository(db: db, api: api).pending(7);
      expect(first, hasLength(1));
      final firstCached = await FlockRepository(
        db: db,
        api: api,
      ).findRecord(3, _today());
      expect(firstCached?.eggsCollected, 400);
      expect(firstCached?.clientUuid, first.single.clientUuid);

      // Second passage le même jour : pré-rempli, la saisie en attente est remplacée
      await tester.pumpWidget(app(key: const ValueKey('second')));
      await tester.pumpAndSettle();
      expect(find.text('400'), findsOneWidget);
      expect(find.textContaining('sur ce téléphone'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Œufs collectés'),
        '850',
      );
      await tester.scrollUntilVisible(
        find.text('Enregistrer le relevé'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer le relevé'));
      await tester.pumpAndSettle();

      final pending = await SyncQueueRepository(db: db, api: api).pending(7);
      expect(pending, hasLength(1));
      expect(decodePayload(pending.single.payload)['eggs_collected'], 850);
      // Le drapeau reste posé : si la première saisie était partie entre-temps, le serveur complète
      expect(decodePayload(pending.single.payload)['merge'], isTrue);

      await _unmount(tester);
    },
  );
}
