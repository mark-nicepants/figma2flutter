/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
/// Figma2Flutter
/// *****************************************************

library tokens;

import 'package:flutter/material.dart';

part 'tokens_extra.g.dart';

abstract class ITokens {
  ColorTokens get color;
  SpacingTokens get spacing;
  TextStyleTokens get textStyle;
  RadiiTokens get radii;
  CompositionTokens get composition;
  ShadowTokens get shadow;
}

abstract class ColorTokens {
  Color get colorsBlack;
  Color get colorsWhite;
  Color get colorsGray100;
  Color get colorsGray200;
  Color get colorsGray300;
  Color get colorsGray400;
  Color get colorsGray500;
  Color get colorsGray600;
  Color get colorsGray700;
  Color get colorsGray800;
  Color get colorsGray900;
  Color get colorsRed100;
  Color get colorsRed200;
  Color get colorsRed300;
  Color get colorsRed400;
  Color get colorsRed500;
  Color get colorsRed600;
  Color get colorsRed700;
  Color get colorsRed800;
  Color get colorsRed900;
  Color get colorsOrange100;
  Color get colorsOrange200;
  Color get colorsOrange300;
  Color get colorsOrange400;
  Color get colorsOrange500;
  Color get colorsOrange600;
  Color get colorsOrange700;
  Color get colorsOrange800;
  Color get colorsOrange900;
  Color get colorsYellow100;
  Color get colorsYellow200;
  Color get colorsYellow300;
  Color get colorsYellow400;
  Color get colorsYellow500;
  Color get colorsYellow600;
  Color get colorsYellow700;
  Color get colorsYellow800;
  Color get colorsYellow900;
  Color get colorsGreen100;
  Color get colorsGreen200;
  Color get colorsGreen300;
  Color get colorsGreen400;
  Color get colorsGreen500;
  Color get colorsGreen600;
  Color get colorsGreen700;
  Color get colorsGreen800;
  Color get colorsGreen900;
  Color get colorsTeal100;
  Color get colorsTeal200;
  Color get colorsTeal300;
  Color get colorsTeal400;
  Color get colorsTeal500;
  Color get colorsTeal600;
  Color get colorsTeal700;
  Color get colorsTeal800;
  Color get colorsTeal900;
  Color get colorsBlue100;
  Color get colorsBlue200;
  Color get colorsBlue300;
  Color get colorsBlue400;
  Color get colorsBlue500;
  Color get colorsBlue600;
  Color get colorsBlue700;
  Color get colorsBlue800;
  Color get colorsBlue900;
  Color get colorsIndigo100;
  Color get colorsIndigo200;
  Color get colorsIndigo300;
  Color get colorsIndigo400;
  Color get colorsIndigo500;
  Color get colorsIndigo600;
  Color get colorsIndigo700;
  Color get colorsIndigo800;
  Color get colorsIndigo900;
  Color get colorsPurple100;
  Color get colorsPurple200;
  Color get colorsPurple300;
  Color get colorsPurple400;
  Color get colorsPurple500;
  Color get colorsPurple600;
  Color get colorsPurple700;
  Color get colorsPurple800;
  Color get colorsPurple900;
  Color get colorsPink100;
  Color get colorsPink200;
  Color get colorsPink300;
  Color get colorsPink400;
  Color get colorsPink500;
  Color get colorsPink600;
  Color get colorsPink700;
  Color get colorsPink800;
  Color get colorsPink900;
  Color get fgDefault;
  Color get fgMuted;
  Color get fgSubtle;
  Color get bgDefault;
  Color get bgMuted;
  Color get bgSubtle;
  Color get accentDefault;
  Color get accentOnAccent;
  Color get accentBg;
  Color get shadowsDefault;
  Color get buttonPrimaryBackground;
  Color get buttonPrimaryText;
  Color get cardBackground;
}

abstract class SpacingTokens {
  EdgeInsets get spacingXs;
  EdgeInsets get spacingSm;
  EdgeInsets get spacingMd;
  EdgeInsets get spacingLg;
  EdgeInsets get spacingXl;
  EdgeInsets get spacingMultiValue;
}

