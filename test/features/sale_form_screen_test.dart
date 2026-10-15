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
import 'package:gestavi_mobile/features/sales/sale_form_screen.dart';
import 'package:gestavi_mobile/features/sales/sale_repository.dart';
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
  permissions: const {'sales.create'},
);

void main() {
  late AppDatabase db;
  late _MockApi api;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    await db
        .into(db.cachedCustomers)
        .insert(
          const CachedCustomer(
            id: 4,
            organisationId: 7,
            name: 'Boulangerie du Plateau',
            code: null,
            phone: null,
          ),
        );
    await db
        .into(db.cachedProducts)
        .insert(
          const CachedProduct(
            id: 9,
            organisationId: 7,
            name: 'Plateau 30 œufs',
            unit: 'plateau',
            unitPrice: 2500,
            taxPercent: 0,
            stockUnitsPerUnit: 1,
            isLiveBirds: false,
          ),
        );
  });

  tearDown(() => db.close());

  Future<void> seedLiveBirds() async {
    await db
        .into(db.cachedProducts)
        .insert(
          const CachedProduct(
            id: 10,
            organisationId: 7,
            name: 'Poulet vif',
            unit: 'sujet',
            unitPrice: 3000,
            taxPercent: 0,
            stockUnitsPerUnit: 1,
            isLiveBirds: true,
          ),
        );
    await db
        .into(db.cachedFlocks)
        .insert(
          const CachedFlock(
            id: 3,
            organisationId: 7,
            farmId: 1,
            code: 'LOT-003',
            name: 'Chair',
            farmName: 'Ferme A',
            kind: 'broiler',
            tracksEggs: false,
            tracksWeight: true,
            quantityCurrent: 1000,
            ageDays: 40,
            lastRecordDate: null,
            status: 'active',
          ),
        );
  }

  Widget app() => ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      apiClientProvider.overrideWithValue(api),
      authControllerProvider.overrideWith(_ConnectedController.new),
    ],
    child: const MaterialApp(home: SaleFormScreen()),
  );

  testWidgets(
    'enregistre une vente hors-ligne avec le prix du catalogue et l\'encaissement',
    (tester) async {
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Pas de connexion'));

      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Client comptant'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Boulangerie du Plateau').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<int>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Plateau 30 œufs').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Quantité'),
        '50',
      );
      await tester.pumpAndSettle();

      expect(find.text('125 000 XOF'), findsWidgets);

      await tester.scrollUntilVisible(
        find.text('Enregistrer la vente'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer la vente'));
      await tester.pumpAndSettle();

      final queue = SyncQueueRepository(db: db, api: api);
      final pending = await queue.pending(7);
      final payload = decodeSalePayload(pending.single.payload);
      final item = (payload['items'] as List).single as Map<String, dynamic>;

      expect(pending.single.type, 'sale');
      expect(payload['farm_id'], 1);
      expect(payload['customer_id'], 4);
      expect(item['product_id'], 9);
      expect(item['quantity'], 50);
      expect(item['unit_price'], 2500);
      expect((payload['payment'] as Map)['method'], 'cash');

      // Lecture directe : un flux drift lu avec `.first` sous l'horloge simulée ne répond jamais
      final sales = await db.select(db.cachedSales).get();
      expect(sales.single.customerName, 'Boulangerie du Plateau');
      expect(sales.single.status, 'local');

      await unmount(tester);
    },
  );

  testWidgets(
    'un produit « sujets vivants » exige la bande vendue, puis l\'envoie dans la ligne',
    (tester) async {
      await seedLiveBirds();
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Pas de connexion'));

      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<int>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Poulet vif').last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Quantité'),
        '50',
      );
      await tester.pumpAndSettle();

      // Sans bande : refus
      await tester.scrollUntilVisible(
        find.text('Enregistrer la vente'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer la vente'));
      await tester.pumpAndSettle();
      expect(find.text('Bande obligatoire'), findsOneWidget);
      expect(await SyncQueueRepository(db: db, api: api).pending(7), isEmpty);

      // Avec la bande : la ligne la porte
      await tester.scrollUntilVisible(
        find.byType(DropdownButtonFormField<int>).at(1),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(DropdownButtonFormField<int>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('LOT-003').last);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Enregistrer la vente'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Enregistrer la vente'));
      await tester.pumpAndSettle();

      final pending = await SyncQueueRepository(db: db, api: api).pending(7);
      final item =
          (decodeSalePayload(pending.single.payload)['items'] as List).single
              as Map<String, dynamic>;
      expect(item['flock_id'], 3);
      expect(item['is_live_birds'], isTrue);

      final flock = await (db.select(
        db.cachedFlocks,
      )..where((f) => f.id.equals(3))).getSingle();
      expect(flock.quantityCurrent, 950);

      await unmount(tester);
    },
  );

  testWidgets('refuse une vente sans ligne remplie', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Enregistrer la vente'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Enregistrer la vente'));
    await tester.pumpAndSettle();

    expect(find.textContaining('au moins une ligne'), findsOneWidget);
    expect(await SyncQueueRepository(db: db, api: api).pending(7), isEmpty);
    verifyNever(() => api.post(any(), body: any(named: 'body')));

    await unmount(tester);
  });
}

/// Démonte l'arbre puis fait avancer l'horloge simulée : les flux Drift annulés à la fermeture
/// du ProviderScope programment un timer à zéro que le testeur refuse de laisser pendant.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 20));
}
