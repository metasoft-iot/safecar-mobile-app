class VehicleInsightsException implements Exception {
  final String message;
  final int? statusCode;

  VehicleInsightsException(this.message, {this.statusCode});

  @override
  String toString() =>
      'VehicleInsightsException(statusCode: $statusCode, message: $message)';
}
