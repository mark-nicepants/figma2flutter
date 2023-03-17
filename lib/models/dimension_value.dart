const kBaseFontSize = 16.0;

/// A value that represents a dimension.
/// This can be a number, a percentage, or a rem value.
/// A percentage is converted to a decimal value between 0 and 1.
/// A rem value is converted to a pixel value based on the base font size (see [kBaseFontSize]).
/// Px values are converted to a double and returned as is.
/// Last but not least, if the value is a number, it is converted to a double and returned as is.
/// And if the value is not a number 0 is returned.
class DimensionValue {
  final double value;

  DimensionValue(this.value);

  static DimensionValue get zero => DimensionValue(0);

  static DimensionValue? maybeParse(dynamic value) {
    if (value == null) return null;

    return DimensionValue(_parseNum(value as String));
  }

  @override
  String toString() => value.toString();

  DimensionValue operator /(num divisor) => DimensionValue(value / divisor);
}

double _parseNum(String value) {
  // 1px = 1.0
  if (value.endsWith('px')) {
    return double.tryParse(value.substring(0, value.length - 2)) ?? 0;
  }

  // 1rem = 16px (base font size)
  if (value.endsWith('rem')) {
    return (double.tryParse(value.substring(0, value.length - 3)) ?? 0) *
        kBaseFontSize;
  }

  // 100% = 1.0
  // 50% = 0.5
  if (value.endsWith('%')) {
    return (double.tryParse(value.substring(0, value.length - 1)) ?? 0) / 100;
  }

  return double.tryParse(value) ?? 0;
}
