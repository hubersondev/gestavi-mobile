import 'dart:convert';

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
  quantityCurrent: 1000,
  ageDays: 120,
  lastRecordDate: null,
  status: 'active',
);

void main() {
  late AppDatabase db;
  late _MockApi api;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    await db.into(db.cachedFlocks).insert(_flock);
  });

  tearDown(() => db.close());

  Widget app() => ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      apiClientProvider.overrideWithValue(api),
      authControllerProvider.overrideWith(_ConnectedController.new),
    ],
    child: const MaterialApp(home: DailyRecordScreen(flock: _flock)),
  );

  testWidgets(
    'enregistre le relevé hors-ligne : file d\'attente et cache de la bande mis à jour',
    (tester) async {
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Pas de connexion'));

      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mortalité'),
        '4',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Réformes'),
        '1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Œufs collectés'),
        '850',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Aliment (kg)'),
        '118,5',
      );
      await tester.scrollUntilVisible(
        find.text('Enregistrer le relevé'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer le relevé'));
      await tester.pumpAndSettle();

      final queue = SyncQueueRepository(db: db, api: api);
      final pending = await queue.pending(7);
      final payload =
          jsonDecode(pending.single.payload) as Map<String, dynamic>;

      expect(pending.single.type, 'daily_record');
      expect(payload['flock_id'], 3);
      expect(payload['mortality'], 4);
      expect(payload['culls'], 1);
      expect(payload['eggs_collected'], 850);
      expect(payload['feed_consumed_kg'], 118.5);
      expect(payload.containsKey('average_weight_g'), isFalse);
      expect(payload['record_date'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));

      final cached = await FlockRepository(db: db, api: api).find(3);
      expect(cached?.quantityCurrent, 995);
      expect(cached?.lastRecordDate, payload['record_date']);
    },
  );

  testWidgets(
    'refuse des pertes supérieures à l\'effectif sans rien enregistrer',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mortalité'),
        '1200',
      );
      await tester.scrollUntilVisible(
        find.text('Enregistrer le relevé'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer le relevé'));
      await tester.pumpAndSettle();

      expect(find.textContaining('supérieures à l\'effectif'), findsOneWidget);
      expect(await SyncQueueRepository(db: db, api: api).pending(7), isEmpty);
      verifyNever(() => api.post(any(), body: any(named: 'body')));
    },
  );
}
