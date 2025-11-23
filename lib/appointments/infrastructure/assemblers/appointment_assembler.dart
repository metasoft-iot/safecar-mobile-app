import '../../../core/infrastructure/base_assembler.dart';
import '../../domain/model/appointment.entity.dart';
import '../resources/appointments_response.dart';

/// Assembler for converting between Appointment entities and Appointment resources.
class AppointmentAssembler implements BaseAssembler<Appointment, AppointmentResource, AppointmentsResponse> {
  @override
  Appointment toEntityFromResource(AppointmentResource resource) {
    return Appointment(
      id: resource.id,
      workshopId: resource.workshopId,
      vehicleId: resource.vehicleId,
      driverId: resource.driverId,
      startAt: DateTime.parse(resource.startAt),
      endAt: DateTime.parse(resource.endAt),
      status: resource.status,
      serviceType: resource.serviceType,
      customServiceDescription: resource.customServiceDescription,
      mechanicId: resource.mechanicId,
      notes: _mapNotes(resource.notes ?? []),
    );
  }

  @override
  AppointmentResource toResourceFromEntity(Appointment entity) {
    return AppointmentResource(
      id: entity.id,
      workshopId: entity.workshopId,
      vehicleId: entity.vehicleId,
      driverId: entity.driverId,
      startAt: entity.startAt.toIso8601String(),
      endAt: entity.endAt.toIso8601String(),
      status: entity.status,
      serviceType: entity.serviceType,
      customServiceDescription: entity.customServiceDescription,
      mechanicId: entity.mechanicId,
      notes: entity.notes.map((n) => {
        'id': n.id,
        'content': n.content,
        'authorId': n.authorId,
        'createdAt': n.createdAt.toIso8601String(),
      }).toList(),
    );
  }

  @override
  List<Appointment> toEntitiesFromResponse(AppointmentsResponse response) {
    return response.appointments.map((resource) => toEntityFromResource(resource)).toList();
  }

  List<AppointmentNote> _mapNotes(List<dynamic> notes) {
    return notes.map((n) {
      final note = n as Map<String, dynamic>;
      return AppointmentNote(
        id: note['id'] as int,
        content: note['content'] as String,
        authorId: note['authorId'] as int,
        createdAt: DateTime.parse(note['createdAt'] as String),
      );
    }).toList();
  }
}

