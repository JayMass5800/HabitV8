import 'package:health/health.dart';
import 'dart:io';
import 'logging_service.dart';

/// HealthService provides secure, privacy-focused access to health data for habit tracking.
/// 
/// This service complies with Android Health Permissions guidelines by:
/// - Only requesting access to specific data types needed for habit tracking features
/// - Processing all data locally on the device
/// - Requiring explicit user consent for each data type
/// - Providing clear justification for each permission request
/// - Allowing users to revoke permissions at any time
/// 
/// Data Usage Justification:
/// - STEPS: Correlate walking/running habits with actual step counts
/// - HEART_RATE: Monitor workout intensity for fitness habit optimization
/// - SLEEP_*: Analyze sleep patterns to improve sleep-related habits
/// - ACTIVE_ENERGY_BURNED: Track energy expenditure for fitness habits
/// - EXERCISE_TIME/WORKOUT: Automatically detect and complete fitness habits
/// - WATER: Support hydration habit tracking and reminders
/// - MINDFULNESS: Track meditation and mindfulness habit completion
/// - WEIGHT: Correlate with health and fitness habit progress
class HealthService {
  static bool _isInitialized = false;

  /// List of health data types we access, each with specific habit tracking purpose
  static final List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.WORKOUT,
    if (Platform.isIOS) ...[
      HealthDataType.MINDFULNESS,
      HealthDataType.WATER,
    ],
    if (Platform.isAndroid) ...[
      HealthDataType.WATER,
      HealthDataType.WEIGHT,
    ],
  ];

  /// Initialize health service
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if health data is available on this platform
      final bool isAvailable = await Health().hasPermissions(_healthDataTypes) ?? false;

      _isInitialized = true;
      AppLogger.info('Health service initialized. Available: $isAvailable');

      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize health service', e);
      return false;
    }
  }

  /// Request health data permissions
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        AppLogger.error('Failed to initialize health service');
        return false;
      }
    }

    try {
      // Check if Health Connect is available
      final bool isAvailable = await Health().hasPermissions([HealthDataType.STEPS]) != null;
      if (!isAvailable) {
        AppLogger.error('Health Connect is not available on this device');
        return false;
      }

      // Request permissions for read access
      final List<HealthDataAccess> permissions = _healthDataTypes
          .map((type) => HealthDataAccess.READ)
          .toList();

      AppLogger.info('Requesting health permissions for ${_healthDataTypes.length} data types');
      
      final bool granted = await Health().requestAuthorization(
        _healthDataTypes,
        permissions: permissions,
      );

      if (granted) {
        AppLogger.info('Health permissions granted successfully');
        // Verify permissions were actually granted
        final bool hasPerms = await hasPermissions();
        AppLogger.info('Permission verification: $hasPerms');
        return hasPerms;
      } else {
        AppLogger.info('Health permissions denied by user');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to request health permissions', e);
      return false;
    }
  }

  /// Check if health permissions are granted
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final bool? hasPerms = await Health().hasPermissions(_healthDataTypes);
      return hasPerms ?? false;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Get steps data for a date range
  static Future<List<HealthDataPoint>> getStepsData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} steps data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get steps data', e);
      return [];
    }
  }

  /// Get heart rate data for a date range
  static Future<List<HealthDataPoint>> getHeartRateData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} heart rate data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get heart rate data', e);
      return [];
    }
  }

  /// Get sleep data for a date range
  static Future<List<HealthDataPoint>> getSleepData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_IN_BED, HealthDataType.SLEEP_ASLEEP],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} sleep data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get sleep data', e);
      return [];
    }
  }

  /// Get exercise/workout data for a date range
  static Future<List<HealthDataPoint>> getExerciseData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.EXERCISE_TIME, HealthDataType.WORKOUT],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} exercise data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get exercise data', e);
      return [];
    }
  }

  /// Get water intake data for a date range
  static Future<List<HealthDataPoint>> getWaterData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.WATER],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} water data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get water data', e);
      return [];
    }
  }

  /// Get comprehensive health summary for today
  static Future<Map<String, dynamic>> getTodayHealthSummary() async {
    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    final DateTime endOfDay = startOfDay.add(const Duration(days: 1));

    final Map<String, dynamic> summary = {};

    try {
      // Get steps
      final stepsData = await getStepsData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      int totalSteps = 0;
      for (var point in stepsData) {
        if (point.value is NumericHealthValue) {
          totalSteps += (point.value as NumericHealthValue).numericValue.toInt();
        }
      }
      summary['steps'] = totalSteps;

      // Get exercise time
      final exerciseData = await getExerciseData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      double totalExerciseMinutes = 0;
      for (var point in exerciseData) {
        if (point.value is NumericHealthValue) {
          totalExerciseMinutes += (point.value as NumericHealthValue).numericValue;
        }
      }
      summary['exerciseMinutes'] = totalExerciseMinutes.round();

      // Get water intake
      final waterData = await getWaterData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      double totalWater = 0;
      for (var point in waterData) {
        if (point.value is NumericHealthValue) {
          totalWater += (point.value as NumericHealthValue).numericValue;
        }
      }
      summary['waterIntake'] = totalWater;

      AppLogger.info('Health summary generated: $summary');
    } catch (e) {
      AppLogger.error('Failed to generate health summary', e);
    }

    return summary;
  }

  /// Get health insights for habit correlation
  static Future<Map<String, dynamic>> getHealthInsights({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Map<String, dynamic> insights = {};

    try {
      // Get average daily steps
      final stepsData = await getStepsData(startDate: startDate, endDate: endDate);
      final Map<String, int> dailySteps = {};

      for (var point in stepsData) {
        if (point.value is NumericHealthValue) {
          final date = '${point.dateFrom.year}-${point.dateFrom.month.toString().padLeft(2, '0')}-${point.dateFrom.day.toString().padLeft(2, '0')}';
          dailySteps[date] = (dailySteps[date] ?? 0) + (point.value as NumericHealthValue).numericValue.toInt();
        }
      }

      if (dailySteps.isNotEmpty) {
        final avgSteps = dailySteps.values.reduce((a, b) => a + b) / dailySteps.length;
        insights['averageDailySteps'] = avgSteps.round();
        insights['totalDaysWithSteps'] = dailySteps.length;
      }

      // Get sleep patterns
      final sleepData = await getSleepData(startDate: startDate, endDate: endDate);
      final List<double> sleepDurations = [];

      for (var point in sleepData) {
        if (point.type == HealthDataType.SLEEP_ASLEEP && point.value is NumericHealthValue) {
          final hours = (point.value as NumericHealthValue).numericValue.toDouble();
          sleepDurations.add(hours);
        }
      }

      if (sleepDurations.isNotEmpty) {
        final avgSleep = sleepDurations.reduce((a, b) => a + b) / sleepDurations.length;
        insights['averageSleepHours'] = (avgSleep * 100).round() / 100; // Round to 2 decimal places
      }

      AppLogger.info('Health insights generated: $insights');
    } catch (e) {
      AppLogger.error('Failed to generate health insights', e);
    }

    return insights;
  }

  /// Check if health data is available on this device
  static Future<bool> isHealthDataAvailable() async {
    try {
      return await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    } catch (e) {
      AppLogger.error('Error checking health data availability', e);
      return false;
    }
  }

  /// Write health data (for habits that contribute to health metrics)
  static Future<bool> writeHealthData({
    required HealthDataType type,
    required double value,
    required DateTime dateTime,
    String? unit,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final bool success = await Health().writeHealthData(
        value: value,
        type: type,
        startTime: dateTime,
        endTime: dateTime,
        unit: unit != null ? HealthDataUnit.values.firstWhere(
          (u) => u.name.toLowerCase() == unit.toLowerCase(),
          orElse: () => HealthDataUnit.NO_UNIT,
        ) : HealthDataUnit.NO_UNIT,
      );

      AppLogger.info('Health data write success: $success');
      return success;
    } catch (e) {
      AppLogger.error('Failed to write health data', e);
      return false;
    }
  }
}
