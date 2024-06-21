import 'dart:math';

import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';

class LinearGradientValue {
  final List<ColorValue> colors;
  final List<DimensionValue> stops;
  final double angle;

  LinearGradientValue._(this.colors, this.stops, this.angle);

  static LinearGradientValue? maybeParse(dynamic value) {
    if (value == null || value is! String) return null;
    if (!value.startsWith('linear-gradient')) return null;

    // Remove an extra character if the string ends with a semicolon
    final trailingCharacters = 1 + (value.endsWith(';') ? 1 : 0);
    final stripped = value
        .substring('linear-gradient('.length, value.length - trailingCharacters)
        .trim();

    // Convert rgba colors to hex so we can better parse the string
    final hexColors = _convertRgbColorsToHex(stripped);

    final firstComma = hexColors.indexOf(',');
    final angle =
        double.tryParse(hexColors.substring(0, hexColors.indexOf('deg')));

    final stops = hexColors.substring(firstComma + 1).trim().split(',');

    final colors = <ColorValue>[];
    final stopsList = <DimensionValue>[];
    for (var element in stops) {
      final splitted = element.trim().split(' ');

      final color = ColorValue.maybeParse(splitted[0].trim())!;
      colors.add(color);

      final stop = DimensionValue.maybeParse(splitted[1].trim())!;
      stopsList.add(stop);
    }

    return LinearGradientValue._(colors, stopsList, angle ?? 0);
  }

  @override
  String toString() {
    return '''const LinearGradient(
  colors: [${colors.map((e) => e.declaration(isConst: false)).join(', ')},],
  stops: $stops,
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(${(angle * pi / 180).toStringAsPrecision(3)}),
)''';
  }
}

String _convertRgbColorsToHex(String input) {
  final rgbaMatcher = RegExp(r'rgba\(([^)]+)\)');

  var updatedInput = input;
  var match = rgbaMatcher.firstMatch(updatedInput);

  while (match != null) {
    final color = ColorValue.maybeParse(match.group(0))!;

    updatedInput = updatedInput.replaceRange(
      match.start,
      match.end,
      color.toHex(),
    );

    match = rgbaMatcher.firstMatch(updatedInput);
  }

  return updatedInput;
}
