import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safecar_mobile_app/router/app_router.dart';
import 'package:safecar_mobile_app/shared/theme/app_theme.dart';

import 'iam/application/blocs/auth_bloc.dart';
import 'iam/application/services/session_service.dart';
import 'iam/application/use_cases/login_use_case.dart';
import 'iam/application/use_cases/logout_use_case.dart';
import 'iam/application/use_cases/register_use_case.dart';
import 'iam/domain/repositories/auth_repository.dart';
import 'iam/infrastructure/config/dio_client.dart';
import 'iam/infrastructure/datasources/auth_remote_datasource.dart';
import 'iam/infrastructure/datasources/profile_remote_datasource.dart';
import 'iam/infrastructure/repositories/auth_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) {

            final dio = DioClient().dio;
            final sessionService = SessionService();

            final authDataSource = AuthRemoteDataSource(dio);
            final profileDataSource =  ProfileRemoteDataSource(dio); // <-- Nuevo

            return AuthRepositoryImpl(
              authRemoteDataSource: authDataSource,
              profileRemoteDataSource: profileDataSource, // <-- Nuevo
              sessionService: sessionService,
            );
          },
        ),
        // ... (otros repositorios)
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final authRepository = context.read<AuthRepository>();

              // Esto no cambia, BLoC no necesita saber sobre los datasources
              return AuthBloc(
                loginUseCase: LoginUseCase(authRepository),
                registerUseCase: RegisterUseCase(authRepository),
                logoutUseCase: LogoutUseCase(authRepository),
              );
            },
          ),
          // ... (otros blocs)
        ],
        child: const MainApp(),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Obtenemos la instancia del AppRouter, que ahora puede
    // acceder al AuthBloc que proveímos arriba
    final appRouter = AppRouter(context.read<AuthBloc>());

    return MaterialApp.router(
      routerConfig: appRouter.router,
      title: 'SafeCar',
      debugShowCheckedModeBanner: false,
    );
  }
}