abstract class TextStyleTokens {
  TextStyle get typographyH1Bold;
  TextStyle get typographyH1Regular;
  TextStyle get typographyH5Bold;
  TextStyle get typographyH5Regular;
  TextStyle get typographyBody;
}

abstract class RadiiTokens {
  BorderRadius get borderRadiusSm;
  BorderRadius get borderRadiusLg;
  BorderRadius get borderRadiusXl;
  BorderRadius get borderRadiusMultiValue;
  BorderRadius get buttonBorderRadius;
  BorderRadius get cardBorderRadius;
}

abstract class CompositionTokens {
  CompositionToken get cardComp;
  CompositionToken get buttonComp;
}

abstract class ShadowTokens {
  List<BoxShadow> get boxShadowDefault;
}

class LightTokens extends ITokens {
  @override
  ColorTokens get color => LightColorTokens();
  @override
  SpacingTokens get spacing => LightSpacingTokens();
  @override
  TextStyleTokens get textStyle => LightTextStyleTokens();
  @override
  RadiiTokens get radii => LightRadiiTokens();
  @override
  CompositionTokens get composition => LightCompositionTokens();
  @override
  ShadowTokens get shadow => LightShadowTokens();
}

class LightColorTokens extends ColorTokens {
  @override
  Color get colorsBlack => const Color(0xFF000000);
  @override
  Color get colorsWhite => const Color(0xFFFFFFFF);
  @override
  Color get colorsGray100 => const Color(0xFFF7FAFC);
  @override
  Color get colorsGray200 => const Color(0xFFEDF2F7);
  @override
  Color get colorsGray300 => const Color(0xFFE2E8F0);
  @override
  Color get colorsGray400 => const Color(0xFFCBD5E0);
  @override
  Color get colorsGray500 => const Color(0xFFA0AEC0);
  @override
  Color get colorsGray600 => const Color(0xFF718096);
  @override
  Color get colorsGray700 => const Color(0xFF4A5568);
  @override
  Color get colorsGray800 => const Color(0xFF2D3748);
  @override
  Color get colorsGray900 => const Color(0xFF1A202C);
  @override
  Color get colorsRed100 => const Color(0xFFFFF5F5);
  @override
  Color get colorsRed200 => const Color(0xFFFED7D7);
  @override
  Color get colorsRed300 => const Color(0xFFFEB2B2);
  @override
  Color get colorsRed400 => const Color(0xFFFC8181);
  @override
  Color get colorsRed500 => const Color(0xFFF56565);
  @override
  Color get colorsRed600 => const Color(0xFFE53E3E);
  @override
  Color get colorsRed700 => const Color(0xFFC53030);
  @override
  Color get colorsRed800 => const Color(0xFF9B2C2C);
  @override
  Color get colorsRed900 => const Color(0xFF742A2A);
  @override
  Color get colorsOrange100 => const Color(0xFFFFFAF0);
  @override
  Color get colorsOrange200 => const Color(0xFFFEEBC8);
  @override
  Color get colorsOrange300 => const Color(0xFFFBD38D);
  @override
  Color get colorsOrange400 => const Color(0xFFF6AD55);
  @override
  Color get colorsOrange500 => const Color(0xFFED8936);
  @override
  Color get colorsOrange600 => const Color(0xFFDD6B20);
  @override
  Color get colorsOrange700 => const Color(0xFFC05621);
  @override
  Color get colorsOrange800 => const Color(0xFF9C4221);
  @override
  Color get colorsOrange900 => const Color(0xFF7B341E);
  @override
  Color get colorsYellow100 => const Color(0xFFFFFFF0);
  @override
  Color get colorsYellow200 => const Color(0xFFFEFCBF);
  @override
  Color get colorsYellow300 => const Color(0xFFFAF089);
  @override
  Color get colorsYellow400 => const Color(0xFFF6E05E);
  @override
  Color get colorsYellow500 => const Color(0xFFECC94B);
  @override
  Color get colorsYellow600 => const Color(0xFFD69E2E);
  @override
  Color get colorsYellow700 => const Color(0xFFB7791F);
  @override
  Color get colorsYellow800 => const Color(0xFF975A16);
  @override
  Color get colorsYellow900 => const Color(0xFF744210);
  @override
  Color get colorsGreen100 => const Color(0xFFF0FFF4);
  @override
  Color get colorsGreen200 => const Color(0xFFC6F6D5);
  @override
  Color get colorsGreen300 => const Color(0xFF9AE6B4);
  @override
  Color get colorsGreen400 => const Color(0xFF68D391);
  @override
  Color get colorsGreen500 => const Color(0xFF48BB78);
  @override
  Color get colorsGreen600 => const Color(0xFF38A169);
  @override
  Color get colorsGreen700 => const Color(0xFF2F855A);
  @override
  Color get colorsGreen800 => const Color(0xFF276749);
  @override
  Color get colorsGreen900 => const Color(0xFF22543D);
  @override
  Color get colorsTeal100 => const Color(0xFFE6FFFA);
  @override
  Color get colorsTeal200 => const Color(0xFFB2F5EA);
  @override
  Color get colorsTeal300 => const Color(0xFF81E6D9);
  @override
  Color get colorsTeal400 => const Color(0xFF4FD1C5);
  @override
  Color get colorsTeal500 => const Color(0xFF38B2AC);
  @override
  Color get colorsTeal600 => const Color(0xFF319795);
  @override
  Color get colorsTeal700 => const Color(0xFF2C7A7B);
  @override
  Color get colorsTeal800 => const Color(0xFF285E61);
  @override
  Color get colorsTeal900 => const Color(0xFF234E52);
  @override
  Color get colorsBlue100 => const Color(0xFFEBF8FF);
  @override
  Color get colorsBlue200 => const Color(0xFFBEE3F8);
  @override
  Color get colorsBlue300 => const Color(0xFF90CDF4);
  @override
  Color get colorsBlue400 => const Color(0xFF63B3ED);
  @override
  Color get colorsBlue500 => const Color(0xFF4299E1);
  @override
  Color get colorsBlue600 => const Color(0xFF3182CE);
  @override
  Color get colorsBlue700 => const Color(0xFF2B6CB0);
  @override
  Color get colorsBlue800 => const Color(0xFF2C5282);
  @override
  Color get colorsBlue900 => const Color(0xFF2A4365);
  @override
  Color get colorsIndigo100 => const Color(0xFFEBF4FF);
  @override
  Color get colorsIndigo200 => const Color(0xFFC3DAFE);
  @override
  Color get colorsIndigo300 => const Color(0xFFA3BFFA);
  @override
  Color get colorsIndigo400 => const Color(0xFF7F9CF5);
  @override
  Color get colorsIndigo500 => const Color(0xFF667EEA);
  @override
  Color get colorsIndigo600 => const Color(0xFF5A67D8);
  @override
  Color get colorsIndigo700 => const Color(0xFF4C51BF);
  @override
  Color get colorsIndigo800 => const Color(0xFF434190);
  @override
  Color get colorsIndigo900 => const Color(0xFF3C366B);
  @override
  Color get colorsPurple100 => const Color(0xFFFAF5FF);
  @override
  Color get colorsPurple200 => const Color(0xFFE9D8FD);
  @override
  Color get colorsPurple300 => const Color(0xFFD6BCFA);
  @override
  Color get colorsPurple400 => const Color(0xFFB794F4);
  @override
  Color get colorsPurple500 => const Color(0xFF9F7AEA);
  @override
  Color get colorsPurple600 => const Color(0xFF805AD5);
  @override
  Color get colorsPurple700 => const Color(0xFF6B46C1);
  @override
  Color get colorsPurple800 => const Color(0xFF553C9A);
  @override
  Color get colorsPurple900 => const Color(0xFF44337A);
  @override
  Color get colorsPink100 => const Color(0xFFFFF5F7);
  @override
  Color get colorsPink200 => const Color(0xFFFED7E2);
  @override
  Color get colorsPink300 => const Color(0xFFFBB6CE);
  @override
  Color get colorsPink400 => const Color(0xFFF687B3);
  @override
  Color get colorsPink500 => const Color(0xFFED64A6);
  @override
  Color get colorsPink600 => const Color(0xFFD53F8C);
  @override
  Color get colorsPink700 => const Color(0xFFB83280);
  @override
  Color get colorsPink800 => const Color(0xFF97266D);
  @override
  Color get colorsPink900 => const Color(0xFF702459);
  @override
  Color get fgDefault => const Color(0xFF000000);
  @override
  Color get fgMuted => const Color(0xFF4A5568);
  @override
  Color get fgSubtle => const Color(0xFFA0AEC0);
  @override
  Color get bgDefault => const Color(0xFFFFFFFF);
  @override
  Color get bgMuted => const Color(0xFFF7FAFC);
  @override
  Color get bgSubtle => const Color(0xFFEDF2F7);
  @override
  Color get accentDefault => const Color(0xFF7F9CF5);
  @override
  Color get accentOnAccent => const Color(0xFFFFFFFF);
  @override
  Color get accentBg => const Color(0xFFC3DAFE);
  @override
  Color get shadowsDefault => const Color(0xFF1A202C);
  @override
  Color get buttonPrimaryBackground => const Color(0xFF7F9CF5);
  @override
  Color get buttonPrimaryText => const Color(0xFFFFFFFF);
  @override
  Color get cardBackground => const Color(0xFFFFFFFF);
}


