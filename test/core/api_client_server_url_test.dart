import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/config.dart';
import 'package:gestavi_mobile/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;
  late TokenStorage tokens;

  setUp(() {
    storage = _MockSecureStorage();
    tokens = TokenStorage(storage: storage);
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
  });

  test('apiBaseFor normalise l\'adresse saisie', () {
    expect(
      AppConfig.apiBaseFor('http://192.168.1.26:8000/'),
      'http://192.168.1.26:8000/api/v1',
    );
    expect(
      AppConfig.apiBaseFor(' https://gestavi.ci '),
      'https://gestavi.ci/api/v1',
    );
  });

  test(
    'l\'adresse enregistrée remplace celle de la compilation à chaque appel',
    () async {
      when(() => storage.read(key: 'gestavi.server_url'))
          .thenAnswer((_) async => 'http://192.168.1.26:8000');
      final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBase));
      final client = ApiClient(tokens: tokens, dio: dio);
      RequestOptions? sent;

      // Intercepteur ajouté après la construction : il passe après celui du client
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sent = options;
            handler.reject(
              DioException.connectionError(
                requestOptions: options,
                reason: 'coupé',
              ),
            );
          },
        ),
      );

      await expectLater(() => client.get('/me'), throwsA(isA<ApiException>()));
      expect(sent?.uri.toString(), 'http://192.168.1.26:8000/api/v1/me');
    },
  );

  test(
    'sans adresse enregistrée, la valeur de compilation reste utilisée',
    () async {
      final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBase));
      final client = ApiClient(tokens: tokens, dio: dio);
      RequestOptions? sent;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            sent = options;
            handler.reject(
              DioException.connectionError(
                requestOptions: options,
                reason: 'coupé',
              ),
            );
          },
        ),
      );

      await expectLater(() => client.get('/me'), throwsA(isA<ApiException>()));
      expect(sent?.uri.toString(), '${AppConfig.apiBase}/me');
    },
  );
}
