import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Test invalid math references throws errors', () {
    final input = '''
{
  "invalidOperator": {
    "value": "{spacingDefault} * 2",
    "type": "spacing"
  }
}
''';

    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(
      () => parser.resolve('invalidOperator'),
      throwsA(const TypeMatcher<FormatException>()),
    );
  });
}
