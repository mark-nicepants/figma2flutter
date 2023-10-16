import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:figma2flutter/extensions/string.dart';

void main() {
  test('extension isReference', () {
    expect('\$reference'.isTokenReference, isFalse);
    expect('{reference}'.isTokenReference, isTrue);
    expect('#reference'.isTokenReference, isFalse);
    expect('reference'.isTokenReference, isFalse);

    expect('{reference}'.valueByRef, equals('reference'));

    expect(
      () => 'noreference'.valueByRef,
      throwsA(const TypeMatcher<Exception>()),
    );
  });

  test('extension alphanumeric', () {
    final test = '[DSDocumentation]BodyTitle2';
    expect(test.alphanumeric, 'DSDocumentationBodyTitle2');
  });

  test('extension alphanumeric spaces', () {
    final test = 'default - dark';
    expect(test.alphanumeric, 'DefaultDark');
  });

  test('extension alphanumeric arrows', () {
    final test = '180-deg-↓';
    expect(test.alphanumeric, '180Deg');
  });
}
