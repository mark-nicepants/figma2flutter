import 'dart:io';

import 'package:figma2flutter/models/token_theme.dart';
import 'package:recase/recase.dart';

const _genWarning = '''
/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************''';

/// Generates a Dart file with all the tokens.
class Generator {
  /// Creates a new [Generator] instance.
  Generator(this.themes);

  /// The list of transformers to generate code for.
  final List<TokenTheme> themes;

  // Returns the content for tokens_extra.g.dart
  String get extra {
    final extraContent = <String>[];
    for (final transformer in themes.first.transformers) {
      if (transformer.extraDeclaration() != null) {
        extraContent.add(transformer.extraDeclaration()!);
      }
    }
    return '''
$_genWarning

part of 'tokens.g.dart';

${extraContent.join('\n\n')}

$_helpers
''';
  }

  /// Returns the generated token themes code. (tokens.g.dart)
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
class ${theme.name.pascalCase}Tokens extends ITokens {
  ${properties.join('\n  ')}
}''';

      classes.insert(insertAt, tokenClass);
    }

    return '''
$_genWarning

library tokens;

import 'package:flutter/material.dart';

part 'tokens_extra.g.dart';

${interfaces.join('\n\n')}

${classes.join('\n\n')}''';
  }

  /// Saves the generated code to the given [outputDirectory].
  void save(String outputDirectory) {
    final dir = Directory(outputDirectory)..createSync(recursive: true);

    _save(output, to: '${dir.path}/tokens.g.dart');
    _save(extra, to: '${dir.path}/tokens_extra.g.dart');
  }

  void _save(String content, {required String to}) {
    final file = File(to);
    if (file.existsSync()) {
      file.deleteSync();
    }
    file.writeAsStringSync(content);
  }
}

final _helpers = '''
class Tokens extends InheritedWidget {
  const Tokens({
    super.key,
    required this.tokens,
    required super.child,
  });

  final ITokens tokens;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is Tokens && oldWidget.tokens != tokens;
  }

  static ITokens of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Tokens>()!.tokens;
  }
}

extension TokensExtension on BuildContext {
  ITokens get tokens => Tokens.of(this);
}
''';
