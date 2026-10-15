import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/api/api_client.dart';

/// Présentation de l'application au premier lancement (avant la connexion), rejouable depuis
/// le menu : à quoi sert Gestavi, le hors-ligne, le relevé du jour, ventes et stocks.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.replay = false});

  /// Rejoué depuis le menu : on revient simplement en arrière à la fin.
  final bool replay;

  static const pages = <OnboardingPage>[
    OnboardingPage(
      icon: Icons.egg_alt_outlined,
      title: 'Bienvenue sur Gestavi',
      body: 'Vos fermes dans la poche : bandes, relevés, ventes et stocks, avec les mêmes identifiants que sur le web.',
    ),
    OnboardingPage(
      icon: Icons.cloud_off_outlined,
      title: 'Ça marche sans réseau',
      body: 'Saisissez au poulailler, même sans connexion. Tout est conservé sur le téléphone et envoyé automatiquement dès que le réseau revient. Le nuage en haut indique ce qui reste à envoyer.',
    ),
    OnboardingPage(
      icon: Icons.edit_note,
      title: 'Chaque jour, le relevé',
      body: 'Pour chaque bande : mortalité, œufs collectés, aliment, eau. Un seul relevé par bande et par jour ; s’il existe déjà, vous le complétez. Les vaccins à faire sont rappelés sur la carte de la bande.',
    ),
    OnboardingPage(
      icon: Icons.receipt_long_outlined,
      title: 'Ventes et stocks',
      body: 'Facturez en quelques gestes, encaissez tout de suite ou plus tard. Les œufs collectés alimentent le stock, les ventes en sortent, et les alertes vous préviennent des stocks bas et des retards.',
    ),
  ];

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLast => _index == OnboardingScreen.pages.length - 1;

  Future<void> _finish() async {
    await ref.read(tokenStorageProvider).markOnboardingSeen();
    ref.invalidate(onboardingSeenProvider);

    if (!mounted) {
      return;
    }

    if (widget.replay) {
      Navigator.of(context).pop();
    } else {
      context.go('/login');
    }
  }

  void _next() {
    if (_isLast) {
      _finish();

      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = OnboardingScreen.pages;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                child: TextButton(
                  onPressed: _isLast ? null : _finish,
                  child: const Text('Passer'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) => _PageView(page: pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < pages.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? GestaviTheme.primary
                                : theme.colorScheme.onSurfaceVariant.withValues(
                                    alpha: 0.3,
                                  ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _next,
                    child: Text(_isLast ? 'Commencer' : 'Suivant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une page de présentation : pictogramme, titre, explication.
class OnboardingPage {
  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

class _PageView extends StatelessWidget {
  const _PageView({required this.page});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: GestaviTheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 56, color: GestaviTheme.primary),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Vrai une fois la présentation vue sur cet appareil (survit à la déconnexion).
final onboardingSeenProvider = FutureProvider<bool>(
  (ref) => ref.watch(tokenStorageProvider).readOnboardingSeen(),
);
