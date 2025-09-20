import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/widget_integration_service.dart';

class WidgetConfigurationScreen extends StatefulWidget {
  const WidgetConfigurationScreen({super.key});

  @override
  State<WidgetConfigurationScreen> createState() =>
      _WidgetConfigurationScreenState();
}

class _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {
  bool _autoRefresh = true;
  int _maxHabitsShown = 5;
  bool _showCompletedHabits = false;
  bool _showNextHabit = true;
  int _refreshInterval = 15; // minutes
  bool _enableHapticFeedback = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() async {
    // Load current widget preferences from SharedPreferences
    // This would typically use a preferences service
    setState(() {
      // Set default values for now
      _autoRefresh = true;
      _maxHabitsShown = 5;
      _showCompletedHabits = false;
      _showNextHabit = true;
      _refreshInterval = 15;
      _enableHapticFeedback = true;
    });
  }

  void _saveSettings() async {
    // Save preferences and update widgets
    try {
      // This would typically save to SharedPreferences
      await WidgetIntegrationService.instance.updateAllWidgets();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Widget settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Settings'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'Save Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget Preview
            _buildPreviewSection(theme),
            const SizedBox(height: 24),

            // Display Settings
            _buildDisplaySettings(theme),
            const SizedBox(height: 24),

            // Behavior Settings
            _buildBehaviorSettings(theme),
            const SizedBox(height: 24),

            // Advanced Settings
            _buildAdvancedSettings(theme),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Widget Preview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.widgets,
                      size: 32,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Widget Preview',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Showing $_maxHabitsShown habits',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
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
  }

  Widget _buildDisplaySettings(ThemeData theme) {
    return _buildSettingsSection(
      theme: theme,
      title: 'Display Settings',
      icon: Icons.display_settings,
      children: [
        _buildSliderSetting(
          theme: theme,
          title: 'Maximum Habits Shown',
          subtitle: 'Number of habits displayed in widget',
          value: _maxHabitsShown.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: (value) {
            setState(() {
              _maxHabitsShown = value.round();
            });
          },
          displayValue: _maxHabitsShown.toString(),
        ),
        _buildSwitchSetting(
          theme: theme,
          title: 'Show Next Habit',
          subtitle: 'Highlight the next upcoming habit',
          value: _showNextHabit,
          onChanged: (value) {
            setState(() {
              _showNextHabit = value;
            });
          },
        ),
        _buildSwitchSetting(
          theme: theme,
          title: 'Show Completed Habits',
          subtitle: 'Include completed habits in widget',
          value: _showCompletedHabits,
          onChanged: (value) {
            setState(() {
              _showCompletedHabits = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBehaviorSettings(ThemeData theme) {
    return _buildSettingsSection(
      theme: theme,
      title: 'Behavior Settings',
      icon: Icons.settings,
      children: [
        _buildSwitchSetting(
          theme: theme,
          title: 'Auto Refresh',
          subtitle: 'Automatically update widget content',
          value: _autoRefresh,
          onChanged: (value) {
            setState(() {
              _autoRefresh = value;
            });
          },
        ),
        if (_autoRefresh)
          _buildSliderSetting(
            theme: theme,
            title: 'Refresh Interval',
            subtitle: 'How often to update widget (minutes)',
            value: _refreshInterval.toDouble(),
            min: 5,
            max: 60,
            divisions: 11,
            onChanged: (value) {
              setState(() {
                _refreshInterval = value.round();
              });
            },
            displayValue: '$_refreshInterval min',
          ),
        _buildSwitchSetting(
          theme: theme,
          title: 'Haptic Feedback',
          subtitle: 'Vibrate when marking habits complete',
          value: _enableHapticFeedback,
          onChanged: (value) {
            setState(() {
              _enableHapticFeedback = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings(ThemeData theme) {
    return _buildSettingsSection(
      theme: theme,
      title: 'Advanced Settings',
      icon: Icons.tune,
      children: [
        ListTile(
          title: Text(
            'Reset to Defaults',
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Restore all widget settings to default values',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          leading: Icon(
            Icons.restore,
            color: theme.colorScheme.error,
          ),
          onTap: _resetToDefaults,
        ),
        ListTile(
          title: Text(
            'Remove Widget',
            style: theme.textTheme.bodyLarge,
          ),
          subtitle: Text(
            'Instructions for removing widgets from home screen',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          leading: Icon(
            Icons.delete_outline,
            color: theme.colorScheme.error,
          ),
          onTap: _showRemoveWidgetDialog,
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: theme.colorScheme.primary,
    );
  }

  Widget _buildSliderSetting({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(title, style: theme.textTheme.bodyLarge),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          trailing: Chip(
            label: Text(displayValue),
            backgroundColor: theme.colorScheme.primaryContainer,
            labelStyle: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('Save Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () async {
              try {
                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Refreshing widgets and checking debug info...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                // Get debug info
                final debugData = await WidgetIntegrationService.instance.testPrepareData();
                await WidgetIntegrationService.instance.updateAllWidgets();
                
                if (mounted) {
                  // Show debug dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Widget Debug Info'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Habits JSON length: ${debugData['habits']?.toString().length ?? 0}'),
                            Text('Theme mode: ${debugData['themeMode']}'),
                            Text('Primary color: ${debugData['primaryColor']}'),
                            Text('Selected date: ${debugData['selectedDate']}'),
                            Text('Last update: ${debugData['lastUpdate']}'),
                            const SizedBox(height: 8),
                            const Text('Habits JSON preview:'),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.grey[100],
                              child: Text(
                                debugData['habits']?.toString().substring(0, 
                                  math.min(200, debugData['habits']?.toString().length ?? 0)) ?? 'null',
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Widgets refreshed - see debug info above'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.bug_report),
            label: const Text('Debug Refresh'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'Are you sure you want to reset all widget settings to their default values?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _autoRefresh = true;
                _maxHabitsShown = 5;
                _showCompletedHabits = false;
                _showNextHabit = true;
                _refreshInterval = 15;
                _enableHapticFeedback = true;
              });
              Navigator.of(context).pop();
              _saveSettings();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showRemoveWidgetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Widget'),
        content: const Text(
          'To remove the widget from your home screen:\n\n'
          '1. Long press on the widget\n'
          '2. Drag it to the "Remove" area that appears\n'
          '3. Or tap "Remove" from the context menu\n\n'
          'The widget will be removed but your settings will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
