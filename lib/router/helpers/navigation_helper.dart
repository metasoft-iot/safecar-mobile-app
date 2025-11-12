library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/router/route_constants.dart';

/// Helper class for general navigation throughout the app
/// Provides type-safe navigation methods for main/parent routes
class NavigationHelper {
  /// Navigate to Vehicles screen
  static void goToVehicles(BuildContext context) {
    context.go(AppRoutes.vehicles);
  }

  /// Navigate to Status screen
  static void goToStatus(BuildContext context) {
    context.go(AppRoutes.status);
  }

  /// Navigate to Workshop screen
  static void goToWorkshop(BuildContext context) {
    context.go(AppRoutes.workshop);
  }

  /// Navigate to Dashboard screen
  static void goToDashboard(BuildContext context) {
    context.go(AppRoutes.dashboard);
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Replace current screen with Dashboard screen
  static void replaceWithDashboard(BuildContext context) {
    context.pushReplacement(AppRoutes.dashboard);
  }

  /// Show a dialog and wait for result
  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// Show a bottom sheet and wait for result
  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }
}

/// Extension methods on BuildContext for easier navigation
extension NavigationExtension on BuildContext {
  /// Navigate to Workshop screen
  void toWorkshop() => NavigationHelper.goToWorkshop(this);

  /// Go back to previous screen
  void goBack() => NavigationHelper.goBack(this);
}
