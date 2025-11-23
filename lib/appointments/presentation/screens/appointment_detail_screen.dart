import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/model/appointment.entity.dart';

/// Screen showing detailed information about a specific appointment for the driver
class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.green;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green.shade700;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel() {
    switch (appointment.status) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return appointment.status;
    }
  }

  IconData _getStatusIcon() {
    switch (appointment.status) {
      case 'PENDING':
        return Icons.schedule;
      case 'CONFIRMED':
        return Icons.check_circle;
      case 'IN_PROGRESS':
        return Icons.build_circle;
      case 'COMPLETED':
        return Icons.done_all;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        backgroundColor: const Color(0xFF5C4FDB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getStatusColor().withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      size: 40,
                      color: _getStatusColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appointment #${appointment.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Appointment details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and time section
                  _DetailSection(
                    title: 'Date & Time',
                    icon: Icons.calendar_today,
                    iconColor: const Color(0xFF5C4FDB),
                    children: [
                      _DetailRow(
                        label: 'Date',
                        value: dateFormat.format(appointment.startAt),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Start Time',
                        value: timeFormat.format(appointment.startAt),
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'End Time',
                        value: timeFormat.format(appointment.endAt),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Service information
                  _DetailSection(
                    title: 'Service Information',
                    icon: Icons.build,
                    iconColor: Colors.orange,
                    children: [
                      _DetailRow(
                        label: 'Service Type',
                        value: _formatServiceType(appointment.serviceType),
                      ),
                      if (appointment.customServiceDescription != null &&
                          appointment.customServiceDescription!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Notes',
                          value: appointment.customServiceDescription!,
                          isMultiline: true,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Vehicle information
                  _DetailSection(
                    title: 'Vehicle',
                    icon: Icons.directions_car,
                    iconColor: Colors.blue,
                    children: [
                      _DetailRow(
                        label: 'Vehicle ID',
                        value: '#${appointment.vehicleId}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Workshop information
                  _DetailSection(
                    title: 'Workshop',
                    icon: Icons.store,
                    iconColor: Colors.green,
                    children: [
                      _DetailRow(
                        label: 'Workshop ID',
                        value: '#${appointment.workshopId}',
                      ),
                      if (appointment.mechanicId != null) ...[
                        const SizedBox(height: 12),
                        _DetailRow(
                          label: 'Assigned Mechanic',
                          value: 'Mechanic #${appointment.mechanicId}',
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Status message
                  if (appointment.status == 'PENDING')
                    _InfoCard(
                      icon: Icons.info_outline,
                      color: Colors.orange,
                      title: 'Waiting for Confirmation',
                      message:
                          'Your appointment is pending. The workshop will review and confirm it soon.',
                    ),

                  if (appointment.status == 'CONFIRMED')
                    _InfoCard(
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                      title: 'Appointment Confirmed',
                      message:
                          'Your appointment has been confirmed. Please arrive on time.',
                    ),

                  if (appointment.status == 'IN_PROGRESS')
                    _InfoCard(
                      icon: Icons.build_circle_outlined,
                      color: Colors.blue,
                      title: 'Service in Progress',
                      message:
                          'Your vehicle is currently being serviced. You will be notified when it\'s ready.',
                    ),

                  if (appointment.status == 'COMPLETED')
                    _InfoCard(
                      icon: Icons.done_all,
                      color: Colors.green.shade700,
                      title: 'Service Completed',
                      message:
                          'Your vehicle service has been completed. Thank you for choosing us!',
                    ),

                  if (appointment.status == 'CANCELLED')
                    _InfoCard(
                      icon: Icons.cancel_outlined,
                      color: Colors.red,
                      title: 'Appointment Cancelled',
                      message:
                          'This appointment has been cancelled. Please contact the workshop for more information.',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatServiceType(String serviceType) {
    // Convert SNAKE_CASE to Title Case
    return serviceType
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiline;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isMultiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          maxLines: isMultiline ? null : 1,
          overflow: isMultiline ? null : TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _InfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
