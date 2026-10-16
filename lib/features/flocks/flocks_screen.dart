import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../auth/auth_controller.dart';
import '../vaccinations/vaccination_repository.dart';
import '../vaccinations/vaccinations_screen.dart';
import 'daily_record_screen.dart';
import 'flock_repository.dart';

/// Mes bandes : effectif, âge, dernier relevé. Tirer pour rafraîchir depuis le serveur ;
/// sans réseau, la liste en cache reste utilisable et la saisie aussi.
class FlocksScreen extends ConsumerStatefulWidget {
  const FlocksScreen({super.key});

  @override
  ConsumerState<FlocksScreen> createState() => _FlocksScreenState();
}

class _FlocksScreenState extends ConsumerState<FlocksScreen> {
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
      final repository = ref.read(flockRepositoryProvider);
      await repository.refresh(
        organisationId: membership.organisationId,
        organisationSlug: membership.slug,
      );
      await repository.refreshDailyRecords(
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
    final flocks = ref.watch(flocksProvider(scope));

    return RefreshIndicator(
      onRefresh: _refresh,
      child: flocks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _Empty(text: 'Lecture locale impossible : $error'),
        data: (list) => list.isEmpty
            ? _Empty(
                text: _refreshedOnce
                    ? 'Aucune bande active sur cette ferme. Les bandes se créent depuis GESTAVI sur le web.'
                    : 'Chargement des bandes…',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _FlockCard(flock: list[index]),
              ),
      ),
    );
  }
}

class _FlockCard extends ConsumerWidget {
  const _FlockCard({required this.flock});

  final CachedFlock flock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = _today();
    final recordedToday = flock.lastRecordDate == today;
    final vaccinations =
        ref
            .watch(
              vaccinationsTodoProvider((
                organisationId: flock.organisationId,
                farmId: null,
                flockId: flock.id,
              )),
            )
            .value ??
        const [];
    final overdue = vaccinations.where((v) => v.isOverdue).length;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(GestaviTheme.radiusSurface),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DailyRecordScreen(flock: flock),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      flock.name?.isNotEmpty == true
                          ? '${flock.code} · ${flock.name}'
                          : flock.code,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  _Pill(
                    label: recordedToday ? 'Relevé fait' : 'À relever',
                    color: recordedToday
                        ? GestaviTheme.primary
                        : GestaviTheme.warning,
                  ),
                ],
              ),
              if (flock.farmName != null) ...[
                const SizedBox(height: 2),
                Text(
                  flock.farmName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _Stat(label: 'Effectif', value: _int(flock.quantityCurrent)),
                  _Stat(
                    label: 'Âge',
                    value: flock.ageDays == null ? '—' : '${flock.ageDays} j',
                  ),
                  _Stat(label: 'Type', value: _kindLabel(flock.kind)),
                  _Stat(
                    label: 'Dernier relevé',
                    value: flock.lastRecordDate == null
                        ? 'jamais'
                        : _shortDate(flock.lastRecordDate!),
                  ),
                ],
              ),
              if (forecastSummary(flock) case final summary?) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.insights_outlined,
                      size: 16,
                      color: GestaviTheme.info,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        summary,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: GestaviTheme.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => VaccinationsScreen(flock: flock),
                        ),
                      ),
                      icon: Icon(
                        Icons.vaccines_outlined,
                        size: 18,
                        color: overdue > 0 ? GestaviTheme.danger : null,
                      ),
                      label: Text(
                        vaccinations.isEmpty
                            ? 'Vaccins'
                            : overdue > 0
                            ? 'Vaccins · $overdue en retard'
                            : 'Vaccins · ${vaccinations.length} à faire',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DailyRecordScreen(flock: flock),
                        ),
                      ),
                      icon: const Icon(Icons.edit_note, size: 18),
                      label: const Text('Relevé'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _kindLabel(String kind) => switch (kind) {
    'layer' || 'layers' || 'eggs' => 'Pondeuses',
    'meat' || 'broiler' || 'broilers' => 'Chair',
    'mixed' => 'Mixte',
    _ => kind,
  };
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
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
    // ListView pour que le tirer-pour-rafraîchir fonctionne même sur une liste vide
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.egg_outlined,
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

String _today() {
  final now = DateTime.now();

  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

String _shortDate(String isoDate) {
  final parts = isoDate.split('-');

  return parts.length == 3 ? '${parts[2]}/${parts[1]}' : isoDate;
}

String _int(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(digits[i]);
  }

  return buffer.toString();
}
