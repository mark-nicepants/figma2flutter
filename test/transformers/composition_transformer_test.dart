import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/composition_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
  "brand": {
    "500": {
      "type": "color",
      "value": "#123456"
    }
  },
	"dimensionDefault": {
		"value": "16px",
		"type": "dimension"
	},
	"spacingDefault": {
		"value": "8",
		"type": "spacing"
	},
  "regular": {
    "value": {
      "fontFamily": "Mali",
      "fontWeight": "700",
      "fontSize": "14"
    },
    "type": "typography"
  },
	"purple": {
		"value": "#ffb000",
		"type": "color"
	},
  "symmetric": {
    "value": "5px",
    "type": "borderWidth"
  },
  "borderDefault": {
    "value": {
      "color": "{brand.500}",
      "width": "{symmetric}",
      "style": "solid"
    },
    "type": "border"
  },
  "borderSmall": {
    "value": {
      "color": "{brand.500}",
      "width": "2px",
      "style": "solid"
    },
    "type": "border"
  },
  "defaultShadow": {
    "value": {
      "x": "0",
      "y": "8",
      "blur": "16",
      "spread": "0",
      "color": "rgba(0,0,0,0.55)",
      "type": "dropShadow"
    },
    "type": "boxShadow"
  },
	"test-card": {
		"value": {
			"verticalPadding": "{dimensionDefault}",
			"horizontalPadding": "{dimensionDefault}",
			"fill": "{purple}",
			"itemSpacing": "{spacingDefault}",
      "borderTop": "{borderSmall}",
      "borderBottom": "{borderSmall}",
      "boxShadow": "{defaultShadow}",
      "typography": "{regular}"
		},
		"type": "composition"
	}
}
''';

void main() {
  test('Transform type composition', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens.length, equals(10));
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
  border: const Border(
    top: BorderSide(color: const Color(0xFF123456), width: 2.0, style: BorderStyle.solid),
    bottom: BorderSide(color: const Color(0xFF123456), width: 2.0, style: BorderStyle.solid),
  ),
  boxShadow: const [
  BoxShadow(
    offset: Offset(0.0, 8.0),
    blurRadius: 16.0,
    spreadRadius: 0.0,
    color: Color(0x8C000000),
  ),
],
  textStyle: const TextStyle(
  fontFamily: 'Mali',
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
),
);''';

    expect(transformer.lines.first, equals(expected));
  });
}
