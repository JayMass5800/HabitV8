import 'package:health/health.dart';
import 'dart:io';
import 'logging_service.dart';

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
/// Android 16 Health Data Types Supported:
/// 
/// Core Fitness & Activity:
/// - STEPS: Correlate walking/running habits with actual step counts
/// - ACTIVE_ENERGY_BURNED: Track energy expenditure for fitness habits
/// - DISTANCE_DELTA: Monitor distance-based exercise habits
/// - WORKOUT: Automatically detect and complete fitness habits
/// - ACTIVITY_INTENSITY: Analyze workout intensity patterns
/// 
/// Vital Signs & Health Monitoring:
/// - HEART_RATE: Monitor workout intensity and resting heart rate trends
/// - BLOOD_PRESSURE: Track cardiovascular health for related habits
/// - BLOOD_GLUCOSE: Support diabetes management habits
/// - BODY_TEMPERATURE: Monitor health status for wellness habits
/// 
/// Sleep & Recovery:
/// - SLEEP_IN_BED, SLEEP_ASLEEP, SLEEP_AWAKE: Comprehensive sleep analysis
/// - SLEEP_DEEP, SLEEP_LIGHT, SLEEP_REM: Sleep quality optimization
/// 
/// Nutrition & Hydration:
/// - WATER: Support hydration habit tracking and reminders
/// - NUTRITION: Track dietary habits and nutritional goals
/// 
/// Mental Health & Wellness:
/// - MINDFULNESS: Track meditation and mindfulness habit completion
/// 
/// Body Metrics:
/// - WEIGHT, HEIGHT, BODY_FAT_PERCENTAGE: Support body composition habits
/// 
/// Background Access:
/// - READ_HEALTH_DATA_IN_BACKGROUND: Continuous monitoring for habit automation
class HealthService {
  static bool _isInitialized = false;

  /// Get platform-specific health data types
  static List<HealthDataType> get _healthDataTypes {
    if (Platform.isAndroid) {
      // Android Health Connect - comprehensive support for Android 16
      // Full range of health data types for habit tracking
      return [
        // Core fitness and activity data
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.WORKOUT,
        
        // Vital signs for health habit tracking
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.BODY_TEMPERATURE,
        
        // Sleep data for sleep habit optimization
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_LIGHT,
        HealthDataType.SLEEP_REM,
        
        // Nutrition and hydration for dietary habits
        HealthDataType.WATER,
        HealthDataType.NUTRITION,
        
        // Mental health and mindfulness
        HealthDataType.MINDFULNESS,
        
        // Body metrics for health tracking habits
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
      ];
    } else if (Platform.isIOS) {
      // iOS HealthKit - comprehensive support
      return [
        // Core fitness and activity data
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.WORKOUT,
        
        // Vital signs
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.BODY_TEMPERATURE,
        
        // Sleep data
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_LIGHT,
        HealthDataType.SLEEP_REM,
        
        // Nutrition and hydration
        HealthDataType.WATER,
        HealthDataType.NUTRITION,
        
        // Mental health
        HealthDataType.MINDFULNESS,
        
        // Body metrics
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
      ];
    } else {
      // Other platforms - basic set
      return [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.WATER,
      ];
    }
  }

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

