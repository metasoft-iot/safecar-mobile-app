import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/application/auth_bloc.dart';
import '../../../auth/application/auth_state.dart';
import '../../../../core/services/vehicle_service.dart';
import '../../../../core/services/insights_service.dart';
import 'package:intl/intl.dart';

/// Dashboard screen - Main screen showing summary and quick actions
class DashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  
  const DashboardScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _vehicleService = VehicleService();
  final _insightsService = InsightsService();
  
  int _totalVehicles = 0;
  String? _lastAlert;
  String? _lastAlertTime;
  String? _nextService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final driverId = prefs.getInt('driver_id');
      
      if (driverId == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Load vehicles
      final vehicles = await _vehicleService.getVehicles();
      setState(() {
        _totalVehicles = vehicles.length;
      });

      // If there are vehicles, get insights for the first one
      if (vehicles.isNotEmpty) {
        final vehicleId = vehicles.first['id'] as int;
        
        // Try to get insights
        final telemetryId = await _insightsService.getLatestTelemetryId(vehicleId);
        if (telemetryId != null) {
          // Try to get insights
          final insights = await _insightsService.getVehicleInsights(vehicleId);
          if (insights != null) {
            setState(() {
              _lastAlert = insights['drivingAlerts'] ?? 'No alerts';
              final generatedAt = DateTime.parse(insights['generatedAt']);
              _lastAlertTime = DateFormat('MMM d, h:mm a').format(generatedAt.toLocal());
              _nextService = insights['maintenanceWindow'] ?? 'Not available';
            });
          }
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient
          Container(
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
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String userName = "User";
                        if (state is AuthAuthenticated) {
                          userName = state.user.username.split('@').first;
                        }
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, $userName!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Welcome back',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content with white background
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Actions Section
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Quick action buttons - 2x2 grid
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.directions_car,
                            label: 'Vehicle Status',
                            color: const Color(0xFF5C4FDB),
                            onTap: () => widget.onNavigateToTab?.call(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.calendar_today,
                            label: 'Appointments',
                            color: const Color(0xFFFF6B6B),
                            onTap: () => widget.onNavigateToTab?.call(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.store,
                            label: 'Workshops',
                            color: const Color(0xFF4ECDC4),
                            onTap: () => widget.onNavigateToTab?.call(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.garage,
                            label: 'My Vehicles',
                            color: const Color(0xFFFFA726),
                            badge: _totalVehicles > 0 ? _totalVehicles.toString() : null,
                            onTap: () => widget.onNavigateToTab?.call(1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // General Summary Section
                    const Text(
                      'General Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last alert received
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              _SummaryCard(
                                title: 'Total Vehicles',
                                content: _totalVehicles > 0 ? '$_totalVehicles Vehicle${_totalVehicles > 1 ? 's' : ''}' : 'No vehicles',
                                subtitle: _totalVehicles > 0 ? 'Registered in your account' : 'Add your first vehicle',
                                icon: Icons.garage_rounded,
                                iconColor: const Color(0xFFFFA726),
                                backgroundColor: Colors.orange.shade50,
                              ),
                              const SizedBox(height: 12),
                              _SummaryCard(
                                title: 'Last Alert',
                                content: _lastAlert ?? 'No alerts available',
                                subtitle: _lastAlertTime ?? 'Check vehicle status',
                                icon: Icons.warning_amber_rounded,
                                iconColor: _lastAlert != null && _lastAlert != 'No alerts' ? Colors.orange : Colors.grey,
                                backgroundColor: _lastAlert != null && _lastAlert != 'No alerts' 
                                    ? Colors.orange.shade50 
                                    : Colors.grey.shade50,
                              ),
                              const SizedBox(height: 12),
                              _SummaryCard(
                                title: 'Next Service',
                                content: _nextService ?? 'Not available',
                                subtitle: 'Based on AI insights',
                                icon: Icons.build_circle_rounded,
                                iconColor: Colors.green,
                                backgroundColor: Colors.green.shade50,
                              ),
                            ],
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: color,
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.1,
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

class _SummaryCard extends StatelessWidget {
  final String title;
  final String content;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _SummaryCard({
    required this.title,
    required this.content,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
