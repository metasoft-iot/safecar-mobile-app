import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/vehicles_bloc.dart';
import '../../application/vehicles_events.dart';
import '../../application/vehicles_states.dart';
import '../../domain/model/vehicle.entity.dart';

/// Screen showing vehicle insights with AI-powered recommendations
class VehicleStatusScreen extends StatefulWidget {
  const VehicleStatusScreen({super.key});

  @override
  State<VehicleStatusScreen> createState() => _VehicleStatusScreenState();
}

class _VehicleStatusScreenState extends State<VehicleStatusScreen> {
  List<Map<String, dynamic>> _vehicles = [];
  String? _selectedVehicleId;
  Map<String, dynamic>? _selectedVehicle;
  Map<String, dynamic>? _insights;
  List<Map<String, dynamic>> _recentTelemetry = [];
  
  bool _isLoading = true;
  bool _isGeneratingInsights = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    // Check if vehicles are already loaded
    final state = context.read<VehiclesStore>().state;
    if (state is VehiclesLoaded) {
      _onVehiclesLoaded(state.vehicles);
    } else {
      setState(() => _isLoading = true);
      context.read<VehiclesStore>().add(const LoadVehicles());
    }
  }

  void _onVehiclesLoaded(List<Vehicle> vehiclesList) {
    if (!mounted) return;
    
    setState(() {
      _vehicles = vehiclesList.map((v) => {
        'id': v.id.toString(),
        'brand': v.brand,
        'model': v.model,
        'licensePlate': v.licensePlate,
        'displayName': v.fullDisplayName,
      }).toList();
      
      _isLoading = false;
      
      if (_vehicles.isNotEmpty && _selectedVehicleId == null) {
        _selectedVehicleId = _vehicles.first['id'].toString();
        _selectedVehicle = _vehicles.first;
        
        // Load insights and telemetry for selected vehicle
        // These are async but we don't await them here to avoid blocking UI
        _loadInsights();
        _loadTelemetry();
      }
    });
  }
  
  Future<void> _loadTelemetry() async {
    if (_selectedVehicleId == null) return;
    
    try {
      context.read<VehiclesStore>().add(LoadTelemetry(vehicleId: int.parse(_selectedVehicleId!), limit: 5));
      
      // Wait for the state to be updated by listening to the stream
      await for (final state in context.read<VehiclesStore>().stream) {
        if (state is InsightsLoaded) {
          if (mounted) {
            setState(() {
              _recentTelemetry = state.telemetry.map((t) => {
                'id': t.id,
                'sample': t.sample,
                'ingestedAt': t.ingestedAt.toIso8601String(),
              }).toList();
              print('[VehicleStatusScreen] ✅ Loaded ${_recentTelemetry.length} telemetry records');
            });
          }
          break;
        } else if (state is VehiclesError) {
          print('[VehicleStatusScreen] ❌ Error loading telemetry: ${state.message}');
          break;
        }
      }
    } catch (e) {
      print('[VehicleStatusScreen] ❌ Error loading telemetry: $e');
    }
  }
  
  Future<void> _loadInsights() async {
    if (_selectedVehicleId == null) return;
    
    try {
      context.read<VehiclesStore>().add(LoadInsights(vehicleId: int.parse(_selectedVehicleId!)));
      
      // Wait for the state to be updated by listening to the stream
      await for (final state in context.read<VehiclesStore>().stream) {
        if (state is InsightsLoaded) {
          if (mounted) {
            setState(() {
              if (state.insights != null) {
                _insights = {
                  'id': state.insights!.id,
                  'vehicleId': state.insights!.vehicleId,
                  'riskLevel': state.insights!.riskLevel,
                  'drivingAlerts': state.insights!.drivingHabits?.alerts.join(', ') ?? '',
                  'maintenanceWindow': state.insights!.maintenancePrediction?.maintenanceWindow ?? '',
                  'drivingHabitsSummary': state.insights!.drivingHabits?.summary ?? '',
                  'drivingHabitsScore': state.insights!.drivingHabits?.score ?? 0,
                  'drivingHabitsAlerts': state.insights!.drivingHabits?.alerts ?? [],
                  'recommendations': state.insights!.recommendations.map((r) => {'title': r.title, 'detail': r.detail}).toList(),
                  'generatedAt': state.insights!.generatedAt.toIso8601String(),
                };
                print('[VehicleStatusScreen] ✅ Insights loaded successfully');
              } else {
                _insights = null;
                print('[VehicleStatusScreen] ℹ️ No insights found for vehicle $_selectedVehicleId');
              }
            });
          }
          break;
        } else if (state is VehiclesError) {
          print('[VehicleStatusScreen] ❌ Error loading insights: ${state.message}');
          break;
        }
      }
    } catch (e) {
      print('[VehicleStatusScreen] ❌ Error loading insights: $e');
    }
  }
  
  Future<void> _generateInsights() async {
    if (_selectedVehicleId == null || _isGeneratingInsights) return;
    
    setState(() => _isGeneratingInsights = true);
    
    try {
      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating insights with AI...'),
                  SizedBox(height: 8),
                  Text(
                    'This may take a few seconds',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Get latest telemetry ID and generate insights using BLoC
      context.read<VehiclesStore>().add(GenerateInsights(vehicleId: int.parse(_selectedVehicleId!)));
      
      // Wait for insights generation by listening to the stream
      await for (final state in context.read<VehiclesStore>().stream) {
        if (state is InsightsLoaded && state.insights != null) {
          final insights = state.insights!;
        
          if (!mounted) return;
          Navigator.of(context).pop(); // Close loading dialog
          
          setState(() {
            _insights = {
              'id': insights.id,
              'vehicleId': insights.vehicleId,
              'riskLevel': insights.riskLevel,
              'drivingAlerts': insights.drivingHabits?.alerts.join(', ') ?? '',
              'maintenanceWindow': insights.maintenancePrediction?.maintenanceWindow ?? '',
              'drivingHabitsSummary': insights.drivingHabits?.summary ?? '',
              'drivingHabitsScore': insights.drivingHabits?.score ?? 0,
              'drivingHabitsAlerts': insights.drivingHabits?.alerts ?? [],
              'recommendations': insights.recommendations.map((r) => {'title': r.title, 'detail': r.detail}).toList(),
              'generatedAt': insights.generatedAt.toIso8601String(),
            };
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Insights generated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          break;
        } else if (state is VehiclesError) {
          if (!mounted) return;
          Navigator.of(context).pop(); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to generate insights: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
          break;
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      // Check if error is about missing telemetry
      String errorMessage = 'Error al generar insights';
      if (e.toString().contains('No telemetry') || 
          e.toString().contains('No se encontraron datos de telemetría') ||
          e.toString().contains('404')) {
        errorMessage = 'No hay datos de telemetría disponibles para este vehículo. Por favor, agregue datos de telemetría primero.';
      } else {
        errorMessage = 'Error al generar insights: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() => _isGeneratingInsights = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehiclesStore, VehiclesState>(
      listener: (context, state) {
        if (state is VehiclesLoading) {
          setState(() => _isLoading = true);
        } else if (state is VehiclesLoaded) {
          _onVehiclesLoaded(state.vehicles);
        } else if (state is VehiclesError) {
          setState(() => _isLoading = false);
          // Optional: Show error in UI
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_vehicles.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No Vehicles Registered',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Add a vehicle first to see insights and recommendations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
              // Header with vehicle selector
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle selector dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedVehicleId,
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: const Color(0xFF5C4FDB),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        items: _vehicles.map((vehicle) {
                          return DropdownMenuItem<String>(
                            value: vehicle['id'],
                            child: Text(vehicle['displayName']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedVehicleId = newValue;
                            _selectedVehicle = _vehicles.firstWhere((v) => v['id'].toString() == newValue);
                            _insights = null; // Clear current insights
                            _recentTelemetry = []; // Clear telemetry
                          });
                          // Load insights and telemetry for new vehicle
                          Future.wait([
                            _loadInsights(),
                            _loadTelemetry(),
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle Overview Section
                        _buildVehicleOverview(),
                        const SizedBox(height: 24),
                        
                        // Recent Telemetry Section
                        _buildRecentTelemetry(),
                        const SizedBox(height: 24),
                        
                        // AI Insights Section
                        _insights != null
                            ? _buildInsightsSection()
                            : _buildNoInsightsSection(),
                      ],
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

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'CRITICAL':
        return Colors.red;
      case 'HIGH':
        return Colors.orange;
      case 'MEDIUM':
        return Colors.yellow.shade700;
      case 'LOW':
      case 'BAJO':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.yellow.shade700;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }
  
  // New methods for Vehicle Overview and Recent Telemetry
  Widget _buildVehicleOverview() {
    if (_selectedVehicle == null) return const SizedBox.shrink();
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: const Color(0xFF5C4FDB)),
                const SizedBox(width: 8),
                const Text(
                  'Vehicle Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Brand', _selectedVehicle!['brand'] ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow('Model', _selectedVehicle!['model'] ?? 'N/A'),
            const SizedBox(height: 12),
            _buildInfoRow('License Plate', _selectedVehicle!['licensePlate'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecentTelemetry() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: const Color(0xFF5C4FDB)),
                const SizedBox(width: 8),
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_recentTelemetry.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No telemetry data available',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              )
            else
              ..._recentTelemetry.map((telemetry) => _buildTelemetryItem(telemetry)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTelemetryItem(Map<String, dynamic> telemetry) {
    final sample = telemetry['sample'] as Map<String, dynamic>?;
    if (sample == null) return const SizedBox.shrink();
    
    final type = sample['type'] ?? 'UNKNOWN';
    final severity = sample['severity'] ?? 'INFO';
    final timestamp = telemetry['ingestedAt'] as String?;
    
    Color severityColor;
    IconData severityIcon;
    
    switch (severity) {
      case 'CRITICAL':
        severityColor = Colors.red;
        severityIcon = Icons.error;
        break;
      case 'WARNING':
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        break;
      default:
        severityColor = Colors.blue;
        severityIcon = Icons.info;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(severityIcon, color: severityColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.replaceAll('_', ' '),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (timestamp != null)
                  Text(
                    _formatTimestamp(timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              severity,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: severityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dt);
      
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }
  
  Widget _buildNoInsightsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No AI Insights Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate AI-powered insights for personalized recommendations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isGeneratingInsights ? null : _generateInsights,
              icon: _isGeneratingInsights
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isGeneratingInsights ? 'Generating...' : 'Generate Insights'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C4FDB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInsightsSection() {
    final riskLevel = _insights!['riskLevel'] ?? 'UNKNOWN';
    final maintenanceWindow = _insights!['maintenanceWindow'] ?? '';
    final drivingScore = _insights!['drivingScore'] ?? 0;
    final recommendations = _insights!['recommendations'] as List?;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: const Color(0xFF5C4FDB)),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Insights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _isGeneratingInsights ? null : _generateInsights,
                  icon: _isGeneratingInsights
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  tooltip: 'Refresh Insights',
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Risk Level
            _buildInsightRow('Risk Level', riskLevel, _getRiskColor(riskLevel)),
            const SizedBox(height: 16),
            
            // Driving Score
            _buildInsightRow('Driving Score', '$drivingScore/100', _getScoreColor(drivingScore)),
            const SizedBox(height: 16),
            
            // Maintenance Window
            if (maintenanceWindow.isNotEmpty) ...[
              Text(
                'Maintenance Window',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                maintenanceWindow,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
              const SizedBox(height: 16),
            ],
            
            // Recommendations
            if (recommendations != null && recommendations.isNotEmpty) ...[
              const Divider(height: 24),
              const Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...recommendations.asMap().entries.map((entry) {
                final recommendation = entry.value;
                final title = recommendation is Map ? recommendation['title'] ?? '' : recommendation.toString();
                final detail = recommendation is Map ? recommendation['detail'] ?? '' : '';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5C4FDB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (detail.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                detail,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildInsightRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}
