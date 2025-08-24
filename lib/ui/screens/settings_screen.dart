import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/permission_service.dart';
import '../../services/notification_service.dart';
import '../../services/theme_service.dart';
import '../../services/health_service.dart';
import '../../services/calendar_service.dart';
import '../../services/calendar_renewal_service.dart';
import '../../services/logging_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/automatic_habit_completion_service.dart';
import '../../services/hybrid_alarm_service.dart';
import '../../data/database.dart';
import '../widgets/calendar_selection_dialog.dart';
import '../widgets/health_education_dialog.dart';
import '../widgets/smooth_transitions.dart';
import '../widgets/progressive_disclosure.dart';
import '../widgets/radio_group.dart' as custom_widgets;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  bool _notificationsEnabled = false;
  bool _exactAlarmsEnabled = false;
  bool _calendarSync = false;
  bool _healthDataSync = false;
  bool _autoCompletionEnabled = false;
  bool _useSystemAlarms = false;
  bool _isLoading = true;
  String _defaultScreen = 'Timeline'; // Default startup screen

  final List<String> _availableScreens = [
    'Timeline',
    'All Habits',
    'Stats',
    'Insights',
  ];

  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPermissionStatus();
    _loadDefaultScreen();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app resumes, refresh permissions in case they were changed externally
    if (state == AppLifecycleState.resumed) {
      AppLogger.info('App resumed, refreshing permissions');
      _refreshHealthPermissions();
      _refreshExactAlarmPermission();
    }
  }

  /// Load current permission status when screen initializes
  Future<void> _loadPermissionStatus() async {
    try {
      final permissionService = PermissionService();

      final notificationStatus = await permissionService
          .isNotificationPermissionGranted();

      // Check exact alarm permission status
      final exactAlarmStatus =
          await NotificationService.canScheduleExactAlarms();

      // Load calendar sync status using the calendar service
      final calendarSyncEnabled = await CalendarService.isCalendarSyncEnabled();

      // Load health sync preference and verify actual permissions
      // Load auto-completion settings
      final autoCompletionEnabled =
          await AutomaticHabitCompletionService.isServiceEnabled();

      // Load alarm type preference
      final useSystemAlarms = HybridAlarmService.useSystemAlarms;
      final healthSyncPreference = await _loadHealthSyncPreference();
      bool healthStatus = false;

      if (healthSyncPreference) {
        // If user previously enabled health sync, check if permissions are still valid
        healthStatus = await permissionService.isHealthPermissionGranted();

        // If permissions were revoked externally, update the preference
        if (!healthStatus) {
          await _saveHealthSyncPreference(false);
        }
      }

      setState(() {
        _notificationsEnabled = notificationStatus;
        _exactAlarmsEnabled = exactAlarmStatus;
        _calendarSync = calendarSyncEnabled;
        _healthDataSync = healthStatus;
        _autoCompletionEnabled = autoCompletionEnabled;
        _useSystemAlarms = useSystemAlarms;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading permission status', e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Load default screen preference
  Future<void> _loadDefaultScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _defaultScreen = prefs.getString('default_screen') ?? 'Timeline';
      });
    } catch (e) {
      AppLogger.error('Error loading default screen preference', e);
    }
  }

  /// Save default screen preference
  Future<void> _saveDefaultScreen(String screen) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_screen', screen);
      setState(() {
        _defaultScreen = screen;
      });
      AppLogger.info('Default screen set to: $screen');
    } catch (e) {
      AppLogger.error('Error saving default screen preference', e);
    }
  }

  /// Save health sync preference
  Future<void> _saveHealthSyncPreference(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_sync_enabled', enabled);
      AppLogger.info('Health sync preference saved: $enabled');
    } catch (e) {
      AppLogger.error('Error saving health sync preference', e);
    }
  }

  /// Load health sync preference
  Future<bool> _loadHealthSyncPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('health_sync_enabled') ?? false;
    } catch (e) {
      AppLogger.error('Error loading health sync preference', e);
      return false;
    }
  }

  /// Refresh health permissions status
  /// This is called when the app resumes to check if permissions were granted externally
  Future<void> _refreshHealthPermissions() async {
    try {
      AppLogger.info('Refreshing health permissions status');

      // Use the new refresh method from HealthService
      final result = await HealthService.refreshPermissions();
      final bool hasPermissions = result.granted;

      // Update the UI state if permissions changed
      if (mounted && hasPermissions != _healthDataSync) {
        setState(() {
          _healthDataSync = hasPermissions;
        });

        // Update the saved preference to match the actual permission state
        await _saveHealthSyncPreference(hasPermissions);

        if (mounted) {
          if (hasPermissions) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Health permissions detected! Health data sync is now enabled. 🎉',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            // Permissions were revoked externally
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Health permissions were revoked. Health data sync is now disabled.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }

        AppLogger.info('Health permissions status updated: $hasPermissions');
      } else if (mounted) {
        // Even if state didn't change, show feedback that refresh was performed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Health permissions refreshed. Status: ${hasPermissions ? 'Enabled' : 'Disabled'}',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error refreshing health permissions', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error refreshing health permissions. Please try again.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Refresh exact alarm permission status
  /// This is called when the app resumes to check if permission was granted externally
  Future<void> _refreshExactAlarmPermission() async {
    try {
      AppLogger.info('Refreshing exact alarm permission status');

      final exactAlarmStatus =
          await NotificationService.canScheduleExactAlarms();

      // Update the UI state if permission changed
      if (mounted && exactAlarmStatus != _exactAlarmsEnabled) {
        setState(() {
          _exactAlarmsEnabled = exactAlarmStatus;
        });

        if (mounted) {
          if (exactAlarmStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Exact timing enabled! Notifications will be precise. ⏰',
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }

        AppLogger.info(
          'Exact alarm permission status updated: $exactAlarmStatus',
        );
      }
    } catch (e) {
      AppLogger.error('Error refreshing exact alarm permission', e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    // Debug: Print health data sync status
    AppLogger.info('Settings build - Health data sync: $_healthDataSync');

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'App Preferences',
            children: [
              _SettingsTile(
                title: 'Default Screen',
                subtitle: 'Choose which screen opens when you start the app',
                leading: const Icon(Icons.home),
                trailing: DropdownButton<String>(
                  value: _defaultScreen,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _saveDefaultScreen(newValue);
                    }
                  },
                  items: _availableScreens.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                title: 'Theme',
                subtitle: _getThemeModeText(themeState.themeMode),
                leading: const Icon(Icons.palette),
                onTap: () => _showThemeDialog(),
              ),
              _SettingsTile(
                title: 'Primary Color',
                subtitle: 'Customize your app\'s accent color',
                leading: CircleAvatar(
                  radius: 12,
                  backgroundColor: themeState.primaryColor,
                ),
                onTap: () => _showColorPicker(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Notifications',
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Get reminders for your habits'),
                value: _notificationsEnabled,
                onChanged: (value) => _toggleNotifications(value),
                secondary: const Icon(Icons.notifications),
              ),
              if (Platform.isAndroid) ...[
                const Divider(),
                ListTile(
                  title: const Text('Exact Timing'),
                  subtitle: Text(
                    _exactAlarmsEnabled
                        ? 'Precise notifications enabled'
                        : 'Tap to enable exact timing (Android 12+)',
                  ),
                  leading: Icon(
                    _exactAlarmsEnabled ? Icons.alarm_on : Icons.alarm_off,
                    color: _exactAlarmsEnabled ? Colors.green : Colors.orange,
                  ),
                  trailing: _exactAlarmsEnabled
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.settings, color: Colors.orange),
                  onTap: _exactAlarmsEnabled
                      ? null
                      : () => _requestExactAlarmPermission(),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Alarm Type'),
                  subtitle: Text(HybridAlarmService.getAlarmTypeDescription()),
                  leading: Icon(
                    _useSystemAlarms ? Icons.alarm : Icons.notifications_active,
                    color: _useSystemAlarms ? Colors.red : Colors.blue,
                  ),
                  trailing: Switch(
                    value: _useSystemAlarms,
                    onChanged: (value) => _toggleAlarmType(value),
                  ),
                  onTap: () => _showAlarmTypeInfo(),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          SettingsDisclosure(
            title: 'Integrations',
            description: 'Connect with external apps and services',
            basicSettings: [
              SwitchListTile(
                title: const Text('Calendar Sync'),
                subtitle: const Text('Sync habits with your device calendar'),
                value: _calendarSync,
                onChanged: (value) => _toggleCalendarSync(value),
                secondary: const Icon(Icons.calendar_today),
              ),
              SwitchListTile(
                title: const Text('Health Data'),
                subtitle: const Text('Connect with health apps for insights'),
                value: _healthDataSync,
                onChanged: (value) => _toggleHealthDataSync(value),
                secondary: const Icon(Icons.favorite),
              ),
              // Show Health Integration Dashboard immediately when health data is enabled
              if (_healthDataSync) ...[
                const Divider(),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text('Health Integration Dashboard'),
                          subtitle: const Text(
                            'Access all health integration settings',
                          ),
                          leading: const Icon(Icons.dashboard),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.push('/health-integration'),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Includes: Sync interval, background sync, auto-completion, and detailed health data settings',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ],
            advancedSettings: [
              if (_calendarSync) ...[
                SmoothTransitions.fadeTransition(
                  show: _calendarSync,
                  child: Column(
                    children: [
                      _SettingsTile(
                        title: 'Select Calendar',
                        subtitle: 'Choose which calendar to sync habits to',
                        leading: const Icon(Icons.calendar_month),
                        onTap: () => _showCalendarSelection(),
                      ),
                      _SettingsTile(
                        title: 'Calendar Renewal Status',
                        subtitle:
                            'View and manage automatic calendar sync renewal',
                        leading: const Icon(Icons.refresh),
                        onTap: () => _showCalendarRenewalStatus(),
                      ),
                    ],
                  ),
                ),
              ],
              // Additional health settings in advanced section
              if (_healthDataSync) ...[
                SmoothTransitions.fadeTransition(
                  show: _healthDataSync,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Automatic Habit Completion'),
                        subtitle: const Text(
                          'Auto-complete habits based on health data',
                        ),
                        value: _autoCompletionEnabled,
                        onChanged: (value) => _toggleAutoCompletion(value),
                        secondary: const Icon(Icons.auto_awesome),
                      ),
                      _SettingsTile(
                        title: 'Manage Health Permissions',
                        subtitle: 'Review and update health data permissions',
                        leading: const Icon(Icons.security),
                        onTap: () => _manageHealthPermissions(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Data & Privacy',
            children: [
              _SettingsTile(
                title: 'Export Data',
                subtitle: 'Download your habit data',
                leading: const Icon(Icons.download),
                onTap: () => _exportData(),
              ),
              _SettingsTile(
                title: 'Show Onboarding',
                subtitle: 'View the app introduction again',
                leading: const Icon(Icons.help_outline),
                onTap: () => _resetOnboarding(),
              ),
              _SettingsTile(
                title: 'Clear All Data',
                subtitle: 'Reset the app and delete all habits',
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: () => _showClearDataDialog(),
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                title: 'Version',
                subtitle: '1.0.0',
                leading: const Icon(Icons.info),
                onTap: () => _showAboutDialog(),
              ),
              _SettingsTile(
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                leading: const Icon(Icons.privacy_tip),
                onTap: () => _showPrivacyPolicy(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog() {
    final themeState = ref.read(themeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            custom_widgets.RadioGroup<ThemeMode>(
              value: themeState.themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(value);
                Navigator.of(context).pop();
              },
              children: [
                Builder(
                  builder: (context) => RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                  ).withRadioGroup(context),
                ),
                Builder(
                  builder: (context) => RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                  ).withRadioGroup(context),
                ),
                Builder(
                  builder: (context) => RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    value: ThemeMode.system,
                  ).withRadioGroup(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
    final themeState = ref.read(themeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Primary Color'),
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _colorOptions.map((color) {
            return GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).setPrimaryColor(color);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: themeState.primaryColor == color
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                ),
                child: themeState.primaryColor == color
                    ? Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _toggleNotifications(bool value) async {
    final permissionService = PermissionService();

    if (value) {
      final granted = await permissionService.requestPermission(
        Permission.notification,
      );
      if (granted) {
        setState(() => _notificationsEnabled = true);
        _showSnackBar('Notifications enabled successfully! 🔔');
      } else {
        setState(() => _notificationsEnabled = false);
        _showSnackBar('Permission denied. Please enable in device settings.');
      }
    } else {
      setState(() => _notificationsEnabled = false);
      _showSnackBar('Notifications disabled');
    }
  }

  /// Request exact alarm permission with user guidance
  Future<void> _requestExactAlarmPermission() async {
    try {
      // Show explanation dialog first
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enable Exact Timing'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exact timing allows notifications to arrive precisely on time.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Text('• Default: Notifications may be delayed up to 15 minutes'),
              Text('• With exact timing: Notifications arrive exactly on time'),
              SizedBox(height: 12),
              Text(
                'This will open Android settings where you can enable "Alarms & reminders" for HabitV8.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );

      if (shouldProceed == true) {
        // Request the permission (this will open Android settings)
        final granted =
            await NotificationService.requestExactAlarmPermissionWithGuidance();

        if (granted) {
          setState(() => _exactAlarmsEnabled = true);
          _showSnackBar(
            'Exact timing enabled! Notifications will be precise. ⏰',
          );
        } else {
          _showSnackBar(
            'Exact timing not enabled. Notifications may be delayed.',
          );
        }
      }
    } catch (e) {
      AppLogger.error('Error requesting exact alarm permission', e);
      _showSnackBar('Error enabling exact timing. Please try again.');
    }
  }

  /// Toggle calendar sync - integrated with table_calendar for consistency
  Future<void> _toggleCalendarSync(bool value) async {
    if (value) {
      // Initialize calendar service with provider container for habit access
      final container = ProviderScope.containerOf(context);
      final initialized = await CalendarService.initialize(container);

      if (initialized) {
        setState(() {
          _calendarSync = true;
        });

        // Save the preference using the service
        await CalendarService.setCalendarSyncEnabled(true);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Calendar sync enabled! Please select a calendar to sync to. 📅',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Show calendar selection dialog
          Future.delayed(const Duration(milliseconds: 500), () {
            _showCalendarSelection();
          });
        }

        AppLogger.info(
          'Calendar sync enabled with device calendar integration',
        );
      } else {
        setState(() {
          _calendarSync = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Calendar sync initialization failed. Using basic calendar view.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }

        AppLogger.warning('Calendar sync failed to initialize');
      }
    } else {
      setState(() {
        _calendarSync = false;
      });

      // Save the preference using the service
      await CalendarService.setCalendarSyncEnabled(false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calendar sync disabled. Using basic calendar view.'),
            backgroundColor: Colors.grey,
            duration: Duration(seconds: 2),
          ),
        );
      }

      AppLogger.info('Calendar sync disabled');
    }
  }

  /// Show calendar selection dialog
  Future<void> _showCalendarSelection() async {
    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => const CalendarSelectionDialog(),
      );

      if (result == true) {
        // Calendar was selected successfully
        AppLogger.info('Calendar selection updated');
      }
    } catch (e) {
      AppLogger.error('Error showing calendar selection', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Toggle health data sync
  Future<void> _toggleHealthDataSync(bool value) async {
    if (value) {
      try {
        // Show health education dialog first
        final bool? userConsent = await HealthEducationDialog.show(context);
        if (userConsent != true) {
          // User declined or dismissed the dialog
          setState(() => _healthDataSync = false);
          return;
        }

        // Show loading indicator
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 16),
                  Text('Requesting health permissions...'),
                ],
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }

        // Initialize health service first
        final initialized = await HealthService.initialize();
        if (!initialized) {
          setState(() => _healthDataSync = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Health Connect is not available on this device'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // First check if permissions are already granted (in case they were granted externally)
        var permissionResult = await HealthService.refreshPermissions();
        bool hasPermissions = permissionResult.granted;

        if (!hasPermissions) {
          // Request health permissions if not already granted
          permissionResult = await HealthService.requestPermissions();
          hasPermissions = permissionResult.granted;

          // If permissions were requested but not immediately granted,
          // they might have been granted in Health Connect but need time to sync
          if (!hasPermissions) {
            // Wait a bit longer and check again
            await Future.delayed(const Duration(seconds: 1));
            permissionResult = await HealthService.refreshPermissions();
            hasPermissions = permissionResult.granted;
          }
        }

        // Update UI state immediately
        setState(() {
          _healthDataSync = hasPermissions;
        });

        if (hasPermissions) {
          // Save the health sync preference to persist across app restarts
          await _saveHealthSyncPreference(true);

          // Force a rebuild to ensure the health integration dashboard appears
          if (mounted) {
            setState(() {});
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Health permissions granted successfully! 🎉'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Health permissions are required for this feature. Please grant permissions in Health Connect and return to the app.',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 8),
                action: SnackBarAction(
                  label: 'Open Settings',
                  onPressed: () => _openHealthConnectSettings(),
                ),
              ),
            );
          }
        }
      } catch (e) {
        setState(() => _healthDataSync = false);
        AppLogger.error('Error toggling health data sync', e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Save the disabled preference
      await _saveHealthSyncPreference(false);

      setState(() {
        _healthDataSync = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Health data sync disabled')),
        );
      }
    }
  }

  /// Toggle automatic habit completion
  Future<void> _toggleAutoCompletion(bool value) async {
    setState(() {
      _autoCompletionEnabled = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_completion_enabled', value);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            value
                ? 'Automatic habit completion enabled'
                : 'Automatic habit completion disabled',
          ),
        ),
      );
    }
  }

  /// Toggle alarm type between notification-based and system alarms
  Future<void> _toggleAlarmType(bool useSystemAlarms) async {
    try {
      await HybridAlarmService.setUseSystemAlarms(useSystemAlarms);

      setState(() {
        _useSystemAlarms = useSystemAlarms;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              useSystemAlarms
                  ? 'Switched to System Alarms - Override Do Not Disturb'
                  : 'Switched to Notification Alarms - Quick actions available',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error toggling alarm type', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error changing alarm type. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show alarm type information dialog
  void _showAlarmTypeInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarm Types'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose how you want to receive habit alarms:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // System Alarms section
              Row(
                children: [
                  Icon(Icons.alarm, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text(
                    'System Alarms',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...HybridAlarmService.getAlarmTypeBenefits()
                  .where(
                    (benefit) => _useSystemAlarms || benefit.startsWith('✅'),
                  )
                  .map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Text(benefit),
                    ),
                  ),

              const SizedBox(height: 16),

              // Notification Alarms section
              Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Notification Alarms',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...HybridAlarmService.getAlarmTypeBenefits()
                  .where(
                    (benefit) => !_useSystemAlarms || benefit.startsWith('✅'),
                  )
                  .map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Text(benefit),
                    ),
                  ),

              const SizedBox(height: 16),
              const Text(
                'You can change this setting anytime. Existing alarms will use the new type when they next trigger.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
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

  Future<void> _exportData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get habit data
      final habitServiceAsync = ref.read(habitServiceProvider);
      final habitService = habitServiceAsync.value;
      if (habitService == null) {
        _showSnackBar('Error: Habit service not available');
        return;
      }

      final habits = await habitService.getAllHabits();

      // Export to JSON file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final filePath = '${directory.path}/habitv8_export_$timestamp.json';

      // Convert habits to JSON
      final jsonData = habits.map((habit) => habit.toJson()).toList();
      final jsonString = jsonEncode(jsonData);

      // Write to file
      final file = File(filePath);
      await file.writeAsString(jsonString);

      if (mounted) {
        _showSnackBar('Data exported to: $filePath');
        AppLogger.info('Data exported to: $filePath');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error exporting data: $e');
      }
      AppLogger.error('Data export error', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetOnboarding() async {
    try {
      await OnboardingService.resetOnboarding();
      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      _showSnackBar('Error resetting onboarding: $e');
      AppLogger.error('Error resetting onboarding', e);
    }
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your habits and progress. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearAllData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Text('Clearing all data...'),
              ],
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }

      // 1. Cancel all notifications
      await NotificationService.cancelAllNotifications();
      AppLogger.info('All notifications cancelled');

      // 2. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      AppLogger.info('SharedPreferences cleared');

      // 3. Reset the Hive database (this will clear all habits)
      await DatabaseService.resetDatabase();
      AppLogger.info('Database reset completed');

      // 4. Disable calendar sync (preferences already cleared above)
      try {
        await CalendarService.setCalendarSyncEnabled(false);
        AppLogger.info('Calendar sync disabled');
      } catch (e) {
        AppLogger.warning('Failed to disable calendar sync: $e');
        // Don't fail the entire operation if calendar disabling fails
      }

      // 5. Reset app state
      setState(() {
        _notificationsEnabled = false;
        _calendarSync = false;
        _healthDataSync = false;
        _defaultScreen = 'Timeline';
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully! 🗑️'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      AppLogger.info('All data cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing all data', e);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Habit Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.track_changes, size: 48),
      children: [
        const Text(
          'A beautiful and intuitive habit tracking application built with Flutter.',
        ),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Visual habit tracking'),
        const Text('• Detailed analytics'),
        const Text('• Custom scheduling'),
        const Text('• Progress insights'),
      ],
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. This app stores all data locally on your device. '
            'No personal information is collected or shared with third parties. '
            'Optional integrations (calendar, health data) require explicit permission and can be disabled at any time.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Manage health permissions
  Future<void> _manageHealthPermissions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Health Data Integration'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This app can integrate with your health data to provide better insights:',
              ),
              SizedBox(height: 16),
              Text('• Step count tracking'),
              Text('• Sleep pattern analysis'),
              Text('• Exercise duration monitoring'),
              Text('• Heart rate insights'),
              SizedBox(height: 16),
              Text('Your privacy is important - data stays on your device.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _openHealthConnectSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _showHealthConnectDebugInfo();
              },
              child: const Text('Debug Info'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                navigator.pop();
                final result = await HealthService.requestPermissions();
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        result.granted
                            ? 'Health permissions granted!'
                            : 'Health permissions denied',
                      ),
                      backgroundColor: result.granted
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Grant Permissions'),
            ),
          ],
        );
      },
    );
  }

  /// Open Health Connect settings
  Future<void> _openHealthConnectSettings() async {
    try {
      final bool opened = await HealthService.openHealthConnectSettings();
      if (mounted) {
        if (opened) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Health Connect opened! Grant permissions for HabitV8, then return to the app.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Refresh',
                onPressed: () => _refreshHealthPermissions(),
              ),
            ),
          );
        } else {
          // Show detailed instructions if we can't open settings automatically
          _showHealthConnectInstructions();
        }
      }
    } catch (e) {
      AppLogger.error('Error opening Health Connect settings', e);
      if (mounted) {
        _showHealthConnectInstructions();
      }
    }
  }

  /// Show manual instructions for Health Connect
  void _showHealthConnectInstructions() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Health Connect Setup'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'To enable health data sync, please follow these steps:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('1. Open the Health Connect app on your device'),
                SizedBox(height: 8),
                Text('2. Go to "App permissions" or "Connected apps"'),
                SizedBox(height: 8),
                Text('3. Find "HabitV8" in the list'),
                SizedBox(height: 8),
                Text(
                  '4. Grant permissions for the data types you want to share',
                ),
                SizedBox(height: 8),
                Text('5. Return to HabitV8 and tap "Refresh Health Status"'),
                SizedBox(height: 16),
                Text(
                  'Note: Health Connect may be called "Google Health" on some devices.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _refreshHealthPermissions();
              },
              child: const Text('Refresh Status'),
            ),
          ],
        );
      },
    );
  }

  /// Show Health Connect debug information
  Future<void> _showHealthConnectDebugInfo() async {
    try {
      final debugInfo = await HealthService.getHealthConnectDebugInfo();

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Health Connect Debug Info'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: debugInfo.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      AppLogger.error('Error showing Health Connect debug info', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to get debug information'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Show calendar renewal status and management options
  Future<void> _showCalendarRenewalStatus() async {
    try {
      final status = await CalendarRenewalService.getRenewalStatus();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.refresh, color: Colors.blue),
                SizedBox(width: 8),
                Text('Calendar Renewal Status'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusRow(
                    'Service Active',
                    status['isActive'] ?? false,
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(
                    'Needs Renewal',
                    status['needsRenewal'] ?? true,
                  ),
                  const SizedBox(height: 8),
                  if (status['lastRenewal'] != null) ...[
                    Text(
                      'Last Renewal: ${_formatDateTime(status['lastRenewal'])}',
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (status['nextRenewal'] != null) ...[
                    Text(
                      'Next Renewal: ${_formatDateTime(status['nextRenewal'])}',
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (status['daysSinceRenewal'] != null) ...[
                    Text(
                      'Days Since Last Renewal: ${status['daysSinceRenewal']}',
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Calendar events are automatically renewed every 30 days to ensure your habits continue syncing to your calendar.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  if (status['error'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        'Error: ${status['error']}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              if (status['needsRenewal'] == true)
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _performManualRenewal();
                  },
                  child: const Text('Renew Now'),
                ),
            ],
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error showing calendar renewal status', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading renewal status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildStatusRow(String label, bool status) {
    return Row(
      children: [
        Icon(
          status ? Icons.check_circle : Icons.cancel,
          color: status ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  String _formatDateTime(String? isoString) {
    if (isoString == null) return 'Unknown';
    try {
      final dateTime = DateTime.parse(isoString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  /// Perform manual calendar renewal
  Future<void> _performManualRenewal() async {
    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Renewing calendar events...'),
              ],
            ),
            duration: Duration(seconds: 10),
          ),
        );
      }

      await CalendarRenewalService.forceRenewal();

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calendar renewal completed successfully! 📅'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error performing manual renewal', e);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Renewal failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
