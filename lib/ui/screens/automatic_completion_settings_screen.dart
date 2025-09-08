import 'package:flutter/material.dart';
import '../../services/automatic_habit_completion_service.dart';

import '../../services/logging_service.dart';
import '../widgets/smart_threshold_settings.dart';

/// Automatic Completion Settings Screen
///
/// Comprehensive settings screen for all automatic habit completion features
class AutomaticCompletionSettingsScreen extends StatefulWidget {
  const AutomaticCompletionSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AutomaticCompletionSettingsScreen> createState() =>
      _AutomaticCompletionSettingsScreenState();
}

class _AutomaticCompletionSettingsScreenState
    extends State<AutomaticCompletionSettingsScreen> {
  bool _isLoading = true;
  bool _serviceEnabled = false;
  bool _realTimeEnabled = false;
  int _checkInterval = 30;
  Map<String, dynamic> _serviceStatus = {};
  Map<String, dynamic> _batteryStatus = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() => _isLoading = true);

      final serviceEnabled =
          await AutomaticHabitCompletionService.isServiceEnabled();
      final realTimeEnabled =
          await AutomaticHabitCompletionService.isRealTimeEnabled();
      final checkInterval =
          await AutomaticHabitCompletionService.getCheckIntervalMinutes();
      final serviceStatus =
          await AutomaticHabitCompletionService.getServiceStatus();
      final batteryStatus =
          await AutomaticHabitCompletionService.getBatteryOptimizationStatus();

      setState(() {
        _serviceEnabled = serviceEnabled;
        _realTimeEnabled = realTimeEnabled;
        _checkInterval = checkInterval;
        _serviceStatus = serviceStatus;
        _batteryStatus = batteryStatus;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading automatic completion settings', e);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleService(bool enabled) async {
    try {
      await AutomaticHabitCompletionService.setServiceEnabled(enabled);
      setState(() => _serviceEnabled = enabled);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Automatic completion service enabled!'
                : 'Automatic completion service disabled.',
          ),
          backgroundColor: enabled ? Colors.green : Colors.orange,
        ),
      );

      await _loadSettings();
    } catch (e) {
      AppLogger.error('Error toggling service', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleRealTime(bool enabled) async {
    try {
      await AutomaticHabitCompletionService.setRealTimeEnabled(enabled);
      setState(() => _realTimeEnabled = enabled);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Real-time monitoring enabled! More responsive but uses more battery.'
                : 'Real-time monitoring disabled. Battery optimized.',
          ),
          backgroundColor: enabled ? Colors.blue : Colors.green,
        ),
      );

      await _loadSettings();
    } catch (e) {
      AppLogger.error('Error toggling real-time monitoring', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating real-time monitoring: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateCheckInterval(int minutes) async {
    try {
      await AutomaticHabitCompletionService.setCheckIntervalMinutes(minutes);
      setState(() => _checkInterval = minutes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Check interval updated to $minutes minutes'),
          backgroundColor: Colors.blue,
        ),
      );

      await _loadSettings();
    } catch (e) {
      AppLogger.error('Error updating check interval', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating check interval: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _performManualCheck() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Performing manual check...'),
          backgroundColor: Colors.blue,
        ),
      );

      final result = await AutomaticHabitCompletionService.performManualCheck();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Manual check completed: ${result.completedHabits} habits completed'),
          backgroundColor: Colors.green,
        ),
      );

      await _loadSettings();
    } catch (e) {
      AppLogger.error('Error performing manual check', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Manual check failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatic Completion'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSettings,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildServiceStatusCard(),
                  const SizedBox(height: 16),
                  _buildMainSettingsCard(),
                  const SizedBox(height: 16),
                  const SmartThresholdSettings(),
                  const SizedBox(height: 16),
                  _buildBatteryOptimizationCard(),
                  const SizedBox(height: 16),
                  _buildActionsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildServiceStatusCard() {
    final isRunning = _serviceStatus['isRunning'] ?? false;
    final lastCheckDate = _serviceStatus['lastCheckDate'];
    final nextCheckTime = _serviceStatus['nextCheckTime'];
    final recentErrorCount = _serviceStatus['recentErrorCount'] ?? 0;
    final pendingCompletions = _serviceStatus['pendingCompletions'] ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRunning ? Icons.check_circle : Icons.error,
                  color: isRunning ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Service Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow('Status', isRunning ? 'Running' : 'Stopped',
                isRunning ? Colors.green : Colors.red),
            if (lastCheckDate != null)
              _buildStatusRow(
                  'Last Check', _formatDateTime(lastCheckDate), Colors.blue),
            if (nextCheckTime != null)
              _buildStatusRow(
                  'Next Check',
                  _formatDateTime(
                      DateTime.fromMillisecondsSinceEpoch(nextCheckTime)
                          .toIso8601String()),
                  Colors.blue),
            _buildStatusRow('Recent Errors', recentErrorCount.toString(),
                recentErrorCount > 0 ? Colors.orange : Colors.green),
            _buildStatusRow('Pending Completions',
                pendingCompletions.toString(), Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildMainSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Main Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Service Enable/Disable
            SwitchListTile(
              title: const Text('Enable Automatic Completion'),
              subtitle: const Text(
                  'Automatically complete habits based on health data'),
              value: _serviceEnabled,
              onChanged: _toggleService,
              secondary: const Icon(Icons.auto_awesome),
            ),

            if (_serviceEnabled) ...[
              const Divider(),

              // Real-time monitoring
              SwitchListTile(
                title: const Text('Real-time Monitoring'),
                subtitle: const Text('More responsive but uses more battery'),
                value: _realTimeEnabled,
                onChanged: _toggleRealTime,
                secondary: const Icon(Icons.sync),
              ),

              const Divider(),

              // Check interval
              ListTile(
                title: const Text('Check Interval'),
                subtitle: Text('Currently: $_checkInterval minutes'),
                trailing: const Icon(Icons.schedule),
                onTap: () => _showIntervalDialog(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryOptimizationCard() {
    final batteryScore = _batteryStatus['batteryScore'] ?? 0;
    final recommendations =
        List<String>.from(_batteryStatus['recommendations'] ?? []);
    final estimatedImpact =
        _batteryStatus['estimatedBatteryImpact'] ?? 'Unknown';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.battery_saver,
                  color: _getBatteryScoreColor(batteryScore),
                ),
                const SizedBox(width: 8),
                Text(
                  'Battery Optimization',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getBatteryScoreColor(batteryScore).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Score: $batteryScore/100',
                    style: TextStyle(
                      color: _getBatteryScoreColor(batteryScore),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow('Battery Impact', estimatedImpact,
                _getImpactColor(estimatedImpact)),
            const SizedBox(height: 12),
            if (recommendations.isNotEmpty) ...[
              Text(
                'Recommendations:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...recommendations.map((rec) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(rec,
                                style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _performManualCheck,
                icon: const Icon(Icons.refresh),
                label: const Text('Run Manual Check'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showIntervalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check Interval'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'How often should the system check for habit completions?'),
            const SizedBox(height: 16),
            ...([15, 30, 60, 120, 240].map((minutes) => RadioListTile<int>(
                  title: Text('$minutes minutes'),
                  subtitle: Text(_getIntervalDescription(minutes)),
                  value: minutes,
                  groupValue: _checkInterval,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    if (value != null) _updateCheckInterval(value);
                  },
                ))),
          ],
        ),
      ),
    );
  }

  String _getIntervalDescription(int minutes) {
    if (minutes <= 15) return 'High battery usage, very responsive';
    if (minutes <= 30) return 'Balanced battery and responsiveness';
    if (minutes <= 60) return 'Good battery life, moderate responsiveness';
    return 'Excellent battery life, lower responsiveness';
  }

  String _formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      return '${difference.inDays}d ago';
    } catch (e) {
      return 'Unknown';
    }
  }

  Color _getBatteryScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getImpactColor(String impact) {
    switch (impact.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
