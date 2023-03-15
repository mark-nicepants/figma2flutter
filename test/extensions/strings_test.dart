import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:figma2flutter/extensions/string.dart';

void main() {
  test('extension camelCase', () {
    expect('Hey world'.camelCased, equals('heyWorld'));
    expect('Hey.world'.camelCased, equals('heyWorld'));
  });

  test('extension isReference', () {
    expect('\$reference'.isReference, isTrue);
    expect('{reference}'.isReference, isTrue);
    expect('#reference'.isReference, isFalse);
    expect('reference'.isReference, isFalse);

    expect('\$reference'.valueByRef, equals('reference'));
    expect('{reference}'.valueByRef, equals('reference'));

    expect(
      () => 'noreference'.valueByRef,
      throwsA(const TypeMatcher<Exception>()),
    );
  });
}
