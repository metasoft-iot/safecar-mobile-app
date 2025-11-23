/// Appointment entity for the appointments domain.
class Appointment {
  final int id;
  final int workshopId;
  final int vehicleId;
  final int driverId;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final String serviceType;
  final String? customServiceDescription;
  final int? mechanicId;
  final List<AppointmentNote> notes;

  Appointment({
    required this.id,
    required this.workshopId,
    required this.vehicleId,
    required this.driverId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.serviceType,
    this.customServiceDescription,
    this.mechanicId,
    this.notes = const [],
  });

  String get statusDisplayText {
    switch (status) {
      case 'PENDING':
        return 'Pendiente';
      case 'CONFIRMED':
        return 'Confirmada';
      case 'IN_PROGRESS':
        return 'En Progreso';
      case 'COMPLETED':
        return 'Completada';
      case 'CANCELLED':
        return 'Cancelada';
      default:
        return status;
    }
  }
}

/// Appointment note entity
class AppointmentNote {
  final int id;
  final String content;
  final int authorId;
  final DateTime createdAt;

  AppointmentNote({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
  });
}

