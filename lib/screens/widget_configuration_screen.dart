import 'package:flutter/material.dart';import 'package:flutter/material.dart';import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class WidgetConfigurationScreen extends StatefulWidget {

  const WidgetConfigurationScreen({super.key});import 'package:shared_preferences/shared_preferences.dart';import 'dart:math' as math;



  @overrideclass WidgetConfigurationScreen extends StatefulWidget {

  State<WidgetConfigurationScreen> createState() => _WidgetConfigurationScreenState();

}  const WidgetConfigurationScreen({super.key});import '../services/widget_integration_service.dart';



class _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {

  bool _autoRefresh = true;

  double _refreshInterval = 15.0;  @overrideclass WidgetConfigurationScreen extends StatefulWidget {



  @override  State<WidgetConfigurationScreen> createState() => _WidgetConfigurationScreenState();

  void initState() {

    super.initState();}  const WidgetConfigurationScreen({Key? key}) : super(key: key);class WidgetConfigurationScreen extends StatefulWidget {

    _loadSettings();

  }



  Future<void> _loadSettings() async {class _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {  const WidgetConfigurationScreen({super.key});

    final prefs = await SharedPreferences.getInstance();

    setState(() {  bool _autoRefresh = true;

      _autoRefresh = prefs.getBool('widget_auto_refresh') ?? true;

      _refreshInterval = prefs.getDouble('widget_refresh_interval') ?? 15.0;  double _refreshInterval = 15.0;  @override

    });

  }



  Future<void> _saveSettings() async {  @override  _WidgetConfigurationScreenState createState() => _WidgetConfigurationScreenState();  @override

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('widget_auto_refresh', _autoRefresh);  void initState() {

    await prefs.setDouble('widget_refresh_interval', _refreshInterval);

        super.initState();}  State<WidgetConfigurationScreen> createState() =>

    if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(    _loadSettings();

        const SnackBar(content: Text('Settings saved successfully')),

      );  }      _WidgetConfigurationScreenState();

    }

  }



  @override  Future<void> _loadSettings() async {class _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {}

  Widget build(BuildContext context) {

    return Scaffold(    final prefs = await SharedPreferences.getInstance();

      appBar: AppBar(

        title: const Text('Widget Settings'),    setState(() {  bool _autoRefresh = true;

      ),

      body: Padding(      _autoRefresh = prefs.getBool('widget_auto_refresh') ?? true;

        padding: const EdgeInsets.all(16.0),

        child: Column(      _refreshInterval = prefs.getDouble('widget_refresh_interval') ?? 15.0;  double _refreshInterval = 15.0; // minutesclass _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [    });

            SwitchListTile(

              title: const Text('Auto Refresh'),  }  bool _autoRefresh = true;

              subtitle: const Text('Automatically refresh widget data'),

              value: _autoRefresh,

              onChanged: (value) {

                setState(() {  Future<void> _saveSettings() async {  @override  int _maxHabitsShown = 5;

                  _autoRefresh = value;

                });    final prefs = await SharedPreferences.getInstance();

              },

            ),    await prefs.setBool('widget_auto_refresh', _autoRefresh);  void initState() {  bool _showCompletedHabits = false;

            const SizedBox(height: 16),

                await prefs.setDouble('widget_refresh_interval', _refreshInterval);

            Text(

              'Refresh Interval: ${_refreshInterval.toInt()} minutes',        super.initState();  bool _showNextHabit = true;

              style: Theme.of(context).textTheme.titleMedium,

            ),    if (mounted) {

            Slider(

              value: _refreshInterval,      ScaffoldMessenger.of(context).showSnackBar(    _loadSettings();  int _refreshInterval = 15; // minutes

              min: 1.0,

              max: 60.0,        const SnackBar(content: Text('Settings saved successfully')),

              divisions: 59,

              label: '${_refreshInterval.toInt()} min',      );  }  bool _enableHapticFeedback = true;

              onChanged: (value) {

                setState(() {    }

                  _refreshInterval = value;

                });  }

              },

            ),

            const SizedBox(height: 32),

              @override  Future<void> _loadSettings() async {  @override

            Card(

              child: Padding(  Widget build(BuildContext context) {

                padding: const EdgeInsets.all(16.0),

                child: Column(    return Scaffold(    final prefs = await SharedPreferences.getInstance();  void initState() {

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [      appBar: AppBar(

                    Text(

                      'Widget Removal Instructions',        title: const Text('Widget Settings'),    setState(() {    super.initState();

                      style: Theme.of(context).textTheme.titleMedium,

                    ),      ),

                    const SizedBox(height: 8),

                    const Text(      body: Padding(      _autoRefresh = prefs.getBool('widget_auto_refresh') ?? true;    _loadCurrentSettings();

                      'To remove the widget from your home screen:\n\n'

                      '1. Long press on the widget\n'        padding: const EdgeInsets.all(16.0),

                      '2. Select "Remove" or drag to the trash icon\n'

                      '3. Confirm removal when prompted',        child: Column(      _refreshInterval = prefs.getDouble('widget_refresh_interval') ?? 15.0;  }

                    ),

                  ],          crossAxisAlignment: CrossAxisAlignment.start,

                ),

              ),          children: [    });

            ),

            const Spacer(),            SwitchListTile(

            

            SizedBox(              title: const Text('Auto Refresh'),  }  void _loadCurrentSettings() async {

              width: double.infinity,

              child: ElevatedButton(              subtitle: const Text('Automatically refresh widget data'),

                onPressed: _saveSettings,

                style: ElevatedButton.styleFrom(              value: _autoRefresh,    // Load current widget preferences from SharedPreferences

                  padding: const EdgeInsets.symmetric(vertical: 16),

                ),              onChanged: (value) {

                child: const Text('Save Settings'),

              ),                setState(() {  Future<void> _saveSettings() async {    // This would typically use a preferences service

            ),

          ],                  _autoRefresh = value;

        ),

      ),                });    final prefs = await SharedPreferences.getInstance();    setState(() {

    );

  }              },

}
            ),    await prefs.setBool('widget_auto_refresh', _autoRefresh);      // Set default values for now

            const SizedBox(height: 16),

                await prefs.setDouble('widget_refresh_interval', _refreshInterval);      _autoRefresh = true;

            Text(

              'Refresh Interval: ${_refreshInterval.toInt()} minutes',          _maxHabitsShown = 5;

              style: Theme.of(context).textTheme.titleMedium,

            ),    if (mounted) {      _showCompletedHabits = false;

            Slider(

              value: _refreshInterval,      ScaffoldMessenger.of(context).showSnackBar(      _showNextHabit = true;

              min: 1.0,

              max: 60.0,        const SnackBar(content: Text('Settings saved successfully')),      _refreshInterval = 15;

              divisions: 59,

              label: '${_refreshInterval.toInt()} min',      );      _enableHapticFeedback = true;

              onChanged: (value) {

                setState(() {    }    });

                  _refreshInterval = value;

                });  }  }

              },

            ),

            const SizedBox(height: 32),

              @override  void _saveSettings() async {

            Card(

              child: Padding(  Widget build(BuildContext context) {    // Save preferences and update widgets

                padding: const EdgeInsets.all(16.0),

                child: Column(    return Scaffold(    try {

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [      appBar: AppBar(      // This would typically save to SharedPreferences

                    Text(

                      'Widget Removal Instructions',        title: const Text('Widget Settings'),      await WidgetIntegrationService.instance.updateAllWidgets();

                      style: Theme.of(context).textTheme.titleMedium,

                    ),      ),

                    const SizedBox(height: 8),

                    const Text(      body: Padding(      if (mounted) {

                      'To remove the widget from your home screen:\n\n'

                      '1. Long press on the widget\n'        padding: const EdgeInsets.all(16.0),        ScaffoldMessenger.of(context).showSnackBar(

                      '2. Select "Remove" or drag to the trash icon\n'

                      '3. Confirm removal when prompted',        child: Column(          const SnackBar(

                    ),

                  ],          crossAxisAlignment: CrossAxisAlignment.start,            content: Text('Widget settings saved successfully'),

                ),

              ),          children: [            backgroundColor: Colors.green,

            ),

            const Spacer(),            // Auto Refresh Setting          ),

            

            SizedBox(            SwitchListTile(        );

              width: double.infinity,

              child: ElevatedButton(              title: const Text('Auto Refresh'),      }

                onPressed: _saveSettings,

                style: ElevatedButton.styleFrom(              subtitle: const Text('Automatically refresh widget data'),    } catch (e) {

                  padding: const EdgeInsets.symmetric(vertical: 16),

                ),              value: _autoRefresh,      if (mounted) {

                child: const Text('Save Settings'),

              ),              onChanged: (value) {        ScaffoldMessenger.of(context).showSnackBar(

            ),

          ],                setState(() {          SnackBar(

        ),

      ),                  _autoRefresh = value;            content: Text('Error saving settings: $e'),

    );

  }                });            backgroundColor: Colors.red,

}
              },          ),

            ),        );

            const SizedBox(height: 16),      }

                }

            // Refresh Interval Setting  }

            Text(

              'Refresh Interval: ${_refreshInterval.toInt()} minutes',  @override

              style: Theme.of(context).textTheme.titleMedium,  Widget build(BuildContext context) {

            ),    final theme = Theme.of(context);

            Slider(

              value: _refreshInterval,    return Scaffold(

              min: 1.0,      appBar: AppBar(

              max: 60.0,        title: const Text('Widget Settings'),

              divisions: 59,        backgroundColor: theme.colorScheme.surface,

              label: '${_refreshInterval.toInt()} min',        foregroundColor: theme.colorScheme.onSurface,

              onChanged: (value) {        elevation: 0,

                setState(() {        actions: [

                  _refreshInterval = value;          IconButton(

                });            icon: const Icon(Icons.save),

              },            onPressed: _saveSettings,

            ),            tooltip: 'Save Settings',

            const SizedBox(height: 32),          ),

                    ],

            // Removal Instructions      ),

            Card(      body: SingleChildScrollView(

              child: Padding(        padding: const EdgeInsets.all(16.0),

                padding: const EdgeInsets.all(16.0),        child: Column(

                child: Column(          crossAxisAlignment: CrossAxisAlignment.start,

                  crossAxisAlignment: CrossAxisAlignment.start,          children: [

                  children: [            // Essential Settings Only

                    Text(            _buildEssentialSettings(theme),

                      'Widget Removal Instructions',            const SizedBox(height: 24),

                      style: Theme.of(context).textTheme.titleMedium,

                    ),            // Widget Removal Instructions

                    const SizedBox(height: 8),            _buildRemovalInstructions(theme),

                    const Text(            const SizedBox(height: 24),

                      'To remove the widget from your home screen:\n\n'

                      '1. Long press on the widget\n'            // Action buttons

                      '2. Select "Remove" or drag to the trash icon\n'            _buildActionButtons(theme),

                      '3. Confirm removal when prompted',          ],

                    ),        ),

                  ],      ),

                ),    );

              ),  }

            ),

            const Spacer(),  Widget _buildEssentialSettings(ThemeData theme) {

                return _buildSettingsSection(

            // Save Settings Button      theme: theme,

            SizedBox(      title: 'Widget Settings',

              width: double.infinity,      icon: Icons.settings,

              child: ElevatedButton(      children: [

                onPressed: _saveSettings,        _buildSwitchSetting(

                style: ElevatedButton.styleFrom(          theme: theme,

                  padding: const EdgeInsets.symmetric(vertical: 16),          title: 'Auto Refresh',

                ),          subtitle: 'Automatically update widget content',

                child: const Text('Save Settings'),          value: _autoRefresh,

              ),          onChanged: (value) {

            ),            setState(() {

          ],              _autoRefresh = value;

        ),            });

      ),          },

    );        ),

  }        if (_autoRefresh)

}          _buildSliderSetting(
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
      ],
    );
  }

  Widget _buildRemovalInstructions(ThemeData theme) {
    return _buildSettingsSection(
      theme: theme,
      title: 'Widget Management',
      icon: Icons.info,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Widget Removal Instructions',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'To remove widgets from your home screen:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Long press on the widget\n'
                '2. Select "Remove" or drag to "Remove" area\n'
                '3. Confirm removal when prompted',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

            // Action buttons
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
                    content:
                        Text('Refreshing widgets and checking debug info...'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Get debug info
                final debugData =
                    await WidgetIntegrationService.instance.testPrepareData();
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
                            Text(
                                'Habits JSON length: ${debugData['habits']?.toString().length ?? 0}'),
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
                                debugData['habits']?.toString().substring(
                                        0,
                                        math.min(
                                            200,
                                            debugData['habits']
                                                    ?.toString()
                                                    .length ??
                                                0)) ??
                                    'null',
                                style: const TextStyle(
                                    fontFamily: 'monospace', fontSize: 10),
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
