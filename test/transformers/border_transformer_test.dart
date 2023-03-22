import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/border_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
  "border": {
    "heavy": {
      "type": "border",
      "value": {
        "color": "#36363600",
        "width": "3px",
        "style": "solid"
      }
    },
    "focusring": {
      "type": "border",
      "value": {
        "color": "#FF00FF",
        "width": "1px",
        "style": "dashed"
      }
    }
  }
}
''';

void main() {
  test('Test border tokens transformer', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens().length, equals(2));
    expect(parser.themes.first.tokens['border.heavy']?.type, equals('border'));

    final transformer = BorderTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.lines.length, equals(2));
    expect(
      transformer.lines[0],
      contains(
        'Border get borderHeavy => Border.all(color: const Color(0x00363636), width: 3.0, style: BorderStyle.solid);',
      ),
    );
    expect(
      transformer.lines[1],
      contains(
        'Border get borderFocusring => Border.all(color: const Color(0xFFFF00FF), width: 1.0, style: BorderStyle.solid);',
      ),
    );
  });
}
