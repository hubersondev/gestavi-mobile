import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/ui/amount_input.dart';

TextEditingValue _type(String text, {int decimals = 2}) =>
    ThousandsFormatter(decimals: decimals).formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      ),
    );

void main() {
  test('groupe les milliers pendant la frappe', () {
    expect(_type('1').text, '1');
    expect(_type('1250').text, '1 250');
    expect(_type('1250000').text, '1 250 000');
    expect(_type('1 250 00').text, '125 000');
    expect(_type('1250000').selection.baseOffset, 9);
  });

  test(
    'accepte une virgule décimale, limite les décimales et convertit le point',
    () {
      expect(_type('118,5').text, '118,5');
      expect(_type('118.5').text, '118,5');
      expect(_type('2500,999').text, '2 500,99');
      expect(_type(',5').text, '0,5');
      expect(_type('12,', decimals: 0).text, '12');
    },
  );

  test('ignore les caractères parasites et les zéros de tête', () {
    expect(_type('abc').text, '');
    expect(_type('007').text, '7');
    expect(_type('0').text, '0');
    expect(_type('12a3').text, '123');
  });

  test('parseAmount relit un champ formaté', () {
    expect(parseAmount('1 250 000'), 1250000);
    expect(parseAmount('118,5'), 118.5);
    expect(parseAmount(''), isNull);
    expect(parseAmount('abc'), isNull);
  });

  test('formatAmountInput prépare le texte initial', () {
    expect(formatAmountInput(2500), '2 500');
    expect(formatAmountInput(118.5), '118,50');
    expect(formatAmountInput(1050000), '1 050 000');
  });
}
