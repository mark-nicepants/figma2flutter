const kInput = 'input';
const kInputAbbr = 'i';

const kOutput = 'output';
const kOutputAbbr = 'o';

class Option<T> {
  final String name;
  final String? abbr;
  final String help;
  final T defaultValue;

  T? _value;
  T get value => _value ?? defaultValue;
  set value(T value) {
    // * All string options are paths at the moment, sanitize the path
    if (value is String && value.contains('/')) {
      _value = _addRoot(_removeEndSlash(value)) as T;
    } else {
      _value = value;
    }
  }

  Option(this.name, this.defaultValue, this.help, [this.abbr]);

  Option<T> copy() => Option<T>(name, defaultValue, help, abbr);

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

class Options {
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
  ];

  Option<T> getOption<T>(String name) {
    final results = options.where((element) => element.name == name);
    if (results.isEmpty) throw 'Cannot find option with name `$name`';
    return results.first as Option<T>;
  }

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

  Options operator +(Options other) {
    final result = Options();

    void mergeOption(Option<dynamic> option) {
      result.setOption(option.name, (option + other.getOption(option.name)).value);
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
