import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('border radius token - single value', () {
    final token1 =
        Token(value: '0', type: 'borderRadius', name: 'zero', path: '');
    final token2 =
        Token(value: '16', type: 'borderRadius', name: 'medium', path: '');

    final transformer = BorderRadiusTransformer();
    expect(
      transformer.transform(token1),
      equals('const BorderRadius.zero'),
    );
    expect(
      transformer.transform(token2),
      equals('BorderRadius.circular(16.0)'),
    );

    transformer.process(token1);
    transformer.process(token2);

    expect(transformer.lines.length, equals(2));
  });

  test('border radius token - double value', () {
    final token1 =
        Token(value: '16 2rem', type: 'borderRadius', name: 'zero', path: '');
    final output =
        'const BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(32.0),bottomRight: Radius.circular(16.0),bottomLeft: Radius.circular(32.0))';

    final transformer = BorderRadiusTransformer();
    expect(transformer.transform(token1), equals(output));
  });

  test('border radius token - 3 values', () {
    final token1 = Token(
      value: '0 8px 16px',
      type: 'borderRadius',
      name: 'zero',
      path: '',
    );
    final output =
        'const BorderRadius.only(topLeft: Radius.circular(0.0),topRight: Radius.circular(8.0),bottomRight: Radius.circular(16.0),bottomLeft: Radius.circular(8.0))';

    final transformer = BorderRadiusTransformer();
    expect(transformer.transform(token1), equals(output));
  });

  test('border radius token - 4 values', () {
    final token1 =
        Token(value: '1 2 3 4', type: 'borderRadius', name: 'zero', path: '');
    final output =
        'const BorderRadius.only(topLeft: Radius.circular(1.0),topRight: Radius.circular(2.0),bottomRight: Radius.circular(3.0),bottomLeft: Radius.circular(4.0))';

    final transformer = BorderRadiusTransformer();
    expect(transformer.transform(token1), equals(output));
  });
}
