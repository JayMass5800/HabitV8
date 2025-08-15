import 'dart:async';
import 'dart:io';
import 'logging_service.dart';
import 'permission_service.dart';

/// ActivityRecognitionService provides activity detection for habit tracking.
/// 
/// This service integrates with device activity recognition to automatically
/// detect and track activity-based habits such as:
/// - Walking/Running habits
/// - Exercise routines
/// - Movement-based activities
/// - Sedentary behavior tracking
/// 
/// The service respects user privacy by:
/// - Only requesting activity recognition permission when needed
/// - Processing all data locally on the device
/// - Allowing users to revoke permissions at any time
/// - Not storing sensitive location or personal data
class ActivityRecognitionService {
  static final ActivityRecognitionService _instance = ActivityRecognitionService._internal();
  factory ActivityRecognitionService() => _instance;
  ActivityRecognitionService._internal();

  static bool _isInitialized = false;
  static bool _isMonitoring = false;
  static StreamSubscription? _activitySubscription;
  
  // Activity types that we can detect and track
  static const Map<String, String> supportedActivities = {
    'walking': 'Walking',
    'running': 'Running',
    'cycling': 'Cycling',
    'driving': 'Driving',
    'still': 'Still/Stationary',
    'unknown': 'Unknown Activity',
  };

  /// Initialize the activity recognition service
  static Future<bool> initialize() async {
    if (_isInitialized) {
      AppLogger.info('Activity recognition service already initialized');
      return true;
    }

    try {
      AppLogger.info('Initializing activity recognition service...');
      
      // Check if activity recognition is supported on this platform
      if (!Platform.isAndroid && !Platform.isIOS) {
        AppLogger.warning('Activity recognition not supported on this platform');
        return false;
      }

      // Check if permission is already granted
      final permissionService = PermissionService();
      final hasPermission = await permissionService.isActivityRecognitionPermissionGranted();
      
      if (hasPermission) {
        AppLogger.info('Activity recognition permission already granted');
      } else {
        AppLogger.info('Activity recognition permission not granted - will request when needed');
      }

      _isInitialized = true;
      AppLogger.info('Activity recognition service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize activity recognition service', e);
      _isInitialized = false;
      return false;
    }
  }

