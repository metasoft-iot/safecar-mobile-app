import 'dart:convert';
import '../../../core/infrastructure/api_service.dart';
import '../resources/insights_response.dart';

/// API service for vehicle insights and telemetry operations.
/// Handles all HTTP requests related to insights and telemetry.
class InsightsApi {
  final ApiService _apiService;

  InsightsApi(this._apiService);

  /// Get insights for a specific vehicle
  Future<VehicleInsightResource?> getVehicleInsights(int vehicleId) async {
    print('[InsightsApi] 🔍 Fetching insights for vehicle ID: $vehicleId');
    
    final response = await _apiService.get(
      '/insights/vehicle/$vehicleId',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('[InsightsApi] ✅ Insights loaded for vehicle $vehicleId');
      return VehicleInsightResource.fromJson(data);
    } else if (response.statusCode == 404) {
      print('[InsightsApi] ℹ️ No insights found for vehicle $vehicleId');
      return null;
    } else {
      throw Exception('Failed to load insights: ${response.statusCode}');
    }
  }

  /// Generate insights for a specific telemetry record
  Future<VehicleInsightResource> generateInsights(int telemetryId) async {
    print('[InsightsApi] 🔄 Generating insights for telemetry ID: $telemetryId');
    
    final response = await _apiService.post(
      '/insights/generate/$telemetryId',
      {},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('[InsightsApi] ✅ Insights generated successfully');
      return VehicleInsightResource.fromJson(data);
    } else {
      throw Exception('Failed to generate insights: ${response.statusCode} - ${response.body}');
    }
  }

  /// Get recent telemetry records for a vehicle
  Future<TelemetryResponse> getRecentTelemetry(int vehicleId, {int limit = 5}) async {
    print('[InsightsApi] 📡 Fetching recent telemetry for vehicle ID: $vehicleId');
    
    final response = await _apiService.get(
      '/telemetry?vehicleId=$vehicleId',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('[InsightsApi] 📡 Found ${data.length} telemetry records');
      
      // Take only the most recent 'limit' records
      final recentData = data.take(limit).toList();
      return TelemetryResponse.fromJson(recentData);
    } else {
      throw Exception('Failed to load telemetry: ${response.statusCode}');
    }
  }

  /// Get the latest telemetry ID for a vehicle (to generate insights from)
  Future<int?> getLatestTelemetryId(int vehicleId) async {
    print('[InsightsApi] 📡 Fetching latest telemetry for vehicle ID: $vehicleId');
    
    final response = await _apiService.get(
      '/telemetry?vehicleId=$vehicleId',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      
      if (data.isNotEmpty) {
        final latestTelemetry = data.first as Map<String, dynamic>;
        
        // Handle both int and double types that might come from JSON
        final idValue = latestTelemetry['id'];
        final telemetryId = idValue is int ? idValue : (idValue as num).toInt();
        
        print('[InsightsApi] ✅ Latest telemetry ID: $telemetryId');
        return telemetryId;
      } else {
        print('[InsightsApi] ℹ️ No telemetry records found for vehicle $vehicleId');
        return null;
      }
    } else {
      throw Exception('Failed to load telemetry: ${response.statusCode}');
    }
  }
}

