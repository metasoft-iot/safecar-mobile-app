import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core
import 'core/infrastructure/api_service.dart';

// Auth Bounded Context
import 'auth/application/auth_bloc.dart';
import 'auth/application/auth_events.dart';
import 'auth/presentation/screens/sign_in_screen.dart';
import 'auth/presentation/screens/sign_up_screen.dart';

// Vehicles Bounded Context
import 'vehicles/application/vehicles_bloc.dart';

// Workshops Bounded Context
import 'workshops/application/workshops_bloc.dart';

// Appointments Bounded Context
import 'appointments/application/appointments_bloc.dart';

// Dashboard Bounded Context
import 'dashboard/application/dashboard_bloc.dart';

// Home Screen (in core/presentation/screens)
import 'core/presentation/screens/home_screen.dart';

void main() {
  runApp(const SafeCarApp());
}

/// Main application widget with DDD architecture.
/// Each bounded context has its own store following the pattern.
class SafeCarApp extends StatelessWidget {
  const SafeCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create shared ApiService instance
    final apiService = ApiService();

    return MultiBlocProvider(
      providers: [
        // Auth Store - Global provider for authentication
        BlocProvider(
          create: (context) => AuthStore(apiService: apiService)
            ..add(const AuthInitializeRequested()),
        ),
        
        // Vehicles Store
        BlocProvider(
          create: (context) => VehiclesStore(apiService: apiService),
        ),
        
        // Workshops Store
        BlocProvider(
          create: (context) => WorkshopsStore(apiService: apiService),
        ),
        
        // Appointments Store
        BlocProvider(
          create: (context) => AppointmentsStore(apiService: apiService),
        ),
        
        // Dashboard Store
        BlocProvider(
          create: (context) => DashboardStore(),
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
