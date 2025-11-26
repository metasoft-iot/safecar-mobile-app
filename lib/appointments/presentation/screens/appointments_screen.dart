import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../application/appointments_bloc.dart';
import '../../application/appointments_states.dart';
import '../../application/appointments_events.dart';
import '../../domain/model/appointment.entity.dart';
import 'select_workshop_screen.dart';
import 'appointment_detail_screen.dart';
import 'new_appointment_screen.dart';

/// Screen displaying list of appointments for the driver using BLoC
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedFilter = 'All';
  int? _driverId;
  bool _isLoadingDriverId = true;
  String? _selectedWorkshopId;
  String? _selectedWorkshopName;
  
  @override
  void initState() {
    super.initState();
    _loadDriverIdAndAppointments();
    _loadSelectedWorkshop();
  }
  
  Future<void> _loadSelectedWorkshop() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _selectedWorkshopId = prefs.getString('selected_workshop_id');
        _selectedWorkshopName = prefs.getString('selected_workshop_name');
      });
    }
  }
  
  Future<void> _loadDriverIdAndAppointments() async {
    try {
      print('📅 [AppointmentsScreen] Loading driver ID...');
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getInt('driver_id');
      
      if (!mounted) return;
      
      setState(() {
        _driverId = driverId;
        _isLoadingDriverId = false;
      });
      
      if (driverId != null) {
        print('📅 [AppointmentsScreen] Driver ID: $driverId, fetching appointments...');
        // For now, hardcode workshopId to 1
        // In production, this should come from user selection or profile
        context.read<AppointmentsStore>().add(
          LoadAppointments(driverId: driverId),
        );
      } else {
        print('📅 [AppointmentsScreen] No driver ID found');
      }
    } catch (e) {
      print('📅 [AppointmentsScreen] Error loading driver ID: $e');
      if (mounted) {
        setState(() {
          _isLoadingDriverId = false;
        });
      }
    }
  }

  Future<void> _refreshAppointments() async {
    if (_driverId != null) {
      print('📅 [AppointmentsScreen] Refreshing appointments for driver $_driverId');
      context.read<AppointmentsStore>().add(
        LoadAppointments(driverId: _driverId!),
      );
    } else {
      // Try to load driver ID again
      await _loadDriverIdAndAppointments();
    }
  }
  
  List<Appointment> _filterAppointments(List<Appointment> appointments) {
    if (_selectedFilter == 'All') return appointments;
    
    return appointments.where((apt) {
      switch (_selectedFilter) {
        case 'PENDING':
          return apt.status == 'PENDING';
        case 'CONFIRMED':
          return apt.status == 'CONFIRMED';
        case 'IN_PROGRESS':
          return apt.status == 'IN_PROGRESS';
        case 'COMPLETED':
          return apt.status == 'COMPLETED';
        case 'CANCELLED':
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
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
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
                    if (_selectedWorkshopName != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.store,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Taller seleccionado',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _selectedWorkshopName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelectWorkshopScreen(),
                                  ),
                                );
                                if (result == true) {
                                  _loadSelectedWorkshop();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                      isSelected: _selectedFilter == 'PENDING',
                      onTap: () => setState(() => _selectedFilter = 'PENDING'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Confirmed',
                      isSelected: _selectedFilter == 'CONFIRMED',
                      onTap: () => setState(() => _selectedFilter = 'CONFIRMED'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'In Progress',
                      isSelected: _selectedFilter == 'IN_PROGRESS',
                      onTap: () => setState(() => _selectedFilter = 'IN_PROGRESS'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completed',
                      isSelected: _selectedFilter == 'COMPLETED',
                      onTap: () => setState(() => _selectedFilter = 'COMPLETED'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Cancelled',
                      isSelected: _selectedFilter == 'CANCELLED',
                      onTap: () => setState(() => _selectedFilter = 'CANCELLED'),
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
                  child: _isLoadingDriverId
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF5C4FDB),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Cargando información del conductor...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : _driverId == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No se pudo cargar la información del conductor',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadDriverIdAndAppointments,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _refreshAppointments,
                              child: BlocBuilder<AppointmentsStore, AppointmentsState>(
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
        onPressed: () async {
          if (_selectedWorkshopId != null && _selectedWorkshopName != null) {
            // Navigate directly to create appointment
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAppointmentScreen(
                  workshopId: _selectedWorkshopId!,
                  workshopName: _selectedWorkshopName!,
                ),
              ),
            );
            if (result == true) {
              _refreshAppointments();
            }
          } else {
            // Navigate to select workshop first
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectWorkshopScreen(),
              ),
            );
            if (result == true) {
              await _loadSelectedWorkshop();
              // Show message to create appointment now
              if (mounted && _selectedWorkshopId != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Ahora puedes crear tu primera cita!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          }
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
  final Appointment appointment;
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
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
        return 'Confirmed';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return appointment.status;
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

