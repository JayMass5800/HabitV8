// import 'package:health/health.dart';  // REMOVED - causes Google Play Console issues
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'logging_service.dart';
import 'minimal_health_channel.dart';

/// Result of a health permission request with detailed status information
class HealthPermissionResult {
  final bool granted;
  final bool needsHealthConnect;
  final bool needsManualSetup;
  final String message;

  const HealthPermissionResult({
    required this.granted,
    this.needsHealthConnect = false,
    this.needsManualSetup = false,
    required this.message,
  });

  /// Whether the user needs to install or set up Health Connect
  bool get requiresHealthConnectSetup => needsHealthConnect;

  /// Whether the user needs to manually enable permissions in Health Connect
  bool get requiresManualPermissionSetup => needsManualSetup;

  /// Whether any user action is required
  bool get requiresUserAction => needsHealthConnect || needsManualSetup;
}

/// Health Connect setup status
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
          message: 'Health permissions are already granted',
        );
      }

      // Check Health Connect status
      final status = await getHealthConnectStatus();

      switch (status) {
        case HealthConnectStatus.notInstalled:
          return HealthPermissionResult(
            granted: false,
            needsHealthConnect: true,
            message: 'Health Connect app needs to be installed',
          );

        case HealthConnectStatus.installed:
          return HealthPermissionResult(
            granted: false,
            needsManualSetup: true,
            message:
                'Health Connect is installed but permissions need to be enabled',
          );

        case HealthConnectStatus.permissionsGranted:
          return HealthPermissionResult(
            granted: true,
            message: 'Health permissions are granted',
          );

        default:
          return HealthPermissionResult(
            granted: false,
            message: 'Unknown Health Connect status',
          );
      }
    } catch (e) {
      AppLogger.error('Error refreshing health permissions', e);
      return HealthPermissionResult(
        granted: false,
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
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting active calories retrieval...');

      // First check permissions
      final hasPerms = await hasPermissions();
      AppLogger.info('Active calories request - Has permissions: $hasPerms');

      if (!hasPerms) {
        AppLogger.warning(
          'No health permissions - cannot retrieve active calories data',
        );
        return 0.0;
      }

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
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting total calories retrieval...');

      // First check permissions
      final hasPerms = await hasPermissions();
      AppLogger.info('Total calories request - Has permissions: $hasPerms');

      if (!hasPerms) {
        AppLogger.warning(
          'No health permissions - cannot retrieve total calories data',
        );
        return 0.0;
      }

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
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Attempting to retrieve sleep data for last night...');

      // First check if we have permissions
      final hasPerms = await hasPermissions();
      AppLogger.info('Sleep data request - Has permissions: $hasPerms');

      if (!hasPerms) {
        AppLogger.warning('No health permissions - cannot retrieve sleep data');
        return 0.0;
      }

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
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Attempting to retrieve latest heart rate data...');

      // First check if we have permissions
      final hasPerms = await hasPermissions();
      AppLogger.info('Heart rate data request - Has permissions: $hasPerms');

      if (!hasPerms) {
        AppLogger.warning(
          'No health permissions - cannot retrieve heart rate data',
        );
        return null;
      }

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

  /// Get today's health summary with real Health Connect data
  static Future<Map<String, dynamic>> getTodayHealthSummary() async {
    try {
      AppLogger.info(
        'Fetching comprehensive health summary from Health Connect...',
      );

      // Fetch all health data concurrently for better performance
      final results = await Future.wait([
        getStepsToday(),
        getActiveCaloriesToday(),
        getTotalCaloriesToday(),
        getSleepHoursLastNight(),
        getWaterIntakeToday(),
        getMindfulnessMinutesToday(),
        getLatestWeight(),
        getMedicationAdherenceToday(),
        getLatestHeartRate(),
        getRestingHeartRateToday(),
      ]);

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
        'timestamp': DateTime.now().toIso8601String(),
        'dataSource': 'health_connect',
        'isInitialized': _isInitialized,
      };

      // Add derived metrics
      final steps = summary['steps'] as int;
      summary['caloriesPerStep'] = steps > 0
          ? (summary['activeCalories'] as double) / steps
          : 0.0;

      summary['hydrationStatus'] = _getHydrationStatus(
        summary['waterIntake'] as double,
      );
      summary['sleepQuality'] = _getSleepQuality(
        summary['sleepHours'] as double,
      );
      summary['activityLevel'] = _getActivityLevel(summary['steps'] as int);

      AppLogger.info(
        'Health summary retrieved successfully: ${summary['steps']} steps, ${(summary['activeCalories'] as double).round()} cal',
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
      };
    }
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
          diagnostics['${dataType.toLowerCase()}_sample'] = data
              .take(2)
              .toList();
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
  static Future<Map<String, dynamic>> debugHealthDataIssues() async {
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
      results['rawSleepData'] = rawSleepData
          .take(10)
          .toList(); // First 10 records

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
}
