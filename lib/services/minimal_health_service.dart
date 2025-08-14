import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'logging_service.dart';

/// Minimal Health Service
/// 
/// This is a custom implementation that ONLY handles the 6 health permissions
/// we actually need, without including any metadata for other health permissions
/// that would trigger Google Play Console rejection.
/// 
/// CRITICAL: This service ONLY supports the exact 6 health data types needed
/// to avoid Google Play Console static analysis issues.
class MinimalHealthService {
  static const MethodChannel _channel = MethodChannel('minimal_health_service');
  static bool _isInitialized = false;

  /// The ONLY 6 health data types this service supports
  /// Adding any more will cause Google Play Console rejection
  static const Map<String, String> _supportedDataTypes = {
    'STEPS': 'android.permission.health.READ_STEPS',
    'ACTIVE_ENERGY_BURNED': 'android.permission.health.READ_ACTIVE_CALORIES_BURNED',
    'SLEEP_IN_BED': 'android.permission.health.READ_SLEEP',
    'WATER': 'android.permission.health.READ_HYDRATION',
    'MINDFULNESS': 'android.permission.health.READ_MINDFULNESS',
    'WEIGHT': 'android.permission.health.READ_WEIGHT',
  };

  /// Initialize the minimal health service
  static Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      AppLogger.info('Initializing Minimal Health Service...');
      
      if (Platform.isAndroid) {
        // Only initialize on Android - iOS doesn't have the same permission issues
        final result = await _channel.invokeMethod('initialize', {
          'supportedTypes': _supportedDataTypes.keys.toList(),
          'permissions': _supportedDataTypes.values.toList(),
        });
        
        _isInitialized = result == true;
        AppLogger.info('Minimal Health Service initialized: $_isInitialized');
      } else {
        // For non-Android platforms, just mark as initialized
        _isInitialized = true;
        AppLogger.info('Minimal Health Service initialized (non-Android platform)');
      }
      
      return _isInitialized;
    } catch (e) {
      AppLogger.error('Failed to initialize Minimal Health Service', e);
      return false;
    }
  }

  /// Check if health permissions are available
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('hasPermissions');
        return result == true;
      } else {
        // For non-Android platforms, assume permissions are available
        return true;
      }
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Request health permissions
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('requestPermissions', {
          'permissions': _supportedDataTypes.values.toList(),
        });
        return result == true;
      } else {
        // For non-Android platforms, assume permissions are granted
        return true;
      }
    } catch (e) {
      AppLogger.error('Error requesting health permissions', e);
      return false;
    }
  }

  /// Get health data for a specific type
  static Future<List<Map<String, dynamic>>> getHealthData({
    required String dataType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    if (!_supportedDataTypes.containsKey(dataType)) {
      throw Exception('Unsupported health data type: $dataType. Only ${_supportedDataTypes.keys.join(', ')} are supported.');
    }
    
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('getHealthData', {
          'dataType': dataType,
          'startDate': startDate.millisecondsSinceEpoch,
          'endDate': endDate.millisecondsSinceEpoch,
        });
        
        if (result is List) {
          return result.cast<Map<String, dynamic>>();
        }
      }
      
      // Return empty list if no data or non-Android platform
      return [];
    } catch (e) {
      AppLogger.error('Error getting health data for $dataType', e);
      return [];
    }
  }

  /// Get steps data
  static Future<int> getStepsToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final data = await getHealthData(
      dataType: 'STEPS',
      startDate: startOfDay,
      endDate: now,
    );
    
    int totalSteps = 0;
    for (final entry in data) {
      totalSteps += (entry['value'] as num?)?.toInt() ?? 0;
    }
    
    return totalSteps;
  }

  /// Get active calories burned today
  static Future<double> getActiveCaloriesToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final data = await getHealthData(
      dataType: 'ACTIVE_ENERGY_BURNED',
      startDate: startOfDay,
      endDate: now,
    );
    
    double totalCalories = 0.0;
    for (final entry in data) {
      totalCalories += (entry['value'] as num?)?.toDouble() ?? 0.0;
    }
    
    return totalCalories;
  }

  /// Get sleep data for last night
  static Future<double> getSleepHoursLastNight() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    final data = await getHealthData(
      dataType: 'SLEEP_IN_BED',
      startDate: yesterday,
      endDate: now,
    );
    
    double totalHours = 0.0;
    for (final entry in data) {
      final minutes = (entry['value'] as num?)?.toDouble() ?? 0.0;
      totalHours += minutes / 60.0;
    }
    
    return totalHours;
  }

  /// Get water intake today
  static Future<double> getWaterIntakeToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final data = await getHealthData(
      dataType: 'WATER',
      startDate: startOfDay,
      endDate: now,
    );
    
    double totalWater = 0.0;
    for (final entry in data) {
      totalWater += (entry['value'] as num?)?.toDouble() ?? 0.0;
    }
    
    return totalWater;
  }

  /// Get mindfulness minutes today
  static Future<double> getMindfulnessMinutesToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final data = await getHealthData(
      dataType: 'MINDFULNESS',
      startDate: startOfDay,
      endDate: now,
    );
    
    double totalMinutes = 0.0;
    for (final entry in data) {
      totalMinutes += (entry['value'] as num?)?.toDouble() ?? 0.0;
    }
    
    return totalMinutes;
  }

  /// Get latest weight
  static Future<double?> getLatestWeight() async {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    
    final data = await getHealthData(
      dataType: 'WEIGHT',
      startDate: lastWeek,
      endDate: now,
    );
    
    if (data.isNotEmpty) {
      // Return the most recent weight entry
      data.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      return (data.first['value'] as num?)?.toDouble();
    }
    
    return null;
  }

  /// Get supported data types
  static List<String> getSupportedDataTypes() {
    return _supportedDataTypes.keys.toList();
  }

  /// Validate that only supported data types are being used
  static void validateDataType(String dataType) {
    if (!_supportedDataTypes.containsKey(dataType)) {
      throw Exception(
        'FORBIDDEN HEALTH DATA TYPE: $dataType\n'
        'This would trigger Google Play Console rejection!\n'
        'Only these types are allowed: ${_supportedDataTypes.keys.join(', ')}'
      );
    }
  }
}