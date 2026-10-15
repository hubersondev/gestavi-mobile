import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:gestavi_mobile/features/sales/sale_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _serverSale(int id) => {
  'id': id,
  'invoice_number': 'FAC-2026-00$id',
  'farm_id': 1,
  'customer_id': 4,
  'customer': 'Boulangerie du Plateau',
  'sale_date': '2026-10-15',
  'status': 'paid',
  'total': 125000.0,
  'paid': 125000.0,
  'items': [
    {'quantity': 50.0, 'product_name': 'Plateau 30 œufs'},
  ],
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late SyncQueueRepository queue;
  late SaleRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    queue = SyncQueueRepository(db: db, api: api);
    repository = SaleRepository(db: db, api: api, queue: queue);
    queue.onSaleSynced = (organisationId, clientUuid, serverSale) =>
        repository.markSynced(
          organisationId: organisationId,
          clientUuid: clientUuid,
          serverSale: serverSale,
        );
  });

  tearDown(() => db.close());

  test('rafraîchit clients et produits depuis l\'API', () async {
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [
          {'id': 4, 'name': 'Boulangerie du Plateau', 'code': 'CLI-004'},
        ],
        'meta': {'last_page': 1},
      },
    );
    when(() => api.get('/organisations/ferme-demo/products')).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 9,
            'name': 'Plateau 30 œufs',
            'unit': 'plateau',
            'default_unit_price': 2500,
            'is_live_birds': false,
          },
        ],
      },
    );

    await repository.refreshReferentials(
      organisationId: 7,
      organisationSlug: 'ferme-demo',
    );

    final customers = await repository.watchCustomers(7).first;
    final products = await repository.watchProducts(7).first;

    expect(customers.single.name, 'Boulangerie du Plateau');
    expect(products.single.unitPrice, 2500);
    expect(products.single.unit, 'plateau');
  });

  test('une vente locale est mise en file avec son client_uuid et listée « local »', () async {
    final clientUuid = await repository.createSale(
      organisationId: 7,
      farmId: 1,
      saleDate: DateTime(2026, 10, 15),
      customerId: 4,
      customerName: 'Boulangerie du Plateau',
      lines: const [
        SaleLine(
          productId: 9,
          productName: 'Plateau 30 œufs',
          unit: 'plateau',
          quantity: 50,
          unitPrice: 2500,
        ),
      ],
      payment: const SalePayment(method: 'orange_money'),
    );

    final pending = await queue.pending(7);
    final payload = decodeSalePayload(pending.single.payload);

    expect(pending.single.type, 'sale');
    expect(pending.single.clientUuid, clientUuid);
    expect(payload['client_uuid'], clientUuid);
    expect(payload['farm_id'], 1);
    expect(payload['sale_date'], '2026-10-15');
    expect((payload['items'] as List).single['quantity'], 50);
    expect((payload['payment'] as Map)['method'], 'orange_money');
    expect((payload['payment'] as Map).containsKey('amount'), isFalse);

    final sales = await repository.watchSales(organisationId: 7).first;
    expect(sales.single.status, 'local');
    expect(sales.single.total, 125000);
    expect(sales.single.paid, 125000);
    expect(sales.single.key, 'c-$clientUuid');
  });

  test('la synchronisation envoie la vente sur POST /sales et le cache prend l\'identité serveur', () async {
    final clientUuid = await repository.createSale(
      organisationId: 7,
      farmId: 1,
      saleDate: DateTime(2026, 10, 15),
      lines: const [
        SaleLine(productName: 'Plateau 30 œufs', quantity: 50, unitPrice: 2500),
      ],
    );
    when(
      () =>
          api.post('/organisations/ferme-demo/sales', body: any(named: 'body')),
    ).thenAnswer((_) async => {'data': _serverSale(42)});

    expect(
      await queue.push(organisationId: 7, organisationSlug: 'ferme-demo'),
      1,
    );

    final sent =
        verify(
              () => api.post(
                '/organisations/ferme-demo/sales',
                body: captureAny(named: 'body'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(sent['client_uuid'], clientUuid);

    expect(await queue.pending(7), isEmpty);
    final sales = await repository.watchSales(organisationId: 7).first;
    expect(sales.single.key, 's-42');
    expect(sales.single.status, 'paid');
    expect(sales.single.invoiceNumber, 'FAC-2026-0042');
    expect(sales.single.summary, '50.0 Plateau 30 œufs');
  });

  test(
    'une vente refusée par l\'API reste visible en rejet, sans rejeu',
    () async {
      await repository.createSale(
        organisationId: 7,
        farmId: 1,
        saleDate: DateTime(2026, 10, 15),
        lines: const [
          SaleLine(productName: 'Sujets', quantity: 10, unitPrice: 3000),
        ],
      );
      when(() => api.post(any(), body: any(named: 'body')))
          .thenThrow(const ApiException('Stock insuffisant.', statusCode: 422));

      await queue.push(organisationId: 7, organisationSlug: 'ferme-demo');

      final rejected = await queue.rejected(7);
      expect(rejected.single.message, 'Stock insuffisant.');
      expect(await queue.pending(7), isEmpty);
      expect(
        (await repository.watchSales(organisationId: 7).first).single.status,
        'local',
      );
    },
  );

  test('sans réseau, la vente reste en attente et l\'erreur remonte', () async {
    await repository.createSale(
      organisationId: 7,
      farmId: 1,
      saleDate: DateTime(2026, 10, 15),
      lines: const [
        SaleLine(productName: 'Sujets', quantity: 10, unitPrice: 3000),
      ],
    );
    when(() => api.post(any(), body: any(named: 'body')))
        .thenThrow(const ApiException('Pas de connexion'));

    await expectLater(
      () => queue.push(organisationId: 7, organisationSlug: 'ferme-demo'),
      throwsA(isA<ApiException>()),
    );
    expect(
      await queue.pushQuietly(
        organisationId: 7,
        organisationSlug: 'ferme-demo',
      ),
      0,
    );
    expect((await queue.pending(7)).length, 1);
  });

  test(
    'refreshSales remplace les ventes serveur et conserve les locales',
    () async {
      await repository.createSale(
        organisationId: 7,
        farmId: 1,
        saleDate: DateTime(2026, 10, 15),
        lines: const [
          SaleLine(productName: 'Sujets', quantity: 10, unitPrice: 3000),
        ],
      );
      when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
        (_) async => {
          'data': [_serverSale(1), _serverSale(2)],
        },
      );

      expect(
        await repository.refreshSales(
          organisationId: 7,
          organisationSlug: 'ferme-demo',
        ),
        2,
      );

      final sales = await repository.watchSales(organisationId: 7).first;
      expect(sales.length, 3);
      expect(sales.where((s) => s.status == 'local').length, 1);
    },
  );

  test('formatXof groupe les milliers', () {
    expect(formatXof(1250000), '1 250 000 XOF');
    expect(formatXof(999), '999 XOF');
  });
}
