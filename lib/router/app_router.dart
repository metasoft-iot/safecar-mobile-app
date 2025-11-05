
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/screens/add_vehicle/add_vehicle_screen.dart';
import 'package:safecar_mobile_app/screens/dashboard/dashboard_screen.dart';
import 'package:safecar_mobile_app/screens/login/login_screen.dart';
import 'package:safecar_mobile_app/screens/my_vehicles/my_vehicles_screen.dart';
import 'package:safecar_mobile_app/screens/register/register_screen.dart';
import 'package:safecar_mobile_app/screens/vehicle_details/vehicle_details_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/vehicles',
      builder: (context, state) => const MyVehiclesScreen(),
    ),
    GoRoute(
      path: '/vehicles/:id',
      builder: (context, state) => const VehicleDetailsScreen(),
    ),
    GoRoute(
      path: '/add-vehicle',
      builder: (context, state) => const AddVehicleScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
