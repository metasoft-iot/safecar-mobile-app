import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/shared/widgets/custom_app_bar.dart';

import 'package:safecar_mobile_app/vehicle_management/infrastructure/mock_vehicle_data.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/widgets/vehicle_form.dart';

class EditVehiclePage extends StatelessWidget {
  final String vehicleId;

  const EditVehiclePage({
    super.key,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = MockVehicleData.getById(vehicleId);

    if (vehicle == null) {
      return Scaffold(
        appBar: CustomAppBar.withBackButton(
          title: 'Edit Vehicle',
          backgroundColor: AppColors.primary,
          titleStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: const Center(
          child: Text('Vehicle not found'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar.withBackButton(
        title: 'Edit Vehicle',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: VehicleForm(
            initialVehicle: vehicle,
          ),
        ),
      ),
    );
  }
}
