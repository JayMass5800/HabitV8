import 'package:flutter/services.dart';
import 'package:habitv8/services/logging_service.dart';

/// Simple Health Service using the new SimpleHealthPlugin
/// Based on latest Android Health Connect documentation patterns
class SimpleHealthService {
  static const MethodChannel _channel = MethodChannel('simple_health_plugin');
  static final AppLogger _logger = AppLogger();
  static bool _isInitialized = false;

  /// Initialize the health service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      _logger.info('SimpleHealthService already initialized');
      return true;
    }

    try {
      _logger.info('Initializing SimpleHealthService...');

      // Check if Health Connect is available
      final permissions = await getHealthPermissions();
      if (permissions.isEmpty) {
        _logger.warning(
            'No health permissions available - Health Connect may not be installed');
        return false;
      }

      _isInitialized = true;
      _logger.info(
          'SimpleHealthService initialized successfully with ${permissions.length} permissions');
      return true;
    } catch (e) {
      _logger.error('Failed to initialize SimpleHealthService: $e');
      _isInitialized = false;
      return false;
    }
  }

  /// Get the list of health permissions required by the app
  static Future<List<String>> getHealthPermissions() async {
    try {
      final List<dynamic> permissions =
          await _channel.invokeMethod('getHealthPermissions');
      return permissions.cast<String>();
    } catch (e) {
      _logger.error('Failed to get health permissions: $e');
      return [];
    }
  }

  /// Request health permissions
  static Future<bool> requestPermissions() async {
    try {
      _logger.info('Requesting health permissions...');
      final bool granted = await _channel.invokeMethod('requestPermissions');
      _logger.info('Health permissions request result: $granted');
      return granted;
    } catch (e) {
      _logger.error('Failed to request health permissions: $e');
      return false;
    }
  }

  /// Check current permission status
  static Future<Map<String, dynamic>> checkPermissions() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('checkPermissions');
      return Map<String, dynamic>.from(result);
    } catch (e) {
      _logger.error('Failed to check permissions: $e');
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
        _logger.error(
            'SimpleHealthService not initialized, cannot get steps data');
        return [];
      }
    }

    try {
      _logger.info(
          'SimpleHealthService: Getting steps data from ${startTime.toIso8601String()} to ${endTime.toIso8601String()}');
      _logger.info('  Start timestamp: ${startTime.millisecondsSinceEpoch}');
      _logger.info('  End timestamp: ${endTime.millisecondsSinceEpoch}');

      final List<dynamic> result = await _channel.invokeMethod('getStepsData', {
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _logger.error('Steps data request timed out after 10 seconds');
          return <dynamic>[];
        },
      );

      final stepsData = result
          .cast<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      _logger.info(
          'SimpleHealthService: Retrieved ${stepsData.length} steps records');

      if (stepsData.isNotEmpty) {
        _logger.info('Sample steps data: ${stepsData.first}');
      } else {
        _logger.warning('No steps data found in the specified time range');
      }

      return stepsData;
    } catch (e) {
      _logger.error('Failed to get steps data: $e');
      return [];
    }
  }

  /// Get heart rate data for a time range
  static Future<List<Map<String, dynamic>>> getHeartRateData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      _logger.info(
          'SimpleHealthService: Getting heart rate data from $startTime to $endTime');

      final List<dynamic> result =
          await _channel.invokeMethod('getHeartRateData', {
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      });

      final heartRateData = result
          .cast<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      _logger.info(
          'SimpleHealthService: Retrieved ${heartRateData.length} heart rate records');
      return heartRateData;
    } catch (e) {
      _logger.error('Failed to get heart rate data: $e');
      return [];
    }
  }

  /// Get sleep data for a time range
  static Future<List<Map<String, dynamic>>> getSleepData({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    try {
      _logger.info(
          'SimpleHealthService: Getting sleep data from $startTime to $endTime');

      final List<dynamic> result = await _channel.invokeMethod('getSleepData', {
        'startTime': startTime.millisecondsSinceEpoch,
        'endTime': endTime.millisecondsSinceEpoch,
      });

      final sleepData = result
          .cast<Map<dynamic, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      _logger.info(
          'SimpleHealthService: Retrieved ${sleepData.length} sleep records');
      return sleepData;
    } catch (e) {
      _logger.error('Failed to get sleep data: $e');
      return [];
    }
  }

  /// Test the simple health service with basic data retrieval
  static Future<void> testHealthService() async {
    _logger.info('=== Testing Simple Health Service ===');

    try {
      // Check permissions
      final permissionStatus = await checkPermissions();
      _logger.info('Permission Status: $permissionStatus');

      if (!permissionStatus['hasAllPermissions']) {
        _logger.warning(
            'Not all permissions granted. Some data may not be available.');
      }

      // Test data retrieval for the last 24 hours
      final endTime = DateTime.now();
      final startTime = endTime.subtract(const Duration(hours: 24));

      // Test steps data
      final stepsData =
          await getStepsData(startTime: startTime, endTime: endTime);
      _logger.info('Steps test result: ${stepsData.length} records');
      if (stepsData.isNotEmpty) {
        _logger.info('Sample steps data: ${stepsData.first}');
      }

      // Test heart rate data
      final heartRateData =
          await getHeartRateData(startTime: startTime, endTime: endTime);
      _logger.info('Heart rate test result: ${heartRateData.length} records');
      if (heartRateData.isNotEmpty) {
        _logger.info('Sample heart rate data: ${heartRateData.first}');
      }

      // Test sleep data
      final sleepData =
          await getSleepData(startTime: startTime, endTime: endTime);
      _logger.info('Sleep test result: ${sleepData.length} records');
      if (sleepData.isNotEmpty) {
        _logger.info('Sample sleep data: ${sleepData.first}');
      }

      _logger.info('=== Simple Health Service Test Complete ===');
    } catch (e) {
      _logger.error('Simple Health Service test failed: $e');
    }
  }
}
