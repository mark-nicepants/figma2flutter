class ColorValue {
  final String value;

  ColorValue._(this.value);

  String declaration({bool isConst = true}) {
    return '${isConst ? 'const ' : ''}Color($value)';
  }

  @override
  String toString() => declaration();

  static ColorValue? maybeParse(dynamic value) {
    if (value == null || value is! String) return null;

    final color = _parse(value);
    if (color == null) return null;

    return ColorValue._(color);
  }

  static String? _parse(String value) {
    if (value.startsWith('#')) {
      return _transformHex(value);
    } else if (value.startsWith('rgb')) {
      return _transformRgb(value);
    } else if (value.startsWith('hsla')) {
      return _transformHsla(value);
    }
    return null;
  }

  /// Transforms a hex color to a Flutter color
  static String _transformHex(String value) {
    final color = value.substring(1).toUpperCase();
    final alpha = color.length == 8 ? color.substring(0, 2) : 'FF';
    final hex = color.length == 8 ? color.substring(2) : color;
    return '0x$alpha$hex';
  }

  /// Transforms a rgb or rgba color to a Flutter color
  static String _transformRgb(String value) {
    final start = value.startsWith('rgba') ? 5 : 4;
    final rgb = value
        .substring(start, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();

    final alpha = _toHex((rgb.length == 4 ? double.parse(rgb[3]) : 1.0) * 255);
    final hex = rgb.sublist(0, 3).map(int.parse).map(_toHex).join();

    return '0x$alpha$hex';
  }

  /// Transforms a hsla color to a Flutter color
  static String _transformHsla(String value) {
    final hsl = value
        .substring(5, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();

    final alpha = _toHex((hsl.length == 4 ? double.parse(hsl[3]) : 1.0) * 255);

    // Strip % from S and L values
    final color = hsl.sublist(0, 3).map((value) {
      if (value.endsWith('%')) {
        return double.parse(value.substring(0, value.length - 1));
      } else {
        return double.parse(value);
      }
    });

    // Convert HSL to Hex values
    final h = color.elementAt(0) / 360;
    final s = color.elementAt(1) / 100;
    final l = color.elementAt(2) / 100;

    double r, g, b;
    if (s == 0) {
      r = g = b = l * 255; // achromatic
    } else {
      var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      var p = 2 * l - q;
      r = _hue2rgb(p, q, h + 1 / 3) * 255;
      g = _hue2rgb(p, q, h) * 255;
      b = _hue2rgb(p, q, h - 1 / 3) * 255;
    }

    final hex = [r, g, b].map(_toHex).join();

    return '0x$alpha$hex';
  }

  static double _hue2rgb(double p, double q, double t) {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  }

  static String _toHex(num input) {
    return input.round().toRadixString(16).padLeft(2, '0').toUpperCase();
  }
}
