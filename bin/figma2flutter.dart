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

  final input = json.decode(File(options.getOption(kInput).value as String).readAsStringSync());
  final setOrder = (input['\$metadata']?['tokenSetOrder'] as List? ?? []).map((e) => e.toString()).toList();

  final parser = TokenParser(setOrder);
  parser.parse(input);

  for (final t in parser.tokenMap.values) {
    final token = t.isReference ? parser.getReference(t) : t;

    if (token == null) {
      print('Reference not found: ${t.value}');
      continue;
    }

    for (final transformer in transformers) {
      transformer.process(t.variableName, token);
    }
  }

  final generator = Generator(transformers);
  generator.save(options.getOption(kOutput).value as String);

  exit(0);
}
