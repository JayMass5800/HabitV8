import 'package:flutter/material.dart';
import '../../services/automatic_habit_completion_service.dart';
import '../../services/smart_threshold_service.dart';
import '../../services/logging_service.dart';

/// Smart Threshold Settings Widget
///
/// Provides UI for configuring and monitoring smart threshold functionality
class SmartThresholdSettings extends StatefulWidget {
  const SmartThresholdSettings({super.key});

  @override
  State<SmartThresholdSettings> createState() => _SmartThresholdSettingsState();
}

class _SmartThresholdSettingsState extends State<SmartThresholdSettings> {
  bool _isEnabled = false;
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      setState(() => _isLoading = true);

      final enabled =
          await AutomaticHabitCompletionService.isSmartThresholdsEnabled();
      final stats = await SmartThresholdService.getSmartThresholdStats();

      setState(() {
        _isEnabled = enabled;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading smart threshold settings', e);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleSmartThresholds(bool enabled) async {
    try {
      await AutomaticHabitCompletionService.setSmartThresholdsEnabled(enabled);
      setState(() => _isEnabled = enabled);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Smart thresholds enabled! The system will learn from your patterns.'
                : 'Smart thresholds disabled. Using fixed thresholds only.',
          ),
          backgroundColor: enabled ? Colors.green : Colors.orange,
        ),
      );

      // Reload stats after change
      await _loadSettings();
    } catch (e) {
      AppLogger.error('Error toggling smart thresholds', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating smart thresholds: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
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
                  Icons.psychology,
                  color: _isEnabled ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  'Smart Thresholds',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Switch(
                  value: _isEnabled,
                  onChanged: _toggleSmartThresholds,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Adaptive thresholds that learn from your behavior patterns to improve automatic habit completion accuracy.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            if (_isEnabled) ...[
              _buildStatsSection(),
              const SizedBox(height: 16),
              _buildBenefitsSection(),
            ] else ...[
              _buildDisabledInfo(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final totalHabits = _stats['totalHabits'] ?? 0;
    final habitsWithAdjustments = _stats['habitsWithAdjustments'] ?? 0;
    final totalAdjustments = _stats['totalAdjustments'] ?? 0;
    final averageConfidence = (_stats['averageConfidence'] ?? 0.0) as double;
    final totalLearningPoints = _stats['totalLearningPoints'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Statistics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Habits Tracked',
                totalHabits.toString(),
                Icons.track_changes,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Habits Optimized',
                habitsWithAdjustments.toString(),
                Icons.tune,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Adjustments',
                totalAdjustments.toString(),
                Icons.auto_fix_high,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                'Confidence',
                '${(averageConfidence * 100).round()}%',
                Icons.psychology,
                _getConfidenceColor(averageConfidence),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildStatCard(
          'Learning Data Points',
          totalLearningPoints.toString(),
          Icons.data_usage,
          Colors.purple,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How Smart Thresholds Help',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildBenefitItem(
          Icons.trending_up,
          'Adaptive Learning',
          'Thresholds adjust based on your actual activity patterns',
          Colors.blue,
        ),
        _buildBenefitItem(
          Icons.schedule,
          'Time-Aware',
          'Considers weekday vs weekend and time-of-day patterns',
          Colors.green,
        ),
        _buildBenefitItem(
          Icons.psychology,
          'Reduces False Positives',
          'Learns when auto-completion was incorrect',
          Colors.orange,
        ),
        _buildBenefitItem(
          Icons.battery_saver,
          'Battery Efficient',
          'Optimizes checking frequency based on accuracy',
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
      IconData icon, String title, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[600],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Smart Thresholds Disabled',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enable smart thresholds to let the system learn from your patterns and improve automatic habit completion accuracy over time.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _toggleSmartThresholds(true),
            icon: const Icon(Icons.psychology),
            label: const Text('Enable Smart Thresholds'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
}
