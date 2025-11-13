import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_event.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_state.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/login_use_case.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/register_use_case.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/logout_use_case.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(Unauthenticated()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final credentials = await _loginUseCase.call(event.email, event.password);
      emit(Authenticated(user: credentials.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  // --- ACTUALIZADO ---
  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _registerUseCase.call(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        roles: [event.role], // Pasa el rol como lista
        fullName: event.fullName,
        city: event.city,
        country: event.country,
        phone: event.phone,
        dni: event.dni,
      );
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _logoutUseCase.call();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}