import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/typography_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
	"fontSizes": {
		"small": {
			"value": "12px",
			"type": "fontSize"
		},
    "normal": {
			"value": "16px",
			"type": "fontSize"
		}
	},
	"fontWeights": {
		"heading": {
			"bold": {
				"value": "800",
				"type": "fontWeight"
			},
      "regular": {
				"value": "regular",
				"type": "fontWeight"
			}
		}
	},
	"fontFamilies": {
		"heading": {
			"value": "Roboto",
			"type": "fontFamily"
		},
    "fallback": {
			"value": ["Roboto", "sans-serif"],
			"type": "fontFamily"
		}
	},
	"bold": {
		"value": {
			"fontFamily": "{fontFamilies.heading}",
			"fontWeight": "{fontWeights.heading.bold}",
			"fontSize": "{fontSizes.small}",
      "letterSpacing": "4px"
		},
		"type": "typography"
	},
	"regular": {
		"value": {
			"fontFamily": "{fontFamilies.fallback}",
			"fontWeight": "{fontWeights.heading.regular}",
			"fontSize": "{fontSizes.normal}",
      "lineHeight": "140%",
      "letterSpacing": "4%"
		},
		"type": "typography"
	}
}
''';

void main() {
  test('Test typography transformer', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.resolvedTokens().length, equals(8));

    final transformer = TypographyTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    expect(transformer.lines.length, equals(2));
    expect(
      transformer.lines[0],
      equals(
        '''TextStyle get bold => const TextStyle(
  fontFamily: 'Roboto',
  fontSize: 12.0,
  fontWeight: FontWeight.w800,
  letterSpacing: 4.0,
);''',
      ),
    );
    expect(
      transformer.lines[1],
      equals(
        '''TextStyle get regular => const TextStyle(
  fontFamily: 'Roboto',
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
  height: 1.4,
  letterSpacing: 0.64,
);''',
      ),
    );
  });
}
