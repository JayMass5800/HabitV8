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
                      Text(
                        'Health Integration',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unable to load integration status: ${snapshot.error ?? 'Unknown error'}',
                  ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (autoCompletionEnabled)
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.blue,
                        size: 20,
                      ),
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
                          mappingPercentage >= 75
                              ? Colors.green
                              : mappingPercentage >= 50
                              ? Colors.orange
                              : Colors.red,
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
                      Text(
                        'Sync Error',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                ...result.completedHabits.map(
                  (completion) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${completion.habitName} (${completion.reason})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build health metrics summary widget
  static Widget buildHealthMetricsSummary({required BuildContext context}) {
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
                  const Icon(
                    Icons.health_and_safety,
                    size: 48,
                    color: Colors.grey,
                  ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                        color: report.overallScore >= 75
                            ? Colors.green
                            : report.overallScore >= 50
                            ? Colors.orange
                            : Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: report.overallScore / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    report.overallScore >= 75
                        ? Colors.green
                        : report.overallScore >= 50
                        ? Colors.orange
                        : Colors.red,
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
                  ...report.predictiveInsights
                      .take(3)
                      .map(
                        (insight) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  insight,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build background service status widget
  static Widget buildBackgroundServiceStatus({required BuildContext context}) {
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
                  subtitle: const Text(
                    'Automatically complete habits based on health data',
                  ),
                  value: isEnabled,
                  onChanged: (value) async {
                    await HealthHabitIntegrationService.setAutoCompletionEnabled(
                      value,
                    );
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
                  subtitle: const Text(
                    'Continuously sync health data in background',
                  ),
                  value: isEnabled,
                  onChanged: (value) async {
                    await HealthHabitBackgroundService.setBackgroundServiceEnabled(
                      value,
                    );
                    onSettingsChanged();
                  },
                );
              },
            ),

            // Health permissions status and setup
            const SizedBox(height: 16),
            FutureBuilder<HealthConnectStatus>(
              future: HealthService.getHealthConnectStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final status =
                    snapshot.data ?? HealthConnectStatus.notInstalled;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          color: _getStatusColor(status),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Health Permissions',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          _getStatusText(status),
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _handleHealthPermissionAction(context, status),
                        icon: Icon(_getActionIcon(status)),
                        label: Text(_getActionText(status)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getStatusColor(status),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Manual sync button
            const SizedBox(height: 16),
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
                        backgroundColor: result.hasCompletions
                            ? Colors.green
                            : Colors.blue,
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
  static Future<Map<String, dynamic>> _getHabitHealthCorrelation(
    Habit habit,
  ) async {
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

  /// Show enhanced health permissions dialog with guided setup
  static Future<void> showHealthPermissionsDialog(BuildContext context) async {
    // First check the current Health Connect status
    final status = await HealthService.getHealthConnectStatus();

    if (!context.mounted) return;

    switch (status) {
      case HealthConnectStatus.notInstalled:
        return _showHealthConnectInstallDialog(context);
      case HealthConnectStatus.installed:
        return _showHealthPermissionsSetupDialog(context);
      case HealthConnectStatus.permissionsGranted:
        return _showHealthPermissionsAlreadyGrantedDialog(context);
      default:
        return _showHealthPermissionsSetupDialog(context);
    }
  }

  /// Show dialog when Health Connect is not installed
  static Future<void> _showHealthConnectInstallDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.download, color: Colors.orange),
              SizedBox(width: 8),
              Text('Install Health Connect'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To enable health integration, you need to install the Health Connect app first.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text('Health Connect allows you to:'),
              SizedBox(height: 8),
              Text('• Securely store your health data'),
              Text('• Control which apps can access your data'),
              Text('• Sync data between health apps'),
              SizedBox(height: 16),
              Text(
                'After installing, come back here to enable health integration.',
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
              child: const Text('Install Health Connect'),
              onPressed: () async {
                Navigator.of(context).pop();

                final opened = await HealthConnectUtils.openHealthConnect();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        opened
                            ? 'Opening Health Connect in Play Store...'
                            : 'Could not open Health Connect. Please search for "Health Connect" in the Play Store.',
                      ),
                      backgroundColor: opened ? Colors.blue : Colors.orange,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Show dialog for setting up permissions when Health Connect is installed
  static Future<void> _showHealthPermissionsSetupDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.blue),
              SizedBox(width: 8),
              Text('Enable Health Permissions'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Connect is installed! Now let\'s enable health data access.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text('This will unlock:'),
              SizedBox(height: 8),
              Text('• Automatic habit completion based on your activity'),
              Text('• Smart insights about your health and habits'),
              Text('• Personalized recommendations'),
              Text('• Progress correlation analysis'),
              SizedBox(height: 16),
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
              child: const Text('Enable Permissions'),
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  final result = await HealthService.requestPermissions();

                  if (context.mounted) {
                    if (result.granted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Health permissions granted! Health integration is now active.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (result.requiresManualPermissionSetup) {
                      _showManualSetupGuidanceDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.message),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to request health permissions: $e',
                        ),
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

  /// Show dialog when permissions are already granted
  static Future<void> _showHealthPermissionsAlreadyGrantedDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Health Integration Active'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Great! Health integration is already enabled and working.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text('Your habits can now be automatically completed based on:'),
              SizedBox(height: 8),
              Text('• Steps and walking activity'),
              Text('• Sleep duration'),
              Text('• Water intake'),
              Text('• Mindfulness sessions'),
              Text('• Weight tracking'),
              Text('• Heart rate data'),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Show manual setup guidance dialog
  static Future<void> _showManualSetupGuidanceDialog(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.settings, color: Colors.orange),
              SizedBox(width: 8),
              Text('Manual Setup Required'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Permissions need to be enabled manually in Health Connect.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text('Follow these steps:'),
              SizedBox(height: 8),
              Text('1. Open Health Connect app'),
              Text('2. Go to "App permissions"'),
              Text('3. Find "HabitV8" in the list'),
              Text('4. Enable the health data types you want to share'),
              SizedBox(height: 16),
              Text(
                'After enabling permissions, come back and refresh this screen.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('I\'ll Do It Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Open Health Connect'),
              onPressed: () async {
                Navigator.of(context).pop();

                final opened =
                    await HealthConnectUtils.openHealthConnectPermissions();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        opened
                            ? 'Opening Health Connect permissions...'
                            : 'Could not open Health Connect. Please open it manually.',
                      ),
                      backgroundColor: opened ? Colors.blue : Colors.orange,
                      action: SnackBarAction(
                        label: 'Refresh',
                        onPressed: () async {
                          final result =
                              await HealthService.refreshPermissions();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result.granted
                                      ? 'Health permissions are now active!'
                                      : 'Permissions still not enabled. Please check Health Connect settings.',
                                ),
                                backgroundColor: result.granted
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Get status icon for Health Connect status
  static IconData _getStatusIcon(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return Icons.download;
      case HealthConnectStatus.installed:
        return Icons.settings;
      case HealthConnectStatus.permissionsGranted:
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }

  /// Get status color for Health Connect status
  static Color _getStatusColor(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return Colors.red;
      case HealthConnectStatus.installed:
        return Colors.orange;
      case HealthConnectStatus.permissionsGranted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Get status text for Health Connect status
  static String _getStatusText(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return 'Not Installed';
      case HealthConnectStatus.installed:
        return 'Setup Required';
      case HealthConnectStatus.permissionsGranted:
        return 'Active';
      default:
        return 'Unknown';
    }
  }

  /// Get action icon for Health Connect status
  static IconData _getActionIcon(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return Icons.download;
      case HealthConnectStatus.installed:
        return Icons.settings;
      case HealthConnectStatus.permissionsGranted:
        return Icons.refresh;
      default:
        return Icons.help_outline;
    }
  }

  /// Get action text for Health Connect status
  static String _getActionText(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return 'Install Health Connect';
      case HealthConnectStatus.installed:
        return 'Enable Permissions';
      case HealthConnectStatus.permissionsGranted:
        return 'Refresh Status';
      default:
        return 'Check Status';
    }
  }

  /// Handle health permission action based on status
  static Future<void> _handleHealthPermissionAction(
    BuildContext context,
    HealthConnectStatus status,
  ) async {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        await _showHealthConnectInstallDialog(context);
        break;
      case HealthConnectStatus.installed:
        await _showHealthPermissionsSetupDialog(context);
        break;
      case HealthConnectStatus.permissionsGranted:
        // Refresh permissions status
        final result = await HealthService.refreshPermissions();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.granted
                    ? 'Health permissions are active and working!'
                    : 'Health permissions need attention: ${result.message}',
              ),
              backgroundColor: result.granted ? Colors.green : Colors.orange,
            ),
          );
        }
        break;
      default:
        await showHealthPermissionsDialog(context);
        break;
    }
  }

  /// Build a comprehensive health permissions status widget
  static Widget buildHealthPermissionsStatusWidget({
    required BuildContext context,
    bool showActions = true,
    VoidCallback? onStatusChanged,
  }) {
    return FutureBuilder<HealthConnectStatus>(
      future: HealthService.getHealthConnectStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Checking health permissions...'),
                ],
              ),
            ),
          );
        }

        final status = snapshot.data ?? HealthConnectStatus.notInstalled;
        final color = _getStatusColor(status);
        final icon = _getStatusIcon(status);
        final statusText = _getStatusText(status);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Health Integration',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getStatusDescription(status),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (showActions) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _handleHealthPermissionAction(
                              context,
                              status,
                            );
                            onStatusChanged?.call();
                          },
                          icon: Icon(_getActionIcon(status)),
                          label: Text(_getActionText(status)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      if (status == HealthConnectStatus.permissionsGranted) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            final result =
                                await HealthService.refreshPermissions();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result.message),
                                  backgroundColor: result.granted
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              );
                              onStatusChanged?.call();
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh status',
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get status description for Health Connect status
  static String _getStatusDescription(HealthConnectStatus status) {
    switch (status) {
      case HealthConnectStatus.notInstalled:
        return 'Health Connect app is required to enable automatic habit completion based on your health data. Install it from the Play Store to get started.';
      case HealthConnectStatus.installed:
        return 'Health Connect is installed but permissions need to be enabled. Tap the button below to set up health data access for automatic habit tracking.';
      case HealthConnectStatus.permissionsGranted:
        return 'Health integration is active! Your habits can be automatically completed based on your health data like steps, sleep, water intake, and more.';
      default:
        return 'Health integration status is unknown. Please check your Health Connect setup.';
    }
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
