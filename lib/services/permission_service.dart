import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import '../services/notification_service.dart';
import 'logging_service.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request all necessary permissions for the app
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
    bool allGranted = statuses.values.every((status) =>
        status == PermissionStatus.granted || status == PermissionStatus.limited);

    return allGranted && healthPermissionsGranted;
  }

  /// Request health-specific permissions
  static Future<bool> _requestHealthPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.WORKOUT,
      HealthDataType.SLEEP_IN_BED,
    ];

    // Create permissions list that matches the length of types
    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    try {
      bool requested = await Health().requestAuthorization(
        types,
        permissions: permissions,
      );
      return requested;
    } catch (e) {
      AppLogger.error('Error requesting health permissions', e);
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

  /// Check health permission status
  Future<bool> isHealthPermissionGranted() async {
    final types = [HealthDataType.STEPS, HealthDataType.HEART_RATE];
    try {
      return await Health().hasPermissions(types) ?? false;
    } catch (e) {
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
