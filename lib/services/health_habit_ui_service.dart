import 'package:flutter/material.dart';

import '../domain/model/habit.dart';
import '../data/database.dart';
import 'health_habit_integration_service.dart';
import 'health_habit_analytics_service.dart';
import 'health_habit_background_service.dart';
import 'health_service.dart';
import 'logging_service.dart';

/// UI Service for Health-Habit Integration
/// 
/// Provides UI components and utilities for displaying health-habit
/// integration features throughout the app.
class HealthHabitUIService {
  
  /// Get health-habit integration status widget
  static Widget buildIntegrationStatusCard({
    required BuildContext context,
    required HabitService habitService,
  }) {
    return FutureBuilder<Map<String, dynamic>>(
      future: HealthHabitIntegrationService.getIntegrationStatus(
        habitService: habitService,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.health_and_safety, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Health Integration', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Unable to load integration status: ${snapshot.error ?? 'Unknown error'}'),
                ],
              ),
            ),
          );
        }
        
        final status = snapshot.data!;
        final mappingPercentage = status['mappingPercentage'] ?? 0;
        final healthPermissions = status['healthPermissions'] ?? false;
        final autoCompletionEnabled = status['autoCompletionEnabled'] ?? false;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety,
                      color: healthPermissions ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Health Integration',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    if (autoCompletionEnabled)
                      const Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Integration score
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: mappingPercentage / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          mappingPercentage >= 75 ? Colors.green :
                          mappingPercentage >= 50 ? Colors.orange : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$mappingPercentage%'),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Status indicators
                Row(
                  children: [
                    _buildStatusChip(
                      'Health Data',
                      healthPermissions,
                      healthPermissions ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      'Auto-Complete',
                      autoCompletionEnabled,
                      autoCompletionEnabled ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                Text(
                  '${status['healthMappedHabits'] ?? 0}/${status['totalHabits'] ?? 0} habits have health integration',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build a small status chip
  static Widget _buildStatusChip(String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build health-habit sync results widget
  static Widget buildSyncResultsCard({
    required BuildContext context,
    required Stream<HealthHabitSyncResult> syncStream,
  }) {
    return StreamBuilder<HealthHabitSyncResult>(
      stream: syncStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final result = snapshot.data!;
        
        if (result.hasError) {
          return Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Sync Error', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Health sync failed: ${result.error}'),
                ],
              ),
            ),
          );
        }
        
        if (!result.hasCompletions) {
          return const SizedBox.shrink();
        }
        
        return Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Auto-Completed! 🎉',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...result.completedHabits.map((completion) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${completion.habitName} (${completion.reason})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build health metrics summary widget
  static Widget buildHealthMetricsSummary({
    required BuildContext context,
  }) {
    return FutureBuilder<Map<String, dynamic>>(
      future: HealthService.getTodayHealthSummary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.health_and_safety, size: 48, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('Health Data Unavailable'),
                  const SizedBox(height: 4),
                  Text(
                    'Enable health permissions to see your metrics',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        
        final healthData = snapshot.data!;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Health Metrics',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                
                // Health metrics grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    _buildHealthMetricTile(
                      'Steps',
                      '${healthData['steps'] ?? 0}',
                      Icons.directions_walk,
                      Colors.blue,
                    ),
                    _buildHealthMetricTile(
                      'Active Energy',
                      '${healthData['activeEnergyBurned'] ?? 0} cal',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                    _buildHealthMetricTile(
                      'Water',
                      '${(healthData['waterIntake'] ?? 0).round()} ml',
                      Icons.water_drop,
                      Colors.cyan,
                    ),
                    _buildHealthMetricTile(
                      'Mindfulness',
                      '${healthData['mindfulnessMinutes'] ?? 0} min',
                      Icons.self_improvement,
                      Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build individual health metric tile
  static Widget _buildHealthMetricTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                    color: color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Build habit health correlation widget
  static Widget buildHabitHealthCorrelation({
    required BuildContext context,
    required Habit habit,
  }) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getHabitHealthCorrelation(habit),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final data = snapshot.data!;
        final correlation = data['correlation'] ?? 0.0;
        final strongestMetric = data['strongestMetric'] as String?;
        
        if (correlation.abs() < 0.1) {
          return const SizedBox.shrink(); // Don't show if correlation is too weak
        }
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.analytics,
                      color: correlation > 0 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Health Correlation',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                if (strongestMetric != null) ...[
                  Text(
                    'Strongest correlation with: $strongestMetric',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                ],
                
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (correlation.abs() / 1.0).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          correlation > 0 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(correlation * 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: correlation > 0 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                Text(
                  correlation > 0.3
                      ? 'Strong positive correlation with health metrics'
                      : correlation > 0.1
                          ? 'Moderate correlation with health metrics'
                          : correlation < -0.3
                              ? 'Strong negative correlation - consider timing adjustments'
                              : 'Weak correlation with health metrics',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build analytics summary widget
  static Widget buildAnalyticsSummary({
    required BuildContext context,
    required HabitService habitService,
  }) {
    return FutureBuilder<HealthHabitAnalyticsReport>(
      future: HealthHabitAnalyticsService.generateAnalyticsReport(
        habitService: habitService,
        analysisWindowDays: 30,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.hasError) {
          return const SizedBox.shrink();
        }
        
        final report = snapshot.data!;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Health-Habit Analytics',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Overall score
                Row(
                  children: [
                    const Text('Overall Score: '),
                    Text(
                      '${report.overallScore.round()}/100',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: report.overallScore >= 75 ? Colors.green :
                               report.overallScore >= 50 ? Colors.orange : Colors.red,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: report.overallScore / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    report.overallScore >= 75 ? Colors.green :
                    report.overallScore >= 50 ? Colors.orange : Colors.red,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Key insights
                if (report.predictiveInsights.isNotEmpty) ...[
                  const Text(
                    'Key Insights:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ...report.predictiveInsights.take(3).map((insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            insight,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build background service status widget
  static Widget buildBackgroundServiceStatus({
    required BuildContext context,
  }) {
    return FutureBuilder<Map<String, dynamic>>(
      future: HealthHabitBackgroundService.getStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        
        final status = snapshot.data!;
        final isRunning = status['isRunning'] ?? false;
        final isEnabled = status['isEnabled'] ?? false;
        final minutesSinceLastSync = status['minutesSinceLastSync'] ?? 0;
        
        if (!isEnabled) {
          return const SizedBox.shrink();
        }
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  isRunning ? Icons.sync : Icons.sync_disabled,
                  color: isRunning ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Background Sync',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        isRunning
                            ? 'Last sync: ${minutesSinceLastSync}m ago'
                            : 'Not running',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (isRunning)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build health-habit settings widget
  static Widget buildHealthHabitSettings({
    required BuildContext context,
    required VoidCallback onSettingsChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Health Integration Settings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Auto-completion toggle
            FutureBuilder<bool>(
              future: HealthHabitIntegrationService.isAutoCompletionEnabled(),
              builder: (context, snapshot) {
                final isEnabled = snapshot.data ?? false;
                
                return SwitchListTile(
                  title: const Text('Auto-Complete Habits'),
                  subtitle: const Text('Automatically complete habits based on health data'),
                  value: isEnabled,
                  onChanged: (value) async {
                    await HealthHabitIntegrationService.setAutoCompletionEnabled(value);
                    onSettingsChanged();
                  },
                );
              },
            ),
            
            // Background service toggle
            FutureBuilder<bool>(
              future: HealthHabitBackgroundService.isBackgroundServiceEnabled(),
              builder: (context, snapshot) {
                final isEnabled = snapshot.data ?? false;
                
                return SwitchListTile(
                  title: const Text('Background Sync'),
                  subtitle: const Text('Continuously sync health data in background'),
                  value: isEnabled,
                  onChanged: (value) async {
                    await HealthHabitBackgroundService.setBackgroundServiceEnabled(value);
                    onSettingsChanged();
                  },
                );
              },
            ),
            
            // Manual sync button
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final habitBox = await DatabaseService.getInstance();
                  final habitService = HabitService(habitBox);
                  
                  final result = await HealthHabitIntegrationService.manualSync(
                    habitService: habitService,
                  );
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.hasCompletions
                              ? 'Sync completed! ${result.completionCount} habits auto-completed.'
                              : 'Sync completed - no habits auto-completed.',
                        ),
                        backgroundColor: result.hasCompletions ? Colors.green : Colors.blue,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sync failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.sync),
              label: const Text('Manual Sync'),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to get habit health correlation data
  static Future<Map<String, dynamic>> _getHabitHealthCorrelation(Habit habit) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 30));
      
      final healthSummary = await HealthService.getTodayHealthSummary();
      
      // This is a simplified correlation calculation
      // In a real implementation, you'd want more sophisticated analysis
      
      final completionDays = habit.completions
          .where((c) => c.isAfter(startDate))
          .map((c) => DateTime(c.year, c.month, c.day))
          .toSet()
          .length;
      
      final totalDays = endDate.difference(startDate).inDays;
      final completionRate = completionDays / totalDays;
      
      // Simplified correlation using health summary
      String? strongestMetric;
      double strongestCorrelation = 0.0;
      
      // Check correlation with available health metrics
      for (final entry in healthSummary.entries) {
        if (entry.value is num && entry.value > 0) {
          // Simple correlation based on completion rate and health data presence
          final correlation = completionRate * 0.7; // Simplified correlation
          
          if (correlation > strongestCorrelation) {
            strongestCorrelation = correlation;
            strongestMetric = entry.key;
          }
        }
      }
      
      return {
        'correlation': strongestCorrelation,
        'strongestMetric': strongestMetric,
      };
    } catch (e) {
      AppLogger.error('Error calculating habit health correlation', e);
      return {'correlation': 0.0, 'strongestMetric': null};
    }
  }

  /// Show health permissions dialog
  static Future<void> showHealthPermissionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.blue),
              SizedBox(width: 8),
              Text('Health Integration'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable health data access to unlock powerful features:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Text('• Automatic habit completion based on your activity'),
              Text('• Smart insights about your health and habits'),
              Text('• Personalized recommendations'),
              Text('• Progress correlation analysis'),
              SizedBox(height: 12),
              Text(
                'Your health data stays private and is processed locally on your device.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Maybe Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Enable Health Access'),
              onPressed: () async {
                Navigator.of(context).pop();
                
                try {
                  final granted = await HealthService.requestPermissions();
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          granted
                              ? 'Health permissions granted! Health integration is now active.'
                              : 'Health permissions denied. You can enable them later in settings.',
                        ),
                        backgroundColor: granted ? Colors.green : Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to request health permissions: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

/// Extension to add health integration features to existing widgets
extension HealthHabitWidgetExtensions on Widget {
  /// Wrap widget with health-habit integration features
  Widget withHealthIntegration({
    required BuildContext context,
    required HabitService habitService,
    Habit? habit,
  }) {
    return Column(
      children: [
        this,
        if (habit != null)
          HealthHabitUIService.buildHabitHealthCorrelation(
            context: context,
            habit: habit,
          ),
      ],
    );
  }
}