import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../auth/auth_controller.dart';
import '../flocks/flock_repository.dart' show networkMessage;
import 'stock_movement_screen.dart';
import 'stock_repository.dart';

/// Niveaux de stock de la ferme, les articles sous le seuil en tête. Appuyer sur un article
/// ouvre la saisie d'une sortie (ou d'une entrée), possible sans réseau.
class StocksScreen extends ConsumerStatefulWidget {
  const StocksScreen({super.key});

  @override
  ConsumerState<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends ConsumerState<StocksScreen> {
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

    try {
      await ref
          .read(stockRepositoryProvider)
          .refresh(
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
    final stocks = ref.watch(stocksProvider(scope));
    final canMove = session.membership!.permissions.contains(
      'stocks.record_movement',
    );

    return RefreshIndicator(
      onRefresh: _refresh,
      child: stocks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Empty(text: 'Lecture locale impossible : $error'),
        data: (list) {
          if (list.isEmpty) {
            return _Empty(
              text: _refreshedOnce
                  ? 'Aucun article de stock sur cette ferme. Les articles se créent depuis GESTAVI sur le web.'
                  : 'Chargement des stocks…',
            );
          }

          final sorted = [...list]
            ..sort((a, b) {
              final lowA = a.quantity <= a.minQuantity ? 0 : 1;
              final lowB = b.quantity <= b.minQuantity ? 0 : 1;

              return lowA != lowB ? lowA - lowB : a.name.compareTo(b.name);
            });

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _StockTile(
              stock: sorted[index],
              onTap: canMove
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            StockMovementScreen(stock: sorted[index]),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _StockTile extends StatelessWidget {
  const _StockTile({required this.stock, this.onTap});

  final CachedStock stock;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLow = stock.quantity <= stock.minQuantity;
    final color = isLow ? GestaviTheme.danger : GestaviTheme.primary;

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(stock.name),
        subtitle: Text(
          [
            if (stock.category != null) stock.category!,
            if (isLow)
              'Seuil : ${formatQuantity(stock.minQuantity)} ${stock.unit}',
          ].join(' · '),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${formatQuantity(stock.quantity)} ${stock.unit}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (isLow)
              Text(
                'Stock bas',
                style: theme.textTheme.labelSmall?.copyWith(color: color),
              ),
          ],
        ),
      ),
    );
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
          Icons.inventory_2_outlined,
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
