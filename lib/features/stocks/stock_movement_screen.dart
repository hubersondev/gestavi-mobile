import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../auth/auth_controller.dart';
import '../flocks/flock_repository.dart';
import 'stock_repository.dart';

/// Sortie (ou entrée) de stock saisie hors-ligne : quantité, motif, bande concernée facultative.
class StockMovementScreen extends ConsumerStatefulWidget {
  const StockMovementScreen({super.key, required this.stock});

  final CachedStock stock;

  @override
  ConsumerState<StockMovementScreen> createState() =>
      _StockMovementScreenState();
}

class _StockMovementScreenState extends ConsumerState<StockMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _notes = TextEditingController();
  bool _isOut = true;
  String _reason = 'consumption';
  int? _flockId;
  bool _saving = false;

  @override
  void dispose() {
    _quantity.dispose();
    _notes.dispose();
    super.dispose();
  }

  double get _parsedQuantity =>
      double.tryParse(_quantity.text.trim().replaceAll(',', '.')) ?? 0;

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final quantity = _parsedQuantity;

    if (_isOut && quantity > widget.stock.quantity) {
      _snack(
        'Sortie (${formatQuantity(quantity)}) supérieure au stock (${formatQuantity(widget.stock.quantity)} ${widget.stock.unit}).',
      );

      return;
    }

    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    final membership = session.membership!;

    if (!mounted) {
      return;
    }

    setState(() => _saving = true);
    FocusScope.of(context).unfocus();

    await ref
        .read(stockRepositoryProvider)
        .recordMovement(
          organisationId: membership.organisationId,
          stock: widget.stock,
          isOut: _isOut,
          quantity: quantity,
          reason: _reason,
          flockId: _flockId,
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        );

    final sent = await ref
        .read(syncQueueProvider)
        .pushQuietly(
          organisationId: membership.organisationId,
          organisationSlug: membership.slug,
        );

    if (!mounted) {
      return;
    }

    _snack(
      sent > 0
          ? 'Mouvement enregistré et synchronisé.'
          : 'Mouvement enregistré, il sera envoyé dès que le réseau revient.',
    );
    Navigator.of(context).pop();
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stock = widget.stock;
    final session = ref.watch(authControllerProvider).value;
    final flocks = session is Authenticated && session.membership != null
        ? ref
                  .watch(
                    flocksProvider((
                      organisationId: session.membership!.organisationId,
                      farmId: stock.farmId,
                    )),
                  )
                  .value ??
              const <CachedFlock>[]
        : const <CachedFlock>[];
    final reasons = _isOut ? stockOutReasons : stockInReasons;

    return Scaffold(
      appBar: AppBar(title: Text(stock.name)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'En stock : ${formatQuantity(stock.quantity)} ${stock.unit}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('Sortie'),
                  icon: Icon(Icons.remove_circle_outline),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('Entrée'),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
              selected: {_isOut},
              onSelectionChanged: (selection) => setState(() {
                _isOut = selection.single;
                _reason = _isOut ? 'consumption' : 'purchase';
              }),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantity,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Quantité',
                suffixText: stock.unit,
              ),
              validator: (value) {
                final parsed = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );

                return parsed == null || parsed <= 0
                    ? 'Quantité positive attendue'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(_isOut),
              initialValue: _reason,
              decoration: const InputDecoration(labelText: 'Motif'),
              items: [
                for (final entry in reasons.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (value) => setState(() => _reason = value ?? _reason),
            ),
            if (flocks.isNotEmpty) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _flockId,
                decoration: const InputDecoration(labelText: 'Bande concernée'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Aucune'),
                  ),
                  for (final flock in flocks)
                    DropdownMenuItem<int?>(
                      value: flock.id,
                      child: Text(
                        flock.name?.isNotEmpty == true
                            ? '${flock.code} · ${flock.name}'
                            : flock.code,
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _flockId = value),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLines: 2,
              maxLength: 1000,
              decoration: const InputDecoration(
                labelText: 'Remarques',
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
              label: Text(
                _isOut ? 'Enregistrer la sortie' : 'Enregistrer l\'entrée',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fonctionne sans réseau : le mouvement est conservé sur le téléphone et envoyé plus tard.',
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
