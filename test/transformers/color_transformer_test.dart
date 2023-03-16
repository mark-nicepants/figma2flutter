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
  },
  "hslaCustom": {
    "value": "hsla(120, 50%, 50%, 0.5)",
    "type": "customType"
  }
}''';

void main() {
  test('Test all color transformer output variants', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.resolvedTokens.length, equals(5));
    expect(parser.tokenMap['hex']?.type, equals('color'));
    expect(parser.tokenMap['rgb']?.type, equals('color'));
    expect(parser.tokenMap['rgba']?.type, equals('color'));
    expect(parser.tokenMap['hsla']?.type, equals('color'));

    final transformer = ColorTransformer();
    expect(
      transformer.transform(parser.tokenMap['hex']!.value),
      equals('const Color(0xFF111111)'),
    );
    expect(
      transformer.transform(parser.tokenMap['rgb']!.value),
      equals('const Color(0xFF000000)'),
    );
    expect(
      transformer.transform(parser.tokenMap['rgba']!.value),
      equals('const Color(0x80FF0000)'),
    );
    expect(
      transformer.transform(parser.tokenMap['hsla']!.value),
      equals('const Color(0x8040BF40)'),
    );
    expect(
      transformer.transform(parser.tokenMap['hslaCustom']!.value),
      equals('const Color(0x8040BF40)'),
    );
  });

  test('Invalid input on ColorTransformer.transform', () {
    final transformer = ColorTransformer();
    expect(() => transformer.transform('invalid'), throwsException);
  });
}
