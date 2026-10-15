import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:gestavi_mobile/features/sales/sale_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _serverSale({
  required double paid,
  required String status,
}) => {
  'id': 42,
  'invoice_number': 'FAC-2026-00042',
  'farm_id': 1,
  'customer': 'Maquis Chez Tantie',
  'sale_date': '2026-10-15',
  'status': status,
  'total': 30000.0,
  'paid': paid,
  'items': [
    {'quantity': 10.0, 'product_name': 'Plateau'},
  ],
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late SyncQueueRepository queue;
  late SaleRepository repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    queue = SyncQueueRepository(db: db, api: api);
    repository = SaleRepository(db: db, api: api, queue: queue);
    queue.onSynced['sale_payment'] = (organisationId, clientUuid, response) =>
        repository.applyServerSale(
          organisationId,
          response['data'] as Map<String, dynamic>,
        );
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [_serverSale(paid: 0, status: 'pending')],
      },
    );
    await repository.refreshSales(
      organisationId: 7,
      organisationSlug: 'ferme-demo',
    );
  });

  tearDown(() => db.close());

  test('un encaissement partiel passe en file et la vente locale devient « partielle »', () async {
    final sale = (await repository.watchSales(organisationId: 7).first).single;

    final clientUuid = await repository.recordPayment(
      organisationId: 7,
      sale: sale,
      amount: 10000,
      method: 'wave',
      paidAt: DateTime(2026, 10, 15),
    );

    final pending = await queue.pending(7);
    final payload = decodePayload(pending.single.payload);
    expect(pending.single.type, 'sale_payment');
    expect(payload['client_uuid'], clientUuid);
    expect(payload['sale_id'], 42);
    expect(payload['amount'], 10000);
    expect(payload['method'], 'wave');
    expect(payload['paid_at'], '2026-10-15');
    expect(
      SyncQueueRepository.endpointFor('sale_payment', payload),
      '/sales/42/payments',
    );

    final updated =
        (await repository.watchSales(organisationId: 7).first).single;
    expect(updated.paid, 10000);
    expect(updated.status, 'partial');
  });

  test(
    'le solde complet passe la vente en « payée » et le serveur confirme',
    () async {
      final sale =
          (await repository.watchSales(organisationId: 7).first).single;
      await repository.recordPayment(
        organisationId: 7,
        sale: sale,
        amount: 30000,
        method: 'cash',
      );
      expect(
        (await repository.watchSales(organisationId: 7).first).single.status,
        'paid',
      );

      when(
        () => api.post(
          '/organisations/ferme-demo/sales/42/payments',
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => {'data': _serverSale(paid: 30000, status: 'paid')},
      );

      expect(
        await queue.push(organisationId: 7, organisationSlug: 'ferme-demo'),
        1,
      );
      expect(await queue.pending(7), isEmpty);
      final synced =
          (await repository.watchSales(organisationId: 7).first).single;
      expect(synced.paid, 30000);
      expect(synced.status, 'paid');
    },
  );

  test(
    'une vente locale non synchronisée ne peut pas être encaissée',
    () async {
      await repository.createSale(
        organisationId: 7,
        farmId: 1,
        saleDate: DateTime(2026, 10, 15),
        lines: const [
          SaleLine(productName: 'Plateau', quantity: 1, unitPrice: 3000),
        ],
      );
      final local = (await repository.watchSales(organisationId: 7).first)
          .firstWhere((s) => s.status == 'local');

      await expectLater(
        () => repository.recordPayment(
          organisationId: 7,
          sale: local,
          amount: 1000,
          method: 'cash',
        ),
        throwsA(isA<StateError>()),
      );
    },
  );
}
