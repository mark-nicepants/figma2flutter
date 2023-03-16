import 'package:collection/collection.dart';

/// https://tr.designtokens.org/format/#font-weight
///
/// Represents a font weight. The $type property MUST be set to the string fontWeight.
/// The value must either be a number value in the range [1, 1000] or one of the pre-defined string values defined in the table below.
///
/// Lower numbers represent lighter weights, and higher numbers represent thicker weights,
/// as per the OpenType wght tag specification. The pre-defined string values are aliases
/// for specific numeric values. For example 100, "thin" and "hairline" are all the exact same value.
///
/// | numeric value | string value aliases |
/// 100	thin, hairline
/// 200	extra-light, ultra-light
/// 300	light
/// 400	normal, regular, book
/// 500	medium
/// 600	semi-bold, demi-bold
/// 700	bold
/// 800	extra-bold, ultra-bold
/// 900	black, heavy
/// 950	extra-black, ultra-black (not widely supported, mapped to 900)
///
/// Note: As flutter supports 900 as a maximum font weight, the 950 value is mapped to 900.
class FontWeightValue {
  final int value;

  FontWeightValue(this.value);

  /// Returns a [FontWeightValue] if the [value] is a valid font weight.
  /// Otherwise returns null.
  static FontWeightValue? maybeParse(dynamic value) {
    final intValue = int.tryParse(value.toString());
    if (intValue != null) {
      return FontWeightValue(intValue);
    } else if (value is String) {
      final fontWeight = _fontWeightMap.entries.firstWhereOrNull(
        (entry) => entry.value.contains(value),
      );
      if (fontWeight != null) {
        return FontWeightValue(fontWeight.key);
      }
    }
    return null;
  }

  @override
  String toString() => 'FontWeight.w$value';
}

final _fontWeightMap = {
  100: ['thin', 'hairline'],
  200: ['extra-light', 'ultra-light'],
  300: ['light'],
  400: ['normal', 'regular', 'book'],
  500: ['medium'],
  600: ['semi-bold', 'demi-bold'],
  700: ['bold'],
  800: ['extra-bold', 'ultra-bold'],
  900: ['black', 'heavy', 'extra-black', 'ultra-black'],
};
