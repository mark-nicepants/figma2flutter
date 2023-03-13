import 'package:args/args.dart' hide Option;
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/config/parser.dart';

class ArgumentParser extends Parser {
  final result = Options();
  final List<String> arguments;
  final argParser = ArgParser();

  ArgumentParser(this.arguments) {
    void addOption(Option element) {
      argParser.addOption(
        element.name,
        abbr: element.abbr,
        defaultsTo: element.defaultValue.toString(),
        callback: (String? v) {
          if (v == 'false') {
            element.value = false;
          } else if (v == 'true') {
            element.value = true;
          } else if (v != null) {
            element.value = v;
          }
        },
        help: element.help,
      );
    }

    result.options.forEach(addOption);
  }

  @override
  Future<Options> parse() async {
    argParser.parse(arguments);
    return result;
  }
}
