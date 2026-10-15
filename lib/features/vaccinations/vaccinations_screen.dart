import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../auth/auth_controller.dart';
import '../flocks/flock_repository.dart' show networkMessage;
import 'vaccination_repository.dart';

/// Vaccinations et traitements à faire sur une bande ; chacun se valide d'un geste, sans réseau.
class VaccinationsScreen extends ConsumerStatefulWidget {
  const VaccinationsScreen({super.key, required this.flock});

  final CachedFlock flock;

  @override
  ConsumerState<VaccinationsScreen> createState() => _VaccinationsScreenState();
}

class _VaccinationsScreenState extends ConsumerState<VaccinationsScreen> {
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

    try {
      await ref
          .read(vaccinationRepositoryProvider)
          .refresh(
            organisationId: session.membership!.organisationId,
            organisationSlug: session.membership!.slug,
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
    }
  }

  Future<void> _markDone(CachedVaccination vaccination) async {
    final result = await showDialog<_DoneInput>(
      context: context,
      builder: (_) =>
          _DoneDialog(vaccination: vaccination, flock: widget.flock),
    );

    if (result == null) {
      return;
    }

    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    final membership = session.membership!;
    await ref
        .read(vaccinationRepositoryProvider)
        .markDone(
          organisationId: membership.organisationId,
          vaccination: vaccination,
          administeredDate: result.date,
          birdsTreated: result.birdsTreated,
          observations: result.observations,
        );
    final sent = await ref
        .read(syncQueueProvider)
        .pushQuietly(
          organisationId: membership.organisationId,
          organisationSlug: membership.slug,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sent > 0
                ? '${vaccination.treatmentName} validée et synchronisée.'
                : '${vaccination.treatmentName} validée, envoi dès que le réseau revient.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;
    final theme = Theme.of(context);

    if (session is! Authenticated || session.membership == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final todo = ref.watch(
      vaccinationsTodoProvider((
        organisationId: session.membership!.organisationId,
        farmId: null,
        flockId: widget.flock.id,
      )),
    );
    final canMark = session.membership!.permissions.contains(
      'vaccinations.mark_done',
    );

    return Scaffold(
      appBar: AppBar(title: Text('Vaccins · ${widget.flock.code}')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: todo.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [Text('Lecture locale impossible : $error')],
          ),
          data: (list) => list.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 48),
                    Icon(
                      Icons.vaccines_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aucune vaccination en attente sur cette bande.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _VaccinationTile(
                    vaccination: list[index],
                    onDone: canMark ? () => _markDone(list[index]) : null,
                  ),
                ),
        ),
      ),
    );
  }
}

class _VaccinationTile extends StatelessWidget {
  const _VaccinationTile({required this.vaccination, this.onDone});

  final CachedVaccination vaccination;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = vaccination.isOverdue
        ? GestaviTheme.danger
        : GestaviTheme.warning;

    return Card(
      child: ListTile(
        leading: Icon(Icons.vaccines_outlined, color: color),
        title: Text(vaccination.treatmentName),
        subtitle: Text(
          [
            treatmentTypeLabel(vaccination.treatmentType),
            'prévu le ${_frDate(vaccination.scheduledDate)}',
            if (vaccination.isOverdue) 'en retard',
            if (vaccination.administrationRoute != null)
              vaccination.administrationRoute!,
          ].join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: vaccination.isOverdue ? color : null,
          ),
        ),
        trailing: onDone == null
            ? null
            : FilledButton.tonal(onPressed: onDone, child: const Text('Faite')),
      ),
    );
  }
}

/// Saisie retournée par la boîte de validation.
class _DoneInput {
  const _DoneInput({
    required this.date,
    this.birdsTreated,
    this.observations,
  });

  final DateTime date;
  final int? birdsTreated;
  final String? observations;
}

class _DoneDialog extends StatefulWidget {
  const _DoneDialog({required this.vaccination, required this.flock});

  final CachedVaccination vaccination;
  final CachedFlock flock;

  @override
  State<_DoneDialog> createState() => _DoneDialogState();
}

class _DoneDialogState extends State<_DoneDialog> {
  late final _birds = TextEditingController(
    text: widget.flock.quantityCurrent.toString(),
  );
  final _observations = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _birds.dispose();
    _observations.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      helpText: 'Date d’administration',
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.vaccination.treatmentName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Administrée le'),
            subtitle: Text(_frDate(VaccinationRepository.isoDate(_date))),
            trailing: const Icon(Icons.edit_outlined),
            onTap: _pickDate,
          ),
          TextField(
            controller: _birds,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Sujets traités'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _observations,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Observations'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            _DoneInput(
              date: _date,
              birdsTreated: int.tryParse(_birds.text.trim()),
              observations: _observations.text.trim().isEmpty
                  ? null
                  : _observations.text.trim(),
            ),
          ),
          child: const Text('Valider'),
        ),
      ],
    );
  }
}

String _frDate(String isoDate) {
  final parts = isoDate.split('-');

  return parts.length == 3 ? '${parts[2]}/${parts[1]}/${parts[0]}' : isoDate;
}
