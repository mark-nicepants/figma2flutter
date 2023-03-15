import 'package:figma2flutter/models/dimension_value.dart';

class SpacingValue {
  List<DimensionValue> values;

  SpacingValue._(this.values);

  factory SpacingValue.parse(dynamic value) {
    // Split on spaces and parse each value to a size
    final values = (value as String)
        .split(' ')
        .map(DimensionValue.maybeParse)
        .where((element) => element != null)
        .cast<DimensionValue>()
        .toList();

    return SpacingValue._(values);
  }
}
