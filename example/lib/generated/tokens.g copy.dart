import 'package:flutter/material.dart';

class Tokens extends InheritedWidget {
  const Tokens({
    super.key,
    required this.tokens,
    required super.child,
  });

  final ITokens tokens;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static ITokens of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Tokens>()!.tokens;
  }
}

abstract class ITokens {
  ColorTokens get color;
}

class TokensThemeWhite extends ITokens {
  @override
  ColorTokens get color => ColorTokens();
  static SpacingTokens get spacing => SpacingTokens();
  static TextStyleTokens get textStyle => TextStyleTokens();
  static RadiiTokens get radii => RadiiTokens();
  static CompositionTokens get composition => CompositionTokens();
  static ShadowTokens get shadow => ShadowTokens();
  static BorderTokens get border => BorderTokens();
  static SizeTokens get size => SizeTokens();
  static GradientTokens get gradient => GradientTokens();
  static MaterialColorTokens get materialColor => MaterialColorTokens();
}

class ColorTokens {
  Color get colorsBlack => const Color(0xFF000000);
  Color get colorsWhite => const Color(0xFFFFFFFF);
  Color get colorsGray100 => const Color(0xFFF7FAFC);
  Color get colorsGray200 => const Color(0xFFEDF2F7);
  Color get colorsGray300 => const Color(0xFFE2E8F0);
  Color get colorsGray400 => const Color(0xFFCBD5E0);
  Color get colorsGray500 => const Color(0xFFA0AEC0);
  Color get colorsGray600 => const Color(0xFF718096);
  Color get colorsGray700 => const Color(0xFF4A5568);
  Color get colorsGray800 => const Color(0xFF2D3748);
  Color get colorsGray900 => const Color(0xFF1A202C);
  Color get colorsRed100 => const Color(0xFFFFF5F5);
  Color get colorsRed200 => const Color(0xFFFED7D7);
  Color get colorsRed300 => const Color(0xFFFEB2B2);
  Color get colorsRed400 => const Color(0xFFFC8181);
  Color get colorsRed500 => const Color(0xFFF56565);
  Color get colorsRed600 => const Color(0xFFE53E3E);
  Color get colorsRed700 => const Color(0xFFC53030);
  Color get colorsRed800 => const Color(0xFF9B2C2C);
  Color get colorsRed900 => const Color(0xFF742A2A);
  Color get colorsOrange100 => const Color(0xFFFFFAF0);
  Color get colorsOrange200 => const Color(0xFFFEEBC8);
  Color get colorsOrange300 => const Color(0xFFFBD38D);
  Color get colorsOrange400 => const Color(0xFFF6AD55);
  Color get colorsOrange500 => const Color(0xFFED8936);
  Color get colorsOrange600 => const Color(0xFFDD6B20);
  Color get colorsOrange700 => const Color(0xFFC05621);
  Color get colorsOrange800 => const Color(0xFF9C4221);
  Color get colorsOrange900 => const Color(0xFF7B341E);
  Color get colorsYellow100 => const Color(0xFFFFFFF0);
  Color get colorsYellow200 => const Color(0xFFFEFCBF);
  Color get colorsYellow300 => const Color(0xFFFAF089);
  Color get colorsYellow400 => const Color(0xFFF6E05E);
  Color get colorsYellow500 => const Color(0xFFECC94B);
  Color get colorsYellow600 => const Color(0xFFD69E2E);
  Color get colorsYellow700 => const Color(0xFFB7791F);
  Color get colorsYellow800 => const Color(0xFF975A16);
  Color get colorsYellow900 => const Color(0xFF744210);
  Color get colorsGreen100 => const Color(0xFFF0FFF4);
  Color get colorsGreen200 => const Color(0xFFC6F6D5);
  Color get colorsGreen300 => const Color(0xFF9AE6B4);
  Color get colorsGreen400 => const Color(0xFF68D391);
  Color get colorsGreen500 => const Color(0xFF48BB78);
  Color get colorsGreen600 => const Color(0xFF38A169);
  Color get colorsGreen700 => const Color(0xFF2F855A);
  Color get colorsGreen800 => const Color(0xFF276749);
  Color get colorsGreen900 => const Color(0xFF22543D);
  Color get colorsTeal100 => const Color(0xFFE6FFFA);
  Color get colorsTeal200 => const Color(0xFFB2F5EA);
  Color get colorsTeal300 => const Color(0xFF81E6D9);
  Color get colorsTeal400 => const Color(0xFF4FD1C5);
  Color get colorsTeal500 => const Color(0xFF38B2AC);
  Color get colorsTeal600 => const Color(0xFF319795);
  Color get colorsTeal700 => const Color(0xFF2C7A7B);
  Color get colorsTeal800 => const Color(0xFF285E61);
  Color get colorsTeal900 => const Color(0xFF234E52);
  Color get colorsBlue100 => const Color(0xFFEBF8FF);
  Color get colorsBlue200 => const Color(0xFFBEE3F8);
  Color get colorsBlue300 => const Color(0xFF90CDF4);
  Color get colorsBlue400 => const Color(0xFF63B3ED);
  Color get colorsBlue500 => const Color(0xFF4299E1);
  Color get colorsBlue600 => const Color(0xFF3182CE);
  Color get colorsBlue700 => const Color(0xFF2B6CB0);
  Color get colorsBlue800 => const Color(0xFF2C5282);
  Color get colorsBlue900 => const Color(0xFF2A4365);
  Color get colorsIndigo100 => const Color(0xFFEBF4FF);
  Color get colorsIndigo200 => const Color(0xFFC3DAFE);
  Color get colorsIndigo300 => const Color(0xFFA3BFFA);
  Color get colorsIndigo400 => const Color(0xFF7F9CF5);
  Color get colorsIndigo500 => const Color(0xFF667EEA);
  Color get colorsIndigo600 => const Color(0xFF5A67D8);
  Color get colorsIndigo700 => const Color(0xFF4C51BF);
  Color get colorsIndigo800 => const Color(0xFF434190);
  Color get colorsIndigo900 => const Color(0xFF3C366B);
  Color get colorsPurple100 => const Color(0xFFFAF5FF);
  Color get colorsPurple200 => const Color(0xFFE9D8FD);
  Color get colorsPurple300 => const Color(0xFFD6BCFA);
  Color get colorsPurple400 => const Color(0xFFB794F4);
  Color get colorsPurple500 => const Color(0xFF9F7AEA);
  Color get colorsPurple600 => const Color(0xFF805AD5);
  Color get colorsPurple700 => const Color(0xFF6B46C1);
  Color get colorsPurple800 => const Color(0xFF553C9A);
  Color get colorsPurple900 => const Color(0xFF44337A);
  Color get colorsPink100 => const Color(0xFFFFF5F7);
  Color get colorsPink200 => const Color(0xFFFED7E2);
  Color get colorsPink300 => const Color(0xFFFBB6CE);
  Color get colorsPink400 => const Color(0xFFF687B3);
  Color get colorsPink500 => const Color(0xFFED64A6);
  Color get colorsPink600 => const Color(0xFFD53F8C);
  Color get colorsPink700 => const Color(0xFFB83280);
  Color get colorsPink800 => const Color(0xFF97266D);
  Color get colorsPink900 => const Color(0xFF702459);
  Color get fgDefault => const Color(0xFFFFFFFF);
  Color get fgMuted => const Color(0xFFE2E8F0);
  Color get fgSubtle => const Color(0xFFA0AEC0);
  Color get bgDefault => const Color(0xFF1A202C);
  Color get bgMuted => const Color(0xFF4A5568);
  Color get bgSubtle => const Color(0xFF718096);
  Color get accentDefault => const Color(0xFF5A67D8);
  Color get accentOnAccent => const Color(0xFFFFFFFF);
  Color get accentBg => const Color(0xFF434190);
  Color get shadowsDefault => const Color(0x4D000000);
}

