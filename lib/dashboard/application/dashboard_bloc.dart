import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/dashboard_summary.entity.dart';
import 'dashboard_events.dart';
import 'dashboard_states.dart';

/// Store for managing dashboard state.
/// Note: In DDD, dashboard typically aggregates data from other bounded contexts.
/// For now, we keep it simple with just state management.
class DashboardStore extends Bloc<DashboardEvent, DashboardState> {
  DashboardStore() : super(const DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      // For now, emit empty data
      // The actual data loading will happen in the presentation layer
      // by accessing VehiclesStore and InsightsStore directly
      final summary = DashboardSummary(
        totalVehicles: 0,
        lastAlert: null,
        lastAlertTime: null,
        nextService: null,
      );

      emit(DashboardLoaded(summary: summary));
    } catch (e) {
      emit(DashboardError(message: 'Error al cargar dashboard: $e'));
    }
  }
}

