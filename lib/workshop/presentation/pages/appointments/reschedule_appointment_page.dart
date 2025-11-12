import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/presentation/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/workshop/presentation/widgets/appointments/form_field_label.dart';
import 'package:safecar_mobile_app/workshop/presentation/widgets/appointments/date_picker_field.dart';
import 'package:safecar_mobile_app/workshop/presentation/widgets/appointments/time_picker_field.dart';
import 'package:safecar_mobile_app/workshop/presentation/widgets/appointments/service_type_dropdown.dart';
import 'package:safecar_mobile_app/workshop/infrastructure/mock_appointment_data.dart';
import 'package:safecar_mobile_app/workshop/domain/entities/appointment.dart';

/// SafeCar Mobile App - Reschedule Appointment Page
/// Allows users to reschedule an existing appointment
/// Part of Workshop bounded context
class RescheduleAppointmentPage extends StatefulWidget {
  final String appointmentId;

  const RescheduleAppointmentPage({super.key, required this.appointmentId});

  @override
  State<RescheduleAppointmentPage> createState() =>
      _RescheduleAppointmentPageState();
}

class _RescheduleAppointmentPageState extends State<RescheduleAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedServiceType;
  bool _isFormValid = false;
  AppointmentModel? _appointment;

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
  void initState() {
    super.initState();
    _loadAppointment();
  }

  void _loadAppointment() {
    _appointment = MockAppointmentData.getById(widget.appointmentId);
    if (_appointment != null) {
      // Pre-fill form with existing appointment data
      _dateController.text =
          '${_appointment!.date.day.toString().padLeft(2, '0')}/${_appointment!.date.month.toString().padLeft(2, '0')}/${_appointment!.date.year}';
      _timeController.text = _appointment!.time;
      _selectedServiceType = _appointment!.serviceType;
      _notesController.text = _appointment!.notes ?? '';
      _validateForm();
    }
  }

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
      _isFormValid =
          _dateController.text.isNotEmpty &&
          _timeController.text.isNotEmpty &&
          _selectedServiceType != null &&
          _selectedServiceType!.isNotEmpty;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _appointment?.date ?? DateTime.now(),
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
        final hour = picked.hourOfPeriod;
        final minute = picked.minute.toString().padLeft(2, '0');
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        _timeController.text = '${hour == 0 ? 12 : hour}:$minute $period';
      });
      _validateForm();
    }
  }

  void _handleSubmit() {
    if (_isFormValid) {
      // TODO: Implement reschedule logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment rescheduled successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_appointment == null) {
      return Scaffold(
        appBar: CustomAppBar.withBackButton(
          title: 'Reschedule Appointment',
          backgroundColor: AppColors.primary,
          titleStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: const Center(child: Text('Appointment not found')),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar.withBackButton(
          title: 'Reschedule Appointment',
          backgroundColor: AppColors.primary,
          titleStyle: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current appointment info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Appointment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _appointment!.formattedDateTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _appointment!.serviceType,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Select New Date & Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Date Field
                const FormFieldLabel(text: 'Date', isRequired: true),
                const SizedBox(height: 8),
                DatePickerField(
                  controller: _dateController,
                  hintText: 'Select date',
                  onTap: _selectDate,
                ),
                const SizedBox(height: 20),

                // Time Field
                const FormFieldLabel(text: 'Hour', isRequired: true),
                const SizedBox(height: 8),
                TimePickerField(
                  controller: _timeController,
                  hintText: 'Select time',
                  onTap: _selectTime,
                ),
                const SizedBox(height: 20),

                // Service Type Dropdown
                const FormFieldLabel(text: 'Service Type', isRequired: true),
                const SizedBox(height: 8),
                ServiceTypeDropdown(
                  initialValue: _selectedServiceType,
                  serviceTypes: _serviceTypes,
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value;
                    });
                    _validateForm();
                  },
                ),
                const SizedBox(height: 20),

                // Notes Field
                const FormFieldLabel(text: 'Notes'),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Add any additional notes or special requests...',
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.textSecondary
                          .withValues(alpha: 0.3),
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm Reschedule',
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
      ),
    );
  }
}
