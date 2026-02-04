import 'package:figma2flutter/models/dimension_value.dart';
import 'package:figma2flutter/models/multi_dimension_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

/// https://docs.tokens.studio/available-tokens/border-radius-tokens
///
/// Radius tokens give you the possibility to define values for your border
/// radius. You can either create a single value token or define multiple
/// border radii in a token.
class BorderRadiusTransformer extends SingleTokenTransformer {
  static const int percentageMultiplier = 100;
  @override
  bool matcher(Token token) {
    return token.type == 'borderRadius';
  }

  @override
  String get name => 'radii';

  @override
  String transform(Token token) {
    final dimensions = MultiDimensionValue.parse(token.value, true);

    if (dimensions.values.length == 1) {
      final dimension = dimensions.values[0];
      if (dimension.value == 0) {
        return 'BorderRadius.zero';
      }

        return 'BorderRadius.circular(${dimension.isPercentage ? dimension.value * percentageMultiplier : dimension.value})';
    }

    final DimensionValue topLeft;
    final DimensionValue topRight;
    final DimensionValue bottomRight;
    final DimensionValue bottomLeft;

    if (dimensions.values.length == 2) {
      topLeft = dimensions.values[0];
      topRight = dimensions.values[1];
      bottomRight = dimensions.values[0];
      bottomLeft = dimensions.values[1];
    } else if (dimensions.values.length == 3) {
      topLeft = dimensions.values[0];
      topRight = dimensions.values[1];
      bottomRight = dimensions.values[2];
      bottomLeft = dimensions.values[1];
    } else {
      topLeft = dimensions.values[0];
      topRight = dimensions.values[1];
      bottomRight = dimensions.values[2];
      bottomLeft = dimensions.values[3];
    }

    return 'const BorderRadius.only('
        'topLeft: Radius.circular(${topLeft.isPercentage ? topLeft.value * percentageMultiplier : topLeft.value}),'
        'topRight: Radius.circular(${topRight.isPercentage ? topRight.value * percentageMultiplier : topRight.value}),'
        'bottomRight: Radius.circular(${bottomRight.isPercentage ? bottomRight.value * percentageMultiplier : bottomRight.value}),'
        'bottomLeft: Radius.circular(${bottomLeft.isPercentage ? bottomLeft.value * percentageMultiplier : bottomLeft.value})'
        ')';
  }

  @override
  String get type => 'BorderRadius';
}
