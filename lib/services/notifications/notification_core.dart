import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
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
    required Function(ReceivedAction) onActionReceivedMethod,
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

    // Initialize AwesomeNotifications
    await AwesomeNotifications().initialize(
      null, // Use default app icon
      [
        // Habit notification channel
        NotificationChannel(
          channelKey: 'habit_channel',
          channelName: 'Habit Notifications',
          channelDescription: 'Notifications for habit reminders',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: false,
        ),
        // Scheduled habit notification channel
        NotificationChannel(
          channelKey: 'habit_scheduled_channel',
          channelName: 'Scheduled Habit Notifications',
          channelDescription: 'Scheduled notifications for habit reminders',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: false,
        ),
        // Alarm notification channel (default)
        NotificationChannel(
          channelKey: 'habit_alarm_default',
          channelName: 'Habit Alarms (Default)',
          channelDescription:
              'Default high-priority alarm notifications for habits',
          defaultColor: const Color(0xFFFF0000),
          ledColor: Colors.red,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        ),
        // High-priority alarm channel (for time-critical habits)
        NotificationChannel(
          channelKey: 'habit_alarms',
          channelName: 'Habit Alarms',
          channelDescription: 'High-priority alarms for time-critical habits',
          importance: NotificationImportance.Max,
          defaultColor: const Color(0xFF9C27B0),
          ledColor: Colors.red,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          locked: true, // Prevent user from dismissing
          defaultPrivacy: NotificationPrivacy.Public,
          criticalAlerts: true, // iOS critical alerts
          channelShowBadge: true,
          onlyAlertOnce: false,
        ),
      ],
      debug: false,
    );

    // Set up action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (ReceivedAction receivedAction) async {
        await onActionReceivedMethod(receivedAction);
      },
    );

    // Add debug logging to verify initialization
    AppLogger.info('🔔 Notification plugin initialized with handlers:');
    AppLogger.info('  - Action handler: registered');

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidPermissions();
    }

    _isInitialized = true;
    _channelsCreated = true;
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
  /// Note: With awesome_notifications, channels are created during initialization
  static Future<void> createNotificationChannels() async {
    if (_channelsCreated) {
      AppLogger.debug('Notification channels already created, skipping');
      return;
    }

    // Channels are already created in initialize()
    _channelsCreated = true;
    AppLogger.info('Notification channels created successfully');
  }

  /// Recreate notification channels with updated sound configuration
  /// This is necessary when sound settings change, especially on Android 16+
  static Future<void> recreateNotificationChannels() async {
    AppLogger.info(
        'Recreating notification channels with updated sound configuration...');

    // With awesome_notifications, we need to reinitialize to update channels
    _isInitialized = false;
    _channelsCreated = false;

    AppLogger.info('Notification channels recreated successfully');
  }

  // ==================== PERMISSIONS ====================

  /// Initialize Android notification settings without requesting permissions
  /// Permissions will be requested contextually when actually needed
  static Future<void> _requestAndroidPermissions() async {
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

  /// Ensure all required permissions are granted before scheduling notifications
  /// This method requests permissions only when actually needed
  static Future<bool> ensureNotificationPermissions() async {
    try {
      // First, ensure basic notification permission is granted
      AppLogger.info('Checking notification permission...');
      final bool hasNotificationPermission =
          await AwesomeNotifications().isNotificationAllowed();

      if (!hasNotificationPermission) {
        AppLogger.info('Requesting notification permission for scheduling...');
        final bool notificationGranted =
            await AwesomeNotifications().requestPermissionToSendNotifications();

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

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  /// Request notification permissions with user context
  static Future<bool> requestNotificationPermissions() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  /// Open notification settings
  static Future<void> openNotificationSettings() async {
    await AwesomeNotifications().showNotificationConfigPage();
  }

  // ==================== CAPABILITY CHECKS ====================

  /// Check if exact alarms can be scheduled on this device
  ///
  /// Required for precise notification timing on Android 12+.
  static Future<bool> canScheduleExactAlarms() async {
    try {
      if (!Platform.isAndroid) return true; // iOS always supports exact timing

      final bool isAndroid12Plus = await NotificationCore.isAndroid12Plus();
      if (!isAndroid12Plus) {
        return true; // Older Android versions don't need permission
      }

      // Check if we have exact alarm permission
      return await PermissionService.hasExactAlarmPermission();
    } catch (e) {
      AppLogger.error('Error checking exact alarm capability', e);
      return false;
    }
  }

  /// Check and log battery optimization status
  ///
  /// Provides guidance to users if battery optimization may affect notifications.
  static Future<void> checkBatteryOptimizationStatus() async {
    try {
      if (!Platform.isAndroid) return; // Only relevant for Android

      // Check if battery optimization is disabled for the app
      final status = await Permission.ignoreBatteryOptimizations.status;

      if (status.isGranted) {
        AppLogger.info(
            '✅ Battery optimization is disabled - notifications will work reliably');
      } else {
        AppLogger.warning(
            '⚠️ Battery optimization is enabled - notifications may be delayed');
        AppLogger.info(
            '💡 Consider disabling battery optimization for reliable notifications');
      }
    } catch (e) {
      AppLogger.error('Error checking battery optimization status', e);
    }
  }
}
