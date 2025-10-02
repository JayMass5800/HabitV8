import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../logging_service.dart';
import '../permission_service.dart';

/// Core notification functionality: initialization, permissions, and channels
///
/// This module handles:
/// - Plugin initialization with platform-specific settings
/// - Notification channel creation and management
/// - Permission requests and validation
/// - Platform capability detection
class NotificationCore {
  static bool _isInitialized = false;
  static bool _channelsCreated = false;

  /// Check if the notification system is initialized
  static bool get isInitialized => _isInitialized;

  /// Check if notification channels have been created
  static bool get channelsCreated => _channelsCreated;

  /// Initialize the notification system
  ///
  /// This must be called before any notification operations.
  /// Sets up platform-specific settings and handlers.
  static Future<void> initialize({
    required FlutterLocalNotificationsPlugin plugin,
    required Function(NotificationResponse) onForegroundTap,
    required Function(NotificationResponse) onBackgroundTap,
    Function()? onPeriodicCleanup,
  }) async {
    if (_isInitialized) {
      AppLogger.debug('Notification core already initialized, skipping');
      return;
    }

    // Start periodic cleanup if provided
    if (onPeriodicCleanup != null) {
      onPeriodicCleanup();
    }

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings with notification categories
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'habit_category',
          actions: [
            DarwinNotificationAction.plain(
              'complete',
              'COMPLETE',
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              'snooze',
              'SNOOZE 30MIN',
              options: {},
            ),
          ],
        ),
      ],
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onForegroundTap,
      onDidReceiveBackgroundNotificationResponse: onBackgroundTap,
    );

    // Add debug logging to verify initialization
    AppLogger.info('🔔 Notification plugin initialized with handlers:');
    AppLogger.info('  - Foreground handler: registered');
    AppLogger.info('  - Background handler: registered');

    // Test if the plugin is actually working by checking its state
    try {
      final androidImplementation =
          plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final areEnabled =
            await androidImplementation.areNotificationsEnabled();
        AppLogger.info('🔔 Android notifications enabled: $areEnabled');
      }
    } catch (e) {
      AppLogger.error('Error checking notification plugin state', e);
    }

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidPermissions(plugin);
      await createNotificationChannels(plugin);
    }

    _isInitialized = true;
    AppLogger.info('🔔 NotificationCore initialized successfully');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔧 Background handler registered: true');
  }

  /// Reset initialization state (for testing)
  static void reset() {
    _isInitialized = false;
    _channelsCreated = false;
  }

  // ==================== PLATFORM DETECTION ====================

  /// Check if device is running Android 12+ (API level 31+)
  static Future<bool> isAndroid12Plus() async {
    if (!Platform.isAndroid) return false;

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 31; // Android 12 = API 31
    } catch (e) {
      AppLogger.error('Error checking Android version', e);
      return false; // Assume older version if error
    }
  }

  // ==================== CHANNEL MANAGEMENT ====================

  /// Create Android notification channels
  static Future<void> createNotificationChannels(
      FlutterLocalNotificationsPlugin plugin) async {
    if (_channelsCreated) {
      AppLogger.debug('Notification channels already created, skipping');
      return;
    }

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Create habit notification channel
      const AndroidNotificationChannel habitChannel =
          AndroidNotificationChannel(
        'habit_channel',
        'Habit Notifications',
        description: 'Notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/notification_sound'),
        enableVibration: true,
      );

      // Create scheduled habit notification channel
      const AndroidNotificationChannel scheduledHabitChannel =
          AndroidNotificationChannel(
        'habit_scheduled_channel',
        'Scheduled Habit Notifications',
        description: 'Scheduled notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/notification_sound'),
        enableVibration: true,
      );

      // Create default alarm notification channel (fallback for non-background alarms)
      const AndroidNotificationChannel alarmChannel =
          AndroidNotificationChannel(
        'habit_alarm_default',
        'Habit Alarms (Default)',
        description: 'Default high-priority alarm notifications for habits',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/alarm_alert'),
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      await androidImplementation.createNotificationChannel(habitChannel);
      await androidImplementation.createNotificationChannel(
        scheduledHabitChannel,
      );
      await androidImplementation.createNotificationChannel(alarmChannel);

      _channelsCreated = true;

      AppLogger.info('Notification channels created successfully');
      AppLogger.info(
        'Habit channel: ${habitChannel.id} - ${habitChannel.name}',
      );
      AppLogger.info(
        'Scheduled habit channel: ${scheduledHabitChannel.id} - ${scheduledHabitChannel.name}',
      );
      AppLogger.info(
        'Alarm channel: ${alarmChannel.id} - ${alarmChannel.name}',
      );
    }
  }

  /// Recreate notification channels with updated sound configuration
  /// This is necessary when sound settings change, especially on Android 16+
  static Future<void> recreateNotificationChannels(
      FlutterLocalNotificationsPlugin plugin) async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      AppLogger.info(
          'Recreating notification channels with updated sound configuration...');

      // Delete existing channels first
      try {
        await androidImplementation.deleteNotificationChannel('habit_channel');
        await androidImplementation
            .deleteNotificationChannel('habit_scheduled_channel');
        await androidImplementation
            .deleteNotificationChannel('habit_alarm_default');
        AppLogger.info('Existing notification channels deleted');
      } catch (e) {
        AppLogger.warning('Some channels may not have existed: $e');
      }

      // Reset the flag to allow recreation
      _channelsCreated = false;

      // Recreate channels with new configuration
      await createNotificationChannels(plugin);
      AppLogger.info('Notification channels recreated successfully');
    }
  }

  // ==================== PERMISSIONS ====================

  /// Initialize Android notification settings without requesting permissions
  /// Permissions will be requested contextually when actually needed
  static Future<void> _requestAndroidPermissions(
      FlutterLocalNotificationsPlugin plugin) async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // DO NOT request notification permission during initialization on Android 13+
      // This causes the permission to become greyed out in system settings
      // Notification permission will be requested only when user enables notifications

      // Note: We also don't request exact alarm permission during initialization
      // This will be requested only when the user specifically enables alarms/reminders
      // to avoid the greyed-out permission issue on Android 14+
      AppLogger.info(
        'Notification service initialized. All permissions will be requested contextually when needed.',
      );
    }
  }

  /// Ensure all required permissions are granted before scheduling notifications
  /// This method requests permissions only when actually needed
  static Future<bool> ensureNotificationPermissions() async {
    try {
      // First, ensure basic notification permission is granted
      AppLogger.info('Checking notification permission...');
      final bool hasNotificationPermission =
          await Permission.notification.isGranted;

      if (!hasNotificationPermission) {
        AppLogger.info('Requesting notification permission for scheduling...');
        final bool notificationGranted =
            await PermissionService.requestNotificationPermissionWithContext();

        if (!notificationGranted) {
          AppLogger.warning(
            'Notification permission denied - cannot schedule notifications',
          );
          return false;
        }
      } else {
        AppLogger.info('Notification permission already granted');
      }

      // Then, check if we need exact alarm permission (Android 12+)
      final bool isAndroid12Plus = await NotificationCore.isAndroid12Plus();
      if (!isAndroid12Plus) {
        AppLogger.info('Exact alarm permission not required for Android < 12');
        return true;
      }

      // Check if we already have exact alarm permission
      final bool hasExactAlarmPermission =
          await PermissionService.hasExactAlarmPermission().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.warning(
            'Exact alarm permission check timed out in notification service - assuming false',
          );
          return false;
        },
      );
      if (hasExactAlarmPermission) {
        AppLogger.info('Exact alarm permission already available');
        return true;
      }

      AppLogger.info(
        'Checking exact alarm permission availability for precise scheduling...',
      );

      // For Android 13+ with USE_EXACT_ALARM: Should be automatically granted
      // For Android 12 with SCHEDULE_EXACT_ALARM: May require user action
      // We'll attempt to request it, but don't block the UI if it fails
      final bool exactAlarmGranted =
          await PermissionService.requestExactAlarmPermissionWithContext()
              .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          AppLogger.warning(
            'Exact alarm permission request timed out in notification service - continuing without exact alarms',
          );
          return false;
        },
      );

      if (exactAlarmGranted) {
        AppLogger.info(
          'Exact alarm permission available - notifications will be precise',
        );
      } else {
        AppLogger.info(
          'Exact alarm permission not available - notifications will use standard scheduling (this is normal for Android 12 if user denies permission)',
        );
        // Continue anyway - notifications will still work but may not be precise
      }

      // Always return true - don't block the UI based on exact alarm permission
      // Basic notifications will work regardless of exact alarm permission status
      return true;
    } catch (e) {
      AppLogger.error('Error ensuring notification permissions', e);
      return false; // Block notification scheduling if there's an error
    }
  }

  // ==================== CAPABILITY CHECKS ====================

  /// Check if exact alarms can be scheduled
  /// Returns true if the device supports exact alarm scheduling
  static Future<bool> canScheduleExactAlarms() async {
    try {
      return await PermissionService.hasExactAlarmPermission();
    } catch (e) {
      AppLogger.warning('Error checking exact alarm capability', e);
      return false;
    }
  }

  /// Check battery optimization status
  /// Logs whether the app is affected by battery optimization
  static Future<void> checkBatteryOptimizationStatus() async {
    if (!Platform.isAndroid) {
      AppLogger.debug('Battery optimization check only available on Android');
      return;
    }

    try {
      // Check if battery optimization is ignored for this app
      final isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;

      if (isIgnoring) {
        AppLogger.info('✅ Battery optimization is disabled for this app');
      } else {
        AppLogger.warning(
          '⚠️ Battery optimization is enabled - notifications may be delayed',
        );
      }
    } catch (e) {
      AppLogger.error('Could not check battery optimization status', e);
    }
  }
}
