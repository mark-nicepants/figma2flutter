import 'dart:convert';

import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  final input = '''
{
  "spacingDefault": {
    "value": "8px",
    "type": "spacing"
  },
  "radiusDefault": {
    "value": "12",
    "type": "borderRadius"
  },
  "mathTest": {
    "value": "{spacingDefault} * 2",
    "type": "borderRadius"
  },
  "bigger": {
    "value": "{radiusDefault} + 6",
    "type": "borderRadius"
  },
  "minus": {
    "value": "{radiusDefault} - -12",
    "type": "borderRadius"
  },
  "teenytiny": {
    "value": "{radiusDefault} / 6",
    "type": "borderRadius"
  },
  "2tokens": {
    "value": "{radiusDefault} / {radiusDefault}",
    "type": "borderRadius"
  }
}
''';

  test('Test dimension value math expressions', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final parsedValues = parser.resolvedTokens
        .map((e) => DimensionValue.maybeParse(e.value)?.value)
        .toList();

    expect(
      parsedValues,
      equals([8.0, 12.0, 16.0, 18.0, 24.0, 2.0, 1.0]),
    );
  });

  test('DimensionValue zero value is correct', () {
    expect(DimensionValue.zero.value, equals(0.0));
  });

  test('DivisionValue operator / divides value correctly', () {
    final value = DimensionValue(12.0) / 2;
    expect(value.value, equals(6.0));
  });
}
