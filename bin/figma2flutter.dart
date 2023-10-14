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
import 'package:path/path.dart';

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
  final inputFileLocation = options.getOption<String>(kInput).value;
  final outputDir = options.getOption<String>(kOutput).value;

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
          _green);
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

/// Loads all the design token info into a single structure resulting in
/// something that looks like it would if it was all in one file
///
/// Creates a single JSON strcture from the driven by the $metadata.json
/// Add the $metadata.json and $themes.json
Map<String, dynamic> _arrangeJsonFilesBySection(String inputFileLocation) {
  // each element of the token set is in this map keyed by the file name ish
  Map<String, dynamic> mergedTokenSet = {};

  // load the metadata contents and massage the paths to be map paths
  final metadataContents = json.decode(
    File('$inputFileLocation/\$metadata.json').readAsStringSync(),
  );
  List<dynamic> metadataTokenSetOrder =
      metadataContents['tokenSetOrder'] as List<dynamic>;
  //_print('tokenSetOrder is $metadataTokenSetOrder');
  mergedTokenSet['\$metadata'] = <String, dynamic>{};
  mergedTokenSet['\$metadata']['tokenSetOrder'] =
      metadataTokenSetOrder.map((path) => basename(path.toString())).toList();

  // _print('mergedTokenSet has entries: ${mergedTokenSet.keys.toList()}');
  // _print(
  //     'mergedTokenSet.\$metadata has entries: ${mergedTokenSet["\$metadata"]}');
  // _print(
  //     'mergedTokenSet.\$metadata.tokenSetOrder has entries: ${mergedTokenSet["\$metadata"]["tokenSetOrder"]}');

  // Load the themes and msassage the paths to the  contents to be map paths
  final themesContents = json.decode(
    File('$inputFileLocation/\$themes.json').readAsStringSync(),
  );
  mergedTokenSet['\$themes'] = themesContents;
  // loop across the themes  we have to remove pathing
  for (dynamic oneTheme in (mergedTokenSet['\$themes'] as List<dynamic>)) {
    // create a new map so we don't have concurrent modificatin
    Map<String, dynamic> massagedSelectedTokenSets = {};
    for (var oneSet
        in (oneTheme['selectedTokenSets'] as Map<String, dynamic>).entries) {
      massagedSelectedTokenSets[basename(oneSet.key)] = oneSet.value;
    }
    oneTheme['selectedTokenSets'] = massagedSelectedTokenSets;
    //_print('massaged tokens in selectedTokenSets: $massagedSelectedTokenSets');
  }

  // Iterate across the "tokenSetOrder" in the $metadata file and
  // load the json files into their own sections in the map
  for (var onePath in metadataContents['tokenSetOrder'] as List<dynamic>) {
    var fullPath = '$inputFileLocation/$onePath.json';
    Map<String, dynamic> contents =
        jsonDecode(File(fullPath).readAsStringSync()) as Map<String, dynamic>;
    mergedTokenSet[basename(onePath as String)] = contents;
    //print('added ${basename(onePath)} sub keys: ${contents.keys}');
  }
  return mergedTokenSet;
}

/// Parses the input from the files in $metadata.json and returns list of resolved tokens
List<TokenTheme> _parseFromFileSet(String inputFileLocation) {
  Map<String, dynamic> inputJson =
      _arrangeJsonFilesBySection(inputFileLocation);
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
