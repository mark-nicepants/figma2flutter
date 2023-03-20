import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

// Color Tokens

// https://docs.tokens.studio/available-tokens/color-tokens
// There are multiple ways you can write color tokens:

// Hex: #ff0000
// RGB: rgb(255, 0, 0)
// RGBA: rgba(255, 0, 0, 1)
// HSLA: hsla(120, 50%, 50%, 1)
// By default, a token references a Solid Paint (single colors).
//
// All colors are converted to Color(int) in Flutter.

class ColorTransformer extends SingleTokenTransformer {
  @override
  String get name => 'color';

  @override
  String get type => 'Color';

  @override
  bool matcher(Token token) =>
      token.type == 'color' &&
      (token.valueAsString?.startsWith('#') == true ||
          token.valueAsString?.startsWith('rgb') == true ||
          token.valueAsString?.startsWith('hsla') == true);

  @override
  String transform(Token token) {
    final value = token.value;

    ColorValue? colorValue = ColorValue.maybeParse(value);
    if (colorValue == null) {
      throw Exception('Invalid color value: $value');
    }

    if (token.hasExtensions) {
      final modify = token.extensions?['studio.tokens']?['modify'];
      if (modify != null) {
        final type = modify['type'];
        final value = double.tryParse(modify['value'] as String? ?? '0');
        final color = modify['color'] as String?;

        if (value != null && value != 0) {
          final amount = (value * 100).floor();
          if (type == 'lighten') {
            colorValue = colorValue.lighten(amount ~/ 2);
          } else if (type == 'darken') {
            colorValue = colorValue.darken(amount ~/ 2);
          } else if (color != null && type == 'mix' && color.startsWith('#')) {
            colorValue = colorValue.mix(color, amount);
          }
        }
      }
    }

    return colorValue.declaration();
  }
}
