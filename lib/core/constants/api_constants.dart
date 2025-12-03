/// API configuration constants for SafeCar mobile app
class ApiConstants {
  // Base URL - change this to match your backend deployment
  static const String baseUrl = 'https://safecar-backend-production-fe3b.up.railway.app/api/v1';
  
  // Authentication endpoints
  static const String authSignIn = '/authentication/sign-in';
  static const String authSignUp = '/authentication/sign-up';
  
  // Profile endpoints
  static const String personProfiles = '/person-profiles';
  static String personProfileByEmail(String email) => '/person-profiles?userEmail=$email';
  static String personProfileById(int profileId) => '/person-profiles/$profileId';
  
  // Drivers endpoints
  static String driverById(int driverId) => '/drivers/$driverId';
  static String driverVehicles(int driverId) => '/vehicles?driver=$driverId';
  static String driverByProfileId(int profileId) => '/drivers?profile=$profileId';
  
  // Workshop endpoints
  static const String workshops = '/workshops';
  static String workshopById(int workshopId) => '/workshops/$workshopId';
  
  // Appointment endpoints
  static String appointmentsByDriver(int workshopId, int driverId) => 
    '/workshops/$workshopId/appointments?driverId=$driverId';
  static String appointmentById(int workshopId, int appointmentId) => 
    '/workshops/$workshopId?appointment=$appointmentId';
  
  // Mechanic endpoints
  static String mechanicById(int mechanicId) => '/mechanics/$mechanicId';
  
  // Vehicle endpoints
  static String vehicleById(int vehicleId) => '/vehicles/$vehicleId';
}

