import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/material_color_transformer.dart';
import 'package:test/test.dart';

void main() {
  test('Test if we can detect material colors and generate them', () {
    final raw = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(raw);

    final transformer = MaterialColorTransformer(parser.resolvedTokens());
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.colorTokensByName.keys.length, equals(1));
    expect(transformer.colorTokensByName['primary'], isNotNull);
    expect(transformer.colorTokensByName['primary']!.length, equals(10));

    expect(transformer.colorTokensByName['primary']![0].digit, equals(50));
    expect(
      transformer.colorTokensByName['primary']![0].color.toString(),
      equals('const Color(0xFFF0FAFF)'),
    );

    transformer.postProcess();

    expect(transformer.lines.length, equals(1));
    expect(
      transformer.lines[0],
      equals('''
MaterialColor get primary => const MaterialColor(0xFF0EA5E9, {
  50: Color(0xFFF0FAFF),
  100: Color(0xFFE0F5FE),
  200: Color(0xFFBAE8FD),
  300: Color(0xFF7DD5FC),
  400: Color(0xFF38BCF8),
  500: Color(0xFF0EA5E9),
  600: Color(0xFF028AC7),
  700: Color(0xFF0370A1),
  800: Color(0xFF075E85),
  900: Color(0xFF0C506E),
});
'''),
    );
  });
}

final input = '''
{
  "singularColor": {
    "value": "#111111",
    "type": "color"
  },
  "primary": {
      "50": {
        "value": "#f0faff",
        "type": "color"
      },
      "100": {
        "value": "#e0f5fe",
        "type": "color"
      },
      "200": {
        "value": "#bae8fd",
        "type": "color"
      },
      "300": {
        "value": "#7dd5fc",
        "type": "color"
      },
      "400": {
        "value": "#38bcf8",
        "type": "color"
      },
      "500": {
        "value": "#0ea5e9",
        "type": "color"
      },
      "600": {
        "value": "#028ac7",
        "type": "color"
      },
      "700": {
        "value": "#0370a1",
        "type": "color"
      },
      "800": {
        "value": "#075e85",
        "type": "color"
      },
      "900": {
        "value": "#0c506e",
        "type": "color"
      }
    }
}
''';
