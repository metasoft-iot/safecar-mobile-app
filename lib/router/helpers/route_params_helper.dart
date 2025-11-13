library;

import 'package:go_router/go_router.dart';

/// Helper class for extracting route parameters
/// Provides type-safe parameter extraction with defaults
class RouteParamsHelper {
  /// Get a required string parameter
  /// Throws if the parameter is missing
  static String getRequiredString(GoRouterState state, String key) {
    final value = state.pathParameters[key];
    if (value == null || value.isEmpty) {
      throw ArgumentError('Required parameter "$key" is missing');
    }
    return value;
  }

  /// Get an optional string parameter
  /// Returns null if the parameter is missing
  static String? getOptionalString(GoRouterState state, String key) {
    return state.pathParameters[key];
  }

  /// Get a required int parameter
  /// Throws if the parameter is missing or invalid
  static int getRequiredInt(GoRouterState state, String key) {
    final value = getRequiredString(state, key);
    final intValue = int.tryParse(value);
    if (intValue == null) {
      throw ArgumentError('Parameter "$key" must be a valid integer');
    }
    return intValue;
  }

  /// Get an optional int parameter
  /// Returns null if the parameter is missing or invalid
  static int? getOptionalInt(GoRouterState state, String key) {
    final value = getOptionalString(state, key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Get a required boolean parameter
  /// Throws if the parameter is missing or invalid
  static bool getRequiredBool(GoRouterState state, String key) {
    final value = getRequiredString(state, key).toLowerCase();
    if (value == 'true') return true;
    if (value == 'false') return false;
    throw ArgumentError('Parameter "$key" must be "true" or "false"');
  }

  /// Get an optional boolean parameter
  /// Returns null if the parameter is missing or invalid
  static bool? getOptionalBool(GoRouterState state, String key) {
    final value = getOptionalString(state, key)?.toLowerCase();
    if (value == null) return null;
    if (value == 'true') return true;
    if (value == 'false') return false;
    return null;
  }
}
