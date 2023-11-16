import 'package:collection/collection.dart';
import 'package:figma2flutter/models/color_value.dart';
import 'package:figma2flutter/models/token.dart';
import 'package:figma2flutter/transformers/transformer.dart';
import 'package:meta/meta.dart';

/// Tries to transform multiple tokens in a single material color
class MaterialColorTransformer extends MultiTokenTransformer {
  @visibleForTesting
  final colorTokensByName = <String, List<_MaterialColorEntry>>{};

  MaterialColorTransformer(super.allTokens);

  @override
  bool matcher(Token token) {
    return token.type == 'color';
  }

  @override
  String get name => 'materialColor';

  final _supportedDigits = [
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
    950,
    50, // As last on purpose so we can use the firstWhereOrNull
  ];

  @override
  void process(Token token) {
    if (!matcher(token)) return;

    // See if the name end with a supported digit (e.g. 50, 100, 200, ...)
    final digit = _supportedDigits.firstWhereOrNull(
      (digit) => token.variableName.endsWith(digit.toString()),
    );

    // Early return, not a supported digit to be used in a material color
    if (digit == null) return;

    // Remove the digit from the name
    final name = token.variableName
        .substring(0, token.variableName.length - digit.toString().length);

    // Add the token to the list of tokens with the same name
    colorTokensByName.putIfAbsent(name, () => []).add(
          _MaterialColorEntry(
            digit,
            ColorValue.maybeParse(token.value)!,
          ),
        );
  }

  @override
  void postProcess() {
    // Loop over all the tokens with the same name
    for (final entry in colorTokensByName.entries) {
      final name = entry.key;
      final colors = entry.value;

      // Sort the colors by their digit
      colors.sort((a, b) => a.digit.compareTo(b.digit));

      final primary = _primaryColorInt(colors);

      // Add the color to the lines
      lines.add(
        '''
@override
MaterialColor get $name => const MaterialColor($primary, {
  ${colors.map((e) => '${e.digit}: ${e.color.declaration(isConst: false)}').join(',\n  ')},
});
''',
      );
    }
  }

  String _primaryColorInt(List<_MaterialColorEntry> colors) {
    final bestEntry =
        colors.firstWhereOrNull((e) => e.digit == 500) ?? colors.first;

    return bestEntry.color.toHex8();
  }
}

class _MaterialColorEntry {
  final int digit;
  final ColorValue color;

  _MaterialColorEntry(this.digit, this.color);
}
