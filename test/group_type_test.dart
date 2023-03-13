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
    "type": "dimension",
    "token dos": {
      "value": "2rem"
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

/// https://tr.designtokens.org/format/#type-0
/// 5.4 Type
///
/// The $type property can be set on different levels:
// at the group level
// at the token level

void main() {
  test('that groups can have a type and that missing token types refer to the group type', () {
    final parsed = json.decode(input);
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(4));
    expect(parser.tokenMap['token uno']?.type, equals('color'));
    expect(parser.tokenMap['token group.token dos']?.type, equals('dimension'));
    expect(parser.tokenMap['token group.nested token group.token tres']?.type, equals('number'));
    expect(parser.tokenMap['token group.nested token group.Token cuatro']?.type, equals('fontWeight'));
  });
}
