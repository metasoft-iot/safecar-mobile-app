class AppEnvironment {
  const AppEnvironment._();

  static const String apiBaseUrl = String.fromEnvironment(
    'SAFECAR_API_BASE_URL',
    defaultValue: 'https://safecar-backend-production.up.railway.app',
  );

  static const String _vehicleInsightsPath = '/api/v1/insights/vehicle';

  static Uri vehicleInsightsUri(int vehicleId) {
    return Uri.parse('$apiBaseUrl$_vehicleInsightsPath/$vehicleId');
  }

  static Uri submitVehicleSnapshotUri() {
    return Uri.parse('$apiBaseUrl$_vehicleInsightsPath');
  }
}