class SpacingTokens {}

class TextStyleTokens {
  TextStyle get typographyH1Bold => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 48.828125,
        height: 1.1,
        letterSpacing: -0.8,
      );
  TextStyle get typographyH1Regular => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 48.828125,
        height: 1.1,
        letterSpacing: -0.8,
      );
  TextStyle get typographyH5Bold => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        height: 1.1,
        letterSpacing: -0.8,
      );
  TextStyle get typographyH5Regular => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.0,
        height: 1.1,
        letterSpacing: -0.8,
      );
  TextStyle get typographyBody => const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16.0,
        height: 1.1,
      );
}

class RadiiTokens {
  BorderRadius get borderRadiusSm => BorderRadius.circular(4.0);
  BorderRadius get borderRadiusLg => BorderRadius.circular(8.0);
  BorderRadius get borderRadiusXl => BorderRadius.circular(16.0);
  BorderRadius get borderRadiusMultiValue => BorderRadius.circular(4.0);
  BorderRadius get buttonBorderRadius => BorderRadius.circular(8.0);
  BorderRadius get cardBorderRadius => BorderRadius.circular(8.0);
}

class CompositionTokens {
  CompositionToken get cardComp => const CompositionToken(
        padding: EdgeInsets.only(
          top: 32.0,
          right: 32.0,
          bottom: 32.0,
          left: 32.0,
        ),
        itemSpacing: 32.0,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            blurRadius: 5.0,
            spreadRadius: 3.0,
            color: Color(0x26000000),
          ),
        ],
      );
  CompositionToken get buttonComp => const CompositionToken(
        padding: EdgeInsets.only(
          top: 8.0,
          right: 16.0,
          bottom: 8.0,
          left: 16.0,
        ),
      );
}

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

class ShadowTokens {
  List<BoxShadow> get boxShadowDefault => const [
        BoxShadow(
          offset: Offset(0.0, 5.0),
          blurRadius: 5.0,
          spreadRadius: 3.0,
          color: Color(0x26000000),
        ),
      ];
}

