/// https://tr.designtokens.org/format/#font-family
///
/// Represents a font name or an array of font names (ordered from most to least preferred).
///
/// The $type property MUST be set to the string fontFamily. The value MUST either be a string
/// value containing a single font name or an array of strings, each being a single font name.
///
/// Note: If an array is given, the first value is used.
///
/// EXAMPLE 18
// {
//   "Primary font": {
//     "$value": "Comic Sans MS",
//     "$type": "fontFamily"
//   },
//   "Body font": {
//     "$value": ["Helvetica", "Arial", "sans-serif"],
//     "$type": "fontFamily"
//   }
// }
class FontFamilyValue {
  final String value;

  FontFamilyValue(this.value);

  static FontFamilyValue? maybeParse(dynamic value) {
    if (value is List) {
      return FontFamilyValue(value.first as String);
    } else if (value is String) {
      return FontFamilyValue(value);
    }
    return null;
  }

  @override
  String toString() => value;
}
