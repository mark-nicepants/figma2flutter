import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';
import 'package:meta/meta.dart';

class TokenTheme {
  final String name;
  final List<String> sets;

  final List<Transformer> transformers = [];

  @visibleForTesting
  final Map<String, Token> tokens = {};

  TokenTheme(this.name, this.sets);

  factory TokenTheme.fromJson(Map<String, dynamic> e, List<String> allSets) {
    final sets = <String>[];
    (e['selectedTokenSets'] as Map<String, dynamic>?)?.forEach((key, value) {
      if (value == 'source') sets.insert(0, key);
      if (value == 'enabled') sets.add(key);
    });

    return TokenTheme(e['name'] as String, sets);
  }

  /// Returns a list of all tokens that have been parsed and all references resolved.
  List<Token> get resolvedTokens => tokens.keys
      .map(resolve)
      .where((element) => element != null)
      .cast<Token>()
      .toList();

  // Fetch a token by key and resolve all references
  Token? resolve(String key) {
    Token? token = tokens[key];
    if (token == null) return null;

    try {
      return token.resolveAllReferences(tokens);
    } catch (e, stacktrace) {
      print('Originating exception stacktrace:\n$stacktrace');
      throw ResolveTokenException(
          '`$key` defined as `${tokens[key]}` - Originating $e');
    }
  }

  void addTokens(Map<String, Token> tokens) {
    this.tokens.addAll(tokens);
  }
}
