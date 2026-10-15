import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';

/// Stocks des fermes accessibles, en cache pour consulter et saisir une sortie sans réseau.
/// Un mouvement part dans la file (POST /stock-movements, idempotent) et le niveau local est
/// ajusté aussitôt ; la réponse du serveur remet ensuite la quantité exacte.
class StockRepository {
  StockRepository({
    required AppDatabase db,
    required ApiClient api,
    required SyncQueueRepository queue,
    Uuid? uuid,
  }) : _db = db,
       _api = api,
       _queue = queue,
       _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final ApiClient _api;
  final SyncQueueRepository _queue;
  final Uuid _uuid;

  Stream<List<CachedStock>> watch({required int organisationId, int? farmId}) {
    final query = _db.select(_db.cachedStocks)
      ..where((s) => s.organisationId.equals(organisationId))
      ..orderBy([(s) => OrderingTerm.asc(s.name)]);

    if (farmId != null) {
      query.where((s) => s.farmId.equals(farmId));
    }

    return query.watch();
  }

  Future<CachedStock?> find(int id) => (_db.select(
    _db.cachedStocks,
  )..where((s) => s.id.equals(id))).getSingleOrNull();

  /// Recharge tous les stocks actifs depuis l'API, page par page.
  Future<int> refresh({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final rows = <CachedStocksCompanion>[];
    var page = 1;

    while (true) {
      final response = await _api.get(
        '/organisations/$organisationSlug/stocks',
        query: {'per_page': 500, 'page': page},
      );

      for (final item
          in (response['data'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        rows.add(_fromServer(organisationId, item));
      }

      final lastPage =
          ((response['meta'] as Map<String, dynamic>?)?['last_page'] as int?) ??
          1;

      if (page >= lastPage) {
        break;
      }

      page++;
    }

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedStocks,
      )..where((s) => s.organisationId.equals(organisationId))).go();
      await _db.batch(
        (batch) => batch.insertAll(
          _db.cachedStocks,
          rows,
          mode: InsertMode.insertOrReplace,
        ),
      );
    });

    return rows.length;
  }

  /// Met un mouvement en file et ajuste le niveau local. Retourne l'identifiant client.
  Future<String> recordMovement({
    required int organisationId,
    required CachedStock stock,
    required bool isOut,
    required double quantity,
    String? reason,
    int? flockId,
    String? notes,
  }) async {
    final clientUuid = _uuid.v4();
    final payload = <String, dynamic>{
      'client_uuid': clientUuid,
      'stock_id': stock.id,
      'direction': isOut ? 'out' : 'in',
      'quantity': quantity,
      'reason': reason,
      'flock_id': flockId,
      'notes': notes,
    }..removeWhere((_, value) => value == null);

    await _queue.enqueue(
      organisationId: organisationId,
      type: 'stock_movement',
      payload: payload,
      recordedAt: DateTime.now(),
      clientUuid: clientUuid,
    );

    final delta = isOut ? -quantity : quantity;
    await (_db.update(
      _db.cachedStocks,
    )..where((s) => s.id.equals(stock.id))).write(
      CachedStocksCompanion(
        quantity: Value((stock.quantity + delta).clamp(0, double.infinity)),
      ),
    );

    return clientUuid;
  }

  /// Après synchronisation, le niveau renvoyé par le serveur fait foi.
  Future<void> applyServerStock(
    int organisationId,
    Map<String, dynamic> stock,
  ) => _db
      .into(_db.cachedStocks)
      .insertOnConflictUpdate(_fromServer(organisationId, stock));

  CachedStocksCompanion _fromServer(
    int organisationId,
    Map<String, dynamic> item,
  ) => CachedStocksCompanion.insert(
    id: Value(item['id'] as int),
    organisationId: organisationId,
    farmId: Value(item['farm_id'] as int?),
    name: item['name'] as String,
    category: Value(item['category'] as String?),
    unit: item['unit'] as String? ?? '',
    quantity: Value((item['quantity'] as num?)?.toDouble() ?? 0),
    minQuantity: Value((item['min_quantity'] as num?)?.toDouble() ?? 0),
  );
}

/// Motifs de mouvement de l'API, par sens.
const stockOutReasons = <String, String>{
  'consumption': 'Consommation',
  'loss': 'Perte / Casse',
  'sale': 'Vente',
  'transfer_out': 'Transfert sortant',
  'adjustment': 'Ajustement',
};

const stockInReasons = <String, String>{
  'purchase': 'Achat',
  'return': 'Retour',
  'transfer_in': 'Transfert entrant',
  'adjustment': 'Ajustement',
};

final stockRepositoryProvider = Provider<StockRepository>((ref) {
  final queue = ref.watch(syncQueueProvider);
  final repository = StockRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
    queue: queue,
  );

  queue.onSynced['stock_movement'] = (organisationId, clientUuid, response) {
    final stock = response['stock'] as Map<String, dynamic>?;

    return stock == null
        ? Future.value()
        : repository.applyServerStock(organisationId, stock);
  };

  return repository;
});

final stocksProvider =
    StreamProvider.family<
      List<CachedStock>,
      ({int organisationId, int? farmId})
    >(
      (ref, scope) => ref
          .watch(stockRepositoryProvider)
          .watch(organisationId: scope.organisationId, farmId: scope.farmId),
    );

/// Quantité lisible : 12, 12,5 ou 1 250.
String formatQuantity(double value) {
  final whole = value.truncate();
  final digits = whole.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(digits[i]);
  }

  final fraction = (value.abs() - whole.abs());

  if (fraction >= 0.005) {
    buffer.write(',${(fraction * 100).round().toString().padLeft(2, '0')}');
  }

  return buffer.toString();
}
