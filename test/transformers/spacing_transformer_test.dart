import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/spacing_transformer.dart';
import 'package:test/test.dart';

final input = '''
{
	"pixelValue": {
		"value": "10px",
		"type": "spacing"
	},
	"intValue": {
		"value": "100",
		"type": "spacing"
	},
	"remValue": {
		"value": "3rem",
		"type": "spacing"
	},
	"twoValues": {
		"value": "100 15px",
		"type": "spacing"
	},
	"threeValues": {
		"value": "1rem 2rem 3rem",
		"type": "spacing"
	},
	"fourValues": {
		"value": "16 8 16 8",
		"type": "spacing"
	}
}''';

void main() {
  test('Test all spacing variants', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.resolvedTokens.length, equals(6));
    expect(parser.tokenMap['pixelValue']?.type, equals('spacing'));

    final transformer = SpacingTransformer();
    parser.resolvedTokens.forEach(transformer.process);

    expect(transformer.lines.length, equals(6));
    expect(
      transformer.lines[0],
      equals(
        'EdgeInsets get pixelValue => const EdgeInsets.all(10.0);',
      ),
    );
    expect(
      transformer.lines[1],
      equals(
        'EdgeInsets get intValue => const EdgeInsets.all(100.0);',
      ),
    );
    expect(
      transformer.lines[2],
      equals(
        'EdgeInsets get remValue => const EdgeInsets.all(48.0);',
      ),
    );
    expect(
      transformer.lines[3],
      equals(
        'EdgeInsets get twoValues => const EdgeInsets.symmetric(horizontal: 15.0, vertical: 100.0);',
      ),
    );
    expect(
      transformer.lines[4],
      equals(
        'EdgeInsets get threeValues => const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0, bottom: 48.0);',
      ),
    );
    expect(
      transformer.lines[5],
      equals(
        'EdgeInsets get fourValues => const EdgeInsets.only(top: 16.0, right: 8.0, bottom: 16.0, left: 8.0);',
      ),
    );
  });
}
