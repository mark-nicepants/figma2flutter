import 'package:figma2flutter/config/options.dart';

abstract class Parser {
  Future<Options> parse();
}
