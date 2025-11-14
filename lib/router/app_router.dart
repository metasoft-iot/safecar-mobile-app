import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/insights/presentation/views/vehicle_insights_page.dart';
import 'package:safecar_mobile_app/router/route_constants.dart';
import 'package:safecar_mobile_app/shared/presentation/pages/not_found_page.dart';
import 'package:safecar_mobile_app/shared/presentation/pages/main_layout.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/workshop/presentation/router/workshop_routes.dart';

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
        // Branch 1: Vehicles
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.vehicles,
              builder: (context, state) => _PlaceholderPage(
                title: 'Vehicles',
                icon: Icons.directions_car,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        // Branch 2: Status
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.status,
              builder: (context, state) => const VehicleInsightsPage(),
            ),
          ],
        ),

        // Branch 3: Workshop (WorkshopRoutes)
        StatefulShellBranch(
          routes: [WorkshopRoutes.getWorkshopRoute(AppRoutes.workshop)],
        ),

        // Branch 4: Dashboard
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
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
