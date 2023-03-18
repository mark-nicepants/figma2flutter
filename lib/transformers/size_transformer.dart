import 'package:figma2flutter/models/sizing_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class SizeTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) => [
        'sizing',
        'width',
        'height',
      ].contains(token.type);

  @override
  String get name => 'size';

  @override
  String get type => 'Size';

  @override
  String transform(Token token) {
    final value = token.value;
    return SizingValue.maybeParse(value)!.toString();
  }
}