class LightSpacingTokens extends SpacingTokens {
  @override
  EdgeInsets get spacingXs => const EdgeInsets.all(4.0);
  @override
  EdgeInsets get spacingSm => const EdgeInsets.all(8.0);
  @override
  EdgeInsets get spacingMd => const EdgeInsets.all(16.0);
  @override
  EdgeInsets get spacingLg => const EdgeInsets.all(32.0);
  @override
  EdgeInsets get spacingXl => const EdgeInsets.all(64.0);
  @override
  EdgeInsets get spacingMultiValue => const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0);
}


class LightTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get typographyH1Bold => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.828125,
  fontWeight: FontWeight.w700,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH1Regular => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.828125,
  fontWeight: FontWeight.w400,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH5Bold => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH5Regular => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyBody => const TextStyle(
  fontFamily: 'Roboto',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.1,
);
}


class LightRadiiTokens extends RadiiTokens {
  @override
  BorderRadius get borderRadiusSm => BorderRadius.circular(4.0);
  @override
  BorderRadius get borderRadiusLg => BorderRadius.circular(8.0);
  @override
  BorderRadius get borderRadiusXl => BorderRadius.circular(16.0);
  @override
  BorderRadius get borderRadiusMultiValue => const BorderRadius.only(topLeft: Radius.circular(4.0),topRight: Radius.circular(8.0),bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(8.0));
  @override
  BorderRadius get buttonBorderRadius => BorderRadius.circular(8.0);
  @override
  BorderRadius get cardBorderRadius => BorderRadius.circular(8.0);
}


