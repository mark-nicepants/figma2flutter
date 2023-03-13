import 'dart:convert';

import 'package:figma2flutter/token_parser.dart';
import 'package:test/test.dart';

final input = '''
{
    "source": {
        "0": {
            "value": "0",
            "type": "letterSpacing"
        },
        "brand": {
            "50": {
                "value": "#f0faff",
                "type": "color"
            },
            "100": {
                "value": "#e0f5fe",
                "type": "color"
            },
            "200": {
                "value": "#bae8fd",
                "type": "color"
            },
            "300": {
                "value": "#7dd5fc",
                "type": "color"
            },
            "400": {
                "value": "#38bcf8",
                "type": "color"
            },
            "500": {
                "value": "#0ea5e9",
                "type": "color"
            },
            "600": {
                "value": "#028ac7",
                "type": "color"
            },
            "700": {
                "value": "#0370a1",
                "type": "color"
            },
            "800": {
                "value": "#075e85",
                "type": "color"
            },
            "900": {
                "value": "#0c506e",
                "type": "color"
            }
        },
        "gray": {
            "50": {
                "value": "#f9fafb",
                "type": "color"
            },
            "100": {
                "value": "#f3f4f6",
                "type": "color"
            },
            "200": {
                "value": "#e5e7eb",
                "type": "color"
            },
            "300": {
                "value": "#d1d5db",
                "type": "color"
            },
            "400": {
                "value": "#9ca3af",
                "type": "color"
            },
            "500": {
                "value": "#6b7280",
                "type": "color"
            },
            "600": {
                "value": "#4b5563",
                "type": "color"
            },
            "700": {
                "value": "#374151",
                "type": "color"
            },
            "800": {
                "value": "#1f2937",
                "type": "color"
            },
            "900": {
                "value": "#111827",
                "type": "color"
            }
        },
        "red": {
            "50": {
                "value": "#fef2f2",
                "type": "color"
            },
            "100": {
                "value": "#fee2e2",
                "type": "color"
            },
            "200": {
                "value": "#fecaca",
                "type": "color"
            },
            "300": {
                "value": "#fca5a5",
                "type": "color"
            },
            "400": {
                "value": "#f87171",
                "type": "color"
            },
            "500": {
                "value": "#ef4444",
                "type": "color"
            },
            "600": {
                "value": "#dc2626",
                "type": "color"
            },
            "700": {
                "value": "#b91c1c",
                "type": "color"
            },
            "800": {
                "value": "#991b1b",
                "type": "color"
            },
            "900": {
                "value": "#7f1d1d",
                "type": "color"
            }
        },
        "yellow": {
            "50": {
                "value": "#fefce8",
                "type": "color"
            },
            "100": {
                "value": "#fef9c3",
                "type": "color"
            },
            "200": {
                "value": "#fef08a",
                "type": "color"
            },
            "300": {
                "value": "#fde047",
                "type": "color"
            },
            "400": {
                "value": "#facc15",
                "type": "color"
            },
            "500": {
                "value": "#eab308",
                "type": "color"
            },
            "600": {
                "value": "#ca8a04",
                "type": "color"
            },
            "700": {
                "value": "#a16207",
                "type": "color"
            },
            "800": {
                "value": "#854d0e",
                "type": "color"
            },
            "900": {
                "value": "#713f12",
                "type": "color"
            }
        },
        "green": {
            "50": {
                "value": "#f0fdf4",
                "type": "color"
            },
            "100": {
                "value": "#dcfce7",
                "type": "color"
            },
            "200": {
                "value": "#bbf7d0",
                "type": "color"
            },
            "300": {
                "value": "#86efac",
                "type": "color"
            },
            "400": {
                "value": "#4ade80",
                "type": "color"
            },
            "500": {
                "value": "#22c55e",
                "type": "color"
            },
            "600": {
                "value": "#16a34a",
                "type": "color"
            },
            "700": {
                "value": "#15803d",
                "type": "color"
            },
            "800": {
                "value": "#166534",
                "type": "color"
            },
            "900": {
                "value": "#14532d",
                "type": "color"
            }
        },
        "white": {
            "value": "#ffffff",
            "type": "color"
        },
        "black": {
            "value": "#000000",
            "type": "color"
        },
        "transparent": {
            "value": "rgba(255,255,255,0)",
            "type": "color"
        },
        "GeneralSans": {
            "value": "General Sans",
            "type": "fontFamilies"
        },
        "Default": {
            "value": "140%",
            "type": "lineHeights"
        },
        "Footnote": {
            "value": "13",
            "type": "fontSizes"
        },
        "Subheadline": {
            "value": "15",
            "type": "fontSizes"
        },
        "Body": {
            "value": "17",
            "type": "fontSizes"
        },
        "Title": {
            "value": "20",
            "type": "fontSizes"
        },
        "LargeTitle": {
            "value": "34",
            "type": "fontSizes"
        },
        "Regular": {
            "value": "Regular",
            "type": "fontWeights"
        },
        "Medium": {
            "value": "Medium",
            "type": "fontWeights"
        },
        "Bold": {
            "value": "Bold",
            "type": "fontWeights"
        }
    },
    "semantic": {
        "brand": {
            "50": {
                "value": "#696969",
                "type": "color"
            }
        }
    },
    "\$themes": [],
    "\$metadata": {
        "tokenSetOrder": [
            "source",
            "semantic"
        ]
    }
}''';

void main() {
  test('sets parsing and value overrides', () {
    final parsed = json.decode(input);
    final parser = TokenParser(['source', 'semantic']);
    parser.parse(parsed);

    expect(parser.tokenMap['brand.50']?.type, equals('color'));
    expect(parser.tokenMap['brand.50']?.value, equals('#696969'));
  });

  test('no overrides when no sets are specified', () {
    final parsed = json.decode(input);
    final parser = TokenParser();
    parser.parse(parsed);

    expect(parser.tokenMap['semantic.brand.50']?.type, equals('color'));
    expect(parser.tokenMap['source.brand.50']?.value, equals('#f0faff'));
    expect(parser.tokenMap['brand.50'], isNull);
  });
}
