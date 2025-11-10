import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/core/shared/widgets/main_layout.dart';
import 'package:safecar_mobile_app/core/shared/pages/not_found_page.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/pages/appointment_page.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/pages/create_appointment_page.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/pages/appointment_details_page.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/pages/reschedule_appointment_page.dart';
import 'package:safecar_mobile_app/core/router/route_constants.dart';
import 'package:safecar_mobile_app/core/shared/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';

/// Global key for navigator
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Main router configuration for SafeCar Mobile App
/// Following Clean Architecture and DDD principles
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.appointment,
  debugLogDiagnostics: true,
  
  // Error page builder
  errorBuilder: (context, state) => const NotFoundPage(),
  
  routes: [
    /// Shell route for bottom navigation
    /// This keeps the bottom bar persistent across navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        // TODO: Vehicles feature - Implement following DDD structure
        // - Domain layer: Entities, Value Objects, Repository interfaces
        // - Application layer: Use Cases
        // - Infrastructure layer: Repository implementations, Data sources
        // - Presentation layer: Pages, Widgets, State management
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vehicles,
              name: RouteNames.vehicles,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: _PlaceholderPage(
                  title: 'Vehicles',
                  icon: Icons.directions_car,
                  message: 'TODO: Implement Vehicles feature with DDD',
                ),
              ),
            ),
          ],
        ),
        
        // TODO: Status feature - Implement following DDD structure
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.status,
              name: RouteNames.status,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: _PlaceholderPage(
                  title: 'Status',
                  icon: Icons.format_list_bulleted,
                  message: 'TODO: Implement Status feature with DDD',
                ),
              ),
            ),
          ],
        ),
        
        // Appointment feature - Currently active
        // Following DDD structure:
        // - Domain: Appointment entity, repository interface
        // - Application: Create/Get/Update appointment use cases
        // - Infrastructure: API implementation, local storage
        // - Presentation: Appointment pages and widgets
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.appointment,
              name: RouteNames.appointment,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AppointmentPage(),
              ),
              routes: [
                // Create appointment sub-route
                GoRoute(
                  path: RoutePaths.createAppointment,
                  name: RouteNames.createAppointment,
                  builder: (context, state) {
                    return const CreateAppointmentPage();
                  },
                ),
                // Appointment details sub-route
                GoRoute(
                  path: RoutePaths.appointmentDetails,
                  name: RouteNames.appointmentDetails,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return AppointmentDetailsPage(appointmentId: id);
                  },
                  routes: [
                    // Reschedule appointment sub-route
                    GoRoute(
                      path: 'reschedule',
                      name: RouteNames.rescheduleAppointment,
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return RescheduleAppointmentPage(appointmentId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        
        // TODO: Dashboard feature - Implement following DDD structure
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: RouteNames.dashboard,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: _PlaceholderPage(
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  message: 'TODO: Implement Dashboard feature with DDD',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

// ============================================================================
// PLACEHOLDER PAGES
// ============================================================================

/// Placeholder page for features not yet implemented
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _PlaceholderPage({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: title,
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
