import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/router/route_constants.dart';
import 'package:safecar_mobile_app/shared/pages/not_found_page.dart';
import 'package:safecar_mobile_app/shared/widgets/main_layout.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

//  Workshop
import 'package:safecar_mobile_app/workshop/presentation/views/appointments/appointment_details_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/views/appointments/appointment_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/views/appointments/create_appointment_page.dart';
import 'package:safecar_mobile_app/workshop/presentation/views/appointments/reschedule_appointment_page.dart';

//  Vehicle Management
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicles_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/add_vehicle_page.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/view/vehicle_details_page.dart';
import 'package:safecar_mobile_app/vehicle_management/vehicle_routes.dart';

/// Main router configuration for SafeCar Mobile App
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.workshop,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        // 🚗 Branch 1: Vehicle Management
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: VehiclePaths.vehicles,                // '/vehicles'
              name: VehicleRouteNames.vehicles,           // 'vehicles'
              builder: (context, state) => const VehiclesPage(),
              routes: [
                GoRoute(
                  path: VehiclePaths.vehicleAdd,          // 'add' -> '/vehicles/add'
                  name: VehicleRouteNames.vehicleAdd,     // 'vehicle-add'
                  builder: (context, state) => const AddVehiclePage(),
                ),
                GoRoute(
                  path: VehiclePaths.vehicleDetails,      // ':id' -> '/vehicles/:id'
                  name: VehicleRouteNames.vehicleDetails, // 'vehicle-details'
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return VehicleDetailsPage(vehicleId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // 📋 Branch 2: Status
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.status,
              builder: (context, state) => _PlaceholderPage(
                title: 'Status',
                icon: Icons.format_list_bulleted,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),

        // 🛠️ Branch 3: Workshop (Appointments)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.workshop,
              builder: (context, state) => const AppointmentPage(),
              routes: [
                GoRoute(
                  path: RoutePaths.workshopDetails,
                  name: RouteNames.workshopDetails,
                  builder: (context, state) {
                    final appointmentId = state.pathParameters['id']!;
                    return AppointmentDetailsPage(appointmentId: appointmentId);
                  },
                ),
                GoRoute(
                  path: RoutePaths.createWorkshop,
                  name: RouteNames.createWorkshop,
                  builder: (context, state) => const CreateAppointmentPage(),
                ),
                GoRoute(
                  path: RoutePaths.rescheduleWorkshop,
                  name: RouteNames.rescheduleWorkshop,
                  builder: (context, state) {
                    final appointmentId = state.pathParameters['id']!;
                    return RescheduleAppointmentPage(appointmentId: appointmentId);
                  },
                ),
              ],
            ),
          ],
        ),

        // 📊 Branch 4: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => _PlaceholderPage(
                title: 'Dashboard',
                icon: Icons.dashboard,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Placeholder page for unimplemented sections
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: AppColors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
