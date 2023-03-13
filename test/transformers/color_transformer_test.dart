import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
  "hex": {
    "value": "#111111",
    "type": "color"
  },
  "rgb": {
    "value": "rgb(0, 0, 0)",
    "type": "color"
  },
  "rgba": {
    "value": "rgba(255, 0, 0, 0.5)",
    "type": "color"
  },
  "hsla": {
    "value": "hsla(120, 50%, 50%, 0.5)",
    "type": "color"
  }
}''';

void main() {
  test('Test all color transformer output variants', () {
    final parsed = json.decode(input);
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(4));
    expect(parser.tokenMap['hex']?.type, equals('color'));
    expect(parser.tokenMap['rgb']?.type, equals('color'));
    expect(parser.tokenMap['rgba']?.type, equals('color'));
    expect(parser.tokenMap['hsla']?.type, equals('color'));

    final transformer = ColorTransformer();
    expect(transformer.transform(parser.tokenMap['hex']!.value), equals('Color(0xFF111111)'));
    expect(transformer.transform(parser.tokenMap['rgb']!.value), equals('Color.fromRGBO(0, 0, 0, 1.0)'));
    expect(transformer.transform(parser.tokenMap['rgba']!.value), equals('Color.fromRGBO(255, 0, 0, 0.5)'));
    expect(transformer.transform(parser.tokenMap['hsla']!.value),
        equals('HSLColor.fromAHSL(0.5, 120, 50%, 50%).toColor()'));
  });
}
