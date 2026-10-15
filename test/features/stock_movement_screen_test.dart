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
import 'package:gestavi_mobile/features/stocks/stock_movement_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

/// Session connectée sur la ferme 1, sans réseau ni stockage.
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
  permissions: const {'stocks.record_movement'},
);

const _stock = CachedStock(
  id: 5,
  organisationId: 7,
  farmId: 1,
  name: 'Aliment ponte',
  category: 'Aliment',
  unit: 'kg',
  quantity: 500,
  minQuantity: 100,
);

void main() {
  late AppDatabase db;
  late _MockApi api;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    await db.into(db.cachedStocks).insert(_stock);
  });

  tearDown(() => db.close());

  Widget app() => ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      apiClientProvider.overrideWithValue(api),
      authControllerProvider.overrideWith(_ConnectedController.new),
    ],
    child: const MaterialApp(home: StockMovementScreen(stock: _stock)),
  );

  testWidgets('enregistre une sortie hors-ligne et décrémente le niveau', (
    tester,
  ) async {
    when(() => api.post(any(), body: any(named: 'body')))
        .thenThrow(const ApiException('Pas de connexion'));

    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quantité'),
      '118,5',
    );
    await tester.tap(find.text('Enregistrer la sortie'));
    await tester.pumpAndSettle();

    final pending = await SyncQueueRepository(db: db, api: api).pending(7);
    final payload = jsonDecode(pending.single.payload) as Map<String, dynamic>;

    expect(pending.single.type, 'stock_movement');
    expect(payload['stock_id'], 5);
    expect(payload['direction'], 'out');
    expect(payload['quantity'], 118.5);
    expect(payload['reason'], 'consumption');

    final cached = await (db.select(
      db.cachedStocks,
    )..where((s) => s.id.equals(5))).getSingle();
    expect(cached.quantity, 381.5);

    await unmount(tester);
  });

  testWidgets('refuse une sortie supérieure au stock', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Quantité'),
      '600',
    );
    await tester.tap(find.text('Enregistrer la sortie'));
    await tester.pumpAndSettle();

    expect(find.textContaining('supérieure au stock'), findsOneWidget);
    expect(await SyncQueueRepository(db: db, api: api).pending(7), isEmpty);
    verifyNever(() => api.post(any(), body: any(named: 'body')));

    await unmount(tester);
  });
}

/// Démonte l'arbre puis fait avancer l'horloge simulée pour laisser les flux drift se fermer.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 20));
}
