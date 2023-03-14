import 'package:figma2flutter/extensions/string.dart';

class Token {
  Token({
    required this.value,
    required this.type,
    required this.path,
    required this.name,
    String? variableName,
  }) : variableName = variableName ?? _getVariableName(path, name);
  final dynamic value;

  // Can be null when the token is a reference
  final String? type;

  final String path;

  final String name;

  final String variableName;

  String? get valueAsString => value as String?;

  bool get isReference => value is String && (value as String).isReference;

  String get valueByRef => (value as String).valueByRef;

  Token copyWith({String? path, String? variableName, dynamic value}) {
    return Token(
      name: name,
      type: type,
      value: value ?? this.value,
      path: path ?? this.path,
      variableName: variableName ?? this.variableName,
    );
  }

  Token? resolveValueReferences(Map<String, Token> tokenMap) {
    // Loop through all values and resolve references recursively
    if (value is Map<String, dynamic>) {
      final resolved = _resolvedValue(value as Map<String, dynamic>, tokenMap);
      return copyWith(value: resolved);
    }

    return this;
  }

  Map<String, dynamic> _resolvedValue(Map<String, dynamic> value, Map<String, Token> tokenMap) {
    final resolved = <String, dynamic>{};

    for (var entry in value.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        resolved[key] = _resolvedValue(value, tokenMap);
      } else if (value is String && value.isReference) {
        final refKey = value.valueByRef;
        resolved[key] = tokenMap[refKey]?.value;
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
