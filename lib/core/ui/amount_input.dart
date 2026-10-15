import 'package:flutter/services.dart';

/// Saisie de montants et de quantités lisible : les milliers sont séparés par une espace au fur
/// et à mesure de la frappe (« 1 250 000 »), la virgule sert de séparateur décimal (2 décimales).
class ThousandsFormatter extends TextInputFormatter {
  const ThousandsFormatter({this.decimals = 2});

  /// Nombre de décimales acceptées (0 = entier seulement).
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(RegExp(r'[\s  ]'), '');

    if (raw.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // Seuls chiffres et une virgule (ou un point, converti) sont acceptés
    final cleaned = raw.replaceAll('.', ',').replaceAll(RegExp(r'[^0-9,]'), '');
    final commaIndex = cleaned.indexOf(',');
    var integerPart = commaIndex < 0
        ? cleaned
        : cleaned.substring(0, commaIndex);
    var decimalPart = commaIndex < 0
        ? null
        : cleaned.substring(commaIndex + 1).replaceAll(',', '');

    if (decimals == 0) {
      decimalPart = null;
    } else if (decimalPart != null && decimalPart.length > decimals) {
      decimalPart = decimalPart.substring(0, decimals);
    }

    integerPart = integerPart.replaceFirst(RegExp(r'^0+(?=\d)'), '');

    final formatted = decimalPart == null
        ? groupThousands(integerPart)
        : '${groupThousands(integerPart.isEmpty ? '0' : integerPart)},$decimalPart';

    // Curseur en fin de saisie : le regroupement déplace les chiffres, la position exacte
    // n'a pas de sens pour l'utilisateur
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// « 1250000 » → « 1 250 000 ».
  static String groupThousands(String digits) {
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }
}

/// Valeur numérique d'un champ formaté (espaces de milliers, virgule décimale), null si vide ou
/// invalide.
double? parseAmount(String text) {
  final cleaned = text.replaceAll(RegExp(r'[\s  ]'), '').replaceAll(',', '.');

  return cleaned.isEmpty ? null : double.tryParse(cleaned);
}

/// Texte initial d'un champ de montant : « 2 500 » ou « 118,50 ».
String formatAmountInput(double value) {
  final isWhole = value % 1 == 0;
  final fixed = value.abs().toStringAsFixed(isWhole ? 0 : 2);
  final parts = fixed.split('.');
  final grouped = ThousandsFormatter.groupThousands(parts.first);
  final sign = value < 0 ? '-' : '';

  return parts.length == 2 ? '$sign$grouped,${parts[1]}' : '$sign$grouped';
}
