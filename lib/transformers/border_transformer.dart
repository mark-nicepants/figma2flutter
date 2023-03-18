import 'package:figma2flutter/models/border_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class BorderTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) => token.type == 'border';

  @override
  String get name => 'border';

  @override
  String transform(Token token) {
    final border = BorderValue.maybeParse(token.value)!;
    return border.toString();
  }

  @override
  String get type => 'Border';
}
