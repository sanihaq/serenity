class NotFoundException implements Exception {
  String cause;
  NotFoundException(this.cause);
}
