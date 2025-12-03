import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/vehicle.entity.dart';
import '../infrastructure/api/vehicles_api.dart';
import '../infrastructure/api/insights_api.dart';
import '../infrastructure/assemblers/vehicle_assembler.dart';
import '../infrastructure/assemblers/insight_assembler.dart';
import '../../core/infrastructure/api_service.dart';
import 'vehicles_events.dart';
import 'vehicles_states.dart';

/// Store for managing vehicles state.
/// This is the single BLoC/Store for the Vehicles bounded context.
class VehiclesStore extends Bloc<VehiclesEvent, VehiclesState> {
  final ApiService _apiService;
  final VehiclesApi _vehiclesApi;
  final InsightsApi _insightsApi;
  final VehicleAssembler _vehicleAssembler;
  final InsightAssembler _insightAssembler;
  final TelemetryAssembler _telemetryAssembler;

  // Cache
  List<Vehicle> _vehicles = [];

  VehiclesStore({
    ApiService? apiService,
    VehiclesApi? vehiclesApi,
    InsightsApi? insightsApi,
    VehicleAssembler? vehicleAssembler,
    InsightAssembler? insightAssembler,
    TelemetryAssembler? telemetryAssembler,
  })  : _apiService = apiService ?? ApiService(),
        _vehiclesApi = vehiclesApi ?? VehiclesApi(apiService ?? ApiService()),
        _insightsApi = insightsApi ?? InsightsApi(apiService ?? ApiService()),
        _vehicleAssembler = vehicleAssembler ?? VehicleAssembler(),
        _insightAssembler = insightAssembler ?? InsightAssembler(),
        _telemetryAssembler = telemetryAssembler ?? TelemetryAssembler(),
        super(const VehiclesInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<CreateVehicle>(_onCreateVehicle);
    on<LoadInsights>(_onLoadInsights);
    on<GenerateInsights>(_onGenerateInsights);
    on<LoadTelemetry>(_onLoadTelemetry);
    on<RefreshVehicles>(_onRefreshVehicles);
  }

  /// Load vehicles for the current driver
  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(const VehiclesLoading());

