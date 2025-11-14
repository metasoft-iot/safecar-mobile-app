import 'package:go_router/go_router.dart';

// Auth
import 'package:safecar_mobile_app/iam/presentation/pages/login_screen.dart';
import 'package:safecar_mobile_app/iam/presentation/pages/register_screen.dart';

// Vehicles
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicles_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicle_details_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/add_vehicle_page.dart';

// Rutas / constantes
import 'package:safecar_mobile_app/router/route_constants.dart';
import 'package:safecar_mobile_app/vehicle_management/vehicle_routes.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // ---------- AUTH ----------
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // ---------- VEHICLES ----------
    GoRoute(
      path: AppRoutes.vehicles, // '/vehicles'
      builder: (context, state) => const VehiclesPage(),
      routes: [
        // Detalle de vehículo  -> /vehicles/:id
        GoRoute(
          path: ':id',
          name: VehicleRouteNames.vehicleDetails,
          builder: (context, state) =>
              VehicleDetailsPage(vehicleId: state.pathParameters['id']!),
        ),

        // Crear vehículo -> /vehicles/add
        GoRoute(
          path: 'add',
          name: VehicleRouteNames.vehicleAdd,
          builder: (context, state) => const AddVehiclePage(),
        ),

        // 👇 Aquí más adelante podemos añadir la ruta de edición
        // GoRoute(
        //   path: ':id/edit',
        //   name: VehicleRouteNames.vehicleEdit,
        //   builder: (context, state) => EditVehiclePage(...),
        // ),
      ],
    ),

    // 👇 Falta conectar Status, Workshop y Dashboard.
    // Cuando me pases las pantallas correspondientes (p.ej. MainLayout,
    // VehicleInsightsPage, AppointmentPage, etc.) las añadimos aquí.
  ],
);
