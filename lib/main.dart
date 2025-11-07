import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safecar_mobile_app/src/core/router/app_router.dart';
import 'package:safecar_mobile_app/src/iam/domain/repositories/auth_repository.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_bloc.dart';
import 'package:safecar_mobile_app/src/iam/application/services/session_service.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/login_use_case.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/logout_use_case.dart';
import 'package:safecar_mobile_app/src/iam/application/use_cases/register_use_case.dart';
import 'package:safecar_mobile_app/src/iam/infrastructure/config/dio_client.dart'; // Asegúrate que esta ruta sea correcta
import 'package:safecar_mobile_app/src/iam/infrastructure/datasources/auth_remote_datasource.dart';
import 'package:safecar_mobile_app/src/iam/infrastructure/repositories/auth_repository_impl.dart';

void main() {
  // Opcional: inicializar bindings si haces algo async antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 1. PROVEER LOS REPOSITORIOS (Y SUS DEPENDENCIAS)
    return MultiRepositoryProvider(
      providers: [

        // Proveemos la implementación de AuthRepository
        RepositoryProvider<AuthRepository>(
          create: (context) {
            // Aquí instanciamos toda la cadena de dependencias
            final dio = DioClient().dio; // Tu instancia de Dio
            final dataSource = AuthRemoteDataSource(dio);
            final sessionService = SessionService();

            return AuthRepositoryImpl(
              remoteDataSource: dataSource,
              sessionService: sessionService,
            );
          },
        ),

        // ... aquí podrías proveer otros repositorios (ej. VehicleRepository)

      ],

      // 2. PROVEER LOS BLOCS
      child: MultiBlocProvider(
        providers: [

          BlocProvider<AuthBloc>(
            create: (context) {
              // Pedimos el AuthRepository al contexto
              final authRepository = context.read<AuthRepository>();

              // Creamos los Casos de Uso pasándole el repositorio
              final loginUseCase = LoginUseCase(authRepository);
              final registerUseCase = RegisterUseCase(authRepository);
              final logoutUseCase = LogoutUseCase(authRepository);

              // Creamos el BLoC
              return AuthBloc(
                loginUseCase: loginUseCase,
                registerUseCase: registerUseCase,
                logoutUseCase: logoutUseCase,
              );
              // ..add(CheckInitialAuthStatus());
            },
          ),

          // ... aquí proveerías otros BLoCs (ProfileBloc, etc.)

        ],
        child: const MainApp(), // 3. Tu aplicación (que ahora está adentro)
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