import 'package:figma2flutter/models/text_style_value.dart';
import 'package:figma2flutter/models/token.dart';

import 'package:figma2flutter/transformers/transformer.dart';

class TypographyTransformer extends SingleTokenTransformer {
  @override
  String get name => 'textStyle';

  @override
  String get type => 'TextStyle';

  @override
  bool matcher(Token token) => token.type == 'typography';

  @override
  String transform(value) {
    final textStyle = TextStyleValue.maybeParse(value);
    return textStyle!.toString();
  }
}
