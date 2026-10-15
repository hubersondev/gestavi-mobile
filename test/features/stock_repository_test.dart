import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/core/sync/sync_queue.dart';
import 'package:gestavi_mobile/features/stocks/stock_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

Map<String, dynamic> _stock(int id, {double quantity = 500, int farmId = 1}) =>
    {
      'id': id,
      'code': 'ALI-00$id',
      'name': 'Aliment ponte $id',
      'farm_id': farmId,
      'category': 'Aliment',
      'unit': 'kg',
      'quantity': quantity,
      'min_quantity': 100.0,
    };

void main() {
  late AppDatabase db;
  late _MockApi api;
  late SyncQueueRepository queue;
  late StockRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    queue = SyncQueueRepository(db: db, api: api);
    repository = StockRepository(db: db, api: api, queue: queue);
    queue.onSynced['stock_movement'] = (organisationId, clientUuid, response) =>
        repository.applyServerStock(
          organisationId,
          response['stock'] as Map<String, dynamic>,
        );
    when(() => api.get(any(), query: any(named: 'query'))).thenAnswer(
      (_) async => {
        'data': [_stock(1), _stock(2, farmId: 2, quantity: 50)],
        'meta': {'last_page': 1},
      },
    );
  });

  tearDown(() => db.close());

  test('rafraîchit le cache et le relit par ferme', () async {
    expect(
      await repository.refresh(
        organisationId: 7,
        organisationSlug: 'ferme-demo',
      ),
      2,
    );

    final all = await repository.watch(organisationId: 7).first;
    final farmTwo = await repository.watch(organisationId: 7, farmId: 2).first;

    expect(all.map((s) => s.name), ['Aliment ponte 1', 'Aliment ponte 2']);
    expect(farmTwo.single.quantity, 50);
    expect(farmTwo.single.minQuantity, 100);
  });

  test('une sortie locale décrémente le niveau et part dans la file', () async {
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    final stock = (await repository.find(1))!;

    final clientUuid = await repository.recordMovement(
      organisationId: 7,
      stock: stock,
      isOut: true,
      quantity: 118.5,
      reason: 'consumption',
      flockId: 3,
    );

    expect((await repository.find(1))?.quantity, 381.5);

    final pending = await queue.pending(7);
    final payload = jsonDecode(pending.single.payload) as Map<String, dynamic>;
    expect(pending.single.type, 'stock_movement');
    expect(pending.single.clientUuid, clientUuid);
    expect(payload['stock_id'], 1);
    expect(payload['direction'], 'out');
    expect(payload['quantity'], 118.5);
    expect(payload['reason'], 'consumption');
    expect(payload['flock_id'], 3);
    expect(payload.containsKey('notes'), isFalse);
  });

  test('la synchronisation envoie sur POST /stock-movements et reprend le niveau du serveur', () async {
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    final stock = (await repository.find(1))!;
    await repository.recordMovement(
      organisationId: 7,
      stock: stock,
      isOut: true,
      quantity: 100,
    );
    when(
      () => api.post(
        '/organisations/ferme-demo/stock-movements',
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => {
        'status': 'created',
        'movement_id': 88,
        'stock': _stock(1, quantity: 397),
      },
    );

    expect(
      await queue.push(organisationId: 7, organisationSlug: 'ferme-demo'),
      1,
    );

    expect(await queue.pending(7), isEmpty);
    expect((await repository.find(1))?.quantity, 397);
    final row = await (db.select(db.syncQueue)).getSingle();
    expect(row.status, 'created');
    expect(row.subjectId, 88);
  });

  test('un mouvement refusé reste en rejet avec son message', () async {
    await repository.refresh(organisationId: 7, organisationSlug: 'ferme-demo');
    await repository.recordMovement(
      organisationId: 7,
      stock: (await repository.find(1))!,
      isOut: true,
      quantity: 100,
    );
    when(() => api.post(any(), body: any(named: 'body')))
        .thenThrow(const ApiException('Stock insuffisant.', statusCode: 422));

    await queue.push(organisationId: 7, organisationSlug: 'ferme-demo');

    expect((await queue.rejected(7)).single.message, 'Stock insuffisant.');
    expect(await queue.pending(7), isEmpty);
  });

  test('formatQuantity', () {
    expect(formatQuantity(1250), '1 250');
    expect(formatQuantity(12.5), '12,50');
    expect(formatQuantity(0), '0');
  });
}
