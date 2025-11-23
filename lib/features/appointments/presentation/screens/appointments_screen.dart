import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../application/appointments_bloc.dart';
import '../../application/appointments_state.dart';
import 'select_workshop_screen.dart';
import '../../domain/models/appointment_model.dart';
import 'appointment_detail_screen.dart';

/// Screen displaying list of appointments for the driver using BLoC
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    // TODO: Get workshopId and driverId from user profile
    // For now, this is a placeholder
    // context.read<AppointmentsBloc>().add(
    //   AppointmentsFetchRequested(workshopId: 1, driverId: 1),
    // );
  }

  Future<void> _refreshAppointments() async {
    // TODO: Implement with actual workshopId and driverId
    // context.read<AppointmentsBloc>().add(
    //   AppointmentsRefreshRequested(workshopId: 1, driverId: 1),
    // );
  }
  
  List<AppointmentModel> _filterAppointments(List<AppointmentModel> appointments) {
    if (_selectedFilter == 'All') return appointments;
    
    return appointments.where((apt) {
      switch (_selectedFilter) {
        case 'Pending':
          return apt.status == 'PENDING';
        case 'Filled':
          return apt.status == 'CONFIRMED' || apt.status == 'COMPLETED';
        case 'Canceled':
          return apt.status == 'CANCELLED';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5C4FDB),
              Color(0xFF7161EF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header (no duplicated title)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // Spacer for centering
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {
                        // TODO: Show notifications
                      },
                    ),
                  ],
                ),
              ),
              
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _selectedFilter == 'All',
                      onTap: () => setState(() => _selectedFilter = 'All'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Pending',
                      isSelected: _selectedFilter == 'Pending',
                      onTap: () => setState(() => _selectedFilter = 'Pending'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Filled',
                      isSelected: _selectedFilter == 'Filled',
                      onTap: () => setState(() => _selectedFilter = 'Filled'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Canceled',
                      isSelected: _selectedFilter == 'Canceled',
                      onTap: () => setState(() => _selectedFilter = 'Canceled'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: _refreshAppointments,
                    child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
                      builder: (context, state) {
                        if (state is AppointmentsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is AppointmentsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _refreshAppointments,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is AppointmentsEmpty || state is AppointmentsInitial) {
                          return _EmptyAppointmentsView();
                        }

                        if (state is AppointmentsLoaded) {
                          final filteredAppointments = _filterAppointments(state.appointments);
                          
                          if (filteredAppointments.isEmpty) {
                            return _EmptyAppointmentsView();
                          }
                          
                          return ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredAppointments.length,
                            itemBuilder: (context, index) {
                              final appointment = filteredAppointments[index];
                              return _AppointmentCard(
                                appointment: appointment,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentDetailScreen(
                                        appointment: appointment,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectWorkshopScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF5C4FDB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF5C4FDB) : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _EmptyAppointmentsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder (you mentioned not to implement images)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.build_circle_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No appointments yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule your first service\nand keep your car in top\ncondition!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.green.shade100;
      case 'IN_PROGRESS':
        return Colors.purple;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red.shade100;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusLabel() {
    switch (appointment.status) {
      case 'CONFIRMED':
        return 'Filled';
      case 'CANCELLED':
        return 'Canceled';
      default:
        return appointment.statusDisplayText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with ID
                    Text(
                      'Appointment #${appointment.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Date and time
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          dateFormat.format(appointment.startAt),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Location (placeholder)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Workshop Location',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusLabel(),
                  style: TextStyle(
                    color: appointment.status == 'CANCELLED' 
                        ? Colors.red.shade700
                        : appointment.status == 'CONFIRMED'
                        ? Colors.green.shade700
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

