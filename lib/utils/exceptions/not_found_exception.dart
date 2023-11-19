class NotFoundException implements Exception {
  String cause;
  NotFoundException(this.cause);

  @override
  String toString() {
    return "Exception: $cause";
  }
}
