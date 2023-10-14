import 'dart:convert';

import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/models/token.dart';
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
      throwsA(
        const TypeMatcher<ResolveTokenException>().having(
          (e) => e.toString(),
          'Has reference to correct token key',
          contains('invalidOperator'),
        ),
      ),
    );
  });

  test('Test variable name has special characters', () {
    // example pulled from zengarden json
    String value = 'linear-gradient(0deg, #9333ea 0%, #c084fc 100%)';
    String type = 'color';
    //String? groupType;
    String path = 'global.color.gradient.purple';
    String name = ' 0-deg-↑';
    //String? extension;
    // variable name is calculated so not provided

    Token aToken = Token(value: value, type: type, path: path, name: name);
    expect(aToken.variableName, equals('globalColorGradientPurple0Deg'));
  });

  test('Test variable path has spaces', () {
    // example pulled from zengarden json
    String value = 'linear-gradient(0deg, #9333ea 0%, #c084fc 100%)';
    String type = 'color';
    //String? groupType;
    String path = 'default theme dark';
    String name = ' 0-deg-↑';
    //String? extension;
    // variable name is calculated so not provided

    Token aToken = Token(value: value, type: type, path: path, name: name);
    expect(aToken.variableName, equals('defaultThemeDark0Deg'));
  });
}
