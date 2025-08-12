import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import '../../data/database.dart';
import '../../services/health_habit_integration_service.dart';
import '../../services/health_habit_mapping_service.dart';
import '../../services/health_service.dart';
import '../../services/logging_service.dart';

/// Comprehensive Health-Habit Dashboard Widget
/// 
/// This widget provides a complete overview of health-habit integration
/// that can be embedded in any screen for quick access to key information.
class HealthHabitDashboardWidget extends ConsumerStatefulWidget {
  final bool showFullDetails;
  final VoidCallback? onTap;
  
  const HealthHabitDashboardWidget({
    super.key,
    this.showFullDetails = false,
    this.onTap,
  });

  @override
  ConsumerState<HealthHabitDashboardWidget> createState() => _HealthHabitDashboardWidgetState();
}

class _HealthHabitDashboardWidgetState extends ConsumerState<HealthHabitDashboardWidget> {
  bool _isLoading = false;
  Map<String, dynamic>? _integrationStatus;
  List<HabitCompletionResult>? _recentCompletions;
  Map<String, dynamic>? _todayHealthSummary;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildStatusIndicators(),
              if (widget.showFullDetails) ...[
                const SizedBox(height: 16),
                _buildDetailedView(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Health Integration',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Loading health integration status...'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hasPermissions = _integrationStatus?['healthPermissions'] ?? false;
    final autoCompletionEnabled = _integrationStatus?['autoCompletionEnabled'] ?? false;
    
    return Row(
      children: [
        Icon(
          Icons.health_and_safety,
          color: hasPermissions ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 8),
        const Text(
          'Health Integration',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Spacer(),
        if (hasPermissions && autoCompletionEnabled)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, size: 14, color: Colors.green.shade700),
                const SizedBox(width: 4),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        if (widget.onTap != null)
          const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildStatusIndicators() {
    final totalHabits = _integrationStatus?['totalHabits'] ?? 0;
    final mappedHabits = _integrationStatus?['healthMappedHabits'] ?? 0;
    final mappingPercentage = _integrationStatus?['mappingPercentage'] ?? 0;
    final hasPermissions = _integrationStatus?['healthPermissions'] ?? false;
    
    return Column(
      children: [
        // Quick stats row
        Row(
          children: [
            Expanded(
              child: _buildStatTile(
                'Mapped Habits',
                '$mappedHabits/$totalHabits',
                Icons.link,
                mappingPercentage > 50 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatTile(
                'Auto-Complete',
                '${mappingPercentage}%',
                Icons.auto_awesome,
                mappingPercentage > 0 ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Health permissions status
        if (!hasPermissions)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Health permissions needed for full integration',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _requestHealthPermissions,
                  child: const Text('Enable'),
                ),
              ],
            ),
          ),
        
        // Recent auto-completions
        if (_recentCompletions != null && _recentCompletions!.isNotEmpty)
          _buildRecentCompletions(),
        
        // Today's health summary
        if (_todayHealthSummary != null && _todayHealthSummary!.isNotEmpty)
          _buildTodayHealthSummary(),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCompletions() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              const Text(
                'Recent Auto-Completions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentCompletions!.take(3).map((completion) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 12, color: Colors.green),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    completion.habitName,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                if (completion.healthValue != null)
                  Text(
                    '${completion.healthValue!.round()}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTodayHealthSummary() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.today, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              const Text(
                'Today\'s Health Metrics',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _todayHealthSummary!.entries.map((entry) {
              final icon = _getHealthMetricIcon(entry.key);
              final value = _formatHealthValue(entry.key, entry.value);
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Health-Habit Mappings',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        
        if (_integrationStatus?['habitMappings'] != null) ...[
          ..._integrationStatus!['habitMappings'].entries.map((entry) {
            final habitData = entry.value as Map<String, dynamic>;
            final healthType = habitData['healthDataType'] as String?;
            final threshold = habitData['threshold'];
            final unit = habitData['unit'] as String?;
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    _getHealthDataTypeIcon(healthType),
                    size: 16,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      habitData['name'] as String,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  if (threshold != null && unit != null)
                    Text(
                      '${threshold.round()} $unit',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            );
          }),
        ] else ...[
          const Text(
            'No health-mapped habits found',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getHealthMetricIcon(String metric) {
    switch (metric.toLowerCase()) {
      case 'steps':
        return Icons.directions_walk;
      case 'active_energy_burned':
        return Icons.local_fire_department;
      case 'sleep_in_bed':
        return Icons.bedtime;
      case 'water':
        return Icons.water_drop;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'weight':
        return Icons.monitor_weight;
      default:
        return Icons.health_and_safety;
    }
  }

  IconData _getHealthDataTypeIcon(String? healthType) {
    if (healthType == null) return Icons.health_and_safety;
    
    switch (healthType.toUpperCase()) {
      case 'STEPS':
        return Icons.directions_walk;
      case 'ACTIVE_ENERGY_BURNED':
        return Icons.local_fire_department;
      case 'SLEEP_IN_BED':
        return Icons.bedtime;
      case 'WATER':
        return Icons.water_drop;
      case 'MINDFULNESS':
        return Icons.self_improvement;
      case 'WEIGHT':
        return Icons.monitor_weight;
      default:
        return Icons.health_and_safety;
    }
  }

  String _formatHealthValue(String metric, dynamic value) {
    if (value == null) return 'N/A';
    
    switch (metric.toLowerCase()) {
      case 'steps':
        return '${value.round()} steps';
      case 'active_energy_burned':
        return '${value.round()} cal';
      case 'sleep_in_bed':
        final hours = (value / 60.0);
        return '${hours.toStringAsFixed(1)}h';
      case 'water':
        final liters = (value / 1000.0);
        return '${liters.toStringAsFixed(1)}L';
      case 'mindfulness':
        return '${value.round()}min';
      case 'weight':
        return '${value.toStringAsFixed(1)}kg';
      default:
        return value.toString();
    }
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load integration status
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      
      _integrationStatus = await HealthHabitIntegrationService.getIntegrationStatus(
        habitService: habitService,
      );

      // Load recent completions (mock data for now)
      _recentCompletions = []; // Would load from actual sync results

      // Load today's health summary
      _todayHealthSummary = await HealthService.getTodayHealthSummary();

    } catch (e) {
      AppLogger.error('Error loading dashboard data', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestHealthPermissions() async {
    try {
      final granted = await HealthService.requestPermissions();
      
      if (granted) {
        // Reload dashboard data
        await _loadDashboardData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions granted! Integration is now active.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions are needed for automatic habit completion.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request permissions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Compact version of the health-habit dashboard for smaller spaces
class CompactHealthHabitDashboard extends StatelessWidget {
  final VoidCallback? onTap;
  
  const CompactHealthHabitDashboard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.health_and_safety,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Integration',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Auto-complete habits with health data',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}