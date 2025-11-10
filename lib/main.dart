import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecar_mobile_app/core/auth/token_provider.dart';
import 'package:safecar_mobile_app/core/config/app_environment.dart';
import 'package:safecar_mobile_app/features/insights/data/datasources/vehicle_insight_remote_data_source.dart';
import 'package:safecar_mobile_app/features/insights/data/repositories/vehicle_insight_repository_impl.dart';
import 'package:safecar_mobile_app/features/insights/domain/usecases/analyze_vehicle_telemetry.dart';
import 'package:safecar_mobile_app/features/insights/domain/usecases/get_vehicle_insight.dart';
import 'package:safecar_mobile_app/features/insights/presentation/providers/vehicle_insight_notifier.dart';
import 'package:safecar_mobile_app/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final http.Client _httpClient;
  late final VehicleInsightNotifier _vehicleInsightNotifier;

  @override
  void initState() {
    super.initState();
    _httpClient = http.Client();

    final tokenProvider = StaticTokenProvider(token: AppEnvironment.bearerToken);
    final remoteDataSource = VehicleInsightRemoteDataSource(
      client: _httpClient,
      tokenProvider: tokenProvider,
    );
    final repository = VehicleInsightRepositoryImpl(remoteDataSource);
    final getInsight = GetVehicleInsightUseCase(repository);
    final analyzeTelemetry = AnalyzeVehicleTelemetryUseCase(repository);

    _vehicleInsightNotifier = VehicleInsightNotifier(
      getVehicleInsightUseCase: getInsight,
      analyzeVehicleTelemetryUseCase: analyzeTelemetry,
    );
  }

  @override
  void dispose() {
    _vehicleInsightNotifier.dispose();
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _vehicleInsightNotifier),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'SafeCar',
      ),
    );
  }
}
