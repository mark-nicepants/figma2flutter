import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/config/args_parser.dart';
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/exceptions/process_token_exception.dart';
import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/generator.dart';
import 'package:figma2flutter/models/token_theme.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/material_color_transformer.dart';
import 'package:figma2flutter/transformers/single_token_factories.dart';
import 'package:figma2flutter/utils/sets_and_themes.dart';

/// Code for making terminal output foreground red
const _red = '\x1b[033;0;31m';

/// Code for making terminal output foreground green
const _green = '\x1b[033;0;32m';

//No Color, reset terminal foreground color
const _nc = '\x1b[033;0m';

// All transformers that process multiple tokens should be added here
final multiTokenFactories = [
  MaterialColorTransformer.new,
];

// Entry point, parses the input arguments and runs the transformers
Future<void> main(List<String> arguments) async {
  final options = await ArgumentParser(arguments).parse();

  /// Get the input json file and output directory from the parsed arguments
  final inputFileLocation = options.getOption<String>(kInput).value;
  final outputDir = options.getOption<String>(kOutput).value;
  final filteredTokenSets = options.getOption<String>(kFilteredTokenSets).value;
  final List<String> filteredSets =
      filteredTokenSets.isNotEmpty ? filteredTokenSets.split(',').toList() : [];

  // Should remove the defaults because you get weird errors for data you didn't know about
  if (inputFileLocation.isEmpty) {
    _print('Missing parameter -i input file');
    exit(-1);
  }
  if (outputDir.isEmpty) {
    _print('Missing parameter -o output directory');
    exit(-1);
  }

  // To be able to debug the example app, uncomment the following lines and
  // comment the lines above. Then run main in debug mode.
  // final inputJson = 'example/bin/example-themes.json';
  // final outputDir = 'example/lib/generated';

  /// Parse the input json file and get all resolved tokens from the parser
  try {
    List<TokenTheme> themes;
    if (FileSystemEntity.isDirectorySync(inputFileLocation)) {
      _print(
        'Loading `\$metadata`, `\$themes` and design token files from $inputFileLocation',
        _green,
      );
      _print(''); // New line
      themes = _parseFromFileSet(inputFileLocation);
    } else {
      _print('Loading design tokens from $inputFileLocation', _green);
      _print(''); // New line
      themes = _parseInputFromFile(inputFileLocation);
    }

    /// Print the number of tokens found to the terminal output
    _print('Found ${themes.length} themes, generating code', _green);

    /// Process the tokens with all transformers
    final result = _processTokens(themes, filteredSets);

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
  } on ProcessTokenException catch (e) {
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
List<TokenTheme> _processTokens(
  List<TokenTheme> themes,
  List<String> filteredSets,
) {
  final processor = Processor(
    themes: themes,
    singleTokenTransformerFactories: singleTokenFactories,
    multiTokenTransformerFactories: multiTokenFactories,
  );

  processor.process(filteredSets: filteredSets);

  return processor.themes;
}

/// Parses the input from the files in tokenFileDirectory and returns list of resolved tokens
List<TokenTheme> _parseFromFileSet(String tokenFileDirectory) {
  Map<String, dynamic> inputJson =
      arrangeJsonFilesBySection(tokenFileDirectory);
  final themes = _parseInputJson(inputJson);
  return themes;
}

/// Parses the input json file and returns a list of resolved tokens
List<TokenTheme> _parseInputFromFile(String inputJsonLocation) {
  final input = json.decode(
    File(inputJsonLocation).readAsStringSync(),
  ) as Map<String, dynamic>;
  return _parseInputJson(input);
}

/// Accepts input json loaded from somewhere and returns list of resolved tokens
List<TokenTheme> _parseInputJson(Map<String, dynamic> inputJson) {
  final setOrder = getSetsFromJson(inputJson);
  final themes = getThemesFromJson(inputJson);

  // _print('inputJson:  ${inputJson.keys}');
  // _print('setOrder: $setOrder');
  // _print('themes: $themes');

  final parser = TokenParser(setOrder, themes)..parse(inputJson);

  return parser.themes;
}

// ignore: avoid_print
void _print(String msg, [String color = _nc]) => print('$color$msg$_nc');
