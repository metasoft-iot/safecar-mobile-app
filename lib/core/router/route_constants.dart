/// Route names constants for the application
/// This ensures type-safe navigation and avoids hardcoded strings
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Main routes
  static const String root = '/';
  
  // Bottom navigation routes
  static const String vehicles = '/vehicles';
  static const String status = '/status';
  static const String appointment = '/appointment';
  static const String dashboard = '/dashboard';
  
  // Feature-specific sub-routes
  static const String appointmentDetails = '/appointment/:id';
  static const String createAppointment = '/appointment/create';
  
  // Error routes
  static const String notFound = '/404';
}

/// Route paths for GoRouter configuration
class RoutePaths {
  RoutePaths._();

  static const String root = '/';
  static const String vehicles = 'vehicles';
  static const String status = 'status';
  static const String appointment = 'appointment';
  static const String dashboard = 'dashboard';
  static const String appointmentDetails = ':id';
  static const String createAppointment = 'create';
  static const String notFound = '404';
}

/// Route names for identification
class RouteNames {
  RouteNames._();

  static const String root = 'root';
  static const String vehicles = 'vehicles';
  static const String status = 'status';
  static const String appointment = 'appointment';
  static const String dashboard = 'dashboard';
  static const String appointmentDetails = 'appointment-details';
  static const String createAppointment = 'create-appointment';
  static const String rescheduleAppointment = 'reschedule-appointment';
  static const String notFound = 'not-found';
}
