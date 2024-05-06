import 'dart:convert';

import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/sizing_value.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  // Future: remote the spacing around the '/' and '*'
  final input = '''
{
  "sizing-base": {
    "value": "16",
    "type": "sizing"
  },
  "sizing-xxxsmall": {
    "value": "{sizing-base} / 8",
    "type": "sizing"
  },
  "sizing-small": {
    "value": "{sizing-base}",
    "type": "sizing"
  },
  "sizing-medium": {
    "value": "{sizing-base} * 2",
    "type": "sizing"
  }
}
''';
  // Note that the parser will return 0.0 if the
  // math operators are not surrounded by spaces
  // Remove the space next to '/' or '*' and this will fail
  test('Test sizing value math expressions', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final parsedValues = parser
        .resolvedTokens()
        .map((e) => SizingValue.maybeParse(e.value)?.width)
        .toList();

    expect(
      parsedValues,
      equals([
        DimensionValue(16.0),
        DimensionValue(2.0),
        DimensionValue(16.0),
        DimensionValue(32.0),
      ]),
    );
  });

  test('SizeValue with 2 different values returns valid size', () {
    final size = SizingValue.maybeParse({
      'width': 12.0,
      'height': 24.0,
    });
    expect(size?.width?.value, equals(12.0));
    expect(size?.height?.value, equals(24.0));
    expect(size.toString(), equals('Size(12.0, 24.0)'));
  });
}
