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
    'BACKGROUND_HEALTH_DATA', // Background health data access
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
        AppLogger.warning(
          'MinimalHealthChannel only supports Android with Health Connect',
        );
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
        AppLogger.warning(
          'MinimalHealthChannel initialization failed - Health Connect may not be available',
        );
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

      final bool available = await _channel.invokeMethod(
        'isHealthConnectAvailable',
      );
      AppLogger.info('Health Connect availability: $available');
      return available;
    } catch (e) {
      AppLogger.error('Error checking Health Connect availability', e);
      return false;
    }
  }

  /// Get detailed Health Connect status
  static Future<Map<String, dynamic>> getHealthConnectStatus() async {
    try {
      if (!Platform.isAndroid) {
        return {
          'status': 'NOT_SUPPORTED',
          'message': 'Health Connect is only available on Android',
        };
      }

      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getHealthConnectStatus',
      );

      final Map<String, dynamic> status = Map<String, dynamic>.from(result);
      AppLogger.info('Health Connect detailed status: ${status['status']}');
      AppLogger.info('Status message: ${status['message']}');

      return status;
    } catch (e) {
      AppLogger.error('Error getting Health Connect status', e);
      return {
        'status': 'ERROR',
        'message': 'Error checking Health Connect status: $e',
      };
    }
  }

  /// Check if health permissions are granted
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final bool hasPerms = await _channel.invokeMethod('hasPermissions', {
        'supportedTypes': _supportedDataTypes,
      });
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
      AppLogger.info(
        'Requesting health permissions for types: ${_supportedDataTypes.join(', ')}',
      );
      final bool granted = await _channel.invokeMethod('requestPermissions', {
        'supportedTypes': _supportedDataTypes,
      });
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

      AppLogger.info(
        'Fetching health data for $dataType from ${startDate.toIso8601String()} to ${endDate.toIso8601String()}',
      );

      final List<dynamic> result = await _channel
          .invokeMethod('getHealthData', {
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

      // Expand the time range to capture sleep sessions that might start earlier or end later
      // Look from 2 days ago at 6 PM to now (to catch any sleep session)
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final startTime = DateTime(
        twoDaysAgo.year,
        twoDaysAgo.month,
        twoDaysAgo.day,
        18,
      ); // 6 PM two days ago
      final endTime = now; // Current time

      AppLogger.info(
        'MinimalHealthChannel: Requesting sleep data from ${startTime.toIso8601String()} to ${endTime.toIso8601String()}',
      );

      final data = await getHealthData(
        dataType: 'SLEEP_IN_BED',
        startDate: startTime,
        endDate: endTime,
      );

      AppLogger.info(
        'MinimalHealthChannel: Received ${data.length} sleep records',
      );

      if (data.isEmpty) {
        AppLogger.warning('No sleep records found in expanded time range');
        return 0.0;
      }

      // Find the most recent sleep session that ended within the last 24 hours
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStart = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
      );
      final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

      double totalSleepMinutes = 0.0;
      int validSessions = 0;

      for (int i = 0; i < data.length; i++) {
        final record = data[i];
        final minutes = record['value'] as double;
        final timestamp = record['timestamp'] as int;
        final endTime = record['endTime'] as int?;

        final sessionStart = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final sessionEnd = endTime != null
            ? DateTime.fromMillisecondsSinceEpoch(endTime)
            : sessionStart.add(Duration(minutes: minutes.round()));

        AppLogger.info(
          'Sleep record $i: ${minutes.toStringAsFixed(1)} minutes, start: ${sessionStart.toIso8601String()}, end: ${sessionEnd.toIso8601String()}',
        );

        // Include sleep sessions that ended between yesterday start and today end
        // This captures the most recent night's sleep
        if (sessionEnd.isAfter(yesterdayStart) &&
            sessionEnd.isBefore(todayEnd)) {
          totalSleepMinutes += minutes;
          validSessions++;
          AppLogger.info(
            'Including sleep session: ${minutes.toStringAsFixed(1)} minutes',
          );
        } else {
          AppLogger.info('Excluding sleep session (outside target range)');
        }
      }

      final sleepHours = totalSleepMinutes / 60.0;
      AppLogger.info(
        'Sleep hours last night: ${sleepHours.toStringAsFixed(1)} (from ${totalSleepMinutes.toStringAsFixed(1)} minutes, $validSessions sessions)',
      );
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
      data.sort(
        (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int),
      );
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

      // Try different time ranges to find heart rate data
      final timeRanges = [
        const Duration(hours: 2), // Last 2 hours
        const Duration(hours: 6), // Last 6 hours
        const Duration(hours: 24), // Last 24 hours
        const Duration(days: 3), // Last 3 days
      ];

      for (final duration in timeRanges) {
        final startTime = now.subtract(duration);

        AppLogger.info(
          'MinimalHealthChannel: Requesting heart rate data from ${startTime.toIso8601String()} to ${now.toIso8601String()}',
        );

        final data = await getHealthData(
          dataType: 'HEART_RATE',
          startDate: startTime,
          endDate: now,
        );

        AppLogger.info(
          'MinimalHealthChannel: Received ${data.length} heart rate records in ${duration.inHours}h range',
        );

        if (data.isNotEmpty) {
          // Filter out invalid readings (0 or extremely high/low values)
          final validData = data.where((record) {
            final value = record['value'] as double;
            return value > 30 && value < 220; // Reasonable heart rate range
          }).toList();

          if (validData.isNotEmpty) {
            // Log first few records for debugging
            for (int i = 0; i < validData.length && i < 3; i++) {
              final record = validData[i];
              final timestamp = DateTime.fromMillisecondsSinceEpoch(
                record['timestamp'] as int,
              );
              AppLogger.info(
                'Heart rate record $i: ${record['value']} bpm at ${timestamp.toIso8601String()}',
              );
            }

            // Sort by timestamp and get the latest
            validData.sort(
              (a, b) =>
                  (b['timestamp'] as int).compareTo(a['timestamp'] as int),
            );
            final latestHeartRate = validData.first['value'] as double;

            AppLogger.info(
              'Latest heart rate: ${latestHeartRate.round()} bpm (from ${validData.length} valid records out of ${data.length} total)',
            );
            return latestHeartRate;
          } else {
            AppLogger.warning(
              'Found ${data.length} heart rate records but none were valid (all outside 30-220 bpm range)',
            );
          }
        }
      }

      AppLogger.warning(
        'No heart rate data found in any time range up to 3 days',
      );
      return null;
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

      // Try today first, then expand to recent days if no data
      final timeRanges = [
        (DateTime(now.year, now.month, now.day), now), // Today
        (DateTime(now.year, now.month, now.day - 1), now), // Yesterday + today
        (now.subtract(const Duration(days: 3)), now), // Last 3 days
      ];

      for (final (startTime, endTime) in timeRanges) {
        final data = await getHealthData(
          dataType: 'HEART_RATE',
          startDate: startTime,
          endDate: endTime,
        );

        if (data.isNotEmpty) {
          // Filter out invalid readings and extreme values
          final validHeartRates = data
              .map((record) => record['value'] as double)
              .where((rate) => rate > 30 && rate < 220)
              .toList();

          if (validHeartRates.isNotEmpty) {
            validHeartRates.sort();

            // Calculate resting heart rate (lowest 15% of readings for better accuracy)
            final restingCount = (validHeartRates.length * 0.15).ceil().clamp(
              1,
              validHeartRates.length,
            );
            final restingRates = validHeartRates.take(restingCount);
            final restingHeartRate =
                restingRates.reduce((a, b) => a + b) / restingRates.length;

            final dayRange = startTime.day == now.day ? 'today' : 'recent days';
            AppLogger.info(
              'Resting heart rate ($dayRange): ${restingHeartRate.round()} bpm (from ${restingCount} lowest readings out of ${validHeartRates.length} valid)',
            );
            return restingHeartRate;
          }
        }
      }

      AppLogger.info(
        'No valid heart rate data found for resting heart rate calculation',
      );
      return null;
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

  /// Start background health monitoring service
  static Future<bool> startBackgroundMonitoring() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      AppLogger.info('Starting background health monitoring service');
      final bool result = await _channel.invokeMethod(
        'startBackgroundMonitoring',
      );
      AppLogger.info('Background monitoring service started: $result');
      return result;
    } catch (e) {
      AppLogger.error('Error starting background health monitoring', e);
      return false;
    }
  }

  /// Stop background health monitoring service
  static Future<bool> stopBackgroundMonitoring() async {
    try {
      AppLogger.info('Stopping background health monitoring service');
      final bool result = await _channel.invokeMethod(
        'stopBackgroundMonitoring',
      );
      AppLogger.info('Background monitoring service stopped: $result');
      return result;
    } catch (e) {
      AppLogger.error('Error stopping background health monitoring', e);
      return false;
    }
  }

  /// Check if background monitoring is active
  static Future<bool> isBackgroundMonitoringActive() async {
    try {
      final bool result = await _channel.invokeMethod(
        'isBackgroundMonitoringActive',
      );
      AppLogger.info('Background monitoring active: $result');
      return result;
    } catch (e) {
      AppLogger.error('Error checking background monitoring status', e);
      return false;
    }
  }

  /// Check if background health data access is granted
  static Future<bool> hasBackgroundHealthDataAccess() async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));

      final data = await getHealthData(
        dataType: 'BACKGROUND_HEALTH_DATA',
        startDate: oneHourAgo,
        endDate: now,
      );

      if (data.isEmpty) {
        AppLogger.info(
          'No background health data access information available',
        );
        return false;
      }

      final isGranted = data.first['isGranted'] as bool? ?? false;
      AppLogger.info(
        'Background health data access: ${isGranted ? "GRANTED" : "DENIED"}',
      );
      return isGranted;
    } catch (e) {
      AppLogger.error('Error checking background health data access', e);
      return false;
    }
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
