/// Erreur d'appel à l'API GESTAVI, avec un message lisible par l'utilisateur et, pour une
/// erreur de validation (422), les messages par champ.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  final String message;

  final int? statusCode;

  /// champ => messages, tel que renvoyé par Laravel (`errors`)
  final Map<String, List<String>> fieldErrors;

  bool get isUnauthenticated => statusCode == 401;

  bool get isForbidden => statusCode == 403;

  bool get isValidation => statusCode == 422;

  bool get isNetwork => statusCode == null;

  /// 423 : organisation en lecture seule côté serveur, la saisie reste en attente.
  bool get isLocked => statusCode == 423;

  String? firstErrorFor(String field) => fieldErrors[field]?.firstOrNull;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
