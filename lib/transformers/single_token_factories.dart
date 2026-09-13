import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/transformers/border_radius_transformer.dart';
import 'package:figma2flutter/transformers/border_transformer.dart';
import 'package:figma2flutter/transformers/box_shadow_transformer.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:figma2flutter/transformers/linear_gradient_transformer.dart';
import 'package:figma2flutter/transformers/size_transformer.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';

// All transformers that process single tokens should be added here
// These transformers will be applied to all tokens in the order they are listed
final singleTokenFactories = <TransformerFactory>[
  (_) => ColorTransformer(),
  (_) => SpacingTransformer(),
  (_) => TypographyTransformer(),
  (_) => BorderRadiusTransformer(),
  (_) => CompositionTransformer(),
  (_) => BoxShadowTransformer(),
  (_) => BorderTransformer(),
  (_) => SizeTransformer(),
  (_) => LinearGradientTransformer(),
];
