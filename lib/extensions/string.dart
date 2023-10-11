extension StringExtension on String {
  /// Returns true if the string is a reference to another token path without any extras
  bool get isTokenReference =>
      (startsWith('{') && endsWith('}')) &&
      RegExp(r'{(.*?)}').allMatches(this).length == 1;

  bool get hasTokenReferences => RegExp(r'{(.*?)}').allMatches(this).isNotEmpty;

  bool get isColorReference {
    return !startsWith('{') && RegExp(r'{(.*?)}').firstMatch(this) != null;
  }

  bool get isMathExpression {
    return contains(' + ') ||
        contains(' - ') ||
        contains(' * ') ||
        contains(' / ');
  }

  /// Returns the path of a reference, so we can search for the token
  String get valueByRef {
    final match = RegExp(r'{(.*?)}').firstMatch(this)?.group(1);
    if (match != null) {
      return match;
    }

    throw Exception(
      'Not a valid reference ( should start with \$ or encased in { })',
    );
  }
}
