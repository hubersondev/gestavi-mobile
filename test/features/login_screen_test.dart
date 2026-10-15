import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/features/auth/auth_controller.dart';
import 'package:gestavi_mobile/features/auth/login_screen.dart';

/// Contrôleur de session sans réseau ni base : mémorise l'appel et simule le verdict.
class _FakeAuthController extends AuthController {
  _FakeAuthController({this.error});

  final String? error;
  final calls = <(String, String)>[];

  @override
  Future<AuthState> build() async => const Unauthenticated();

  @override
  Future<void> login({required String email, required String password}) async {
    calls.add((email, password));
    state = AsyncValue.data(Unauthenticated(error: error));
  }
}

Widget _app(_FakeAuthController controller) => ProviderScope(
  overrides: [authControllerProvider.overrideWith(() => controller)],
  child: const MaterialApp(home: LoginScreen()),
);

void main() {
  testWidgets(
    'refuse une adresse invalide ou un mot de passe vide sans appeler l\'API',
    (tester) async {
      final controller = _FakeAuthController();
      await tester.pumpWidget(_app(controller));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'pas-une-adresse',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Connexion'));
      await tester.pumpAndSettle();

      expect(find.text('Adresse e-mail invalide.'), findsOneWidget);
      expect(find.text('Le mot de passe est obligatoire.'), findsOneWidget);
      expect(controller.calls, isEmpty);
    },
  );

  testWidgets(
    'envoie les identifiants et affiche le message d\'erreur renvoyé',
    (tester) async {
      final controller = _FakeAuthController(error: 'Identifiants incorrects.');
      await tester.pumpWidget(_app(controller));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'jean@ferme-demo.ci',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'secret');
      await tester.tap(find.widgetWithText(FilledButton, 'Connexion'));
      await tester.pumpAndSettle();

      expect(controller.calls, [('jean@ferme-demo.ci', 'secret')]);
      expect(find.text('Identifiants incorrects.'), findsOneWidget);
    },
  );
}
