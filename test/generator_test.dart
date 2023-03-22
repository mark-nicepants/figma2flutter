import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
  "token": {
    "value": "#111111",
    "type": "color"
  }
}''';

final output = '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

import 'package:flutter/material.dart';

abstract class ITokens {
  ColorTokens get color;
}

abstract class ColorTokens {
  Color get token;
}

class DefaultTokens extends ITokens {
  @override
  ColorTokens get color => DefaultColorTokens();
}

class DefaultColorTokens extends ColorTokens {
  @override
  Color get token => const Color(0xFF111111);
}
''';

void main() {
  test(
      'That the parser resolves all references and that the generator generates the correct output',
      () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.themes.first.tokens.length, equals(1));
    expect(parser.themes.first.tokens['token']?.type, equals('color'));
    expect(parser.themes.first.tokens['token']?.value, equals('#111111'));

    final transformer = ColorTransformer();
    transformer.process(parser.themes.first.tokens['token']!);

    expect(transformer.lines.length, equals(1));
    expect(
      transformer.lines[0],
      equals('@override\n  Color get token => const Color(0xFF111111);'),
    );

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );
    processor.process();

    final generator = Generator(processor.themes);
    expect(generator.output, equals(output));

    generator.save('test/output');
    expect(
      File('test/output/tokens.g.dart').readAsStringSync(),
      equals(output),
    );

    // Check if a save to the same path will overwrite the file.
    generator.save('test/output');
    expect(
      File('test/output/tokens.g.dart').readAsStringSync(),
      equals(output),
    );

    Directory('test/output').deleteSync(recursive: true);
  });
}
