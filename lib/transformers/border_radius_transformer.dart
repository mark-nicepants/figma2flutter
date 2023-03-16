import 'package:figma2flutter/models/multi_dimension_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';

/// https://docs.tokens.studio/available-tokens/border-radius-tokens
///
/// Radius tokens give you the possibility to define values for your border
/// radius. You can either create a single value token or define multiple
/// border radii in a token.
class BorderRadiusTransformer extends SingleTokenTransformer {
  @override
  bool matcher(Token token) {
    return token.type == 'borderRadius';
  }

  @override
  String get name => 'radii';

  @override
  String transform(dynamic value) {
    final dimensions = MultiDimensionValue.parse(value);

    if (dimensions.values.length == 1) {
      if (dimensions.values[0].value == 0) {
        return 'const BorderRadius.zero';
      }

      return 'BorderRadius.circular(${dimensions.values[0].value})';
    }

    final double topLeft;
    final double topRight;
    final double bottomRight;
    final double bottomLeft;

    if (dimensions.values.length == 2) {
      topLeft = dimensions.values[0].value;
      topRight = dimensions.values[1].value;
      bottomRight = dimensions.values[0].value;
      bottomLeft = dimensions.values[1].value;
    } else if (dimensions.values.length == 3) {
      topLeft = dimensions.values[0].value;
      topRight = dimensions.values[1].value;
      bottomRight = dimensions.values[2].value;
      bottomLeft = dimensions.values[1].value;
    } else {
      topLeft = dimensions.values[0].value;
      topRight = dimensions.values[1].value;
      bottomRight = dimensions.values[2].value;
      bottomLeft = dimensions.values[3].value;
    }

    return 'const BorderRadius.only('
        'topLeft: Radius.circular($topLeft),'
        'topRight: Radius.circular($topRight),'
        'bottomRight: Radius.circular($bottomRight),'
        'bottomLeft: Radius.circular($bottomLeft)'
        ')';
  }

  @override
  String get type => 'BorderRadius';
}
