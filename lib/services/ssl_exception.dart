class SSLException implements Exception {
  String message;
  SSLException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return "Exception: $message";
  }
}
