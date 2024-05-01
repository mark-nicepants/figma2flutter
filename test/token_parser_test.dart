import 'dart:convert';

import 'package:figma2flutter/exceptions/theme_configuration_exception.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

final input = '''
{
  "dogs":{
    "corgi": {
      "value": "#888888",
      "type": "color"
    }

  },
  "cats":{
    "calico": {
      "value": "#111111",
      "type": "color"
    }
  }
}''';

void main() {
  test(
    'Themes loads because all metadata sets present',
    () {
      List<TokenTheme> themes = [
        TokenTheme('animals', ['dogs', 'cats']),
      ];
      List<String> metadata = ['dogs', 'cats'];

      final parsed = json.decode(input) as Map<String, dynamic>;
      final parser = TokenParser(metadata, themes)..parse(parsed);
      expect(parser.resolvedTokens(themeName: 'animals').length, equals(2));
    },
  );

  test(
    'Themes fail loading because of missing metadata',
    () {
      List<TokenTheme> themes = [
        TokenTheme('animals', ['dogs', 'cats', 'cows']),
      ];
      List<String> metadata = ['dogs', 'cats'];

      final parsed = json.decode(input) as Map<String, dynamic>;
      expect(
        () => TokenParser(metadata, themes)..parse(parsed),
        throwsA(isA<ThemeConfigurationException>()),
      );
    },
  );
}
