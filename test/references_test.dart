import 'dart:convert';

import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

/// https://tr.designtokens.org/format/#alias-reference
/// https://docs.tokens.studio/tokens/aliases
///
/// 3.8 Alias (reference)
///
/// To use an alias in your tokens, we write them in the following notation: {spacing.sm},
/// you can also write them in the older $ notation, like this: $spacing.sm

void main() {
  test('references with both annotations and within groups ', () {
    final input = '''
{
  "token": {
    "value": "#111111",
    "type": "color"
  },
  "group": {
    "type": "dimension",
    "token": {
      "value": "2rem"
    }
  },
  "token1": {
    "value": "\$token"
  },
  "token2": {
    "value": "{token}"
  },
  "token3": {
    "value": "\$group.token"
  },
  "token4": {
    "value": "{group.token}"
  }
}''';

    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.themes.first.tokens.length, equals(6));
    expect(parser.themes.first.tokens['token']?.type, equals('color'));
    expect(
      parser.themes.first.tokens['group.token']?.type,
      equals('dimension'),
    );

    expect(parser.resolve('token1')?.type, equals('color'));
    expect(parser.resolve('token2')?.type, equals('color'));
    expect(parser.resolve('token3')?.type, equals('dimension'));
    expect(parser.resolve('token4')?.type, equals('dimension'));
  });

  test('child references are properly resolved', () {
    final childReferences = '''
{
	"fontSizes": {
		"small": {
			"value": "12px",
			"type": "fontSize"
		}
	},
	"fontWeights": {
		"heading": {
			"bold": {
				"value": "100",
				"type": "fontWeight"
			}
		}
	},
	"fontFamilies": {
		"heading": {
			"value": "Roboto",
			"type": "fontFamily"
		}
	},
	"bold": {
		"value": {
			"fontFamily": "{fontFamilies.heading}",
			"fontWeight": "{fontWeights.heading.bold}",
			"fontSize": "{fontSizes.small}"
		},
		"type": "typography"
	},
	"boldReference": {
		"value": "{bold}"
	}
}
''';

    final parsed = json.decode(childReferences) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.themes.first.tokens.length, equals(5));

    expect(parser.resolve('bold')!.value['fontFamily'], equals('Roboto'));
    expect(parser.resolve('bold')!.value['fontWeight'], equals('100'));
    expect(parser.resolve('bold')!.value['fontSize'], equals('12px'));

    expect(
      parser.resolve('boldReference')!.value['fontFamily'],
      equals('Roboto'),
    );
    expect(parser.resolve('boldReference')!.value['fontWeight'], equals('100'));
    expect(parser.resolve('boldReference')!.value['fontSize'], equals('12px'));
  });

  test('Test recursive deep references', () {
    final recursiveTest = '''
{
  "brand": {
    "500": {
      "type": "color",
      "value": "#123456"
    }
  },
  "borderSmall": {
    "value": {
      "color": "{brand.500}",
      "width": "2px",
      "style": "solid"
    },
    "type": "border"
  },
	"test-card": {
		"value": {
      "borderRight": "{borderSmall}"
		},
		"type": "composition"
	}
}
''';

    final parsed = json.decode(recursiveTest) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final color = parser.resolve('test-card')?.value['borderRight']['color'];
    expect(color, isNotNull);
    expect(color, equals('#123456'));
  });

  test('Test color ref in other color with alpha', () {
    final colorRefTest = '''
{
  "brand": {
    "500": {
      "type": "color",
      "value": "#123456"
    }
  },
  "semiTransparent": {
    "value": "rgba({brand.500}, 0.5)",
    "type": "color"
  }
}
''';

    final parsed = json.decode(colorRefTest) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final color = parser.resolve('semiTransparent')?.value;
    expect(color, isNotNull);
    expect(color, equals('rgba(18, 52, 86, 0.5)'));
    expect(ColorValue.maybeParse(color)?.toHex8(), equals('0x80123456'));
  });
}
