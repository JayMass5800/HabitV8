import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/settings_tile.dart';
import '../widgets/calendar_selection_dialog.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';
import '../../services/theme_service.dart';
import '../../services/calendar_service.dart';
import '../../services/logging_service.dart';
import '../../services/data_export_import_service.dart';
import '../../data/database.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _calendarSyncEnabled = false;
  String? _selectedCalendarName;
  String _defaultScreen = 'All Habits'; // Default screen setting

  @override
  void initState() {
    super.initState();
    _loadCalendarSettings();
    _loadDefaultScreen();
  }

  Future<void> _loadDefaultScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultScreen = prefs.getString('default_screen') ?? 'All Habits';

      AppLogger.info('Loading default screen setting: $defaultScreen');

      if (mounted) {
        setState(() {
          _defaultScreen = defaultScreen;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading default screen setting', e);
    }
  }

  Future<void> _loadCalendarSettings() async {
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      final selectedCalendar = await CalendarService.getSelectedCalendar();

      if (mounted) {
        setState(() {
          _calendarSyncEnabled = syncEnabled;
          _selectedCalendarName = selectedCalendar?.name;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  String _getCalendarSyncSubtitle(bool hasPermissions) {
    if (_calendarSyncEnabled && _selectedCalendarName != null) {
      return 'Syncing to $_selectedCalendarName';
    } else if (_calendarSyncEnabled && _selectedCalendarName == null) {
      return 'Calendar sync enabled - select calendar';
    } else if (hasPermissions) {
      return 'Sync habits with your calendar';
    } else {
      return 'Tap to enable and grant permissions';
    }
  }

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
                                await PermissionService
                                    .requestNotificationPermissionWithContext();
                              } else {
                                // Disable notifications - no direct method available,
                                // so we'll show a message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Notifications disabled. You can re-enable them in device settings.'),
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
                        SettingsTile(
                          title: 'Default Screen',
                          subtitle:
                              'Choose which screen opens when you start the app',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _defaultScreen,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () => _showDefaultScreenPicker(context),
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
                Consumer(
                  builder: (context, ref, child) {
                    return FutureBuilder<bool>(
                      future: CalendarService.hasPermissions(),
                      builder: (context, permissionSnapshot) {
                        final hasPermissions = permissionSnapshot.data ?? false;

                        return Column(
                          children: [
                            SettingsTile(
                              title: 'Calendar Sync',
                              subtitle:
                                  _getCalendarSyncSubtitle(hasPermissions),
                              trailing: Switch(
                                value: _calendarSyncEnabled,
                                onChanged: (value) async {
                                  await _handleCalendarSyncToggle(value);
                                },
                              ),
                            ),
                            if (_calendarSyncEnabled && hasPermissions) ...[
                              SettingsTile(
                                title: 'Select Calendar',
                                subtitle: _selectedCalendarName ??
                                    'Choose calendar to sync to',
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    _showCalendarSelectionDialog(context),
                              ),
                            ],
                            if (!hasPermissions && !_calendarSyncEnabled) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: Colors.blue.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline,
                                          color: Colors.blue.shade700),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Calendar Sync Available',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Enable calendar sync to automatically create habit reminders in your device calendar with the correct times.',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    );
                  },
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

  Future<void> _handleCalendarSyncToggle(bool enabled) async {
    try {
      if (enabled) {
        // Show loading indicator while requesting permissions
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Requesting calendar permissions...'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Request calendar permissions
        final hasPermissions = await _requestCalendarPermissions();
        if (!hasPermissions) {
          if (mounted) {
            _showPermissionDeniedDialog(context, false);
          }
          return;
        }

        // If no calendar is selected, show selection dialog
        if (CalendarService.getSelectedCalendarId() == null) {
          final dialogResult = await _showCalendarSelectionDialog(context);
          if (dialogResult != true) {
            return; // User cancelled or dialog failed
          }
        }

        // Enable calendar sync
        await CalendarService.setCalendarSyncEnabled(true);

        // Sync all existing habits
        final habitServiceAsync = ref.read(habitServiceProvider);
        final habitService = habitServiceAsync.value;
        if (habitService != null) {
          final allHabits = await habitService.getAllHabits();
          await CalendarService.syncAllHabitsToCalendar(allHabits);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar sync enabled and habits synced! 📅'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Show confirmation dialog before disabling
        final confirmDisable = await _showDisableConfirmationDialog(context);
        if (confirmDisable != true) {
          return;
        }

        // Disable calendar sync and remove all habit events
        await CalendarService.setCalendarSyncEnabled(false);

        final habitServiceAsync = ref.read(habitServiceProvider);
        final habitService = habitServiceAsync.value;
        if (habitService != null) {
          final allHabits = await habitService.getAllHabits();
          await CalendarService.removeAllHabitsFromCalendar(allHabits);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar sync disabled and habit events removed'),
              backgroundColor: Colors.orange,
            ),
          );

          // Show dialog about revoking permissions
          _showPermissionRevokeDialog(context);
        }
      }

      // Reload calendar settings
      await _loadCalendarSettings();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error toggling calendar sync: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool?> _showCalendarSelectionDialog(BuildContext context) async {
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => const CalendarSelectionDialog(),
      );

      if (result == true) {
        // Reload calendar settings after selection
        await _loadCalendarSettings();
      }

      return result;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error showing calendar selection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  Future<bool> _requestCalendarPermissions() async {
    try {
      // First check if permissions are already granted
      final hasPermissions = await CalendarService.hasPermissions();
      if (hasPermissions) {
        return true;
      }

      // Request permissions using permission_handler
      final status = await Permission.calendarFullAccess.request();
      final granted = status.isGranted;

      if (granted) {
        // Reinitialize calendar service after permissions are granted
        await CalendarService.reinitializeAfterPermissions();
        AppLogger.info(
            'Calendar permissions granted and service reinitialized');
      } else {
        AppLogger.warning('Calendar permissions denied: ${status.toString()}');
      }

      return granted;
    } catch (e) {
      AppLogger.error('Error requesting calendar permissions', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error requesting calendar permissions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  void _showPermissionDeniedDialog(
      BuildContext context, bool isPermanentlyDenied) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calendar Permission Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To enable calendar sync, HabitV8 needs access to your device calendar.',
            ),
            const SizedBox(height: 12),
            const Text('This allows the app to:'),
            const SizedBox(height: 8),
            const Text('• Create reminder events for your habits'),
            const Text('• Sync habit schedules with your calendar'),
            const Text('• Remove habit events when sync is disabled'),
            if (isPermanentlyDenied) ...[
              const SizedBox(height: 12),
              const Text(
                'Please enable calendar permissions in your device settings.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ],
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
          if (isPermanentlyDenied)
            FilledButton(
              onPressed: () async {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            )
          else
            FilledButton(
              onPressed: () async {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                await _handleCalendarSyncToggle(true);
              },
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }

  Future<bool?> _showDisableConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Calendar Sync?'),
        content: const Text(
          'This will remove all habit events from your calendar and disable future syncing. You can re-enable it later.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, false);
              }
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, true);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _showPermissionRevokeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calendar Permissions'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar sync has been disabled and all habit events have been removed from your calendar.',
            ),
            SizedBox(height: 12),
            Text(
              'If you want to completely revoke calendar permissions:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('1. Go to your device Settings'),
            Text('2. Find "Apps" or "Application Manager"'),
            Text('3. Select "HabitV8"'),
            Text('4. Tap "Permissions"'),
            Text('5. Turn off "Calendar" permission'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Got it'),
          ),
          FilledButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final themeState = ref.watch(themeProvider);
          return AlertDialog(
            title: const Text('Color Theme'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _colorOption(
                      'Blue', Colors.blue, themeState.primaryColor, ref),
                  _colorOption('Red', Colors.red, themeState.primaryColor, ref),
                  _colorOption(
                      'Green', Colors.green, themeState.primaryColor, ref),
                  _colorOption(
                      'Purple', Colors.purple, themeState.primaryColor, ref),
                  _colorOption(
                      'Orange', Colors.orange, themeState.primaryColor, ref),
                  _colorOption(
                      'Teal', Colors.teal, themeState.primaryColor, ref),
                  _colorOption(
                      'Pink', Colors.pink, themeState.primaryColor, ref),
                  _colorOption(
                      'Indigo', Colors.indigo, themeState.primaryColor, ref),
                  _colorOption(
                      'Amber', Colors.amber, themeState.primaryColor, ref),
                  _colorOption('Deep Orange', Colors.deepOrange,
                      themeState.primaryColor, ref),
                  _colorOption('Light Blue', Colors.lightBlue,
                      themeState.primaryColor, ref),
                  _colorOption(
                      'Lime', Colors.lime, themeState.primaryColor, ref),
                  _colorOption(
                      'Cyan', Colors.cyan, themeState.primaryColor, ref),
                  _colorOption(
                      'Brown', Colors.brown, themeState.primaryColor, ref),
                  _colorOption('Blue Grey', Colors.blueGrey,
                      themeState.primaryColor, ref),
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
          );
        },
      ),
    );
  }

  Widget _colorOption(
      String name, Color color, Color currentColor, WidgetRef ref) {
    final isSelected = currentColor.value == color.value;

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
        // Update the theme color
        await ref.read(themeProvider.notifier).setPrimaryColor(color);

        // Safely dismiss the dialog
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show confirmation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name theme selected'),
              backgroundColor: color,
            ),
          );
        }
      },
    );
  }

  void _showDefaultScreenPicker(BuildContext context) {
    final availableScreens = [
      'Timeline',
      'All Habits',
      'Calendar',
      'Stats',
      'Insights',
      'Settings',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Screen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableScreens
              .map((screen) => ListTile(
                    title: Text(screen),
                    leading: Radio<String>(
                      value: screen,
                      groupValue: _defaultScreen,
                      onChanged: (value) async {
                        if (value != null) {
                          await _saveDefaultScreen(value);
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                    onTap: () async {
                      await _saveDefaultScreen(screen);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ))
              .toList(),
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

  Future<void> _saveDefaultScreen(String screenName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_screen', screenName);

      if (mounted) {
        setState(() {
          _defaultScreen = screenName;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Default screen set to $screenName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      AppLogger.info('Default screen changed to: $screenName');
    } catch (e) {
      AppLogger.error('Error saving default screen setting', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save default screen setting'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
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
                      onChanged: (value) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ))
              .toList(),
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

  void _showExportOptions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await _exportData('CSV');
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await _exportData('JSON');
            },
            child: const Text('JSON'),
          ),
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

  void _showImportOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
            'Select import format and backup file to import your habit data.'),
        actions: [
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await _importData('JSON');
            },
            child: const Text('JSON File'),
          ),
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await _importData('CSV');
            },
            child: const Text('CSV File'),
          ),
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              await _clearAllData();
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

  Future<void> _clearAllData() async {
    bool dialogShown = false;

    try {
      // Show loading dialog
      if (mounted) {
        dialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Clearing all data...'),
              ],
            ),
          ),
        );
      }

      // Cancel all notifications first
      await NotificationService.cancelAllNotifications();
      AppLogger.info('All notifications cancelled');

      // Clear calendar events if calendar sync is enabled
      try {
        final syncEnabled = await CalendarService.isCalendarSyncEnabled();
        if (syncEnabled) {
          final habitService = await ref.read(habitServiceProvider.future);
          final habits = await habitService.getAllHabits();
          await CalendarService.removeAllHabitsFromCalendar(habits);
          AppLogger.info('All calendar events removed');
        }
      } catch (e) {
        AppLogger.warning('Failed to clear calendar events: $e');
      }

      // Reset the database (this will delete all habits)
      await DatabaseService.resetDatabase();
      AppLogger.info('Database reset completed');

      // Close loading dialog BEFORE invalidating providers
      if (mounted && dialogShown) {
        try {
          Navigator.pop(context);
          dialogShown = false;
        } catch (e) {
          AppLogger.warning('Could not close loading dialog: $e');
        }
      }

      // Show success message BEFORE invalidating providers
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All habit data has been permanently cleared'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Small delay to allow UI updates to process
      await Future.delayed(const Duration(milliseconds: 100));

      // Invalidate providers to refresh UI (this may cause widget rebuilds)
      if (mounted) {
        ref.invalidate(habitServiceProvider);
        ref.invalidate(databaseProvider);
      }
    } catch (e) {
      AppLogger.error('Failed to clear all data', e);

      // Close loading dialog if it's still shown
      if (mounted && dialogShown) {
        try {
          Navigator.pop(context);
        } catch (navError) {
          AppLogger.warning(
              'Could not close loading dialog after error: $navError');
        }
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear data: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _exportData(String format) async {
    bool dialogShown = false;

    try {
      AppLogger.info('Starting export process for format: $format');
      
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Exporting data...'),
              ],
            ),
          ),
        );
        dialogShown = true;
        AppLogger.info('Loading dialog shown');
      }

      // Get all habits from database
      final habitService = await ref.read(habitServiceProvider.future);
      final habits = await habitService.getAllHabits();
      
      AppLogger.info('Retrieved ${habits.length} habits from database');

      if (habits.isEmpty) {
        AppLogger.info('No habits found, closing dialog and showing message');
        if (mounted && dialogShown) {
          // Safely close dialog
          try {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
              AppLogger.info('Loading dialog closed successfully');
            } else {
              AppLogger.warning('Cannot pop dialog - no route to pop');
            }
          } catch (e) {
            AppLogger.error('Error closing loading dialog', e);
          }
          dialogShown = false;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No habits to export'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      ExportResult? exportResult;
      if (format == 'JSON') {
        AppLogger.info('Starting JSON export');
        exportResult = await DataExportImportService.exportToJSON(habits);
      } else if (format == 'CSV') {
        AppLogger.info('Starting CSV export');
        exportResult = await DataExportImportService.exportToCSV(habits);
      }

      AppLogger.info('Export completed with success: ${exportResult?.success}');

      // Always try to close the loading dialog
      if (mounted && dialogShown) {
        AppLogger.info('Attempting to close loading dialog');
        try {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            AppLogger.info('Loading dialog closed successfully');
          } else {
            AppLogger.warning('Cannot pop dialog - no route to pop');
          }
        } catch (e) {
          AppLogger.error('Error closing loading dialog', e);
        }
        dialogShown = false;
      }

      // Add a small delay to ensure dialog is fully closed
      await Future.delayed(const Duration(milliseconds: 100));

      if (exportResult?.success == true && mounted) {
        AppLogger.info('Export successful, showing success message');
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$format export completed successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (mounted) {
        final errorMessage =
            exportResult?.message ?? 'Failed to export data to $format';

        // Check if it's a permission-related error
        final isPermissionError = errorMessage.contains('permission') ||
            errorMessage.contains('Permission');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            action: isPermissionError
                ? SnackBarAction(
                    label: 'Settings',
                    textColor: Colors.white,
                    onPressed: () {
                      openAppSettings();
                    },
                  )
                : null,
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Export failed with exception', e);
      
      // Ensure loading dialog is closed on error
      if (mounted && dialogShown) {
        AppLogger.info('Attempting to close loading dialog after error');
        try {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            AppLogger.info('Loading dialog closed after error');
          } else {
            AppLogger.warning('Cannot pop dialog after error - no route to pop');
          }
        } catch (navError) {
          AppLogger.error('Could not close loading dialog after error', navError);
        }
        dialogShown = false;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData(String format) async {
    try {
      // Show loading dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Importing data...'),
              ],
            ),
          ),
        );
      }

      ImportResult result;
      if (format == 'JSON') {
        result = await DataExportImportService.importFromJSON();
      } else if (format == 'CSV') {
        result = await DataExportImportService.importFromCSV();
      } else {
        result = ImportResult(
          success: false,
          message: 'Invalid format: $format',
        );
      }

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              result.success ? 'Import Successful' : 'Import Failed',
              style: TextStyle(
                color: result.success ? Colors.green : Colors.red,
              ),
            ),
            content: Text(result.message),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }

      // Refresh the UI to show new habits
      if (result.success && mounted) {
        // Invalidate the habit service provider to refresh data
        ref.invalidate(habitServiceProvider);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      AppLogger.error('Import failed', e);
    }
  }
}
