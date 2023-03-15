import 'package:figma2flutter/config/options.dart';

/// Abstract contract for a parser
abstract class Parser {
  // Parse any input and return the options
  Future<Options> parse();
}
