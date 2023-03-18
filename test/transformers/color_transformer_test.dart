import 'dart:convert';

import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
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
      transformer.transform(parser.tokenMap['hex']!),
      equals('const Color(0xFF111111)'),
    );
    expect(
      transformer.transform(parser.tokenMap['rgb']!),
      equals('const Color(0xFF000000)'),
    );
    expect(
      transformer.transform(parser.tokenMap['rgba']!),
      equals('const Color(0x80FF0000)'),
    );
    expect(
      transformer.transform(parser.tokenMap['hsla']!),
      equals('const Color(0x8040BF40)'),
    );
    expect(
      transformer.transform(parser.tokenMap['hslaCustom']!),
      equals('const Color(0x8040BF40)'),
    );
  });

  test('Invalid input on ColorTransformer.transform', () {
    final transformer = ColorTransformer();
    final invalid = Token(
      value: 'invalid',
      path: 'invalid',
      name: 'invalid',
      type: 'color',
    );
    expect(() => transformer.transform(invalid), throwsException);

    final nomatch = Token(
      value: 'wierdColor(3, 4,5)',
      type: 'color',
      path: 'path',
      name: 'name',
    );
    expect(transformer.matcher(nomatch), isFalse);
  });

  test(
    'Composition transformer inserts Composition widget and CompositionToken class',
    () {
      final transformer = CompositionTransformer();
      final classes = transformer.classDeclaration();

      expect(classes, contains('class Composition extends StatelessWidget'));
      expect(classes, contains('class CompositionToken'));
    },
  );
}
