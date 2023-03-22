extension StringExtension on String {
  /// Converts a string to camelCase.
  /// Examples: `hello world` -> `helloWorld`, `hello.world` -> `helloWorld`
  String get camelCased {
    // Match all non alphanumeric characters and replace them with a space
    final pattern = RegExp(r'[^a-zA-Z0-9]');
    final capitalized = replaceAll(pattern, ' ')
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join();
    return capitalized[0].toLowerCase() + capitalized.substring(1);
  }

  String get capitalize {
    return this[0].toUpperCase() + substring(1);
  }

  /// Returns true if the string is a reference to another token path without any extras
  bool get isTokenReference =>
      startsWith('\$') || (startsWith('{') && endsWith('}'));

  bool get isColorReference {
    return !startsWith('\$') &&
        !startsWith('{') &&
        RegExp(r'{(.*?)}').firstMatch(this) != null;
  }

  bool get isMathExpression {
    return contains(' + ') ||
        contains(' - ') ||
        contains(' * ') ||
        contains(' / ');
  }

  /// Returns the path of a reference, so we can search for the token
  String get valueByRef {
    if (startsWith('\$') == true) {
      return substring(1);
    }

    final match = RegExp(r'{(.*?)}').firstMatch(this)?.group(1);
    if (match != null) {
      return match;
    }

    throw Exception(
      'Not a valid reference ( should start with \$ or encased in { })',
    );
  }
}
