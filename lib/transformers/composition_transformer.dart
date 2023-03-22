import 'package:figma2flutter/models/border_value.dart';
import 'package:figma2flutter/models/box_shadow_value.dart';
import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/linear_gradient_value.dart';
import 'package:figma2flutter/models/sizing_value.dart';
import 'package:figma2flutter/models/text_style_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class CompositionTransformer extends SingleTokenTransformer {
  @override
  String get type => 'CompositionToken';

  @override
  bool matcher(Token token) => token.type == 'composition';

  @override
  String get name => 'composition';

  @override
  String classDeclaration(String theme) {
    return '${super.classDeclaration(theme)}\n\n$_extraClassesDeclaration';
  }

  @override
  String transform(Token token) {
    final value = token.value;

    if (value is! Map<String, dynamic>) {
      throw Exception('Composition value should be a map');
    }

    final values = value;

    final size = _getSize(values);
    final padding = _getPadding(values);
    final gradient = _getGradient(values);
    final fill = _getFill(values);
    final spacing = _getSpacing(values);
    final borderRadius = _getBorderRadius(values);
    final borders = _getBorders(values, borderRadius != null);
    final shadows = _getShadows(values);
    final textStyle = _getTextStyle(values);
    final opacity = _getOpacity(values);

    final params = [
      size,
      padding,
      gradient ?? fill, // Cannot be applied at the same time
      spacing,
      borderRadius,
      borders,
      shadows,
      textStyle,
      opacity,
    ].where((e) => e != null).join(',\n  ');

    return '''
CompositionToken(
  $params,
)''';
  }

  String? _getSize(Map<String, dynamic> value) {
    final size = SizingValue.maybeParse(value);
    return size != null ? 'size: const $size' : null;
  }

  String? _getPadding(Map<String, dynamic> values) {
    final zero = DimensionValue(0);
    final horizontalPadding =
        DimensionValue.maybeParse(values['horizontalPadding']);
    final verticalPadding =
        DimensionValue.maybeParse(values['verticalPadding']);

    final topPadding = DimensionValue.maybeParse(values['paddingTop']) ??
        verticalPadding ??
        zero;
    final rightPadding = DimensionValue.maybeParse(values['paddingRight']) ??
        horizontalPadding ??
        zero;
    final bottomPadding = DimensionValue.maybeParse(values['paddingBottom']) ??
        verticalPadding ??
        zero;
    final leftPadding = DimensionValue.maybeParse(values['paddingLeft']) ??
        horizontalPadding ??
        zero;

    return '''
padding: const EdgeInsets.only(
    top: $topPadding,
    right: $rightPadding,
    bottom: $bottomPadding,
    left: $leftPadding,
  )''';
  }

  String? _getGradient(Map<String, dynamic> values) {
    final gradient = LinearGradientValue.maybeParse(values['fill']);
    if (gradient == null) {
      return null;
    }

    return 'gradient: $gradient';
  }

  String? _getFill(Map<String, dynamic> values) {
    final fill = ColorValue.maybeParse(values['fill']);
    if (fill == null) {
      return null;
    }

    return 'fill: $fill';
  }

  String? _getSpacing(Map<String, dynamic> values) {
    final spacing = DimensionValue.maybeParse(values['itemSpacing']);
    if (spacing == null) {
      return null;
    }

    return 'itemSpacing: $spacing';
  }

  String? _getBorderRadius(Map<String, dynamic> values) {
    final radius = DimensionValue.maybeParse(values['borderRadius']);
    final borderRadiusTopLeft =
        DimensionValue.maybeParse(values['borderRadiusTopLeft']);
    final borderRadiusTopRight =
        DimensionValue.maybeParse(values['borderRadiusTopRight']);
    final borderRadiusBottomRight =
        DimensionValue.maybeParse(values['borderRadiusBottomRight']);
    final borderRadiusBottomLeft =
        DimensionValue.maybeParse(values['borderRadiusBottomLeft']);

    // If all null return null
    if (radius == null &&
        borderRadiusTopLeft == null &&
        borderRadiusTopRight == null &&
        borderRadiusBottomRight == null &&
        borderRadiusBottomLeft == null) {
      return null;
    }

    if (radius != null) {
      return 'borderRadius: BorderRadius.circular($radius)';
    }

    return '''
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular($borderRadiusTopLeft),
    topRight: Radius.circular($borderRadiusTopRight),
    bottomRight: Radius.circular($borderRadiusBottomRight),
    bottomLeft: Radius.circular($borderRadiusBottomLeft),
  )''';
  }

  String? _getBorders(Map<String, dynamic> values, bool hasBorderRadius) {
    final border = BorderValue.maybeParse(values['border']);
    final borderLeft = BorderValue.maybeParse(values['borderLeft']);
    final borderTop = BorderValue.maybeParse(values['borderTop']);
    final borderRight = BorderValue.maybeParse(values['borderRight']);
    final borderBottom = BorderValue.maybeParse(values['borderBottom']);

    // If all null return null
    if (border == null &&
        borderLeft == null &&
        borderTop == null &&
        borderRight == null &&
        borderBottom == null) {
      return null;
    }

    if (border != null) {
      return 'border: $border';
    }

    // Check if all widths are the same
    final widthsUniform = {
          borderLeft?.width.value,
          borderTop?.width.value,
          borderRight?.width.value,
          borderBottom?.width.value,
        }.length ==
        1;

    if (!widthsUniform && hasBorderRadius) {
      throw Exception(
        'Border widths must be uniform for all sides when making a Composition border with a border radius',
      );
    }

    final sides = <String>[];
    if (borderTop != null) {
      sides.add('top: ${borderTop.toStringForSide(BorderSide.top)}');
    }
    if (borderRight != null) {
      sides.add('right: ${borderRight.toStringForSide(BorderSide.right)}');
    }
    if (borderBottom != null) {
      sides.add('bottom: ${borderBottom.toStringForSide(BorderSide.bottom)}');
    }
    if (borderLeft != null) {
      sides.add('left: ${borderLeft.toStringForSide(BorderSide.left)}');
    }

    return '''
border: const Border(
    ${sides.join(',\n    ')},
  )''';
  }

  String? _getShadows(Map<String, dynamic> values) {
    final shadows = BoxShadowValueList.maybeParse(values['boxShadow']);
    return shadows == null ? null : 'boxShadow: $shadows';
  }

  String? _getTextStyle(Map<String, dynamic> values) {
    final textStyle = TextStyleValue.maybeParse(values['typography']);
    return textStyle == null ? null : 'textStyle: $textStyle';
  }

  String? _getOpacity(Map<String, dynamic> values) {
    final opacity = DimensionValue.maybeParse(values['opacity']);
    return opacity == null ? null : 'opacity: $opacity';
  }
}

