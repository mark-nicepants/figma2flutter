import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
	"dimensionDefault": {
		"value": "16px",
		"type": "dimension"
	},
	"spacingDefault": {
		"value": "8",
		"type": "spacing"
	},
	"purple": {
		"value": "#ffb000",
		"type": "color"
	},
	"test-card": {
		"value": {
			"verticalPadding": "{dimensionDefault}",
			"horizontalPadding": "{dimensionDefault}",
			"fill": "{purple}",
			"itemSpacing": "{spacingDefault}"
		},
		"type": "composition"
	}
}
''';

void main() {
  test('Transform type composition', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens.length, equals(4));
    expect(parser.tokenMap['dimensionDefault']?.type, equals('dimension'));
    expect(parser.tokenMap['spacingDefault']?.type, equals('spacing'));
    expect(parser.tokenMap['purple']?.type, equals('color'));
    expect(parser.tokenMap['test-card']?.type, equals('composition'));

    final transformer = CompositionTransformer();
    parser.resolvedTokens.forEach(transformer.process);

    final expected = '''
CompositionToken get testCard => CompositionToken(
  padding: const EdgeInsets.only(
    top: 16.0,
    right: 16.0,
    bottom: 16.0,
    left: 16.0,
  ),
  fill: const Color(0xFFFFB000),
  itemSpacing: 8.0,
);''';

    expect(transformer.lines.first, equals(expected));
  });
}
