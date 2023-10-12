import 'package:recase/recase.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:figma2flutter/extensions/string.dart';

void main() {
  test('extension camelCase', () {
    expect('Hey world'.camelCase, equals('heyWorld'));
    expect('Hey.world'.camelCase, equals('heyWorld'));
  });

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
}
