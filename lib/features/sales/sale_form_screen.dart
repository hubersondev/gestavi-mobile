import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/ui/amount_input.dart';
import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_repository.dart';
import '../auth/models.dart';
import '../flocks/flock_repository.dart';
import '../stocks/stock_repository.dart';
import 'sale_repository.dart';

/// Vente rapide saisie hors-ligne : client (ou comptant), lignes produit × quantité × prix,
/// encaissement immédiat facultatif. La vente est conservée localement puis envoyée à l'API.
class SaleFormScreen extends ConsumerStatefulWidget {
  const SaleFormScreen({super.key});

  @override
  ConsumerState<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends ConsumerState<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lines = <_LineDraft>[_LineDraft()];
  final _paidAmount = TextEditingController();
  final _notes = TextEditingController();
  DateTime _date = DateTime.now();
  CachedCustomer? _customer;
  int? _farmId;
  List<FarmSummary> _farms = const [];
  bool _collectPayment = true;
  String _paymentMethod = 'cash';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadFarms());
  }

  @override
  void dispose() {
    for (final line in _lines) {
      line.dispose();
    }
    _paidAmount.dispose();
    _notes.dispose();
    super.dispose();
  }

  /// Quand l'utilisateur voit « toutes les fermes », il doit nommer celle qui vend.
  Future<void> _loadFarms() async {
    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    if (session.farmId != null) {
      setState(() => _farmId = session.farmId);

      return;
    }

    final farms = await ref
        .read(authRepositoryProvider)
        .farms(session.membership!);

    if (mounted) {
      setState(() {
        _farms = farms;
        _farmId = farms.length == 1 ? farms.single.id : null;
      });
    }
  }

  double get _subtotal =>
      _lines.fold<double>(0, (sum, line) => sum + line.total);

  List<SaleLine> _buildLines() => _lines
      .where((line) => line.isFilled)
      .map(
        (line) => SaleLine(
          productId: line.product?.id,
          productName: line.productName,
          unit: line.product?.unit,
          quantity: line.quantity,
          unitPrice: line.unitPrice,
          flockId: line.flock?.id,
          isLiveBirds: line.product?.isLiveBirds ?? false,
        ),
      )
      .toList();

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final lines = _buildLines();

    if (lines.isEmpty) {
      _snack('Ajoutez au moins une ligne avec un produit et une quantité.');

      return;
    }

    final shortage = _lines
        .where((line) => line.isFilled && line.availableQuantity != null)
        .where((line) => line.quantity > line.availableQuantity!)
        .firstOrNull;

    if (shortage != null) {
      _snack(
        'Stock insuffisant pour « ${shortage.productName} » : ${formatQuantity(shortage.quantity)} demandé(s), ${formatQuantity(shortage.availableQuantity!)} disponible(s).',
      );

      return;
    }

    if (lines.any((line) => line.isLiveBirds && line.flockId == null)) {
      _snack(
        'Indiquez la bande vendue sur chaque ligne de sujets vivants, sinon l\'effectif ne bouge pas.',
      );

      return;
    }

    if (_farmId == null) {
      _snack('Choisissez la ferme qui réalise la vente.');

      return;
    }

    final session = await ref.read(authControllerProvider.future);

    if (session is! Authenticated || session.membership == null) {
      return;
    }

    final membership = session.membership!;
    final total = _subtotal;
    final paid = parseAmount(_paidAmount.text);

    if (_collectPayment && paid != null && paid > total) {
      _snack('L\'encaissement dépasse le total de la vente.');

      return;
    }

    if (!mounted) {
      return;
    }

    setState(() => _saving = true);
    FocusScope.of(context).unfocus();

    await ref
        .read(saleRepositoryProvider)
        .createSale(
          organisationId: membership.organisationId,
          farmId: _farmId!,
          saleDate: _date,
          customerId: _customer?.id,
          customerName: _customer?.name,
          lines: lines,
          payment: _collectPayment
              ? SalePayment(method: _paymentMethod, amount: paid)
              : null,
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
          ? 'Vente enregistrée et synchronisée.'
          : 'Vente enregistrée, elle sera envoyée dès que le réseau revient.',
    );
    Navigator.of(context).pop();
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Date de la vente',
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(authControllerProvider).value;
    final organisationId = session is Authenticated
        ? session.membership?.organisationId
        : null;
    final customers = organisationId == null
        ? const <CachedCustomer>[]
        : ref.watch(customersProvider(organisationId)).value ?? const [];
    final products = organisationId == null
        ? const <CachedProduct>[]
        : ref.watch(productsProvider(organisationId)).value ?? const [];
    final stocks = organisationId == null
        ? const <CachedStock>[]
        : ref
                  .watch(
                    stocksProvider((
                      organisationId: organisationId,
                      farmId: _farmId,
                    )),
                  )
                  .value ??
              const [];
    final flocks = organisationId == null
        ? const <CachedFlock>[]
        : ref
                  .watch(
                    flocksProvider((
                      organisationId: organisationId,
                      farmId: _farmId,
                    )),
                  )
                  .value ??
              const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle vente')),
      // Défilement simple plutôt que ListView : une liste paresseuse démonte les champs hors
      // écran et leurs validations ne s'exécuteraient plus une fois la page défilée
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_farms.length > 1) ...[
                DropdownButtonFormField<int>(
                  initialValue: _farmId,
                  decoration: const InputDecoration(labelText: 'Ferme'),
                  items: [
                    for (final farm in _farms)
                      DropdownMenuItem(value: farm.id, child: Text(farm.name)),
                  ],
                  onChanged: (value) => setState(() => _farmId = value),
                  validator: (value) => value == null ? 'Obligatoire' : null,
                ),
                const SizedBox(height: 12),
              ],
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Date de la vente'),
                  subtitle: Text(_frDate(_date)),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _customer?.id,
                decoration: const InputDecoration(labelText: 'Client'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Client comptant'),
                  ),
                  for (final customer in customers)
                    DropdownMenuItem<int?>(
                      value: customer.id,
                      child: Text(customer.name),
                    ),
                ],
                onChanged: (value) => setState(
                  () => _customer = value == null
                      ? null
                      : customers.firstWhere((c) => c.id == value),
                ),
              ),
              const SizedBox(height: 20),
              Text('Lignes', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (var i = 0; i < _lines.length; i++) ...[
                _LineCard(
                  line: _lines[i],
                  products: products,
                  flocks: flocks,
                  stocks: stocks,
                  farmId: _farmId,
                  canRemove: _lines.length > 1,
                  onChanged: () => setState(() {}),
                  onRemove: () => setState(() => _lines.removeAt(i).dispose()),
                ),
                const SizedBox(height: 8),
              ],
              OutlinedButton.icon(
                onPressed: () => setState(() => _lines.add(_LineDraft())),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une ligne'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Total', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  Text(
                    formatXof(_subtotal),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Encaisser maintenant'),
                subtitle: const Text(
                  'Sinon la vente reste à crédit, à encaisser plus tard.',
                ),
                value: _collectPayment,
                onChanged: (value) => setState(() => _collectPayment = value),
              ),
              if (_collectPayment) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Mode de paiement',
                  ),
                  items: [
                    for (final entry in salePaymentMethods.entries)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _paymentMethod = value ?? 'cash'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _paidAmount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: const [ThousandsFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Montant encaissé',
                    helperText: 'Vide = la totalité de la vente',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }

                    final parsed = parseAmount(value);

                    return parsed == null || parsed <= 0
                        ? 'Montant positif attendu'
                        : null;
                  },
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
                label: const Text('Enregistrer la vente'),
              ),
              const SizedBox(height: 8),
              Text(
                'Fonctionne sans réseau : la vente est conservée sur le téléphone et envoyée plus tard.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: GestaviTheme.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne en cours de saisie ; le prix se pré-remplit depuis le catalogue mais reste modifiable.
class _LineDraft {
  CachedProduct? product;
  CachedFlock? flock;

  /// Quantité vendable d'après le stock en cache, null si le produit n'est pas suivi
  double? availableQuantity;
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String get productName => product?.name ?? '';

  double get quantity => parseAmount(quantityController.text) ?? 0;

  double get unitPrice => parseAmount(priceController.text) ?? 0;

  double get total => quantity * unitPrice;

  bool get isFilled => product != null && quantity > 0;

  void dispose() {
    quantityController.dispose();
    priceController.dispose();
  }
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.products,
    required this.flocks,
    required this.stocks,
    required this.farmId,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final _LineDraft line;
  final List<CachedProduct> products;
  final List<CachedFlock> flocks;
  final List<CachedStock> stocks;
  final int? farmId;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = line.product;
    final stock = product == null
        ? null
        : trackedStockFor(product, farmId, stocks);
    line.availableQuantity = product != null && stock != null
        ? sellableQuantity(product, stock)
        : null;
    final available = line.availableQuantity;
    final short = available != null && line.quantity > available;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: line.product?.id,
                    decoration: const InputDecoration(labelText: 'Produit'),
                    isExpanded: true,
                    items: [
                      for (final product in products)
                        DropdownMenuItem(
                          value: product.id,
                          child: Text(
                            product.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      line.product = products.firstWhere((p) => p.id == value);
                      if (line.priceController.text.trim().isEmpty ||
                          line.unitPrice == 0) {
                        line.priceController.text = formatAmountInput(
                          line.product!.unitPrice,
                        );
                      }
                      onChanged();
                    },
                    validator: (value) => value == null && line.quantity > 0
                        ? 'Produit obligatoire'
                        : null,
                  ),
                ),
                if (canRemove)
                  IconButton(
                    tooltip: 'Retirer la ligne',
                    icon: const Icon(Icons.close),
                    onPressed: onRemove,
                  ),
              ],
            ),
            if (line.product?.isLiveBirds == true) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: line.flock?.id,
                decoration: const InputDecoration(
                  labelText: 'Bande vendue',
                  helperText: 'Les sujets vendus sortent de l\'effectif',
                ),
                isExpanded: true,
                items: [
                  for (final flock in flocks)
                    DropdownMenuItem(
                      value: flock.id,
                      child: Text(
                        flock.name?.isNotEmpty == true
                            ? '${flock.code} · ${flock.name} (${flock.quantityCurrent})'
                            : '${flock.code} (${flock.quantityCurrent})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  line.flock = flocks.firstWhere((f) => f.id == value);
                  onChanged();
                },
                validator: (value) =>
                    value == null ? 'Bande obligatoire' : null,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: line.quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: const [ThousandsFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      suffixText: line.product?.unit,
                    ),
                    onChanged: (_) => onChanged(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      return parseAmount(value) == null
                          ? 'Nombre attendu'
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: line.priceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: const [ThousandsFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Prix unitaire',
                    ),
                    onChanged: (_) => onChanged(),
                  ),
                ),
              ],
            ),
            if (available != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  short
                      ? 'Stock insuffisant : ${formatQuantity(available)} ${product?.unit ?? ''} disponible(s)'
                      : 'En stock : ${formatQuantity(available)} ${product?.unit ?? ''}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: short ? GestaviTheme.danger : GestaviTheme.inkMuted,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatXof(line.total),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _frDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
