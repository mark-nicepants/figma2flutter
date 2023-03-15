class DimensionValue {
  final double value;

  DimensionValue._(this.value);

  static DimensionValue? maybeParse(dynamic value) {
    if (value == null) return null;

    return DimensionValue._(_parseNum(value as String));
  }

  @override
  String toString() => value.toString();
}

double _parseNum(String value) {
  // 1px = 1.0
  if (value.endsWith('px')) {
    return double.tryParse(value.substring(0, value.length - 2)) ?? 0;
  }

  // 1rem = 16px (base font size)
  if (value.endsWith('rem')) {
    return (double.tryParse(value.substring(0, value.length - 3)) ?? 0) * 16;
  }

  // 100% = 1.0
  // 50% = 0.5
  if (value.endsWith('%')) {
    return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) / 100;
  }

  return double.tryParse(value) ?? 0;
}
