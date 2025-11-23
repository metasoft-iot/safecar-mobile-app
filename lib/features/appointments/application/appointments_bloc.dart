import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/models/appointment_model.dart';
import '../../workshops/domain/models/workshop_model.dart';
import '../../vehicles/domain/models/vehicle_model.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';

/// BLoC for managing appointments state
/// This is the single BLoC for the Appointments bounded context
class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final ApiService _apiService = ApiService();

  // Cache for related data
  final Map<int, MechanicModel> _mechanicsCache = {};
  final Map<int, VehicleModel> _vehiclesCache = {};

  AppointmentsBloc() : super(const AppointmentsInitial()) {
    on<AppointmentsFetchRequested>(_onFetchRequested);
    on<AppointmentsRefreshRequested>(_onRefreshRequested);
    on<AppointmentsErrorCleared>(_onErrorCleared);
  }

  /// Fetch all appointments for a driver
  Future<void> _onFetchRequested(
    AppointmentsFetchRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading());
    await _fetchAppointments(event.workshopId, event.driverId, emit);
  }

  /// Refresh appointments
  Future<void> _onRefreshRequested(
    AppointmentsRefreshRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    // Don't show loading state for refresh, keep current appointments visible
    await _fetchAppointments(event.workshopId, event.driverId, emit);
  }

  /// Common method to fetch appointments
  Future<void> _fetchAppointments(
    int workshopId,
    int driverId,
    Emitter<AppointmentsState> emit,
  ) async {
    try {
      final response = await _apiService.get(
        ApiConstants.appointmentsByDriver(workshopId, driverId),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final appointments = data
            .map((json) => AppointmentModel.fromJson(json))
            .toList();

        // Sort by date (most recent first)
        appointments.sort((a, b) => b.startAt.compareTo(a.startAt));

        if (appointments.isEmpty) {
          emit(const AppointmentsEmpty());
        } else {
          emit(AppointmentsLoaded(appointments: appointments));
        }
      } else {
        emit(const AppointmentsError(
          message: 'Error al cargar las citas',
        ));
      }
    } catch (e) {
      emit(AppointmentsError(
        message: 'Error: ${e.toString()}',
      ));
    }
  }

  /// Get mechanic details (with caching)
  Future<MechanicModel?> getMechanic(int mechanicId) async {
    if (_mechanicsCache.containsKey(mechanicId)) {
      return _mechanicsCache[mechanicId];
    }

    try {
      final response = await _apiService.get(
        ApiConstants.mechanicById(mechanicId),
      );

      if (response.statusCode == 200) {
        final mechanic = MechanicModel.fromJson(jsonDecode(response.body));
        _mechanicsCache[mechanicId] = mechanic;
        return mechanic;
      }
    } catch (e) {
      // Log error but don't throw
    }

    return null;
  }

  /// Get vehicle details (with caching)
  Future<VehicleModel?> getVehicle(int vehicleId) async {
    if (_vehiclesCache.containsKey(vehicleId)) {
      return _vehiclesCache[vehicleId];
    }

    try {
      final response = await _apiService.get(
        ApiConstants.vehicleById(vehicleId),
      );

      if (response.statusCode == 200) {
        final vehicle = VehicleModel.fromJson(jsonDecode(response.body));
        _vehiclesCache[vehicleId] = vehicle;
        return vehicle;
      }
    } catch (e) {
      // Log error but don't throw
    }

    return null;
  }

  /// Clear error message
  void _onErrorCleared(
    AppointmentsErrorCleared event,
    Emitter<AppointmentsState> emit,
  ) {
    emit(const AppointmentsInitial());
  }
}

