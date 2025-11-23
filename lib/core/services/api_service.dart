import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Service for making HTTP requests to the SafeCar backend API
class ApiService {
  final http.Client _client = http.Client();
  
  /// Get authorization header with stored token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  /// Make a GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    try {
      final response = await _client.get(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Make a POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    try {
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Make a PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    try {
      final response = await _client.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Make a DELETE request
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders();
    
    try {
      final response = await _client.delete(url, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  /// Store authentication token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  /// Get stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  /// Clear authentication token
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  /// Store user ID
  Future<void> storeUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }
  
  /// Get stored user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
  
  /// Store driver ID
  Future<void> storeDriverId(int driverId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('driver_id', driverId);
  }
  
  /// Get stored driver ID
  Future<int?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('driver_id');
  }
  
  /// Get driver ID with fallback to fetch from backend if not cached
  Future<int?> getDriverIdWithFallback() async {
    // Try to get from storage first
    int? driverId = await getDriverId();
    
    if (driverId != null && driverId > 0) {
      return driverId;
    }
    
    // If not found, fetch from backend with retries
    try {
      final email = await getUserEmail();
      if (email == null) {
        print('No email found in storage');
        return null;
      }
      
      print('🔍 Looking for profile with email: $email');
      
      // Get profile by email (returns a single object, not a list)
      final profileResponse = await get('/person-profiles?userEmail=$email');
      
      print('Profile response status: ${profileResponse.statusCode}');
      print('Profile response body: ${profileResponse.body}');
      
      if (profileResponse.statusCode == 200) {
        final Map<String, dynamic> profile = jsonDecode(profileResponse.body);
        print('Parsed profile: $profile');
        
        // The backend returns 'profileId', not 'id'
        final profileId = profile['profileId'];
        print('Profile ID extracted: $profileId');
        
        if (profileId == null) {
          print('ERROR: profileId is null! Cannot fetch driver.');
          return null;
        }
        
        // Retry to get driver (it might be created asynchronously)
        int retries = 5;
        
        for (int i = 0; i < retries; i++) {
          if (i > 0) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: 300 * (i + 1)));
            print('Retrying to fetch driver ID... Attempt ${i + 1}/$retries');
          }
          
          // Get driver by profileId
          final driverResponse = await get('/profiles/$profileId/driver');
          
          if (driverResponse.statusCode == 200) {
            final driverData = jsonDecode(driverResponse.body);
            driverId = driverData['driverId'];
            await storeDriverId(driverId!);
            print('Driver ID $driverId fetched and stored');
            return driverId;
          } else if (driverResponse.statusCode == 404 && i < retries - 1) {
            print('Driver not found yet (attempt ${i + 1}/$retries), waiting...');
            continue;
          }
        }
        
        // If still not found after all retries
        print('Driver not found after $retries attempts. Attempting manual creation...');
        
        // Last resort: Try to create driver manually
        try {
          final createResponse = await post('/profiles/$profileId/driver', {});
          
          if (createResponse.statusCode == 201) {
            final driverData = jsonDecode(createResponse.body);
            driverId = driverData['driverId'];
            await storeDriverId(driverId!);
            print('Driver ID $driverId created manually and stored');
            return driverId;
          } else if (createResponse.statusCode == 409) {
            // Driver was created between retries, try one more time to get it
            print('Driver already exists (409), fetching again...');
            await Future.delayed(const Duration(milliseconds: 500));
            final retryResponse = await get('/profiles/$profileId/driver');
            if (retryResponse.statusCode == 200) {
              final driverData = jsonDecode(retryResponse.body);
              driverId = driverData['driverId'];
              await storeDriverId(driverId!);
              print('Driver ID $driverId fetched after manual creation attempt');
              return driverId;
            }
          } else {
            print('Failed to create driver manually: ${createResponse.statusCode}');
          }
        } catch (e) {
          print('Error creating driver manually: $e');
        }
      }
    } catch (e) {
      print('Error fetching driver ID: $e');
    }
    
    return null;
  }
  
  /// Store user email
  Future<void> storeUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }
  
  /// Get stored user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
  
  /// Clear all stored data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