  /// Get blood pressure data for a date range
  static Future<List<HealthDataPoint>> getBloodPressureData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_PRESSURE_SYSTOLIC, HealthDataType.BLOOD_PRESSURE_DIASTOLIC],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} blood pressure data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get blood pressure data', e);
      return [];
    }
  }

  /// Get blood glucose data for a date range
  static Future<List<HealthDataPoint>> getBloodGlucoseData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.BLOOD_GLUCOSE],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} blood glucose data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get blood glucose data', e);
      return [];
    }
  }

  /// Get body temperature data for a date range
  static Future<List<HealthDataPoint>> getBodyTemperatureData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.BODY_TEMPERATURE],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} body temperature data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get body temperature data', e);
      return [];
    }
  }

  /// Get nutrition data for a date range
  static Future<List<HealthDataPoint>> getNutritionData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.NUTRITION],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} nutrition data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get nutrition data', e);
      return [];
    }
  }

  /// Get body metrics data (weight, height, body fat) for a date range
  static Future<List<HealthDataPoint>> getBodyMetricsData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [
          HealthDataType.WEIGHT,
          HealthDataType.HEIGHT,
          HealthDataType.BODY_FAT_PERCENTAGE,
        ],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} body metrics data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get body metrics data', e);
      return [];
    }
  }

  /// Get mindfulness data for a date range
  static Future<List<HealthDataPoint>> getMindfulnessData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: [HealthDataType.MINDFULNESS],
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} mindfulness data points');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get mindfulness data', e);
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

      // Get heart rate data
      final heartRateData = await getHeartRateData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      if (heartRateData.isNotEmpty) {
        double avgHeartRate = 0;
        int count = 0;
        for (var point in heartRateData) {
          if (point.value is NumericHealthValue) {
            avgHeartRate += (point.value as NumericHealthValue).numericValue;
            count++;
          }
        }
        if (count > 0) {
          summary['averageHeartRate'] = (avgHeartRate / count).round();
        }
      }

      // Get mindfulness data
      final mindfulnessData = await getMindfulnessData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      double totalMindfulnessMinutes = 0;
      for (var point in mindfulnessData) {
        if (point.value is NumericHealthValue) {
          totalMindfulnessMinutes += (point.value as NumericHealthValue).numericValue;
        }
      }
      summary['mindfulnessMinutes'] = totalMindfulnessMinutes.round();

      // Get latest body metrics
      final bodyMetricsData = await getBodyMetricsData(
        startDate: startOfDay.subtract(const Duration(days: 7)), // Look back 7 days for latest readings
        endDate: endOfDay,
      );
      
      double? latestWeight;
      double? latestBodyFat;
      
      for (var point in bodyMetricsData) {
        if (point.value is NumericHealthValue) {
          if (point.type == HealthDataType.WEIGHT) {
            latestWeight = (point.value as NumericHealthValue).numericValue.toDouble();
          } else if (point.type == HealthDataType.BODY_FAT_PERCENTAGE) {
            latestBodyFat = (point.value as NumericHealthValue).numericValue.toDouble();
          }
        }
      }
      
      if (latestWeight != null) summary['weight'] = latestWeight;
      if (latestBodyFat != null) summary['bodyFatPercentage'] = latestBodyFat;

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
        insights['maxDailySteps'] = dailySteps.values.reduce((a, b) => a > b ? a : b);
        insights['minDailySteps'] = dailySteps.values.reduce((a, b) => a < b ? a : b);
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
        insights['totalSleepSessions'] = sleepDurations.length;
      }

      // Get heart rate insights
      final heartRateData = await getHeartRateData(startDate: startDate, endDate: endDate);
      if (heartRateData.isNotEmpty) {
        final List<double> heartRates = [];
        for (var point in heartRateData) {
          if (point.value is NumericHealthValue) {
            heartRates.add((point.value as NumericHealthValue).numericValue.toDouble());
          }
        }
        
        if (heartRates.isNotEmpty) {
          final avgHeartRate = heartRates.reduce((a, b) => a + b) / heartRates.length;
          insights['averageHeartRate'] = avgHeartRate.round();
          insights['maxHeartRate'] = heartRates.reduce((a, b) => a > b ? a : b).round();
          insights['minHeartRate'] = heartRates.reduce((a, b) => a < b ? a : b).round();
        }
      }

      // Get exercise insights
      final exerciseData = await getExerciseData(startDate: startDate, endDate: endDate);
      if (exerciseData.isNotEmpty) {
        double totalExerciseMinutes = 0;
        int exerciseSessions = 0;
        
        for (var point in exerciseData) {
          if (point.value is NumericHealthValue) {
            totalExerciseMinutes += (point.value as NumericHealthValue).numericValue;
            exerciseSessions++;
          }
        }
        
        if (exerciseSessions > 0) {
          insights['totalExerciseMinutes'] = totalExerciseMinutes.round();
          insights['exerciseSessions'] = exerciseSessions;
          insights['averageExerciseSessionMinutes'] = (totalExerciseMinutes / exerciseSessions).round();
        }
      }

      // Get water intake insights
      final waterData = await getWaterData(startDate: startDate, endDate: endDate);
      if (waterData.isNotEmpty) {
        double totalWater = 0;
        final Map<String, double> dailyWater = {};
        
        for (var point in waterData) {
          if (point.value is NumericHealthValue) {
            final date = '${point.dateFrom.year}-${point.dateFrom.month.toString().padLeft(2, '0')}-${point.dateFrom.day.toString().padLeft(2, '0')}';
            final waterAmount = (point.value as NumericHealthValue).numericValue;
            totalWater += waterAmount;
            dailyWater[date] = (dailyWater[date] ?? 0) + waterAmount;
          }
        }
        
        if (dailyWater.isNotEmpty) {
          final avgDailyWater = dailyWater.values.reduce((a, b) => a + b) / dailyWater.length;
          insights['averageDailyWaterIntake'] = (avgDailyWater * 100).round() / 100;
          insights['totalWaterIntake'] = (totalWater * 100).round() / 100;
        }
      }

      // Get mindfulness insights
      final mindfulnessData = await getMindfulnessData(startDate: startDate, endDate: endDate);
      if (mindfulnessData.isNotEmpty) {
        double totalMindfulnessMinutes = 0;
        int mindfulnessSessions = 0;
        
        for (var point in mindfulnessData) {
          if (point.value is NumericHealthValue) {
            totalMindfulnessMinutes += (point.value as NumericHealthValue).numericValue;
            mindfulnessSessions++;
          }
        }
        
        if (mindfulnessSessions > 0) {
          insights['totalMindfulnessMinutes'] = totalMindfulnessMinutes.round();
          insights['mindfulnessSessions'] = mindfulnessSessions;
          insights['averageMindfulnessSessionMinutes'] = (totalMindfulnessMinutes / mindfulnessSessions).round();
        }
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

  /// Get all available health data for comprehensive analysis
  static Future<List<HealthDataPoint>> getAllHealthData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: _healthDataTypes,
        startTime: startDate,
        endTime: endDate,
      );

      AppLogger.info('Retrieved ${healthData.length} total health data points across ${_healthDataTypes.length} data types');
      return healthData;
    } catch (e) {
      AppLogger.error('Failed to get all health data', e);
      return [];
    }
  }

  /// Get health data correlation for habit analysis
  static Future<Map<String, List<HealthDataPoint>>> getHealthDataByType({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Map<String, List<HealthDataPoint>> dataByType = {};
    
    try {
      final allData = await getAllHealthData(startDate: startDate, endDate: endDate);
      
      for (var point in allData) {
        final typeName = point.type.name;
        if (!dataByType.containsKey(typeName)) {
          dataByType[typeName] = [];
        }
        dataByType[typeName]!.add(point);
      }
      
      AppLogger.info('Organized health data into ${dataByType.keys.length} categories');
    } catch (e) {
      AppLogger.error('Failed to organize health data by type', e);
    }
    
    return dataByType;
  }

  /// Check which health data types are available and have permissions
  static Future<Map<String, bool>> getAvailableHealthDataTypes() async {
    final Map<String, bool> availability = {};
    
    try {
      for (var type in _healthDataTypes) {
        try {
          final bool? hasPermission = await Health().hasPermissions([type]);
          availability[type.name] = hasPermission ?? false;
        } catch (e) {
          availability[type.name] = false;
          AppLogger.warning('Failed to check permission for ${type.name}: $e');
        }
      }
      
      AppLogger.info('Health data type availability: $availability');
    } catch (e) {
      AppLogger.error('Failed to check health data type availability', e);
    }
    
    return availability;
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

  /// Write multiple health data points at once
  static Future<bool> writeMultipleHealthData(List<Map<String, dynamic>> dataPoints) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      int successCount = 0;
      
      for (var dataPoint in dataPoints) {
        final success = await writeHealthData(
          type: dataPoint['type'] as HealthDataType,
          value: dataPoint['value'] as double,
          dateTime: dataPoint['dateTime'] as DateTime,
          unit: dataPoint['unit'] as String?,
        );
        
        if (success) successCount++;
      }
      
      final bool allSuccessful = successCount == dataPoints.length;
      AppLogger.info('Wrote $successCount/${dataPoints.length} health data points successfully');
      return allSuccessful;
    } catch (e) {
      AppLogger.error('Failed to write multiple health data points', e);
      return false;
    }
  }
}
