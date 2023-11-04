import 'dart:convert';
import 'dart:io';

import 'package:figma2flutter/models/token_theme.dart';
import 'package:path/path.dart';

/// Finds the order of the token sets in the input json
List<String> getSetsFromJson(Map<String, dynamic> input) {
  return (input['\$metadata']?['tokenSetOrder'] as List? ?? [])
      .map((e) => e.toString())
      .toList();
}

/// Finds the themes in the input json
List<TokenTheme> getThemesFromJson(Map<String, dynamic> input) {
  final sets = getSetsFromJson(input);

  final themes = input['\$themes'] as List?;
  if (themes == null || themes.isEmpty) return [];

  return themes
      .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, sets))
      .toList();
}

/// Accepts the contents of a `$themes` JSON that was probably loaded from a file
/// Returns the `$themes` changed so that it works in a single JSON structure
List<dynamic> themesAsSection(List<dynamic> themesContents) {
  // should copy by attribute to decouple
  List<dynamic> massagedThemeInfo = themesContents;
  // loop across each theme.  we have to remove pathing
  for (dynamic oneTheme in (themesContents)) {
    // create a new map so we don't have concurrent modificatin
    Map<String, dynamic> massagedSelectedTokenSets = {};
    // loop across each token set in this theme
    for (var oneSet
        in (oneTheme['selectedTokenSets'] as Map<String, dynamic>).entries) {
      massagedSelectedTokenSets[basename(oneSet.key)] = oneSet.value;
    }
    oneTheme['selectedTokenSets'] = massagedSelectedTokenSets;
    //_print('massaged tokens in selectedTokenSets: $massagedSelectedTokenSets');
  }
  return massagedThemeInfo;
}

/// Accepts the contents of a `$metadata` JSON that was probably loaded from a file
/// Returns the `$metadata` changed so that it works in a single JSON structure
Map<String, dynamic> metadataAsSection(Map<String, dynamic> metadataContents) {
  Map<String, dynamic> massagedMetadata = {};

  List<dynamic> metadataTokenSetOrder =
      metadataContents['tokenSetOrder'] as List<dynamic>;
  //_print('tokenSetOrder is $metadataTokenSetOrder');
  massagedMetadata = <String, dynamic>{};
  massagedMetadata['tokenSetOrder'] =
      metadataTokenSetOrder.map((path) => basename(path.toString())).toList();

  // _print('massagedMetadata has entries: ${massagedMetadata.keys.toList()}');
  // _print(
  //     'massagedMetadata.\$metadata has entries: ${massagedMetadata["\$metadata"]}');
  // _print(
  //     'massagedMetadata.\$metadata.tokenSetOrder has entries: ${massagedMetadata["\$metadata"]["tokenSetOrder"]}');

  return massagedMetadata;
}

/// Loads all the design token info into a single structure resulting in
/// something that looks like it would if it was all in one file
///
/// Creates a single JSON strcture from the driven by the $metadata.json
/// Adds the $metadata.json and $themes.json with pathing adjusted to in-memory
Map<String, dynamic> arrangeJsonFilesBySection(String tokenFileDirectory) {
  // each element of the token set is in this map keyed by the file name ish
  Map<String, dynamic> mergedTokenSet = {};

  // load the metadata contents and massage the paths to be map paths
  final metadataContents = json.decode(
    File('$tokenFileDirectory/\$metadata.json').readAsStringSync(),
  );
  mergedTokenSet['\$metadata'] =
      metadataAsSection(metadataContents as Map<String, dynamic>);

  // Load the themes and msassage the paths to the  contents to be map paths
  final themesContents = json.decode(
    File('$tokenFileDirectory/\$themes.json').readAsStringSync(),
  );
  mergedTokenSet['\$themes'] = themesAsSection(themesContents as List<dynamic>);

  //_print('Merged metadata and themes: $mergedTokenSet');

  // Iterate across the "tokenSetOrder" in the $metadata file and
  // Has to be the original file locations because they include paths
  // load the json files into their own sections in the map
  for (var onePath in metadataContents['tokenSetOrder'] as List<dynamic>) {
    var fullPath = '$tokenFileDirectory/$onePath.json';
    Map<String, dynamic> contents =
        jsonDecode(File(fullPath).readAsStringSync()) as Map<String, dynamic>;
    mergedTokenSet[basename(onePath as String)] = contents;
    //_print('added ${basename(onePath)} sub keys: ${contents.keys}');
  }
  return mergedTokenSet;
}
