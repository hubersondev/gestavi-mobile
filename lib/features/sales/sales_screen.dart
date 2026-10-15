import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../auth/auth_controller.dart';
import '../flocks/flock_repository.dart' show networkMessage;
import 'sale_form_screen.dart';
import 'sale_repository.dart';

/// Ventes récentes de la ferme et ventes saisies sur le téléphone en attente d'envoi.
/// Tirer pour rafraîchir recharge aussi les clients et produits utilisés hors-ligne.
class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  bool _refreshedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh(silent: true));
  }

  Future<void> _refresh({bool silent = false}) async {
    final session = ref.read(authControllerProvider).value;

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    final membership = session.membership!;
    final repository = ref.read(saleRepositoryProvider);

    try {
      await repository.refreshReferentials(
        organisationId: membership.organisationId,
        organisationSlug: membership.slug,
      );
      await repository.refreshSales(
        organisationId: membership.organisationId,
        organisationSlug: membership.slug,
      );
    } catch (error) {
      if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              networkMessage(error) ?? 'Rafraîchissement impossible : $error',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _refreshedOnce = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;

    if (session is! Authenticated || session.membership == null) {
      return const SizedBox.shrink();
    }

    final scope = (
      organisationId: session.membership!.organisationId,
      farmId: session.farmId,
    );
    final sales = ref.watch(salesProvider(scope));
    final canSell = session.membership!.permissions.contains('sales.create');

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: sales.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              _Empty(text: 'Lecture locale impossible : $error'),
          data: (list) => list.isEmpty
              ? _Empty(
                  text: _refreshedOnce
                      ? 'Aucune vente récente. Appuyez sur + pour en saisir une.'
                      : 'Chargement des ventes…',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _SaleTile(sale: list[index]),
                ),
        ),
      ),
      floatingActionButton: canSell
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SaleFormScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle vente'),
            )
          : null,
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale});

  final CachedSale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (sale.status) {
      'paid' => GestaviTheme.primary,
      'partial' || 'pending' => GestaviTheme.warning,
      'local' => GestaviTheme.info,
      'cancelled' => GestaviTheme.danger,
      _ => GestaviTheme.inkMuted,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    sale.customerName ?? 'Client comptant',
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formatXof(sale.total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (sale.summary?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                sale.summary!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  [
                    _shortDate(sale.saleDate),
                    if (sale.invoiceNumber != null) sale.invoiceNumber!,
                  ].join(' · '),
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    saleStatusLabel(sale.status),
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _shortDate(String isoDate) {
    final parts = isoDate.split('-');

    return parts.length == 3 ? '${parts[2]}/${parts[1]}/${parts[0]}' : isoDate;
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.receipt_long_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 12),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
