/// SafeCar Mobile App - Mock Appointment Data
/// Mock data for testing and development
/// Part of Workshop bounded context
library;

import 'package:safecar_mobile_app/workshop/domain/model/appointment.dart';

class MockAppointmentData {
  static final List<AppointmentModel> appointments = [
    // Pending Appointments
    AppointmentModel(
      id: 'APT-001',
      vehicleName: 'Toyota Camry 2020',
      vehiclePlate: 'ABC-1234',
      serviceType: 'Oil Change',
      date: DateTime(2025, 11, 15),
      time: '10:00 AM',
      status: AppointmentStatus.pending,
      notes: 'Please check the brake pads as well.',
      createdAt: DateTime(2025, 11, 1),
    ),
    AppointmentModel(
      id: 'APT-002',
      vehicleName: 'Honda Civic 2019',
      vehiclePlate: 'XYZ-5678',
      serviceType: 'Tire Rotation',
      date: DateTime(2025, 11, 16),
      time: '2:00 PM',
      status: AppointmentStatus.pending,
      notes: null,
      createdAt: DateTime(2025, 11, 2),
    ),
    AppointmentModel(
      id: 'APT-003',
      vehicleName: 'Ford F-150 2021',
      vehiclePlate: 'DEF-9012',
      serviceType: 'Engine Diagnostic',
      date: DateTime(2025, 11, 18),
      time: '9:00 AM',
      status: AppointmentStatus.pending,
      notes: 'Check engine light is on. Needs urgent attention.',
      createdAt: DateTime(2025, 11, 3),
    ),

    // Confirmed Appointments
    AppointmentModel(
      id: 'APT-004',
      vehicleName: 'Tesla Model 3 2022',
      vehiclePlate: 'GHI-3456',
      serviceType: 'Battery Service',
      date: DateTime(2025, 11, 20),
      time: '11:00 AM',
      status: AppointmentStatus.confirmed,
      notes: 'Customer prefers morning appointments.',
      createdAt: DateTime(2025, 11, 4),
    ),
    AppointmentModel(
      id: 'APT-005',
      vehicleName: 'BMW X5 2020',
      vehiclePlate: 'JKL-7890',
      serviceType: 'Air Conditioning',
      date: DateTime(2025, 11, 22),
      time: '3:00 PM',
      status: AppointmentStatus.confirmed,
      notes: 'AC not cooling properly. May need refrigerant refill.',
      createdAt: DateTime(2025, 11, 5),
    ),

    // Completed Appointments
    AppointmentModel(
      id: 'APT-006',
      vehicleName: 'Mercedes C-Class 2019',
      vehiclePlate: 'MNO-2345',
      serviceType: 'General Inspection',
      date: DateTime(2025, 11, 5),
      time: '10:00 AM',
      status: AppointmentStatus.completed,
      notes: 'Annual inspection required for registration renewal.',
      createdAt: DateTime(2025, 10, 25),
    ),
    AppointmentModel(
      id: 'APT-007',
      vehicleName: 'Chevrolet Silverado 2018',
      vehiclePlate: 'PQR-6789',
      serviceType: 'Brake Service',
      date: DateTime(2025, 11, 8),
      time: '1:00 PM',
      status: AppointmentStatus.completed,
      notes: 'Replace front brake pads and rotors.',
      createdAt: DateTime(2025, 10, 28),
    ),

    // Cancelled Appointments
    AppointmentModel(
      id: 'APT-008',
      vehicleName: 'Audi A4 2021',
      vehiclePlate: 'STU-0123',
      serviceType: 'Transmission Service',
      date: DateTime(2025, 11, 12),
      time: '4:00 PM',
      status: AppointmentStatus.cancelled,
      notes: 'Customer cancelled due to schedule conflict.',
      createdAt: DateTime(2025, 11, 1),
    ),
    AppointmentModel(
      id: 'APT-009',
      vehicleName: 'Nissan Altima 2020',
      vehiclePlate: 'VWX-4567',
      serviceType: 'Oil Change',
      date: DateTime(2025, 11, 10),
      time: '11:30 AM',
      status: AppointmentStatus.cancelled,
      notes: null,
      createdAt: DateTime(2025, 10, 30),
    ),

    // More recent appointments
    AppointmentModel(
      id: 'APT-010',
      vehicleName: 'Mazda CX-5 2022',
      vehiclePlate: 'YZA-8901',
      serviceType: 'General Inspection',
      date: DateTime(2025, 11, 25),
      time: '8:00 AM',
      status: AppointmentStatus.confirmed,
      notes: 'First service for new vehicle.',
      createdAt: DateTime(2025, 11, 6),
    ),
  ];

  /// Get appointments filtered by status
  static List<AppointmentModel> getByStatus(AppointmentStatus status) {
    return appointments.where((apt) => apt.status == status).toList();
  }

  /// Get appointments filtered by status text
  static List<AppointmentModel> getByStatusText(String statusText) {
    switch (statusText.toLowerCase()) {
      case 'pending':
        return getByStatus(AppointmentStatus.pending);
      case 'filled':
      case 'confirmed':
        return getByStatus(AppointmentStatus.confirmed);
      case 'canceled':
      case 'cancelled':
        return getByStatus(AppointmentStatus.cancelled);
      case 'completed':
        return getByStatus(AppointmentStatus.completed);
      default:
        return appointments;
    }
  }

  /// Get appointment by ID
  static AppointmentModel? getById(String id) {
    try {
      return appointments.firstWhere((apt) => apt.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get upcoming appointments (future dates)
  static List<AppointmentModel> getUpcoming() {
    final now = DateTime.now();
    return appointments
        .where((apt) =>
            apt.date.isAfter(now) &&
            apt.status != AppointmentStatus.cancelled &&
            apt.status != AppointmentStatus.completed)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get recent appointments (past 30 days)
  static List<AppointmentModel> getRecent() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return appointments
        .where((apt) => apt.createdAt.isAfter(thirtyDaysAgo))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get statistics
  static Map<String, int> getStatistics() {
    return {
      'total': appointments.length,
      'pending': getByStatus(AppointmentStatus.pending).length,
      'confirmed': getByStatus(AppointmentStatus.confirmed).length,
      'completed': getByStatus(AppointmentStatus.completed).length,
      'cancelled': getByStatus(AppointmentStatus.cancelled).length,
    };
  }
}
