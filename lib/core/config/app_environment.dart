/// Centralizes environment configuration (API URLs, credentials, flags).
class AppEnvironment {
  const AppEnvironment._();

  /// Base URL for the SafeCar backend. Can be overridden with `--dart-define`.
  static const String apiBaseUrl = String.fromEnvironment(
    'SAFECAR_API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Insights endpoints
  static const String _vehicleInsightsPath = '/api/v1/insights/vehicle';

  static Uri vehicleInsightsUri(int vehicleId) {
    return Uri.parse('$apiBaseUrl$_vehicleInsightsPath/$vehicleId');
  }

  static Uri submitVehicleSnapshotUri() {
    return Uri.parse('$apiBaseUrl$_vehicleInsightsPath');
  }
}
