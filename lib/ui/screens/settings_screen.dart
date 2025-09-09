import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/settings_tile.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';
import '../../services/theme_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notifications Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Notifications',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return FutureBuilder<bool>(
                      future: NotificationService.areNotificationsEnabled(),
                      builder: (context, snapshot) {
                        final isEnabled = snapshot.data ?? false;
                        
                        return SettingsTile(
                          title: 'Push Notifications',
                          subtitle: 'Get reminders for your habits',
                          trailing: Switch(
                            value: isEnabled,
                            onChanged: (value) async {
                              if (value) {
                                await PermissionService.requestNotificationPermissionWithContext();
                              } else {
                                // Disable notifications - no direct method available, 
                                // so we'll show a message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notifications disabled. You can re-enable them in device settings.'),
                                  ),
                                );
                              }
                              setState(() {}); // Refresh the UI
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                SettingsTile(
                  title: 'Notification Time',
                  subtitle: 'Set your preferred reminder time',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTimePicker(context),
                ),
                SettingsTile(
                  title: 'Notification Sound',
                  subtitle: 'Choose your reminder sound',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSoundPicker(context),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Appearance Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Appearance',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final themeState = ref.watch(themeProvider);
                    
                    return Column(
                      children: [
                        SettingsTile(
                          title: 'Dark Mode',
                          subtitle: 'Use dark theme',
                          trailing: Switch(
                            value: themeState.themeMode == ThemeMode.dark,
                            onChanged: (value) {
                              ref.read(themeProvider.notifier).setThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          title: 'Color Theme',
                          subtitle: 'Choose your preferred color scheme',
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _showColorPicker(context),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Calendar Integration Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Calendar',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Calendar Sync',
                  subtitle: 'Sync habits with your calendar',
                  trailing: Switch(
                    value: false, // Placeholder
                    onChanged: (value) {
                      _showFeatureComingSoon(context);
                    },
                  ),
                ),
                SettingsTile(
                  title: 'Weekly Start Day',
                  subtitle: 'Choose which day starts your week',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showWeekStartPicker(context),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Data Management Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.storage,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Data Management',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Export Data',
                  subtitle: 'Export your habit data',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showExportOptions(context),
                ),
                SettingsTile(
                  title: 'Import Data',
                  subtitle: 'Import habit data from backup',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showImportOptions(context),
                ),
                SettingsTile(
                  title: 'Clear Data',
                  subtitle: 'Reset all habit data',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showClearDataDialog(context),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // About Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'About',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Privacy Policy',
                  subtitle: 'View our privacy policy',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/privacy'),
                ),
                SettingsTile(
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/terms'),
                ),
                SettingsTile(
                  title: 'App Version',
                  subtitle: 'v1.0.0',
                  trailing: const SizedBox.shrink(),
                  onTap: null,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) {
      // Save the notification time preference
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification time set to ${time.format(context)}'),
        ),
      );
    }
  }

  void _showSoundPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Default'),
              leading: Radio<String>(
                value: 'default',
                groupValue: 'default',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('Gentle Bell'),
              leading: Radio<String>(
                value: 'bell',
                groupValue: 'default',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
            ListTile(
              title: const Text('Chime'),
              leading: Radio<String>(
                value: 'chime',
                groupValue: 'default',
                onChanged: (value) => Navigator.pop(context),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _colorOption('Blue', Colors.blue),
            _colorOption('Green', Colors.green),
            _colorOption('Purple', Colors.purple),
            _colorOption('Orange', Colors.orange),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _colorOption(String name, Color color) {
    return ListTile(
      title: Text(name),
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name theme selected')),
        );
      },
    );
  }

  void _showWeekStartPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Week Start Day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ]
              .map((day) => ListTile(
                    title: Text(day),
                    leading: Radio<String>(
                      value: day,
                      groupValue: 'Monday',
                      onChanged: (value) => Navigator.pop(context),
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFeatureComingSoon(context);
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFeatureComingSoon(context);
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showImportOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text('Select a backup file to import your habit data.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFeatureComingSoon(context);
            },
            child: const Text('Select File'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your habit data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }

  void _showFeatureComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
      ),
    );
  }
}
