import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';

/// SafeCar Mobile App - Service Type Dropdown
/// Dropdown field for selecting service type
class ServiceTypeDropdown extends StatelessWidget {
  final String? initialValue;
  final List<String> serviceTypes;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onChanged;

  const ServiceTypeDropdown({
    super.key,
    required this.serviceTypes,
    this.initialValue,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      validator: validator,
      decoration: InputDecoration(
        hintText: 'Select type',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 16,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey.shade600,
      ),
      items: serviceTypes.map((String service) {
        return DropdownMenuItem<String>(
          value: service,
          child: Text(service),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
