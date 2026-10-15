import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Jeton d'accès de l'appareil et adresse du serveur, conservés dans le stockage sécurisé du
/// système (Keystore Android, Keychain iOS). L'adresse survit à la déconnexion.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'gestavi.api_token';
  static const String _serverKey = 'gestavi.server_url';

  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);

  /// Adresse du serveur choisie sur l'écran de connexion, null = celle de la compilation.
  Future<String?> readServerUrl() => _storage.read(key: _serverKey);

  Future<void> writeServerUrl(String? url) => url == null || url.isEmpty
      ? _storage.delete(key: _serverKey)
      : _storage.write(key: _serverKey, value: url);
}
