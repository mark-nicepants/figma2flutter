import 'package:figma2flutter/models/dimension_value.dart';

class MultiDimensionValue {
  List<DimensionValue> values;

  MultiDimensionValue._(this.values);

  factory MultiDimensionValue.parse(dynamic value) {
    // Split on spaces and parse each value to a size
    final values = (value as String)
        .split(' ')
        .map(DimensionValue.maybeParse)
        .where((element) => element != null)
        .cast<DimensionValue>()
        .toList();

    return MultiDimensionValue._(values);
  }
}