    try {
      final driverId = await _getDriverId();
      
      if (driverId == null) {
        print('[VehiclesStore] No driver ID found');
        emit(const VehiclesError(message: 'Driver ID not found'));
        return;
      }

      final response = await _vehiclesApi.getVehiclesByDriverId(driverId);
      _vehicles = _vehicleAssembler.toEntitiesFromResponse(response);
      
      print('[VehiclesStore] Loaded ${_vehicles.length} vehicles');
      emit(VehiclesLoaded(vehicles: _vehicles));
    } catch (e) {
      print('[VehiclesStore] Error loading vehicles: $e');
      emit(VehiclesError(message: 'Error loading vehicles: $e'));
    }
  }

  /// Create a new vehicle
  Future<void> _onCreateVehicle(
    CreateVehicle event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehicleCreating(currentVehicles: _vehicles));

    try {
      final driverId = await _getDriverId();
      
      if (driverId == null) {
        print('[VehiclesStore] Cannot create vehicle: No driver ID');
        emit(VehiclesError(
          message: 'Cannot create vehicle: Driver ID not found',
          vehicles: _vehicles,
        ));
        return;
      }

      final resource = await _vehiclesApi.createVehicle(
        driverId: driverId,
        licensePlate: event.licensePlate,
        brand: event.brand,
        model: event.model,
        year: event.year,
        vin: event.vin,
        color: event.color,
        mileage: event.mileage,
      );

      final vehicle = _vehicleAssembler.toEntityFromResource(resource);
      _vehicles = [..._vehicles, vehicle];

      print('[VehiclesStore] Vehicle created successfully');
      emit(VehicleCreated(vehicle: vehicle, allVehicles: _vehicles));
      
      // Emit loaded state after creation
      emit(VehiclesLoaded(vehicles: _vehicles));
    } catch (e) {
      print('[VehiclesStore] Error creating vehicle: $e');
      emit(VehiclesError(
        message: 'Error creating vehicle: $e',
        vehicles: _vehicles,
      ));
    }
  }

  /// Load insights for a vehicle
  Future<void> _onLoadInsights(
    LoadInsights event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(InsightsLoading(vehicles: _vehicles));

    try {
      // Load insights
      final insightResource = await _insightsApi.getVehicleInsights(event.vehicleId);
      final insight = insightResource != null 
          ? _insightAssembler.toEntityFromResource(insightResource)
          : null;

      // Load telemetry
      final telemetryResponse = await _insightsApi.getRecentTelemetry(event.vehicleId);
      final telemetry = _telemetryAssembler.toEntitiesFromResponse(telemetryResponse);

      print('[VehiclesStore] Loaded insights and ${telemetry.length} telemetry records');
      emit(InsightsLoaded(
        vehicles: _vehicles,
        insights: insight,
        telemetry: telemetry,
      ));
    } catch (e) {
      print('[VehiclesStore] Error loading insights: $e');
      emit(VehiclesError(
        message: 'Error loading insights: $e',
        vehicles: _vehicles,
      ));
    }
  }

  /// Generate insights for a vehicle
  Future<void> _onGenerateInsights(
    GenerateInsights event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(InsightsGenerating(vehicles: _vehicles));

    try {
      // Get latest telemetry ID
      final telemetryId = await _insightsApi.getLatestTelemetryId(event.vehicleId);
      
      if (telemetryId == null) {
        print('[VehiclesStore] No telemetry found for vehicle ${event.vehicleId}');
        emit(VehiclesError(
          message: 'No telemetry data found for this vehicle',
          vehicles: _vehicles,
        ));
        return;
      }

      // Generate insights
      final insightResource = await _insightsApi.generateInsights(telemetryId);
      final insight = _insightAssembler.toEntityFromResource(insightResource);

      // Load telemetry
      final telemetryResponse = await _insightsApi.getRecentTelemetry(event.vehicleId);
      final telemetry = _telemetryAssembler.toEntitiesFromResponse(telemetryResponse);

      print('[VehiclesStore] Insights generated successfully');
      emit(InsightsLoaded(
        vehicles: _vehicles,
        insights: insight,
        telemetry: telemetry,
      ));
    } catch (e) {
      print('[VehiclesStore] Error generating insights: $e');
      emit(VehiclesError(
        message: 'Error generating insights: $e',
        vehicles: _vehicles,
      ));
    }
  }

  /// Load telemetry for a vehicle
  Future<void> _onLoadTelemetry(
    LoadTelemetry event,
    Emitter<VehiclesState> emit,
  ) async {
    try {
      final telemetryResponse = await _insightsApi.getRecentTelemetry(
        event.vehicleId,
        limit: event.limit,
      );
      final telemetry = _telemetryAssembler.toEntitiesFromResponse(telemetryResponse);

      print('[VehiclesStore] Loaded ${telemetry.length} telemetry records');
      
      // If we're in an InsightsLoaded state, maintain the insights
      if (state is InsightsLoaded) {
        final currentState = state as InsightsLoaded;
        emit(InsightsLoaded(
          vehicles: _vehicles,
          insights: currentState.insights,
          telemetry: telemetry,
        ));
      } else {
        emit(InsightsLoaded(
          vehicles: _vehicles,
          insights: null,
          telemetry: telemetry,
        ));
      }
    } catch (e) {
      print('[VehiclesStore] Error loading telemetry: $e');
      emit(VehiclesError(
        message: 'Error loading telemetry: $e',
        vehicles: _vehicles,
      ));
    }
  }

  /// Refresh vehicles list
  Future<void> _onRefreshVehicles(
    RefreshVehicles event,
    Emitter<VehiclesState> emit,
  ) async {
    // Same as LoadVehicles
    add(const LoadVehicles());
  }

  /// Get driver ID from stored data
  Future<int?> _getDriverId() async {
    try {
      return await _apiService.getDriverId();
    } catch (e) {
      print('[VehiclesStore] Error getting driver ID: $e');
      return null;
    }
  }
}

