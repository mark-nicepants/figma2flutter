import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/config/args_parser.dart';
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';

// All transformers should be added here
// These transformers will be applied to all tokens in the order they are listed
final transformers = [
  ColorTransformer(),
  SpacingTransformer(),
  TypographyTransformer(),
  BorderRadiusTransformer(),
];

// Entry point, parses the input arguments and runs the transformers
Future<void> main(List<String> arguments) async {
  final options = await ArgumentParser(arguments).parse();

  final inputJson = options.getOption<String>(kInput).value;
  final outputDir = options.getOption<String>(kOutput).value;

  final input = json.decode(
    File(inputJson).readAsStringSync(),
  ) as Map<String, dynamic>;
  final setOrder = (input['\$metadata']?['tokenSetOrder'] as List? ?? [])
      .map((e) => e.toString())
      .toList();

  final parser = TokenParser(setOrder);
  parser.parse(input);

  final resolved = parser.resolvedTokens;

  _print('Found ${resolved.length} tokens, generating code', _green);

  for (final token in resolved) {
    for (final transformer in transformers) {
      transformer.process(token);
    }
  }

  for (final transformer in transformers) {
    _print(
      'Found ${transformer.lines.length} ${transformer.name} tokens',
      _green,
    );
  }

  final generator = Generator(transformers);
  generator.save(outputDir);

  _print(''); // New line
  _print('Done, output saved to $outputDir', _green);

  exit(0);
}

const _green = '\x1b[033;0;32m';
const _nc = '\x1b[033;0m'; //No Color, reset

// ignore: avoid_print
void _print(String msg, [String color = _nc]) => print('$color$msg$_nc');
