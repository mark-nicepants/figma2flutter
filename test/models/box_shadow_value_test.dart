import 'package:figma2flutter/models/box_shadow_value.dart';
import 'package:test/test.dart';

void main() {
  test('BoxShadowValue throws FormatException for non-map value', () {
    expect(
      () => BoxShadowValue.maybeParse('2px 4px 8px #000'),
      throwsA(isA<FormatException>()),
    );
  });

  test('BoxShadowValue returns null for null value', () {
    expect(BoxShadowValue.maybeParse(null), isNull);
  });
}
