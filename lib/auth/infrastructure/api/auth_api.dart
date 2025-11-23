import 'dart:convert';
import '../../../core/infrastructure/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../resources/auth_response.dart';

/// API service for authentication operations.
/// Handles all HTTP requests related to authentication.
class AuthApi {
  final ApiService _apiService;

  AuthApi(this._apiService);

  /// Sign in with email and password
  Future<SignInResponse> signIn(String email, String password) async {
    print('[AuthApi] 🔐 Signing in with email: $email');
    
    final response = await _apiService.post(
      ApiConstants.authSignIn,
      {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SignInResponse.fromJson(data);
    } else {
      throw Exception('Failed to sign in: ${response.statusCode}');
    }
  }

  /// Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required List<String> roles,
  }) async {
    print('[AuthApi] 📝 Signing up new user with email: $email');
    
    final response = await _apiService.post(
      ApiConstants.authSignUp,
      {
        'email': email,
        'password': password,
        'confirmPassword': password,
        'roles': roles,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  /// Create a person profile
  Future<PersonProfileResource> createPersonProfile({
    required String userEmail,
    required String fullName,
    required String phone,
    String city = 'Lima',
    String country = 'Peru',
    String dni = '00000000',
  }) async {
    print('[AuthApi] 👤 Creating person profile for: $userEmail');
    
    final response = await _apiService.post(
      '${ApiConstants.personProfiles}?userEmail=$userEmail',
      {
        'fullName': fullName,
        'city': city,
        'country': country,
        'phone': phone,
        'dni': dni,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return PersonProfileResource.fromJson(data);
    } else {
      throw Exception('Failed to create person profile: ${response.statusCode}');
    }
  }

  /// Get person profile by email
  Future<PersonProfileResource> getPersonProfileByEmail(String email) async {
    print('[AuthApi] 🔍 Fetching profile for email: $email');
    
    final response = await _apiService.get(
      ApiConstants.personProfileByEmail(email),
    );

    print('[AuthApi] 📥 Profile response status: ${response.statusCode}');
    print('[AuthApi] 📥 Profile response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final profile = PersonProfileResource.fromJson(data);
      print('[AuthApi] ✅ Profile parsed: ID=${profile.profileId}, Email=${profile.email}');
      return profile;
    } else {
      print('[AuthApi] ❌ Failed to get profile: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to get person profile: ${response.statusCode}');
    }
  }

  /// Get driver by profile ID (with retry logic)
  Future<DriverResource?> getDriverByProfileId(int profileId, {int maxRetries = 5}) async {
    print('[AuthApi] 🚗 Fetching driver for profile ID: $profileId');
    
    for (int i = 0; i < maxRetries; i++) {
      if (i > 0) {
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        print('[AuthApi] 🔄 Retrying to fetch driver... Attempt ${i + 1}/$maxRetries');
      }

      final endpoint = ApiConstants.driverByProfileId(profileId);
      print('[AuthApi] 🌐 Calling endpoint: $endpoint');
      
      final response = await _apiService.get(endpoint);

      print('[AuthApi] 📥 Driver response status: ${response.statusCode}');
      print('[AuthApi] 📥 Driver response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final driver = DriverResource.fromJson(data);
        print('[AuthApi] ✅ Driver found: ID=${driver.driverId}');
        return driver;
      } else if (response.statusCode == 404) {
        print('[AuthApi] ⚠️ Driver not found yet (attempt ${i + 1}/$maxRetries)');
        if (i == maxRetries - 1) {
          print('[AuthApi] ❌ Driver not created after $maxRetries attempts');
          return null;
        }
      } else {
        print('[AuthApi] ❌ Unexpected status code: ${response.statusCode}');
        throw Exception('Failed to get driver: ${response.statusCode}');
      }
    }

    return null;
  }
}

