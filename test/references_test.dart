import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

final input = '''
{
  "token": {
    "value": "#111111",
    "type": "color"
  },
  "group": {
    "type": "dimension",
    "token": {
      "value": "2rem"
    }
  },
  "token1": {
    "value": "\$token"
  },
  "token2": {
    "value": "{token}"
  },
  "token3": {
    "value": "\$group.token"
  },
  "token4": {
    "value": "{group.token}"
  }
}''';

/// https://tr.designtokens.org/format/#alias-reference
/// https://docs.tokens.studio/tokens/aliases
///
/// 3.8 Alias (reference)
///
/// To use an alias in your tokens, we write them in the following notation: {spacing.sm},
/// you can also write them in the older $ notation, like this: $spacing.sm

void main() {
  test('references with both annotations and within groups ', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(6));
    expect(parser.tokenMap['token']?.type, equals('color'));
    expect(parser.tokenMap['group.token']?.type, equals('dimension'));

    expect(parser.resolve('token1')?.type, equals('color'));
    expect(parser.resolve('token2')?.type, equals('color'));
    expect(parser.resolve('token3')?.type, equals('dimension'));
    expect(parser.resolve('token4')?.type, equals('dimension'));
  });
}
