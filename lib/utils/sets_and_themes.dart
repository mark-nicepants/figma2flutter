// Finds the order of the token sets in the input json
import 'package:figma2flutter/models/token_theme.dart';

List<String> getSetsFromJson(Map<String, dynamic> input) {
  return (input['\$metadata']?['tokenSetOrder'] as List? ?? [])
      .map((e) => e.toString())
      .toList();
}

// Finds the themes in the input json
List<TokenTheme> getThemesFromJson(Map<String, dynamic> input) {
  final sets = getSetsFromJson(input);

  final themes = input['\$themes'] as List?;
  if (themes == null || themes.isEmpty) return [];

  return themes
      .map((e) => TokenTheme.fromJson(e as Map<String, dynamic>, sets))
      .toList();
}
