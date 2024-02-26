class ResolveTokenException implements Exception {
  final String message;

  ResolveTokenException(this.message);

  @override
  String toString() {
    return 'ResolveTokenException{message: $message}';
  }
}
