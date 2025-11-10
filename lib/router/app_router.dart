
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/features/insights/presentation/screens/vehicle_insight_screen.dart';
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
      path: '/status',
      builder: (context, state) {
        final idParam = state.uri.queryParameters['vehicleId'];
        final vehicleId = int.tryParse(idParam ?? '') ?? 1;
        return VehicleInsightScreen(vehicleId: vehicleId);
      },
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
