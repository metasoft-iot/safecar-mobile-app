import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';

/// SafeCar Mobile App - Custom Form Field Label
/// Reusable label widget for form fields
class FormFieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const FormFieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isRequired ? '$text*' : text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
