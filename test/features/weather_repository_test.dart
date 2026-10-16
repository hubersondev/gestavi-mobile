import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/db/app_database.dart';
import 'package:gestavi_mobile/features/alerts/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockApi extends Mock implements ApiClient {}

String _iso(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

Map<String, dynamic> _day(int offset, {double tempMax = 33}) => {
  'date': _iso(DateTime.now().add(Duration(days: offset))),
  'temp_min': 24.0,
  'temp_max': tempMax,
  'temp_avg': 28.5,
  'humidity': 78,
  'wind_kmh': 12.6,
  'rain_mm': offset == 1 ? 6.5 : 0,
  'description': 'ciel dégagé',
  'icon': '01d',
  'emoji': '☀️',
};

Map<String, dynamic> _response({bool enabled = true, int days = 5}) => {
  'enabled': enabled,
  'located': true,
  'current': enabled ? _day(0) : null,
  'forecast': enabled ? [for (var i = 0; i < days; i++) _day(i)] : [],
  'alerts': enabled
      ? [
          {
            'flock_id': 7,
            'flock_code': 'LOT-2026-002',
            'date': _iso(DateTime.now().add(const Duration(days: 1))),
            'kind': 'heat',
            'critical': true,
            'message': 'Canicule le 17/10 : 41 °C prévus, seuil 30 °C',
          },
          {
            'flock_id': 7,
            'flock_code': 'LOT-2026-002',
            'date': _iso(DateTime.now().add(const Duration(days: 2))),
            'kind': 'wind',
            'critical': false,
            'message': 'Vent fort le 18/10 : 58 km/h prévus',
          },
        ]
      : [],
  'fetched_at': '2026-10-16T06:00:00+00:00',
};

void main() {
  late AppDatabase db;
  late _MockApi api;
  late WeatherRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    api = _MockApi();
    repository = WeatherRepository(db: db, api: api);
  });

  tearDown(() => db.close());

  test(
    'met en cache 3 jours de prévisions et les alertes de la ferme',
    () async {
      when(() => api.get(any())).thenAnswer((_) async => _response());

      expect(
        await repository.refresh(
          organisationSlug: 'kouassi',
          farmId: 1,
          farmName: 'Ferme Anyama',
        ),
        3,
      );
      verify(() => api.get('/organisations/kouassi/farms/1/weather')).called(1);

      final days = await db.select(db.cachedWeather).get();
      final alerts = await db.select(db.cachedWeatherAlerts).get();

      expect(days.length, 3);
      expect(days.first.farmName, 'Ferme Anyama');
      expect(days.first.tempMax, 33);
      expect(days.first.emoji, '☀️');
      expect(days[1].rainMm, 6.5);
      expect(weatherRange(days.first), '24–33 °C');
      expect(weatherDayLabel(days.first.forecastDate), 'Aujourd’hui');
      expect(alerts.length, 2);
      expect(alerts.where((a) => a.isCritical).single.kind, 'heat');
    },
  );

  test('ne remplace que la ferme rafraîchie', () async {
    when(() => api.get(any())).thenAnswer((_) async => _response());
    await repository.refresh(organisationSlug: 'kouassi', farmId: 1);
    await repository.refresh(organisationSlug: 'kouassi', farmId: 2);

    when(() => api.get(any())).thenAnswer((_) async => _response(days: 1));
    await repository.refresh(organisationSlug: 'kouassi', farmId: 1);

    final days = await db.select(db.cachedWeather).get();

    expect(days.where((d) => d.farmId == 1).length, 1);
    expect(days.where((d) => d.farmId == 2).length, 3);
  });

  test(
    'météo désactivée côté serveur : le cache de la ferme est vidé',
    () async {
      when(() => api.get(any())).thenAnswer((_) async => _response());
      await repository.refresh(organisationSlug: 'kouassi', farmId: 1);

      when(() => api.get(any()))
          .thenAnswer((_) async => _response(enabled: false));

      expect(
        await repository.refresh(organisationSlug: 'kouassi', farmId: 1),
        0,
      );
      expect(await db.select(db.cachedWeather).get(), isEmpty);
      expect(await db.select(db.cachedWeatherAlerts).get(), isEmpty);
    },
  );
}
