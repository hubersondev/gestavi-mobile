/// Configuration de l'application, surchargeable à la compilation :
/// `flutter run --dart-define=API_URL=http://192.168.1.20:8000`.
///
/// Par défaut, l'adresse de l'émulateur Android vers le poste de développement.
class AppConfig {
  AppConfig._();

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const String apiVersion = 'v1';

  static String get apiBase => '$apiUrl/api/$apiVersion';

  static const Duration connectTimeout = Duration(seconds: 15);

  static const Duration receiveTimeout = Duration(seconds: 30);
}
