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
import 'package:gestavi_mobile/features/stocks/stock_repository.dart';
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

const _trays = CachedProduct(
  id: 9,
  organisationId: 7,
  name: 'Plateau de 30 œufs',
  unit: 'plateau',
  unitPrice: 3000,
  taxPercent: 0,
  isLiveBirds: false,
  stockKind: 'eggs',
  stockId: null,
  stockUnitsPerUnit: 30,
);

const _eggStock = CachedStock(
  id: 4,
  organisationId: 7,
  farmId: 1,
  name: 'Œufs',
  category: 'Production',
  unit: 'œuf',
  quantity: 75,
  minQuantity: 0,
  kind: 'eggs',
);

void main() {
  test(
    'le stock suivi d’un produit se résout et donne la quantité vendable',
    () {
      const otherFarmEggs = CachedStock(
        id: 5,
        organisationId: 7,
        farmId: 2,
        name: 'Œufs',
        category: null,
        unit: 'œuf',
        quantity: 900,
        minQuantity: 0,
        kind: 'eggs',
      );

      expect(trackedStockFor(_trays, 1, [otherFarmEggs, _eggStock])?.id, 4);
      expect(trackedStockFor(_trays, 3, [_eggStock]), isNull);
      expect(sellableQuantity(_trays, _eggStock), 2);

      const dressed = CachedProduct(
        id: 10,
        organisationId: 7,
        name: 'Poulet abattu',
        unit: 'kg',
        unitPrice: 2500,
        taxPercent: 0,
        isLiveBirds: false,
        stockKind: null,
        stockId: 8,
        stockUnitsPerUnit: 1,
      );
      const carcasses = CachedStock(
        id: 8,
        organisationId: 7,
        farmId: 1,
        name: 'Carcasses',
        category: null,
        unit: 'kg',
        quantity: 12.345,
        minQuantity: 0,
        kind: null,
      );
      expect(trackedStockFor(dressed, 1, [carcasses])?.id, 8);
      expect(sellableQuantity(dressed, carcasses), 12.34);
    },
  );

  group('formulaire de vente', () {
    late AppDatabase db;
    late _MockApi api;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      api = _MockApi();
      await db.into(db.cachedProducts).insert(_trays);
      await db.into(db.cachedStocks).insert(_eggStock);
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Pas de connexion'));
    });

    tearDown(() => db.close());

    Widget app() => ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        apiClientProvider.overrideWithValue(api),
        authControllerProvider.overrideWith(_ConnectedController.new),
      ],
      child: const MaterialApp(home: SaleFormScreen()),
    );

    testWidgets(
      'affiche le disponible en plateaux et refuse une vente au-delà du stock d’œufs',
      (tester) async {
        await tester.pumpWidget(app());
        await tester.pumpAndSettle();

        await tester.tap(find.byType(DropdownButtonFormField<int>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Plateau de 30 œufs').last);
        await tester.pumpAndSettle();

        expect(find.text('En stock : 2 plateau'), findsOneWidget);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Quantité'),
          '3',
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Stock insuffisant : 2 plateau disponible(s)'),
          findsOneWidget,
        );

        await tester.scrollUntilVisible(
          find.text('Enregistrer la vente'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Enregistrer la vente'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Stock insuffisant pour'), findsOneWidget);
        expect(await SyncQueueRepository(db: db, api: api).pending(7), isEmpty);

        // Dans la limite du stock, la vente passe
        await tester.scrollUntilVisible(
          find.widgetWithText(TextFormField, 'Quantité'),
          -200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Quantité'),
          '2',
        );
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Enregistrer la vente'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Enregistrer la vente'));
        await tester.pumpAndSettle();

        expect(
          (await SyncQueueRepository(db: db, api: api).pending(7)).length,
          1,
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 20));
      },
    );
  });
}
