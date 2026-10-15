import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/farm/farm_screen.dart';
import '../features/home/home_shell.dart';
import '../features/onboarding/onboarding_screen.dart';

/// Navigation : présentation (premier lancement) → connexion → choix de la ferme (si
/// plusieurs) → accueil à onglets. Les redirections suivent l'état de session.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final onboardingSeen = ref.watch(onboardingSeenProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final session = auth.value;
      final location = state.matchedLocation;

      if (session == null ||
          session is AuthLoading ||
          onboardingSeen.isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      if (session is Unauthenticated) {
        if (!(onboardingSeen.value ?? true)) {
          return location == '/onboarding' ? null : '/onboarding';
        }

        return location == '/login' ? null : '/login';
      }

      final authenticated = session as Authenticated;

      if (!authenticated.hasOrganisation) {
        return location == '/no-organisation' ? null : '/no-organisation';
      }

      if (authenticated.needsFarmChoice) {
        return location == '/farm' ? null : '/farm';
      }

      if (location == '/login' ||
          location == '/onboarding' ||
          location == '/splash' ||
          location == '/farm' ||
          location == '/no-organisation') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/no-organisation',
        builder: (context, state) => const NoOrganisationScreen(),
      ),
      GoRoute(path: '/farm', builder: (context, state) => const FarmScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeShell()),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
