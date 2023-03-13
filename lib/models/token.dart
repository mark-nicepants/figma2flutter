class Token {
  final dynamic value;
  final String type;
  final String path;
  final String name;

  Token({
    required this.value,
    required this.type,
    required this.path,
    required this.name,
  });

  bool get isReference {
    return value is String && value.startsWith('\$');
  }

  // Path + name with all dots removed and in camelCase
  String get variableName {
    final parts = path.split('.').where((e) => e.isNotEmpty).toList()..add(name);
    final capitalized = parts.map((e) => e[0].toUpperCase() + e.substring(1)).join();
    return capitalized[0].toLowerCase() + capitalized.substring(1);
  }

  Token copyWith({String? path}) {
    return Token(
      value: value,
      type: type,
      path: path ?? this.path,
      name: name,
    );
  }

  @override
  String toString() => '$value: $type';
}
