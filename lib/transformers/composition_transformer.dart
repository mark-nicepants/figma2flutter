import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class CompositionTransformer extends SingleTokenTransformer {
  @override
  String get type => 'CompositionToken';

  @override
  bool matcher(Token token) => token.type == 'composition';

  @override
  String get name => 'compositions';

  @override
  String classDeclaration() {
    return '${super.classDeclaration()}\n\n$_extraClassesDeclaration';
  }

  @override
  String transform(dynamic value) {
    if (value is! Map<String, dynamic>) {
      throw Exception('Composition value should be a map');
    }

    final values = value;

    final size = _getSize(values);
    final padding = _getPadding(values);
    final fill = _getFill(values);
    final spacing = _getSpacing(values);

    final params = [
      size,
      padding,
      fill,
      spacing,
    ].where((e) => e != null).join(',\n  ');

    return '''
const CompositionToken(
$params,
)''';
  }

  String? _getSize(Map<String, dynamic> value) {
    final width = DimensionValue.maybeParse(value['width']);
    final height = DimensionValue.maybeParse(value['height']);

    if (width != null && height != null) {
      return 'size: const Size($width, $height)';
    }
    if (width != null) {
      return 'size: const Size.fromWidth($width)';
    }
    if (height != null) {
      return 'size: const Size.fromHeight($height)';
    }

    return null;
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
  padding: EdgeInsets.only(
    top: $topPadding,
    right: $rightPadding,
    bottom: $bottomPadding,
    left: $leftPadding,
  )''';
  }

  String? _getFill(Map<String, dynamic> values) {
    final fill = ColorValue.maybeParse(values['fill']);
    if (fill == null) {
      return null;
    }

    return 'fill: ${fill.declaration(isConst: false)}';
  }

  String? _getSpacing(Map<String, dynamic> values) {
    final spacing = DimensionValue.maybeParse(values['itemSpacing']);
    if (spacing == null) {
      return null;
    }

    return 'itemSpacing: $spacing';
  }
}

final _extraClassesDeclaration = '''
class CompositionToken {
  final EdgeInsets? padding;
  final Size? size;
  final Color? fill;
  final double? itemSpacing;

  const CompositionToken({
    this.padding,
    this.size,
    this.fill,
    this.itemSpacing,
  });
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
    return Container(
      color: token.fill,
      padding: token.padding,
      width: token.size?.width,
      height: token.size?.height,
      child: Flex(
        direction: axis,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children:
            token.itemSpacing != null ? children.separated(spacing) : children,
      ),
    );
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
