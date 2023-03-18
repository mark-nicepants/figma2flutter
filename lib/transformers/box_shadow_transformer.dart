import 'package:figma2flutter/models/box_shadow_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class BoxShadowTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) {
    return token.type == 'boxShadow';
  }

  @override
  String get name => 'shadow';

  @override
  String get type => 'List<BoxShadow>';

  @override
  String transform(value) {
    final shadows = BoxShadowValueList.maybeParse(value);
    return shadows.toString();
  }
}
