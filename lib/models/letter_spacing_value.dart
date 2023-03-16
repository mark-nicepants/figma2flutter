import 'package:figma2flutter/models/dimension_value.dart';

/// A value that represents a letter spacing.
/// This is different from [DimensionValue] because it can be a percentage.
/// If it is a percentage, it is converted to a decimal value. This percentage
/// is based on the base font size. 100% = 1rem = 16px. 50% = 0.5rem = 8px.
class LetterSpacingValue extends DimensionValue {
  LetterSpacingValue._(super.value);

  static LetterSpacingValue? maybeParse(dynamic value) {
    final dimensionValue = DimensionValue.maybeParse(value);
    if (dimensionValue == null) return null;

    if (value is String && value.endsWith('%')) {
      return LetterSpacingValue._(dimensionValue.value * kBaseFontSize);
    }

    return LetterSpacingValue._(dimensionValue.value);
  }
}
