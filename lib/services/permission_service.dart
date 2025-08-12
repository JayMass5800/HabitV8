import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import '../services/notification_service.dart';
import 'logging_service.dart';

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
      
      AppLogger.info('Essential permission (notification) status: $notificationStatus');
      
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
    bool allGranted = statuses.values.every((status) =>
        status == PermissionStatus.granted || status == PermissionStatus.limited);

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
  /// 
  /// All data is processed locally and used solely for habit tracking features.
  /// Users can revoke these permissions at any time through device settings.
  static Future<bool> _requestHealthPermissions() async {
    // Platform-specific health data types to avoid permission issues
    List<HealthDataType> types;
    
    if (Platform.isAndroid) {
      // Android Health Connect - minimal essential data types only
      // Reduced to minimize excessive permissions in Health Connect
      types = [
        HealthDataType.STEPS,                    // Primary fitness metric
        HealthDataType.ACTIVE_ENERGY_BURNED,     // Exercise intensity tracking
        HealthDataType.SLEEP_IN_BED,             // Sleep duration tracking
        HealthDataType.WATER,                    // Hydration habits
        HealthDataType.MINDFULNESS,              // Meditation tracking
        HealthDataType.WEIGHT,                   // Weight tracking habits
      ];
    } else if (Platform.isIOS) {
      // iOS HealthKit - same minimal essential data types
      types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WATER,
        HealthDataType.MINDFULNESS,
        HealthDataType.WEIGHT,
      ];
    } else {
      // Other platforms - minimal set
      types = [
        HealthDataType.STEPS,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WATER,
      ];
    }

    // Create permissions list that matches the length of types (READ access only)
    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    try {
      AppLogger.info('Requesting health permissions for ${types.length} data types');
      
      // Request authorization with explicit user consent
      bool requested = await Health().requestAuthorization(
        types,
        permissions: permissions,
      );
      
      if (requested) {
        AppLogger.info('Health permission request completed');
        
        // Add a small delay to allow the system to process the permission changes
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Verify that permissions were actually granted
        final bool hasPermissions = await Health().hasPermissions(types) ?? false;
        AppLogger.info('Health permissions verification: $hasPermissions');
        
        if (hasPermissions) {
          AppLogger.info('Health permissions successfully granted for habit tracking features');
          return true;
        } else {
          AppLogger.info('Health permissions were requested but not fully granted');
          
          // On Android, sometimes partial permissions are granted
          // Check individual permissions to provide better feedback
          if (Platform.isAndroid) {
            for (final type in types) {
              final hasIndividualPermission = await Health().hasPermissions([type]) ?? false;
              AppLogger.info('Permission for $type: $hasIndividualPermission');
            }
          }
          
          // Return true if at least STEPS permission is granted (minimum requirement)
          final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
          AppLogger.info('Minimum STEPS permission granted: $hasStepsPermission');
          return hasStepsPermission;
        }
      } else {
        AppLogger.info('Health permissions denied by user');
        return false;
      }
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
    // Use the same platform-specific health data types as we request
    List<HealthDataType> types;
    
    if (Platform.isAndroid) {
      // Android Health Connect - minimal essential data types only
      // Reduced to minimize excessive permissions in Health Connect
      types = [
        HealthDataType.STEPS,                    // Primary fitness metric
        HealthDataType.ACTIVE_ENERGY_BURNED,     // Exercise intensity tracking
        HealthDataType.SLEEP_IN_BED,             // Sleep duration tracking
        HealthDataType.WATER,                    // Hydration habits
        HealthDataType.MINDFULNESS,              // Meditation tracking
        HealthDataType.WEIGHT,                   // Weight tracking habits
      ];
    } else if (Platform.isIOS) {
      // iOS HealthKit - same minimal essential data types
      types = [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WATER,
        HealthDataType.MINDFULNESS,
        HealthDataType.WEIGHT,
      ];
    } else {
      // Other platforms - minimal set
      types = [
        HealthDataType.STEPS,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WATER,
      ];
    }
    
    try {
      final hasPermissions = await Health().hasPermissions(types);
      AppLogger.info('Health permissions check result: $hasPermissions for ${types.length} types');
      
      if (hasPermissions == true) {
        return true;
      }
      
      // If full permissions are not granted, check for minimum requirements
      // At least STEPS permission should be sufficient for basic functionality
      final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
      AppLogger.info('Minimum STEPS permission check: $hasStepsPermission');
      
      if (hasStepsPermission) {
        // Check how many permissions we actually have
        int grantedCount = 0;
        for (final type in types) {
          try {
            final bool? hasIndividual = await Health().hasPermissions([type]);
            if (hasIndividual == true) {
              grantedCount++;
            }
          } catch (e) {
            AppLogger.warning('Error checking individual permission for $type: $e');
          }
        }
        
        AppLogger.info('Health permissions: $grantedCount/${types.length} granted');
        
        // Consider it successful if we have at least 2 permissions including STEPS
        if (grantedCount >= 2) {
          AppLogger.info('Sufficient health permissions satisfied');
          return true;
        } else {
          AppLogger.info('Minimum health permissions satisfied (STEPS only)');
          return true; // Still allow with just STEPS
        }
      }
      
      return false;
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