class LightCompositionTokens extends CompositionTokens {
  @override
  CompositionToken get cardComp => CompositionToken(
  padding: const EdgeInsets.only(
    top: 32.0,
    right: 32.0,
    bottom: 32.0,
    left: 32.0,
  ),
  fill: const Color(0xFFFFFFFF),
  itemSpacing: 16.0,
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: const [
  BoxShadow(
    offset: Offset(0.0, 5.0),
    blurRadius: 5.0,
    spreadRadius: 3.0,
    color: Color(0x261A202C),
  ),
],
);
  @override
  CompositionToken get buttonComp => CompositionToken(
  padding: const EdgeInsets.only(
    top: 8.0,
    right: 16.0,
    bottom: 8.0,
    left: 16.0,
  ),
  fill: const Color(0xFF7F9CF5),
  borderRadius: BorderRadius.circular(8.0),
);
}


class LightShadowTokens extends ShadowTokens {
  @override
  List<BoxShadow> get boxShadowDefault => const [
  BoxShadow(
    offset: Offset(0.0, 5.0),
    blurRadius: 5.0,
    spreadRadius: 3.0,
    color: Color(0x261A202C),
  ),
];
}


class DarkTokens extends ITokens {
  @override
  ColorTokens get color => DarkColorTokens();
  @override
  SpacingTokens get spacing => DarkSpacingTokens();
  @override
  TextStyleTokens get textStyle => DarkTextStyleTokens();
  @override
  RadiiTokens get radii => DarkRadiiTokens();
  @override
  CompositionTokens get composition => DarkCompositionTokens();
  @override
  ShadowTokens get shadow => DarkShadowTokens();
}

