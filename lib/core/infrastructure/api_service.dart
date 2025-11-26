import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Core API service for making HTTP requests.
/// Handles authentication headers and base URL configuration.
class ApiService {
  /// Performs a GET request.
  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    print('[ApiService] 🌐 GET: $url');
    final response = await http.get(url, headers: headers);
    print('[ApiService] 📥 Response: ${response.statusCode}');
    
    return response;
  }

  /// Performs a POST request.
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    print('[ApiService] 🌐 POST: $url');
    print('[ApiService] 📤 Body: ${jsonEncode(body)}');
    
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    
    print('[ApiService] 📥 Response: ${response.statusCode}');
    return response;
  }

  /// Performs a PUT request.
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    print('[ApiService] 🌐 PUT: $url');
    print('[ApiService] 📤 Body: ${jsonEncode(body)}');
    
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    
    print('[ApiService] 📥 Response: ${response.statusCode}');
    return response;
  }

  /// Performs a DELETE request.
  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    print('[ApiService] 🌐 DELETE: $url');
    final response = await http.delete(url, headers: headers);
    print('[ApiService] 📥 Response: ${response.statusCode}');
    
    return response;
  }

  /// Gets headers with authentication token if available.
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
      print('[ApiService] 🔑 Token found');
    } else {
      print('[ApiService] ⚠️ No token found in SharedPreferences');
    }

    return headers;
  }

  // ===== Token and User Data Management =====

  /// Get stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Store authentication token
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Get stored user ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  /// Store user ID
  Future<void> storeUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  /// Get stored user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  /// Store user email
  Future<void> storeUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  /// Get stored driver ID
  Future<int?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    final driverId = prefs.getInt('driver_id');
    print('[ApiService] 🔍 Retrieved driver ID from storage: $driverId');
    return driverId;
  }

  /// Store driver ID
  Future<void> storeDriverId(int driverId) async {
    print('[ApiService] 💾 Storing driver ID: $driverId');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('driver_id', driverId);
    print('[ApiService] ✅ Driver ID stored successfully');
  }

  /// Get driver ID with fallback to profile lookup
  Future<int?> getDriverIdWithFallback() async {
    final driverId = await getDriverId();
    if (driverId != null) return driverId;

    // Fallback: try to fetch from profile
    try {
      final email = await getUserEmail();
      if (email == null) return null;

      // This is a simplified fallback; in a real scenario,
      // you might want to call the auth API to fetch and store the driver ID
      print('[ApiService] No cached driver ID, may need to fetch from profile');
      return null;
    } catch (e) {
      print('[ApiService] Error in fallback driver ID lookup: $e');
      return null;
    }
  }

  /// Clear stored authentication data, but preserve persistent settings
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    
    print('[ApiService] 🧹 Clearing session data...');
    // Explicitly remove only session-related keys
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('driver_id');
    
    // Note: We deliberately DO NOT remove 'selected_workshop_id_*' keys
    // to ensure the workshop selection persists across sessions.
    
    print('[ApiService] ✅ Session data cleared (persistent settings preserved)');
  }
}

