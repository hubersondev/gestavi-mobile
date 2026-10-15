import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

/// Saisies faites sur le téléphone en attente d'envoi : chacune porte un identifiant unique
/// généré localement, que l'API utilise pour ne jamais créer de doublon au rejeu.
class SyncQueue extends Table {
  TextColumn get clientUuid => text()();
  IntColumn get organisationId => integer()();
  TextColumn get type =>
      text()(); // daily_record, vaccination_done, sale, stock_movement
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // pending, created, duplicate, rejected
  TextColumn get message => text().nullable()();
  IntColumn get subjectId => integer().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {clientUuid};
}

/// Réglages locaux (organisation et ferme actives, dernière synchronisation…), clé => valeur.
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Cache des bandes visibles, rafraîchi à chaque connexion réseau.
class CachedFlocks extends Table {
  IntColumn get id => integer()();
  IntColumn get organisationId => integer()();
  IntColumn get farmId => integer().nullable()();
  TextColumn get code => text()();
  TextColumn get name => text().nullable()();
  TextColumn get farmName => text().nullable()();
  TextColumn get kind => text()();
  BoolColumn get tracksEggs => boolean().withDefault(const Constant(false))();
  BoolColumn get tracksWeight => boolean().withDefault(const Constant(false))();
  IntColumn get quantityCurrent => integer().withDefault(const Constant(0))();
  IntColumn get ageDays => integer().nullable()();
  TextColumn get lastRecordDate => text().nullable()();
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache des clients, pour la vente hors-ligne.
class CachedCustomers extends Table {
  IntColumn get id => integer()();
  IntColumn get organisationId => integer()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get phone => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache des produits du catalogue, pour la vente hors-ligne.
class CachedProducts extends Table {
  IntColumn get id => integer()();
  IntColumn get organisationId => integer()();
  TextColumn get name => text()();
  TextColumn get unit => text().nullable()();
  RealColumn get unitPrice => real().withDefault(const Constant(0))();
  RealColumn get taxPercent => real().withDefault(const Constant(0))();
  BoolColumn get isLiveBirds => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache des stocks des fermes accessibles.
class CachedStocks extends Table {
  IntColumn get id => integer()();
  IntColumn get organisationId => integer()();
  IntColumn get farmId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get unit => text()();
  RealColumn get quantity => real().withDefault(const Constant(0))();
  RealColumn get minQuantity => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Ventes récentes et ventes saisies localement (statut « local » tant qu'elles ne sont pas
/// envoyées), pour l'onglet Ventes hors-ligne.
class CachedSales extends Table {
  TextColumn get key =>
      text()(); // identifiant serveur (s-123) ou client_uuid (c-uuid)
  IntColumn get organisationId => integer()();
  IntColumn get farmId => integer().nullable()();
  IntColumn get serverId => integer().nullable()();
  TextColumn get clientUuid => text().nullable()();
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get saleDate => text()();
  TextColumn get customerName => text().nullable()();
  RealColumn get total => real().withDefault(const Constant(0))();
  RealColumn get paid => real().withDefault(const Constant(0))();
  TextColumn get status => text()(); // local, pending, partial, paid, cancelled
  TextColumn get summary =>
      text().nullable()(); // ex. « 50 plateaux, 20 sujets »
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Notifications de l'utilisateur (alertes, rappels), lisibles sans réseau.
class CachedNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get body => text().nullable()();
  TextColumn get status =>
      text().nullable()(); // success, warning, danger, info
  TextColumn get url => text().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    SyncQueue,
    Settings,
    CachedFlocks,
    CachedCustomers,
    CachedProducts,
    CachedStocks,
    CachedSales,
    CachedNotifications,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cachedSales);
      }
      if (from < 3) {
        await m.createTable(cachedNotifications);
      }
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(name: 'gestavi');

  // ─── Réglages ──────────────────────────────────────────────────────────

  Future<String?> setting(String key) async {
    final row = await (select(
      settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();

    return row?.value;
  }

  Future<void> putSetting(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Future<void> removeSetting(String key) =>
      (delete(settings)..where((s) => s.key.equals(key))).go();

  /// Vide tout ce qui appartient à l'utilisateur connecté (déconnexion).
  Future<void> clearAll() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);

  return db;
});
