// import 'package:health/health.dart';  // REMOVED - causes Google Play Console issues
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'logging_service.dart';
import 'minimal_health_channel.dart';
import 'health_permission_result.dart';

enum HealthConnectStatus {
  notInstalled,
  installed,
  configured,
  permissionsGranted,
}

/// Utility class for Health Connect operations
class HealthConnectUtils {
  /// Open Health Connect app
  static Future<bool> openHealthConnect() async {
    try {
      // Try to open Health Connect app directly
      const healthConnectPackage = 'com.google.android.apps.healthdata';
      final uri = Uri.parse('package:$healthConnectPackage');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }

      // Fallback to Play Store
      final playStoreUri = Uri.parse(
        'market://details?id=$healthConnectPackage',
      );
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri);
        return true;
      }

      // Final fallback to web Play Store
      final webPlayStoreUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$healthConnectPackage',
      );
      if (await canLaunchUrl(webPlayStoreUri)) {
        await launchUrl(webPlayStoreUri, mode: LaunchMode.externalApplication);
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.error('Failed to open Health Connect', e);
      return false;
    }
  }

  /// Open Health Connect permissions settings
  static Future<bool> openHealthConnectPermissions() async {
    try {
      // Try to open Health Connect permissions directly
      final uri = Uri.parse(
        'android-app://com.google.android.apps.healthdata/permissions',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }

      // Fallback to opening the main app
      return await openHealthConnect();
    } catch (e) {
      AppLogger.error('Failed to open Health Connect permissions', e);
      return await openHealthConnect();
    }
  }
}

/// HealthService provides secure, privacy-focused access to health data for habit tracking.
///
/// This service complies with Android 16 Health Connect permissions and guidelines by:
/// - Only requesting access to specific data types needed for habit tracking features
/// - Processing all data locally on the device
/// - Requiring explicit user consent for each data type
/// - Providing clear justification for each permission request
/// - Allowing users to revoke permissions at any time
/// - Supporting background health data access for continuous monitoring
///
/// CRITICAL: This service supports essential health data types while avoiding Google Play Console rejection
/// NOTE: This service ONLY works with real health data - no mock/simulation data is supported
class HealthService {
  static bool _isInitialized = false;

  /// Get platform-specific health data types
  /// STRICTLY LIMITED to essential data types to prevent Google Play Console
  /// static analysis from detecting broader health permissions
  ///
  /// CRITICAL: This list MUST match exactly what's declared in AndroidManifest.xml
  /// and health_permissions.xml to avoid static analysis issues
  static List<String> get _healthDataTypes {
    // FIXED LIST - DO NOT ADD MORE TYPES
    // These are the essential health data types this app requests
    const allowedTypes = [
      'STEPS', // Steps tracking
      'ACTIVE_ENERGY_BURNED', // Calories burned (active)
      'TOTAL_CALORIES_BURNED', // Total calories burned
      'SLEEP_IN_BED', // Sleep duration
      'WATER', // Water intake/hydration
      'MINDFULNESS', // Meditation/mindfulness (when available)
      'WEIGHT', // Body weight
      'HEART_RATE', // Heart rate for habit correlation analysis
    ];

    // Validate that we're not accidentally including forbidden types
    _validateHealthDataTypes(allowedTypes);

    // Log the health data types being requested
    AppLogger.info('Requesting health data types: ${allowedTypes.join(', ')}');

    return allowedTypes;
  }

  /// Validate that only allowed health data types are being used
  /// This prevents accidental inclusion of types that would trigger Google Play Console issues
  static void _validateHealthDataTypes(List<String> types) {
    // List of forbidden types that would trigger Google Play Console static analysis
    const forbiddenTypes = [
      'BLOOD_PRESSURE_SYSTOLIC',
      'BLOOD_PRESSURE_DIASTOLIC',
      'BLOOD_GLUCOSE',
      'BODY_TEMPERATURE',
      'RESPIRATORY_RATE',
      'NUTRITION',
      'EXERCISE',
      'DISTANCE',
      'OXYGEN_SATURATION',
      'ELECTROCARDIOGRAM',
      'BODY_FAT_PERCENTAGE',
      'LEAN_BODY_MASS',
      // Add more forbidden types as needed
    ];

    for (final type in types) {
      if (forbiddenTypes.contains(type)) {
        throw Exception(
          'FORBIDDEN HEALTH DATA TYPE DETECTED: $type - This would trigger Google Play Console rejection!',
        );
      }
    }

    // Validate we have reasonable number of types (not too many to trigger scrutiny)
    if (types.length > 10) {
      throw Exception(
        'TOO MANY HEALTH DATA TYPES: ${types.length} types may trigger Google Play Console rejection!',
      );
    }

    AppLogger.info(
      'Health data types validation passed: ${types.length} allowed types',
    );
  }

