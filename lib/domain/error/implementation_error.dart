class ImplementationError extends Error {
  final String message;

  ImplementationError(this.message);

  @override
  String toString() {
    return 'Implementation error: $message';
  }
}
