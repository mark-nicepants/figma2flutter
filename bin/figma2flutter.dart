import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/config/args_parser.dart';
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:figma2flutter/transformers/material_color_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:figma2flutter/transformers/transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';

/// Code for making terminal output foreground red
const _red = '\x1b[033;0;31m';

/// Code for making terminal output foreground green
const _green = '\x1b[033;0;32m';

//No Color, reset terminal foreground color
const _nc = '\x1b[033;0m';

// All transformers that process single tokens should be added here
// These transformers will be applied to all tokens in the order they are listed
final singleTokenTransformers = [
  ColorTransformer(),
  SpacingTransformer(),
  TypographyTransformer(),
  BorderRadiusTransformer(),
  CompositionTransformer(),
];

// All transformers that process multiple tokens should be added here
List<MultiTokenTransformer> _getPostProcessTransformers(List<Token> tokens) => [
      MaterialColorTransformer(tokens),
    ];

// Entry point, parses the input arguments and runs the transformers
Future<void> main(List<String> arguments) async {
  final options = await ArgumentParser(arguments).parse();

  /// Get the input json file and output directory from the parsed arguments
  final inputJson = options.getOption<String>(kInput).value;
  final outputDir = options.getOption<String>(kOutput).value;

  /// Parse the input json file and get all resolved tokens from the parser
  final resolved = _parseInput(inputJson);

  /// Print the number of tokens found to the terminal output
  _print('Found ${resolved.length} tokens, generating code', _green);

  /// Process the tokens with all transformers
  final allTransformers = _processTokens(resolved);

  /// Print the number of tokens each transformer processed to the terminal output
  for (final transformer in allTransformers) {
    _print(
      'Found ${transformer.lines.length} ${transformer.name} tokens',
      _green,
    );
  }

  /// Save the output to the specified directory
  _saveOutput(allTransformers, outputDir);

  /// Let the user know that the output has been saved
  _print(''); // New line
  _print('Done, output saved to $outputDir', _green);

  exit(0);
}

/// Save the output to the specified directory
void _saveOutput(List<Transformer> allTransformers, String outputDir) {
  final generator = Generator(allTransformers);
  generator.save(outputDir);
}

/// Process the tokens with all transformers
List<Transformer> _processTokens(List<Token> resolved) {
  for (final token in resolved) {
    for (final transformer in singleTokenTransformers) {
      try {
        transformer.process(token);
      } catch (e) {
        _print('Error while processing ${token.path}.${token.name}', _red);
        rethrow;
      }
    }
  }

  final postProcessTransformers = _getPostProcessTransformers(resolved);
  for (var transformer in postProcessTransformers) {
    for (final token in resolved) {
      try {
        transformer.process(token);
      } catch (e) {
        _print('Error while processing ${token.path}.${token.name}', _red);
        rethrow;
      }
    }
  }

  // Run post process on all transformers that need it
  for (var transformer in postProcessTransformers) {
    transformer.postProcess();
  }

  return [
    ...singleTokenTransformers,
    ...postProcessTransformers,
  ];
}

/// Parses the input json file and returns a list of resolved tokens
List<Token> _parseInput(String inputJson) {
  final input = json.decode(
    File(inputJson).readAsStringSync(),
  ) as Map<String, dynamic>;

  final setOrder = (input['\$metadata']?['tokenSetOrder'] as List? ?? [])
      .map((e) => e.toString())
      .toList();

  final parser = TokenParser(setOrder)..parse(input);

  return parser.resolvedTokens;
}

// ignore: avoid_print
void _print(String msg, [String color = _nc]) => print('$color$msg$_nc');
