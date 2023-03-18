import 'package:figma2flutter/models/color_value.dart';
import 'package:test/test.dart';

void main() {
  test('ColorValue black returns proper color', () {
    expect(ColorValue.black.value, equals('0xFF000000'));
    expect(ColorValue.black.toString(), equals('const Color(0xFF000000)'));
  });
}
