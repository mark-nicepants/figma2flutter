import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/config/args_parser.dart';
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';

final transformers = [
  ColorTransformer(),
  SpacingTransformer(),
];

Future<void> main(List<String> arguments) async {
  final options = await ArgumentParser(arguments).parse();

  final input = json.decode(File(options.getOption<String>(kInput).value).readAsStringSync()) as Map<String, dynamic>;
  final setOrder = (input['\$metadata']?['tokenSetOrder'] as List? ?? []).map((e) => e.toString()).toList();

  final parser = TokenParser(setOrder);
  parser.parse(input);

  for (final token in parser.resolvedTokens) {
    for (final transformer in transformers) {
      transformer.process(token);
    }
  }

  final generator = Generator(transformers);
  generator.save(options.getOption<String>(kOutput).value);

  exit(0);
}
