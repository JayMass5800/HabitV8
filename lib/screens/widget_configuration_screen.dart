import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import '../services/theme_service.dart';

class WidgetConfigurationScreen extends ConsumerStatefulWidget {
  const WidgetConfigurationScreen({super.key});

  @override
  ConsumerState<WidgetConfigurationScreen> createState() =>
      _WidgetConfigurationScreenState();
}

class _WidgetConfigurationScreenState
    extends ConsumerState<WidgetConfigurationScreen> {
  bool _autoRefresh = true;
  double _refreshInterval = 15.0;
  String _widgetThemeMode = 'follow_app'; // follow_app, light, dark
  Color _widgetPrimaryColor = Colors.blue;

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
      _widgetThemeMode = prefs.getString('widget_theme_mode') ?? 'follow_app';
      final colorValue = prefs.getInt('widget_primary_color') ?? 0xFF2196F3;
      _widgetPrimaryColor = Color(colorValue);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('widget_auto_refresh', _autoRefresh);
    await prefs.setDouble('widget_refresh_interval', _refreshInterval);
    await prefs.setString('widget_theme_mode', _widgetThemeMode);

    // Convert color to ARGB32 format
    int colorValue;
    try {
      colorValue = _widgetPrimaryColor.toARGB32();
    } catch (e) {
      // Fallback to deprecated .value property if toARGB32 is not available
      // ignore: deprecated_member_use
      colorValue = _widgetPrimaryColor.value;
    }
    await prefs.setInt('widget_primary_color', colorValue);

    // Persist canonical keys for the Android widgets (read by Kotlin via HomeWidgetPreferences)
    try {
      await HomeWidget.saveWidgetData(
          'themeMode', _resolveWidgetThemeForStorage(_widgetThemeMode));
      await HomeWidget.saveWidgetData('primaryColor', colorValue);
      // small delay to ensure prefs are flushed
      await Future.delayed(const Duration(milliseconds: 250));
      await HomeWidget.updateWidget(
          name: 'HabitTimelineWidgetProvider',
          androidName: 'HabitTimelineWidgetProvider');
      await HomeWidget.updateWidget(
          name: 'HabitCompactWidgetProvider',
          androidName: 'HabitCompactWidgetProvider');
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Widget settings saved successfully')),
      );
    }
  }

  // Map the UI radio selection to what the widgets expect
  String _resolveWidgetThemeForStorage(String mode) {
    switch (mode) {
      case 'light':
        return 'light';
      case 'dark':
        return 'dark';
      case 'follow_app':
      default:
        // Mirror the app's current effective theme (resolve system brightness if needed)
        final appMode = ref.read(themeProvider).themeMode;
        if (appMode == ThemeMode.dark) return 'dark';
        if (appMode == ThemeMode.light) return 'light';
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark ? 'dark' : 'light';
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

            // Widget Theme Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.palette,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Widget Appearance',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Theme Mode Selection
                    Text(
                      'Theme Mode',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Follow App'),
                          value: 'follow_app',
                          // ignore: deprecated_member_use
                          groupValue: _widgetThemeMode,
                          // ignore: deprecated_member_use
                          onChanged: (value) {
                            setState(() {
                              _widgetThemeMode = value!;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Light'),
                                value: 'light',
                                // ignore: deprecated_member_use
                                groupValue: _widgetThemeMode,
                                // ignore: deprecated_member_use
                                onChanged: (value) {
                                  setState(() {
                                    _widgetThemeMode = value!;
                                  });
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Dark'),
                                value: 'dark',
                                // ignore: deprecated_member_use
                                groupValue: _widgetThemeMode,
                                // ignore: deprecated_member_use
                                onChanged: (value) {
                                  setState(() {
                                    _widgetThemeMode = value!;
                                  });
                                },
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Color Selection
                    ListTile(
                      title: const Text('Widget Color Theme'),
                      subtitle:
                          const Text('Choose color scheme for the widget'),
                      leading: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _widgetPrimaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showWidgetColorPicker(context),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

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

  void _showWidgetColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Widget Color Theme'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _widgetColorOption('Blue', Colors.blue, _widgetPrimaryColor),
              _widgetColorOption('Red', Colors.red, _widgetPrimaryColor),
              _widgetColorOption('Green', Colors.green, _widgetPrimaryColor),
              _widgetColorOption('Purple', Colors.purple, _widgetPrimaryColor),
              _widgetColorOption('Orange', Colors.orange, _widgetPrimaryColor),
              _widgetColorOption('Teal', Colors.teal, _widgetPrimaryColor),
              _widgetColorOption('Pink', Colors.pink, _widgetPrimaryColor),
              _widgetColorOption('Indigo', Colors.indigo, _widgetPrimaryColor),
              _widgetColorOption('Amber', Colors.amber, _widgetPrimaryColor),
              _widgetColorOption(
                  'Deep Orange', Colors.deepOrange, _widgetPrimaryColor),
              _widgetColorOption(
                  'Light Blue', Colors.lightBlue, _widgetPrimaryColor),
              _widgetColorOption('Lime', Colors.lime, _widgetPrimaryColor),
              _widgetColorOption('Cyan', Colors.cyan, _widgetPrimaryColor),
              _widgetColorOption('Brown', Colors.brown, _widgetPrimaryColor),
              _widgetColorOption(
                  'Blue Grey', Colors.blueGrey, _widgetPrimaryColor),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _widgetColorOption(String name, Color color, Color currentColor) {
    final isSelected = currentColor.toARGB32 == color.toARGB32;

    return ListTile(
      title: Text(name),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
            : null,
      ),
      onTap: () async {
        // Update the widget color
        setState(() {
          _widgetPrimaryColor = color;
        });

        // Safely dismiss the dialog
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name widget theme selected'),
              backgroundColor: color,
            ),
          );
        }
      },
    );
  }
}
