class HttpException implements Exception {
  final dynamic message;

  HttpException([this.message]);

  String toString() {
    Object message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
