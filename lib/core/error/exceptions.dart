class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}

class MissingTokenException implements Exception {
  const MissingTokenException();

  @override
  String toString() => 'MissingTokenException: Authorization token is required.';
}
