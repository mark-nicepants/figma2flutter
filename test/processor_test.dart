import 'dart:convert';

import 'package:figma2flutter/exceptions/process_token_exception.dart';
import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:test/test.dart';

void main() {
  test('Test processor error resolve exception', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });

  test('Test processor error process exception', () {
    final parsed = json.decode(invalidColor) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ProcessTokenException>()),
    );
  });

  test('Test processor error color reference exception', () {
    final parsed = json.decode(invalidRefColor) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });

  test(
      'Test processor error color reference exception when a ref color is invalid',
      () {
    final parsed = json.decode(invalidRefColorRef) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });
}

final input = '''
{
  "token": {
    "value": "{purple}",
    "type": "color"
  }
}''';

final invalidColor = '''
{
  "token": {
    "value": "#purple",
    "type": "color"
  }
}''';

final invalidRefColor = '''
{
  "token": {
    "value": "rgba({brand.500}, 0.5)",
    "type": "color"
  }
}''';

final invalidRefColorRef = '''
{
  "purple": {
    "value": "#purple",
    "type": "color"
  },
  "token": {
    "value": "rgba({purple}, 0.5)",
    "type": "color"
  }
}''';
