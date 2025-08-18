import 'dart:io';
import 'package:flutter/services.dart';
import 'logging_service.dart';

/// MinimalHealthChannel provides a direct interface to our custom MinimalHealthPlugin
/// 
/// This service communicates with the native Android plugin that ONLY accesses
/// the 7 essential health data types, preventing Google Play Console rejection.
/// 
/// CRITICAL: This service ONLY works with real Health Connect data on Android.
/// No mock data, no simulation - only authentic health data from the user's device.
class MinimalHealthChannel {
  static const MethodChannel _channel = MethodChannel('minimal_health_service');
  static bool _isInitialized = false;

  /// Supported health data types (matching the native plugin)
  static const List<String> _supportedDataTypes = [
    'STEPS',
    'ACTIVE_ENERGY_BURNED', 
    'SLEEP_IN_BED',
    'WATER',
    'WEIGHT',
    'MINDFULNESS', // Available if supported by Health Connect version
    'HEART_RATE', // Heart rate for habit correlation analysis
  ];

  /// Initialize the minimal health channel
  static Future<bool> initialize() async {
    if (_isInitialized) {
      AppLogger.info('MinimalHealthChannel already initialized');
      return true;
    }

    try {
      AppLogger.info('Initializing MinimalHealthChannel...');
      
      // Only initialize on Android - iOS would need a separate implementation
      if (!Platform.isAndroid) {
        AppLogger.warning('MinimalHealthChannel only supports Android with Health Connect');
        return false;
      }

      // Initialize the native plugin
      final bool result = await _channel.invokeMethod('initialize', {
        'supportedTypes': _supportedDataTypes,
      });

      _isInitialized = result;
      
      if (_isInitialized) {
        AppLogger.info('MinimalHealthChannel initialized successfully');
      } else {
        AppLogger.warning('MinimalHealthChannel initialization failed - Health Connect may not be available');
      }
      
      return _isInitialized;
    } catch (e) {
      AppLogger.error('Failed to initialize MinimalHealthChannel', e);
      _isInitialized = false;
      return false;
    }
  }

  /// Check if Health Connect is available on the device
  static Future<bool> isHealthConnectAvailable() async {
    try {
      if (!Platform.isAndroid) {
        return false;
      }
      
      final bool available = await _channel.invokeMethod('isHealthConnectAvailable');
      AppLogger.info('Health Connect availability: $available');
      return available;
    } catch (e) {
      AppLogger.error('Error checking Health Connect availability', e);
      return false;
    }
  }

