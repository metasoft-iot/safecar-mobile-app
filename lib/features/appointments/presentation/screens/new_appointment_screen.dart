import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/vehicle_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/constants/api_constants.dart';

/// Screen for creating a new appointment request
class NewAppointmentScreen extends StatefulWidget {
  final String workshopId;
  final String workshopName;
  
  const NewAppointmentScreen({
    super.key,
    required this.workshopId,
    required this.workshopName,
  });

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _hourController = TextEditingController();
  final _notesController = TextEditingController();
  final _vehicleService = VehicleService();
  final _apiService = ApiService();
  
  String? _selectedServiceType;
  String? _selectedVehicle;
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  // Service types displayed to user
  final List<String> _serviceTypes = [
    'General Maintenance',
    'Oil Change',
    'Brake Service',
    'Tire Service',
    'Engine Diagnostics',
    'Transmission Service',
    'Electrical Repair',
    'Air Conditioning',
    'Suspension Repair',
    'Custom Service',
  ];
  
  // Map user-friendly names to backend enum values
  final Map<String, String> _serviceTypeMap = {
    'General Maintenance': 'GENERAL_MAINTENANCE',
    'Oil Change': 'OIL_CHANGE',
    'Brake Service': 'BRAKE_SERVICE',
    'Tire Service': 'TIRE_SERVICE',
    'Engine Diagnostics': 'ENGINE_DIAGNOSTICS',
    'Transmission Service': 'TRANSMISSION_SERVICE',
    'Electrical Repair': 'ELECTRICAL_REPAIR',
    'Air Conditioning': 'AIR_CONDITIONING',
    'Suspension Repair': 'SUSPENSION_REPAIR',
    'Custom Service': 'CUSTOM',
  };

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }
  
  Future<void> _loadVehicles() async {
    try {
      final vehicles = await _vehicleService.getVehicles();
      setState(() {
        _vehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading vehicles: $e');
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _hourController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5C4FDB),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5C4FDB),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
        _hourController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedVehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a vehicle'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_selectedServiceType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a service type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        // Get driver ID with fallback
        final driverId = await _apiService.getDriverIdWithFallback();
        if (driverId == null) {
          throw Exception('Driver ID not found. Please log in again.');
        }
        
        // Combine date and time to create startAt (Instant)
        final startDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        
        // Assume 1-hour appointment duration
        final endDateTime = startDateTime.add(const Duration(hours: 1));
        
        // Convert to ISO 8601 format (Instant format)
        final startAt = startDateTime.toUtc().toIso8601String();
        final endAt = endDateTime.toUtc().toIso8601String();
        
        // Convert service type to backend enum value
        final backendServiceType = _serviceTypeMap[_selectedServiceType] ?? 'CUSTOM';
        
        // Prepare appointment data
        final appointmentData = {
          'workshopId': int.parse(widget.workshopId),
          'vehicleId': int.parse(_selectedVehicle!),
          'driverId': driverId,
          'startAt': startAt,
          'endAt': endAt,
          'serviceType': backendServiceType,
          'customServiceDescription': _notesController.text.trim().isEmpty 
              ? null 
              : _notesController.text.trim(),
        };
        
        print('📅 Creating appointment for workshop ${widget.workshopId}');
        print('📅 Appointment data: $appointmentData');
        
        // Create appointment
        final response = await _apiService.post(
          ApiConstants.appointmentsByDriver(int.parse(widget.workshopId), driverId).split('?')[0],
          appointmentData,
        );
        
        print('📅 Appointment response: ${response.statusCode}');
        print('📅 Appointment response body: ${response.body}');
        
        if (!mounted) return;
        
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment request sent!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create appointment: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'New Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Form content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Appointment Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Workshop info card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5C4FDB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF5C4FDB).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5C4FDB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.store,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Taller Seleccionado',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF5C4FDB),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.workshopName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Date field
                          const Text(
                            'Date*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'dd/mm/aaaa',
                              suffixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Hour field
                          const Text(
                            'Hour*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _hourController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'HH:MM',
                              suffixIcon: const Icon(Icons.access_time),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onTap: () => _selectTime(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          
                          // Vehicle selection
                          const Text(
                            'Vehicle*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _vehicles.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'You need to add a vehicle first. Go to Vehicles tab.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedVehicle,
                                  decoration: InputDecoration(
                                    hintText: 'Select vehicle',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  items: _vehicles.map((vehicle) {
                                    return DropdownMenuItem<String>(
                                      value: vehicle['id'],
                                      child: Text(vehicle['displayName']!),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedVehicle = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                          if (_selectedVehicle == null)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 12.0),
                              child: Text(
                                '(*) This field is required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          
                          // Service type dropdown
                          const Text(
                            'Type of service*',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedServiceType,
                            decoration: InputDecoration(
                              hintText: 'Select type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: _serviceTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedServiceType = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          if (_selectedServiceType == null)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 12.0),
                              child: Text(
                                '(*) This field is required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          
                          // Notes field
                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 4,
                            maxLength: 250,
                            decoration: InputDecoration(
                              hintText: 'Add additional notes here',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitAppointment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5C4FDB),
                                disabledBackgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Save appointment',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