class DarkColorTokens extends ColorTokens {
  @override
  Color get colorsBlack => const Color(0xFF000000);
  @override
  Color get colorsWhite => const Color(0xFFFFFFFF);
  @override
  Color get colorsGray100 => const Color(0xFFF7FAFC);
  @override
  Color get colorsGray200 => const Color(0xFFEDF2F7);
  @override
  Color get colorsGray300 => const Color(0xFFE2E8F0);
  @override
  Color get colorsGray400 => const Color(0xFFCBD5E0);
  @override
  Color get colorsGray500 => const Color(0xFFA0AEC0);
  @override
  Color get colorsGray600 => const Color(0xFF718096);
  @override
  Color get colorsGray700 => const Color(0xFF4A5568);
  @override
  Color get colorsGray800 => const Color(0xFF2D3748);
  @override
  Color get colorsGray900 => const Color(0xFF1A202C);
  @override
  Color get colorsRed100 => const Color(0xFFFFF5F5);
  @override
  Color get colorsRed200 => const Color(0xFFFED7D7);
  @override
  Color get colorsRed300 => const Color(0xFFFEB2B2);
  @override
  Color get colorsRed400 => const Color(0xFFFC8181);
  @override
  Color get colorsRed500 => const Color(0xFFF56565);
  @override
  Color get colorsRed600 => const Color(0xFFE53E3E);
  @override
  Color get colorsRed700 => const Color(0xFFC53030);
  @override
  Color get colorsRed800 => const Color(0xFF9B2C2C);
  @override
  Color get colorsRed900 => const Color(0xFF742A2A);
  @override
  Color get colorsOrange100 => const Color(0xFFFFFAF0);
  @override
  Color get colorsOrange200 => const Color(0xFFFEEBC8);
  @override
  Color get colorsOrange300 => const Color(0xFFFBD38D);
  @override
  Color get colorsOrange400 => const Color(0xFFF6AD55);
  @override
  Color get colorsOrange500 => const Color(0xFFED8936);
  @override
  Color get colorsOrange600 => const Color(0xFFDD6B20);
  @override
  Color get colorsOrange700 => const Color(0xFFC05621);
  @override
  Color get colorsOrange800 => const Color(0xFF9C4221);
  @override
  Color get colorsOrange900 => const Color(0xFF7B341E);
  @override
  Color get colorsYellow100 => const Color(0xFFFFFFF0);
  @override
  Color get colorsYellow200 => const Color(0xFFFEFCBF);
  @override
  Color get colorsYellow300 => const Color(0xFFFAF089);
  @override
  Color get colorsYellow400 => const Color(0xFFF6E05E);
  @override
  Color get colorsYellow500 => const Color(0xFFECC94B);
  @override
  Color get colorsYellow600 => const Color(0xFFD69E2E);
  @override
  Color get colorsYellow700 => const Color(0xFFB7791F);
  @override
  Color get colorsYellow800 => const Color(0xFF975A16);
  @override
  Color get colorsYellow900 => const Color(0xFF744210);
  @override
  Color get colorsGreen100 => const Color(0xFFF0FFF4);
  @override
  Color get colorsGreen200 => const Color(0xFFC6F6D5);
  @override
  Color get colorsGreen300 => const Color(0xFF9AE6B4);
  @override
  Color get colorsGreen400 => const Color(0xFF68D391);
  @override
  Color get colorsGreen500 => const Color(0xFF48BB78);
  @override
  Color get colorsGreen600 => const Color(0xFF38A169);
  @override
  Color get colorsGreen700 => const Color(0xFF2F855A);
  @override
  Color get colorsGreen800 => const Color(0xFF276749);
  @override
  Color get colorsGreen900 => const Color(0xFF22543D);
  @override
  Color get colorsTeal100 => const Color(0xFFE6FFFA);
  @override
  Color get colorsTeal200 => const Color(0xFFB2F5EA);
  @override
  Color get colorsTeal300 => const Color(0xFF81E6D9);
  @override
  Color get colorsTeal400 => const Color(0xFF4FD1C5);
  @override
  Color get colorsTeal500 => const Color(0xFF38B2AC);
  @override
  Color get colorsTeal600 => const Color(0xFF319795);
  @override
  Color get colorsTeal700 => const Color(0xFF2C7A7B);
  @override
  Color get colorsTeal800 => const Color(0xFF285E61);
  @override
  Color get colorsTeal900 => const Color(0xFF234E52);
  @override
  Color get colorsBlue100 => const Color(0xFFEBF8FF);
  @override
  Color get colorsBlue200 => const Color(0xFFBEE3F8);
  @override
  Color get colorsBlue300 => const Color(0xFF90CDF4);
  @override
  Color get colorsBlue400 => const Color(0xFF63B3ED);
  @override
  Color get colorsBlue500 => const Color(0xFF4299E1);
  @override
  Color get colorsBlue600 => const Color(0xFF3182CE);
  @override
  Color get colorsBlue700 => const Color(0xFF2B6CB0);
  @override
  Color get colorsBlue800 => const Color(0xFF2C5282);
  @override
  Color get colorsBlue900 => const Color(0xFF2A4365);
  @override
  Color get colorsIndigo100 => const Color(0xFFEBF4FF);
  @override
  Color get colorsIndigo200 => const Color(0xFFC3DAFE);
  @override
  Color get colorsIndigo300 => const Color(0xFFA3BFFA);
  @override
  Color get colorsIndigo400 => const Color(0xFF7F9CF5);
  @override
  Color get colorsIndigo500 => const Color(0xFF667EEA);
  @override
  Color get colorsIndigo600 => const Color(0xFF5A67D8);
  @override
  Color get colorsIndigo700 => const Color(0xFF4C51BF);
  @override
  Color get colorsIndigo800 => const Color(0xFF434190);
  @override
  Color get colorsIndigo900 => const Color(0xFF3C366B);
  @override
  Color get colorsPurple100 => const Color(0xFFFAF5FF);
  @override
  Color get colorsPurple200 => const Color(0xFFE9D8FD);
  @override
  Color get colorsPurple300 => const Color(0xFFD6BCFA);
  @override
  Color get colorsPurple400 => const Color(0xFFB794F4);
  @override
  Color get colorsPurple500 => const Color(0xFF9F7AEA);
  @override
  Color get colorsPurple600 => const Color(0xFF805AD5);
  @override
  Color get colorsPurple700 => const Color(0xFF6B46C1);
  @override
  Color get colorsPurple800 => const Color(0xFF553C9A);
  @override
  Color get colorsPurple900 => const Color(0xFF44337A);
  @override
  Color get colorsPink100 => const Color(0xFFFFF5F7);
  @override
  Color get colorsPink200 => const Color(0xFFFED7E2);
  @override
  Color get colorsPink300 => const Color(0xFFFBB6CE);
  @override
  Color get colorsPink400 => const Color(0xFFF687B3);
  @override
  Color get colorsPink500 => const Color(0xFFED64A6);
  @override
  Color get colorsPink600 => const Color(0xFFD53F8C);
  @override
  Color get colorsPink700 => const Color(0xFFB83280);
  @override
  Color get colorsPink800 => const Color(0xFF97266D);
  @override
  Color get colorsPink900 => const Color(0xFF702459);
  @override
  Color get fgDefault => const Color(0xFFFFFFFF);
  @override
  Color get fgMuted => const Color(0xFFE2E8F0);
  @override
  Color get fgSubtle => const Color(0xFFA0AEC0);
  @override
  Color get bgDefault => const Color(0xFF1A202C);
  @override
  Color get bgMuted => const Color(0xFF4A5568);
  @override
  Color get bgSubtle => const Color(0xFF718096);
  @override
  Color get accentDefault => const Color(0xFF5A67D8);
  @override
  Color get accentOnAccent => const Color(0xFFFFFFFF);
  @override
  Color get accentBg => const Color(0xFF434190);
  @override
  Color get shadowsDefault => const Color(0x4D000000);
  @override
  Color get buttonPrimaryBackground => const Color(0xFF5A67D8);
  @override
  Color get buttonPrimaryText => const Color(0xFFFFFFFF);
  @override
  Color get cardBackground => const Color(0xFF1A202C);
}