  /// Check if health permissions are granted
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final bool hasPerms = await _channel.invokeMethod('hasPermissions');
      AppLogger.info('Health permissions status: $hasPerms');
      return hasPerms;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Request health permissions from the user
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Requesting health permissions...');
      final bool granted = await _channel.invokeMethod('requestPermissions');
      AppLogger.info('Health permissions request result: $granted');
      return granted;
    } catch (e) {
      AppLogger.error('Error requesting health permissions', e);
      return false;
    }
  }

  /// Get health data for a specific type and date range
  static Future<List<Map<String, dynamic>>> getHealthData({
    required String dataType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Validate data type
      if (!_supportedDataTypes.contains(dataType)) {
        AppLogger.error('Unsupported data type: $dataType');
        return [];
      }

      AppLogger.info('Fetching health data for $dataType from ${startDate.toIso8601String()} to ${endDate.toIso8601String()}');
      
      final List<dynamic> result = await _channel.invokeMethod('getHealthData', {
        'dataType': dataType,
        'startDate': startDate.millisecondsSinceEpoch,
        'endDate': endDate.millisecondsSinceEpoch,
      });

      final List<Map<String, dynamic>> healthData = result
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      AppLogger.info('Retrieved ${healthData.length} records for $dataType');
      return healthData;
    } catch (e) {
      AppLogger.error('Error getting health data for $dataType', e);
      return [];
    }
  }

  /// Get steps data for today
  static Future<int> getStepsToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await getHealthData(
        dataType: 'STEPS',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      int totalSteps = 0;
      for (final record in data) {
        totalSteps += (record['value'] as double).round();
      }

      AppLogger.info('Total steps today: $totalSteps');
      return totalSteps;
    } catch (e) {
      AppLogger.error('Error getting steps today', e);
      return 0;
    }
  }

  /// Get active calories burned today
  static Future<double> getActiveCaloriesToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await getHealthData(
        dataType: 'ACTIVE_ENERGY_BURNED',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      double totalCalories = 0.0;
      for (final record in data) {
        totalCalories += record['value'] as double;
      }

      AppLogger.info('Total active calories today: ${totalCalories.round()}');
      return totalCalories;
    } catch (e) {
      AppLogger.error('Error getting active calories today', e);
      return 0.0;
    }
  }

  /// Get sleep hours for last night
  static Future<double> getSleepHoursLastNight() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final startTime = DateTime(yesterday.year, yesterday.month, yesterday.day, 18); // 6 PM yesterday
      final endTime = DateTime(now.year, now.month, now.day, 12); // 12 PM today

      final data = await getHealthData(
        dataType: 'SLEEP_IN_BED',
        startDate: startTime,
        endDate: endTime,
      );

      double totalSleepMinutes = 0.0;
      for (final record in data) {
        totalSleepMinutes += record['value'] as double;
      }

      final sleepHours = totalSleepMinutes / 60.0;
      AppLogger.info('Sleep hours last night: ${sleepHours.toStringAsFixed(1)}');
      return sleepHours;
    } catch (e) {
      AppLogger.error('Error getting sleep hours', e);
      return 0.0;
    }
  }

  /// Get water intake for today
  static Future<double> getWaterIntakeToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await getHealthData(
        dataType: 'WATER',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      double totalLiters = 0.0;
      for (final record in data) {
        totalLiters += record['value'] as double;
      }

      final totalMl = totalLiters * 1000; // Convert to milliliters
      AppLogger.info('Water intake today: ${totalMl.round()}ml');
      return totalMl;
    } catch (e) {
      AppLogger.error('Error getting water intake today', e);
      return 0.0;
    }
  }

  /// Get mindfulness minutes for today
  static Future<double> getMindfulnessMinutesToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await getHealthData(
        dataType: 'MINDFULNESS',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      double totalMinutes = 0.0;
      for (final record in data) {
        totalMinutes += record['value'] as double;
      }

      AppLogger.info('Mindfulness minutes today: ${totalMinutes.round()}');
      return totalMinutes;
    } catch (e) {
      AppLogger.error('Error getting mindfulness minutes today', e);
      return 0.0;
    }
  }

  /// Get latest weight measurement
  static Future<double?> getLatestWeight() async {
    try {
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));

      final data = await getHealthData(
        dataType: 'WEIGHT',
        startDate: oneWeekAgo,
        endDate: now,
      );

      if (data.isEmpty) {
        AppLogger.info('No weight data found in the last week');
        return null;
      }

      // Sort by timestamp and get the latest
      data.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      final latestWeight = data.first['value'] as double;

      AppLogger.info('Latest weight: ${latestWeight.toStringAsFixed(1)}kg');
      return latestWeight;
    } catch (e) {
      AppLogger.error('Error getting latest weight', e);
      return null;
    }
  }

  /// Get latest heart rate reading
  static Future<double?> getLatestHeartRate() async {
    try {
      final now = DateTime.now();
      final startTime = now.subtract(const Duration(hours: 24)); // Last 24 hours

      final data = await getHealthData(
        dataType: 'HEART_RATE',
        startDate: startTime,
        endDate: now,
      );

      if (data.isEmpty) {
        AppLogger.info('No heart rate data found in the last 24 hours');
        return null;
      }

      // Sort by timestamp and get the latest
      data.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      final latestHeartRate = data.first['value'] as double;

      AppLogger.info('Latest heart rate: ${latestHeartRate.round()} bpm');
      return latestHeartRate;
    } catch (e) {
      AppLogger.error('Error getting latest heart rate', e);
      return null;
    }
  }

  // ...existing code...

  /// Get resting heart rate for today
  static Future<double?> getRestingHeartRateToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final data = await getHealthData(
        dataType: 'HEART_RATE',
        startDate: startOfDay,
        endDate: endOfDay,
      );

      if (data.isEmpty) {
        AppLogger.info('No heart rate data found for today');
        return null;
      }

      // Calculate resting heart rate (lowest 10% of readings)
      final heartRates = data.map((record) => record['value'] as double).toList();
      heartRates.sort();
      
      final restingCount = (heartRates.length * 0.1).ceil();
      if (restingCount == 0) return heartRates.first;
      
      final restingRates = heartRates.take(restingCount);
      final restingHeartRate = restingRates.reduce((a, b) => a + b) / restingRates.length;

      AppLogger.info('Resting heart rate today: ${restingHeartRate.round()} bpm');
      return restingHeartRate;
    } catch (e) {
      AppLogger.error('Error getting resting heart rate', e);
      return null;
    }
  }

  /// Get heart rate data for a specific date range
  static Future<List<Map<String, dynamic>>> getHeartRateData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final data = await getHealthData(
        dataType: 'HEART_RATE',
        startDate: startDate,
        endDate: endDate,
      );

      AppLogger.info('Retrieved ${data.length} heart rate readings');
      return data;
    } catch (e) {
      AppLogger.error('Error getting heart rate data range', e);
      return [];
    }
  }

  /// Get supported data types
  static List<String> getSupportedDataTypes() {
    return List.from(_supportedDataTypes);
  }

  /// Get service status for debugging
  static Map<String, dynamic> getServiceStatus() {
    return {
      'isInitialized': _isInitialized,
      'platform': Platform.operatingSystem,
      'supportedDataTypes': _supportedDataTypes,
      'channelName': 'minimal_health_service',
      'realDataOnly': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Reset the service (for testing)
  static void reset() {
    _isInitialized = false;
    AppLogger.info('MinimalHealthChannel reset');
  }
}