import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Jeton d'accès de l'appareil, conservé dans le stockage sécurisé du système
/// (Keystore Android, Keychain iOS).
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String _key = 'gestavi.api_token';

  final FlutterSecureStorage _storage;

  Future<String?> read() => _storage.read(key: _key);

  Future<void> write(String token) => _storage.write(key: _key, value: token);

  Future<void> clear() => _storage.delete(key: _key);
}
