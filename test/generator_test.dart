import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/generator.dart';
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

class Tokens {
  static ColorTokens get color => ColorTokens();
}

class ColorTokens {
  Color get token => const Color(0xFF111111);
}
''';

/// https://tr.designtokens.org/format/#type-0
/// 5.4 Type
///
/// The $type property can be set on different levels:
// at the group level
// at the token level

void main() {
  test(
      'that groups can have a type and that missing token types refer to the group type',
      () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(1));
    expect(parser.tokenMap['token']?.type, equals('color'));
    expect(parser.tokenMap['token']?.value, equals('#111111'));

    final transformer = ColorTransformer();
    transformer.process(parser.tokenMap['token']!);

    expect(transformer.lines.length, equals(1));
    expect(
      transformer.lines[0],
      equals('Color get token => const Color(0xFF111111);'),
    );

    final generator = Generator([transformer]);
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
