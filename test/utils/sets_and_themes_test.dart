import 'dart:convert';

import 'package:figma2flutter/utils/sets_and_themes.dart';
import 'package:test/test.dart';

void main() {
  test('getSetsFromJson', () {
    final parsed = json.decode(singleDocInput) as Map<String, dynamic>;
    final sets = getSetsFromJson(parsed);

    expect(sets, equals(['core', 'light', 'dark', 'theme']));
  });

  test('getThemesFromJson', () {
    final parsed = json.decode(singleDocInput) as Map<String, dynamic>;
    final themes = getThemesFromJson(parsed);

    expect(themes.length, equals(2));
    expect(themes[0].name, equals('light'));
    expect(themes[0].sets, equals(['core', 'light', 'theme']));

    expect(themes[1].name, equals('dark'));
    expect(themes[1].sets, equals(['core', 'dark', 'theme']));
  });

  test('manipulateMetadataFromFile', () {
    final parsed = json.decode(standaloneMetadataInput) as Map<String, dynamic>;
    final massaged = metadataAsSection(parsed);
    final expectedResult = json.decode(standaloneMetadataOutput);

    expect(massaged, equals(expectedResult));
  });

  test('manipulateThemesFromFile', () {
    final parsed = json.decode(standaloneThemeInput) as List<dynamic>;
    final massaged = themesAsSection(parsed);
    final expectedResult = json.decode(standaloneThemeOutput);

    expect(massaged, equals(expectedResult));
  });
}

final singleDocInput = '''
{
 "\$themes": [
      {
        "id": "33f7ab9c99363ec90d03707ec9b383c1259aadbe",
        "name": "light",
        "selectedTokenSets": {
          "core": "source",
          "light": "enabled",
          "theme": "enabled"
        },
        "\$figmaStyleReferences": {}
      },
      {
        "id": "a433dc4e5dfab62b5063a58b6c8a38aa36f20f52",
        "name": "dark",
        "selectedTokenSets": {
          "core": "source",
          "dark": "enabled",
          "theme": "enabled"
        },
        "\$figmaStyleReferences": {
          "button.primary.background": "S:183bfd323d7205fd5e4bddabbff1cb3696bd4747,",
          "button.primary.text": "S:32f312598c92b48a542ad86e27a6e3e3f076bec5,",
          "card.background": "S:1c2e181a1e5eb14b9260c7cae923bb7af78bbccd,",
          "fg.default": "S:d63de4049baee6b58fea74f21cf491372e539aad,",
          "fg.muted": "S:8b2ec83cabf4ab199b69cb08cb33946bd63d97f0,",
          "fg.subtle": "S:18317e21ac43f82fc44dc9b968519413505c0bf4,",
          "bg.default": "S:3d0415ae139a55d63ff536ff408d3aa4e72c6a73,",
          "bg.muted": "S:f204ded80d95f63398ff10c180798d234a243d51,",
          "bg.subtle": "S:7af269bac16527b97c2cebf0870396a5422475bd,",
          "accent.default": "S:ef78df17ed9329480aeb7639d9a38954c1ba05be,",
          "accent.onAccent": "S:8bc992a113d23f5f45e5c8b815cc9314ea4b2910,",
          "accent.bg": "S:3785731f175611e4b02a6d276855260ff4acf484,",
          "shadows.default": "S:a4b796186c3b8bf05b74e15cf635c2d98ad3bf75,",
          "typography.H1.Bold": "S:f15cf52714ee6b5148384fb80ef8b11ee55c31a6,",
          "typography.H1.Regular": "S:504034451d649b225143193aee7a0f51c5d5106e,",
          "typography.Body": "S:ccd0d10b0d1b3a58224645fd0f4d8533cc0587c6,",
          "boxShadow.default": "S:cff695ae2acbe063f75f2dc7ec5a0000f0a5db0a,"
        }
      }
    ],
    "\$metadata": {
      "tokenSetOrder": [
        "core",
        "light",
        "dark",
        "theme"
      ]
    }
  }
''';

/// contents when in a file with pathing - taken from zengarden exmaple
final standaloneMetadataInput = '''
{
  "tokenSetOrder": [
    "global",
    "semantic",
    "comp/button",
    "theme/light"
  ]
}''';

final standaloneMetadataOutput = '''
{
  "tokenSetOrder": [
    "global",
    "semantic",
    "button",
    "light"
  ]
}''';

/// contents when in a file with pathing - taken from zengarden example
final standaloneThemeInput = '''
[
  {
    "id": "7347fd90e502aaece9e7cf40f79f188b93485a2a",
    "name": "default - light",
    "selectedTokenSets": {
      "global": "enabled",
      "semantic": "enabled",
      "comp/button": "enabled",
      "theme/light": "enabled"
    },
    "\$figmaStyleReferences": {}
  }
]
''';

final standaloneThemeOutput = '''
[
  {
    "id": "7347fd90e502aaece9e7cf40f79f188b93485a2a",
    "name": "default - light",
    "selectedTokenSets": {
      "global": "enabled",
      "semantic": "enabled",
      "button": "enabled",
      "light": "enabled"
    },
    "\$figmaStyleReferences": {}
  }
]
''';
