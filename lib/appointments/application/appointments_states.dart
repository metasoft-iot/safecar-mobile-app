import 'package:equatable/equatable.dart';
import '../domain/model/appointment.entity.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

class AppointmentsLoaded extends AppointmentsState {
  final List<Appointment> appointments;

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class AppointmentsEmpty extends AppointmentsState {
  const AppointmentsEmpty();
}

class AppointmentCreated extends AppointmentsState {
  final Appointment appointment;

  const AppointmentCreated({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

