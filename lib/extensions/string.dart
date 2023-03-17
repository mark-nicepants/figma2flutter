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

  /// Returns true if the string is a reference to another token path
  bool get isReference =>
      startsWith('\$') || (startsWith('{') && endsWith('}'));

  /// Returns the path of a reference, so we can search for the token
  String get valueByRef {
    if (startsWith('\$') == true) {
      return substring(1);
    }
    if (startsWith('{') == true) {
      return substring(1, length - 1);
    }

    throw Exception(
      'Not a valid reference ( should start with \$ or encased in { })',
    );
  }
}
