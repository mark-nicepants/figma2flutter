import 'package:figma2flutter/models/dimension_value.dart';

class SizingValue {
  final DimensionValue? width;
  final DimensionValue? height;

  SizingValue._({
    this.width,
    this.height,
  });

  static SizingValue? maybeParse(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      final sizing = DimensionValue.maybeParse(value['sizing']);
      final width = DimensionValue.maybeParse(value['width']);
      final height = DimensionValue.maybeParse(value['height']);

      if (sizing == null && width == null && height == null) return null;

      if (sizing != null) {
        return SizingValue._(width: sizing, height: sizing);
      } else {
        return SizingValue._(width: width, height: height);
      }
    } else {
      final sizing = DimensionValue.maybeParse(value);
      if (sizing != null) {
        return SizingValue._(width: sizing, height: sizing);
      }
    }
    return null;
  }

  @override
  String toString() {
    if (width == null && height == null) return 'Size.infinite';
    if (width == null) return 'Size.fromHeight($height)';
    if (height == null) return 'Size.fromWidth($width)';

    return 'Size($width, $height)';
  }
}
