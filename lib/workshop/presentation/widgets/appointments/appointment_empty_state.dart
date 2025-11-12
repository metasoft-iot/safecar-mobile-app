import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/workshop/presentation/workshop_router/helpers/workshop_navigation_helper.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

/// SafeCar Mobile App - Appointment Empty State Widget
/// Displays when there are no appointments yet
/// Part of Workshop bounded context
class AppointmentEmptyState extends StatelessWidget {
  const AppointmentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 120, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            const Text(
              'No appointments yet!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Schedule your first service and keep your car in top condition!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                AppointmentNavigationHelper.goToCreateAppointment(context);
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Schedule Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
