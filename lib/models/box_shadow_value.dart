import 'package:collection/collection.dart';
import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';

class BoxShadowValueList {
  final List<BoxShadowValue> shadows;

  BoxShadowValueList(this.shadows);

  static BoxShadowValueList? maybeParse(dynamic value) {
    if (value == null) return null;

    if (value is List) {
      final list = value.map(BoxShadowValue.maybeParse).toList();
      final shadows = list.whereNotNull().toList();
      return BoxShadowValueList(shadows);
    } else {
      return BoxShadowValueList(
        [BoxShadowValue.maybeParse(value)].whereNotNull().toList(),
      );
    }
  }

  @override
  String toString() {
    return '''const [
${shadows.join(',\n')},
]''';
  }
}

class BoxShadowValue {
  final DimensionValue x;
  final DimensionValue y;
  final DimensionValue blur;
  final DimensionValue spread;
  final ColorValue color;
  final BoxShadowType type;

  BoxShadowValue._(
    this.x,
    this.y,
    this.blur,
    this.spread,
    this.color,
    this.type,
  );

  static BoxShadowValue? maybeParse(dynamic value) {
    final x = DimensionValue.maybeParse(value['x'] ?? 0)!;
    final y = DimensionValue.maybeParse(value['y'] ?? 0)!;
    final blur = DimensionValue.maybeParse(value['blur'] ?? 0)!;
    final spread = DimensionValue.maybeParse(value['spread'] ?? 0)!;
    final color = ColorValue.maybeParse(value['color'] ?? '#000000')!;

    // TODO(mark): Add support for inner shadows

    return BoxShadowValue._(
      x,
      y,
      blur,
      spread,
      color,
      BoxShadowType.dropShadow,
    );
  }

  @override
  String toString() {
    return '''
  BoxShadow(
    offset: Offset(${x.value}, ${y.value}),
    blurRadius: ${blur.value},
    spreadRadius: ${spread.value},
    color: ${color.declaration(isConst: false)},
  )''';
  }
}

enum BoxShadowType { dropShadow, innerShadow }
