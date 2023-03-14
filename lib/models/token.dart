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

  bool get isReference {
    return value is String && ((value as String).startsWith('\$') || (value as String).startsWith('{'));
  }

  String get valueByRef {
    if (valueAsString?.startsWith('\$') == true) {
      return valueAsString!.substring(1);
    }
    if (valueAsString?.startsWith('{') == true) {
      return valueAsString!.substring(1, valueAsString!.length - 1);
    }

    throw Exception('Not a valid reference ( should start with \$ or encased in { })');
  }

  // Path + name with all dots removed and in camelCase
  static String _getVariableName(String path, String name) {
    final parts = path.split('.').where((e) => e.isNotEmpty).toList()..add(name);
    final capitalized = parts.map((e) => e[0].toUpperCase() + e.substring(1)).join();
    return capitalized[0].toLowerCase() + capitalized.substring(1);
  }

  Token copyWith({String? path, String? variableName}) {
    return Token(
      value: value,
      type: type,
      path: path ?? this.path,
      name: name,
      variableName: variableName ?? this.variableName,
    );
  }

  @override
  String toString() => '$value: $type';
}
