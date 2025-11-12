library;

/// Appointment sub-route paths (relative to parent routes)
class AppointmentRoutePaths {
  static const String details = ':id';
  static const String create = 'create';
  static const String reschedule = ':id/reschedule';
}

/// Named routes for appointment programmatic navigation
class AppointmentRouteNames {
  static const String details = 'appointment-details';
  static const String create = 'create-appointment';
  static const String reschedule = 'reschedule-appointment';
}
