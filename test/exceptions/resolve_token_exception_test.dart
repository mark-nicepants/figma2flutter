import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('ResolveTokenException message', () {
    expect(
      ResolveTokenException('some wrapped exception').toString(),
      equals('ResolveTokenException{message: some wrapped exception}'),
    );
  });
}
