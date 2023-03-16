import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

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

/// https://tr.designtokens.org/format/#alias-reference
/// https://docs.tokens.studio/tokens/aliases
///
/// 3.8 Alias (reference)
///
/// To use an alias in your tokens, we write them in the following notation: {spacing.sm},
/// you can also write them in the older $ notation, like this: $spacing.sm

void main() {
  test('references with both annotations and within groups ', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(6));
    expect(parser.tokenMap['token']?.type, equals('color'));
    expect(parser.tokenMap['group.token']?.type, equals('dimension'));

    expect(parser.resolve('token1')?.type, equals('color'));
    expect(parser.resolve('token2')?.type, equals('color'));
    expect(parser.resolve('token3')?.type, equals('dimension'));
    expect(parser.resolve('token4')?.type, equals('dimension'));
  });

  test('child references are properly resolved', () {
    final parsed = json.decode(childReferences) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap.length, equals(5));

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
}
