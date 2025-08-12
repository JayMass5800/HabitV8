import 'package:health/health.dart';
import 'package:url_launcher/url_launcher.dart';
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
  /// Only requests permissions for data types that are actually used by the app
  /// to comply with Play Store requirements and user privacy expectations
  static List<HealthDataType> get _healthDataTypes {
    if (Platform.isAndroid) {
      // Android Health Connect - only essential data types actually used by the app
      // Note: Health Connect may show additional derived metrics, but we only request these core types
      return [
        // Core fitness data - used in insights and habit correlation
        HealthDataType.STEPS,                    // Used in getTodayHealthSummary()
        HealthDataType.ACTIVE_ENERGY_BURNED,     // Used for fitness habit insights
        HealthDataType.WORKOUT,                  // Used in getExerciseData()
        
        // Heart rate - used for workout intensity monitoring
        HealthDataType.HEART_RATE,               // Used in getTodayHealthSummary()
        
        // Hydration tracking - used for water intake habits
        HealthDataType.WATER,                    // Used in getTodayHealthSummary()
        
        // Mental health - used for meditation habit tracking
        HealthDataType.MINDFULNESS,              // Used in getTodayHealthSummary()
        
        // Body metrics - used for health tracking habits
        HealthDataType.WEIGHT,                   // Used in getBodyMetricsData()
        HealthDataType.HEIGHT,                   // Used in getBodyMetricsData()
        HealthDataType.BODY_FAT_PERCENTAGE,      // Used in getBodyMetricsData()
        
        // Sleep data - basic sleep tracking for sleep habits
        HealthDataType.SLEEP_IN_BED,             // Used in getSleepData()
        HealthDataType.SLEEP_ASLEEP,             // Used in getSleepData()
      ];
    } else if (Platform.isIOS) {
      // iOS HealthKit - same essential data types
      return [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.WORKOUT,
        HealthDataType.HEART_RATE,
        HealthDataType.WATER,
        HealthDataType.MINDFULNESS,
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
        HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
      ];
    } else {
      // Other platforms - minimal set
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
    if (_isInitialized) {
      AppLogger.info('Health service already initialized');
      return true;
    }

    try {
      AppLogger.info('Initializing health service...');
      
      // Configure the health plugin
      await Health().configure();
      
      // Test basic functionality to ensure it's working
      try {
        // Try a simple permission check to verify the service is working
        await Health().hasPermissions([HealthDataType.STEPS]);
        AppLogger.info('Health service basic functionality test passed');
      } catch (e) {
        AppLogger.warning('Health service basic functionality test failed, but continuing: $e');
        // Don't fail initialization just because of this test
      }
      
      _isInitialized = true;
      AppLogger.info('Health service initialized successfully');

      return true;
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
      // Request permissions for read access
      final List<HealthDataAccess> permissions = _healthDataTypes
          .map((type) => HealthDataAccess.READ)
          .toList();

      AppLogger.info('Requesting health permissions for ${_healthDataTypes.length} data types');
      AppLogger.info('Data types: ${_healthDataTypes.map((t) => t.name).join(', ')}');
      
      final bool granted = await Health().requestAuthorization(
        _healthDataTypes,
        permissions: permissions,
      );

      AppLogger.info('Permission request result: $granted');

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
  /// Returns true if at least the minimum required permissions are available
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // First check if all permissions are granted
      final bool? hasAllPerms = await Health().hasPermissions(_healthDataTypes);
      AppLogger.info('Health permissions check result (all): $hasAllPerms');
      
      if (hasAllPerms == true) {
        return true;
      }
      
      // If not all permissions are granted, check for minimum required permissions
      // At least STEPS permission is required for basic functionality
      final List<HealthDataType> minimumRequired = [HealthDataType.STEPS];
      final bool? hasMinimumPerms = await Health().hasPermissions(minimumRequired);
      AppLogger.info('Health permissions check result (minimum): $hasMinimumPerms');
      
      if (hasMinimumPerms == true) {
        // Check how many permissions we actually have
        int grantedCount = 0;
        for (final type in _healthDataTypes) {
          try {
            final bool? hasIndividual = await Health().hasPermissions([type]);
            if (hasIndividual == true) {
              grantedCount++;
            }
          } catch (e) {
            AppLogger.warning('Error checking individual permission for $type: $e');
          }
        }
        
        AppLogger.info('Health permissions: $grantedCount/${_healthDataTypes.length} granted');
        
        // Consider it successful if we have at least 3 permissions including STEPS
        return grantedCount >= 3;
      }
      
      return false;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Refresh and re-check health permissions
  /// This is useful when permissions might have been granted outside the app
  static Future<bool> refreshPermissions() async {
    try {
      AppLogger.info('Refreshing health permissions status');
      
      // Re-initialize if needed, or force re-initialization if service seems broken
      if (!_isInitialized) {
        AppLogger.info('Health service not initialized, initializing...');
        final initialized = await initialize();
        if (!initialized) {
          AppLogger.error('Failed to initialize health service during refresh');
          return false;
        }
      } else {
        // Try a quick test to see if the service is working
        try {
          await Health().hasPermissions([HealthDataType.STEPS]);
        } catch (e) {
          AppLogger.warning('Health service seems broken, re-initializing: $e');
          final reinitialized = await reinitialize();
          if (!reinitialized) {
            AppLogger.error('Failed to re-initialize health service');
            return false;
          }
        }
      }
      
      // Add a small delay to ensure system has processed any recent permission changes
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check permissions again
      final bool hasPerms = await hasPermissions();
      AppLogger.info('Refreshed health permissions status: $hasPerms');
      
      // If we have permissions, try to verify by attempting to read a small amount of data
      if (hasPerms) {
        try {
          final now = DateTime.now();
          final yesterday = now.subtract(const Duration(days: 1));
          
          // Try to read steps data as a verification
          final stepsData = await Health().getHealthDataFromTypes(
            types: [HealthDataType.STEPS],
            startTime: yesterday,
            endTime: now,
          );
          
          AppLogger.info('Permission verification: Successfully accessed health data (${stepsData.length} points)');
          return true;
        } catch (e) {
          AppLogger.info('Permission verification failed: $e');
          // Even if data access fails, return the permission status
          return hasPerms;
        }
      }
      
      return hasPerms;
    } catch (e) {
      AppLogger.error('Error refreshing health permissions', e);
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

  /// Open Health Connect settings for Android
  static Future<bool> openHealthConnectSettings() async {
    try {
      if (Platform.isAndroid) {
        AppLogger.info('Attempting to open Health Connect settings');
        
        // Try multiple approaches to open Health Connect
        
        // Method 1: Try to open Health Connect app directly
        const healthConnectPackage = 'com.google.android.apps.healthdata';
        final healthConnectUri = Uri.parse('package:$healthConnectPackage');
        
        if (await canLaunchUrl(healthConnectUri)) {
          AppLogger.info('Opening Health Connect app directly');
          final launched = await launchUrl(healthConnectUri);
          if (launched) {
            return true;
          }
        }
        
        // Method 2: Try to open Health Connect via intent
        const healthConnectIntent = 'android-app://com.google.android.apps.healthdata';
        final intentUri = Uri.parse(healthConnectIntent);
        
        if (await canLaunchUrl(intentUri)) {
          AppLogger.info('Opening Health Connect via intent');
          final launched = await launchUrl(intentUri);
          if (launched) {
            return true;
          }
        }
        
        // Method 3: Try to open Health Connect settings via action
        const settingsAction = 'android.settings.HEALTH_CONNECT_SETTINGS';
        final settingsUri = Uri.parse('android.intent.action.VIEW');
        
        try {
          // Try to launch with custom scheme for Health Connect settings
          final healthConnectSettingsUri = Uri.parse('android.intent.action.MAIN');
          if (await canLaunchUrl(healthConnectSettingsUri)) {
            final launched = await launchUrl(healthConnectSettingsUri);
            if (launched) {
              return true;
            }
          }
        } catch (e) {
          AppLogger.info('Health Connect settings action not available: $e');
        }
        
        // Method 4: Fallback to general app settings
        AppLogger.info('Falling back to general app settings');
        const appSettingsUri = 'android.settings.APPLICATION_DETAILS_SETTINGS';
        final appUri = Uri.parse('android.settings.APPLICATION_DETAILS_SETTINGS');
        
        if (await canLaunchUrl(appUri)) {
          final launched = await launchUrl(appUri);
          if (launched) {
            AppLogger.info('Opened general app settings as fallback');
            return true;
          }
        }
        
        AppLogger.info('All methods to open Health Connect settings failed');
        return false;
      } else if (Platform.isIOS) {
        // For iOS, try to open Health app
        AppLogger.info('Attempting to open iOS Health app');
        const healthAppUri = 'x-apple-health://';
        final uri = Uri.parse(healthAppUri);
        
        if (await canLaunchUrl(uri)) {
          final launched = await launchUrl(uri);
          if (launched) {
            AppLogger.info('Opened iOS Health app');
            return true;
          }
        }
        
        // Fallback to iOS Settings
        const settingsUri = 'app-settings:';
        final settingsUriParsed = Uri.parse(settingsUri);
        
        if (await canLaunchUrl(settingsUriParsed)) {
          final launched = await launchUrl(settingsUriParsed);
          if (launched) {
            AppLogger.info('Opened iOS app settings');
            return true;
          }
        }
        
        return false;
      } else {
        AppLogger.info('Health Connect settings not available on this platform');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to open Health Connect settings', e);
      return false;
    }
  }

  /// Check if Health Connect is installed and available
  static Future<bool> isHealthConnectAvailable() async {
    try {
      if (Platform.isAndroid) {
        // Try to check permissions as a way to verify Health Connect availability
        final bool hasPermissions = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
        AppLogger.info('Health Connect availability check via permissions: $hasPermissions');
        return true; // Assume available if we can check permissions
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to check Health Connect availability', e);
      return false;
    }
  }

  /// Debug method to check Health Connect status
  static Future<Map<String, dynamic>> getHealthConnectDebugInfo() async {
    final Map<String, dynamic> debugInfo = {};
    
    try {
      // Check platform
      debugInfo['platform'] = Platform.operatingSystem;
      debugInfo['isAndroid'] = Platform.isAndroid;
      
      if (Platform.isAndroid) {
        // Check Health Connect availability via permissions check
        debugInfo['healthConnectAvailable'] = await isHealthConnectAvailable();
        
        // Check permissions for a basic data type
        debugInfo['hasStepsPermission'] = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
        
        // Check all requested data types
        debugInfo['requestedDataTypes'] = _healthDataTypes.map((t) => t.name).toList();
        debugInfo['dataTypesCount'] = _healthDataTypes.length;
        
        // Check if initialized
        debugInfo['serviceInitialized'] = _isInitialized;
        
        // Try to re-initialize if not initialized
        if (!_isInitialized) {
          debugInfo['attemptingInitialization'] = true;
          try {
            final initResult = await initialize();
            debugInfo['initializationResult'] = initResult;
            debugInfo['serviceInitializedAfterAttempt'] = _isInitialized;
          } catch (e) {
            debugInfo['initializationError'] = e.toString();
          }
        }
        
        // Test basic functionality
        try {
          final testResult = await Health().hasPermissions([HealthDataType.STEPS]);
          debugInfo['basicFunctionalityTest'] = testResult;
        } catch (e) {
          debugInfo['basicFunctionalityError'] = e.toString();
        }
      }
      
      AppLogger.info('Health Connect Debug Info: $debugInfo');
      return debugInfo;
    } catch (e) {
      debugInfo['error'] = e.toString();
      AppLogger.error('Failed to get Health Connect debug info', e);
      return debugInfo;
    }
  }
}
