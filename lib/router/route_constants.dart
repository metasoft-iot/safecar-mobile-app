/// Route paths for the SafeCar Mobile App
class AppRoutes {
  static const String vehicles = '/vehicles';
  static const String status = '/status';
  static const String workshop = '/workshop';
  static const String dashboard = '/dashboard';
}

/// Sub-route paths (relative to parent routes)
class RoutePaths {
  static const String workshopDetails = ':id';
  static const String createWorkshop = 'create';
  static const String rescheduleWorkshop = ':id/reschedule';
}

/// Named routes for programmatic navigation
class RouteNames {
  static const String workshopDetails = 'workshop-details';
  static const String createWorkshop = 'create-workshop';
  static const String rescheduleWorkshop = 'reschedule-workshop';
}
