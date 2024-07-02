import 'dart:convert';

import 'package:figma2flutter/exceptions/process_token_exception.dart';
import 'package:figma2flutter/exceptions/resolve_token_exception.dart';
import 'package:figma2flutter/processor.dart';
import 'package:figma2flutter/token_parser.dart';
import 'package:figma2flutter/transformers/color_transformer.dart';
import 'package:figma2flutter/transformers/single_token_factories.dart';
import 'package:figma2flutter/utils/sets_and_themes.dart';
import 'package:test/test.dart';

void main() {
  test('Test processor error resolve exception', () {
    final parsed = json.decode(input) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });

  test('Test processor error process exception', () {
    final parsed = json.decode(invalidColor) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ProcessTokenException>()),
    );
  });

  test('Test processor error color reference exception', () {
    final parsed = json.decode(invalidRefColor) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });

  test(
      'Test processor error color reference exception when a ref color is invalid',
      () {
    final parsed = json.decode(invalidRefColorRef) as Map<String, dynamic>;
    final parser = TokenParser()..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: [(_) => ColorTransformer()],
    );

    expect(
      () => processor.process(),
      throwsA(const TypeMatcher<ResolveTokenException>()),
    );
  });

  test('Test processor does not filter when unnecessary', () {
    final parsed = json.decode(singleDocInput) as Map<String, dynamic>;
    final setOrder = getSetsFromJson(parsed);
    final themes = getThemesFromJson(parsed);
    final parser = TokenParser(setOrder, themes)..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: singleTokenFactories,
    )..process(filteredSets: []);

    final transformers = processor.themes.first.transformers;

    expect(transformers.length, equals(5));
    for (final transformer in transformers) {
      if (transformer.name == 'color') {
        expect(transformer.lines.length, equals(6));
      }
      if (transformer.name == 'spacing') {
        expect(transformer.lines.length, equals(5));
      }
      if (transformer.name == 'textStyle') {
        expect(transformer.lines.length, equals(3));
      }
      if (transformer.name == 'radii') {
        expect(transformer.lines.length, equals(2));
      }
      if (transformer.name == 'size') {
        expect(transformer.lines.length, equals(4));
      }
    }
  });

  test('Test processor filters sets when necessary', () {
    final parsed = json.decode(singleDocInput) as Map<String, dynamic>;
    final setOrder = getSetsFromJson(parsed);
    final themes = getThemesFromJson(parsed);
    final parser = TokenParser(setOrder, themes)..parse(parsed);

    final processor = Processor(
      themes: parser.themes,
      singleTokenTransformerFactories: singleTokenFactories,
    )..process(filteredSets: ['core', 'spacing']);

    final transformers = processor.themes.first.transformers;
    for (final transformer in transformers) {
      print(
        'Found ${transformer.lines.length} ${transformer.name} tokens',
      );
    }
    expect(transformers.length, equals(3));
    for (final transformer in transformers) {
      if (transformer.name == 'textStyle') {
        expect(transformer.lines.length, equals(3));
      }
      if (transformer.name == 'radii') {
        expect(transformer.lines.length, equals(2));
      }
      if (transformer.name == 'size') {
        expect(transformer.lines.length, equals(4));
      }
    }
  });
}

final input = '''
{
  "token": {
    "value": "{purple}",
    "type": "color"
  }
}''';

final invalidColor = '''
{
  "token": {
    "value": "#purple",
    "type": "color"
  }
}''';

final invalidRefColor = '''
{
  "token": {
    "value": "rgba({brand.500}, 0.5)",
    "type": "color"
  }
}''';

final invalidRefColorRef = '''
{
  "purple": {
    "value": "#purple",
    "type": "color"
  },
  "token": {
    "value": "rgba({purple}, 0.5)",
    "type": "color"
  }
}''';

