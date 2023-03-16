import 'package:figma2flutter/models/token.dart';
import 'package:meta/meta.dart';

/// A parser that will parse a map of Design tokens and can resolve references
/// to other tokens (e.g. {color.primary})
class TokenParser {
  // Figma supports multiple sets. Sets are used to override tokens in a specific
  // set. This list is used to make sure that the overrides are applied in the
  // correct order.
  final List<String> sets;

  // The raw map of tokens. The key is the path to the token and the value is the
  // token itself. Any references to other tokens are not resolved yet. The key
  // is used to resolve the references. See [TokenParser.resolvedTokens].
  @visibleForTesting
  final Map<String, Token> tokenMap = {};

  /// Creates a new [TokenParser] instance.
  TokenParser([this.sets = const []]);

  /// Parses the given json map recursively and saves the tokens in the [tokenMap].
  void parse(Map<String, dynamic> input) {
    tokenMap.addAll(findTokens('.', input));

    _postProcess();
  }

  // Loop trough the ordered sets and remove the set name from key an path
  // this will make sure that overrides are properly applied
  void _postProcess() {
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
      );

      return {
        [path, name].where((e) => e.isNotEmpty).join('.'): token
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
  List<Token> get resolvedTokens => tokenMap.keys
      .map(resolve)
      .where((element) => element != null)
      .cast<Token>()
      .toList();

  /// Fetch a reference while keeping the original variable name
  Token? _getReference(Token token) {
    final reference = tokenMap[token.valueByRef];

    // Keep original variable name when resolving reference
    return reference?.copyWith(variableName: token.variableName);
  }

  // Fetch a token by key and resolve all references
  @visibleForTesting
  Token? resolve(String key) {
    Token? token = tokenMap[key];
    if (token == null) return null;

    if (token.isReference == true) {
      token = _getReference(token);
    }

    token = token?.resolveValueReferences(tokenMap);

    return token;
  }
}
