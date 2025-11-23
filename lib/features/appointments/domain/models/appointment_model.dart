/// Appointment model representing a service appointment
class AppointmentModel {
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

  AppointmentModel({
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

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as int,
      workshopId: json['workshopId'] as int,
      vehicleId: json['vehicleId'] as int,
      driverId: json['driverId'] as int,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      status: json['status'] as String,
      serviceType: json['serviceType'] as String,
      customServiceDescription: json['customServiceDescription'] as String?,
      mechanicId: json['mechanicId'] as int?,
      notes: (json['notes'] as List<dynamic>?)
          ?.map((note) => AppointmentNote.fromJson(note))
          .toList() ?? [],
    );
  }

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

/// Appointment note model
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

  factory AppointmentNote.fromJson(Map<String, dynamic> json) {
    return AppointmentNote(
      id: json['id'] as int,
      content: json['content'] as String,
      authorId: json['authorId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

