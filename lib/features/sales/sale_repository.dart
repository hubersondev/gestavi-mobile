import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';

/// Ventes depuis le mobile : clients et produits en cache pour saisir sans réseau, ventes récentes
/// rafraîchies depuis l'API, et ventes locales en attente d'envoi (POST /sales idempotent).
class SaleRepository {
  SaleRepository({
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

  // ─── Référentiels ───────────────────────────────────────────────────────

  Stream<List<CachedCustomer>> watchCustomers(int organisationId) =>
      (_db.select(_db.cachedCustomers)
            ..where((c) => c.organisationId.equals(organisationId))
            ..orderBy([(c) => OrderingTerm.asc(c.name)]))
          .watch();

  Stream<List<CachedProduct>> watchProducts(int organisationId) =>
      (_db.select(_db.cachedProducts)
            ..where((p) => p.organisationId.equals(organisationId))
            ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  /// Recharge clients et produits depuis l'API (toutes les pages de clients).
  Future<void> refreshReferentials({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final customers = <CachedCustomersCompanion>[];
    var page = 1;

    while (true) {
      final response = await _api.get(
        '/organisations/$organisationSlug/customers',
        query: {'per_page': 500, 'page': page},
      );

      for (final item
          in (response['data'] as List<dynamic>).cast<Map<String, dynamic>>()) {
        customers.add(
          CachedCustomersCompanion.insert(
            id: Value(item['id'] as int),
            organisationId: organisationId,
            name: item['name'] as String,
            code: Value(item['code'] as String?),
            phone: Value(item['phone'] as String?),
          ),
        );
      }

      final lastPage =
          ((response['meta'] as Map<String, dynamic>?)?['last_page'] as int?) ??
          1;

      if (page >= lastPage) {
        break;
      }

      page++;
    }

    final productsResponse = await _api.get(
      '/organisations/$organisationSlug/products',
    );
    final products = (productsResponse['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(
          (item) => CachedProductsCompanion.insert(
            id: Value(item['id'] as int),
            organisationId: organisationId,
            name: item['name'] as String,
            unit: Value(item['unit'] as String?),
            unitPrice: Value(
              (item['default_unit_price'] as num?)?.toDouble() ?? 0,
            ),
            taxPercent: Value(
              (item['default_tax_percent'] as num?)?.toDouble() ?? 0,
            ),
            isLiveBirds: Value(item['is_live_birds'] as bool? ?? false),
            stockKind: Value(item['stock_kind'] as String?),
            stockId: Value(item['stock_id'] as int?),
            stockUnitsPerUnit: Value(
              (item['stock_units_per_unit'] as num?)?.toDouble() ?? 1,
            ),
          ),
        )
        .toList();

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedCustomers,
      )..where((c) => c.organisationId.equals(organisationId))).go();
      await (_db.delete(
        _db.cachedProducts,
      )..where((p) => p.organisationId.equals(organisationId))).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.cachedCustomers,
          customers,
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.cachedProducts,
          products,
          mode: InsertMode.insertOrReplace,
        );
      });
    });
  }

  // ─── Ventes ─────────────────────────────────────────────────────────────

  Stream<List<CachedSale>> watchSales({
    required int organisationId,
    int? farmId,
  }) {
    final query = _db.select(_db.cachedSales)
      ..where((s) => s.organisationId.equals(organisationId))
      ..orderBy([
        (s) => OrderingTerm.desc(s.saleDate),
        (s) => OrderingTerm.desc(s.updatedAt),
      ])
      ..limit(200);

    if (farmId != null) {
      query.where((s) => s.farmId.equals(farmId));
    }

    return query.watch();
  }

  /// Ventes récentes depuis l'API (les ventes locales en attente sont conservées).
  Future<int> refreshSales({
    required int organisationId,
    required String organisationSlug,
  }) async {
    final response = await _api.get(
      '/organisations/$organisationSlug/sales',
      query: {'per_page': 100},
    );
    final rows = (response['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((item) => _serverSale(organisationId, item))
        .toList();

    await _db.transaction(() async {
      await (_db.delete(_db.cachedSales)..where(
            (s) =>
                s.organisationId.equals(organisationId) &
                s.serverId.isNotNull(),
          ))
          .go();
      await _db.batch(
        (batch) => batch.insertAll(
          _db.cachedSales,
          rows,
          mode: InsertMode.insertOrReplace,
        ),
      );
    });

    return rows.length;
  }

  /// Enregistre une vente localement et la met en file d'envoi. Retourne son identifiant client.
  Future<String> createSale({
    required int organisationId,
    required int farmId,
    required DateTime saleDate,
    int? customerId,
    String? customerName,
    required List<SaleLine> lines,
    double taxPercent = 0,
    SalePayment? payment,
    String? notes,
  }) async {
    final clientUuid = _uuid.v4();
    final subtotal = lines.fold<double>(
      0,
      (sum, line) => sum + line.quantity * line.unitPrice,
    );
    final total = subtotal * (1 + taxPercent / 100);

    final payload = <String, dynamic>{
      'client_uuid': clientUuid,
      'farm_id': farmId,
      'customer_id': customerId,
      'sale_date': _iso(saleDate),
      'tax_percent': taxPercent,
      'notes': notes,
      'items': lines
          .map(
            (line) => {
              'product_id': line.productId,
              'product_name': line.productName,
              'unit': line.unit,
              'quantity': line.quantity,
              'unit_price': line.unitPrice,
              'flock_id': line.flockId,
              'is_live_birds': line.isLiveBirds,
            }..removeWhere((_, value) => value == null),
          )
          .toList(),
      'payment': payment == null
          ? null
          : (<String, dynamic>{
              'method': payment.method,
              'amount': payment.amount,
              'account_id': payment.accountId,
            }..removeWhere((_, value) => value == null)),
    }..removeWhere((_, value) => value == null);

    await _queue.enqueue(
      organisationId: organisationId,
      type: 'sale',
      payload: payload,
      recordedAt: DateTime.now(),
      clientUuid: clientUuid,
    );

    // Les sujets vivants vendus sortent aussitôt de l'effectif en cache de leur bande
    for (final line in lines.where((l) => l.isLiveBirds && l.flockId != null)) {
      final flock = await (_db.select(
        _db.cachedFlocks,
      )..where((f) => f.id.equals(line.flockId!))).getSingleOrNull();

      if (flock != null) {
        await (_db.update(
          _db.cachedFlocks,
        )..where((f) => f.id.equals(flock.id))).write(
          CachedFlocksCompanion(
            quantityCurrent: Value(
              (flock.quantityCurrent - line.quantity.round()).clamp(
                0,
                flock.quantityCurrent,
              ),
            ),
          ),
        );
      }
    }

    await _db
        .into(_db.cachedSales)
        .insertOnConflictUpdate(
          CachedSalesCompanion.insert(
            key: 'c-$clientUuid',
            organisationId: organisationId,
            farmId: Value(farmId),
            clientUuid: Value(clientUuid),
            saleDate: _iso(saleDate),
            customerName: Value(customerName),
            total: Value(total),
            paid: Value(payment == null ? 0 : (payment.amount ?? total)),
            status: 'local',
            summary: Value(lines.map((l) => l.label).join(', ')),
            updatedAt: DateTime.now(),
          ),
        );

    return clientUuid;
  }

  /// Encaissement d'une vente déjà synchronisée : file (POST /sales/{id}/payments, idempotent)
  /// puis montant reçu reflété localement. Retourne l'identifiant client.
  Future<String> recordPayment({
    required int organisationId,
    required CachedSale sale,
    required double amount,
    required String method,
    DateTime? paidAt,
  }) async {
    final saleId = sale.serverId;

    if (saleId == null) {
      throw StateError(
        'Une vente non synchronisée ne peut pas être encaissée.',
      );
    }

    final clientUuid = _uuid.v4();
    final date = paidAt ?? DateTime.now();

    await _queue.enqueue(
      organisationId: organisationId,
      type: 'sale_payment',
      payload: {
        'client_uuid': clientUuid,
        'sale_id': saleId,
        'amount': amount,
        'method': method,
        'paid_at': _iso(date),
      },
      recordedAt: date,
      clientUuid: clientUuid,
    );

    final paid = sale.paid + amount;
    await (_db.update(
      _db.cachedSales,
    )..where((s) => s.key.equals(sale.key))).write(
      CachedSalesCompanion(
        paid: Value(paid),
        status: Value(paid >= sale.total - 0.01 ? 'paid' : 'partial'),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return clientUuid;
  }

  /// La vente renvoyée par le serveur remplace la version en cache.
  Future<void> applyServerSale(
    int organisationId,
    Map<String, dynamic> serverSale,
  ) => _db
      .into(_db.cachedSales)
      .insertOnConflictUpdate(_serverSale(organisationId, serverSale));

  /// Après synchronisation, la vente locale prend l'identité du serveur.
  Future<void> markSynced({
    required String clientUuid,
    required Map<String, dynamic> serverSale,
    required int organisationId,
  }) async {
    await (_db.delete(
      _db.cachedSales,
    )..where((s) => s.key.equals('c-$clientUuid'))).go();
    await _db
        .into(_db.cachedSales)
        .insertOnConflictUpdate(_serverSale(organisationId, serverSale));
  }

  CachedSalesCompanion _serverSale(
    int organisationId,
    Map<String, dynamic> item,
  ) => CachedSalesCompanion.insert(
    key: 's-${item['id']}',
    organisationId: organisationId,
    farmId: Value(item['farm_id'] as int?),
    serverId: Value(item['id'] as int),
    invoiceNumber: Value(item['invoice_number'] as String?),
    saleDate: item['sale_date'] as String,
    customerName: Value(item['customer'] as String?),
    total: Value((item['total'] as num?)?.toDouble() ?? 0),
    paid: Value((item['paid'] as num?)?.toDouble() ?? 0),
    status: item['status'] as String? ?? 'pending',
    summary: Value(
      (item['items'] as List<dynamic>?)
          ?.cast<Map<String, dynamic>>()
          .map((i) => '${i['quantity']} ${i['product_name']}')
          .join(', '),
    ),
    updatedAt: DateTime.now(),
  );

  static String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Ligne d'une vente en cours de saisie.
class SaleLine {
  const SaleLine({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.productId,
    this.unit,
    this.flockId,
    this.isLiveBirds = false,
  });

  final int? productId;
  final String productName;
  final String? unit;
  final double quantity;
  final double unitPrice;
  final int? flockId;
  final bool isLiveBirds;

  double get total => quantity * unitPrice;

  String get label =>
      '${quantity % 1 == 0 ? quantity.toInt() : quantity} ${unit ?? ''} $productName'
          .replaceAll('  ', ' ')
          .trim();
}

/// Encaissement immédiat d'une vente.
class SalePayment {
  const SalePayment({required this.method, this.amount, this.accountId});

  final String method;
  final double? amount;
  final int? accountId;
}

/// Modes de paiement de l'API, avec leur libellé.
const salePaymentMethods = <String, String>{
  'cash': 'Espèces',
  'orange_money': 'Orange Money',
  'mtn_momo': 'MTN MoMo',
  'moov_money': 'Moov Money',
  'wave': 'Wave',
  'bank_transfer': 'Virement',
  'cheque': 'Chèque',
};

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  final queue = ref.watch(syncQueueProvider);
  final repository = SaleRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
    queue: queue,
  );

  // Une vente envoyée avec succès prend aussitôt son identité serveur dans le cache
  queue.onSynced['sale'] = (organisationId, clientUuid, response) =>
      repository.markSynced(
        organisationId: organisationId,
        clientUuid: clientUuid,
        serverSale: response['data'] as Map<String, dynamic>? ?? response,
      );
  queue.onSynced['sale_payment'] = (organisationId, clientUuid, response) =>
      repository.applyServerSale(
        organisationId,
        response['data'] as Map<String, dynamic>? ?? response,
      );

  return repository;
});

/// Libellé d'un statut de vente de l'API (ou « À envoyer » pour une vente locale).
String saleStatusLabel(String status) => switch (status) {
  'local' => 'À envoyer',
  'draft' => 'Brouillon',
  'pending' => 'En attente',
  'partial' => 'Partiellement payée',
  'paid' => 'Payée',
  'cancelled' => 'Annulée',
  _ => status,
};

final customersProvider = StreamProvider.family<List<CachedCustomer>, int>(
  (ref, organisationId) =>
      ref.watch(saleRepositoryProvider).watchCustomers(organisationId),
);

final productsProvider = StreamProvider.family<List<CachedProduct>, int>(
  (ref, organisationId) =>
      ref.watch(saleRepositoryProvider).watchProducts(organisationId),
);

final salesProvider =
    StreamProvider.family<
      List<CachedSale>,
      ({int organisationId, int? farmId})
    >(
      (ref, scope) => ref
          .watch(saleRepositoryProvider)
          .watchSales(
            organisationId: scope.organisationId,
            farmId: scope.farmId,
          ),
    );

/// Montant XOF lisible : 1 250 000.
String formatXof(double value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < rounded.length; i++) {
    if (i > 0 && (rounded.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(rounded[i]);
  }

  return '$buffer XOF';
}

/// Décodage d'un corps JSON de vente conservé dans la file.
Map<String, dynamic> decodeSalePayload(String payload) =>
    jsonDecode(payload) as Map<String, dynamic>;
