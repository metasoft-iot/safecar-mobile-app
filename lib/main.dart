import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'router/app_router.dart';

// Bloc
import 'iam/application/blocs/auth_bloc.dart';

// Use cases
import 'iam/application/use_cases/login_use_case.dart';
import 'iam/application/use_cases/register_use_case.dart';
import 'iam/application/use_cases/logout_use_case.dart';

// Servicios
import 'iam/application/services/session_service.dart';

// Infraestructura
import 'iam/infrastructure/config/dio_client.dart';
import 'iam/infrastructure/datasources/auth_remote_datasource.dart';
import 'iam/infrastructure/datasources/profile_remote_datasource.dart';
import 'iam/infrastructure/repositories/auth_repository_impl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ----------------- INFRAESTRUCTURA -----------------

    // Cliente Dio “envuelto” en tu DioClient
    final dioClient = DioClient();
    final dio = dioClient.dio;

    // Data sources remotos (constructores posicionales)
    final authRemoteDataSource = AuthRemoteDataSource(dio);
    final profileRemoteDataSource = ProfileRemoteDataSource(dio);

    // Servicio de sesión
    final sessionService = SessionService();

    // Repositorio de Auth
    final authRepository = AuthRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      profileRemoteDataSource: profileRemoteDataSource,
      sessionService: sessionService,
    );

    // ----------------- USE CASES -----------------
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);

    // ----------------- APP -----------------
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(
        loginUseCase: loginUseCase,
        registerUseCase: registerUseCase,
        logoutUseCase: logoutUseCase,
      ),
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'SafeCar',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
