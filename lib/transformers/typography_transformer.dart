import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/letter_spacing_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/models/font_family_value.dart';

import 'package:figma2flutter/models/font_weight_value.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class TypographyTransformer extends SingleTokenTransformer {
  @override
  String get name => 'textStyles';

  @override
  String get type => 'TextStyle';

  @override
  bool matcher(Token token) => token.type == 'typography';

  @override
  String transform(value) {
    final fontFamily = FontFamilyValue.maybeParse(value['fontFamily']);
    final fontWeight = FontWeightValue.maybeParse(value['fontWeight']);
    final lineHeight = DimensionValue.maybeParse(value['lineHeight']);
    final fontSize = DimensionValue.maybeParse(value['fontSize']);
    final letterSpacing = LetterSpacingValue.maybeParse(value['letterSpacing']);

    final parts = <String>[];

    if (fontFamily != null) parts.add("fontFamily: '$fontFamily'");
    if (fontSize != null) parts.add('fontSize: $fontSize');
    if (fontWeight != null) parts.add('fontWeight: $fontWeight');
    if (lineHeight != null) parts.add('height: $lineHeight');
    if (letterSpacing != null) parts.add('letterSpacing: $letterSpacing');

    return 'const TextStyle(${parts.join(', ')})';
  }
}
