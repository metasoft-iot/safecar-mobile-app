// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import 'package:safecar_mobile_app/iam/presentation/pages/login_screen.dart';
import 'package:safecar_mobile_app/iam/presentation/pages/register_screen.dart';

// Layout + bottom bar
import 'package:safecar_mobile_app/shared/presentation/pages/main_layout.dart';

// Vehicles
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicles_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicle_details_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/add_vehicle_page.dart';
import 'package:safecar_mobile_app/vehicle_management/vehicle_routes.dart';

// Insights (STATUS TAB)
import 'package:safecar_mobile_app/insights/presentation/views/vehicle_insights_page.dart';

// Workshop / Appointment
import 'package:safecar_mobile_app/workshop/presentation/views/appointments/appointment_page.dart';

// Rutas / constantes
import 'package:safecar_mobile_app/router/route_constants.dart';

/// Router global de la app
final GoRouter appRouter = GoRouter(
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

    // ---------- SHELL PRINCIPAL CON BOTTOM NAV ----------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainLayout(navigationShell: navigationShell),

      branches: [
        // ===== TAB 0: VEHICLES =====
        StatefulShellBranch(
          routes: [
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

                // (Opcional) Editar vehículo -> /vehicles/:id/edit
                // GoRoute(
                //   path: ':id/edit',
                //   name: VehicleRouteNames.vehicleEdit,
                //   builder: (context, state) =>
                //       EditVehiclePage(vehicleId: state.pathParameters['id']!),
                // ),
              ],
            ),
          ],
        ),

        // ===== TAB 1: STATUS (INSIGHTS) =====
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.status, // '/status'
              builder: (context, state) => const VehicleInsightsPage(),
            ),
          ],
        ),

        // ===== TAB 2: APPOINTMENT (WORKSHOP) =====
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.workshop, // '/workshop'
              builder: (context, state) => const AppointmentPage(),
              // Aquí luego puedes anidar create / details / reschedule
            ),
          ],
        ),

        // ===== TAB 3: DASHBOARD =====
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard, // '/dashboard'
              builder: (context, state) => const _DashboardPlaceholder(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Pantalla placeholder para el Dashboard (cámbiala por tu vista real)
class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Dashboard (coming soon)')),
    );
  }
}
