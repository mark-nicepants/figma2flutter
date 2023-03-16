import 'package:figma2flutter/models/multi_dimension_value.dart';
import 'package:test/test.dart';

void main() {
  test('check invalid value usage', () {
    final value = MultiDimensionValue.parse(<int>[]);
    expect(value.values, isEmpty);
  });
}
