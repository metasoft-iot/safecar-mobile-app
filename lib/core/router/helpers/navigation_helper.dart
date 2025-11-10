import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/core/router/route_constants.dart';

/// Navigation helper class with utility methods for app navigation
class NavigationHelper {
  NavigationHelper._();

  /// Navigate to a named route
  static void goToRoute(BuildContext context, String route) {
    context.go(route);
  }

  /// Push a named route
  static void pushRoute(BuildContext context, String route) {
    context.push(route);
  }

  /// Navigate to a named route and replace the current route
  static void replaceRoute(BuildContext context, String route) {
    context.replace(route);
  }

  /// Pop the current route
  static void pop(BuildContext context) {
    context.pop();
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // Bottom navigation shortcuts
  // TODO: Implement vehicles feature
  static void goToVehicles(BuildContext context) {
    context.go(AppRoutes.vehicles);
  }

  // TODO: Implement status feature
  static void goToStatus(BuildContext context) {
    context.go(AppRoutes.status);
  }

  static void goToAppointment(BuildContext context) {
    context.go(AppRoutes.appointment);
  }

  // TODO: Implement dashboard feature
  static void goToDashboard(BuildContext context) {
    context.go(AppRoutes.dashboard);
  }

  // Appointment-specific navigation
  static void goToAppointmentDetails(BuildContext context, String id) {
    context.push('/appointment/$id');
  }

  static void goToCreateAppointment(BuildContext context) {
    context.push(AppRoutes.createAppointment);
  }

  static void goToRescheduleAppointment(BuildContext context, String id) {
    context.push('/appointment/$id/reschedule');
  }
}

/// Extension on BuildContext for easier navigation
extension NavigationExtension on BuildContext {
  /// Navigate using go (replaces the entire stack)
  void navigateTo(String route) {
    go(route);
  }

  /// Navigate using push (adds to stack)
  void navigateToPush(String route) {
    push(route);
  }

  /// Navigate and replace
  void navigateReplace(String route) {
    replace(route);
  }

  /// Go back
  void navigateBack() {
    pop();
  }

  /// Check if can navigate back
  bool get canNavigateBack => canPop();

  // Shortcuts
  void toVehicles() => go(AppRoutes.vehicles); // TODO
  void toStatus() => go(AppRoutes.status); // TODO
  void toAppointment() => go(AppRoutes.appointment);
  void toDashboard() => go(AppRoutes.dashboard); // TODO
}
