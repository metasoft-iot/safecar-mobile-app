import 'dart:convert';
import 'api_service.dart';
import '../constants/api_constants.dart';

/// Service to manage vehicle data from the backend
class VehicleService {
  static final VehicleService _instance = VehicleService._internal();
  
  factory VehicleService() {
    return _instance;
  }
  
  VehicleService._internal();
  
  final _apiService = ApiService();
  List<Map<String, dynamic>> _cachedVehicles = [];
  bool _isLoaded = false;
  
  /// Get all vehicles for the current driver from backend
  Future<List<Map<String, dynamic>>> getVehicles() async {
    try {
      final driverId = await _getDriverId();
      
      if (driverId == null) {
        print('🚗 No driver ID found. User might not be logged in or profile not created.');
        return [];
      }
      
      print('🚗 Fetching vehicles for driver ID: $driverId');
      final response = await _apiService.get(
        ApiConstants.driverVehicles(driverId),
      );
      
      print('🚗 Vehicle response status: ${response.statusCode}');
      print('🚗 Vehicle response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('🚗 Parsed ${data.length} vehicles');
        
        _cachedVehicles = data.map((vehicle) {
          return {
            'id': vehicle['id'].toString(),
            'brand': vehicle['brand'] ?? '',  // Backend uses 'brand', not 'make'
            'model': vehicle['model'] ?? '',
            'licensePlate': vehicle['licensePlate'] ?? '',
            'displayName': '${vehicle['brand']} ${vehicle['model']} (${vehicle['licensePlate']})',
          };
        }).toList();
        
        _isLoaded = true;
        print('🚗 Cached ${_cachedVehicles.length} vehicles');
        return List.from(_cachedVehicles);
      } else if (response.statusCode == 404) {
        // No vehicles found for this driver
        print('🚗 No vehicles found for driver $driverId');
        _cachedVehicles = [];
        _isLoaded = true;
        return [];
      } else {
        print('🚗 Error loading vehicles: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🚗 Exception loading vehicles: $e');
      return [];
    }
  }
  
  /// Get driver ID from stored user data
  Future<int?> _getDriverId() async {
    try {
      // Use the new method with fallback
      return await _apiService.getDriverIdWithFallback();
    } catch (e) {
      print('Error getting driver ID: $e');
      return null;
    }
  }
  
  /// Reload vehicles from backend (refresh)
  Future<List<Map<String, dynamic>>> refreshVehicles() async {
    _isLoaded = false;
    _cachedVehicles = [];
    return await getVehicles();
  }
  
  /// Clear cached vehicles
  void clearCache() {
    _isLoaded = false;
    _cachedVehicles = [];
  }
  
  /// Get vehicle by ID from cache or backend
  Future<Map<String, dynamic>?> getVehicleById(String id) async {
    // First check cache
    if (_isLoaded) {
      try {
        return _cachedVehicles.firstWhere((v) => v['id'] == id);
      } catch (e) {
        // Not in cache, fetch from backend
      }
    }
    
    // Fetch from backend
    try {
      final response = await _apiService.get(
        ApiConstants.vehicleById(int.parse(id)),
      );
      
      if (response.statusCode == 200) {
        final vehicle = jsonDecode(response.body);
        return {
          'id': vehicle['id'].toString(),
          'brand': vehicle['brand'] ?? '',  // Backend uses 'brand'
          'model': vehicle['model'] ?? '',
          'licensePlate': vehicle['licensePlate'] ?? '',
          'displayName': '${vehicle['brand']} ${vehicle['model']} (${vehicle['licensePlate']})',
        };
      }
    } catch (e) {
      print('Error getting vehicle by ID: $e');
    }
    
    return null;
  }
  
  /// Add a new vehicle
  Future<bool> addVehicle(Map<String, dynamic> vehicleData) async {
    try {
      final driverId = await _getDriverId();
      
      if (driverId == null) {
        print('Cannot create vehicle: No driver ID found');
        return false;
      }
      
      // Prepare the payload according to backend CreateVehicleResource
      final payload = {
        'driverId': driverId,
        'licensePlate': vehicleData['licensePlate'],
        'brand': vehicleData['brand'] ?? vehicleData['make'],  // Support both 'brand' and 'make'
        'model': vehicleData['model'],
      };
      
      print('🚗 Creating vehicle with payload: $payload');
      
      final response = await _apiService.post(
        '/vehicles',
        payload,
      );
      
      print('🚗 Create vehicle response: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Vehicle created successfully, clear cache to force refresh
        _isLoaded = false;
        _cachedVehicles = [];
        print('🚗 Vehicle created successfully, cache cleared');
        return true;
      } else {
        print('Error creating vehicle: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception creating vehicle: $e');
      return false;
    }
  }
  
  /// Update vehicle (placeholder for future implementation)
  Future<bool> updateVehicle(String id, Map<String, dynamic> updatedVehicle) async {
    // TODO: Implement PUT to /vehicles/{vehicleId}
    print('Update vehicle not yet implemented');
    return false;
  }
  
  /// Delete vehicle (placeholder for future implementation)
  Future<bool> deleteVehicle(String id) async {
    // TODO: Implement DELETE to /vehicles/{vehicleId}
    print('Delete vehicle not yet implemented');
    return false;
  }
}

