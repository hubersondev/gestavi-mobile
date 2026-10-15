import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_client.dart';
import 'package:gestavi_mobile/core/storage/token_storage.dart';
import 'package:gestavi_mobile/features/onboarding/onboarding_screen.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage storage;

  setUp(() {
    storage = _MockSecureStorage();
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  Widget app() => ProviderScope(
    overrides: [
      tokenStorageProvider.overrideWithValue(TokenStorage(storage: storage)),
    ],
    child: const MaterialApp(home: OnboardingScreen(replay: true)),
  );

  test(
    'la présentation est marquée vue sur l’appareil et relue ensuite',
    () async {
      final tokens = TokenStorage(storage: storage);
      expect(await tokens.readOnboardingSeen(), isFalse);

      await tokens.markOnboardingSeen();
      verify(() => storage.write(key: 'gestavi.onboarding_seen', value: '1'))
          .called(1);

      when(() => storage.read(key: 'gestavi.onboarding_seen'))
          .thenAnswer((_) async => '1');
      expect(await tokens.readOnboardingSeen(), isTrue);
    },
  );

  testWidgets(
    'fait défiler les pages puis marque la présentation vue à la fin',
    (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      expect(find.text('Bienvenue sur Gestavi'), findsOneWidget);
      expect(find.text('Suivant'), findsOneWidget);

      for (var i = 1; i < OnboardingScreen.pages.length; i++) {
        await tester.tap(find.text('Suivant'));
        await tester.pumpAndSettle();
        expect(find.text(OnboardingScreen.pages[i].title), findsOneWidget);
      }

      expect(find.text('Commencer'), findsOneWidget);
      verifyNever(
        () => storage.write(
          key: 'gestavi.onboarding_seen',
          value: any(named: 'value'),
        ),
      );

      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      verify(() => storage.write(key: 'gestavi.onboarding_seen', value: '1'))
          .called(1);
    },
  );

  testWidgets('« Passer » marque aussi la présentation vue', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();

    verify(() => storage.write(key: 'gestavi.onboarding_seen', value: '1'))
        .called(1);
  });
}
