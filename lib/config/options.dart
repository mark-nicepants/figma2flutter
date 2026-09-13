const kInput = 'input';
const kInputAbbr = 'i';

const kOutput = 'output';
const kOutputAbbr = 'o';

const kFilteredTokenSets = 'filtered-token-sets';
const kFilteredTokenSetsAbbr = 'f';

/// Options class to store a single option
class Option<T> {
  /// The name of the option
  final String name;

  /// The abbreviation of the option
  final String? abbr;

  /// The help text for the option when using the help flag
  final String help;

  /// The default value of the option
  final T defaultValue;

  /// The parsed value of the option
  T? _value;

  /// Returns the value of the option, if not set, the default value is used
  T get value => _value ?? defaultValue;

  /// Sets the value of the option
  set value(T value) {
    // * All string options are paths at the moment, sanitize the path
    if (value is String && value.contains('/')) {
      _value = _addRoot(_removeEndSlash(value)) as T;
    } else {
      _value = value;
    }
  }

  /// Constructor for the option class
  Option(this.name, this.defaultValue, this.help, [this.abbr]);

  /// Copies this option into a new object
  Option<T> copy() => Option<T>(name, defaultValue, help, abbr);

  /// When merging options we can use the + operator to merge the values
  /// of the options. If there are more than one option the filled in and
  /// not the same as the default, the second option will be used.
  Option<T> operator +(Option<T> other) {
    if (name != other.name) throw 'Cannot add to options of different type';
    final newOption = copy();
    newOption.value = _getValue(value, other.value, defaultValue);
    return newOption;
  }

  @override
  String toString() {
    return '$name: $value';
  }
}

/// Container that holds all available options for this program
class Options {
  /// The list of all available options
  List<Option<String>> options = [
    Option<String>(
      kInput,
      './design/tokens.json',
      'Specify the directory where the design token json lives.',
      kInputAbbr,
    ),
    Option<String>(
      kOutput,
      './lib/assets/tokens/',
      'Specify generated output directory.',
      kOutputAbbr,
    ),
    // Omits tokens by type, I.E. "core, source"
    Option<String>(
      kFilteredTokenSets,
      '',
      'Specify token sets to filter, separated by commas.',
      kFilteredTokenSetsAbbr,
    ),
  ];

  /// Returns the option with the given name
  Option<T> getOption<T>(String name) {
    final results = options.where((element) => element.name == name);
    if (results.isEmpty) throw 'Cannot find option with name `$name`';
    return results.first as Option<T>;
  }

  /// Sets the option with the given name to the given value
  void setOption<T>(String name, T? value) {
    if (value != null) {
      getOption<T>(name).value = value;
    }
  }

  @override
  String toString() {
    return '''
Options:
  $options
''';
  }

  /// When merging options we can use the + operator to merge the values
  Options operator +(Options other) {
    final result = Options();

    void mergeOption(Option<dynamic> option) {
      result.setOption(
        option.name,
        (option + other.getOption(option.name)).value,
      );
    }

    options.forEach(mergeOption);

    return result;
  }
}

T _getValue<T>(T first, T second, T defaultValue) {
  // Same doesnt matter what we return
  if (first == second) return first;
  // first is default, return second
  if (first == defaultValue) return second;
  // second is default, return first
  if (second == defaultValue) return first;
  // second takes precedent when both are not the default value
  return second;
}

String _removeEndSlash(String input) {
  if (input.endsWith('/')) return input.substring(0, input.length - 1);
  return input;
}

String _addRoot(String input) {
  if (!input.startsWith('./')) return './$input';
  return input;
}
