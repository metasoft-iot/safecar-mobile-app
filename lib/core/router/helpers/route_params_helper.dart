import 'package:go_router/go_router.dart';

/// Helper class for route parameters extraction and validation
/// Part of Core layer - Infrastructure concern
class RouteParamsHelper {
  RouteParamsHelper._();

  /// Extract a required string parameter from route state
  static String getRequiredParam(GoRouterState state, String paramName) {
    final param = state.pathParameters[paramName];
    if (param == null || param.isEmpty) {
      throw ArgumentError('Required parameter "$paramName" is missing');
    }
    return param;
  }

  /// Extract an optional string parameter from route state
  static String? getOptionalParam(GoRouterState state, String paramName) {
    return state.pathParameters[paramName];
  }

  /// Extract a required query parameter from route state
  static String getRequiredQuery(GoRouterState state, String queryName) {
    final query = state.uri.queryParameters[queryName];
    if (query == null || query.isEmpty) {
      throw ArgumentError('Required query parameter "$queryName" is missing');
    }
    return query;
  }

  /// Extract an optional query parameter from route state
  static String? getOptionalQuery(GoRouterState state, String queryName) {
    return state.uri.queryParameters[queryName];
  }

  /// Extract all query parameters
  static Map<String, String> getAllQueryParams(GoRouterState state) {
    return state.uri.queryParameters;
  }

  /// Extract extra data from route state
  static T? getExtra<T>(GoRouterState state) {
    return state.extra as T?;
  }

  /// Build a route with path parameters
  static String buildRoute(String template, Map<String, String> params) {
    var route = template;
    params.forEach((key, value) {
      route = route.replaceAll(':$key', value);
    });
    return route;
  }

  /// Build a route with query parameters
  static String buildRouteWithQuery(
    String path,
    Map<String, String> queryParams,
  ) {
    if (queryParams.isEmpty) return path;
    
    final query = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    return '$path?$query';
  }
}
