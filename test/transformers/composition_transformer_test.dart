import 'dart:convert';

import 'package:figma2flutter/models/token.dart';
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
  "opacity50": {
    "type": "opacity",
    "value": "50%"
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
      "sizing": "100",
			"verticalPadding": "{dimensionDefault}",
			"horizontalPadding": "{dimensionDefault}",
			"fill": "{purple}",
			"itemSpacing": "{spacingDefault}",
      "borderTop": "{borderSmall}",
      "borderBottom": "{borderSmall}",
      "borderLeft": "{borderDefault}",
      "borderRight": "{borderDefault}",
      "boxShadow": "{defaultShadow}",
      "typography": "{regular}",
      "opacity": "{opacity50}"
		},
		"type": "composition"
	}
}
''';

void main() {
  test('Transform type composition', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens().length, equals(11));
    expect(
      parser.themes.first.tokens['dimensionDefault']?.type,
      equals('dimension'),
    );
    expect(
      parser.themes.first.tokens['spacingDefault']?.type,
      equals('spacing'),
    );
    expect(parser.themes.first.tokens['purple']?.type, equals('color'));
    expect(
      parser.themes.first.tokens['test-card']?.type,
      equals('composition'),
    );

    final transformer = CompositionTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    final expected = '''
CompositionToken get testCard => CompositionToken(
  size: const Size(100.0, 100.0),
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
    right: BorderSide(color: const Color(0xFF123456), width: 5.0, style: BorderStyle.solid),
    bottom: BorderSide(color: const Color(0xFF123456), width: 2.0, style: BorderStyle.solid),
    left: BorderSide(color: const Color(0xFF123456), width: 5.0, style: BorderStyle.solid),
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
  opacity: 0.5,
);''';

    expect(transformer.lines.first, equals(expected));
  });

  test('Test composition gradient, border all, radius all', () {
    final input = '''
{
   "gradient": {
    "value": "linear-gradient(45deg, #ffffff 0%, #000000 100%)",
    "type": "color"
  },
  "borderDefault": {
    "value": {
      "color": "#ff0000",
      "width": "2px",
      "style": "solid"
    },
    "type": "border"
  },
  "test-card": {
		"value": {
      "fill": "{gradient}",
      "border": "{borderDefault}",
      "borderRadius": "5px"
		},
		"type": "composition"
	}
}''';

    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    expect(parser.resolvedTokens().length, equals(3));

    final transformer = CompositionTransformer();
    parser.resolvedTokens().forEach(transformer.process);

    final output = '''
CompositionToken get testCard => CompositionToken(
  padding: const EdgeInsets.only(
    top: 0.0,
    right: 0.0,
    bottom: 0.0,
    left: 0.0,
  ),
  gradient: const LinearGradient(
  colors: [Color(0xFFFFFFFF), Color(0xFF000000),],
  stops: [0.0, 1.0],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  transform: GradientRotation(0.785),
),
  borderRadius: BorderRadius.circular(5.0),
  border: Border.all(color: const Color(0xFFFF0000), width: 2.0, style: BorderStyle.solid),
);''';
    expect(transformer.lines.first, equals(output));
  });

  test('invalid usage of CompositionTransformer', () {
    final transformer = CompositionTransformer();

    final invalid = Token(
      name: 'invalid',
      type: 'composition',
      value: 'invalid',
      path: 'invalid',
    );

    expect(() => transformer.transform(invalid), throwsException);
  });
}