  /// Initialize health service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      AppLogger.info('Health service already initialized');
      return true;
    }

    try {
      AppLogger.info(
        'Initializing health service with custom Health Connect integration...',
      );

      // Check platform support - currently only Android with Health Connect
      if (!Platform.isAndroid) {
        AppLogger.warning(
          'Health data currently only supported on Android with Health Connect',
        );
        _isInitialized = true;
        return false;
      }

      // Initialize our custom MinimalHealthChannel with all required data types
      AppLogger.info(
        'Initializing MinimalHealthChannel with data types: ${_healthDataTypes.join(', ')}',
      );
      final bool initialized = await MinimalHealthChannel.initialize();

      if (initialized) {
        // Check if Health Connect is available
        final bool available =
            await MinimalHealthChannel.isHealthConnectAvailable();

        if (available) {
          _isInitialized = true;
          AppLogger.info(
            'Health service initialized successfully with Health Connect',
          );
          return true;
        } else {
          _isInitialized = true;
          AppLogger.warning('Health Connect not available on this device');
          return false;
        }
      } else {
        _isInitialized = true;
        AppLogger.warning('MinimalHealthChannel initialization failed');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to initialize health service', e);
      _isInitialized = false;
      return false;
    }
  }

  /// Force re-initialization of the health service
  static Future<bool> reinitialize() async {
    AppLogger.info('Force re-initializing health service...');
    _isInitialized = false;
    return await initialize();
  }

  /// Check if background health permissions are granted
  /// This is critical for continuous health monitoring
  static Future<bool> hasBackgroundPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Get detailed Health Connect status
      final status = await MinimalHealthChannel.getHealthConnectStatus();

      // Check if background permission is granted
      final bool hasBackgroundPermission =
          status["hasBackgroundPermission"] ?? false;

      AppLogger.info(
          "Background health permission status: $hasBackgroundPermission");

      return hasBackgroundPermission;
    } catch (e) {
      AppLogger.error("Error checking background health permissions", e);
      return false;
    }
  }

  /// Request health permissions with explicit background access
  /// This ensures the app can monitor health data in the background
  static Future<HealthPermissionResult>
      requestPermissionsWithBackground() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info(
          "Requesting health permissions with explicit background access");

      // Ensure BACKGROUND_HEALTH_DATA is included in the request
      if (!_healthDataTypes.contains("BACKGROUND_HEALTH_DATA")) {
        _healthDataTypes.add("BACKGROUND_HEALTH_DATA");
        AppLogger.info("Added BACKGROUND_HEALTH_DATA to permission request");
      }

      // Request permissions using standard method
      final result = await requestPermissions();

      // Verify background permission specifically
      if (result.granted) {
        final hasBackground = await hasBackgroundPermissions();

        if (!hasBackground) {
          AppLogger.warning(
              "Regular permissions granted but BACKGROUND permission missing");
          return HealthPermissionResult(
            granted: true,
            backgroundGranted: false,
            needsHealthConnect: false,
            message:
                "Health permissions granted but background access is missing",
          );
        } else {
          AppLogger.info("All permissions including background access granted");
          return HealthPermissionResult(
            granted: true,
            backgroundGranted: true,
            needsHealthConnect: false,
            message:
                "All health permissions including background access granted",
          );
        }
      }

      return result;
    } catch (e) {
      AppLogger.error("Error requesting health permissions with background", e);
      return HealthPermissionResult(
        granted: false,
        backgroundGranted: false,
        needsHealthConnect: false,
        message: "Error requesting permissions: $e",
      );
    }
  }

  /// Request health data permissions with enhanced user guidance
  static Future<HealthPermissionResult> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info(
        'Requesting health permissions for ${_healthDataTypes.length} data types',
      );
      AppLogger.info('Data types: ${_healthDataTypes.join(', ')}');

      // Log each data type individually for debugging
      for (var type in _healthDataTypes) {
        AppLogger.info('  - Health data type: $type');
      }

      // Verify critical permissions are included
      final criticalTypes = [
        'HEART_RATE',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
      ];
      for (var type in criticalTypes) {
        if (_healthDataTypes.contains(type)) {
          AppLogger.info('✅ Critical permission included: $type');
        } else {
          AppLogger.error('❌ Critical permission MISSING: $type');
        }
      }

      // First check if Health Connect is available and installed
      final bool healthConnectAvailable =
          await MinimalHealthChannel.isHealthConnectAvailable();
      if (!healthConnectAvailable) {
        AppLogger.warning('Health Connect is not available or not installed');
        return HealthPermissionResult(
          granted: false,
          backgroundGranted: false,
          needsHealthConnect: true,
          message: 'Health Connect app is required but not installed',
        );
      }

      // Use our custom MinimalHealthChannel for permission requests
      final bool granted = await MinimalHealthChannel.requestPermissions();

      if (granted) {
        AppLogger.info('Health permissions granted successfully');

        // Verify permissions were actually granted
        final bool hasPerms = await MinimalHealthChannel.hasPermissions();
        AppLogger.info('Permission verification result: $hasPerms');

        return HealthPermissionResult(
          granted: hasPerms,
          needsHealthConnect: false,
          message: hasPerms
              ? 'Health permissions granted successfully'
              : 'Permission verification failed',
        );
      } else {
        AppLogger.info('Health permissions denied by user');

        // Check if this is because Health Connect needs setup
        final bool stillAvailable =
            await MinimalHealthChannel.isHealthConnectAvailable();

        return HealthPermissionResult(
          granted: false,
          needsHealthConnect: !stillAvailable,
          needsManualSetup: stillAvailable,
          message: stillAvailable
              ? 'Permissions denied. You may need to enable them manually in Health Connect.'
              : 'Health Connect needs to be set up first.',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to request health permissions', e);
      return HealthPermissionResult(
        granted: false,
        backgroundGranted: false,
        needsHealthConnect: false,
        message: 'Error requesting permissions: $e',
      );
    }
  }

  /// Legacy method for backward compatibility
  static Future<bool> requestPermissionsLegacy() async {
    final result = await requestPermissions();
    return result.granted;
  }

  /// Request exact alarm permission for precise notifications
  /// Required for Android 12+ (API 31+) to schedule exact alarms
  static Future<bool> requestExactAlarmPermission() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Requesting exact alarm permission...');
      final bool result =
          await MinimalHealthChannel.requestExactAlarmPermission();
      AppLogger.info('Exact alarm permission request result: $result');
      return result;
    } catch (e) {
      AppLogger.error('Failed to request exact alarm permission', e);
      return false;
    }
  }

  /// Check if exact alarm permission is granted
  /// Required for Android 12+ (API 31+) to schedule exact alarms
  static Future<bool> hasExactAlarmPermission() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Checking exact alarm permission...');
      final bool result = await MinimalHealthChannel.hasExactAlarmPermission();
      AppLogger.info('Exact alarm permission status: $result');
      return result;
    } catch (e) {
      AppLogger.error('Failed to check exact alarm permission', e);
      return false;
    }
  }

  /// Check if health permissions are granted
  /// Returns true if at least the minimum required permissions are available
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Use our custom MinimalHealthChannel to check permissions
      final bool hasPerms = await MinimalHealthChannel.hasPermissions();
      AppLogger.info('Health permissions check result: $hasPerms');
      return hasPerms;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Check if health data sync is enabled by the user in settings
  /// This is the master switch that controls whether health data should be accessed at all
  static Future<bool> isHealthSyncEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool('health_sync_enabled') ?? false;
      AppLogger.info('Health sync enabled preference: $enabled');
      return enabled;
    } catch (e) {
      AppLogger.error('Error checking health sync preference', e);
      return false;
    }
  }

  /// Check if health data operations should proceed
  /// This combines both user preference and permissions check
  static Future<bool> shouldPerformHealthOperations() async {
    // First check if user has enabled health sync
    final syncEnabled = await isHealthSyncEnabled();
    if (!syncEnabled) {
      AppLogger.info(
          'Health sync disabled by user, skipping health operations');
      return false;
    }

    // Then check if permissions are granted
    final hasPerms = await hasPermissions();
    if (!hasPerms) {
      AppLogger.info(
          'Health permissions not granted, skipping health operations');
      return false;
    }

    return true;
  }

  /// Test method to verify all critical permissions are working
  static Future<Map<String, bool>> testCriticalPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    final results = <String, bool>{};
    final criticalTypes = [
      'HEART_RATE',
      'ACTIVE_ENERGY_BURNED',
      'TOTAL_CALORIES_BURNED',
    ];

    for (final type in criticalTypes) {
      try {
        AppLogger.info('Testing permission for: $type');

        // Try to fetch a small amount of data to test the permission
        final endTime = DateTime.now();
        final startTime = endTime.subtract(const Duration(hours: 1));

        final data = await MinimalHealthChannel.getHealthData(
          dataType: type,
          startDate: startTime,
          endDate: endTime,
        );

        results[type] = data.isNotEmpty;
        AppLogger.info(
          'Permission test for $type: ${results[type] == true ? 'SUCCESS' : 'FAILED'}',
        );
      } catch (e) {
        results[type] = false;
        AppLogger.error('Permission test for $type failed: $e');
      }
    }

    return results;
  }

  /// Get detailed Health Connect status
  static Future<HealthConnectStatus> getHealthConnectStatus() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Get detailed status from native plugin
      final Map<String, dynamic> statusData =
          await MinimalHealthChannel.getHealthConnectStatus();
      final String status = statusData['status'] ?? 'ERROR';

      AppLogger.info('Native Health Connect status: $status');
      AppLogger.info('Status details: ${statusData['message']}');

      switch (status) {
        case 'NOT_INSTALLED':
        case 'NOT_SUPPORTED':
        case 'ERROR':
          return HealthConnectStatus.notInstalled;
        case 'PERMISSIONS_GRANTED':
          return HealthConnectStatus.permissionsGranted;
        case 'INSTALLED':
        default:
          return HealthConnectStatus.installed;
      }
    } catch (e) {
      AppLogger.error('Error checking Health Connect status', e);
      return HealthConnectStatus.notInstalled;
    }
  }

  /// Refresh and re-check health permissions with detailed status
  static Future<HealthPermissionResult> refreshPermissions() async {
    try {
      AppLogger.info('Refreshing health permissions status');

      // Force re-initialization to ensure we have the latest state
      await reinitialize();

      // Check current permissions
      final currentPermissions = await hasPermissions();
      if (currentPermissions) {
        AppLogger.info('Health permissions already granted');
        return HealthPermissionResult(
          granted: true,
          backgroundGranted: false,
          message: 'Health permissions are already granted',
        );
      }

      // Check Health Connect status
      final status = await getHealthConnectStatus();

      switch (status) {
        case HealthConnectStatus.notInstalled:
          return HealthPermissionResult(
            granted: false,
            backgroundGranted: false,
            needsHealthConnect: true,
            message: 'Health Connect app needs to be installed',
          );

        case HealthConnectStatus.installed:
          return HealthPermissionResult(
            granted: false,
            backgroundGranted: false,
            needsManualSetup: true,
            message:
                'Health Connect is installed but permissions need to be enabled',
          );

        case HealthConnectStatus.permissionsGranted:
          return HealthPermissionResult(
            granted: true,
            backgroundGranted: false,
            message: 'Health permissions are granted',
          );

        default:
          return HealthPermissionResult(
            granted: false,
            backgroundGranted: false,
            message: 'Unknown Health Connect status',
          );
      }
    } catch (e) {
      AppLogger.error('Error refreshing health permissions', e);
      return HealthPermissionResult(
        granted: false,
        backgroundGranted: false,
        message: 'Error refreshing permissions: $e',
      );
    }
  }

  /// Legacy method for backward compatibility
  static Future<bool> refreshPermissionsLegacy() async {
    final result = await refreshPermissions();
    return result.granted;
  }

  /// Force request all health permissions, including heart rate and background access
  static Future<bool> forceRequestAllPermissions() async {
    try {
      AppLogger.info(
        'Force requesting all health permissions, including heart rate and background access',
      );

      // Reinitialize to ensure we have the latest data types
      await reinitialize();

      // Start background monitoring to ensure the service is running
      final backgroundStarted =
          await MinimalHealthChannel.startBackgroundMonitoring();
      AppLogger.info(
        'Background monitoring service started: $backgroundStarted',
      );

      // Request permissions explicitly
      final result = await requestPermissions();
      final granted = result.granted;

      if (granted) {
        AppLogger.info('All health permissions successfully granted');

        // Verify heart rate permission specifically
        final heartRateData = await getLatestHeartRate();
        if (heartRateData != null) {
          AppLogger.info('Heart rate permission verified: data accessible');
        } else {
          AppLogger.warning(
            'Heart rate permission may not be granted: no data accessible',
          );
        }

        // Check if background monitoring is active
        final isBackgroundActive =
            await MinimalHealthChannel.isBackgroundMonitoringActive();
        AppLogger.info('Background monitoring active: $isBackgroundActive');

        // If permissions are granted but background monitoring is not active, try to start it again
        if (!isBackgroundActive) {
          final restartResult =
              await MinimalHealthChannel.startBackgroundMonitoring();
          AppLogger.info('Restarted background monitoring: $restartResult');
        }
      } else {
        AppLogger.warning('Failed to grant all health permissions');

        // Try one more time with a direct approach
        AppLogger.info('Trying one more time with direct approach...');
        await Future.delayed(const Duration(seconds: 1));
        final retryResult = await requestPermissions();
        AppLogger.info(
          'Retry permission request result: ${retryResult.granted}',
        );

        return retryResult.granted;
      }

      return granted;
    } catch (e) {
      AppLogger.error('Error force requesting health permissions', e);
      return false;
    }
  }

  /// Get steps data for today
  static Future<int> getStepsToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final int steps = await MinimalHealthChannel.getStepsToday();
      AppLogger.info('Retrieved steps data: $steps');
      return steps;
    } catch (e) {
      AppLogger.error('Error getting steps data', e);
      return 0;
    }
  }

  /// Get active calories burned today
  static Future<double> getActiveCaloriesToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting active calories retrieval...');

      // Get detailed data for debugging
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      AppLogger.info(
        'Requesting active calories from ${startOfDay.toIso8601String()} to ${endOfDay.toIso8601String()}',
      );

      final data = await MinimalHealthChannel.getHealthData(
        dataType: 'ACTIVE_ENERGY_BURNED',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      AppLogger.info('Active calories raw data: ${data.length} records');

      double totalCalories = 0.0;
      for (int i = 0; i < data.length; i++) {
        final record = data[i];
        final value = record['value'] as double;
        final timestamp = record['timestamp'] as int;
        final recordTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

        AppLogger.info(
          'Calories record $i: ${value.round()} cal at ${recordTime.toIso8601String()}',
        );
        totalCalories += value;
      }

      final double calories =
          await MinimalHealthChannel.getActiveCaloriesToday();
      AppLogger.info(
        'Retrieved active calories data: ${calories.round()} (total from ${data.length} records: ${totalCalories.round()})',
      );
      return calories;
    } catch (e) {
      AppLogger.error('Error getting active calories data', e);
      return 0.0;
    }
  }

  /// Get total calories burned today
  static Future<double> getTotalCaloriesToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting total calories retrieval...');

      // Get detailed data for debugging
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      AppLogger.info(
        'Requesting total calories from ${startOfDay.toIso8601String()} to ${endOfDay.toIso8601String()}',
      );

      final data = await MinimalHealthChannel.getHealthData(
        dataType: 'TOTAL_CALORIES_BURNED',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      AppLogger.info('Total calories raw data: ${data.length} records');

      double totalCalories = 0.0;
      for (int i = 0; i < data.length; i++) {
        final record = data[i];
        final value = record['value'] as double;
        final timestamp = record['timestamp'] as int;
        final recordTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

        AppLogger.info(
          'Total calories record $i: ${value.round()} cal at ${recordTime.toIso8601String()}',
        );
        totalCalories += value;
      }

      // Use the MinimalHealthChannel method for consistency
      final double calories =
          await MinimalHealthChannel.getTotalCaloriesToday();
      AppLogger.info(
        'Retrieved total calories data: ${calories.round()} (total from ${data.length} records: ${totalCalories.round()})',
      );
      return calories;
    } catch (e) {
      AppLogger.error('Error getting total calories data', e);
      return 0.0;
    }
  }

  /// Get sleep hours for last night
  static Future<double> getSleepHoursLastNight() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Attempting to retrieve sleep data for last night...');

      final double sleepHours =
          await MinimalHealthChannel.getSleepHoursLastNight();
      AppLogger.info(
        'Retrieved sleep data: ${sleepHours.toStringAsFixed(1)} hours',
      );

      // If we got 0 hours, let's debug further
      if (sleepHours == 0.0) {
        AppLogger.warning('Sleep data returned 0 hours - investigating...');

        // Try to get raw sleep data for debugging with expanded time range
        final now = DateTime.now();
        final threeDaysAgo = now.subtract(const Duration(days: 3));
        final startTime = DateTime(
          threeDaysAgo.year,
          threeDaysAgo.month,
          threeDaysAgo.day,
          18,
        ); // 6 PM three days ago
        final endTime = now; // Current time

        AppLogger.info(
          'Checking sleep data from ${startTime.toIso8601String()} to ${endTime.toIso8601String()}',
        );

        try {
          final rawSleepData = await MinimalHealthChannel.getHealthData(
            dataType: 'SLEEP_IN_BED',
            startDate: startTime,
            endDate: endTime,
          );

          AppLogger.info(
            'Raw sleep data records found: ${rawSleepData.length}',
          );
          for (int i = 0; i < rawSleepData.length && i < 10; i++) {
            final record = rawSleepData[i];
            final timestamp = DateTime.fromMillisecondsSinceEpoch(
              record['timestamp'] as int,
            );
            final endTime = record['endTime'] != null
                ? DateTime.fromMillisecondsSinceEpoch(record['endTime'] as int)
                : null;
            AppLogger.info(
              'Sleep record $i: ${record['value']} minutes from ${timestamp.toIso8601String()} to ${endTime?.toIso8601String() ?? 'unknown'}',
            );
          }

          if (rawSleepData.isEmpty) {
            AppLogger.warning(
              'No sleep records found in Health Connect for the last 3 days',
            );
            AppLogger.info('Troubleshooting steps:');
            AppLogger.info(
              '1. Check if your smartwatch is syncing to Health Connect',
            );
            AppLogger.info(
              '2. Verify sleep tracking is enabled on your smartwatch',
            );
            AppLogger.info(
              '3. Check Health Connect app for sleep data visibility',
            );
            AppLogger.info(
              '4. Ensure your smartwatch app has Health Connect integration',
            );
            AppLogger.info('5. Try manually syncing your smartwatch data');
          } else {
            AppLogger.info(
              'Found sleep records but they may be outside the expected time range for "last night"',
            );
          }
        } catch (debugError) {
          AppLogger.error(
            'Error getting raw sleep data for debugging',
            debugError,
          );
        }
      }

      return sleepHours;
    } catch (e) {
      AppLogger.error('Error getting sleep data', e);
      return 0.0;
    }
  }

  /// Get water intake for today
  static Future<double> getWaterIntakeToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final double waterMl = await MinimalHealthChannel.getWaterIntakeToday();
      AppLogger.info('Retrieved water intake data: ${waterMl.round()}ml');
      return waterMl;
    } catch (e) {
      AppLogger.error('Error getting water intake data', e);
      return 0.0;
    }
  }

  /// Get mindfulness minutes for today
  static Future<double> getMindfulnessMinutesToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 0.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final double mindfulnessMinutes =
          await MinimalHealthChannel.getMindfulnessMinutesToday();
      AppLogger.info(
        'Retrieved mindfulness data: ${mindfulnessMinutes.round()} minutes',
      );
      return mindfulnessMinutes;
    } catch (e) {
      AppLogger.error('Error getting mindfulness data', e);
      return 0.0;
    }
  }

  /// Get latest weight
  static Future<double?> getLatestWeight() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return null;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final double? weight = await MinimalHealthChannel.getLatestWeight();
      if (weight != null) {
        AppLogger.info('Retrieved weight data: ${weight.toStringAsFixed(1)}kg');
      } else {
        AppLogger.info('No weight data available');
      }
      return weight;
    } catch (e) {
      AppLogger.error('Error getting weight data', e);
      return null;
    }
  }

  /// Get medication adherence for today
  /// For now, this returns a default value since medication tracking
  /// is primarily handled through habit completion rather than health data
  static Future<double> getMedicationAdherenceToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return 1.0;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      // For now, return a default adherence value
      // This could be enhanced in the future to track actual medication data
      // from health platforms that support it
      AppLogger.info('Retrieved medication adherence data: 1.0 (default)');
      return 1.0;
    } catch (e) {
      AppLogger.error('Error getting medication adherence data', e);
      return 1.0;
    }
  }

  /// Get latest heart rate reading
  static Future<double?> getLatestHeartRate() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return null;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Attempting to retrieve latest heart rate data...');

      final double? heartRate = await MinimalHealthChannel.getLatestHeartRate();
      if (heartRate != null) {
        AppLogger.info('Retrieved heart rate data: ${heartRate.round()} bpm');
      } else {
        AppLogger.info('No heart rate data available - investigating...');

        // Try to get raw heart rate data for debugging
        final now = DateTime.now();
        final startTime = now.subtract(
          const Duration(hours: 24),
        ); // Last 24 hours

        AppLogger.info(
          'Checking heart rate data from ${startTime.toIso8601String()} to ${now.toIso8601String()}',
        );

        try {
          final rawHeartRateData = await MinimalHealthChannel.getHealthData(
            dataType: 'HEART_RATE',
            startDate: startTime,
            endDate: now,
          );

          AppLogger.info(
            'Raw heart rate data records found: ${rawHeartRateData.length}',
          );
          for (int i = 0; i < rawHeartRateData.length && i < 5; i++) {
            final record = rawHeartRateData[i];
            AppLogger.info('Heart rate record $i: ${record.toString()}');
          }

          if (rawHeartRateData.isEmpty) {
            AppLogger.warning(
              'No heart rate records found in Health Connect for the last 24 hours',
            );
            AppLogger.info('This could mean:');
            AppLogger.info(
              '1. Your smartwatch heart rate data is not syncing to Health Connect',
            );
            AppLogger.info(
              '2. Heart rate data permissions are not properly granted',
            );
            AppLogger.info(
              '3. Your smartwatch app is not compatible with Health Connect',
            );
            AppLogger.info(
              '4. Heart rate data is stored in a different format or location',
            );

            // Try a wider time range
            final widerStartTime = now.subtract(
              const Duration(days: 7),
            ); // Last 7 days
            AppLogger.info('Trying wider time range: last 7 days...');

            final widerRangeData = await MinimalHealthChannel.getHealthData(
              dataType: 'HEART_RATE',
              startDate: widerStartTime,
              endDate: now,
            );

            AppLogger.info(
              'Heart rate data in last 7 days: ${widerRangeData.length} records',
            );

            if (widerRangeData.isNotEmpty) {
              AppLogger.info('Sample heart rate records from last 7 days:');
              for (int i = 0; i < widerRangeData.length && i < 5; i++) {
                final record = widerRangeData[i];
                final timestamp = DateTime.fromMillisecondsSinceEpoch(
                  record['timestamp'] as int,
                );
                AppLogger.info(
                  'HR record $i: ${record['value']} bpm at ${timestamp.toIso8601String()}',
                );
              }
            } else {
              AppLogger.warning('No heart rate data found even in 7-day range');
              AppLogger.info('Troubleshooting steps:');
              AppLogger.info(
                '1. Check if your smartwatch is measuring heart rate',
              );
              AppLogger.info(
                '2. Verify heart rate data is syncing to Health Connect',
              );
              AppLogger.info(
                '3. Check Health Connect app for heart rate data visibility',
              );
              AppLogger.info(
                '4. Ensure continuous heart rate monitoring is enabled',
              );
              AppLogger.info('5. Try manually syncing your smartwatch data');
            }
          }
        } catch (debugError) {
          AppLogger.error(
            'Error getting raw heart rate data for debugging',
            debugError,
          );
        }
      }
      return heartRate;
    } catch (e) {
      AppLogger.error('Error getting heart rate data', e);
      return null;
    }
  }

  /// Get resting heart rate for today
  static Future<double?> getRestingHeartRateToday() async {
    // Check if health operations should proceed
    if (!await shouldPerformHealthOperations()) {
      return null;
    }

    if (!_isInitialized) {
      await initialize();
    }

    try {
      final double? restingHR =
          await MinimalHealthChannel.getRestingHeartRateToday();
      if (restingHR != null) {
        AppLogger.info(
          'Retrieved resting heart rate data: ${restingHR.round()} bpm',
        );
      } else {
        AppLogger.info('No resting heart rate data available');
      }
      return restingHR;
    } catch (e) {
      AppLogger.error('Error getting resting heart rate data', e);
      return null;
    }
  }

  /// Get heart rate data for a specific date range
  static Future<List<Map<String, dynamic>>> getHeartRateData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<Map<String, dynamic>> heartRateData =
          await MinimalHealthChannel.getHeartRateData(startDate, endDate);
      AppLogger.info('Retrieved ${heartRateData.length} heart rate readings');
      return heartRateData;
    } catch (e) {
      AppLogger.error('Error getting heart rate data range', e);
      return [];
    }
  }

  /// Get average heart rate for a specific date
  static Future<double?> getAverageHeartRateForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final heartRateData = await getHeartRateData(
      startDate: startOfDay,
      endDate: endOfDay,
    );

    if (heartRateData.isEmpty) return null;

    final totalHeartRate = heartRateData.fold<double>(
      0.0,
      (sum, reading) => sum + (reading['value'] as double? ?? 0.0),
    );

    return totalHeartRate / heartRateData.length;
  }

  /// Test heart rate data retrieval (for debugging compatibility issues)
  static Future<Map<String, dynamic>> testHeartRateDataRetrieval() async {
    try {
      AppLogger.info('Testing heart rate data retrieval...');

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      AppLogger.info('Requesting heart rate data from $yesterday to $now');

      final heartRateData = await getHeartRateData(
        startDate: yesterday,
        endDate: now,
      );

      final result = {
        'success': true,
        'dataCount': heartRateData.length,
        'startDate': yesterday.toIso8601String(),
        'endDate': now.toIso8601String(),
        'sampleData':
            heartRateData.take(3).toList(), // First 3 samples for debugging
      };

      AppLogger.info('Heart rate test result: $result');
      return result;
    } catch (e) {
      AppLogger.error('Heart rate test failed', e);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get today's health summary with real Health Connect data
  static Future<Map<String, dynamic>> getTodayHealthSummary() async {
    try {
      AppLogger.info(
        'Fetching comprehensive health summary from Health Connect...',
      );

      // Check if health operations should proceed
      if (!await shouldPerformHealthOperations()) {
        AppLogger.info('Health sync disabled, returning empty summary');
        return {
          'steps': 0,
          'activeCalories': 0.0,
          'totalCalories': 0.0,
          'sleepHours': 0.0,
          'waterIntake': 0.0,
          'mindfulnessMinutes': 0.0,
          'weight': null,
          'medicationAdherence': 1.0,
          'heartRate': null,
          'restingHeartRate': null,
          'healthSyncEnabled': false,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      // First, check if we have any data sources connected
      final dataSources = await _checkHealthDataSources();
      AppLogger.info('Health data sources check: $dataSources');

      // Fetch health data with timeouts and error handling to prevent crashes
      // Make calls sequential to reduce load on native plugin
      final results = <dynamic>[];

      final healthDataCalls = [
        () => getStepsToday(),
        () => getActiveCaloriesToday(),
        () => getTotalCaloriesToday(),
        () => getSleepHoursLastNight(),
        () => getWaterIntakeToday(),
        () => getMindfulnessMinutesToday(),
        () => getLatestWeight(),
        () => getMedicationAdherenceToday(),
        () => getLatestHeartRate(),
        () => getRestingHeartRateToday(),
      ];

      for (int i = 0; i < healthDataCalls.length; i++) {
        try {
          final result = await healthDataCalls[i]().timeout(
            const Duration(seconds: 8),
            onTimeout: () {
              AppLogger.warning(
                  'Health data call $i timed out, using default value');
              // Return appropriate default values based on call index
              switch (i) {
                case 0:
                  return 0; // steps
                case 1:
                case 2:
                case 4:
                case 5:
                case 7:
                  return 0.0; // calories, water, mindfulness, medication
                case 3:
                  return 0.0; // sleep
                case 6:
                case 8:
                case 9:
                  return null; // weight, heart rates
                default:
                  return null;
              }
            },
          );
          results.add(result);

          // Small delay between calls to prevent overwhelming the native plugin
          if (i < healthDataCalls.length - 1) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        } catch (e) {
          AppLogger.warning(
              'Health data call $i failed: $e, using default value');
          // Add default values for failed calls
          switch (i) {
            case 0:
              results.add(0);
              break; // steps
            case 1:
            case 2:
            case 4:
            case 5:
            case 7:
              results.add(0.0);
              break; // calories, water, mindfulness, medication
            case 3:
              results.add(0.0);
              break; // sleep
            case 6:
            case 8:
            case 9:
              results.add(null);
              break; // weight, heart rates
            default:
              results.add(null);
          }
        }
      }

      final summary = {
        'steps': results[0] as int,
        'activeCalories': results[1] as double,
        'totalCalories': results[2] as double,
        'sleepHours': results[3] as double,
        'waterIntake': results[4] as double,
        'mindfulnessMinutes': results[5] as double,
        'weight': results[6] as double?,
        'medicationAdherence': results[7] as double,
        'heartRate': results[8] as double?,
        'restingHeartRate': results[9] as double?,
        'healthSyncEnabled': true,
        'timestamp': DateTime.now().toIso8601String(),
        'dataSource': 'health_connect',
        'isInitialized': _isInitialized,
        'dataSources': dataSources,
      };

      // Check if we got any meaningful data
      final hasAnyData = (summary['steps'] as int) > 0 ||
          (summary['activeCalories'] as double) > 0 ||
          (summary['totalCalories'] as double) > 0 ||
          (summary['sleepHours'] as double) > 0 ||
          (summary['waterIntake'] as double) > 0 ||
          (summary['heartRate'] as double?) != null;

      if (!hasAnyData) {
        AppLogger.warning(
            'No health data found - this might indicate missing data sources');
        summary['noDataReason'] = _getNoDataReason(dataSources);
        summary['troubleshootingSteps'] = _getTroubleshootingSteps();
      }

      // Add derived metrics
      final steps = summary['steps'] as int;
      summary['caloriesPerStep'] =
          steps > 0 ? (summary['activeCalories'] as double) / steps : 0.0;

      summary['hydrationStatus'] = _getHydrationStatus(
        summary['waterIntake'] as double,
      );
      summary['sleepQuality'] = _getSleepQuality(
        summary['sleepHours'] as double,
      );
      summary['activityLevel'] = _getActivityLevel(summary['steps'] as int);

      AppLogger.info(
        'Health summary retrieved: ${summary['steps']} steps, ${(summary['activeCalories'] as double).round()} cal, hasData: $hasAnyData',
      );
      return summary;
    } catch (e) {
      AppLogger.error('Error getting health summary', e);
      return {
        'steps': 0,
        'activeCalories': 0.0,
        'sleepHours': 0.0,
        'waterIntake': 0.0,
        'mindfulnessMinutes': 0.0,
        'weight': null,
        'medicationAdherence': 1.0,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
        'dataSource': 'error',
        'isInitialized': _isInitialized,
        'caloriesPerStep': 0.0,
        'hydrationStatus': 'error',
        'sleepQuality': 'error',
        'activityLevel': 'error',
        'troubleshootingSteps': _getTroubleshootingSteps(),
      };
    }
  }

  /// Check what health data sources are available and connected
  static Future<Map<String, dynamic>> _checkHealthDataSources() async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final sources = <String, dynamic>{
        'hasStepsData': false,
        'hasCaloriesData': false,
        'hasSleepData': false,
        'hasHeartRateData': false,
        'hasWaterData': false,
        'totalDataPoints': 0,
        'dataSourcesConnected': <String>[],
        'lastDataTimestamp': null,
      };

      // Check each data type for recent data
      final dataTypes = [
        'STEPS',
        'ACTIVE_ENERGY_BURNED',
        'SLEEP_IN_BED',
        'HEART_RATE',
        'WATER'
      ];

      for (final dataType in dataTypes) {
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: dataType,
            startDate: sevenDaysAgo,
            endDate: now,
          );

          if (data.isNotEmpty) {
            sources['totalDataPoints'] =
                (sources['totalDataPoints'] as int) + data.length;

            // Find the most recent data timestamp
            final latestRecord = data.reduce((a, b) =>
                (a['timestamp'] as int) > (b['timestamp'] as int) ? a : b);
            final latestTimestamp = DateTime.fromMillisecondsSinceEpoch(
                latestRecord['timestamp'] as int);

            if (sources['lastDataTimestamp'] == null ||
                latestTimestamp.isAfter(DateTime.parse(
                    sources['lastDataTimestamp'] as String? ?? '1970-01-01'))) {
              sources['lastDataTimestamp'] = latestTimestamp.toIso8601String();
            }

            switch (dataType) {
              case 'STEPS':
                sources['hasStepsData'] = true;
                sources['dataSourcesConnected'].add('Steps tracking');
                break;
              case 'ACTIVE_ENERGY_BURNED':
                sources['hasCaloriesData'] = true;
                sources['dataSourcesConnected'].add('Calories tracking');
                break;
              case 'SLEEP_IN_BED':
                sources['hasSleepData'] = true;
                sources['dataSourcesConnected'].add('Sleep tracking');
                break;
              case 'HEART_RATE':
                sources['hasHeartRateData'] = true;
                sources['dataSourcesConnected'].add('Heart rate monitoring');
                break;
              case 'WATER':
                sources['hasWaterData'] = true;
                sources['dataSourcesConnected'].add('Hydration tracking');
                break;
            }
          }
        } catch (e) {
          AppLogger.warning('Error checking data source for $dataType: $e');
        }
      }

      AppLogger.info('Data sources found: ${sources['dataSourcesConnected']}');
      AppLogger.info(
          'Total data points in last 7 days: ${sources['totalDataPoints']}');

      return sources;
    } catch (e) {
      AppLogger.error('Error checking health data sources', e);
      return {
        'hasStepsData': false,
        'hasCaloriesData': false,
        'hasSleepData': false,
        'hasHeartRateData': false,
        'hasWaterData': false,
        'totalDataPoints': 0,
        'dataSourcesConnected': <String>[],
        'error': e.toString(),
      };
    }
  }

  /// Get reason why no health data was found
  static String _getNoDataReason(Map<String, dynamic> dataSources) {
    final totalDataPoints = dataSources['totalDataPoints'] as int? ?? 0;
    final connectedSources =
        dataSources['dataSourcesConnected'] as List<String>? ?? [];

    if (totalDataPoints == 0 && connectedSources.isEmpty) {
      return 'No health apps are connected to Health Connect or no data has been recorded yet.';
    } else if (totalDataPoints > 0 && connectedSources.isNotEmpty) {
      return 'Health data exists but may not be from today. Check if your fitness apps are syncing recent data.';
    } else {
      return 'Health Connect permissions are granted but no data sources are actively providing health data.';
    }
  }

  /// Get troubleshooting steps for health data issues
  static List<String> _getTroubleshootingSteps() {
    return [
      '1. Install and set up a fitness app (Google Fit, Samsung Health, Fitbit, etc.)',
      '2. Open Health Connect app and verify data sources are connected',
      '3. Check that your fitness app has Health Connect integration enabled',
      '4. Ensure your fitness app is actively tracking data (walk around, log activities)',
      '5. Try manually syncing your fitness app data',
      '6. Restart both your fitness app and Health Connect',
      '7. Check that Health Connect permissions are granted for all data types',
      '8. Verify your device has recent activity data to sync',
    ];
  }

  /// Debug health data issues specifically for Zepp and Google Fit
  static Future<Map<String, dynamic>> debugHealthDataIssues() async {
    final debug = <String, dynamic>{};

    try {
      AppLogger.info('Starting comprehensive health data debugging...');

      // Test multiple time ranges to find where data exists
      final now = DateTime.now();
      final timeRanges = {
        'last_hour': {
          'start': now.subtract(const Duration(hours: 1)),
          'end': now,
        },
        'today': {
          'start': DateTime(now.year, now.month, now.day),
          'end': now,
        },
        'yesterday': {
          'start': DateTime(now.year, now.month, now.day - 1),
          'end': DateTime(now.year, now.month, now.day),
        },
        'last_3_days': {
          'start': now.subtract(const Duration(days: 3)),
          'end': now,
        },
        'last_week': {
          'start': now.subtract(const Duration(days: 7)),
          'end': now,
        },
        'last_month': {
          'start': now.subtract(const Duration(days: 30)),
          'end': now,
        },
      };

      // Test each data type across all time ranges
      final dataTypes = [
        'STEPS',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
        'HEART_RATE',
        'SLEEP_IN_BED',
        'WATER'
      ];

      for (final dataType in dataTypes) {
        debug[dataType] = <String, dynamic>{};

        for (final rangeName in timeRanges.keys) {
          final range = timeRanges[rangeName]!;

          try {
            AppLogger.info(
                'Testing $dataType for $rangeName: ${range['start']} to ${range['end']}');

            final data = await MinimalHealthChannel.getHealthData(
              dataType: dataType,
              startDate: range['start']!,
              endDate: range['end']!,
            );

            debug[dataType][rangeName] = {
              'recordCount': data.length,
              'timeRange':
                  '${range['start']!.toIso8601String()} to ${range['end']!.toIso8601String()}',
            };

            if (data.isNotEmpty) {
              // Get first and last records
              final firstRecord = data.first;
              final lastRecord = data.last;

              debug[dataType][rangeName]['firstRecord'] = {
                'value': firstRecord['value'],
                'timestamp': firstRecord['timestamp'],
                'readable': DateTime.fromMillisecondsSinceEpoch(
                        firstRecord['timestamp'] as int)
                    .toIso8601String(),
              };

              debug[dataType][rangeName]['lastRecord'] = {
                'value': lastRecord['value'],
                'timestamp': lastRecord['timestamp'],
                'readable': DateTime.fromMillisecondsSinceEpoch(
                        lastRecord['timestamp'] as int)
                    .toIso8601String(),
              };

              // Calculate total value for this range
              if (dataType == 'STEPS') {
                final totalSteps = data.fold<int>(0,
                    (sum, record) => sum + (record['value'] as double).round());
                debug[dataType][rangeName]['totalValue'] = totalSteps;
              } else if (dataType.contains('CALORIES')) {
                final totalCalories = data.fold<double>(
                    0.0, (sum, record) => sum + (record['value'] as double));
                debug[dataType][rangeName]['totalValue'] = totalCalories;
              }
            }

            AppLogger.info('$dataType $rangeName: ${data.length} records');
          } catch (e) {
            debug[dataType][rangeName] = {
              'error': e.toString(),
              'timeRange':
                  '${range['start']!.toIso8601String()} to ${range['end']!.toIso8601String()}',
            };
            AppLogger.error('Error testing $dataType for $rangeName: $e');
          }
        }
      }

      // Add summary analysis
      debug['analysis'] = _analyzeDebugResults(debug);

      // Add specific recommendations for Zepp and Google Fit
      debug['zeppGoogleFitRecommendations'] = [
        'For Zepp App:',
        '• Open Zepp app → Profile → Health Data Sharing → Health Connect',
        '• Ensure all data types are enabled for sharing',
        '• Try manual sync: Pull down to refresh in Zepp app',
        '• Check if Zepp app has background app refresh enabled',
        '',
        'For Google Fit:',
        '• Open Google Fit → Profile → Settings → Connected apps → Health Connect',
        '• Verify all permissions are granted',
        '• Check Google Fit is actively tracking (not just connected)',
        '• Try recording a manual activity in Google Fit',
        '',
        'General Health Connect:',
        '• Open Health Connect app → Data and access → Connected apps',
        '• Verify both Zepp and Google Fit are listed and have permissions',
        '• Check data sources: Health Connect → Browse data → [Data type]',
        '• Try disconnecting and reconnecting apps if no recent data',
      ];

      debug['timestamp'] = DateTime.now().toIso8601String();
      debug['success'] = true;
    } catch (e) {
      debug['error'] = e.toString();
      debug['success'] = false;
      AppLogger.error('Health data debugging failed', e);
    }

    return debug;
  }

  /// Analyze debug results to provide insights
  static Map<String, dynamic> _analyzeDebugResults(
      Map<String, dynamic> debugData) {
    final analysis = <String, dynamic>{};

    try {
      // Check which data types have any data at all
      final dataTypesWithData = <String>[];
      final dataTypesWithoutData = <String>[];

      for (final dataType in [
        'STEPS',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
        'HEART_RATE',
        'SLEEP_IN_BED',
        'WATER'
      ]) {
        final typeData = debugData[dataType] as Map<String, dynamic>?;
        if (typeData != null) {
          bool hasAnyData = false;
          for (final rangeName in typeData.keys) {
            final rangeData = typeData[rangeName] as Map<String, dynamic>?;
            if (rangeData != null &&
                (rangeData['recordCount'] as int? ?? 0) > 0) {
              hasAnyData = true;
              break;
            }
          }

          if (hasAnyData) {
            dataTypesWithData.add(dataType);
          } else {
            dataTypesWithoutData.add(dataType);
          }
        }
      }

      analysis['dataTypesWithData'] = dataTypesWithData;
      analysis['dataTypesWithoutData'] = dataTypesWithoutData;

      // Check for recent data (last 3 days)
      final recentDataTypes = <String>[];
      for (final dataType in dataTypesWithData) {
        final typeData = debugData[dataType] as Map<String, dynamic>;
        final last3DaysData = typeData['last_3_days'] as Map<String, dynamic>?;
        if (last3DaysData != null &&
            (last3DaysData['recordCount'] as int? ?? 0) > 0) {
          recentDataTypes.add(dataType);
        }
      }

      analysis['recentDataTypes'] = recentDataTypes;

      // Provide specific diagnosis
      if (dataTypesWithData.isEmpty) {
        analysis['diagnosis'] = 'NO_DATA_FOUND';
        analysis['issue'] =
            'No health data found in any time range. This suggests Health Connect integration is not working.';
        analysis['priority'] = 'HIGH';
      } else if (recentDataTypes.isEmpty) {
        analysis['diagnosis'] = 'OLD_DATA_ONLY';
        analysis['issue'] =
            'Health data exists but no recent data (last 3 days). Apps may have stopped syncing.';
        analysis['priority'] = 'MEDIUM';
      } else if (recentDataTypes.length < dataTypesWithData.length) {
        analysis['diagnosis'] = 'PARTIAL_SYNC_ISSUE';
        analysis['issue'] =
            'Some data types have recent data, others don\'t. Selective sync issue.';
        analysis['priority'] = 'MEDIUM';
      } else {
        analysis['diagnosis'] = 'DATA_AVAILABLE';
        analysis['issue'] =
            'Health data is available and recent. The issue might be in the app\'s data processing.';
        analysis['priority'] = 'LOW';
      }
    } catch (e) {
      analysis['error'] = e.toString();
    }

    return analysis;
  }

  /// Get hydration status based on water intake
  static String _getHydrationStatus(double waterIntakeMl) {
    if (waterIntakeMl >= 3000) return 'excellent';
    if (waterIntakeMl >= 2000) return 'good';
    if (waterIntakeMl >= 1500) return 'adequate';
    if (waterIntakeMl >= 1000) return 'low';
    return 'very_low';
  }

  /// Get sleep quality based on hours
  static String _getSleepQuality(double sleepHours) {
    if (sleepHours >= 8.5) return 'excellent';
    if (sleepHours >= 7.5) return 'good';
    if (sleepHours >= 6.5) return 'adequate';
    if (sleepHours >= 5.5) return 'poor';
    return 'very_poor';
  }

  /// Get activity level based on steps
  static String _getActivityLevel(int steps) {
    if (steps >= 12000) return 'very_active';
    if (steps >= 8000) return 'active';
    if (steps >= 5000) return 'moderate';
    if (steps >= 2000) return 'light';
    return 'sedentary';
  }

  /// Get health data for specific types and date range
  static Future<List<Map<String, dynamic>>> getHealthDataFromTypes({
    required List<String> types,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      AppLogger.info(
        'Fetching health data for types: ${types.join(', ')} from ${startTime.toIso8601String()} to ${endTime.toIso8601String()}',
      );

      final List<Map<String, dynamic>> allData = [];

      // Fetch data for each requested type
      for (final type in types) {
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: type,
            startDate: startTime,
            endDate: endTime,
          );
          allData.addAll(data);
        } catch (e) {
          AppLogger.warning('Failed to get data for type $type: $e');
        }
      }

      AppLogger.info('Retrieved ${allData.length} total health records');
      return allData;
    } catch (e) {
      AppLogger.error('Error getting health data from types', e);
      return <Map<String, dynamic>>[];
    }
  }

  /// Check if health data is available
  static Future<bool> isHealthDataAvailable() async {
    try {
      return await hasPermissions();
    } catch (e) {
      AppLogger.error('Error checking health data availability', e);
      return false;
    }
  }

  /// Comprehensive health data diagnostic tool
  /// This method performs extensive checks to diagnose health data issues
  static Future<Map<String, dynamic>> diagnoseHealthDataIssues() async {
    final results = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'permissions': {},
      'dataAvailability': {},
      'timeRangeTests': {},
      'recommendations': <String>[],
    };

    try {
      AppLogger.info('🔍 Starting comprehensive health data diagnosis...');

      // Test 1: Check permissions
      AppLogger.info('📋 Testing permissions...');
      final hasPermissions = await HealthService.hasPermissions();
      results['permissions']['hasPermissions'] = hasPermissions;

      if (!hasPermissions) {
        results['recommendations'].add(
            '❌ Health permissions not granted. Go to Settings > Apps > HabitV8 > Permissions > Health Connect and grant all required permissions.');
        AppLogger.error(
            '❌ No health permissions - this is likely the main issue');
        return results;
      }

      AppLogger.info('✅ Health permissions are granted');

      // Test 2: Check data availability for different time ranges
      final now = DateTime.now();
      final testRanges = [
        {
          'name': 'Last 2 hours',
          'start': now.subtract(const Duration(hours: 2)),
          'end': now
        },
        {
          'name': 'Last 24 hours',
          'start': now.subtract(const Duration(hours: 24)),
          'end': now
        },
        {
          'name': 'Last 3 days',
          'start': now.subtract(const Duration(days: 3)),
          'end': now
        },
        {
          'name': 'Last week',
          'start': now.subtract(const Duration(days: 7)),
          'end': now
        },
      ];

      final testDataTypes = [
        'STEPS',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
        'HEART_RATE',
        'SLEEP_IN_BED'
      ];

      for (final range in testRanges) {
        final rangeName = range['name'] as String;
        final startTime = range['start'] as DateTime;
        final endTime = range['end'] as DateTime;

        AppLogger.info('📊 Testing data availability for: $rangeName');
        results['timeRangeTests'][rangeName] = {};

        for (final dataType in testDataTypes) {
          try {
            final data = await MinimalHealthChannel.getHealthData(
              dataType: dataType,
              startDate: startTime,
              endDate: endTime,
            );

            results['timeRangeTests'][rangeName][dataType] = {
              'recordCount': data.length,
              'hasData': data.isNotEmpty,
            };

            if (data.isNotEmpty) {
              AppLogger.info(
                  '✅ $dataType: ${data.length} records found in $rangeName');

              // Log sample data
              final firstRecord = data.first;
              final lastRecord = data.last;
              AppLogger.info(
                  '  First: ${DateTime.fromMillisecondsSinceEpoch(firstRecord['timestamp'] as int).toIso8601String()}');
              AppLogger.info(
                  '  Last: ${DateTime.fromMillisecondsSinceEpoch(lastRecord['timestamp'] as int).toIso8601String()}');
            } else {
              AppLogger.warning('⚠️  $dataType: No data found in $rangeName');
            }
          } catch (e) {
            AppLogger.error('❌ Error testing $dataType for $rangeName: $e');
            results['timeRangeTests'][rangeName][dataType] = {
              'error': e.toString(),
              'hasData': false,
            };
          }
        }
      }

      // Test 3: Generate recommendations based on findings
      AppLogger.info('💡 Generating recommendations...');

      bool hasAnyData = false;
      for (final range in results['timeRangeTests'].values) {
        for (final dataType in (range as Map).values) {
          if ((dataType as Map)['hasData'] == true) {
            hasAnyData = true;
            break;
          }
        }
        if (hasAnyData) break;
      }

      if (!hasAnyData) {
        results['recommendations'].addAll([
          '❌ No health data found in any time range. This suggests:',
          '1. Your fitness apps (Zepp, Google Fit, Samsung Health, etc.) are not syncing to Health Connect',
          '2. Health Connect is not properly configured',
          '3. Your devices are not recording health data',
          '4. Data sources are not connected to Health Connect',
          '',
          '🔧 Troubleshooting steps:',
          '1. Open Health Connect app and check "Data and access" section',
          '2. Verify your fitness apps are listed and have permissions',
          '3. Try manually syncing your fitness apps',
          '4. Check if your smartwatch/fitness tracker is properly connected',
          '5. Ensure your fitness apps have recorded data in the tested time ranges',
        ]);
      } else {
        results['recommendations'].add(
            '✅ Health data is available - the issue may be with specific data types or time ranges');
      }

      AppLogger.info('🏁 Health data diagnosis completed');
      return results;
    } catch (e) {
      AppLogger.error('❌ Error during health data diagnosis', e);
      results['error'] = e.toString();
      results['recommendations'].add('❌ Diagnosis failed with error: $e');
      return results;
    }
  }

  /// Quick health data test - call this method to run diagnostics
  static Future<void> runHealthDataDiagnostics() async {
    AppLogger.info('🚀 Running health data diagnostics...');
    final results = await diagnoseHealthDataIssues();

    AppLogger.info('📋 DIAGNOSIS RESULTS:');
    AppLogger.info('Timestamp: ${results['timestamp']}');
    AppLogger.info(
        'Has Permissions: ${results['permissions']['hasPermissions']}');

    AppLogger.info('📊 DATA AVAILABILITY BY TIME RANGE:');
    for (final entry in (results['timeRangeTests'] as Map).entries) {
      final rangeName = entry.key;
      final rangeData = entry.value as Map;
      AppLogger.info('  $rangeName:');

      for (final dataEntry in rangeData.entries) {
        final dataType = dataEntry.key;
        final data = dataEntry.value as Map;
        final hasData = data['hasData'] ?? false;
        final recordCount = data['recordCount'] ?? 0;
        final status = hasData ? '✅' : '❌';
        AppLogger.info('    $status $dataType: $recordCount records');
      }
    }

    AppLogger.info('💡 RECOMMENDATIONS:');
    for (final recommendation in (results['recommendations'] as List)) {
      AppLogger.info('  $recommendation');
    }

    AppLogger.info(
        '🏁 Diagnostics completed. Check the logs above for detailed results.');
  }

  /// Test Health Connect connection and data availability
  static Future<Map<String, dynamic>> testHealthConnectConnection() async {
    final results = <String, dynamic>{};

    try {
      AppLogger.info('Testing Health Connect connection...');

      // Test 1: Check if Health Connect is available
      final isAvailable = await MinimalHealthChannel.isHealthConnectAvailable();
      results['healthConnectAvailable'] = isAvailable;
      AppLogger.info('Health Connect available: $isAvailable');

      if (!isAvailable) {
        results['error'] = 'Health Connect is not available on this device';
        return results;
      }

      // Test 2: Check permissions
      final hasPerms = await hasPermissions();
      results['hasPermissions'] = hasPerms;
      AppLogger.info('Has permissions: $hasPerms');

      if (!hasPerms) {
        results['error'] = 'Health permissions not granted';
        return results;
      }

      // Test 3: Try to fetch recent data for each type
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final dataTypes = [
        'STEPS',
        'HEART_RATE',
        'SLEEP_IN_BED',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
        'WATER',
        'WEIGHT',
      ];

      for (final dataType in dataTypes) {
        final keyName = dataType.toLowerCase().replaceAll('_', '');
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: dataType,
            startDate: threeDaysAgo,
            endDate: now,
          );
          results['${keyName}Records'] = data.length;
          AppLogger.info('$dataType: ${data.length} records found');

          if (data.isNotEmpty) {
            final latestRecord = data.last;
            final timestamp = DateTime.fromMillisecondsSinceEpoch(
              latestRecord['timestamp'] as int,
            );
            results['${keyName}LatestTimestamp'] = timestamp.toIso8601String();
            results['${keyName}LatestValue'] = latestRecord['value'];
          }
        } catch (e) {
          AppLogger.warning('Error testing $dataType: $e');
          results['${keyName}Error'] = e.toString();
        }
      }

      results['testCompleted'] = true;
      results['testTimestamp'] = DateTime.now().toIso8601String();
    } catch (e) {
      AppLogger.error('Error testing Health Connect connection', e);
      results['error'] = e.toString();
    }

    return results;
  }

  /// Open Health Connect settings (Android only)
  static Future<bool> openHealthConnectSettings() async {
    if (!Platform.isAndroid) {
      AppLogger.info('Health Connect settings only available on Android');
      return false;
    }

    try {
      const url = 'package:com.google.android.apps.healthdata';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch Health Connect settings');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error opening Health Connect settings', e);
      return false;
    }
  }

  /// Check if Health Connect is available
  static Future<bool> isHealthConnectAvailable() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final bool available =
          await MinimalHealthChannel.isHealthConnectAvailable();
      AppLogger.info('Health Connect availability: $available');
      return available;
    } catch (e) {
      AppLogger.error('Error checking Health Connect availability', e);
      return false;
    }
  }

  /// Check if background health data access is granted
  static Future<bool> hasBackgroundHealthDataAccess() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return await MinimalHealthChannel.hasBackgroundHealthDataAccess();
    } catch (e) {
      AppLogger.error('Error checking background health data access', e);
      return false;
    }
  }

  /// Get health service debug info
  static Future<Map<String, dynamic>> getHealthConnectDebugInfo() async {
    try {
      final debugInfo = <String, dynamic>{
        'isInitialized': _isInitialized,
        'realDataOnly': true,
        'isAvailable': await isHealthConnectAvailable(),
        'hasPermissions': await hasPermissions(),
        'hasBackgroundAccess': await hasBackgroundHealthDataAccess(),
        'hasHeartRatePermission': await getLatestHeartRate() != null,
        'isBackgroundMonitoringActive':
            await MinimalHealthChannel.isBackgroundMonitoringActive(),
        'allowedDataTypes': _healthDataTypes,
        'supportedDataTypes': MinimalHealthChannel.getSupportedDataTypes(),
        'platform': Platform.operatingSystem,
        'channelStatus': MinimalHealthChannel.getServiceStatus(),
        'timestamp': DateTime.now().toIso8601String(),
        'message': 'Using custom Health Connect integration - real data only',
      };

      // Add current health summary for debugging
      try {
        debugInfo['currentHealthSummary'] = await getTodayHealthSummary();
      } catch (e) {
        debugInfo['healthSummaryError'] = e.toString();
      }

      return debugInfo;
    } catch (e) {
      AppLogger.error('Error getting Health Connect debug info', e);
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'isInitialized': _isInitialized,
        'realDataOnly': true,
      };
    }
  }

  /// Test health data retrieval with detailed logging
  static Future<Map<String, dynamic>> testHealthDataRetrieval() async {
    final testResults = <String, dynamic>{};

    try {
      AppLogger.info('=== TESTING HEALTH DATA RETRIEVAL ===');

      // Test initialization
      testResults['isInitialized'] = _isInitialized;
      AppLogger.info('Health service initialized: $_isInitialized');

      if (!_isInitialized) {
        AppLogger.info('Attempting to initialize health service...');
        await initialize();
        testResults['initializationAttempted'] = true;
        testResults['isInitializedAfterAttempt'] = _isInitialized;
      }

      // Test permissions
      final hasPerms = await hasPermissions();
      testResults['hasPermissions'] = hasPerms;
      AppLogger.info('Has permissions: $hasPerms');

      if (!hasPerms) {
        AppLogger.warning('No permissions - requesting...');
        final permResult = await requestPermissions();
        testResults['permissionRequestResult'] = permResult;
        AppLogger.info('Permission request result: $permResult');
      }

      // Test Health Connect availability
      final isAvailable = await isHealthConnectAvailable();
      testResults['isHealthConnectAvailable'] = isAvailable;
      AppLogger.info('Health Connect available: $isAvailable');

      // Test individual data types
      AppLogger.info('Testing individual data retrieval...');

      // Test steps
      try {
        final steps = await getStepsToday();
        testResults['stepsToday'] = steps;
        AppLogger.info('Steps today: $steps');
      } catch (e) {
        testResults['stepsError'] = e.toString();
        AppLogger.error('Error getting steps', e);
      }

      // Test active calories
      try {
        final calories = await getActiveCaloriesToday();
        testResults['activeCaloriesToday'] = calories;
        AppLogger.info('Active calories today: $calories');
      } catch (e) {
        testResults['activeCaloriesError'] = e.toString();
        AppLogger.error('Error getting active calories', e);
      }

      // Test sleep
      try {
        final sleep = await getSleepHoursLastNight();
        testResults['sleepHoursLastNight'] = sleep;
        AppLogger.info('Sleep hours last night: $sleep');
      } catch (e) {
        testResults['sleepError'] = e.toString();
        AppLogger.error('Error getting sleep', e);
      }

      // Test raw health data from minimal channel
      try {
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final rawStepsData = await MinimalHealthChannel.getHealthData(
          dataType: 'STEPS',
          startDate: startOfDay,
          endDate: endOfDay,
        );
        testResults['rawStepsDataCount'] = rawStepsData.length;
        testResults['rawStepsData'] =
            rawStepsData.take(3).toList(); // First 3 records
        AppLogger.info('Raw steps data records: ${rawStepsData.length}');
      } catch (e) {
        testResults['rawDataError'] = e.toString();
        AppLogger.error('Error getting raw health data', e);
      }

      AppLogger.info('=== HEALTH DATA TEST COMPLETE ===');
      return testResults;
    } catch (e) {
      AppLogger.error('Error in health data test', e);
      testResults['testError'] = e.toString();
      return testResults;
    }
  }

  /// Comprehensive Health Connect diagnostic tool
  static Future<Map<String, dynamic>> runHealthConnectDiagnostics() async {
    final diagnostics = <String, dynamic>{};

    try {
      AppLogger.info('Running comprehensive Health Connect diagnostics...');

      // 1. Check initialization
      diagnostics['isInitialized'] = _isInitialized;

      // 2. Check Health Connect availability
      final isAvailable = await MinimalHealthChannel.isHealthConnectAvailable();
      diagnostics['healthConnectAvailable'] = isAvailable;

      // 3. Get detailed Health Connect status
      final status = await getHealthConnectStatus();
      diagnostics['healthConnectStatus'] = status.name;

      // 4. Check permissions
      final hasPerms = await hasPermissions();
      diagnostics['hasPermissions'] = hasPerms;

      // 5. Test data retrieval for each type
      final dataTypes = [
        'STEPS',
        'SLEEP_IN_BED',
        'HEART_RATE',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
      ];
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      for (final dataType in dataTypes) {
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: dataType,
            startDate: yesterday,
            endDate: now,
          );
          diagnostics['${dataType.toLowerCase()}_records'] = data.length;
          diagnostics['${dataType.toLowerCase()}_sample'] =
              data.take(2).toList();
        } catch (e) {
          diagnostics['${dataType.toLowerCase()}_error'] = e.toString();
        }
      }

      // 6. Check specific time ranges for sleep
      final sleepStart = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        18,
      );
      final sleepEnd = DateTime(now.year, now.month, now.day, 12);

      try {
        final sleepData = await MinimalHealthChannel.getHealthData(
          dataType: 'SLEEP_IN_BED',
          startDate: sleepStart,
          endDate: sleepEnd,
        );
        diagnostics['sleep_extended_range_records'] = sleepData.length;
        diagnostics['sleep_time_range'] =
            '${sleepStart.toIso8601String()} to ${sleepEnd.toIso8601String()}';
      } catch (e) {
        diagnostics['sleep_extended_range_error'] = e.toString();
      }

      // 7. Check heart rate over longer period
      final heartRateStart = now.subtract(const Duration(days: 7));
      try {
        final heartRateData = await MinimalHealthChannel.getHealthData(
          dataType: 'HEART_RATE',
          startDate: heartRateStart,
          endDate: now,
        );
        diagnostics['heart_rate_7day_records'] = heartRateData.length;
      } catch (e) {
        diagnostics['heart_rate_7day_error'] = e.toString();
      }

      diagnostics['timestamp'] = DateTime.now().toIso8601String();
      diagnostics['success'] = true;

      AppLogger.info('Health Connect diagnostics completed successfully');
      AppLogger.info('Diagnostics summary: ${diagnostics.toString()}');
    } catch (e) {
      diagnostics['error'] = e.toString();
      diagnostics['success'] = false;
      AppLogger.error('Health Connect diagnostics failed', e);
    }

    return diagnostics;
  }

  /// Get health insights with intelligent analysis from real Health Connect data
  static Future<Map<String, dynamic>> getHealthInsights({int days = 7}) async {
    try {
      final summary = await getTodayHealthSummary();
      final insights = <String>[];
      final recommendations = <String>[];

      // Analyze activity level
      final steps = summary['steps'] as int;
      final activityLevel = summary['activityLevel'] as String;

      if (activityLevel == 'very_active') {
        insights.add('🏃‍♂️ Excellent activity level with $steps steps today!');
        recommendations.add(
          'Keep up the great work! Consider adding strength training.',
        );
      } else if (activityLevel == 'active') {
        insights.add('👟 Good activity level with $steps steps today');
        recommendations.add(
          'Try to reach 10,000+ steps for optimal health benefits.',
        );
      } else if (activityLevel == 'moderate') {
        insights.add('🚶‍♂️ Moderate activity with $steps steps today');
        recommendations.add(
          'Consider increasing daily movement. Take stairs or walk during breaks.',
        );
      } else if (activityLevel == 'light') {
        insights.add('🚶 Light activity with $steps steps today');
        recommendations.add(
          'Try to increase daily movement. Even short walks can help!',
        );
      } else {
        insights.add('📱 Low activity detected with only $steps steps today');
        recommendations.add(
          'Consider setting a daily step goal and taking regular walking breaks.',
        );
      }

      // Analyze sleep quality
      final sleepHours = summary['sleepHours'] as double;
      final sleepQuality = summary['sleepQuality'] as String;

      if (sleepQuality == 'excellent') {
        insights.add(
          '😴 Excellent sleep quality with ${sleepHours.toStringAsFixed(1)} hours',
        );
      } else if (sleepQuality == 'good') {
        insights.add(
          '🛏️ Good sleep with ${sleepHours.toStringAsFixed(1)} hours',
        );
      } else if (sleepQuality == 'adequate') {
        insights.add(
          '💤 Adequate sleep with ${sleepHours.toStringAsFixed(1)} hours',
        );
        recommendations.add(
          'Try to get 7-9 hours of sleep for optimal recovery.',
        );
      } else if (sleepQuality == 'poor') {
        insights.add(
          '⚠️ Poor sleep quality with only ${sleepHours.toStringAsFixed(1)} hours',
        );
        recommendations.add(
          'Prioritize sleep hygiene. Aim for 7-9 hours nightly.',
        );
      } else {
        insights.add(
          '😴 Very poor sleep with ${sleepHours.toStringAsFixed(1)} hours',
        );
        recommendations.add(
          'Consider consulting a healthcare provider about sleep quality.',
        );
      }

      // Analyze hydration
      final waterIntake = summary['waterIntake'] as double;
      final hydrationStatus = summary['hydrationStatus'] as String;

      if (hydrationStatus == 'excellent') {
        insights.add(
          '💧 Excellent hydration with ${(waterIntake / 1000).toStringAsFixed(1)}L water',
        );
      } else if (hydrationStatus == 'good') {
        insights.add(
          '🥤 Good hydration with ${(waterIntake / 1000).toStringAsFixed(1)}L water',
        );
      } else if (hydrationStatus == 'adequate') {
        insights.add(
          '💦 Adequate hydration with ${(waterIntake / 1000).toStringAsFixed(1)}L water',
        );
        recommendations.add(
          'Try to increase water intake slightly for optimal hydration.',
        );
      } else {
        insights.add(
          '🚰 Low hydration with only ${(waterIntake / 1000).toStringAsFixed(1)}L water',
        );
        recommendations.add('Increase water intake. Aim for 2-3 liters daily.');
      }

      // Analyze mindfulness
      final mindfulnessMinutes = summary['mindfulnessMinutes'] as double;
      if (mindfulnessMinutes > 0) {
        insights.add(
          '🧘‍♀️ Great job on ${mindfulnessMinutes.round()} minutes of mindfulness today',
        );
        if (mindfulnessMinutes < 10) {
          recommendations.add(
            'Consider extending mindfulness sessions to 10+ minutes for greater benefits.',
          );
        }
      } else {
        recommendations.add(
          'Consider adding mindfulness or meditation to your daily routine.',
        );
      }

      // Add general insights
      insights.add('📊 Health data from Health Connect integration');
      insights.add('🔒 All data processed locally for privacy');

      return {
        'period': days,
        'summary': summary,
        'insights': insights,
        'recommendations': recommendations,
        'overallScore': _calculateOverallHealthScore(summary),
        'dataSource': 'health_connect',
        'realDataOnly': true,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting health insights', e);
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'insights': ['Error analyzing health data from Health Connect'],
        'recommendations': [
          'Please check Health Connect permissions and data availability',
        ],
        'realDataOnly': true,
        'dataSource': 'error',
      };
    }
  }

  /// Calculate overall health score (0-100) based on real health data
  static int _calculateOverallHealthScore(Map<String, dynamic> summary) {
    try {
      int score = 0;

      // Activity score (0-30 points)
      final activityLevel = summary['activityLevel'] as String;
      switch (activityLevel) {
        case 'very_active':
          score += 30;
          break;
        case 'active':
          score += 25;
          break;
        case 'moderate':
          score += 20;
          break;
        case 'light':
          score += 10;
          break;
        default:
          score += 0;
      }

      // Sleep score (0-30 points)
      final sleepQuality = summary['sleepQuality'] as String;
      switch (sleepQuality) {
        case 'excellent':
          score += 30;
          break;
        case 'good':
          score += 25;
          break;
        case 'adequate':
          score += 20;
          break;
        case 'poor':
          score += 10;
          break;
        default:
          score += 0;
      }

      // Hydration score (0-20 points)
      final hydrationStatus = summary['hydrationStatus'] as String;
      switch (hydrationStatus) {
        case 'excellent':
          score += 20;
          break;
        case 'good':
          score += 15;
          break;
        case 'adequate':
          score += 10;
          break;
        case 'low':
          score += 5;
          break;
        default:
          score += 0;
      }

      // Mindfulness bonus (0-10 points)
      final mindfulness = summary['mindfulnessMinutes'] as double;
      if (mindfulness >= 20) {
        score += 10;
      } else if (mindfulness >= 10) {
        score += 5;
      } else if (mindfulness > 0) {
        score += 2;
      }

      // Weight tracking bonus (0-10 points)
      if (summary['weight'] != null) {
        score += 10;
      }

      return score.clamp(0, 100);
    } catch (e) {
      AppLogger.error('Error calculating health score', e);
      return 50; // Default neutral score
    }
  }

  /// Reset health service state
  static Future<void> resetHealthService() async {
    try {
      _isInitialized = false;
      AppLogger.info('Health service reset successfully');
    } catch (e) {
      AppLogger.error('Error resetting health service', e);
    }
  }

  /// Get service status for monitoring
  static Map<String, dynamic> getServiceStatus() {
    return {
      'isInitialized': _isInitialized,
      'realDataOnly': true,
      'supportedDataTypes': _healthDataTypes.length,
      'platform': Platform.operatingSystem,
      'integration': 'custom_health_connect',
      'channelStatus': MinimalHealthChannel.getServiceStatus(),
      'message': 'Using custom Health Connect integration - real data only',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Start background health monitoring
  static Future<bool> startBackgroundMonitoring() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting background health monitoring...');

      // Check if we have permissions first
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        AppLogger.warning(
            'Cannot start background monitoring - no permissions');
        return false;
      }

      // Start background monitoring via MinimalHealthChannel
      final result = await MinimalHealthChannel.startBackgroundMonitoring();

      if (result) {
        AppLogger.info('Background health monitoring started successfully');
      } else {
        AppLogger.warning('Failed to start background health monitoring');
      }

      return result;
    } catch (e) {
      AppLogger.error('Error starting background health monitoring', e);
      return false;
    }
  }

  /// Detailed calories debugging method
  static Future<Map<String, dynamic>> debugCaloriesData() async {
    final results = <String, dynamic>{};

    try {
      AppLogger.info('Starting detailed calories debugging...');

      // Check permissions first
      final hasPerms = await hasPermissions();
      results['hasPermissions'] = hasPerms;

      if (!hasPerms) {
        results['error'] = 'No health permissions';
        return results;
      }

      // Test different time ranges
      final now = DateTime.now();
      final timeRanges = [
        {
          'name': 'today',
          'start': DateTime(now.year, now.month, now.day),
          'end': now,
        },
        {
          'name': 'yesterday',
          'start': DateTime(now.year, now.month, now.day - 1),
          'end': DateTime(now.year, now.month, now.day),
        },
        {
          'name': 'last7days',
          'start': now.subtract(const Duration(days: 7)),
          'end': now,
        },
      ];

      for (final range in timeRanges) {
        final rangeName = range['name'] as String;
        final startDate = range['start'] as DateTime;
        final endDate = range['end'] as DateTime;

        // Get active calories
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: 'ACTIVE_ENERGY_BURNED',
            startDate: startDate,
            endDate: endDate,
          );

          results['${rangeName}ActiveRecords'] = data.length;
          results['${rangeName}ActiveCalories'] = data.fold<double>(
            0.0,
            (sum, record) => sum + (record['value'] as double),
          );

          if (data.isNotEmpty) {
            results['${rangeName}ActiveFirstRecord'] = {
              'value': data.first['value'],
              'timestamp': DateTime.fromMillisecondsSinceEpoch(
                data.first['timestamp'] as int,
              ).toIso8601String(),
            };
            results['${rangeName}ActiveLastRecord'] = {
              'value': data.last['value'],
              'timestamp': DateTime.fromMillisecondsSinceEpoch(
                data.last['timestamp'] as int,
              ).toIso8601String(),
            };
          }

          AppLogger.info(
            'Active calories $rangeName: ${data.length} records, total: ${results['${rangeName}ActiveCalories']} cal',
          );
        } catch (e) {
          results['${rangeName}ActiveError'] = e.toString();
          AppLogger.error('Error getting active calories for $rangeName', e);
        }

        // Get total calories
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: 'TOTAL_CALORIES_BURNED',
            startDate: startDate,
            endDate: endDate,
          );

          results['${rangeName}TotalRecords'] = data.length;
          results['${rangeName}TotalCalories'] = data.fold<double>(
            0.0,
            (sum, record) => sum + (record['value'] as double),
          );

          if (data.isNotEmpty) {
            results['${rangeName}TotalFirstRecord'] = {
              'value': data.first['value'],
              'timestamp': DateTime.fromMillisecondsSinceEpoch(
                data.first['timestamp'] as int,
              ).toIso8601String(),
            };
            results['${rangeName}TotalLastRecord'] = {
              'value': data.last['value'],
              'timestamp': DateTime.fromMillisecondsSinceEpoch(
                data.last['timestamp'] as int,
              ).toIso8601String(),
            };
          }

          AppLogger.info(
            'Total calories $rangeName: ${data.length} records, total: ${results['${rangeName}TotalCalories']} cal',
          );
        } catch (e) {
          results['${rangeName}TotalError'] = e.toString();
          AppLogger.error('Error getting total calories for $rangeName', e);
        }
      }

      // Test the MinimalHealthChannel methods directly
      try {
        final activeCalories =
            await MinimalHealthChannel.getActiveCaloriesToday();
        results['minimalChannelActiveCalories'] = activeCalories;
        AppLogger.info(
          'MinimalHealthChannel.getActiveCaloriesToday(): $activeCalories',
        );
      } catch (e) {
        results['minimalChannelActiveError'] = e.toString();
        AppLogger.error(
          'Error with MinimalHealthChannel.getActiveCaloriesToday()',
          e,
        );
      }

      try {
        final totalCalories =
            await MinimalHealthChannel.getTotalCaloriesToday();
        results['minimalChannelTotalCalories'] = totalCalories;
        AppLogger.info(
          'MinimalHealthChannel.getTotalCaloriesToday(): $totalCalories',
        );
      } catch (e) {
        results['minimalChannelTotalError'] = e.toString();
        AppLogger.error(
          'Error with MinimalHealthChannel.getTotalCaloriesToday()',
          e,
        );
      }

      results['debugCompleted'] = true;
      results['debugTimestamp'] = DateTime.now().toIso8601String();
    } catch (e) {
      AppLogger.error('Error in calories debugging', e);
      results['error'] = e.toString();
    }

    return results;
  }

  /// Debug health data issues - comprehensive troubleshooting method
  static Future<Map<String, dynamic>>
      debugHealthDataIssuesComprehensive() async {
    final results = <String, dynamic>{};

    try {
      AppLogger.info('Starting comprehensive health data debugging...');

      // Check basic setup
      results['isInitialized'] = _isInitialized;
      results['hasPermissions'] = await hasPermissions();
      results['healthConnectStatus'] = await getHealthConnectStatus();

      // Debug sleep data
      AppLogger.info('Debugging sleep data...');
      final sleepDebug = await _debugSleepData();
      results['sleepDebug'] = sleepDebug;

      // Debug calories data
      AppLogger.info('Debugging calories data...');
      final caloriesDebug = await debugCaloriesData();
      results['caloriesDebug'] = caloriesDebug;

      // Test all data types
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final dataTypes = [
        'STEPS',
        'ACTIVE_ENERGY_BURNED',
        'TOTAL_CALORIES_BURNED',
        'SLEEP_IN_BED',
        'WATER',
        'WEIGHT',
        'HEART_RATE',
      ];

      for (final dataType in dataTypes) {
        try {
          final data = await MinimalHealthChannel.getHealthData(
            dataType: dataType,
            startDate: startOfDay,
            endDate: endOfDay,
          );
          results['${dataType.toLowerCase()}RecordCount'] = data.length;
          AppLogger.info('$dataType: ${data.length} records found');
        } catch (e) {
          results['${dataType.toLowerCase()}Error'] = e.toString();
          AppLogger.error('Error getting $dataType data', e);
        }
      }

      results['debugCompleted'] = true;
      results['debugTimestamp'] = DateTime.now().toIso8601String();
    } catch (e) {
      AppLogger.error('Error in comprehensive health debugging', e);
      results['error'] = e.toString();
    }

    return results;
  }

  /// Debug sleep data specifically
  static Future<Map<String, dynamic>> _debugSleepData() async {
    final results = <String, dynamic>{};

    try {
      final now = DateTime.now();

      // Get raw sleep data for the last 3 days
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      final startTime = DateTime(
        threeDaysAgo.year,
        threeDaysAgo.month,
        threeDaysAgo.day,
        18,
      );

      final rawSleepData = await MinimalHealthChannel.getHealthData(
        dataType: 'SLEEP_IN_BED',
        startDate: startTime,
        endDate: now,
      );

      results['totalSleepRecords'] = rawSleepData.length;
      results['rawSleepData'] =
          rawSleepData.take(10).toList(); // First 10 records

      // Test the sleep calculation method
      final calculatedSleep =
          await MinimalHealthChannel.getSleepHoursLastNight();
      results['calculatedSleepHours'] = calculatedSleep;

      // Analyze sleep records
      if (rawSleepData.isNotEmpty) {
        final sleepAnalysis = <Map<String, dynamic>>[];

        for (int i = 0; i < rawSleepData.length && i < 5; i++) {
          final record = rawSleepData[i];
          final minutes = record['value'] as double;
          final timestamp = record['timestamp'] as int;
          final endTime = record['endTime'] as int?;

          final sessionStart = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final sessionEnd = endTime != null
              ? DateTime.fromMillisecondsSinceEpoch(endTime)
              : sessionStart.add(Duration(minutes: minutes.round()));

          sleepAnalysis.add({
            'index': i,
            'durationMinutes': minutes,
            'durationHours': minutes / 60.0,
            'startTime': sessionStart.toIso8601String(),
            'endTime': sessionEnd.toIso8601String(),
            'isReasonableDuration': minutes >= 60 && minutes <= 960,
          });
        }

        results['sleepAnalysis'] = sleepAnalysis;
      }
    } catch (e) {
      AppLogger.error('Error debugging sleep data', e);
      results['error'] = e.toString();
    }

    return results;
  }

  /// Diagnostic method to check Health Connect data availability
  static Future<Map<String, dynamic>> diagnoseHealthConnectData() async {
    try {
      AppLogger.info('Starting Health Connect data diagnosis...');

      // Check basic availability
      final debugInfo = await getHealthConnectDebugInfo();

      // Try to get a small sample of data for each type
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final diagnosis = <String, dynamic>{
        'debugInfo': debugInfo,
        'dataAvailability': <String, dynamic>{},
        'timestamp': now.toIso8601String(),
      };

      // Test each data type individually
      final dataTypes = [
        'STEPS',
        'HEART_RATE',
        'SLEEP_IN_BED',
        'ACTIVE_ENERGY_BURNED'
      ];

      for (final dataType in dataTypes) {
        try {
          AppLogger.info('Testing data availability for: $dataType');
          final data = await MinimalHealthChannel.getHealthData(
            dataType: dataType,
            startDate: yesterday,
            endDate: now,
          );

          diagnosis['dataAvailability'][dataType] = {
            'recordCount': data.length,
            'hasData': data.isNotEmpty,
            'sampleRecord': data.isNotEmpty ? data.first : null,
          };

          AppLogger.info('$dataType: ${data.length} records found');
        } catch (e) {
          diagnosis['dataAvailability'][dataType] = {
            'error': e.toString(),
            'hasData': false,
          };
          AppLogger.warning('Error testing $dataType: $e');
        }
      }

      return diagnosis;
    } catch (e) {
      AppLogger.error('Error in Health Connect diagnosis', e);
      return {'error': e.toString()};
    }
  }
}