class DarkSpacingTokens extends SpacingTokens {
  @override
  EdgeInsets get spacingXs => const EdgeInsets.all(4.0);
  @override
  EdgeInsets get spacingSm => const EdgeInsets.all(8.0);
  @override
  EdgeInsets get spacingMd => const EdgeInsets.all(16.0);
  @override
  EdgeInsets get spacingLg => const EdgeInsets.all(32.0);
  @override
  EdgeInsets get spacingXl => const EdgeInsets.all(64.0);
  @override
  EdgeInsets get spacingMultiValue => const EdgeInsets.symmetric(horizontal: 64.0, vertical: 8.0);
}


class DarkTextStyleTokens extends TextStyleTokens {
  @override
  TextStyle get typographyH1Bold => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.828125,
  fontWeight: FontWeight.w700,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH1Regular => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 48.828125,
  fontWeight: FontWeight.w400,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH5Bold => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w700,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyH5Regular => const TextStyle(
  fontFamily: 'Inter',
  fontSize: 20.0,
  fontWeight: FontWeight.w400,
  height: 1.1,
  letterSpacing: -0.8,
);
  @override
  TextStyle get typographyBody => const TextStyle(
  fontFamily: 'Roboto',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.1,
);
}


class DarkRadiiTokens extends RadiiTokens {
  @override
  BorderRadius get borderRadiusSm => BorderRadius.circular(4.0);
  @override
  BorderRadius get borderRadiusLg => BorderRadius.circular(8.0);
  @override
  BorderRadius get borderRadiusXl => BorderRadius.circular(16.0);
  @override
  BorderRadius get borderRadiusMultiValue => const BorderRadius.only(topLeft: Radius.circular(4.0),topRight: Radius.circular(8.0),bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(8.0));
  @override
  BorderRadius get buttonBorderRadius => BorderRadius.circular(8.0);
  @override
  BorderRadius get cardBorderRadius => BorderRadius.circular(8.0);
}


class DarkCompositionTokens extends CompositionTokens {
  @override
  CompositionToken get cardComp => CompositionToken(
  padding: const EdgeInsets.only(
    top: 32.0,
    right: 32.0,
    bottom: 32.0,
    left: 32.0,
  ),
  fill: const Color(0xFF1A202C),
  itemSpacing: 16.0,
  borderRadius: BorderRadius.circular(8.0),
  boxShadow: const [
  BoxShadow(
    offset: Offset(0.0, 5.0),
    blurRadius: 5.0,
    spreadRadius: 3.0,
    color: Color(0x26000000),
  ),
],
);
  @override
  CompositionToken get buttonComp => CompositionToken(
  padding: const EdgeInsets.only(
    top: 8.0,
    right: 16.0,
    bottom: 8.0,
    left: 16.0,
  ),
  fill: const Color(0xFF5A67D8),
  borderRadius: BorderRadius.circular(8.0),
);
}


class DarkShadowTokens extends ShadowTokens {
  @override
  List<BoxShadow> get boxShadowDefault => const [
  BoxShadow(
    offset: Offset(0.0, 5.0),
    blurRadius: 5.0,
    spreadRadius: 3.0,
    color: Color(0x26000000),
  ),
];
}