class BorderTokens {}

class SizeTokens {}

class GradientTokens {}

class MaterialColorTokens {
  MaterialColor get colorsGray => const MaterialColor(0xFFA0AEC0, {
        100: Color(0xFFF7FAFC),
        200: Color(0xFFEDF2F7),
        300: Color(0xFFE2E8F0),
        400: Color(0xFFCBD5E0),
        500: Color(0xFFA0AEC0),
        600: Color(0xFF718096),
        700: Color(0xFF4A5568),
        800: Color(0xFF2D3748),
        900: Color(0xFF1A202C),
      });

  MaterialColor get colorsRed => const MaterialColor(0xFFF56565, {
        100: Color(0xFFFFF5F5),
        200: Color(0xFFFED7D7),
        300: Color(0xFFFEB2B2),
        400: Color(0xFFFC8181),
        500: Color(0xFFF56565),
        600: Color(0xFFE53E3E),
        700: Color(0xFFC53030),
        800: Color(0xFF9B2C2C),
        900: Color(0xFF742A2A),
      });

  MaterialColor get colorsOrange => const MaterialColor(0xFFED8936, {
        100: Color(0xFFFFFAF0),
        200: Color(0xFFFEEBC8),
        300: Color(0xFFFBD38D),
        400: Color(0xFFF6AD55),
        500: Color(0xFFED8936),
        600: Color(0xFFDD6B20),
        700: Color(0xFFC05621),
        800: Color(0xFF9C4221),
        900: Color(0xFF7B341E),
      });

  MaterialColor get colorsYellow => const MaterialColor(0xFFECC94B, {
        100: Color(0xFFFFFFF0),
        200: Color(0xFFFEFCBF),
        300: Color(0xFFFAF089),
        400: Color(0xFFF6E05E),
        500: Color(0xFFECC94B),
        600: Color(0xFFD69E2E),
        700: Color(0xFFB7791F),
        800: Color(0xFF975A16),
        900: Color(0xFF744210),
      });

  MaterialColor get colorsGreen => const MaterialColor(0xFF48BB78, {
        100: Color(0xFFF0FFF4),
        200: Color(0xFFC6F6D5),
        300: Color(0xFF9AE6B4),
        400: Color(0xFF68D391),
        500: Color(0xFF48BB78),
        600: Color(0xFF38A169),
        700: Color(0xFF2F855A),
        800: Color(0xFF276749),
        900: Color(0xFF22543D),
      });

  MaterialColor get colorsTeal => const MaterialColor(0xFF38B2AC, {
        100: Color(0xFFE6FFFA),
        200: Color(0xFFB2F5EA),
        300: Color(0xFF81E6D9),
        400: Color(0xFF4FD1C5),
        500: Color(0xFF38B2AC),
        600: Color(0xFF319795),
        700: Color(0xFF2C7A7B),
        800: Color(0xFF285E61),
        900: Color(0xFF234E52),
      });

  MaterialColor get colorsBlue => const MaterialColor(0xFF4299E1, {
        100: Color(0xFFEBF8FF),
        200: Color(0xFFBEE3F8),
        300: Color(0xFF90CDF4),
        400: Color(0xFF63B3ED),
        500: Color(0xFF4299E1),
        600: Color(0xFF3182CE),
        700: Color(0xFF2B6CB0),
        800: Color(0xFF2C5282),
        900: Color(0xFF2A4365),
      });

  MaterialColor get colorsIndigo => const MaterialColor(0xFF667EEA, {
        100: Color(0xFFEBF4FF),
        200: Color(0xFFC3DAFE),
        300: Color(0xFFA3BFFA),
        400: Color(0xFF7F9CF5),
        500: Color(0xFF667EEA),
        600: Color(0xFF5A67D8),
        700: Color(0xFF4C51BF),
        800: Color(0xFF434190),
        900: Color(0xFF3C366B),
      });

  MaterialColor get colorsPurple => const MaterialColor(0xFF9F7AEA, {
        100: Color(0xFFFAF5FF),
        200: Color(0xFFE9D8FD),
        300: Color(0xFFD6BCFA),
        400: Color(0xFFB794F4),
        500: Color(0xFF9F7AEA),
        600: Color(0xFF805AD5),
        700: Color(0xFF6B46C1),
        800: Color(0xFF553C9A),
        900: Color(0xFF44337A),
      });

  MaterialColor get colorsPink => const MaterialColor(0xFFED64A6, {
        100: Color(0xFFFFF5F7),
        200: Color(0xFFFED7E2),
        300: Color(0xFFFBB6CE),
        400: Color(0xFFF687B3),
        500: Color(0xFFED64A6),
        600: Color(0xFFD53F8C),
        700: Color(0xFFB83280),
        800: Color(0xFF97266D),
        900: Color(0xFF702459),
      });
}
