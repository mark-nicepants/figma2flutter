import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/box_shadow_transformer.dart';
import 'package:test/test.dart';

void main() {
  test('Test single shadow ', () {
    final single = '''
{
  "defaultShadow": {
    "value": {
      "x": "0",
      "y": "8",
      "blur": "16",
      "spread": "0",
      "color": "rgba(0,0,0,0.55)",
      "type": "dropShadow"
    },
    "type": "boxShadow"
  }
}
''';

    final parsed = json.decode(single) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens().length, equals(1));
    expect(
      parser.themes.first.tokens['defaultShadow']?.type,
      equals('boxShadow'),
    );

    final transformer = BoxShadowTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.lines.length, equals(1));
    expect(
      transformer.lines.first,
      contains(
        '''
List<BoxShadow> get defaultShadow => const [
  BoxShadow(
    offset: Offset(0.0, 8.0),
    blurRadius: 16.0,
    spreadRadius: 0.0,
    color: Color(0x8C000000),
  ),
];''',
      ),
    );
  });

  test('Test multiple shadows', () {
    final multiple = '''
{
  "brand": {
    "500": {
      "value": "#007AFF",
      "type": "color"
    }
  },
  "my-shadow-tokens": {
    "default": {
      "value": [
        {
          "x": 5,
          "y": 5,
          "spread": 3,
          "color": "rgba({brand.500}, 0.15)",
          "blur": 5,
          "type": "dropShadow"
        },
        {
          "x": 4,
          "y": 4,
          "spread": 6,
          "color": "#00000033",
          "blur": 5,
          "type": "dropShadow"
        }
      ],
      "type": "boxShadow"
    }
  }
}
''';

    final parsed = json.decode(multiple) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens().length, equals(2));
    expect(
      parser.themes.first.tokens['my-shadow-tokens.default']?.type,
      equals('boxShadow'),
    );

    final transformer = BoxShadowTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.lines.length, equals(1));
    expect(
      transformer.lines.first,
      contains(
        '''
List<BoxShadow> get myShadowTokensDefault => const [
  BoxShadow(
    offset: Offset(5.0, 5.0),
    blurRadius: 5.0,
    spreadRadius: 3.0,
    color: Color(0x26007AFF),
  ),
  BoxShadow(
    offset: Offset(4.0, 4.0),
    blurRadius: 5.0,
    spreadRadius: 6.0,
    color: Color(0x33000000),
  ),
];''',
      ),
    );
  });
}
