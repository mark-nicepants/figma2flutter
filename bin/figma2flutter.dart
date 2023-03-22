import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/config/args_parser.dart';
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:figma2flutter/transformers/border_transformer.dart';
import 'package:figma2flutter/transformers/box_shadow_transformer.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:figma2flutter/transformers/linear_gradient_transformer.dart';
import 'package:figma2flutter/transformers/material_color_transformer.dart';
import 'package:figma2flutter/transformers/size_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';
import 'package:figma2flutter/utils/sets_and_themes.dart';

/// Code for making terminal output foreground red
const _red = '\x1b[033;0;31m';

/// Code for making terminal output foreground green
const _green = '\x1b[033;0;32m';

//No Color, reset terminal foreground color
const _nc = '\x1b[033;0m';

// All transformers that process single tokens should be added here
// These transformers will be applied to all tokens in the order they are listed
final singleTokenFactories = <TransformerFactory>[
  (_) => ColorTransformer(),
  (_) => SpacingTransformer(),
  (_) => TypographyTransformer(),
  (_) => BorderRadiusTransformer(),
  (_) => CompositionTransformer(),
  (_) => BoxShadowTransformer(),
  (_) => BorderTransformer(),
  (_) => SizeTransformer(),
  (_) => LinearGradientTransformer(),
];

// All transformers that process multiple tokens should be added here
final multiTokenFactories = [
  MaterialColorTransformer.new,
];

// Entry point, parses the input arguments and runs the transformers
Future<void> main(List<String> arguments) async {
  final options = await ArgumentParser(arguments).parse();

  /// Get the input json file and output directory from the parsed arguments
  final inputJson = options.getOption<String>(kInput).value;
  final outputDir = options.getOption<String>(kOutput).value;

  // To be able to debug the example app, uncomment the following lines and
  // comment the lines above. Then run main in debug mode.
  // final inputJson = 'example/bin/example-themes.json';
  // final outputDir = 'example/lib/generated';

  /// Parse the input json file and get all resolved tokens from the parser
  try {
    final themes = _parseInput(inputJson);

    /// Print the number of tokens found to the terminal output
    _print('Found ${themes.length} themes, generating code', _green);

    /// Process the tokens with all transformers
    final result = _processTokens(themes);

    /// Print the number of tokens each transformer processed to the terminal output
    for (final transformer in result.first.transformers) {
      _print(
        'Found ${transformer.lines.length} ${transformer.name} tokens',
        _green,
      );
    }

    /// Save the output to the specified directory
    _saveOutput(result, outputDir);

    /// Let the user know that the output has been saved
    _print(''); // New line
    _print('Done, output saved to $outputDir', _green);

    exit(0);
  } on ResolveTokenException catch (e) {
    _print(e.toString(), _red);
    rethrow;
  }
}

/// Save the output to the specified directory
void _saveOutput(List<TokenTheme> themes, String outputDir) {
  final generator = Generator(themes);
  generator.save(outputDir);
}

/// Process the tokens with all transformers
List<TokenTheme> _processTokens(List<TokenTheme> themes) {
  final processor = Processor(
    themes: themes,
    singleTokenTransformerFactories: singleTokenFactories,
    multiTokenTransformerFactories: multiTokenFactories,
  );

  processor.process();

  return processor.themes;
}

/// Parses the input json file and returns a list of resolved tokens
List<TokenTheme> _parseInput(String inputJson) {
  final input = json.decode(
    File(inputJson).readAsStringSync(),
  ) as Map<String, dynamic>;

  final setOrder = getSetsFromJson(input);
  final themes = getThemesFromJson(input);

  final parser = TokenParser(setOrder, themes)..parse(input);

  return parser.themes;
}

// ignore: avoid_print
void _print(String msg, [String color = _nc]) => print('$color$msg$_nc');
