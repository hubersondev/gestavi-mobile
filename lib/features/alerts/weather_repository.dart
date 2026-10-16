import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/db/app_database.dart';

/// Météo des fermes : prévisions à 3 jours et conditions à risque pour les bandes, rafraîchies
/// depuis `GET /organisations/{slug}/farms/{farm}/weather` et lisibles sans réseau.
class WeatherRepository {
  WeatherRepository({required AppDatabase db, required ApiClient api})
    : _db = db,
      _api = api;

  final AppDatabase _db;
  final ApiClient _api;

  /// Jours affichés sur l'onglet Alertes.
  static const int horizonDays = 3;

  /// Prévisions à venir (jour courant inclus), toutes fermes ou une seule.
  Stream<List<CachedWeatherData>> watch({int? farmId}) {
    final query = _db.select(_db.cachedWeather)
      ..where((w) => w.forecastDate.isBiggerOrEqualValue(_today()))
      ..orderBy([
        (w) => OrderingTerm.asc(w.farmName),
        (w) => OrderingTerm.asc(w.forecastDate),
      ]);

    if (farmId != null) {
      query.where((w) => w.farmId.equals(farmId));
    }

    return query.watch();
  }

  Stream<List<CachedWeatherAlert>> watchAlerts({int? farmId}) {
    final query = _db.select(_db.cachedWeatherAlerts)
      ..where((a) => a.forecastDate.isBiggerOrEqualValue(_today()))
      ..orderBy([
        (a) => OrderingTerm.desc(a.isCritical),
        (a) => OrderingTerm.asc(a.forecastDate),
      ]);

    if (farmId != null) {
      query.where((a) => a.farmId.equals(farmId));
    }

    return query.watch();
  }

  /// Rafraîchit une ferme ; retourne le nombre de journées reçues (0 si la météo n'est pas
  /// activée côté serveur : le cache de la ferme est alors vidé).
  Future<int> refresh({
    required String organisationSlug,
    required int farmId,
    String? farmName,
  }) async {
    final response = await _api.get(
      '/organisations/$organisationSlug/farms/$farmId/weather',
    );
    final enabled = response['enabled'] as bool? ?? false;
    final fetchedAt = _date(response['fetched_at']);
    final days = enabled
        ? (response['forecast'] as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>()
              .take(horizonDays)
              .map(
                (day) => CachedWeatherCompanion.insert(
                  key: '${farmId}_${day['date']}',
                  farmId: farmId,
                  farmName: Value(farmName),
                  forecastDate: day['date'] as String,
                  tempMin: Value(_double(day['temp_min'])),
                  tempMax: Value(_double(day['temp_max'])),
                  tempAvg: Value(_double(day['temp_avg'])),
                  humidity: Value(_double(day['humidity'])),
                  windKmh: Value(_double(day['wind_kmh'])),
                  rainMm: Value(_double(day['rain_mm'])),
                  description: Value(day['description'] as String?),
                  emoji: Value(day['emoji'] as String?),
                  fetchedAt: Value(fetchedAt),
                ),
              )
              .toList()
        : const <CachedWeatherCompanion>[];
    final alerts = enabled
        ? (response['alerts'] as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>()
              .map(
                (alert) => CachedWeatherAlertsCompanion.insert(
                  key:
                      '${farmId}_${alert['flock_id']}_${alert['date']}_${alert['kind']}',
                  farmId: farmId,
                  flockId: alert['flock_id'] as int,
                  flockCode: Value(alert['flock_code'] as String?),
                  forecastDate: alert['date'] as String,
                  kind: alert['kind'] as String,
                  isCritical: Value(alert['critical'] as bool? ?? false),
                  message: alert['message'] as String,
                ),
              )
              .toList()
        : const <CachedWeatherAlertsCompanion>[];

    await _db.transaction(() async {
      await (_db.delete(
        _db.cachedWeather,
      )..where((w) => w.farmId.equals(farmId))).go();
      await (_db.delete(
        _db.cachedWeatherAlerts,
      )..where((a) => a.farmId.equals(farmId))).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.cachedWeather,
          days,
          mode: InsertMode.insertOrReplace,
        );
        batch.insertAll(
          _db.cachedWeatherAlerts,
          alerts,
          mode: InsertMode.insertOrReplace,
        );
      });
    });

    return days.length;
  }

  static String _today() {
    final now = DateTime.now();

    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static double? _double(Object? value) => switch (value) {
    num n => n.toDouble(),
    String s => double.tryParse(s),
    _ => null,
  };

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepository(
    db: ref.watch(appDatabaseProvider),
    api: ref.watch(apiClientProvider),
  ),
);

final weatherProvider = StreamProvider.family<List<CachedWeatherData>, int?>(
  (ref, farmId) => ref.watch(weatherRepositoryProvider).watch(farmId: farmId),
);

final weatherAlertsProvider =
    StreamProvider.family<List<CachedWeatherAlert>, int?>(
      (ref, farmId) =>
          ref.watch(weatherRepositoryProvider).watchAlerts(farmId: farmId),
    );

/// « Lun 17/10 » à partir d'une date ISO.
String weatherDayLabel(String isoDate) {
  final date = DateTime.tryParse(isoDate);

  if (date == null) {
    return isoDate;
  }

  const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  final today = DateTime.now();

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'Aujourd’hui';
  }

  return '${days[date.weekday - 1]} ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}

/// « 24–33 °C ».
String weatherRange(CachedWeatherData day) {
  if (day.tempMin == null && day.tempMax == null) {
    return '—';
  }

  return '${(day.tempMin ?? day.tempMax!).round()}–${(day.tempMax ?? day.tempMin!).round()} °C';
}

/// « 💧 78 %  🌧️ 6,5 mm » : humidité moyenne et cumul de pluie s'il y en a.
String weatherDetails(CachedWeatherData day) {
  final humidity = day.humidity == null ? '—' : '${day.humidity!.round()}';
  final rain = day.rainMm ?? 0;

  if (rain <= 0) {
    return '💧 $humidity %';
  }

  final rainText = rain < 10
      ? rain.toStringAsFixed(1).replaceAll('.', ',')
      : rain.round().toString();

  return '💧 $humidity %  🌧️ $rainText mm';
}
