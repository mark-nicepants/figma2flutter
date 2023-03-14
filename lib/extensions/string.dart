extension StringExtension on String {
  String get camelCased {
    final capitalized = replaceAll('.', ' ').split(' ').map((e) => e[0].toUpperCase() + e.substring(1)).join();
    return capitalized[0].toLowerCase() + capitalized.substring(1);
  }

  bool get isReference => startsWith('\$') || (startsWith('{') && endsWith('}'));

  String get valueByRef {
    if (startsWith('\$') == true) {
      return substring(1);
    }
    if (startsWith('{') == true) {
      return substring(1, length - 1);
    }

    throw Exception('Not a valid reference ( should start with \$ or encased in { })');
  }
}
