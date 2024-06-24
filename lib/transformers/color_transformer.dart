import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

// Color Tokens

// https://docs.tokens.studio/available-tokens/color-tokens
// There are multiple ways you can write color tokens:

// Hex: #ff0000
// RGB: rgb(255, 0, 0)
// RGBA: rgba(255, 0, 0, 1)
// HSL: hsl(120, 50%, 50%)
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
          token.valueAsString?.startsWith('hsl') == true);

  @override
  String transform(Token token) {
    final value = token.value;

    ColorValue? colorValue =
        ColorValue.maybeParse(value)?.applyStudioExtension(token.extensions);
    if (colorValue == null) {
      throw Exception('Invalid color value: $value');
    }

    return colorValue.declaration();
  }
}
