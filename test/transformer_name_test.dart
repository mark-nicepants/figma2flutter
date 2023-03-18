import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:figma2flutter/transformers/border_transformer.dart';
import 'package:figma2flutter/transformers/box_shadow_transformer.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:figma2flutter/transformers/linear_gradient_transformer.dart';
import 'package:figma2flutter/transformers/material_color_transformer.dart';
import 'package:figma2flutter/transformers/size_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';
import 'package:test/test.dart';

void main() {
  test('Test transformer names match expectations', () {
    expect(ColorTransformer().name, equals('color'));
    expect(SpacingTransformer().name, equals('spacing'));
    expect(TypographyTransformer().name, equals('textStyle'));
    expect(BorderRadiusTransformer().name, equals('radii'));
    expect(CompositionTransformer().name, equals('composition'));
    expect(BoxShadowTransformer().name, equals('shadow'));
    expect(BorderTransformer().name, equals('border'));
    expect(SizeTransformer().name, equals('size'));
    expect(LinearGradientTransformer().name, equals('gradient'));
    expect(MaterialColorTransformer([]).name, equals('materialColor'));
  });
}
