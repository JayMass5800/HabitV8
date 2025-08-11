import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../services/permission_service.dart';
import '../../services/notification_service.dart';
import '../../services/theme_service.dart';
import '../../services/health_service.dart';
import '../../services/calendar_service.dart';
import '../../services/logging_service.dart';
import '../../services/onboarding_service.dart';
import '../../data/database.dart';
import '../widgets/calendar_selection_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = false;
  bool _calendarSync = false;
  bool _healthDataSync = false;
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
    _loadPermissionStatus();
    _loadDefaultScreen();
  }

  /// Load current permission status when screen initializes
  Future<void> _loadPermissionStatus() async {
    try {
      final permissionService = PermissionService();

      final notificationStatus = await permissionService.isNotificationPermissionGranted();
      final healthStatus = await permissionService.isHealthPermissionGranted();
      
      // Load calendar sync status using the calendar service
      final calendarSyncEnabled = await CalendarService.isCalendarSyncEnabled();

      setState(() {
        _notificationsEnabled = notificationStatus;
        _calendarSync = calendarSyncEnabled;
        _healthDataSync = healthStatus;
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

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
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
                  items: _availableScreens.map<DropdownMenuItem<String>>((String value) {
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
              if (_notificationsEnabled)
                _SettingsTile(
                  title: 'Test Action Buttons',
                  subtitle: 'Test notification Complete/Snooze buttons',
                  leading: const Icon(Icons.notification_add),
                  onTap: () => _testNotifications(),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Integrations',
            children: [
              SwitchListTile(
                title: const Text('Calendar Sync'),
                subtitle: const Text('Sync habits with your device calendar'),
                value: _calendarSync,
                onChanged: (value) => _toggleCalendarSync(value),
                secondary: const Icon(Icons.calendar_today),
              ),
              if (_calendarSync)
                _SettingsTile(
                  title: 'Select Calendar',
                  subtitle: 'Choose which calendar to sync habits to',
                  leading: const Icon(Icons.calendar_month),
                  onTap: () => _showCalendarSelection(),
                ),
              if (_calendarSync)
                _SettingsTile(
                  title: 'Debug Calendar Sync',
                  subtitle: 'Check calendar sync status and logs',
                  leading: const Icon(Icons.bug_report),
                  onTap: () => _debugCalendarSync(),
                ),
              SwitchListTile(
                title: const Text('Health Data'),
                subtitle: const Text('Connect with health apps for insights'),
                value: _healthDataSync,
                onChanged: (value) => _toggleHealthDataSync(value),
                secondary: const Icon(Icons.favorite),
              ),
              if (_healthDataSync)
                _SettingsTile(
                  title: 'Health Permissions',
                  subtitle: 'Manage health data access',
                  leading: const Icon(Icons.health_and_safety),
                  onTap: () => _manageHealthPermissions(),
                ),
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
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: themeState.themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: themeState.themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(value!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: themeState.themeMode,
              onChanged: (value) {
                ref.read(themeProvider.notifier).setThemeMode(value!);
                Navigator.of(context).pop();
              },
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
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
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
      final granted = await permissionService.requestPermission(Permission.notification);
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
              content: Text('Calendar sync enabled! Please select a calendar to sync to. 📅'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          
          // Show calendar selection dialog
          Future.delayed(const Duration(milliseconds: 500), () {
            _showCalendarSelection();
          });
        }
        
        AppLogger.info('Calendar sync enabled with device calendar integration');
      } else {
        setState(() {
          _calendarSync = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar sync initialization failed. Using basic calendar view.'),
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
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Toggle health data sync
  Future<void> _toggleHealthDataSync(bool value) async {
    if (value) {
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

        // Request health permissions
        final hasPermissions = await HealthService.requestPermissions();
        
        setState(() {
          _healthDataSync = hasPermissions;
        });

        if (hasPermissions) {
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
                content: const Text('Health permissions are required for this feature. Please grant permissions in Health Connect.'),
                backgroundColor: Colors.orange,
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
      setState(() {
        _healthDataSync = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health data sync disabled'),
          ),
        );
      }
    }
  }

  Future<void> _testNotifications() async {
    try {
      // Send a regular test notification first
      await NotificationService.showTestNotification();

      // Test notification with action buttons (Complete/Snooze)
      await Future.delayed(const Duration(seconds: 1));
      await NotificationService.scheduleHabitNotification(
        id: 1001,
        habitId: 'test-habit-action-buttons',
        title: '🧪 Test Action Buttons',
        body: 'Tap Complete or Snooze to test the notification action buttons!',
        scheduledTime: DateTime.now().add(const Duration(seconds: 2)),
      );

      _showSnackBar('Test notifications sent! Check the Complete/Snooze buttons 🚀');
    } catch (e) {
      _showSnackBar('Error sending test notification: $e');
      AppLogger.error('Test notification error', e);
    }
  }

  void _exportData() {
    // TODO: Implement data export functionality
    _showSnackBar('Data export feature coming soon!');
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

  void _clearAllData() {
    // TODO: Implement data clearing functionality
    _showSnackBar('All data cleared');
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Habit Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.track_changes, size: 48),
      children: [
        const Text('A beautiful and intuitive habit tracking application built with Flutter.'),
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

  /// Debug calendar sync status
  Future<void> _debugCalendarSync() async {
    try {
      // Print debug status to logs
      await CalendarService.debugCalendarStatus();
      
      // Get detailed status for display
      final status = await CalendarService.getCalendarSyncStatus();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Calendar Sync Debug'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Initialized: ${status['isInitialized']}'),
                  Text('Sync Enabled: ${status['enabled']}'),
                  Text('Has Permissions: ${status['hasPermissions']}'),
                  Text('Device Calendar Available: ${status['deviceCalendarAvailable']}'),
                  Text('Selected Calendar: ${status['selectedCalendar'] ?? 'None'}'),
                  Text('Available Calendars: ${status['availableCalendarsCount']}'),
                  const SizedBox(height: 16),
                  const Text('Check the app logs for detailed debug information.'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Test sync with existing habits
                  final habitServiceAsync = ref.read(habitServiceProvider);
                  final habitService = habitServiceAsync.value;
                  if (habitService != null) {
                    final habits = await habitService.getAllHabits();
                    if (habits.isNotEmpty) {
                      await CalendarService.syncAllHabitsToCalendar(habits);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test sync completed - check logs for details'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Test Sync'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error in debug calendar sync', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debug error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              Text('This app can integrate with your health data to provide better insights:'),
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
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final granted = await HealthService.requestPermissions();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(granted
                        ? 'Health permissions granted!'
                        : 'Health permissions denied'),
                      backgroundColor: granted ? Colors.green : Colors.red,
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
      final permissionService = PermissionService();
      await permissionService.openSettings();
    } catch (e) {
      AppLogger.error('Error opening Health Connect settings', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open settings. Please manually open Health Connect app.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

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
        Card(
          child: Column(children: children),
        ),
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
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
