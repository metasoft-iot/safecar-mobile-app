import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/presentation/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/shared/presentation/widgets/confirmation_dialog.dart';
import 'package:safecar_mobile_app/workshop/presentation/router/helpers/workshop_navigation_helper.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/workshop/infrastructure/mock_appointment_data.dart';
import 'package:safecar_mobile_app/workshop/domain/entities/appointment.dart';

/// SafeCar Mobile App - Appointment Details Page
/// Part of Workshop bounded context
class AppointmentDetailsPage extends StatelessWidget {
  final String appointmentId;

  const AppointmentDetailsPage({super.key, required this.appointmentId});

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get appointment data from mock
    final appointment = MockAppointmentData.getById(appointmentId);

    // Handle not found
    if (appointment == null) {
      return Scaffold(
        appBar: CustomAppBar.withBackButton(
          title: 'Appointment Details',
          backgroundColor: AppColors.primary,
          titleStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: const Center(child: Text('Appointment not found')),
      );
    }

    final statusColor = _getStatusColor(appointment.status);

    return Scaffold(
      appBar: CustomAppBar.withBackButton(
        title: 'Appointment Details',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: AppColors.white,
            onPressed: () {
              // TODO: Navigate to edit page
            },
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: AppColors.white,
            onPressed: () {
              // TODO: Show delete confirmation
            },
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                appointment.statusText.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Appointment ID
            _buildInfoSection('Appointment ID', appointment.id, Icons.tag),
            const Divider(height: 32),

            // Vehicle Info
            _buildInfoSection(
              'Vehicle',
              '${appointment.vehicleName}\n${appointment.vehiclePlate}',
              Icons.directions_car,
            ),
            const Divider(height: 32),

            // Service Type
            _buildInfoSection(
              'Service Type',
              appointment.serviceType,
              Icons.build,
            ),
            const Divider(height: 32),

            // Date & Time
            _buildInfoSection(
              'Date & Time',
              appointment.formattedDateTime,
              Icons.calendar_today,
            ),

            // Notes (only if exists)
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const Divider(height: 32),
              _buildInfoSection('Notes', appointment.notes!, Icons.notes),
            ],

            const SizedBox(height: 32),

            // Action Buttons (only for non-completed and non-cancelled)
            if (appointment.status != AppointmentStatus.completed &&
                appointment.status != AppointmentStatus.cancelled)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppointmentNavigationHelper.goToRescheduleAppointment(
                          context,
                          appointment.id,
                        );
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      type: ConfirmationDialogType.delete,
      title: 'Cancel Appointment?',
      message:
          'When you cancel your appointment, the assigned workshop will be automatically notified, who will contact you to define a solution or reschedule if necessary.\n\n'
          'This action cannot be undone. Are you sure you want to continue?',
      confirmText: 'Confirm',
      onConfirm: () {
        // TODO: Implement actual cancel logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment cancelled successfully'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
