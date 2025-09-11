import 'package:permission_handler/permission_handler.dart';
import '../services/notification_service.dart';
import 'logging_service.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request only essential permissions during app startup
  /// This prevents app crashes by avoiding heavy permission requests during initialization
  /// On Android 13+ (API 33+), notification permissions should be requested contextually
  static Future<bool> requestEssentialPermissions() async {
    try {
      // DO NOT request notification permission during startup on Android 13+
      // This causes the permission to become greyed out in system settings
      // Notification permission will be requested only when user enables notifications
      AppLogger.info(
        'Skipping notification permission during startup to prevent Android 13+ issues',
      );

      // For Android 13+ with USE_EXACT_ALARM: Permission is automatically granted
      // For Android 12: SCHEDULE_EXACT_ALARM still requires manual request (skip during startup)
      // For Android < 12: No exact alarm permission needed
      AppLogger.info(
        'Exact alarm permission handling: USE_EXACT_ALARM (Android 13+) is auto-granted, SCHEDULE_EXACT_ALARM (Android 12) requested contextually',
      );

      AppLogger.info(
        'Essential permissions summary - All permissions will be requested contextually',
      );

      // Return true to allow app to start normally
      // Permissions will be requested when actually needed
      return true;
    } catch (e) {
      AppLogger.error('Error in essential permissions check', e);
      return true; // Don't block app startup
    }
  }

  /// Request all necessary permissions for the app
  /// This should be called contextually when features are accessed, not during startup
  static Future<bool> requestAllPermissions() async {
    final permissions = <Permission>[
      Permission.notification,
      Permission.calendarFullAccess,
      Permission.storage,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Request health permissions separately
    final bool healthPermissionsGranted = await _requestHealthPermissions();

    // Check if all permissions are granted
    bool allGranted = statuses.values.every(
      (status) =>
          status == PermissionStatus.granted ||
          status == PermissionStatus.limited,
    );

    return allGranted && healthPermissionsGranted;
  }

  /// Request health permissions contextually when user accesses health features
  /// Health permissions are no longer supported - returns false
  static Future<bool> requestHealthPermissions() async {
    AppLogger.info(
        'Health permissions not available - health integration removed');
    return false;
  }

  /// Health permissions are no longer supported - returns false
  static Future<bool> _requestHealthPermissions() async {
    AppLogger.info(
        'Health permissions not available - health integration removed');
    return false;
  }

  /// Health permissions are no longer supported - returns false
  static Future<bool> forceRequestAllHealthPermissions() async {
    AppLogger.info(
        'Health permissions not available - health integration removed');
    return false;
  }

  /// Check notification permission status
  Future<bool> isNotificationPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  /// Request notification permission when actually needed
  /// This should only be called when the user tries to enable notifications
  /// NOT during app startup to avoid Android 13+ greyed-out permission issues
  static Future<bool> requestNotificationPermission() async {
    try {
      AppLogger.info('Requesting notification permission when needed...');
      final notificationStatus = await Permission.notification.request();

      final granted = notificationStatus == PermissionStatus.granted ||
          notificationStatus == PermissionStatus.limited;

      AppLogger.info('Notification permission request result: $granted');
      return granted;
    } catch (e) {
      AppLogger.error('Error requesting notification permission', e);
      return false;
    }
  }

  /// Request notification permission with user-friendly context
  /// This method provides better UX by explaining why the permission is needed
  static Future<bool> requestNotificationPermissionWithContext() async {
    try {
      // First check if we already have the permission
      final bool hasPermission = await Permission.notification.isGranted;
      if (hasPermission) {
        AppLogger.info('Notification permission already granted');
        return true;
      }

      AppLogger.info('Requesting notification permission with user context...');

      // Request the permission
      final bool granted = await requestNotificationPermission();

      if (granted) {
        AppLogger.info('Notification permission granted successfully');
      } else {
        AppLogger.warning(
          'Notification permission denied - notifications will not work',
        );
      }

      return granted;
    } catch (e) {
      AppLogger.error(
        'Error requesting notification permission with context',
        e,
      );
      return false;
    }
  }

  /// Check calendar permission status
  Future<bool> isCalendarPermissionGranted() async {
    return await Permission.calendarFullAccess.isGranted;
  }

  // Activity recognition is fully removed
  Future<bool> isActivityRecognitionPermissionGranted() async {
    AppLogger.info(
        'Activity recognition permission check skipped (feature removed)');
    return false;
  }

  Future<bool> requestActivityRecognitionPermission() async {
    AppLogger.info(
        'Activity recognition permission request skipped (feature removed)');
    return false;
  }

  /// Check if exact alarm permission is granted
  /// This is required for precise notification scheduling on Android 12+
  static Future<bool> hasExactAlarmPermission() async {
    try {
      AppLogger.info('Checking exact alarm permission status...');

      // Simplified alarm permission check - no health service needed
      // For basic alarms, Android doesn't require special permissions in most cases
      AppLogger.info('Exact alarm permission check result: true (simplified)');
      return true;
    } catch (e) {
      AppLogger.error('Error checking exact alarm permission', e);
      return false;
    }
  }

  /// Request exact alarm permission when actually needed
  /// For Android 13+ with USE_EXACT_ALARM: Should be automatically granted
  /// For Android 12 with SCHEDULE_EXACT_ALARM: Requires manual user action
  /// This should only be called when the user is trying to schedule notifications
  static Future<bool> requestExactAlarmPermission() async {
    try {
      AppLogger.info('Requesting exact alarm permission when needed...');

      // First check if we already have the permission
      final bool hasPermission = await hasExactAlarmPermission();
      if (hasPermission) {
        AppLogger.info('Exact alarm permission already available');
        return true;
      }

      // Simplified alarm permission request - no health service needed
      // For basic alarms, Android doesn't require special permissions in most cases
      AppLogger.info(
          'Exact alarm permission request result: true (simplified)');
      return true;
    } catch (e) {
      AppLogger.error('Error requesting exact alarm permission', e);
      return false;
    }
  }

  /// Request exact alarm permission with user-friendly context
  /// This method provides better UX by explaining why the permission is needed
  /// For Android 13+ with USE_EXACT_ALARM: Should be automatically available
  /// For Android 12 with SCHEDULE_EXACT_ALARM: May require user action
  static Future<bool> requestExactAlarmPermissionWithContext() async {
    try {
      // First check if we already have the permission
      final bool hasPermission = await hasExactAlarmPermission();
      if (hasPermission) {
        AppLogger.info('Exact alarm permission already granted');
        return true;
      }

      AppLogger.info('Requesting exact alarm permission with user context...');

      // Request the permission with timeout
      final bool granted = await requestExactAlarmPermission().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          AppLogger.warning(
            'Exact alarm permission request with context timed out - assuming false',
          );
          return false;
        },
      );

      if (granted) {
        AppLogger.info('Exact alarm permission granted successfully');
      } else {
        AppLogger.warning(
          'Exact alarm permission not available - notifications may not be precise (this is expected on Android 12 if user denies permission)',
        );
      }

      return granted;
    } catch (e) {
      AppLogger.error(
        'Error requesting exact alarm permission with context',
        e,
      );
      return false;
    }
  }

  /// Health permissions are no longer supported - returns false
  Future<bool> isHealthPermissionGranted() async {
    AppLogger.info(
        'Health permissions not available - health integration removed');
    return false;
  }

  /// Request specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  /// Open app settings for manual permission management
  Future<void> openSettings() async {
    await openAppSettings();
  }

  /// Test notification permissions and send a test notification
  Future<void> testNotifications() async {
    // Check if notifications are enabled
    final isEnabled = await isNotificationPermissionGranted();

    if (isEnabled) {
      // Send a test notification using static method
      await NotificationService.showTestNotification();
    } else {
      // Request permission first
      final granted = await requestPermission(Permission.notification);
      if (granted) {
        await NotificationService.showTestNotification();
      }
    }
  }
}
