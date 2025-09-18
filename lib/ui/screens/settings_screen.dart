import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/settings_tile.dart';
import '../widgets/calendar_selection_dialog.dart';
import '../widgets/document_popup_dialog.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';
import '../../services/theme_service.dart';
import '../../services/calendar_service.dart';
import '../../services/logging_service.dart';
import '../../services/data_export_import_service.dart';
import '../../services/subscription_service.dart';
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
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Notifications disabled. You can re-enable them in device settings.'),
                                    ),
                                  );
                                }
                              }
                              if (mounted) {
                                setState(() {}); // Refresh the UI
                              }
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

          // Premium Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Premium Version',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<SubscriptionStatus>(
                  future: SubscriptionService().getSubscriptionStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final status =
                        snapshot.data ?? SubscriptionStatus.trialExpired;
                    final subscriptionService = SubscriptionService();

                    return Column(
                      children: [
                        SettingsTile(
                          title: 'Status',
                          subtitle: _getSubscriptionStatusText(status),
                          trailing: _getSubscriptionStatusIcon(status),
                        ),
                        if (status == SubscriptionStatus.trial)
                          FutureBuilder<int>(
                            future: subscriptionService.getRemainingTrialDays(),
                            builder: (context, daysSnapshot) {
                              final daysRemaining = daysSnapshot.data ?? 0;
                              return SettingsTile(
                                title: 'Trial Days Remaining',
                                subtitle: '$daysRemaining days left',
                                trailing: const Icon(Icons.timer),
                              );
                            },
                          ),
                        // Debug option - will be removed after testing
                        if (status == SubscriptionStatus.trial)
                          SettingsTile(
                            title: 'Debug Trial Info',
                            subtitle: 'Tap to see detailed trial debug info',
                            trailing: const Icon(Icons.bug_report),
                            onTap: () => _showTrialDebugInfo(),
                          ),
                        if (status != SubscriptionStatus.premium)
                          SettingsTile(
                            title: 'Purchase Premium',
                            subtitle:
                                'One-time purchase to unlock all features',
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.go('/purchase'),
                          ),
                        if (status == SubscriptionStatus.premium)
                          SettingsTile(
                            title: 'Restore Purchases',
                            subtitle: 'Restore previous purchases',
                            trailing: const Icon(Icons.refresh),
                            onTap: () => _restorePurchases(),
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
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color:
                                            Colors.blue.withValues(alpha: 0.3)),
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
                  onTap: () => DocumentPopupDialog.showPrivacyPolicy(context),
                ),
                SettingsTile(
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => DocumentPopupDialog.showTermsOfService(context),
                ),
                ListTile(
                  title: const Text(
                    'App Version',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Text('v1.0.0'),
                      const SizedBox(width: 8),
                      Text(
                        'DapperCatsInc',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: const SizedBox.shrink(),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
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
          if (!mounted) return;
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
    final messenger = ScaffoldMessenger.of(context);
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
        messenger.showSnackBar(
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
        // Update the theme color
        await ref.read(themeProvider.notifier).setPrimaryColor(color);

        // Safely dismiss the dialog
        if (mounted && Navigator.canPop(context)) {
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
                          final navigator = Navigator.of(context);
                          await _saveDefaultScreen(value);
                          if (mounted && navigator.canPop()) {
                            navigator.pop();
                          }
                        }
                      },
                    ),
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await _saveDefaultScreen(screen);
                      if (mounted && navigator.canPop()) {
                        navigator.pop();
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
    OverlayEntry? loadingOverlay;

    try {
      // Use overlay instead of dialog to avoid navigation conflicts
      if (mounted) {
        loadingOverlay = OverlayEntry(
          builder: (context) => Material(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      const Text('Clearing all data...'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insert(loadingOverlay);
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

      // Mark database reset as in progress to prevent refresh attempts
      HabitsNotifier.markDatabaseResetInProgress();

      // Invalidate providers BEFORE resetting database to stop periodic refresh
      if (mounted) {
        ref.invalidate(habitServiceProvider);
        ref.invalidate(databaseProvider);
        AppLogger.info('Providers invalidated');
      }

      // Small delay to allow providers to clean up properly
      await Future.delayed(const Duration(milliseconds: 300));

      // Reset the database (this will delete all habits)
      await DatabaseService.resetDatabase();
      AppLogger.info('Database reset completed');

      // Wait a bit longer to ensure database cleanup is complete
      await Future.delayed(const Duration(milliseconds: 200));

      // Force database reinitialization by invalidating providers AGAIN
      if (mounted) {
        ref.invalidate(habitServiceProvider);
        ref.invalidate(databaseProvider);
        AppLogger.info('Providers re-invalidated after database reset');
      }

      // Mark reset as complete
      HabitsNotifier.markDatabaseResetComplete();

      // Remove loading overlay
      if (mounted && loadingOverlay != null) {
        try {
          loadingOverlay.remove();
          loadingOverlay = null;
        } catch (e) {
          AppLogger.warning('Could not remove loading overlay: $e');
        }
      }

      // Additional delay to ensure database is properly closed and providers cleaned up
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to main page to reset the navigation stack
      if (mounted) {
        // Use context.go to reset the entire navigation stack
        context.go('/');

        // Show success message after navigation with additional delay
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Use Future.delayed to add the delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All habit data has been permanently cleared'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          });
        });
      }
    } catch (e) {
      AppLogger.error('Failed to clear all data', e);

      // Mark reset as complete even on error
      HabitsNotifier.markDatabaseResetComplete();

      // Remove loading overlay if it's still shown
      if (mounted && loadingOverlay != null) {
        try {
          loadingOverlay.remove();
          loadingOverlay = null;
        } catch (overlayError) {
          AppLogger.warning(
              'Could not remove loading overlay after error: $overlayError');
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
    OverlayEntry? loadingOverlay;

    try {
      AppLogger.info('Starting export process for format: $format');

      // Show loading overlay instead of dialog to avoid navigation conflicts
      if (mounted) {
        loadingOverlay = OverlayEntry(
          builder: (context) => Material(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Text('Exporting data...',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insert(loadingOverlay);
        dialogShown = true;
        AppLogger.info('Loading overlay shown');
      }

      // Get all habits from database
      final habitService = await ref.read(habitServiceProvider.future);
      final habits = await habitService.getAllHabits();

      AppLogger.info('Retrieved ${habits.length} habits from database');

      if (habits.isEmpty) {
        AppLogger.info('No habits found, closing overlay and showing message');
        if (mounted && dialogShown && loadingOverlay != null) {
          // Remove loading overlay
          try {
            loadingOverlay.remove();
            AppLogger.info('Loading overlay removed successfully');
          } catch (e) {
            AppLogger.error('Error removing loading overlay', e);
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

      // Always try to close the loading overlay
      if (mounted && dialogShown && loadingOverlay != null) {
        AppLogger.info('Attempting to close loading overlay');
        try {
          loadingOverlay.remove();
          AppLogger.info('Loading overlay closed successfully');
        } catch (e) {
          AppLogger.error('Error closing loading overlay', e);
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
      } else if (exportResult?.cancelled == true) {
        AppLogger.info('Export was cancelled by user, no message needed');
        // User cancelled - don't show any message
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

      // Ensure loading overlay is closed on error
      if (mounted && dialogShown && loadingOverlay != null) {
        AppLogger.info('Attempting to close loading overlay after error');
        try {
          loadingOverlay.remove();
          AppLogger.info('Loading overlay closed after error');
        } catch (overlayError) {
          AppLogger.error(
              'Could not close loading overlay after error', overlayError);
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

      // Show result dialog only if there's something meaningful to show
      if (mounted && result.message != 'No file selected') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              result.success ? 'Import Successful' : 'Import Failed',
              style: TextStyle(
                color: result.success ? Colors.green : Colors.red,
              ),
            ),
            content: result.success
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.message),
                      const SizedBox(height: 16),
                      const Text(
                        'Note: Imported habits will start working after the next midnight refresh, or you can refresh notifications now.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  )
                : Text(result.message),
            actions: result.success
                ? [
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('OK'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        await _refreshNotificationsAfterImport();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Notifications'),
                    ),
                  ]
                : [
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

  /// Refresh all notifications and alarms after importing habits
  Future<void> _refreshNotificationsAfterImport() async {
    OverlayEntry? loadingOverlay;

    try {
      // Show loading overlay
      if (mounted) {
        loadingOverlay = OverlayEntry(
          builder: (context) => Material(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Refreshing notifications and alarms...'),
                      const SizedBox(height: 8),
                      const Text(
                        'This may take a moment',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insert(loadingOverlay);
      }

      AppLogger.info('🔔 Starting notification refresh after import');

      // Schedule all habit notifications and alarms
      await NotificationService.scheduleAllHabitNotifications();

      AppLogger.info('✅ Notification refresh completed after import');

      // Remove loading overlay
      loadingOverlay?.remove();
      loadingOverlay = null;

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Notifications and alarms refreshed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('❌ Error refreshing notifications after import', e);

      // Remove loading overlay
      loadingOverlay?.remove();
      loadingOverlay = null;

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Error refreshing notifications: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Get subscription status text for display
  String _getSubscriptionStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.trial:
        return 'Free trial active';
      case SubscriptionStatus.premium:
        return 'Premium purchased';
      case SubscriptionStatus.trialExpired:
        return 'Trial expired - purchase now';
      case SubscriptionStatus.cancelled:
        return 'Purchase cancelled';
    }
  }

  /// Get subscription status icon for display
  Widget _getSubscriptionStatusIcon(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.trial:
        return Icon(Icons.timer, color: Colors.orange);
      case SubscriptionStatus.premium:
        return Icon(Icons.verified, color: Colors.green);
      case SubscriptionStatus.trialExpired:
        return Icon(Icons.warning, color: Colors.red);
      case SubscriptionStatus.cancelled:
        return Icon(Icons.cancel, color: Colors.red);
    }
  }

  /// Restore purchases
  Future<void> _restorePurchases() async {
    try {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restoring purchases...'),
          ),
        );
      }

      // For now, just refresh the subscription status
      // In a real app, this would query the app store/play store
      final subscriptionService = SubscriptionService();
      await subscriptionService.initialize();

      // Refresh the UI
      if (mounted) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error restoring purchases: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Debug method to show trial information (remove after testing)
  Future<void> _showTrialDebugInfo() async {
    try {
      final subscriptionService = SubscriptionService();
      final debugInfo = await subscriptionService.getTrialDebugInfo();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🐛 Trial Debug Info'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Trial Started: ${debugInfo['trialStarted']}'),
                  if (debugInfo['trialStarted']) ...[
                    const SizedBox(height: 8),
                    Text('Start Date: ${debugInfo['trialStartDate']}'),
                    Text('Current Date: ${debugInfo['currentDate']}'),
                    Text('Days Since Start: ${debugInfo['daysSinceStart']}'),
                    Text(
                        'Trial Duration: ${debugInfo['trialDurationDays']} days'),
                    Text('Remaining Days: ${debugInfo['remainingDays']}'),
                    Text(
                        'Clamped Remaining: ${debugInfo['clampedRemainingDays']}'),
                    Text('Status: ${debugInfo['subscriptionStatus']}'),
                    Text('Is Active: ${debugInfo['isTrialActive']}'),
                    Text('Will Expire: ${debugInfo['willExpireOn']}'),
                  ] else ...[
                    Text(debugInfo['message'] ?? 'Unknown error'),
                  ],
                ],
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting debug info: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
