import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import '../../core/db/app_database.dart';
import '../../core/storage/token_storage.dart';
import 'models.dart';

/// Connexion par jeton d'appareil, profil et appartenances, fermes accessibles ; le profil est
/// conservé localement pour ouvrir l'application sans réseau.
class AuthRepository {
  AuthRepository({
    required ApiClient api,
    required TokenStorage tokens,
    required AppDatabase db,
  }) : _api = api,
       _tokens = tokens,
       _db = db;

  final ApiClient _api;
  final TokenStorage _tokens;
  final AppDatabase _db;

  static const String profileKey = 'auth.profile';
  static const String organisationKey = 'auth.organisation_id';
  static const String farmKey = 'auth.farm_id';
  static const String farmsKeyPrefix = 'auth.farms.';

  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/token',
      body: {
        'email': email.trim(),
        'password': password,
        'device_name': await _deviceName(),
      },
    );

    await _tokens.write(response['token'] as String);

    final profile = UserProfile.fromJson(
      response['user'] as Map<String, dynamic>,
    );
    await _db.putSetting(profileKey, jsonEncode(profile.toJson()));

    return profile;
  }

  /// Profil mémorisé, sans réseau. Null si personne n'est connecté.
  Future<UserProfile?> storedProfile() async {
    if (await _tokens.read() == null) {
      return null;
    }

    final raw = await _db.setting(profileKey);

    return raw == null
        ? null
        : UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Rafraîchit le profil depuis l'API ; en cas de panne réseau, conserve celui en mémoire.
  Future<UserProfile?> refreshProfile() async {
    try {
      final response = await _api.get('/me');
      final profile = UserProfile.fromJson(
        response['data'] as Map<String, dynamic>,
      );
      await _db.putSetting(profileKey, jsonEncode(profile.toJson()));

      return profile;
    } on ApiException catch (e) {
      if (e.isUnauthenticated) {
        await logout(remote: false);

        return null;
      }

      return storedProfile();
    }
  }

  Future<void> logout({bool remote = true}) async {
    if (remote) {
      try {
        await _api.delete('/auth/token');
      } on ApiException {
        // Le jeton local disparaît quoi qu'il arrive ; un jeton orphelin se révoque depuis le panel
      }
    }

    await _tokens.clear();
    await _db.clearAll();
  }

  Future<List<FarmSummary>> farms(Membership membership) async {
    final key = '$farmsKeyPrefix${membership.organisationId}';

    try {
      final response = await _api.get(
        '/organisations/${membership.slug}/farms',
      );
      final farms = (response['data'] as List<dynamic>)
          .map((f) => FarmSummary.fromJson(f as Map<String, dynamic>))
          .toList();
      await _db.putSetting(
        key,
        jsonEncode(farms.map((f) => f.toJson()).toList()),
      );

      return farms;
    } on ApiException catch (e) {
      if (!e.isNetwork) {
        rethrow;
      }

      final cached = await _db.setting(key);

      return cached == null
          ? const []
          : (jsonDecode(cached) as List<dynamic>)
                .map((f) => FarmSummary.fromJson(f as Map<String, dynamic>))
                .toList();
    }
  }

  Future<void> selectOrganisation(int organisationId) =>
      _db.putSetting(organisationKey, organisationId.toString());

  /// Ferme de travail ; null = toutes les fermes (rôles à accès global), mémorisé comme un choix fait.
  Future<void> selectFarm(int? farmId) =>
      _db.putSetting(farmKey, farmId?.toString() ?? 'all');

  Future<void> forgetFarm() => _db.removeSetting(farmKey);

  Future<int?> selectedOrganisationId() async =>
      int.tryParse(await _db.setting(organisationKey) ?? '');

  /// (choix fait ?, identifiant de ferme ou null pour toutes)
  Future<({bool resolved, int? farmId})> selectedFarm() async {
    final raw = await _db.setting(farmKey);

    if (raw == null) {
      return (resolved: false, farmId: null);
    }

    return (resolved: true, farmId: int.tryParse(raw));
  }

  Future<String> _deviceName() async {
    try {
      return '${Platform.operatingSystem} ${Platform.localHostname}'.trim();
    } catch (_) {
      return 'Mobile';
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    api: ref.watch(apiClientProvider),
    tokens: ref.watch(tokenStorageProvider),
    db: ref.watch(appDatabaseProvider),
  ),
);
