import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';

class BorderValue {
  final DimensionValue width;
  final ColorValue color;
  final BorderStyle style;

  BorderValue._(this.width, this.style, this.color);

  static BorderValue? maybeParse(dynamic value) {
    // value is required and must be a map
    if (value is! Map<String, dynamic>) {
      throw FormatException(
        'BorderValue must be a Map and not "$value" of type ${value.runtimeType}',
      );
    }

    final width =
        DimensionValue.maybeParse(value['width']) ?? DimensionValue.zero;
    final color = ColorValue.maybeParse(value['color']) ?? ColorValue.black;
    final style = BorderStyle.values.firstWhere(
      (e) => e.name == value['style'],
      orElse: () => BorderStyle.solid,
    );

    return BorderValue._(width, style, color);
  }

  @override
  String toString() {
    return 'Border.all(color: $color, width: $width, style: $style)';
  }

  String toStringForSide(BorderSide side) {
    return 'BorderSide(color: $color, width: $width, style: $style)';
  }
}

enum BorderStyle { solid }

enum BorderSide { top, right, bottom, left }
