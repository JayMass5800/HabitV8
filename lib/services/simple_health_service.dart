import 'package:habitv8/services/logging_service.dart';
import 'package:habitv8/services/minimal_health_channel.dart';

/// Simple Health Service using the new SimpleHealthPlugin
/// Based on latest Android Health Connect documentation patterns
class SimpleHealthService {
  static bool _isInitialized = false;

  /// Initialize the health service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      AppLogger.info('SimpleHealthService already initialized');
      return true;
    }

    try {
      AppLogger.info('Initializing SimpleHealthService...');

      // Check if Health Connect is available
      final permissions = await getHealthPermissions();
      if (permissions.isEmpty) {
        AppLogger.warning(
            'No health permissions available - Health Connect may not be installed');
        return false;
      }

      _isInitialized = true;
      AppLogger.info(
          'SimpleHealthService initialized successfully with ${permissions.length} permissions');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize SimpleHealthService: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Get the list of health permissions required by the app
  static Future<List<String>> getHealthPermissions() async {
    try {
      // Use MinimalHealthChannel to get supported data types
      final supportedTypes = MinimalHealthChannel.getSupportedDataTypes();
      return supportedTypes;
    } catch (e) {
      AppLogger.error('Failed to get health permissions: $e');
      return [];
    }
  }

  /// Request health permissions
  static Future<bool> requestPermissions() async {
    try {
      AppLogger.info('Requesting health permissions...');
      final granted = await MinimalHealthChannel.requestPermissions();
      AppLogger.info('Health permissions request result: $granted');
      return granted;
    } catch (e) {
      AppLogger.error('Failed to request health permissions: $e');
      return false;
    }
  }

  /// Check current permission status
  static Future<Map<String, dynamic>> checkPermissions() async {
    try {
      final result = await MinimalHealthChannel.getHealthConnectStatus();
      return result;
    } catch (e) {
      AppLogger.error('Failed to check permissions: $e');
      return {
        'hasAllPermissions': false,
        'grantedCount': 0,
        'requiredCount': 0,
        'grantedPermissions': <String>[],
        'requiredPermissions': <String>[],
      };
    }
  }

  /// Get steps data for a time range
  static Future<List<Map<String, dynamic>>> getStepsData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        AppLogger.error(
            'SimpleHealthService not initialized, cannot get steps data');
        return [];
      }
    }

    try {
      AppLogger.info(
          'SimpleHealthService: Getting steps data from ${startTime.toIso8601String()} to ${endTime.toIso8601String()}');
      AppLogger.info('  Start timestamp: ${startTime.millisecondsSinceEpoch}');
      AppLogger.info('  End timestamp: ${endTime.millisecondsSinceEpoch}');

      // Use MinimalHealthChannel instead of direct method channel call
      final stepsData = await MinimalHealthChannel.getHealthData(
        dataType: 'STEPS',
        startDate: startTime,
        endDate: endTime,
      );

      AppLogger.info(
          'SimpleHealthService: Retrieved ${stepsData.length} steps records');

      if (stepsData.isNotEmpty) {
        AppLogger.info('Sample steps data: ${stepsData.first}');
      } else {
        AppLogger.warning('No steps data found in the specified time range');
      }

      return stepsData;
    } catch (e) {
      AppLogger.error('Failed to get steps data: $e');
      return [];
    }
  }

  /// Get heart rate data for a time range
  static Future<List<Map<String, dynamic>>> getHeartRateData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      AppLogger.info(
          'SimpleHealthService: Getting heart rate data from $startTime to $endTime');

      // Use MinimalHealthChannel instead of direct method channel call
      final heartRateData = await MinimalHealthChannel.getHealthData(
        dataType: 'HEART_RATE',
        startDate: startTime,
        endDate: endTime,
      );

      AppLogger.info(
          'SimpleHealthService: Retrieved ${heartRateData.length} heart rate records');
      return heartRateData;
    } catch (e) {
      AppLogger.error('Failed to get heart rate data: $e');
      return [];
    }
  }

  /// Get sleep data for a time range
  static Future<List<Map<String, dynamic>>> getSleepData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      AppLogger.info(
          'SimpleHealthService: Getting sleep data from $startTime to $endTime');

      // Use MinimalHealthChannel instead of direct method channel call
      final sleepData = await MinimalHealthChannel.getHealthData(
        dataType: 'SLEEP_IN_BED',
        startDate: startTime,
        endDate: endTime,
      );

      AppLogger.info(
          'SimpleHealthService: Retrieved ${sleepData.length} sleep records');
      return sleepData;
    } catch (e) {
      AppLogger.error('Failed to get sleep data: $e');
      return [];
    }
  }

  /// Test the simple health service with basic data retrieval
  static Future<void> testHealthService() async {
    AppLogger.info('=== Testing Simple Health Service ===');

    try {
      // Check permissions
      final permissionStatus = await checkPermissions();
      AppLogger.info('Permission Status: $permissionStatus');

      if (!permissionStatus['hasAllPermissions']) {
        AppLogger.warning(
            'Not all permissions granted. Some data may not be available.');
      }

      // Test data retrieval for the last 24 hours
      final endTime = DateTime.now();
      final startTime = endTime.subtract(const Duration(hours: 24));

      // Test steps data
      final stepsData =
          await getStepsData(startTime: startTime, endTime: endTime);
      AppLogger.info('Steps test result: ${stepsData.length} records');
      if (stepsData.isNotEmpty) {
        AppLogger.info('Sample steps data: ${stepsData.first}');
      }

      // Test heart rate data
      final heartRateData =
          await getHeartRateData(startTime: startTime, endTime: endTime);
      AppLogger.info('Heart rate test result: ${heartRateData.length} records');
      if (heartRateData.isNotEmpty) {
        AppLogger.info('Sample heart rate data: ${heartRateData.first}');
      }

      // Test sleep data
      final sleepData =
          await getSleepData(startTime: startTime, endTime: endTime);
      AppLogger.info('Sleep test result: ${sleepData.length} records');
      if (sleepData.isNotEmpty) {
        AppLogger.info('Sample sleep data: ${sleepData.first}');
      }

      AppLogger.info('=== Simple Health Service Test Complete ===');
    } catch (e) {
      AppLogger.error('Simple Health Service test failed: $e');
    }
  }
}
