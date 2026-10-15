import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../auth/auth_controller.dart';
import 'sale_repository.dart';

/// Encaissement d'une vente déjà synchronisée (à crédit ou partiellement payée), hors-ligne :
/// l'encaissement part dans la file et la vente locale reflète aussitôt le montant reçu.
class SalePaymentSheet extends ConsumerStatefulWidget {
  const SalePaymentSheet({super.key, required this.sale});

  final CachedSale sale;

  static Future<void> show(BuildContext context, CachedSale sale) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => SalePaymentSheet(sale: sale),
      );

  @override
  ConsumerState<SalePaymentSheet> createState() => _SalePaymentSheetState();
}

class _SalePaymentSheetState extends ConsumerState<SalePaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _amount = TextEditingController(
    text: _plain(widget.sale.total - widget.sale.paid),
  );
  String _method = 'cash';
  bool _saving = false;

  double get _balance => widget.sale.total - widget.sale.paid;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null || !mounted) {
      return;
    }

    final membership = session.membership!;
    final amount = double.parse(_amount.text.trim().replaceAll(',', '.'));

    setState(() => _saving = true);

    await ref
        .read(saleRepositoryProvider)
        .recordPayment(
          organisationId: membership.organisationId,
          sale: widget.sale,
          amount: amount,
          method: _method,
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

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent > 0
              ? 'Encaissement enregistré et synchronisé.'
              : 'Encaissement enregistré, envoi dès que le réseau revient.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Encaisser ${widget.sale.invoiceNumber ?? 'la vente'}',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Reste dû : ${formatXof(_balance)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Montant encaissé'),
              validator: (value) {
                final parsed = double.tryParse(
                  (value ?? '').trim().replaceAll(',', '.'),
                );

                if (parsed == null || parsed <= 0) {
                  return 'Montant positif attendu';
                }

                return parsed > _balance + 0.01
                    ? 'Supérieur au reste dû (${formatXof(_balance)})'
                    : null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: const InputDecoration(labelText: 'Mode de paiement'),
              items: [
                for (final entry in salePaymentMethods.entries)
                  DropdownMenuItem(value: entry.key, child: Text(entry.value)),
              ],
              onChanged: (value) => setState(() => _method = value ?? 'cash'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check),
              label: const Text('Enregistrer l’encaissement'),
            ),
          ],
        ),
      ),
    );
  }

  static String _plain(double value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
}
