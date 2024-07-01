import 'package:recase/recase.dart';

const negativeNumberPreface = 'Negative';

extension StringExtension on String {
  String get alphanumeric {
    // Match '-' only if it is followed by a digit and replace with negativeNumberPreface
    final patternNegative = RegExp(r'^(-)(?=\d)');
    // Match all non alphanumeric characters (excluding negativeNumberPreface replacements) and replace them with a space
    final patternNonAlphanumeric = RegExp(r'[^a-zA-Z0-9]');

    var result = replaceAll(patternNegative, negativeNumberPreface);
    result = result.replaceAll(patternNonAlphanumeric, ' ');

    return result.pascalCase;
  }

  /// Returns true if the string is a reference to another token path without any extras
  bool get isTokenReference =>
      (startsWith('{') && endsWith('}')) &&
      RegExp(r'{(.*?)}').allMatches(this).length == 1;

  bool get hasTokenReferences => RegExp(r'{(.*?)}').allMatches(this).isNotEmpty;

  bool get isColorReference {
    // what is this really used for.  It says #123456 isn't a color
    // this should probably only be done at the token level
    bool isColor =
        !startsWith('{') && RegExp(r'{(.*?)}').firstMatch(this) != null;
    // print('looked at $this to see if it is a color - $isColor');
    return isColor;
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
