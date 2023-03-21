import 'dart:math' as math;

class ColorValue {
  final int r; // 0 - 255
  final int g; // 0 - 255
  final int b; // 0 - 255
  final int a; // 0 - 255

  static ColorValue get black => ColorValue._(0, 0, 0, 255);

  ColorValue._(this.r, this.g, this.b, this.a);

  String declaration({bool isConst = true}) {
    return '${isConst ? 'const ' : ''}Color(${toHex8()})';
  }

  List<num> toRgb() {
    return [r, g, b];
  }

  String toHex() {
    return '#${_toHex(r)}${_toHex(g)}${_toHex(b)}${_toHex(a)}'.toUpperCase();
  }

  String toHex8() {
    return '0x${'${_toHex(a)}${_toHex(r)}${_toHex(g)}${_toHex(b)}'.toUpperCase()}';
  }

  ColorValue lighten(double amount) {
    final rgb = toHSL().lighten(amount).toRGB();
    return ColorValue._(rgb[0], rgb[1], rgb[2], a);
  }

  ColorValue darken(double amount) {
    final rgb = toHSL().darken(amount).toRGB();
    return ColorValue._(rgb[0], rgb[1], rgb[2], a);
  }

  ColorValue mix(String value, double amount) {
    final other = maybeParse(value)!;

    final newa = ((other.a - a) * amount + a).round();
    final newr = ((other.r - r) * amount + r).round();
    final newg = ((other.g - g) * amount + g).round();
    final newb = ((other.b - b) * amount + b).round();

    return ColorValue._(newr, newg, newb, newa);
  }

  @override
  String toString() => declaration();

  HSL toHSL() {
    final rgb = toRgb();
    final r = rgb[0].toDouble();
    final g = rgb[1].toDouble();
    final b = rgb[2].toDouble();

    return HSL.fromRGB(r, g, b);
  }

  static ColorValue? maybeParse(dynamic value) {
    if (value == null || value is! String) return null;

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
  static ColorValue _transformHex(String value) {
    final color = value.substring(1).toUpperCase();
    final alpha = color.length == 8 ? color.substring(6, 8) : 'FF';
    final hex = color.length == 8 ? color.substring(0, 6) : color;

    final a = int.parse(alpha, radix: 16);
    final r = int.parse(hex.substring(0, 2), radix: 16);
    final g = int.parse(hex.substring(2, 4), radix: 16);
    final b = int.parse(hex.substring(4, 6), radix: 16);

    return ColorValue._(r, g, b, a);
  }

  /// Transforms a rgb or rgba color to a ColorValue
  static ColorValue _transformRgb(String value) {
    final start = value.startsWith('rgba') ? 5 : 4;
    final rgb = value
        .substring(start, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();

    final a = ((rgb.length == 4 ? double.parse(rgb[3]) : 1.0) * 255).round();
    final rgbi = rgb.sublist(0, 3).map(int.parse);

    final r = rgbi.elementAt(0);
    final g = rgbi.elementAt(1);
    final b = rgbi.elementAt(2);

    return ColorValue._(r, g, b, a);
  }

  /// Transforms a hsla color to a Flutter color
  static ColorValue _transformHsla(String value) {
    final hsl = value
        .substring(5, value.length - 1)
        .split(',')
        .map((e) => e.trim())
        .toList();

    final a = ((hsl.length == 4 ? double.parse(hsl[3]) : 1.0) * 255).round();

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

    final rgb = HSL(h, s, l).toRGB();

    final r = rgb[0];
    final g = rgb[1];
    final b = rgb[2];

    return ColorValue._(r, g, b, a);
  }
}

class HSL {
  final double h;
  final double s;
  final double l;

  HSL(this.h, this.s, this.l);

  @override
  String toString() {
    return 'HSL($h, $s, $l)';
  }

  HSL lighten(double amount) {
    return HSL(h, s, l + amount);
  }

  HSL darken(double amount) {
    return HSL(h, s, l - amount);
  }

  String toHex() {
    return toRGB().map(_toHex).join(); // RRGGBB (without #)
  }

  static HSL fromRGB(double r, double g, double b) {
    final double rBound = _bound(r, 255.0);
    final double gBound = _bound(g, 255.0);
    final double bBound = _bound(b, 255.0);

    final max = [rBound, gBound, bBound].reduce(math.max);
    final min = [rBound, gBound, bBound].reduce(math.min);
    double h = 0.0;
    double s = 0.0;
    final double l = (max + min) / 2;

    if (max == min) {
      h = s = 0.0;
    } else {
      final double d = max - min;
      s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min);
      if (max == rBound) {
        h = (gBound - bBound) / d + (gBound < bBound ? 6 : 0);
      } else if (max == gBound) {
        h = (bBound - rBound) / d + 2;
      } else if (max == bBound) {
        h = (rBound - gBound) / d + 4;
      }
    }

    h /= 6.0;
    return HSL(h, s, l);
  }

  List<int> toRGB() {
    double r;
    double g;
    double b;

    final double h = _bound(this.h * 360, 360.0);
    final double s = _bound(this.s * 100, 100.0);
    final double l = _bound(this.l * 100, 100.0);

    if (s == 0.0) {
      r = g = b = l;
    } else {
      final q = l < 0.5 ? l * (1.0 + s) : l + s - l * s;
      final p = 2 * l - q;
      r = _hue2rgb(p, q, h + 1 / 3);
      g = _hue2rgb(p, q, h);
      b = _hue2rgb(p, q, h - 1 / 3);
    }
    return [r, g, b].map((e) => (e * 255).round()).toList();
  }
}

String _toHex(num input) {
  return input.round().toRadixString(16).padLeft(2, '0').toUpperCase();
}

double _bound(double value, double max) {
  final double n = max == 360.0 ? value : math.min(max, math.max(0.0, value));
  final double absDifference = n - max;
  if (absDifference.abs() < 0.000001) {
    return 1.0;
  }

  if (max == 360) {
    return (n < 0 ? n % max + max : n % max) / max;
  } else {
    return (n % max) / max;
  }
}

double _hue2rgb(double p, double q, double t) {
  if (t < 0) t += 1;
  if (t > 1) t -= 1;
  if (t < 1 / 6) return p + (q - p) * 6 * t;
  if (t < 1 / 2) return q;
  if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
  return p;
}
