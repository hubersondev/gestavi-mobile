import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../auth/auth_controller.dart';
import 'flock_repository.dart';

/// Relevé du jour d'une bande, saisi hors-ligne : la saisie part dans la file de synchronisation,
/// le cache de la bande est mis à jour aussitôt, et l'envoi est tenté dans la foulée si le réseau répond.
class DailyRecordScreen extends ConsumerStatefulWidget {
  const DailyRecordScreen({super.key, required this.flock});

  final CachedFlock flock;

  @override
  ConsumerState<DailyRecordScreen> createState() => _DailyRecordScreenState();
}

class _DailyRecordScreenState extends ConsumerState<DailyRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mortality = TextEditingController(text: '0');
  final _culls = TextEditingController(text: '0');
  final _eggs = TextEditingController();
  final _eggsBroken = TextEditingController();
  final _feed = TextEditingController();
  final _water = TextEditingController();
  final _weight = TextEditingController();
  final _weighed = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [
      _mortality,
      _culls,
      _eggs,
      _eggsBroken,
      _feed,
      _water,
      _weight,
      _weighed,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Corps envoyé au serveur ; les champs vides sont omis.
  Map<String, dynamic> buildPayload() {
    int? asInt(TextEditingController c) =>
        c.text.trim().isEmpty ? null : int.tryParse(c.text.trim());
    double? asNum(TextEditingController c) => c.text.trim().isEmpty
        ? null
        : double.tryParse(c.text.trim().replaceAll(',', '.'));

    final payload = <String, dynamic>{
      'flock_id': widget.flock.id,
      'record_date': _isoDate(_date),
      'mortality': asInt(_mortality) ?? 0,
      'culls': asInt(_culls) ?? 0,
      'eggs_collected': widget.flock.tracksEggs ? asInt(_eggs) : null,
      'eggs_broken': widget.flock.tracksEggs ? asInt(_eggsBroken) : null,
      'feed_consumed_kg': asNum(_feed),
      'water_consumed_l': asNum(_water),
      'average_weight_g': widget.flock.tracksWeight ? asNum(_weight) : null,
      'birds_weighed': widget.flock.tracksWeight ? asInt(_weighed) : null,
      'notes': _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    };

    payload.removeWhere((_, value) => value == null);

    return payload;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // La session est attendue plutôt que lue : le contrôleur peut encore se charger
    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    final membership = session.membership!;
    final payload = buildPayload();
    final losses = (payload['mortality'] as int) + (payload['culls'] as int);

    if (losses > widget.flock.quantityCurrent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pertes (${losses}) supérieures à l\'effectif (${widget.flock.quantityCurrent}).',
          ),
        ),
      );

      return;
    }

    setState(() => _saving = true);
    FocusScope.of(context).unfocus();

    final queue = ref.read(syncQueueProvider);
    await queue.enqueue(
      organisationId: membership.organisationId,
      type: 'daily_record',
      payload: payload,
      recordedAt: DateTime.now(),
    );
    await ref
        .read(flockRepositoryProvider)
        .applyLocalRecord(
          flockId: widget.flock.id,
          recordDate: payload['record_date'] as String,
          losses: losses,
        );

    final sent = await queue.pushQuietly(
      organisationId: membership.organisationId,
      organisationSlug: membership.slug,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent > 0 ? 'Relevé enregistré et synchronisé.' : 'Relevé enregistré, il sera synchronisé dès que le réseau revient.',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      helpText: 'Date du relevé',
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final flock = widget.flock;

    return Scaffold(
      appBar: AppBar(title: Text('Relevé · ${flock.code}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Date du relevé'),
                subtitle: Text(_frDate(_date)),
                trailing: const Icon(Icons.edit_outlined),
                onTap: _pickDate,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Effectif actuel : ${flock.quantityCurrent} sujets',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _IntField(
                    controller: _mortality,
                    label: 'Mortalité',
                    required: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _IntField(
                    controller: _culls,
                    label: 'Réformes',
                    required: true,
                  ),
                ),
              ],
            ),
            if (flock.tracksEggs) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _IntField(
                      controller: _eggs,
                      label: 'Œufs collectés',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IntField(
                      controller: _eggsBroken,
                      label: 'Œufs cassés',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _NumField(controller: _feed, label: 'Aliment (kg)'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NumField(controller: _water, label: 'Eau (L)'),
                ),
              ],
            ),
            if (flock.tracksWeight) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _NumField(
                      controller: _weight,
                      label: 'Poids moyen (g)',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IntField(
                      controller: _weighed,
                      label: 'Sujets pesés',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Observations',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: const Text('Enregistrer le relevé'),
            ),
            const SizedBox(height: 8),
            Text(
              'Fonctionne sans réseau : le relevé est conservé sur le téléphone et envoyé plus tard.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: GestaviTheme.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntField extends StatelessWidget {
  const _IntField({
    required this.controller,
    required this.label,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return required ? 'Obligatoire' : null;
        }

        return int.tryParse(value.trim()) == null
            ? 'Nombre entier attendu'
            : null;
      },
    );
  }
}

class _NumField extends StatelessWidget {
  const _NumField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return null;
        }

        return double.tryParse(value.trim().replaceAll(',', '.')) == null
            ? 'Nombre attendu'
            : null;
      },
    );
  }
}

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String _frDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
