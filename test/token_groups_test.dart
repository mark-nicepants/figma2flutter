import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

final input = '''
{
  "token uno": {
    "value": "#111111",
    "type": "color"
  },
  "token group": {
    "token dos": {
      "value": "2rem",
      "type": "dimension"
    },
    "nested token group": {
      "token tres": {
        "value": 33,
        "type": "number"
      },
      "Token cuatro": {
        "value": 444,
        "type": "fontWeight"
      }
    }
  }
}''';

void main() {
  test('if groups are correctly read', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.themes.first.tokens.length, equals(4));

    expect(
      parser.themes.first.tokens.keys,
      equals([
        'token uno',
        'token group.token dos',
        'token group.nested token group.token tres',
        'token group.nested token group.Token cuatro',
      ]),
    );
  });
}
