import 'package:permission_handler/permission_handler.dart';
import '../services/notification_service.dart';
import 'logging_service.dart';
import 'health_service.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request only essential permissions during app startup
  /// This prevents app crashes by avoiding heavy permission requests during initialization
  static Future<bool> requestEssentialPermissions() async {
    try {
      // Only request notification permission during startup
      // This is the most critical permission for basic app functionality
      final notificationStatus = await Permission.notification.request();

      AppLogger.info(
        'Essential permission (notification) status: $notificationStatus',
      );

      return notificationStatus == PermissionStatus.granted ||
          notificationStatus == PermissionStatus.limited;
    } catch (e) {
      AppLogger.error('Error requesting essential permissions', e);
      return false;
    }
  }

  /// Request all necessary permissions for the app
  /// This should be called contextually when features are accessed, not during startup
  static Future<bool> requestAllPermissions() async {
    final permissions = <Permission>[
      Permission.notification,
      Permission.calendarFullAccess,
      Permission.activityRecognition,
      Permission.sensors,
      Permission.location,
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
  /// This is the public method that should be called when health integration is needed
  static Future<bool> requestHealthPermissions() async {
    return await _requestHealthPermissions();
  }

  /// Request health-specific permissions with proper user consent
  ///
  /// This method requests access to specific health data types that directly support
  /// habit tracking features. Each data type serves a specific purpose:
  /// - STEPS: For walking/running habit tracking and step count insights
  /// - ACTIVE_ENERGY_BURNED: For correlating energy expenditure with fitness habits
  /// - SLEEP_IN_BED: For sleep habit optimization and bedtime routine tracking
  /// - WATER: For hydration habit tracking and reminders
  /// - MINDFULNESS: For meditation and mindfulness habit completion
  /// - WEIGHT: For weight management habit tracking
  /// - HEART_RATE: For heart rate monitoring and correlation with habits
  ///
  /// All data is processed locally and used solely for habit tracking features.
  /// Users can revoke these permissions at any time through device settings.
  static Future<bool> _requestHealthPermissions() async {
    try {
      AppLogger.info('Requesting health permissions using health service');

      // Use our health service for real health data access
      final bool granted = await HealthService.requestPermissions();

      if (granted) {
        AppLogger.info('Health permissions granted successfully');

        // Verify that permissions were actually granted
        final bool hasPermissions = await HealthService.hasPermissions();
        AppLogger.info('Health permissions verification: $hasPermissions');

        return hasPermissions;
      } else {
        AppLogger.info('Health permissions denied by user');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error requesting health permissions', e);
      return false;
    }
  }

  /// Force request all health permissions, including heart rate
  /// This method should be called when heart rate data access is specifically needed
  static Future<bool> forceRequestAllHealthPermissions() async {
    try {
      AppLogger.info(
        'Force requesting all health permissions, including heart rate',
      );

      // Use the force request method in HealthService
      final bool granted = await HealthService.forceRequestAllPermissions();

      if (granted) {
        AppLogger.info('All health permissions successfully granted');
        return true;
      } else {
        AppLogger.warning('Failed to grant all health permissions');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error force requesting health permissions', e);
      return false;
    }
  }

  /// Check notification permission status
  Future<bool> isNotificationPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  /// Check calendar permission status
  Future<bool> isCalendarPermissionGranted() async {
    return await Permission.calendarFullAccess.isGranted;
  }

  /// Check activity recognition permission status
  Future<bool> isActivityRecognitionPermissionGranted() async {
    try {
      final status = await Permission.activityRecognition.status;
      AppLogger.info('Activity recognition permission status: $status');
      return status == PermissionStatus.granted;
    } catch (e) {
      AppLogger.error('Error checking activity recognition permission', e);
      return false;
    }
  }

  /// Request activity recognition permission
  Future<bool> requestActivityRecognitionPermission() async {
    try {
      AppLogger.info('Requesting activity recognition permission');
      final status = await Permission.activityRecognition.request();
      AppLogger.info('Activity recognition permission request result: $status');
      return status == PermissionStatus.granted;
    } catch (e) {
      AppLogger.error('Error requesting activity recognition permission', e);
      return false;
    }
  }

  /// Check health permission status
  Future<bool> isHealthPermissionGranted() async {
    try {
      // Use our health service to check permissions
      final bool hasPermissions = await HealthService.hasPermissions();
      AppLogger.info('Health permissions check result: $hasPermissions');

      return hasPermissions;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      // If there's an error checking permissions, assume they're not granted
      return false;
    }
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
