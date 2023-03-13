import 'package:figma2flutter/models/sizes.dart';
import 'package:figma2flutter/transformers/transformer.dart';

class SpacingTransformer extends Transformer {
  @override
  bool matcher(String type) {
    return type == 'spacing';
  }

  @override
  String get name => 'spacing';

  @override
  String get type => 'EdgeInsets';

  @override
  String transform(dynamic value) {
    final sizes = Sizes.from(value);

    if (sizes.values.length == 1) {
      return 'const EdgeInsets.all(${sizes.values[0]})';
    }
    if (sizes.values.length == 2) {
      return 'const EdgeInsets.symmetric(horizontal: ${sizes.values[1]}, vertical: ${sizes.values[0]})';
    }
    if (sizes.values.length == 3) {
      return 'const EdgeInsets.only(top: ${sizes.values[0]}, left: ${sizes.values[1]}, right: ${sizes.values[1]}, bottom: ${sizes.values[2]})';
    }
    if (sizes.values.length == 4) {
      return 'const EdgeInsets.only(top: ${sizes.values[0]}, right: ${sizes.values[1]}, bottom: ${sizes.values[2]}, left: ${sizes.values[3]})';
    }

    return 'const EdgeInsets.none';
  }
}
