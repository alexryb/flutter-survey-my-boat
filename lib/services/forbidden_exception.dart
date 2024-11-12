class ForbiddenException implements Exception {
  String message;
  ForbiddenException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return "Exception: $message";
  }
}
