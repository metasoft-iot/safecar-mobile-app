import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/appointment.entity.dart';
import '../infrastructure/api/appointments_api.dart';
import '../infrastructure/assemblers/appointment_assembler.dart';
import '../../core/infrastructure/api_service.dart';
import 'appointments_events.dart';
import 'appointments_states.dart';

/// Store for managing appointments state.
class AppointmentsStore extends Bloc<AppointmentsEvent, AppointmentsState> {
  final ApiService _apiService;
  final AppointmentsApi _appointmentsApi;
  final AppointmentAssembler _appointmentAssembler;

  List<Appointment> _appointments = [];

  AppointmentsStore({
    ApiService? apiService,
    AppointmentsApi? appointmentsApi,
    AppointmentAssembler? appointmentAssembler,
  })  : _apiService = apiService ?? ApiService(),
        _appointmentsApi = appointmentsApi ?? AppointmentsApi(apiService ?? ApiService()),
        _appointmentAssembler = appointmentAssembler ?? AppointmentAssembler(),
        super(const AppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CreateAppointment>(_onCreateAppointment);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading());

    try {
      final response = await _appointmentsApi.getAppointmentsByDriver(
        driverId: event.driverId,
      );

      _appointments = _appointmentAssembler.toEntitiesFromResponse(response);
      
      // Sort by date (most recent first)
      _appointments.sort((a, b) => b.startAt.compareTo(a.startAt));

      print('[AppointmentsStore] Loaded ${_appointments.length} appointments');

      if (_appointments.isEmpty) {
        emit(const AppointmentsEmpty());
      } else {
        emit(AppointmentsLoaded(appointments: _appointments));
      }
    } catch (e) {
      print('[AppointmentsStore] Error loading appointments: $e');
      emit(AppointmentsError(message: 'Error al cargar citas: $e'));
    }
  }

  Future<void> _onCreateAppointment(
    CreateAppointment event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading());

    try {
      final resource = await _appointmentsApi.createAppointment(
        workshopId: event.workshopId,
        vehicleId: event.vehicleId,
        driverId: event.driverId,
        startAt: event.startAt,
        endAt: event.endAt,
        serviceType: event.serviceType,
        customServiceDescription: event.customServiceDescription,
        mechanicId: event.mechanicId,
      );

      final appointment = _appointmentAssembler.toEntityFromResource(resource);
      _appointments = [..._appointments, appointment];

      print('[AppointmentsStore] Appointment created successfully');
      emit(AppointmentCreated(appointment: appointment));
      
      // After creation, show updated list
      emit(AppointmentsLoaded(appointments: _appointments));
    } catch (e) {
      print('[AppointmentsStore] Error creating appointment: $e');
      emit(AppointmentsError(message: 'Error al crear cita: $e'));
    }
  }
}

