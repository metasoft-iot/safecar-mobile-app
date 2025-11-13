// lib/vehicle_management/vehicle_routes.dart

/// Rutas de Vehicle Management

class VehiclePaths {
  // Ruta base
  static const String vehicles = '/vehicles';

  // Subrutas (relativas al GoRoute de /vehicles)
  static const String vehicleAdd = 'add';        // /vehicles/add
  static const String vehicleDetails = ':id';    // /vehicles/:id
  static const String vehicleEdit = ':id/edit';  // /vehicles/:id/edit
}

class VehicleRouteNames {
  static const String vehicles = 'vehicles';
  static const String vehicleAdd = 'vehicle-add';
  static const String vehicleDetails = 'vehicle-details';
  static const String vehicleEdit = 'vehicle-edit';
}
