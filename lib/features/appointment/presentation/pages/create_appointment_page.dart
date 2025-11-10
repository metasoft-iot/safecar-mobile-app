import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/core/shared/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/create_appointment/form_field_label.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/create_appointment/date_picker_field.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/create_appointment/time_picker_field.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/create_appointment/service_type_dropdown.dart';

/// SafeCar Mobile App - Create Appointment Page
/// Allows users to schedule a new service appointment with date, time,
/// service type selection, and additional notes.
class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedServiceType;
  bool _isFormValid = false;
  
  final List<String> _serviceTypes = [
    'Oil Change',
    'Tire Rotation',
    'Brake Service',
    'Engine Diagnostic',
    'Battery Service',
    'Air Conditioning',
    'Transmission Service',
    'General Inspection',
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Valida si todos los campos requeridos están completos
  void _validateForm() {
    setState(() {
      _isFormValid = _dateController.text.isNotEmpty &&
          _timeController.text.isNotEmpty &&
          _selectedServiceType != null &&
          _selectedServiceType!.isNotEmpty;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = 
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
      _validateForm();
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
      _validateForm();
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality with BLoC/repository
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Quitar el foco de los inputs cuando se toca fuera
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar.withBackButton(
          title: 'New Appointment',
          backgroundColor: AppColors.primary,
          titleStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  const Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Date Field
                  const FormFieldLabel(text: 'Date', isRequired: true),
                  const SizedBox(height: 8),
                  DatePickerField(
                    controller: _dateController,
                    hintText: 'dd/mm/aaaa',
                    onTap: _selectDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Hour Field
                  const FormFieldLabel(text: 'Hour', isRequired: true),
                  const SizedBox(height: 8),
                  TimePickerField(
                    controller: _timeController,
                    hintText: 'HH:MM',
                    onTap: _selectTime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Type of Service Field
                  const FormFieldLabel(text: 'Type of service', isRequired: true),
                  const SizedBox(height: 8),
                  ServiceTypeDropdown(
                    initialValue: _selectedServiceType,
                    serviceTypes: _serviceTypes,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a service type';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedServiceType = newValue;
                      });
                      _validateForm();
                    },
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '(*) This field is required',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Notes Field
                  const FormFieldLabel(text: 'Notes'),
                  const SizedBox(height: 8),
                  _buildNotesField(),
                  const SizedBox(height: 48),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _saveAppointment : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid ? AppColors.primary : Colors.grey.shade300,
                        foregroundColor: _isFormValid ? AppColors.white : Colors.grey.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                      ),
                      child: const Text(
                        'Save appointment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Form
      ), // Scaffold
    ); // GestureDetector
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 5,
      maxLength: 250,
      decoration: InputDecoration(
        hintText: 'Add additional notes here',
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
        counterText: '${_notesController.text.length}/250',
        counterStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      onChanged: (value) {
        setState(() {}); // Update character counter
      },
    );
  }
}
