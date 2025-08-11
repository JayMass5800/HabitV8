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

  /// Request health-specific permissions with proper user consent
  /// 
  /// This method requests access to specific health data types that directly support
  /// habit tracking features. Each data type serves a specific purpose:
  /// - STEPS: For walking/running habit tracking and step count insights
  /// - HEART_RATE: For workout intensity monitoring during fitness habits
  /// - ACTIVE_ENERGY_BURNED: For correlating energy expenditure with fitness habits
  /// - DISTANCE_DELTA: For tracking distance-based exercise habits
  /// - WORKOUT: For automatic detection and completion of fitness habits
  /// - SLEEP_IN_BED: For sleep habit optimization and bedtime routine tracking
  /// 
  /// All data is processed locally and used solely for habit tracking features.
  /// Users can revoke these permissions at any time through device settings.
  static Future<bool> _requestHealthPermissions() async {
    final types = [
      HealthDataType.STEPS,           // For step counting habits and walking goals
      HealthDataType.HEART_RATE,      // For workout intensity and fitness habits
      HealthDataType.ACTIVE_ENERGY_BURNED, // For energy expenditure correlation
      HealthDataType.DISTANCE_DELTA,  // For distance-based exercise habits
      HealthDataType.WORKOUT,         // For automatic fitness habit completion
      HealthDataType.SLEEP_IN_BED,    // For sleep habit optimization
    ];

    // Create permissions list that matches the length of types (READ access only)
    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    try {
      // Request authorization with explicit user consent
      bool requested = await Health().requestAuthorization(
        types,
        permissions: permissions,
      );
      
      if (requested) {
        AppLogger.info('Health permissions granted for habit tracking features');
      } else {
        AppLogger.info('Health permissions denied by user');
      }
      
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
