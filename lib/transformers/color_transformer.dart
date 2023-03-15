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

class ColorTransformer extends Transformer {
  @override
  String get name => 'colors';

  @override
  String get type => 'Color';

  @override
  bool matcher(Token token) =>
      token.type == 'color' &&
      (token.valueAsString?.startsWith('#') == true ||
          token.valueAsString?.startsWith('rgb') == true ||
          token.valueAsString?.startsWith('hsla') == true);

  @override
  String transform(dynamic value) {
    if (value is String && value.startsWith('#')) {
      return _transformHex(value);
    } else if (value is String && value.startsWith('rgb')) {
      return _transformRgb(value);
    } else if (value is String && value.startsWith('hsla')) {
      return _transformHsla(value);
    }
    throw Exception('Unknown color format: $value');
  }

  /// Transforms a hex color to a Flutter color
  String _transformHex(String value) {
    final hex = value.substring(1).toUpperCase();
    final alpha = hex.length == 8 ? hex.substring(0, 2) : 'FF';
    final color = hex.length == 8 ? hex.substring(2) : hex;
    return 'const Color(0x$alpha$color)';
  }

  /// Transforms a rgb or rgba color to a Flutter color
  String _transformRgb(String value) {
    final start = value.startsWith('rgba') ? 5 : 4;
    final rgb = value
        .substring(start, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();
    final alpha = rgb.length == 4 ? rgb[3] : '1.0';
    final color = rgb.sublist(0, 3).join(', ');
    return 'const Color.fromRGBO($color, $alpha)';
  }

  /// Transforms a hsla color to a Flutter color
  String _transformHsla(String value) {
    final hsl = value
        .substring(5, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();
    final alpha = hsl.length == 4 ? hsl[3] : '1.0';
    final color = hsl.sublist(0, 3).join(', ');
    return 'HSLColor.fromAHSL($alpha, $color).toColor()';
  }
}
