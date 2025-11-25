import 'package:equatable/equatable.dart';

abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentsEvent {
  final int driverId;

  const LoadAppointments({
    required this.driverId,
  });

  @override
  List<Object?> get props => [driverId];
}

class CreateAppointment extends AppointmentsEvent {
  final int workshopId;
  final int vehicleId;
  final int driverId;
  final DateTime startAt;
  final DateTime endAt;
  final String serviceType;
  final String? customServiceDescription;
  final int? mechanicId;

  const CreateAppointment({
    required this.workshopId,
    required this.vehicleId,
    required this.driverId,
    required this.startAt,
    required this.endAt,
    required this.serviceType,
    this.customServiceDescription,
    this.mechanicId,
  });

  @override
  List<Object?> get props => [
    workshopId,
    vehicleId,
    driverId,
    startAt,
    endAt,
    serviceType,
    customServiceDescription,
    mechanicId,
  ];
}

