class AppEnvironment {
  const AppEnvironment._();

  static const String baseUrl = String.fromEnvironment(
    'SAFE_CAR_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String bearerToken = String.fromEnvironment(
    'SAFE_CAR_TOKEN',
    defaultValue: '',
  );

  static const String insightsPath = '/api/v1/insights';

  static Uri buildUri(String pathSegment) {
    final sanitized = pathSegment.startsWith('/') ? pathSegment : '/$pathSegment';
    return Uri.parse('$baseUrl$sanitized');
  }

  static bool get hasAuthToken => bearerToken.isNotEmpty;
}
