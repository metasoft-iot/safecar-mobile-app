import 'dart:convert';
import 'api_service.dart';
import '../constants/api_constants.dart';

/// Service to manage workshop data from the backend
class WorkshopService {
  static final WorkshopService _instance = WorkshopService._internal();
  
  factory WorkshopService() {
    return _instance;
  }
  
  WorkshopService._internal();
  
  final _apiService = ApiService();
  
  /// Get all workshops from backend
  Future<List<Map<String, dynamic>>> getWorkshops() async {
    try {
      print('🏪 Fetching workshops');
      final response = await _apiService.get(ApiConstants.workshops);
      
      print('🏪 Workshop response status: ${response.statusCode}');
      print('🏪 Workshop response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('🏪 Parsed ${data.length} workshops');
        
        return data.map((workshop) {
          return {
            'id': workshop['id'].toString(),
            'businessProfileId': workshop['businessProfileId']?.toString() ?? '',
            'description': workshop['workshopDescription'] ?? 'Workshop',
            'totalMechanics': workshop['totalMechanics'] ?? 0,
          };
        }).toList();
      } else {
        print('🏪 Error loading workshops: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('🏪 Exception loading workshops: $e');
      return [];
    }
  }
  
  /// Get workshop by ID
  Future<Map<String, dynamic>?> getWorkshopById(int workshopId) async {
    try {
      final response = await _apiService.get(ApiConstants.workshopById(workshopId));
      
      if (response.statusCode == 200) {
        final workshop = jsonDecode(response.body);
        return {
          'id': workshop['id'].toString(),
          'businessProfileId': workshop['businessProfileId']?.toString() ?? '',
          'description': workshop['workshopDescription'] ?? 'Workshop',
          'totalMechanics': workshop['totalMechanics'] ?? 0,
        };
      }
      return null;
    } catch (e) {
      print('Error getting workshop by ID: $e');
      return null;
    }
  }
}