  /// Request activity recognition permissions
  static Future<bool> requestPermissions() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        AppLogger.error('Failed to initialize activity recognition service');
        return false;
      }
    }

    try {
      AppLogger.info('Requesting activity recognition permissions');
      
      final permissionService = PermissionService();
      final granted = await permissionService.requestActivityRecognitionPermission();
      
      if (granted) {
        AppLogger.info('Activity recognition permissions granted successfully');
        return true;
      } else {
        AppLogger.info('Activity recognition permissions denied by user');
        return false;
      }
    } catch (e) {
      AppLogger.error('Failed to request activity recognition permissions', e);
      return false;
    }
  }

  /// Check if activity recognition permissions are granted
  static Future<bool> hasPermissions() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final permissionService = PermissionService();
      final hasPermission = await permissionService.isActivityRecognitionPermissionGranted();
      AppLogger.info('Activity recognition permissions check result: $hasPermission');
      return hasPermission;
    } catch (e) {
      AppLogger.error('Error checking activity recognition permissions', e);
      return false;
    }
  }

  /// Start monitoring activity for habit tracking
  static Future<bool> startMonitoring() async {
    if (_isMonitoring) {
      AppLogger.info('Activity monitoring already active');
      return true;
    }

    try {
      // Ensure we have permissions
      final hasPerms = await hasPermissions();
      if (!hasPerms) {
        AppLogger.warning('Cannot start activity monitoring - permissions not granted');
        return false;
      }

      AppLogger.info('Starting activity recognition monitoring');
      
      // Note: In a real implementation, you would integrate with a platform-specific
      // activity recognition plugin like 'activity_recognition' or 'sensors_plus'
      // For now, we'll simulate the monitoring setup
      
      _isMonitoring = true;
      AppLogger.info('Activity recognition monitoring started successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to start activity monitoring', e);
      return false;
    }
  }

  /// Stop monitoring activity
  static Future<void> stopMonitoring() async {
    if (!_isMonitoring) {
      AppLogger.info('Activity monitoring not active');
      return;
    }

    try {
      AppLogger.info('Stopping activity recognition monitoring');
      
      await _activitySubscription?.cancel();
      _activitySubscription = null;
      _isMonitoring = false;
      
      AppLogger.info('Activity recognition monitoring stopped');
    } catch (e) {
      AppLogger.error('Error stopping activity monitoring', e);
    }
  }

  /// Get current activity status
  static Future<Map<String, dynamic>> getCurrentActivity() async {
    try {
      if (!_isInitialized || !_isMonitoring) {
        return {
          'activity': 'unknown',
          'confidence': 0.0,
          'timestamp': DateTime.now().toIso8601String(),
          'monitoring': false,
        };
      }

      // Note: In a real implementation, this would return actual activity data
      // from the device's activity recognition system
      return {
        'activity': 'unknown',
        'confidence': 0.0,
        'timestamp': DateTime.now().toIso8601String(),
        'monitoring': true,
      };
    } catch (e) {
      AppLogger.error('Error getting current activity', e);
      return {
        'activity': 'unknown',
        'confidence': 0.0,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }

  /// Get activity summary for today
  static Future<Map<String, dynamic>> getTodayActivitySummary() async {
    try {
      // Note: In a real implementation, this would aggregate activity data
      // from throughout the day
      return {
        'totalActiveMinutes': 0,
        'walkingMinutes': 0,
        'runningMinutes': 0,
        'cyclingMinutes': 0,
        'stillMinutes': 0,
        'activities': <Map<String, dynamic>>[],
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting activity summary', e);
      return {
        'totalActiveMinutes': 0,
        'walkingMinutes': 0,
        'runningMinutes': 0,
        'cyclingMinutes': 0,
        'stillMinutes': 0,
        'activities': <Map<String, dynamic>>[],
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }

  /// Check if a specific activity was detected today
  static Future<bool> wasActivityDetectedToday(String activityType) async {
    try {
      if (!supportedActivities.containsKey(activityType)) {
        AppLogger.warning('Unsupported activity type: $activityType');
        return false;
      }

      // Note: In a real implementation, this would check if the specified
      // activity was detected at any point during the current day
      return false;
    } catch (e) {
      AppLogger.error('Error checking activity detection for $activityType', e);
      return false;
    }
  }

  /// Get activity-based habit suggestions
  static Future<List<Map<String, dynamic>>> getActivityBasedHabitSuggestions() async {
    try {
      final summary = await getTodayActivitySummary();
      final suggestions = <Map<String, dynamic>>[];

      // Analyze activity patterns and suggest relevant habits
      if (summary['walkingMinutes'] > 0) {
        suggestions.add({
          'type': 'walking',
          'title': 'Daily Walking Goal',
          'description': 'Track your daily walking activity',
          'suggestedTarget': '30 minutes',
          'category': 'fitness',
        });
      }

      if (summary['stillMinutes'] > 240) { // More than 4 hours still
        suggestions.add({
          'type': 'movement_break',
          'title': 'Movement Breaks',
          'description': 'Take regular breaks from sitting',
          'suggestedTarget': 'Every 2 hours',
          'category': 'health',
        });
      }

      return suggestions;
    } catch (e) {
      AppLogger.error('Error getting activity-based habit suggestions', e);
      return [];
    }
  }

  /// Get service status and debug information
  static Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      return {
        'isInitialized': _isInitialized,
        'isMonitoring': _isMonitoring,
        'hasPermissions': await hasPermissions(),
        'supportedActivities': supportedActivities,
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      AppLogger.error('Error getting activity recognition service status', e);
      return {
        'isInitialized': _isInitialized,
        'isMonitoring': _isMonitoring,
        'hasPermissions': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Dispose of the service and clean up resources
  static Future<void> dispose() async {
    try {
      AppLogger.info('Disposing activity recognition service');
      
      await stopMonitoring();
      _isInitialized = false;
      
      AppLogger.info('Activity recognition service disposed');
    } catch (e) {
      AppLogger.error('Error disposing activity recognition service', e);
    }
  }
}