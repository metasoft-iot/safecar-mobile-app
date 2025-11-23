import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/workshop.entity.dart';
import '../infrastructure/api/workshops_api.dart';
import '../infrastructure/assemblers/workshop_assembler.dart';
import '../../core/infrastructure/api_service.dart';
import 'workshops_events.dart';
import 'workshops_states.dart';

/// Store for managing workshops state.
class WorkshopsStore extends Bloc<WorkshopsEvent, WorkshopsState> {
  final ApiService _apiService;
  final WorkshopsApi _workshopsApi;
  final WorkshopAssembler _workshopAssembler;

  List<Workshop> _workshops = [];

  WorkshopsStore({
    ApiService? apiService,
    WorkshopsApi? workshopsApi,
    WorkshopAssembler? workshopAssembler,
  })  : _apiService = apiService ?? ApiService(),
        _workshopsApi = workshopsApi ?? WorkshopsApi(apiService ?? ApiService()),
        _workshopAssembler = workshopAssembler ?? WorkshopAssembler(),
        super(const WorkshopsInitial()) {
    on<LoadWorkshops>(_onLoadWorkshops);
    on<LoadWorkshopById>(_onLoadWorkshopById);
  }

  Future<void> _onLoadWorkshops(
    LoadWorkshops event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(const WorkshopsLoading());

    try {
      final response = await _workshopsApi.getWorkshops();
      _workshops = _workshopAssembler.toEntitiesFromResponse(response);
      
      print('[WorkshopsStore] Loaded ${_workshops.length} workshops');
      emit(WorkshopsLoaded(workshops: _workshops));
    } catch (e) {
      print('[WorkshopsStore] Error loading workshops: $e');
      emit(WorkshopsError(message: 'Error al cargar talleres: $e'));
    }
  }

  Future<void> _onLoadWorkshopById(
    LoadWorkshopById event,
    Emitter<WorkshopsState> emit,
  ) async {
    emit(const WorkshopsLoading());

    try {
      final resource = await _workshopsApi.getWorkshopById(event.workshopId);
      final workshop = _workshopAssembler.toEntityFromResource(resource);
      
      print('[WorkshopsStore] Loaded workshop ${workshop.id}');
      emit(WorkshopDetailLoaded(workshop: workshop, allWorkshops: _workshops));
    } catch (e) {
      print('[WorkshopsStore] Error loading workshop: $e');
      emit(WorkshopsError(message: 'Error al cargar taller: $e'));
    }
  }
}

