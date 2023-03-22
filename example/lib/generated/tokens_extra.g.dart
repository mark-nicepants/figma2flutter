/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

part of tokens;

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

  InputDecoration asInputDecoration(BorderColors colors) {
    InputBorder borderForColor(Color color) {
      return OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
        borderSide: BorderSide(
          color: color,
          width: border?.top.width ?? 0,
        ),
      );
    }

    return InputDecoration(
      contentPadding: padding,
      fillColor: fill,
      filled: fill != null,
      border: borderForColor(colors.normal),
      enabledBorder: borderForColor(colors.normal),
      focusedBorder: borderForColor(colors.focussed),
      disabledBorder: borderForColor(colors.disabled),
      errorBorder: borderForColor(colors.error),
      focusedErrorBorder: borderForColor(colors.focussedError),
      errorStyle: textStyle,
    );
  }
}

class BorderColors {
  final Color normal;
  final Color focussed;
  final Color disabled;
  final Color error;
  final Color focussedError;

  const BorderColors({
    required this.normal,
    required this.focussed,
    required this.disabled,
    required this.error,
    required this.focussedError,
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
    Widget child = Flex(
      direction: axis,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: token.itemSpacing != null ? children.separated(spacing) : children,
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
    List<Widget> list = map((element) => <Widget>[element, separator]).expand((e) => e).toList();
    if (list.isNotEmpty) list = list..removeLast();
    return list;
  }
}

class Tokens extends InheritedWidget {
  const Tokens({
    super.key,
    required this.tokens,
    required super.child,
  });

  final ITokens tokens;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is Tokens && oldWidget.tokens != tokens;
  }

  static ITokens of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Tokens>()!.tokens;
  }
}

extension TokensExtension on BuildContext {
  ITokens get tokens => Tokens.of(this);
}
