import 'package:args/args.dart' hide Option;
import 'package:figma2flutter/config/options.dart';
import 'package:figma2flutter/config/parser.dart';

/// Parses the input arguments and returns the options
class ArgumentParser extends Parser {
  // All arguments passed to the program
  final List<String> _arguments;

  // The result of the parsing
  final _result = Options();

  // The argument parser
  final _argParser = ArgParser();

  // Constructor for the argument parser
  ArgumentParser(this._arguments) {
    void addOption(Option<dynamic> element) {
      _argParser.addOption(
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

    _result.options.forEach(addOption);
  }

  @override
  Future<Options> parse() async {
    _argParser.parse(_arguments);
    return _result;
  }
}
