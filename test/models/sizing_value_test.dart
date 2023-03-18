import 'package:figma2flutter/models/sizing_value.dart';
import 'package:test/test.dart';

void main() {
  test('SizeValue with 2 different values returns valid size', () {
    final size = SizingValue.maybeParse({
      'width': 12.0,
      'height': 24.0,
    });
    expect(size?.width?.value, equals(12.0));
    expect(size?.height?.value, equals(24.0));
    expect(size.toString(), equals('Size(12.0, 24.0)'));
  });
}
