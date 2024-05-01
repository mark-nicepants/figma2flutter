import 'package:figma2flutter/exceptions/theme_configuration_exception.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:meta/meta.dart';

const kDefaultThemeName = 'default';

/// A parser that will parse a map of Design tokens and can resolve references
/// to other tokens (e.g. {color.primary})
class TokenParser {
  // Figma supports multiple sets. Sets are used to override tokens in a specific
  // set. This list is used to make sure that the overrides are applied in the
  // correct order.
  final List<String> sets;

  // List of themes, each theme contains a list of sets that are enabled.
  List<TokenTheme> themes;

  /// Creates a new [TokenParser] instance.
  TokenParser([
    this.sets = const [],
    this.themes = const [],
  ]);

  /// Parses the given json map recursively and saves the tokens in the [tokenMap].
  void parse(Map<String, dynamic> input) {
    if (themes.isEmpty) {
      themes = [TokenTheme(kDefaultThemeName, sets)];
    }

    for (final theme in themes) {
      final Map<String, dynamic> tokensForTheme;
      if (theme.sets.isEmpty) {
        tokensForTheme = input;
      } else {
        tokensForTheme = {};
        for (final set in theme.sets) {
          if (input[set] == null) {
            throw (ThemeConfigurationException(
              'No metadata entry named "$set" expected by theme "${theme.name}"',
            ));
          }
          tokensForTheme[set] = input[set] as Map<String, dynamic>;
        }
      }

      final tokens = findTokens('.', tokensForTheme);
      _postProcess(tokens);

      theme.addTokens(tokens);
    }
  }

  // Loop trough the ordered sets and remove the set name from key an path
  // this will make sure that overrides are properly applied
  void _postProcess(Map<String, Token> tokenMap) {
    for (var element in sets) {
      final set = '$element.';
      final setLength = set.length - 1;

      tokenMap.entries
          .where((element) => element.key.startsWith(set))
          .toList()
          .forEach((entry) {
        final key = entry.key;
        final value = entry.value;

        if (key.startsWith(set)) {
          tokenMap.remove(key);
          tokenMap[key.substring(setLength + 1)] = value.copyWith(
            path: value.path.substring(setLength),
          );
        }
      });
    }
  }

  // Recursively find all tokens in the given map
  Map<String, Token> findTokens(
    String parent,
    Map<String, dynamic> input, [
    String? groupType,
  ]) {
    final tokens = <String, Token>{};

    if (input.containsKey('value')) {
      final cleaned =
          parent.substring(0, parent.length - 1); // remove the trailing dot
      final name = cleaned.split('.').last;

      final end = cleaned.length - name.length - 1;
      final path = end > 0 ? cleaned.substring(1, end) : '';
      final token = Token(
        value: input['value'],
        type: input['type'] as String? ?? groupType,
        path: path,
        name: name,
        extensions: input['\$extensions'] as Map<String, dynamic>?,
      );

      return {
        [path, name].where((e) => e.isNotEmpty).join('.'): token,
      };
    }

    for (var entry in input.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        tokens.addAll(
          findTokens('$parent$key.', value, input['type'] as String?),
        );
      }
    }

    return tokens;
  }

  /// Returns a list of all tokens that have been parsed and all references resolved.
  List<Token> resolvedTokens({String themeName = kDefaultThemeName}) =>
      themes.firstWhere((element) => element.name == themeName).resolvedTokens;

  // Fetch a token by key and theme name and resolve all references
  @visibleForTesting
  Token? resolve(String key, [String theme = kDefaultThemeName]) {
    return themes.firstWhere((e) => e.name == theme).resolve(key);
  }
}
