import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/core/router/helpers/navigation_helper.dart';
import 'package:safecar_mobile_app/core/shared/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/appointment_list/appointment_filter_bar.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/appointment_list/appointment_empty_state.dart';
import 'package:safecar_mobile_app/features/appointment/presentation/widgets/appointment_list/appointment_list.dart';
import 'package:safecar_mobile_app/features/appointment/data/mock/mock_appointment_data.dart';
import 'package:safecar_mobile_app/features/appointment/data/models/appointment_model.dart';

/// SafeCar Mobile App - Appointment Page
/// Main page for viewing and managing appointments
class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String _selectedFilter = 'All';
  List<AppointmentModel> _filteredAppointments = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredAppointments();
  }

  void _updateFilteredAppointments() {
    setState(() {
      if (_selectedFilter == 'All') {
        _filteredAppointments = MockAppointmentData.appointments;
      } else {
        _filteredAppointments = MockAppointmentData.getByStatusText(_selectedFilter);
      }
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _updateFilteredAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: 'Appointment',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Column(
        children: [
          // Filter Bar
          AppointmentFilterBar(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
          // Main Content
          Expanded(
            child: _filteredAppointments.isEmpty
                ? const AppointmentEmptyState()
                : AppointmentList(
                    selectedFilter: _selectedFilter,
                    appointments: _filteredAppointments,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationHelper.goToCreateAppointment(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }
}
