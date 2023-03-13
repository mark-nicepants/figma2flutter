import 'package:figma2flutter/models/token.dart';

abstract class Transformer {
  final lines = <String>[];

  String get name;
  String get type;
  String get className => '${name[0].toUpperCase()}${name.substring(1)}Tokens';

  bool matcher(String type);

  String transform(dynamic value);

  void process(String variableName, Token token) {
    if (matcher(token.type)) {
      lines.add("static $type get $variableName => ${transform(token.value)};");
    }
  }

  String propertyDeclaration() {
    return 'static $className get $name => $className();';
  }

  String classDeclaration() {
    return '''
class $className {
  ${lines.join('\n  ')}
}
''';
  }
}
