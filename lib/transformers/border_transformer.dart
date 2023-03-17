import 'package:figma2flutter/models/border_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class BorderTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) => token.type == 'border';

  @override
  String get name => 'borders';

  @override
  String transform(value) {
    final border = BorderValue.maybeParse(value)!;
    return border.toString();
  }

  @override
  String get type => 'Border';
}
