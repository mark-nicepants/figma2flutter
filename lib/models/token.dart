import 'dart:math';

import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/extensions/string.dart';
import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';

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
    this.extensions,
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

  /// The extensions of the token
  final Map<String, dynamic>? extensions;

  bool get hasExtensions => extensions != null && extensions!.isNotEmpty;

  /// The value of the token as a string
  String? get valueAsString {
    if (value is String) {
      return value as String;
    }

    return null;
  }

  /// Check if the token is a reference to another token
  bool get _hasTokenReferences =>
      value is String && (value as String).hasTokenReferences;

  /// Check if the token has an inner reference to a color
  bool get _hasColorReference =>
      value is String && (value as String).isColorReference;

  bool get _hasMathExpression =>
      value is String && (value as String).isMathExpression;

  /// The name of the token that is referenced without the leading '$'
  /// or '{' and '}' characters
  String get valueByRef => (value as String).valueByRef;

  /// Returns a copy of this token with the given values. If the path is set,
  /// the variable name will be updated as well.
  Token copyWith({
    String? path,
    String? variableName,
    String? type,
    dynamic value,
    Map<String, dynamic>? extensions,
  }) {
    if (path != null && variableName == null) {
      variableName = _getVariableName(path, name);
    }

    return Token(
      name: name,
      type: type ?? this.type,
      value: value ?? this.value,
      path: path ?? this.path,
      extensions: extensions ?? this.extensions,
      variableName: variableName ?? this.variableName,
    );
  }

  Token resolveAllReferences(Map<String, Token> tokenMap) {
    Token? token = this;

    if (_hasColorReference) {
      token = token._resolveColorReferences(tokenMap);
    }

    if (_hasMathExpression) {
      token = token._resolveMathExpression(tokenMap);
    }

    if (token._hasTokenReferences == true) {
      if (token.valueAsString?.isTokenReference == true) {
        final reference =
            tokenMap[token.valueByRef]?.resolveAllReferences(tokenMap);
        if (reference == null) {
          throw ResolveTokenException(
            'Reference not found for `${token.valueByRef}`',
          );
        }

        token = token.copyWith(
          value: reference.value,
          type: type ?? reference.type,
        );
      } else {
        var resolved = token.valueAsString!;
        var match = RegExp(r'{(.*?)}').firstMatch(resolved);
        String? type = this.type;
        while (match != null) {
          final reference =
              tokenMap[match.group(1)]?.resolveAllReferences(tokenMap);
          if (reference == null) {
            throw ResolveTokenException(
              'Reference not found for `${match.group(1)}`',
            );
          }

          // If the type is not set yet, set it to the type of the first reference
          type = type ?? reference.type;

          resolved = resolved.replaceRange(
            match.start,
            match.end,
            reference.value.toString(),
          );

          match = RegExp(r'{(.*?)}').firstMatch(resolved);
        }

        token = token.copyWith(
          value: resolved,
          type: type,
        );
      }
    }

    return token._resolveValueReferences(tokenMap);
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
  Token _resolveValueReferences(Map<String, Token> tokenMap) {
    // Loop through all values and resolve references recursively
    if (value is Map<String, dynamic>) {
      final resolved = _resolvedValue(value as Map<String, dynamic>, tokenMap);
      return copyWith(value: resolved);
    }

    // Loop through all values in the list and resolve references recursively if they are a Map
    if (value is List) {
      final resolvedList = <dynamic>[];
      for (final element in (value as List)) {
        if (element is Map<String, dynamic>) {
          final resolved = _resolvedValue(element, tokenMap);
          resolvedList.add(resolved);
        } else {
          resolvedList.add(element);
        }
      }
      return copyWith(value: resolvedList);
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
      } else if (value is String && value.isColorReference) {
        resolved[key] = _resolveColorValue(value, tokenMap);
      } else if (value is String && value.isTokenReference) {
        final refKey = value.valueByRef;
        resolved[key] = tokenMap[refKey]?.resolveAllReferences(tokenMap).value;
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }

  // If the value is a reference and starts with 'rgba', we need to
  // resolve the reference to the color token and use the value of that
  // token as the value of this token. See [references_test.dart:145] for
  // an example. Eg: rgba({brand.500}, 0.5) => rgba(255, 255, 255, 0.5)
  Token _resolveColorReferences(Map<String, Token> tokenMap) {
    String value = _resolveColorValue(valueAsString!, tokenMap);
    return copyWith(value: value);
  }

  Token _resolveMathExpression(Map<String, Token> tokenMap) {
    final isMultiply = valueAsString!.contains(' * ');
    final isDivide = valueAsString!.contains(' / ');
    final isAdd = valueAsString!.contains(' + ');
    final isSubtract = valueAsString!.contains(' - ');

    // Split on expression and parse the left and right side
    // We search for: a space, then a valid operator (*/+-), then a space
    final splitted = valueAsString!.split(RegExp(r'\s[*/+-]\s'));

    final leftPart = splitted[0].trim();
    final rightPart = splitted[1].trim();

    final leftValue = leftPart.isTokenReference
        ? tokenMap[leftPart.valueByRef]?.resolveAllReferences(tokenMap).value
        : leftPart;
    final rightValue = rightPart.isTokenReference
        ? tokenMap[rightPart.valueByRef]?.resolveAllReferences(tokenMap).value
        : rightPart;

    final left = DimensionValue.maybeParse(leftValue);
    final right = DimensionValue.maybeParse(rightValue);

    if (left == null || right == null) {
      throw FormatException(
        'Could not parse math expression for Token $name (path: $path) `$valueAsString`',
      );
    }

    double? solved = 0.0;
    if (isMultiply) {
      solved = left.value * right.value;
    } else if (isDivide) {
      solved = left.value / right.value;
    } else if (isAdd) {
      solved = left.value + right.value;
    } else if (isSubtract) {
      solved = left.value - right.value;
    }

    return copyWith(value: solved);
  }
}

String _resolveColorValue(String initialValue, Map<String, Token> tokenMap) {
  var value = initialValue;
  var match = RegExp(r'{(.*?)}').firstMatch(initialValue);
  while (match != null) {
    final reference = tokenMap[match.group(1)]?.resolveAllReferences(tokenMap);
    if (reference == null) {
      throw ResolveTokenException(
        'Reference not found for `${match.group(1)}`',
      );
    }

    final color = ColorValue.maybeParse(reference.value);
    if (color == null) {
      throw ResolveTokenException(
        'Could not parse color for `${reference.value}`',
      );
    }

    // Check if is inside a rgba() function
    final isRgb =
        value.substring(max(0, match.start - 7), match.start).contains('rgba(');
    final String replaceWith;
    if (isRgb) {
      replaceWith = color.toRgb().join(', ');
    } else {
      replaceWith = color.toHex();
    }

    value = value.replaceRange(
      match.start,
      match.end,
      replaceWith,
    );

    // Search next match
    match = RegExp(r'{(.*?)}').firstMatch(value);
  }
  return value;
}

// Path + name with all dots removed and in camelCase
String _getVariableName(String path, String name) {
  final parts = path.split('.').where((e) => e.isNotEmpty).toList()..add(name);
  return parts.join(' ').camelCased;
}
