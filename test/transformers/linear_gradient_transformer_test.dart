import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/linear_gradient_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
  "purple": {
    "value": "#ffb000",
    "type": "color"
  },
  "black": {
    "value": "#000000",
    "type": "color"
  },
  "white": {
    "value": "#ffffff",
    "type": "color"
  },
  "gradient": {
    "value": "linear-gradient(45deg, #ffffff 0%, #000000 100%)",
    "type": "color"
  },
  "gradientMoreStops": {
    "value": "linear-gradient(180deg, {white} 0%, {purple} 50%, {black} 100%)",
    "type": "color"
  },
  "rgbaInGradient": {
    "value": "linear-gradient(45deg, rgba({white}, 0.5) 0%, rgba({purple}, 1) 100%)",
    "type": "color"
  }
}''';

final output = '''
LinearGradient get gradient => const LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFF000000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
);
LinearGradient get gradientMoreStops => const LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFFFFB000), Color(0xFF000000),],
  stops: [0.0, 0.5, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(3.14),
);
LinearGradient get rgbaInGradient => const LinearGradient(
  colors: [Color(0x80FFFFFF), Color(0xFFFFB000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
);''';

void main() {
  test('Test linear gradient type transformer', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens.length, equals(6));

    final transformer = LinearGradientTransformer();
    parser.resolvedTokens.forEach(transformer.process);

    expect(transformer.lines.join('\n'), equals(output));
  });
}
