import 'package:flutter/foundation.dart';

import '../../domain/entities/vehicle_insight.dart';
import '../../domain/entities/vehicle_telemetry.dart';
import '../../domain/usecases/analyze_vehicle_telemetry.dart';
import '../../domain/usecases/get_vehicle_insight.dart';

enum VehicleInsightStatus { initial, loading, loaded, error }

class VehicleInsightNotifier extends ChangeNotifier {
  VehicleInsightNotifier({
    required GetVehicleInsightUseCase getVehicleInsightUseCase,
    required AnalyzeVehicleTelemetryUseCase analyzeVehicleTelemetryUseCase,
  })  : _getVehicleInsightUseCase = getVehicleInsightUseCase,
        _analyzeVehicleTelemetryUseCase = analyzeVehicleTelemetryUseCase;

  final GetVehicleInsightUseCase _getVehicleInsightUseCase;
  final AnalyzeVehicleTelemetryUseCase _analyzeVehicleTelemetryUseCase;

  VehicleInsight? _insight;
  VehicleInsightStatus _status = VehicleInsightStatus.initial;
  String? _errorMessage;
  bool _isAnalyzing = false;
  int? _currentVehicleId;

  VehicleInsight? get insight => _insight;
  VehicleInsightStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAnalyzing => _isAnalyzing;
  int? get vehicleId => _currentVehicleId;

  Future<void> loadInsight(int vehicleId) async {
    _currentVehicleId = vehicleId;
    _status = VehicleInsightStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _insight = await _getVehicleInsightUseCase(vehicleId);
      _status = VehicleInsightStatus.loaded;
    } catch (error) {
      _status = VehicleInsightStatus.error;
      _errorMessage = _mapError(error);
    }

    notifyListeners();
  }

  Future<void> refreshAnalysis(VehicleTelemetry telemetry) async {
    _isAnalyzing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _insight = await _analyzeVehicleTelemetryUseCase(telemetry);
      _status = VehicleInsightStatus.loaded;
    } catch (error) {
      _status = VehicleInsightStatus.error;
      _errorMessage = _mapError(error);
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  String _mapError(Object error) {
    return error.toString();
  }
}
