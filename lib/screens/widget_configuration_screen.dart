import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetConfigurationScreen extends StatefulWidget {
  const WidgetConfigurationScreen({super.key});

  @override
  State<WidgetConfigurationScreen> createState() => _WidgetConfigurationScreenState();
}

class _WidgetConfigurationScreenState extends State<WidgetConfigurationScreen> {
  bool _autoRefresh = true;
  double _refreshInterval = 15.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoRefresh = prefs.getBool('widget_auto_refresh') ?? true;
      _refreshInterval = prefs.getDouble('widget_refresh_interval') ?? 15.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('widget_auto_refresh', _autoRefresh);
    await prefs.setDouble('widget_refresh_interval', _refreshInterval);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Auto Refresh'),
              subtitle: const Text('Automatically refresh widget data'),
              value: _autoRefresh,
              onChanged: (value) {
                setState(() {
                  _autoRefresh = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            Text(
              'Refresh Interval: ${_refreshInterval.toInt()} minutes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _refreshInterval,
              min: 1.0,
              max: 60.0,
              divisions: 59,
              label: '${_refreshInterval.toInt()} min',
              onChanged: (value) {
                setState(() {
                  _refreshInterval = value;
                });
              },
            ),
            const SizedBox(height: 32),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widget Removal Instructions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'To remove the widget from your home screen:\n\n'
                      '1. Long press on the widget\n'
                      '2. Select "Remove" or drag to the trash icon\n'
                      '3. Confirm removal when prompted',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
