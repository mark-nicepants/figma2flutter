class ResolveTokenException {
  final String message;

  ResolveTokenException(this.message);

  @override
  String toString() {
    return 'ResolveTokenException{message: $message}';
  }
}
