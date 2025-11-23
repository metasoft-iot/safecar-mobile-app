import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for managing authentication state
/// This is the single BLoC for the Auth bounded context
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService = ApiService();

  AuthBloc() : super(const AuthInitial()) {
    on<AuthInitializeRequested>(_onInitializeRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  /// Initialize authentication state from stored token
  Future<void> _onInitializeRequested(
    AuthInitializeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final token = await _apiService.getToken();
      final userId = await _apiService.getUserId();

      if (token != null && userId != null) {
        // TODO: Verify token is still valid by fetching user profile
        // For now, we assume it's valid
        final user = UserModel(
          id: userId,
          username: 'user', // TODO: Fetch from API
          email: '',
          roles: ['ROLE_DRIVER'],
        );
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Sign in with username and password
  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _apiService.post(
        ApiConstants.authSignIn,
        {
          'email': event.username, // Backend uses email for sign in
          'password': event.password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);

        // Store token, user ID, and email
        await _apiService.storeToken(authResponse.token);
        await _apiService.storeUserId(authResponse.id);
        await _apiService.storeUserEmail(event.username);
        
        // Try to get and store driver ID
        await _fetchAndStoreDriverId(event.username);

        final user = UserModel(
          id: authResponse.id,
          username: authResponse.username,
          email: event.username,
          roles: ['ROLE_DRIVER'],
        );

        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Usuario o contraseña incorrectos'));
      }
    } catch (e) {
      emit(AuthError(message: 'Error al iniciar sesión: ${e.toString()}'));
    }
  }
  
  /// Fetch and store driver ID from profile
  Future<void> _fetchAndStoreDriverId(String email) async {
    try {
      print('[AuthBloc] 🔍 Fetching profile for email: $email');
      
      // First get the person profile
      final profileResponse = await _apiService.get(
        ApiConstants.personProfileByEmail(email),
      );
      
      print('[AuthBloc] Profile response status: ${profileResponse.statusCode}');
      print('[AuthBloc] Profile response body: ${profileResponse.body}');
      
      if (profileResponse.statusCode == 200) {
        // The endpoint returns a single object, not a list
        final Map<String, dynamic> profile = jsonDecode(profileResponse.body);
        print('[AuthBloc] Parsed profile: $profile');
        
        // The backend returns 'profileId', not 'id'
        final profileId = profile['profileId'];
        print('[AuthBloc] Profile ID extracted: $profileId');
        
        if (profileId == null) {
          print('[AuthBloc] ERROR: profileId is null! Cannot fetch driver.');
          return;
        }
        
        // Now get the driver using the new endpoint
        // Retry up to 5 times with delays because driver creation is async
        int retries = 5;
        int? driverId;
        
        for (int i = 0; i < retries; i++) {
          if (i > 0) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
            print('Retrying to fetch driver... Attempt ${i + 1}');
          }
          
          final driverResponse = await _apiService.get(
            ApiConstants.driverByProfileId(profileId),
          );
          
          if (driverResponse.statusCode == 200) {
            final driverData = jsonDecode(driverResponse.body);
            driverId = driverData['driverId'] as int;
            await _apiService.storeDriverId(driverId);
            print('Driver ID $driverId stored successfully');
            break;
          } else if (driverResponse.statusCode == 404) {
            print('Driver not found yet for profile ID $profileId (attempt ${i + 1}/$retries)');
            if (i == retries - 1) {
              print('Driver not created after $retries attempts. User may need to wait a moment.');
            }
          } else {
            print('Error fetching driver: ${driverResponse.statusCode}');
            break;
          }
        }
      }
    } catch (e) {
      print('Error fetching driver ID: $e');
      // Continue anyway, driver ID might not be needed immediately
    }
  }

  /// Sign up as a new driver
  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Step 1: Sign up user in IAM
      final signUpResponse = await _apiService.post(
        ApiConstants.authSignUp,
        {
          'email': event.email,
          'password': event.password,
          'confirmPassword': event.password,
          'roles': ['ROLE_DRIVER'],
        },
      );

      if (signUpResponse.statusCode == 201 || signUpResponse.statusCode == 200) {
        // Step 2: Create PersonProfile
        final fullName = '${event.firstName} ${event.lastName}';
        
        final profileResponse = await _apiService.post(
          '${ApiConstants.personProfiles}?userEmail=${event.email}',
          {
            'fullName': fullName,
            'city': 'Lima', // Default value, can be updated later
            'country': 'Peru', // Default value, can be updated later
            'phone': event.phoneNumber,
            'dni': '00000000', // Default value, can be updated later
          },
        );

        if (profileResponse.statusCode == 201 || profileResponse.statusCode == 200) {
          // Step 3: Sign in automatically
          // The Driver will be created automatically by the DeviceProfileCreatedEventHandler
          add(AuthSignInRequested(
            username: event.email,
            password: event.password,
          ));
        } else {
          emit(const AuthError(message: 'Error al crear el perfil'));
        }
      } else {
        final errorBody = signUpResponse.body;
        emit(AuthError(message: 'Error al crear la cuenta: $errorBody'));
      }
    } catch (e) {
      emit(AuthError(message: 'Error al registrarse: ${e.toString()}'));
    }
  }

  /// Sign out
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _apiService.clearAll();
    emit(const AuthUnauthenticated());
  }

  /// Clear error message
  void _onErrorCleared(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }
}

