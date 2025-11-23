import 'package:equatable/equatable.dart';
import '../domain/models/appointment_model.dart';

/// Base class for all appointments states
abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state when appointments haven't been loaded yet
class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

/// State when appointments are being loaded
class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

/// State when appointments have been loaded successfully
class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> appointments;

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

/// State when there's no appointments
class AppointmentsEmpty extends AppointmentsState {
  const AppointmentsEmpty();
}

/// State when there's an error loading appointments
class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError({required this.message});

  @override
  List<Object?> get props => [message];
}

