import 'dart:io';

import 'package:figma2flutter/extensions/string.dart';
import 'package:figma2flutter/models/token_theme.dart';

/// Generates a Dart file with all the tokens.
class Generator {
  /// Creates a new [Generator] instance.
  Generator(this.themes);

  /// The list of transformers to generate code for.
  final List<TokenTheme> themes;

  /// Returns the generated code.
  String get output {
    final interfaces = <String>[];
    final classes = <String>[];

    final interFaceNames = <String, String>{};
    for (final transformer in themes.first.transformers) {
      interfaces.add(transformer.interfaceDeclaration());
      interFaceNames[transformer.name] = transformer.className;
    }

    final iTokenInterface = '''
abstract class ITokens {
  ${interFaceNames.entries.map((e) => '${e.value} get ${e.key};').join('\n  ')}
}''';

    interfaces.insert(0, iTokenInterface);

    for (final theme in themes) {
      final properties = <String>[];
      final insertAt = classes.length;
      for (final transformer in theme.transformers) {
        properties.add(transformer.propertyDeclaration(theme.name));
        classes.add(transformer.classDeclaration(theme.name));
      }

      final tokenClass = '''
class ${theme.name.capitalize}Tokens extends ITokens {
  ${properties.join('\n  ')}
}''';

      classes.insert(insertAt, tokenClass);
    }

    return '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

import 'package:flutter/material.dart';

${interfaces.join('\n\n')}

${classes.join('\n\n')}''';
  }

  /// Saves the generated code to the given [outputDirectory].
  void save(String outputDirectory) {
    final dir = Directory(outputDirectory)..createSync(recursive: true);
    final file = File('${dir.path}/tokens.g.dart');
    if (file.existsSync()) {
      file.deleteSync();
    }

    file.writeAsStringSync(output);
  }
}
