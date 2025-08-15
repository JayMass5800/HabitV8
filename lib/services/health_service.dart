// import 'package:health/health.dart';  // REMOVED - causes Google Play Console issues
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'logging_service.dart';
import 'minimal_health_service.dart';

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
/// CRITICAL: This service ONLY supports 6 health data types to avoid Google Play Console rejection
class HealthService {
  static bool _isInitialized = false;

  /// Get platform-specific health data types
  /// STRICTLY LIMITED to only the 6 essential data types to prevent Google Play Console
  /// static analysis from detecting broader health permissions
  /// 
  /// CRITICAL: This list MUST match exactly what's declared in AndroidManifest.xml
  /// and health_permissions.xml to avoid static analysis issues
  static List<String> get _healthDataTypes {
    // FIXED LIST - DO NOT ADD MORE TYPES
    // These are the ONLY 6 health data types this app will ever request
    const allowedTypes = [
      'STEPS',                    // Steps tracking
      'ACTIVE_ENERGY_BURNED',     // Calories burned (active)
      'SLEEP_IN_BED',             // Sleep duration
      'WATER',                    // Water intake/hydration
      'MINDFULNESS',              // Meditation/mindfulness
      'WEIGHT',                   // Body weight
    ];
    
    // Validate that we're not accidentally including forbidden types
    _validateHealthDataTypes(allowedTypes);
    
    return allowedTypes;
  }
  
  /// Validate that only allowed health data types are being used
  /// This prevents accidental inclusion of types that would trigger Google Play Console issues
  static void _validateHealthDataTypes(List<String> types) {
    // List of forbidden types that would trigger Google Play Console static analysis
    const forbiddenTypes = [
      'HEART_RATE',
      'BLOOD_PRESSURE_SYSTOLIC',
      'BLOOD_PRESSURE_DIASTOLIC',
      'BLOOD_GLUCOSE',
      'BODY_TEMPERATURE',
      'RESPIRATORY_RATE',
      'NUTRITION',
      'EXERCISE',
      'DISTANCE',
      // Add more forbidden types as needed
    ];
    
    for (final type in types) {
      if (forbiddenTypes.contains(type)) {
        throw Exception('FORBIDDEN HEALTH DATA TYPE DETECTED: $type - This would trigger Google Play Console rejection!');
      }
    }
    
    // Ensure we only have the exact 6 allowed types
    if (types.length != 6) {
      throw Exception('INVALID HEALTH DATA TYPE COUNT: Expected exactly 6 types, got ${types.length}');
    }
    
    AppLogger.info('Health data types validation passed: ${types.length} allowed types');
  }

