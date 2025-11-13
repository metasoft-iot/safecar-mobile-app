import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/shared/widgets/custom_app_bar.dart';

import '../../infrastructure/mock_vehicle_data.dart';
import '../../domain/model/vehicle_model.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_empty_state.dart';
import '../../vehicle_routes.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  late List<VehicleModel> vehicles;

  @override
  void initState() {
    super.initState();
    vehicles = MockVehicleData.vehicles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: 'My Vehicles',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: vehicles.isEmpty
          ? const VehicleEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          return VehicleCard(
            vehicle: vehicles[i],
            onTap: () {
              context.pushNamed(
                VehicleRouteNames.vehicleDetails,
                pathParameters: {'id': vehicles[i].id},
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(VehicleRouteNames.vehicleAdd);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
