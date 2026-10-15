import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class _FakeSecureStorage extends Mock implements FlutterSecureStorage {}

/// Répond sans réseau à chaque requête du Dio donné : réponse ou erreur programmée.
/// Ajouté après la construction du client, pour passer derrière son intercepteur de jeton.
void _answer(
  Dio dio, {
  int? status,
  Object? data,
  DioExceptionType? failure,
  void Function(RequestOptions)? inspect,
}) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        inspect?.call(options);

        if (failure != null) {
          handler.reject(DioException(requestOptions: options, type: failure));

          return;
        }

        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: data,
        );

        if (status != null && status >= 400) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: response,
              type: DioExceptionType.badResponse,
            ),
          );

          return;
        }

        handler.resolve(response);
      },
    ),
  );
}

void main() {
  late _FakeSecureStorage storage;
  late TokenStorage tokens;
  late Dio dio;
  late ApiClient client;

  setUp(() {
    storage = _FakeSecureStorage();
    tokens = TokenStorage(storage: storage);
    dio = Dio();
    client = ApiClient(tokens: tokens, dio: dio);
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => 'jeton-test');
    // Pas d'adresse de serveur enregistrée : celle de la compilation s'applique
    when(() => storage.read(key: 'gestavi.server_url'))
        .thenAnswer((_) async => null);
  });

  test('ajoute le jeton porteur et renvoie le corps JSON', () async {
    RequestOptions? seen;
    _answer(
      dio,
      status: 200,
      data: {
        'data': {'id': 1},
      },
      inspect: (o) => seen = o,
    );

    final body = await client.get('/me');

    expect(body['data'], {'id': 1});
    expect(seen?.headers['Authorization'], 'Bearer jeton-test');
  });

  test(
    'traduit une erreur de validation 422 avec les messages par champ',
    () async {
      _answer(
        dio,
        status: 422,
        data: {
          'message': 'Identifiants incorrects.',
          'errors': {
            'email': ['Identifiants incorrects.'],
          },
        },
      );

      await expectLater(
        () => client.post('/auth/token', body: {}),
        throwsA(
          isA<ApiException>()
              .having((e) => e.isValidation, 'isValidation', isTrue)
              .having(
                (e) => e.firstErrorFor('email'),
                'email',
                'Identifiants incorrects.',
              )
              .having((e) => e.message, 'message', 'Identifiants incorrects.'),
        ),
      );
    },
  );

  test('traduit un 401 en session expirée', () async {
    _answer(dio, status: 401, data: {});

    await expectLater(
      () => client.get('/me'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.isUnauthenticated,
          'isUnauthenticated',
          isTrue,
        ),
      ),
    );
  });

  test('conserve le message du serveur sur un 403', () async {
    _answer(
      dio,
      status: 403,
      data: {'message': 'Permission requise : sales.create.'},
    );

    await expectLater(
      () => client.get('/x'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Permission requise : sales.create.',
        ),
      ),
    );
  });

  test('signale une panne réseau comme telle, sans code HTTP', () async {
    _answer(dio, failure: DioExceptionType.connectionError);

    await expectLater(
      () => client.get('/me'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.isNetwork, 'isNetwork', isTrue)
            .having((e) => e.message, 'message', contains('Pas de connexion')),
      ),
    );
  });
}