  /// Initialize health service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      AppLogger.info('Health service already initialized');
      return true;
    }

    try {
      AppLogger.info('Initializing minimal health service...');
      
      // Use our minimal health service instead of the problematic health plugin
      final initialized = await MinimalHealthService.initialize();
      
      if (initialized) {
        _isInitialized = true;
        AppLogger.info('Minimal health service initialized successfully');
        return true;
      } else {
        AppLogger.error('Failed to initialize minimal health service');
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
      AppLogger.info('Requesting health permissions for ${_healthDataTypes.length} data types');
      AppLogger.info('Data types: ${_healthDataTypes.join(', ')}');
      
      final bool granted = await MinimalHealthService.requestPermissions();

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
      // Use our minimal health service to check permissions
      final bool hasPerms = await MinimalHealthService.hasPermissions();
      AppLogger.info('Health permissions check result: $hasPerms');
      
      return hasPerms;
    } catch (e) {
      AppLogger.error('Error checking health permissions', e);
      return false;
    }
  }

  /// Refresh and re-check health permissions
  static Future<bool> refreshPermissions() async {
    try {
      AppLogger.info('Refreshing health permissions status');
      return await hasPermissions();
    } catch (e) {
      AppLogger.error('Error refreshing health permissions', e);
      return false;
    }
  }

  /// Get steps data for today
  static Future<int> getStepsToday() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return await MinimalHealthService.getStepsToday();
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
      return await MinimalHealthService.getActiveCaloriesToday();
    } catch (e) {
      AppLogger.error('Error getting active calories data', e);
      return 0.0;
    }
  }

  /// Get sleep hours for last night
  static Future<double> getSleepHoursLastNight() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      return await MinimalHealthService.getSleepHoursLastNight();
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
      return await MinimalHealthService.getWaterIntakeToday();
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
      return await MinimalHealthService.getMindfulnessMinutesToday();
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
      return await MinimalHealthService.getLatestWeight();
    } catch (e) {
      AppLogger.error('Error getting weight data', e);
      return null;
    }
  }

  /// Get today's health summary
  static Future<Map<String, dynamic>> getTodayHealthSummary() async {
    try {
      final steps = await getStepsToday();
      final calories = await getActiveCaloriesToday();
      final sleep = await getSleepHoursLastNight();
      final water = await getWaterIntakeToday();
      final mindfulness = await getMindfulnessMinutesToday();
      final weight = await getLatestWeight();

      return {
        'steps': steps,
        'activeCalories': calories,
        'sleepHours': sleep,
        'waterIntake': water,
        'mindfulnessMinutes': mindfulness,
        'weight': weight,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting health summary', e);
      return {
        'steps': 0,
        'activeCalories': 0.0,
        'sleepHours': 0.0,
        'waterIntake': 0.0,
        'mindfulnessMinutes': 0.0,
        'weight': null,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }

  /// Get health data for specific types and date range
  static Future<List<Map<String, dynamic>>> getHealthDataFromTypes({
    required List<String> types,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final results = <Map<String, dynamic>>[];
    
    try {
      for (final type in types) {
        switch (type) {
          case 'STEPS':
            // For now, only support today's data
            if (_isToday(startTime)) {
              final steps = await getStepsToday();
              if (steps > 0) {
                results.add({
                  'type': type,
                  'value': steps.toDouble(),
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'unit': 'count',
                });
              }
            }
            break;
            
          case 'ACTIVE_ENERGY_BURNED':
            if (_isToday(startTime)) {
              final calories = await getActiveCaloriesToday();
              if (calories > 0) {
                results.add({
                  'type': type,
                  'value': calories,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'unit': 'kcal',
                });
              }
            }
            break;
            
          case 'SLEEP_IN_BED':
            if (_isToday(startTime)) {
              final sleep = await getSleepHoursLastNight();
              if (sleep > 0) {
                results.add({
                  'type': type,
                  'value': sleep,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'unit': 'hours',
                });
              }
            }
            break;
            
          case 'WATER':
            if (_isToday(startTime)) {
              final water = await getWaterIntakeToday();
              if (water > 0) {
                results.add({
                  'type': type,
                  'value': water,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'unit': 'ml',
                });
              }
            }
            break;
            
          case 'MINDFULNESS':
            if (_isToday(startTime)) {
              final mindfulness = await getMindfulnessMinutesToday();
              if (mindfulness > 0) {
                results.add({
                  'type': type,
                  'value': mindfulness,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'unit': 'minutes',
                });
              }
            }
            break;
            
          case 'WEIGHT':
            final weight = await getLatestWeight();
            if (weight != null) {
              results.add({
                'type': type,
                'value': weight,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'unit': 'kg',
              });
            }
            break;
        }
      }
    } catch (e) {
      AppLogger.error('Error getting health data from types', e);
    }
    
    return results;
  }
  
  /// Helper method to check if a date is today
  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
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
      // For now, assume it's available on Android
      // In a real implementation, you'd check if Health Connect is installed
      return true;
    } catch (e) {
      AppLogger.error('Error checking Health Connect availability', e);
      return false;
    }
  }

  /// Get Health Connect debug info
  static Future<Map<String, dynamic>> getHealthConnectDebugInfo() async {
    try {
      return {
        'isAvailable': await isHealthConnectAvailable(),
        'hasPermissions': await hasPermissions(),
        'supportedDataTypes': MinimalHealthService.getSupportedDataTypes(),
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting Health Connect debug info', e);
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get health insights (simplified version)
  static Future<Map<String, dynamic>> getHealthInsights({
    int days = 7,
  }) async {
    try {
      final summary = await getTodayHealthSummary();
      
      return {
        'period': days,
        'summary': summary,
        'insights': [
          'Health data integration is active',
          'Using minimal health permissions for privacy',
          'Only essential health data types are accessed',
        ],
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting health insights', e);
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}