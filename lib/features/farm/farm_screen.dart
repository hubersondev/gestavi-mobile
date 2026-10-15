import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_exception.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../auth/models.dart';

/// Choix de la ferme de travail. Une seule ferme accessible : choisie sans rien demander.
/// Les rôles à accès global peuvent aussi travailler sur « toutes les fermes ».
class FarmScreen extends ConsumerStatefulWidget {
  const FarmScreen({super.key});

  @override
  ConsumerState<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends ConsumerState<FarmScreen> {
  List<FarmSummary>? _farms;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = ref.read(authControllerProvider).value;

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    setState(() => _error = null);

    try {
      final farms = await ref
          .read(authRepositoryProvider)
          .farms(session.membership!);

      if (!mounted) {
        return;
      }

      // Une seule ferme : le choix est fait, l'accueil s'ouvre directement
      if (farms.length == 1 && !session.membership!.allFarms) {
        await ref
            .read(authControllerProvider.notifier)
            .selectFarm(farms.single.id);

        return;
      }

      if (farms.length == 1 && session.membership!.allFarms) {
        await ref.read(authControllerProvider.notifier).selectFarm(null);

        return;
      }

      setState(() => _farms = farms);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _error = e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;
    final membership = session is Authenticated ? session.membership : null;
    final theme = Theme.of(context);
    final farms = _farms;

    return Scaffold(
      appBar: AppBar(
        title: Text(membership?.name ?? 'Votre ferme'),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: _error != null
          ? _Message(
              text: _error!,
              action: FilledButton(
                onPressed: _load,
                child: const Text('Réessayer'),
              ),
            )
          : farms == null
          ? const Center(child: CircularProgressIndicator())
          : farms.isEmpty
          ? const _Message(
              text: 'Aucune ferme ne vous est affectée. Demandez à votre responsable de vous rattacher à une ferme.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Sur quelle ferme travaillez-vous ?',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Vous pourrez en changer depuis l\'accueil.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                if (membership?.allFarms ?? false) ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.apps_outlined),
                      title: const Text('Toutes les fermes'),
                      subtitle: const Text(
                        'Vue d\'ensemble, saisie sur n\'importe quelle ferme',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => ref
                          .read(authControllerProvider.notifier)
                          .selectFarm(null),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                for (final farm in farms) ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.agriculture_outlined),
                      title: Text(
                        farm.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: farm.code.isEmpty ? null : Text(farm.code),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => ref
                          .read(authControllerProvider.notifier)
                          .selectFarm(farm.id),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

/// Compte sans organisation : rien à afficher tant qu'un responsable ne l'a pas invité.
class NoOrganisationScreen extends ConsumerWidget {
  const NoOrganisationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestavi'),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: const _Message(
        text: 'Votre compte n\'est rattaché à aucune organisation. Demandez à votre responsable de vous inviter depuis GESTAVI, puis reconnectez-vous.',
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
