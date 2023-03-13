class Sizes {
  final List<double> values;

  factory Sizes.from(dynamic value) {
    // If value can be parsed as a double, return a single value

    // Split on spaces and parse each value to a size
    final values = (value as String).split(' ').map(_parseNum).toList();
    return Sizes._(values);
  }

  Sizes._(this.values);
}

double _parseNum(String value) {
  if (value.endsWith('px')) {
    return double.tryParse(value.substring(0, value.length - 2)) ?? 0;
  }
  if (value.endsWith('rem')) {
    return (double.tryParse(value.substring(0, value.length - 3)) ?? 0) * 16;
  }

  return double.tryParse(value) ?? 0;
}
