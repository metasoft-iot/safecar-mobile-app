/// SafeCar Mobile App - Appointment Model
/// Data model for appointments within the Workshop bounded context
library;

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class AppointmentModel {
  final String id;
  final String vehicleName;
  final String vehiclePlate;
  final String serviceType;
  final DateTime date;
  final String time;
  final AppointmentStatus status;
  final String? notes;
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.serviceType,
    required this.date,
    required this.time,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  String get statusText {
    switch (status) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get formattedDate {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get formattedDateTime {
    return '$formattedDate at $time';
  }

  // Copy with method for updates
  AppointmentModel copyWith({
    String? id,
    String? vehicleName,
    String? vehiclePlate,
    String? serviceType,
    DateTime? date,
    String? time,
    AppointmentStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      vehicleName: vehicleName ?? this.vehicleName,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
