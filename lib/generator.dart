import 'dart:io';

import 'package:figma2flutter/transformers/transformer.dart';

/// Generates a Dart file with all the tokens.
class Generator {
  /// Creates a new [Generator] instance.
  Generator(this.transformers);

  /// The list of transformers to generate code for.
  final List<Transformer> transformers;

  /// Returns the generated code.
  String get output {
    final properties = <String>[];
    final classes = <String>[];

    for (final transformer in transformers) {
      properties.add(transformer.propertyDeclaration());
      classes.add(transformer.classDeclaration());
    }

    return '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

import 'package:flutter/material.dart';

class Tokens {
  ${properties.join('\n  ')}
}

${classes.join('\n')}''';
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
