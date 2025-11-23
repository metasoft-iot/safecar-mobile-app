import 'package:equatable/equatable.dart';

/// Base class for all appointments events
abstract class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch all appointments for a driver
class AppointmentsFetchRequested extends AppointmentsEvent {
  final int workshopId;
  final int driverId;

  const AppointmentsFetchRequested({
    required this.workshopId,
    required this.driverId,
  });

  @override
  List<Object?> get props => [workshopId, driverId];
}

/// Event to refresh appointments
class AppointmentsRefreshRequested extends AppointmentsEvent {
  final int workshopId;
  final int driverId;

  const AppointmentsRefreshRequested({
    required this.workshopId,
    required this.driverId,
  });

  @override
  List<Object?> get props => [workshopId, driverId];
}

/// Event to clear error message
class AppointmentsErrorCleared extends AppointmentsEvent {
  const AppointmentsErrorCleared();
}

