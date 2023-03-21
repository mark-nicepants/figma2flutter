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

final colorModifiers = '''
{
  "purple": {
    "value": "#6400FF",
    "type": "color"
  },
  "lighten-test": {
    "value": "{purple}",
    "type": "color",
    "\$extensions": {
      "studio.tokens": {
        "modify": {
          "type": "lighten",
          "value": "0.5",
          "space": "lch"
        }
      }
    }
  },
  "darken-test": {
    "value": "{purple}",
    "type": "color",
    "\$extensions": {
      "studio.tokens": {
        "modify": {
          "type": "darken",
          "value": "0.5",
          "space": "lch"
        }
      }
    }
  },
  "mix-test": {
    "value": "{purple}",
    "type": "color",
    "\$extensions": {
      "studio.tokens": {
        "modify": {
          "type": "mix",
          "value": "0.5",
          "space": "lch",
          "color": "#ff00c7"
        }
      }
    }
  }
}
''';

void main() {
  test('Test all color transformer output variants', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.resolvedTokens().length, equals(5));
    expect(parser.themes.first.tokens['hex']?.type, equals('color'));
    expect(parser.themes.first.tokens['rgb']?.type, equals('color'));
    expect(parser.themes.first.tokens['rgba']?.type, equals('color'));
    expect(parser.themes.first.tokens['hsla']?.type, equals('color'));

    final transformer = ColorTransformer();
    expect(
      transformer.transform(parser.themes.first.tokens['hsla']!),
      equals('const Color(0x8040BF40)'),
    );
    expect(
      transformer.transform(parser.themes.first.tokens['hex']!),
      equals('const Color(0xFF111111)'),
    );
    expect(
      transformer.transform(parser.themes.first.tokens['rgb']!),
      equals('const Color(0xFF000000)'),
    );
    expect(
      transformer.transform(parser.themes.first.tokens['rgba']!),
      equals('const Color(0x80FF0000)'),
    );

    expect(
      transformer.transform(parser.themes.first.tokens['hslaCustom']!),
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

  test('Color modifiers lighten/darken/mix', () {
    final parsed = json.decode(colorModifiers) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final transformer = ColorTransformer();

    expect(
      transformer.transform(parser.resolve('lighten-test')!),
      equals('const Color(0xFFB280FF)'),
    );
    expect(
      transformer.transform(parser.resolve('darken-test')!),
      equals('const Color(0xFF320080)'),
    );
    expect(
      transformer.transform(parser.resolve('mix-test')!),
      equals('const Color(0xFFB200E3)'),
    );
  });
}
