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

    // Handle the new 'shouldOmitCore' flag
    _argParser.addFlag(
      kShouldOmitCore,
      abbr: kShouldOmitCoreAbbr,
      defaultsTo: false,
      help: 'Specify to omit "core" tokens.',
    );
  }

  @override
  Future<Options> parse() async {
    // Parse the arguments to set the options and flags
    final parsedArgs = _argParser.parse(_arguments);

    // Set the value of the shouldOmitCore flag in the _result
    _result.shouldOmitCoreFlag = parsedArgs[kShouldOmitCore] as bool;

    return _result;
  }

  // Retrieve the flag value
  bool get shouldOmitCore =>
      _argParser.parse(_arguments)[kShouldOmitCore] as bool;
}
