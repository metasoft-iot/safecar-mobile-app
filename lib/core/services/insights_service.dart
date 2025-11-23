import 'dart:convert';
import 'api_service.dart';

/// Service for managing vehicle insights from the backend
class InsightsService {
  static final InsightsService _instance = InsightsService._internal();
  
  factory InsightsService() {
    return _instance;
  }
  
  InsightsService._internal();
  
  final _apiService = ApiService();
  
  /// Get insights for a specific vehicle
  Future<Map<String, dynamic>?> getVehicleInsights(int vehicleId) async {
    try {
      print('🔍 Fetching insights for vehicle ID: $vehicleId');
      final response = await _apiService.get(
        '/insights/vehicle/$vehicleId'
      );
      
      print('🔍 Insights response status: ${response.statusCode}');
      print('🔍 Insights response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Insights loaded for vehicle $vehicleId');
        return data;
      } else if (response.statusCode == 404) {
        print('ℹ️ No insights found for vehicle $vehicleId');
        return null;
      } else {
        print('❌ Error loading insights: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception loading insights: $e');
      return null;
    }
  }
  
  /// Generate insights for a specific telemetry record
  Future<Map<String, dynamic>?> generateInsights(int telemetryId) async {
    try {
      print('🔄 Generating insights for telemetry ID: $telemetryId');
      final response = await _apiService.post(
        '/insights/generate/$telemetryId',
        {},
      );
      
      print('🔄 Generate insights response status: ${response.statusCode}');
      print('🔄 Generate insights response body: ${response.body}');
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Insights generated successfully for telemetry $telemetryId');
        return data;
      } else {
        print('❌ Error generating insights: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception generating insights: $e');
      return null;
    }
  }
  
  /// Get recent telemetry records for a vehicle
  Future<List<Map<String, dynamic>>> getRecentTelemetry(int vehicleId, {int limit = 5}) async {
    try {
      print('📡 Fetching recent telemetry for vehicle ID: $vehicleId');
      
      final url = '/telemetry?vehicleId=$vehicleId';
      print('📡 Telemetry URL: $url');
      
      final response = await _apiService.get(url);
      
      print('📡 Telemetry response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('📡 Found ${data.length} telemetry records');
        
        // Return only the most recent 'limit' records
        final recentRecords = data.take(limit).map((record) => record as Map<String, dynamic>).toList();
        return recentRecords;
      } else {
        print('❌ Error fetching telemetry: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception fetching telemetry: $e');
      return [];
    }
  }

  /// Get latest telemetry for a vehicle (to generate insights from)
  Future<int?> getLatestTelemetryId(int vehicleId) async {
    try {
      print('📡 Fetching latest telemetry for vehicle ID: $vehicleId');
      
      // Get all telemetry for the vehicle (backend returns most recent first)
      final url = '/telemetry?vehicleId=$vehicleId';
      print('📡 Telemetry URL: $url');
      
      final response = await _apiService.get(url);
      
      print('📡 Telemetry response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        print('📡 Found ${data.length} telemetry records');
        
        if (data.isNotEmpty) {
          // Get the first record (most recent, since backend orders by ingestedAt DESC)
          final latestTelemetry = data.first;
          final telemetryId = latestTelemetry['id'];
          print('✅ Latest telemetry ID: $telemetryId');
          return telemetryId;
        } else {
          print('ℹ️ No telemetry records found for vehicle $vehicleId');
          return null;
        }
      } else {
        print('❌ Error fetching telemetry: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception fetching telemetry: $e');
      return null;
    }
  }
}

