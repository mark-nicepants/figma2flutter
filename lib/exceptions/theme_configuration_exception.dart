class ThemeConfigurationException {
  final String message;

  ThemeConfigurationException(this.message);

  @override
  String toString() {
    return 'ThemeConfigurationException{message: $message}';
  }
}
