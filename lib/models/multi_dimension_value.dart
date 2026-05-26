import 'package:figma2flutter/models/dimension_value.dart';

/// A value that has multiple dimensions.
class MultiDimensionValue {
  /// The values of the dimensions.
  List<DimensionValue> values;

  /// Creates a new [MultiDimensionValue] with the given [values].
  MultiDimensionValue._(this.values);

  /// Parses the given [value] to a [MultiDimensionValue].
  factory MultiDimensionValue.parse(dynamic value, bool supportPercentage) {
    if (value == null) {
      return MultiDimensionValue._([]);
    }

    if (value is double) {
      final parsedValue = DimensionValue.maybeParse(value, supportPercentage);
      if (parsedValue != null) {
      return MultiDimensionValue._([parsedValue]);
      }
    }

    if (value is int) {
      final parsedValue = DimensionValue.maybeParse(value, supportPercentage);
      if (parsedValue != null) {
        return MultiDimensionValue._([parsedValue]);
      }
    }

    if (value is! String) {
      return MultiDimensionValue._([]);
    }

    // Split on spaces and parse each value to a size
    final values = value
        .split(' ')
        .map((v) => DimensionValue.maybeParse(v, supportPercentage))
        .where((element) => element != null)
        .cast<DimensionValue>()
        .toList();

    return MultiDimensionValue._(values);
  }
}
