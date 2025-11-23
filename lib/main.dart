import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/application/auth_bloc.dart';
import 'features/auth/application/auth_event.dart';
import 'features/appointments/application/appointments_bloc.dart';
import 'features/auth/presentation/screens/sign_in_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() {
  runApp(const SafeCarApp());
}

class SafeCarApp extends StatelessWidget {
  const SafeCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(const AuthInitializeRequested()),
        ),
        BlocProvider(
          create: (context) => AppointmentsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'SafeCar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF4A60D0),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A60D0),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF4A60D0),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A60D0),
              foregroundColor: Colors.white,
              elevation: 2,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/sign-in',
        routes: {
          '/sign-in': (context) => const SignInScreen(),
          '/sign-up': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