final _extraClassesDeclaration = '''
class CompositionToken {
  final EdgeInsets? padding;
  final Size? size;
  final Color? fill;
  final LinearGradient? gradient;
  final double? itemSpacing;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;
  final double? opacity;

  const CompositionToken({
    this.padding,
    this.size,
    this.fill,
    this.gradient,
    this.itemSpacing,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.textStyle,
    this.opacity,
  });

  CompositionToken copyWith({
    EdgeInsets? padding,
    Size? size,
    Color? fill,
    LinearGradient? gradient,
    double? itemSpacing,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyle,
    double? opacity,
  }) {
    return CompositionToken(
      padding: padding ?? this.padding,
      size: size ?? this.size,
      fill: fill ?? this.fill,
      gradient: gradient ?? this.gradient,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      boxShadow: boxShadow ?? this.boxShadow,
      textStyle: textStyle ?? this.textStyle,
      opacity: opacity ?? this.opacity,
    );
  }
}

class Composition extends StatelessWidget {
  const Composition({
    required this.token,
    required this.axis,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    super.key,
  });

  final CompositionToken token;
  final Axis axis;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;

  Widget get spacing {
    if (axis == Axis.horizontal) {
      return SizedBox(width: token.itemSpacing);
    } else {
      return SizedBox(height: token.itemSpacing);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Flex(
      direction: axis,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children:
          token.itemSpacing != null ? children.separated(spacing) : children,
    );

    if (token.textStyle != null) {
      child = DefaultTextStyle(
        style: token.textStyle!,
        child: child,
      );
    }

    final container = Container(
      decoration: BoxDecoration(
        color: token.fill,
        gradient: token.gradient,
        borderRadius: token.borderRadius,
        border: token.border,
        boxShadow: token.boxShadow,
      ),
      padding: token.padding,
      width: token.size?.width,
      height: token.size?.height,
      child: child,
    );

    if (token.opacity != null) {
      return Opacity(
        opacity: token.opacity!,
        child: container,
      );
    }

    return container;
  }
}

extension WidgetListEx on List<Widget> {
  List<Widget> separated(Widget separator) {
    List<Widget> list = map((element) => <Widget>[element, separator])
        .expand((e) => e)
        .toList();
    if (list.isNotEmpty) list = list..removeLast();
    return list;
  }
}
''';
