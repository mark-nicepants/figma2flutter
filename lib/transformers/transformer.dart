import 'package:figma2flutter/models/token.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

/// A transformer is responsible for transforming a token into code
/// that can be used in the generated code.
abstract class Transformer {
  // The lines of code that will be generated for this transformer
  final lines = <String>[];

  // The name of the property that will be generated in the Tokens class
  String get name;

  // The name of the class that will be generated
  String get className => '${name.pascalCase}Tokens';

  // Returns true if the token should be processed by this transformer
  @protected
  bool matcher(Token token);

  String interfaceDeclaration() {
    return '''abstract class $className {
  ${lines.map(_toInterfaceDeclaration).join('\n  ')}
}''';
  }

  // Returns the code that will be generated for the property declaration
  String propertyDeclaration(String theme) {
    return '@override\n  $className get $name => ${theme.pascalCase}$className();';
  }

  void process(Token token);

  // Returns the class that is generated for this transformer including all processed tokens
  String classDeclaration(String theme) {
    return '''
class ${theme.pascalCase}$className extends $className {
  ${lines.join('\n  ')}
}
''';
  }

  String _toInterfaceDeclaration(String input) {
    return '${input.substring(0, input.indexOf('=>')).replaceAll('@override\n', '').trim()};';
  }

  String? extraDeclaration() => null;
}

abstract class SingleTokenTransformer extends Transformer {
  // Returns the code that will be generated for the token
  @protected
  String transform(Token token);

  // The type of the properties that will be generated
  String get type;

  // Processes the token and adds the generated code to the lines list
  @override
  void process(Token token) {
    if (matcher(token)) {
      lines.add(
        '@override\n  $type get ${token.variableName} => ${transform(token)};',
      );
    }
  }
}

abstract class MultiTokenTransformer extends Transformer {
  final List<Token> token;

  MultiTokenTransformer(this.token);

  void postProcess();
}
