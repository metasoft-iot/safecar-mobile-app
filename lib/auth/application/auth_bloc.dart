import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/user.entity.dart';
import '../infrastructure/api/auth_api.dart';
import '../infrastructure/assemblers/user_assembler.dart';
import '../../core/infrastructure/api_service.dart';
import 'auth_events.dart';
import 'auth_states.dart';

/// Store for managing authentication state.
/// This is the single BLoC/Store for the Auth bounded context.
/// It follows the pattern of the Angular LearningStore but using BLoC for state management.
class AuthStore extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;
  final AuthApi _authApi;
  final UserAssembler _userAssembler;

  AuthStore({
    ApiService? apiService,
    AuthApi? authApi,
    UserAssembler? userAssembler,
  })  : _apiService = apiService ?? ApiService(),
        _authApi = authApi ?? AuthApi(apiService ?? ApiService()),
        _userAssembler = userAssembler ?? UserAssembler(),
        super(const AuthInitial()) {
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
      final email = await _apiService.getUserEmail();

      if (token != null && userId != null) {
        // Create user from stored data
        final user = User(
          id: userId,
          username: email ?? 'user',
          email: email ?? '',
          roles: ['ROLE_DRIVER'],
        );
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      print('[AuthStore] Error initializing: $e');
      emit(const AuthUnauthenticated());
    }
  }

  /// Sign in with email and password
  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // Call API to sign in
      final signInResponse = await _authApi.signIn(event.email, event.password);
      
      // Store token and user data
      await _apiService.storeToken(signInResponse.auth.token);
      await _apiService.storeUserId(signInResponse.auth.id);
      await _apiService.storeUserEmail(event.email);

      // Try to fetch and store driver ID
      await _fetchAndStoreDriverId(event.email);

      // Convert to domain entity
      final user = _userAssembler.toEntityFromResourceWithEmail(
        signInResponse.auth,
        event.email,
      );

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      print('[AuthStore] Error signing in: $e');
      emit(AuthError(message: 'Incorrect email or password'));
    }
  }

  /// Fetch and store driver ID from profile
  Future<void> _fetchAndStoreDriverId(String email) async {
    try {
      print('[AuthStore] 🔍 Starting to fetch driver ID for email: $email');
      
      // Get person profile
      final profile = await _authApi.getPersonProfileByEmail(email);
      print('[AuthStore] ✅ Profile found - ID: ${profile.profileId}, Email: ${profile.email}');

      // Get driver with retry logic
      print('[AuthStore] 🔍 Fetching driver for profile ID: ${profile.profileId}');
      final driver = await _authApi.getDriverByProfileId(profile.profileId);

      if (driver != null) {
        print('[AuthStore] ✅ Driver found - ID: ${driver.driverId}');
        await _apiService.storeDriverId(driver.driverId);
        
        // Verify it was stored
        final storedDriverId = await _apiService.getDriverId();
        print('[AuthStore] ✅ Driver ID stored and verified: $storedDriverId');
      } else {
        print('[AuthStore] ❌ Driver is NULL - not found for profile ${profile.profileId}');
      }
    } catch (e, stackTrace) {
      print('[AuthStore] ❌ ERROR fetching driver ID: $e');
      print('[AuthStore] ❌ Stack trace: $stackTrace');
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
      await _authApi.signUp(
        email: event.email,
        password: event.password,
        roles: ['ROLE_DRIVER'],
      );

      // Step 2: Create PersonProfile
      final fullName = '${event.firstName} ${event.lastName}';
      await _authApi.createPersonProfile(
        userEmail: event.email,
        fullName: fullName,
        phone: event.phoneNumber,
      );

      // Step 3: Sign in automatically
      // The Driver will be created automatically by the DeviceProfileCreatedEventHandler
      add(AuthSignInRequested(
        email: event.email,
        password: event.password,
      ));
    } catch (e) {
      print('[AuthStore] Error signing up: $e');
      emit(AuthError(message: 'Error signing up: ${e.toString()}'));
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