final singleDocInput = '''
{
  "\$metadata": {
    "tokenSetOrder": ["global", "core", "semantic-light"]
  },
  "\$themes": [
    {
      "id": "1a8dc4275d61b3e960452418b36ccaca5044d7f9",
      "name": "ping",
      "\$figmaStyleReferences": {
        "comp.map.radius": "S:c04f87cad480c58b39166b07fa3dab978dd26514",
        "surface.default": "S:7f742c34b318021ac6b36dd5ea458dffcffdfbc8",
        "accent.primary.default": "S:cb780648858a45f09d75ed88898f76b4fcc51cc4",
        "surface.map.gradient": "S:ba5d3b3bd836ce03caf7277380f4e88ae17872c2",
        "heading.large": "S:ea35d47676ec855b35a76ae0f4a2fb5aba34b2cc",
        "body.large": "S:1d9426100b4790a47a88e1274882726441f12ca2"
      },
      "selectedTokenSets": {
        "global": "enabled",
        "core": "source",
        "semantic-light": "enabled"
      },
      "\$figmaCollectionId": "VariableCollectionId:1608:316",
      "\$figmaModeId": "1608:0",
      "\$figmaVariableReferences": {
        "comp.map.radius": "b93a06255d03faf19c79f404da5798d589349a83",
        "surface.default": "e22c9b3d96eb478d7dc5d4d4825053a8c1b10caf",
        "accent.primary.default": "b956da767da14a0ea3846bfa54dd5387b445e69a",
        "surface.map.gradient": "ba5d3b3bd836ce03caf7277380f4e88ae17872c2",
        "heading.large": "ea35d47676ec855b35a76ae0f4a2fb5aba34b2cc",
        "body.large": "1d9426100b4790a47a88e1274882726441f12ca2"
      }
    }
  ],
  "global": {
    "global": {
      "spacing": {
        "0": { "value": 0, "type": "spacing" },
        "2": { "value": 2, "type": "spacing" },
        "4": { "value": 4, "type": "spacing" },
        "6": { "value": 6, "type": "spacing" },
        "8": { "value": 8, "type": "spacing" }
      },
      "lineHeights": {
        "0": { "value": "100%", "type": "lineHeights" },
        "16": { "value": 16, "type": "lineHeights" },
        "18": { "value": 18, "type": "lineHeights" }
      },
      "size": {
        "4": { "value": 4, "type": "sizing" },
        "8": { "value": 8, "type": "sizing" },
        "12": { "value": 12, "type": "sizing" },
        "16": { "value": 16, "type": "sizing" }
      },
      "borderRadius": {
        "0": { "value": 0, "type": "borderRadius" },
        "8": { "value": 8, "type": "borderRadius" }
      },
      "borderWidth": {
        "0": { "value": 0, "type": "borderWidth" },
        "1": { "value": 1, "type": "borderWidth" }
      },
      "fontSize": {
        "12": { "value": 12, "type": "fontSizes" },
        "13": { "value": 13, "type": "fontSizes" }
      },
      "letterSpacing": {
        "0": { "value": 0, "type": "letterSpacing" },
        "4": { "value": 4, "type": "letterSpacing" }
      },
      "opacity": {
        "0": { "value": "0%", "type": "opacity" },
        "5": { "value": "5%", "type": "opacity" }
      }
    }
  },
  "core": {
    "core": {
      "color": {
        "gray": {
          "5": { "value": "#EAE8E0", "type": "color" },
          "10": { "value": "#D5D3CD", "type": "color" }
        },
        "white": {
          "0": { "value": "#ffffff00", "type": "color" },
          "5": { "value": "#ffffff0d", "type": "color" }
        },
        "brown": {
          "5": { "value": "#E0AFA9", "type": "color" }
        },
        "indigo": {
          "40": { "value": "#4B0082", "type": "color" }
        }
      },
      "fontFamilies": {
        "primary": { "value": "Outfit", "type": "fontFamilies" }
      },
      "fontWeight": {
        "400": { "value": 400, "type": "fontWeight" },
        "600": { "value": 600, "type": "fontWeight" },
        "700": { "value": 700, "type": "fontWeight" }
      }
    }
  },
  "semantic-light": {
    "comp": {
      "map": {
        "radius": {
          "value": "accent.primary.higher",
          "type": "color",
          "\$extensions": {
            "studio.tokens": {
              "modify": {
                "type": "alpha",
                "value": ".38",
                "space": "lch"
              }
            }
          }
        }
      }
    },
    "surface": {
      "default": {
        "type": "color",
        "value": "core.color.brown.5"
      }
    },
    "heading": {
      "large": {
        "value": {
          "fontFamily": "core.fontFamilies.primary",
          "fontWeight": "core.fontWeight.700",
          "fontSize": "global.fontSize.32",
          "lineHeight": "global.lineHeights.40",
          "letterSpacing": "global.letterSpacing.0"
        },
        "type": "typography"
      }
    },
    "label": {
      "large": {
        "value": {
          "fontFamily": "core.fontFamilies.primary",
          "fontWeight": "core.fontWeight.600",
          "fontSize": "global.fontSize.18",
          "lineHeight": "global.lineHeights.24",
          "letterSpacing": "global.letterSpacing.0"
        },
        "type": "typography"
      }
    },
    "body": {
      "medium": {
        "value": {
          "fontFamily": "core.fontFamilies.primary",
          "fontWeight": "core.fontWeight.400",
          "fontSize": "global.fontSize.16",
          "lineHeight": "global.lineHeights.0",
          "letterSpacing": "global.letterSpacing.0"
        },
        "type": "typography"
      }
    }
  }
}
''';
