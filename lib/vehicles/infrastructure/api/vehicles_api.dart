import 'dart:convert';
import '../../../core/infrastructure/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../resources/vehicles_response.dart';

/// API service for vehicle operations.
/// Handles all HTTP requests related to vehicles.
class VehiclesApi {
  final ApiService _apiService;

  VehiclesApi(this._apiService);

  /// Get all vehicles for a driver
  Future<VehiclesResponse> getVehiclesByDriverId(int driverId) async {
    print('[VehiclesApi] 🚗 Fetching vehicles for driver ID: $driverId');
    
    final response = await _apiService.get(
      ApiConstants.driverVehicles(driverId),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('[VehiclesApi] 🚗 Found ${data.length} vehicles');
      return VehiclesResponse.fromJson(data);
    } else if (response.statusCode == 404) {
      print('[VehiclesApi] 🚗 No vehicles found for driver $driverId');
      return VehiclesResponse(vehicles: []);
    } else {
      throw Exception('Failed to load vehicles: ${response.statusCode}');
    }
  }

  /// Get a single vehicle by ID
  Future<VehicleResource> getVehicleById(int vehicleId) async {
    print('[VehiclesApi] 🚗 Fetching vehicle ID: $vehicleId');
    
    final response = await _apiService.get(
      ApiConstants.vehicleById(vehicleId),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return VehicleResource.fromJson(data);
    } else {
      throw Exception('Failed to load vehicle: ${response.statusCode}');
    }
  }

  /// Create a new vehicle
  Future<VehicleResource> createVehicle({
    required int driverId,
    required String licensePlate,
    required String brand,
    required String model,
    int? year,
    String? vin,
    String? color,
    int? mileage,
  }) async {
    print('[VehiclesApi] 🚗 Creating vehicle: $brand $model ($licensePlate)');
    
    final payload = {
      'driverId': driverId,
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      if (year != null) 'year': year,
      if (vin != null) 'vin': vin,
      if (color != null) 'color': color,
      if (mileage != null) 'mileage': mileage,
    };

    final response = await _apiService.post(
      '/vehicles',
      payload,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('[VehiclesApi] ✅ Vehicle created successfully');
      return VehicleResource.fromJson(data);
    } else {
      throw Exception('Failed to create vehicle: ${response.statusCode} - ${response.body}');
    }
  }

  /// Update an existing vehicle
  Future<VehicleResource> updateVehicle({
    required int vehicleId,
    String? licensePlate,
    String? brand,
    String? model,
    int? year,
    String? vin,
  }) async {
    print('[VehiclesApi] 🚗 Updating vehicle ID: $vehicleId');
    
    final payload = <String, dynamic>{};
    if (licensePlate != null) payload['licensePlate'] = licensePlate;
    if (brand != null) payload['brand'] = brand;
    if (model != null) payload['model'] = model;
    if (year != null) payload['year'] = year;
    if (vin != null) payload['vin'] = vin;

    final response = await _apiService.put(
      '/vehicles/$vehicleId',
      payload,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('[VehiclesApi] ✅ Vehicle updated successfully');
      return VehicleResource.fromJson(data);
    } else {
      throw Exception('Failed to update vehicle: ${response.statusCode}');
    }
  }

  /// Delete a vehicle
  Future<void> deleteVehicle(int vehicleId) async {
    print('[VehiclesApi] 🚗 Deleting vehicle ID: $vehicleId');
    
    final response = await _apiService.delete(
      '/vehicles/$vehicleId',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete vehicle: ${response.statusCode}');
    }

    print('[VehiclesApi] ✅ Vehicle deleted successfully');
  }
}

