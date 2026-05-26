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
  final bool isPercentage;

  DimensionValue(this.value, {this.isPercentage = false});

  static DimensionValue get zero => DimensionValue(0);

  static DimensionValue? maybeParse(dynamic value, bool supportPercentage) {
    if (value == null) return null;
    final parsedValue = _parseNum(value.toString());

    // If percentage values are not supported, return null for percentage values
    if (parsedValue == null || (parsedValue.isPercentage && !supportPercentage)) {
      return null;
    }

    return parsedValue;
  }

  @override
  String toString() => value.toString();

  DimensionValue operator /(num divisor) => DimensionValue(value / divisor);
  DimensionValue operator +(num addend) => DimensionValue(value + addend);
  DimensionValue operator -(num difference) =>
      DimensionValue(value - difference);
  DimensionValue operator *(num multiplicand) =>
      DimensionValue(value * multiplicand);

  @override
  bool operator ==(Object other) =>
      other is DimensionValue && value == other.value;

  @override
  int get hashCode => value.hashCode;

  static DimensionValue? _parseNum(String value) {
    // 1px = 1.0
    if (value.endsWith('px')) {
      final doubleValue = double.tryParse(value.substring(0, value.length - 2));
      if (doubleValue == null) return null;
      return DimensionValue(doubleValue);
    }

    // 1rem = 16px (base font size)
    if (value.endsWith('rem')) {
      final doubleValue = double.tryParse(value.substring(0, value.length - 3));
      if (doubleValue == null) return null;
      return DimensionValue(doubleValue * kBaseFontSize);
    }

    // 100% = 1.0
    // 50% = 0.5
    if (value.endsWith('%')) {
      final doubleValue = double.tryParse(value.substring(0, value.length - 1));
      if (doubleValue == null) return null;
      return DimensionValue(doubleValue / 100, isPercentage: true);
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null) return null;
    return DimensionValue(parsedValue);
  }
}
