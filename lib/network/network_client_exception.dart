enum HttpApiExceptionType {
  network,
  other,
}

class HttpApiException implements Exception {
  final HttpApiExceptionType type;

  HttpApiException(this.type);
}
