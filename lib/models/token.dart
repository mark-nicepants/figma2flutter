import 'package:figma2flutter/extensions/string.dart';

/// A [Token] represents a single token in the json file.
/// It holds the value, the type, the path and the name of the token and it
/// also holds the name of the variable that will be generated for this token.
///
/// A token can hold a reference to another token directly or indirectly when
/// one of the values in the values Map is a reference.
class Token {
  /// Create a new [Token] instance
  Token({
    required this.value,
    required this.type,
    required this.path,
    required this.name,
    String? variableName,
  }) : variableName = variableName ?? _getVariableName(path, name);

  /// The value this token holds
  final dynamic value;

  // Can be null when the token is a reference
  final String? type;

  /// The path where this token was found in the json file
  final String path;

  /// The name of the token
  final String name;

  /// The name of the variable that will be generated for this token
  /// Based on the path and name of the token
  final String variableName;

  /// The value of the token as a string
  String? get valueAsString => value as String?;

  /// Check if the token is a reference to another token
  bool get isReference => value is String && (value as String).isReference;

  /// The name of the token that is referenced without the leading '$'
  /// or '{' and '}' characters
  String get valueByRef => (value as String).valueByRef;

  /// Returns a copy of this token with the given values. If the path is set,
  /// the variable name will be updated as well.
  Token copyWith({String? path, String? variableName, dynamic value}) {
    if (path != null && variableName == null) {
      variableName = _getVariableName(path, name);
    }

    return Token(
      name: name,
      type: type,
      value: value ?? this.value,
      path: path ?? this.path,
      variableName: variableName ?? this.variableName,
    );
  }

  /// Resolves all references in the value of this token.
  /// This is done recursively in case the value Map has a Map as value as well.
  ///
  /// Example:
  ///
  /// ```json
  /// {
  ///   "colors": {
  ///     "primary": {
  ///       "value": "#FF0000",
  ///       "type": "color"
  ///     }
  ///   },
  ///   "component": {
  ///     "value": {
  ///       "color": "$colors.primary"
  ///     },
  ///     "type": "component"
  ///   }
  /// }
  /// ```
  Token? resolveValueReferences(Map<String, Token> tokenMap) {
    // Loop through all values and resolve references recursively
    if (value is Map<String, dynamic>) {
      final resolved = _resolvedValue(value as Map<String, dynamic>, tokenMap);
      return copyWith(value: resolved);
    }

    return this;
  }

  /// Resolves all references in the given value Map recursively.
  Map<String, dynamic> _resolvedValue(
    Map<String, dynamic> value,
    Map<String, Token> tokenMap,
  ) {
    final resolved = <String, dynamic>{};

    for (var entry in value.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        resolved[key] = _resolvedValue(value, tokenMap);
      } else if (value is String && value.isReference) {
        final refKey = value.valueByRef;
        resolved[key] =
            tokenMap[refKey]?.resolveValueReferences(tokenMap)?.value;
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }
}

// Path + name with all dots removed and in camelCase
String _getVariableName(String path, String name) {
  final parts = path.split('.').where((e) => e.isNotEmpty).toList()..add(name);
  return parts.join(' ').camelCased;
}
