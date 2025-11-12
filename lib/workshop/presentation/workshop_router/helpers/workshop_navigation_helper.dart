library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/router/route_constants.dart';
import 'package:safecar_mobile_app/workshop/presentation/workshop_router/workshop_route_constants.dart';

/// Helper class for appointment navigation
/// Provides type-safe navigation methods for appointment pages
class AppointmentNavigationHelper {
  /// Navigate to Appointments screen (main appointment list)
  static void goToAppointments(BuildContext context) {
    context.go(AppRoutes.workshop);
  }

  /// Navigate to Appointment Details page
  static void goToAppointmentDetails(BuildContext context, String appointmentId) {
    context.go('${AppRoutes.workshop}/$appointmentId');
  }

  /// Navigate to Create Appointment page
  static void goToCreateAppointment(BuildContext context) {
    context.goNamed(AppointmentRouteNames.create);
  }

  /// Navigate to Reschedule Appointment page
  static void goToRescheduleAppointment(
    BuildContext context,
    String appointmentId,
  ) {
    context.goNamed(
      AppointmentRouteNames.reschedule,
      pathParameters: {'id': appointmentId},
    );
  }

  /// Replace current screen with Appointments page
  static void replaceWithAppointments(BuildContext context) {
    context.pushReplacement(AppRoutes.workshop);
  }
}

/// Extension methods on BuildContext for easier appointment navigation
extension AppointmentNavigationExtension on BuildContext {
  /// Navigate to Appointments page
  void toAppointments() => AppointmentNavigationHelper.goToAppointments(this);

  /// Navigate to Appointment Details page
  void toAppointmentDetails(String appointmentId) =>
      AppointmentNavigationHelper.goToAppointmentDetails(this, appointmentId);

  /// Navigate to Create Appointment page
  void toCreateAppointment() => AppointmentNavigationHelper.goToCreateAppointment(this);

  /// Navigate to Reschedule Appointment page
  void toRescheduleAppointment(String appointmentId) =>
      AppointmentNavigationHelper.goToRescheduleAppointment(this, appointmentId);
}
