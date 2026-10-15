import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_queue.dart';
import '../../core/sync/sync_service.dart';
import '../auth/auth_controller.dart';
import '../flocks/flocks_screen.dart';
import '../sales/sales_screen.dart';

/// Accueil à onglets : bandes, ventes, stocks, alertes. Les écrans arrivent un par un ;
/// la coque porte déjà le contexte (ferme active), la synchronisation et la déconnexion.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;
  int? _syncStartedFor;

  static const _tabs = [
    (label: 'Bandes', icon: Icons.egg_outlined, selected: Icons.egg),
    (
      label: 'Ventes',
      icon: Icons.receipt_long_outlined,
      selected: Icons.receipt_long,
    ),
    (
      label: 'Stocks',
      icon: Icons.inventory_2_outlined,
      selected: Icons.inventory_2,
    ),
    (
      label: 'Alertes',
      icon: Icons.notifications_outlined,
      selected: Icons.notifications,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;

    if (session is! Authenticated || session.membership == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final membership = session.membership!;

    // Synchronisation de fond dès que le réseau revient, une fois par organisation
    if (_syncStartedFor != membership.organisationId) {
      _syncStartedFor = membership.organisationId;
      ref
          .read(syncServiceProvider)
          .start(
            organisationId: membership.organisationId,
            organisationSlug: membership.slug,
          );
    }
    final pendingCount =
        ref.watch(_pendingCountProvider(membership.organisationId)).value ?? 0;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_tabs[_index].label),
            Text(
              session.farmId == null
                  ? '${membership.name} · toutes les fermes'
                  : membership.name,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.appBarTheme.foregroundColor?.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (pendingCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Badge.count(
                count: pendingCount,
                child: IconButton(
                  tooltip: 'Saisies à synchroniser',
                  icon: const Icon(Icons.cloud_upload_outlined),
                  onPressed: () =>
                      _sync(membership.organisationId, membership.slug),
                ),
              ),
            ),
          PopupMenuButton<String>(
            tooltip: 'Menu',
            onSelected: (value) => switch (value) {
              'farm' => ref.read(authControllerProvider.notifier).changeFarm(),
              'logout' => ref.read(authControllerProvider.notifier).logout(),
              _ => null,
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'farm',
                child: ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text('Changer de ferme'),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Se déconnecter'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          FlocksScreen(),
          SalesScreen(),
          _ComingSoon(
            title: 'Stocks',
            detail: 'Niveaux par ferme, sorties d\'aliment et de médicaments.',
          ),
          _ComingSoon(
            title: 'Alertes',
            detail: 'Stock bas, vaccinations à faire, relevés manquants, factures échues.',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selected),
              label: tab.label,
            ),
        ],
      ),
    );
  }

  Future<void> _sync(int organisationId, String slug) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final count = await ref
          .read(syncQueueProvider)
          .push(organisationId: organisationId, organisationSlug: slug);
      messenger.showSnackBar(
        SnackBar(content: Text('$count saisie(s) synchronisée(s).')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Synchronisation impossible : $e')),
      );
    }
  }
}

final _pendingCountProvider = StreamProvider.family<int, int>(
  (ref, organisationId) =>
      ref.watch(syncQueueProvider).watchPendingCount(organisationId),
);

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
