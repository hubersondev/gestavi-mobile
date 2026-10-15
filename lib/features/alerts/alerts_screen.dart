import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../auth/auth_controller.dart';
import '../flocks/flock_repository.dart' show networkMessage;
import '../stocks/stock_repository.dart';
import '../vaccinations/vaccination_repository.dart';
import 'notification_repository.dart';

/// Alertes : stocks sous le seuil (calculés depuis le cache, donc à jour même sans réseau)
/// puis les notifications du serveur, non lues en évidence.
class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  bool _refreshedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh(silent: true));
  }

  Future<void> _refresh({bool silent = false}) async {
    final session = ref.read(authControllerProvider).value;

    try {
      await ref.read(notificationRepositoryProvider).refresh();

      if (session is Authenticated && session.membership != null) {
        await ref
            .read(vaccinationRepositoryProvider)
            .refresh(
              organisationId: session.membership!.organisationId,
              organisationSlug: session.membership!.slug,
            );
      }
    } catch (error) {
      if (!silent && mounted) {
        _snack(networkMessage(error) ?? 'Rafraîchissement impossible : $error');
      }
    } finally {
      if (mounted) {
        setState(() => _refreshedOnce = true);
      }
    }
  }

  Future<void> _markAsRead(CachedNotification notification) async {
    if (notification.readAt != null) {
      return;
    }

    try {
      await ref
          .read(notificationRepositoryProvider)
          .markAsRead(notification.id);
    } catch (error) {
      if (mounted) {
        _snack(
          networkMessage(error) ?? 'Impossible de marquer comme lue : $error',
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead();
    } catch (error) {
      if (mounted) {
        _snack(
          networkMessage(error) ?? 'Impossible de tout marquer lu : $error',
        );
      }
    }
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;

    if (session is! Authenticated || session.membership == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final lowStocks =
        ref
            .watch(
              stocksProvider((
                organisationId: session.membership!.organisationId,
                farmId: session.farmId,
              )),
            )
            .value
            ?.where((s) => s.quantity <= s.minQuantity)
            .toList() ??
        const <CachedStock>[];
    final overdueVaccinations =
        ref
            .watch(
              vaccinationsTodoProvider((
                organisationId: session.membership!.organisationId,
                farmId: session.farmId,
                flockId: null,
              )),
            )
            .value
            ?.where((v) => v.isOverdue)
            .toList() ??
        const <CachedVaccination>[];
    final notifications = ref.watch(notificationsProvider).value ?? const [];
    final unread = notifications.where((n) => n.readAt == null).length;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (lowStocks.isNotEmpty) ...[
            Text('Stocks sous le seuil', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final stock in lowStocks)
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.inventory_2_outlined,
                    color: GestaviTheme.danger,
                  ),
                  title: Text(stock.name),
                  subtitle: Text(
                    'Reste ${formatQuantity(stock.quantity)} ${stock.unit}, seuil ${formatQuantity(stock.minQuantity)}',
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
          if (overdueVaccinations.isNotEmpty) ...[
            Text('Vaccinations en retard', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final vaccination in overdueVaccinations)
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.vaccines_outlined,
                    color: GestaviTheme.danger,
                  ),
                  title: Text(vaccination.treatmentName),
                  subtitle: Text(
                    '${vaccination.flockCode ?? 'Bande ${vaccination.flockId}'} · prévue le ${_frDate(vaccination.scheduledDate)}',
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Text('Notifications', style: theme.textTheme.titleMedium),
              const Spacer(),
              if (unread > 0)
                TextButton(
                  onPressed: _markAllAsRead,
                  child: const Text('Tout marquer lu'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _refreshedOnce
                        ? 'Aucune notification.'
                        : 'Chargement des notifications…',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          else
            for (final notification in notifications)
              _NotificationTile(
                notification: notification,
                onTap: () => _markAsRead(notification),
              ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final CachedNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = notification.readAt == null;
    final color = switch (notification.status) {
      'danger' => GestaviTheme.danger,
      'warning' => GestaviTheme.warning,
      'success' => GestaviTheme.primary,
      _ => GestaviTheme.info,
    };

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          isUnread ? Icons.notifications_active : Icons.notifications_none,
          color: color,
        ),
        title: Text(
          notification.title ?? 'Notification',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.body?.isNotEmpty == true)
              Text(
                notification.body!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              _relative(notification.createdAt),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _relative(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return 'à l\'instant';
    }
    if (diff.inHours < 1) {
      return 'il y a ${diff.inMinutes} min';
    }
    if (diff.inDays < 1) {
      return 'il y a ${diff.inHours} h';
    }
    if (diff.inDays < 7) {
      return 'il y a ${diff.inDays} j';
    }

    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

String _frDate(String isoDate) {
  final parts = isoDate.split('-');

  return parts.length == 3 ? '${parts[2]}/${parts[1]}/${parts[0]}' : isoDate;
}
