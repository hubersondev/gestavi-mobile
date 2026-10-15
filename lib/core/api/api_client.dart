import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

/// Client HTTP de l'API GESTAVI : jeton porteur ajouté à chaque appel, erreurs traduites en
/// [ApiException] (réseau, 401, 403, 422 avec les messages par champ, autres).
class ApiClient {
  ApiClient({required TokenStorage tokens, Dio? dio, String? baseUrl})
    : _tokens = tokens,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl ?? AppConfig.apiBase,
              connectTimeout: AppConfig.connectTimeout,
              receiveTimeout: AppConfig.receiveTimeout,
              headers: const {'Accept': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Adresse du serveur modifiable depuis l'écran de connexion, sans recompiler
          final serverUrl = await _tokens.readServerUrl();
          if (serverUrl != null && serverUrl.isNotEmpty) {
            options.baseUrl = AppConfig.apiBaseFor(serverUrl);
          }

          final token = await _tokens.read();
          if (token != null && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokens;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) => _call(() => _dio.get<dynamic>(path, queryParameters: query));

  Future<Map<String, dynamic>> post(String path, {Object? body}) =>
      _call(() => _dio.post<dynamic>(path, data: body));

  Future<Map<String, dynamic>> delete(String path) =>
      _call(() => _dio.delete<dynamic>(path));

  Future<Map<String, dynamic>> _call(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return data;
      }

      return {'data': data};
    } on DioException catch (e) {
      throw _translate(e);
    } on SocketException catch (e) {
      throw ApiException('Serveur injoignable : ${e.message}');
    }
  }

  ApiException _translate(DioException e) {
    final response = e.response;

    if (response == null) {
      return ApiException(switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout =>
          'Le serveur met trop de temps à répondre. Vérifiez votre connexion.',
        DioExceptionType.connectionError => 'Pas de connexion au serveur. Vos saisies seront synchronisées plus tard.',
        _ => 'Erreur réseau : ${e.message ?? 'inconnue'}',
      });
    }

    final body = response.data;
    final message = body is Map<String, dynamic>
        ? (body['message'] as String?)
        : null;
    final errors = <String, List<String>>{};

    if (body is Map<String, dynamic> &&
        body['errors'] is Map<String, dynamic>) {
      (body['errors'] as Map<String, dynamic>).forEach((field, messages) {
        errors[field] = (messages as List<dynamic>)
            .map((m) => m.toString())
            .toList();
      });
    }

    return ApiException(
      message ??
          switch (response.statusCode) {
            401 => 'Session expirée, reconnectez-vous.',
            403 => 'Accès refusé.',
            404 => 'Introuvable.',
            429 => 'Trop de tentatives, patientez une minute.',
            _ => 'Erreur du serveur (${response.statusCode}).',
          },
      statusCode: response.statusCode,
      fieldErrors: errors,
    );
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(tokens: ref.watch(tokenStorageProvider)),
);
