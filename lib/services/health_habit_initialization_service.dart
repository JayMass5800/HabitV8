import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database.dart';
import 'health_service.dart';
import 'health_habit_integration_service.dart';
import 'health_habit_background_service.dart';
import 'health_habit_analytics_service.dart';
import 'logging_service.dart';
import 'notification_service.dart';

/// Comprehensive Health-Habit Initialization Service
/// 
/// Manages the initialization and lifecycle of all health-habit integration
/// services, ensuring proper startup sequence and error handling.
class HealthHabitInitializationService {
  static const String _initializationStatusKey = 'health_habit_init_status';
  static const String _lastInitializationKey = 'last_health_habit_init';
  static const String _initializationVersionKey = 'health_habit_init_version';
  static const String _notificationSentKey = 'health_habit_notification_sent';
  
  // Current version of the health-habit integration system
  static const int _currentVersion = 1;
  
  static bool _isInitialized = false;
  static bool _isInitializing = false;
  static final Completer<bool> _initializationCompleter = Completer<bool>();
  
  /// Initialize all health-habit integration services
  static Future<HealthHabitInitializationResult> initialize({
    bool forceReinit = false,
  }) async {
    if (_isInitializing) {
      // Wait for ongoing initialization to complete
      await _initializationCompleter.future;
      final result = HealthHabitInitializationResult();
      result.success = _isInitialized;
      result.message = _isInitialized ? 'Already initialized' : 'Initialization failed';
      return result;
    }
    
    if (_isInitialized && !forceReinit) {
      final result = HealthHabitInitializationResult();
      result.success = true;
      result.message = 'Health-Habit integration already initialized';
      return result;
    }
    
    _isInitializing = true;
    final result = HealthHabitInitializationResult();
    
    try {
      AppLogger.info('Starting Health-Habit Integration initialization...');
      
      // Check if we need to reinitialize due to version changes
      final needsReinit = await _checkVersionAndReinitIfNeeded();
      if (needsReinit || forceReinit) {
        AppLogger.info('Performing full reinitialization...');
        await _performCleanup();
      }
      
      // Step 1: Initialize core health service
      result.healthServiceInitialized = await _initializeHealthService();
      if (!result.healthServiceInitialized) {
        result.warnings.add('Health service initialization failed - continuing with limited functionality');
      }
      
      // Step 2: Initialize integration service
      result.integrationServiceInitialized = await _initializeIntegrationService();
      if (!result.integrationServiceInitialized) {
        throw Exception('Integration service initialization failed');
      }
      
      // Step 3: Initialize background service
      result.backgroundServiceInitialized = await _initializeBackgroundService();
      if (!result.backgroundServiceInitialized) {
        result.warnings.add('Background service initialization failed - manual sync only');
      }
      
      // Step 4: Initialize analytics service (optional)
      result.analyticsServiceInitialized = await _initializeAnalyticsService();
      if (!result.analyticsServiceInitialized) {
        result.warnings.add('Analytics service initialization failed - limited insights available');
      }
      
      // Step 5: Set up periodic maintenance
      await _setupPeriodicMaintenance();
      
      // Step 6: Perform initial health check
      final healthCheck = await _performHealthCheck();
      result.healthCheckPassed = healthCheck.passed;
      result.warnings.addAll(healthCheck.warnings);
      
      // Step 7: Update initialization status
      await _updateInitializationStatus(true);
      
      _isInitialized = true;
      result.success = true;
      result.message = 'Health-Habit integration initialized successfully';
      
      AppLogger.info('Health-Habit Integration initialization completed successfully');
      
      // Send initialization success notification
      await _sendInitializationNotification(true);
      
    } catch (e) {
      AppLogger.error('Health-Habit Integration initialization failed', e);
      result.success = false;
      result.message = 'Initialization failed: $e';
      result.error = e.toString();
      
      // Update initialization status as failed
      await _updateInitializationStatus(false);
      
      // Send initialization failure notification
      await _sendInitializationNotification(false);
    } finally {
      _isInitializing = false;
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete(_isInitialized);
      }
    }
    
    return result;
  }

  /// Initialize health service
  static Future<bool> _initializeHealthService() async {
    try {
      AppLogger.info('Initializing Health Service...');
      
      final initialized = await HealthService.initialize();
      if (!initialized) {
        AppLogger.warning('Health Service initialization failed');
        return false;
      }
      
      // Try to request permissions if not already granted
      final hasPermissions = await HealthService.hasPermissions();
      if (!hasPermissions) {
        AppLogger.info('Health permissions not granted - will request when needed');
      }
      
      AppLogger.info('Health Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health Service', e);
      return false;
    }
  }

  /// Initialize integration service
  static Future<bool> _initializeIntegrationService() async {
    try {
      AppLogger.info('Initializing Health-Habit Integration Service...');
      
      final initialized = await HealthHabitIntegrationService.initialize();
      if (!initialized) {
        AppLogger.error('Health-Habit Integration Service initialization failed');
        return false;
      }
      
      AppLogger.info('Health-Habit Integration Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health-Habit Integration Service', e);
      return false;
    }
  }

  /// Initialize background service
  static Future<bool> _initializeBackgroundService() async {
    try {
      AppLogger.info('Initializing Health-Habit Background Service...');
      
      final initialized = await HealthHabitBackgroundService.initialize();
      if (!initialized) {
        AppLogger.warning('Health-Habit Background Service initialization failed');
        return false;
      }
      
      // Start the background service if enabled
      final isEnabled = await HealthHabitBackgroundService.isBackgroundServiceEnabled();
      if (isEnabled) {
        await HealthHabitBackgroundService.start();
        AppLogger.info('Background service started');
      }
      
      AppLogger.info('Health-Habit Background Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health-Habit Background Service', e);
      return false;
    }
  }

  /// Initialize analytics service
  static Future<bool> _initializeAnalyticsService() async {
    try {
      AppLogger.info('Initializing Health-Habit Analytics Service...');
      
      // Analytics service doesn't need explicit initialization
      // Just verify it can generate a basic report
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      
      final report = await HealthHabitAnalyticsService.generateAnalyticsReport(
        habitService: habitService,
        analysisWindowDays: 7, // Small window for initialization test
      );
      
      if (report.hasError) {
        AppLogger.warning('Analytics service test failed: ${report.error}');
        return false;
      }
      
      AppLogger.info('Health-Habit Analytics Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health-Habit Analytics Service', e);
      return false;
    }
  }

  /// Set up periodic maintenance tasks
  static Future<void> _setupPeriodicMaintenance() async {
    try {
      AppLogger.info('Setting up periodic maintenance...');
      
      // Schedule daily maintenance at 3 AM
      Timer.periodic(const Duration(hours: 24), (timer) async {
        final now = DateTime.now();
        if (now.hour == 3) { // Run at 3 AM
          await _performMaintenanceTasks();
        }
      });
      
      AppLogger.info('Periodic maintenance scheduled');
    } catch (e) {
      AppLogger.error('Failed to set up periodic maintenance', e);
    }
  }

  /// Perform health check of all services
  static Future<HealthCheckResult> _performHealthCheck() async {
    final result = HealthCheckResult();
    
    try {
      AppLogger.info('Performing health check...');
      
      // Check health service
      final healthServiceOk = await HealthService.hasPermissions();
      if (!healthServiceOk) {
        result.warnings.add('Health permissions not granted');
      }
      
      // Check integration service
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final integrationStatus = await HealthHabitIntegrationService.getIntegrationStatus(
        habitService: habitService,
      );
      
      if (integrationStatus['error'] != null) {
        result.warnings.add('Integration service has errors: ${integrationStatus['error']}');
      }
      
      // Check background service
      final backgroundStatus = await HealthHabitBackgroundService.getStatus();
      final isBackgroundEnabled = backgroundStatus['isEnabled'] ?? false;
      final isBackgroundRunning = backgroundStatus['isRunning'] ?? false;
      
      if (isBackgroundEnabled && !isBackgroundRunning) {
        result.warnings.add('Background service enabled but not running');
      }
      
      // Overall health check
      result.passed = result.warnings.length < 3; // Allow up to 2 warnings
      
      AppLogger.info('Health check completed: ${result.passed ? 'PASSED' : 'FAILED'} (${result.warnings.length} warnings)');
      
    } catch (e) {
      AppLogger.error('Health check failed', e);
      result.passed = false;
      result.warnings.add('Health check failed: $e');
    }
    
    return result;
  }

  /// Check version and reinitialize if needed
  static Future<bool> _checkVersionAndReinitIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedVersion = prefs.getInt(_initializationVersionKey) ?? 0;
      
      if (storedVersion < _currentVersion) {
        AppLogger.info('Version upgrade detected: $storedVersion -> $_currentVersion');
        await prefs.setInt(_initializationVersionKey, _currentVersion);
        return true;
      }
      
      return false;
    } catch (e) {
      AppLogger.error('Failed to check version', e);
      return false;
    }
  }

  /// Perform cleanup before reinitialization
  static Future<void> _performCleanup() async {
    try {
      AppLogger.info('Performing cleanup...');
      
      // Stop background service
      await HealthHabitBackgroundService.stop();
      
      // Clear any cached data that might be outdated
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_initializationStatusKey);
      await prefs.remove(_lastInitializationKey);
      
      AppLogger.info('Cleanup completed');
    } catch (e) {
      AppLogger.error('Cleanup failed', e);
    }
  }

  /// Update initialization status
  static Future<void> _updateInitializationStatus(bool success) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_initializationStatusKey, success);
      await prefs.setInt(_lastInitializationKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.error('Failed to update initialization status', e);
    }
  }

  /// Send initialization notification (only once)
  static Future<void> _sendInitializationNotification(bool success) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationSent = prefs.getBool(_notificationSentKey) ?? false;
      
      // Only send notification if it hasn't been sent before
      if (!notificationSent) {
        if (success) {
          await NotificationService.showNotification(
            id: 9997,
            title: 'Health Integration Ready! 🎯',
            body: 'Your habits can now be automatically completed based on health data.',
          );
        } else {
          await NotificationService.showNotification(
            id: 9996,
            title: 'Health Integration Setup',
            body: 'Some features may be limited. Check settings to enable full integration.',
          );
        }
        
        // Mark notification as sent
        await prefs.setBool(_notificationSentKey, true);
        AppLogger.info('Health integration notification sent');
      } else {
        AppLogger.info('Health integration notification already sent, skipping');
      }
    } catch (e) {
      AppLogger.error('Failed to send initialization notification', e);
    }
  }

  /// Reset notification flag (for testing or re-enabling notifications)
  static Future<void> resetNotificationFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notificationSentKey);
      AppLogger.info('Health integration notification flag reset');
    } catch (e) {
      AppLogger.error('Failed to reset notification flag', e);
    }
  }

  /// Perform periodic maintenance tasks
  static Future<void> _performMaintenanceTasks() async {
    try {
      AppLogger.info('Performing maintenance tasks...');
      
      // Clean up old cached data
      // Refresh health permissions
      await HealthService.refreshPermissions();
      
      // Perform a health check
      final healthCheck = await _performHealthCheck();
      if (!healthCheck.passed) {
        AppLogger.warning('Maintenance health check failed: ${healthCheck.warnings}');
      }
      
      // Force a sync if background service is running
      final backgroundStatus = await HealthHabitBackgroundService.getStatus();
      if (backgroundStatus['isRunning'] == true) {
        await HealthHabitBackgroundService.forceSyncNow();
      }
      
      AppLogger.info('Maintenance tasks completed');
    } catch (e) {
      AppLogger.error('Maintenance tasks failed', e);
    }
  }

  /// Get initialization status
  static Future<Map<String, dynamic>> getInitializationStatus() async {
    final status = <String, dynamic>{};
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      status['isInitialized'] = _isInitialized;
      status['isInitializing'] = _isInitializing;
      status['lastInitialization'] = prefs.getInt(_lastInitializationKey);
      status['initializationSuccess'] = prefs.getBool(_initializationStatusKey);
      status['version'] = prefs.getInt(_initializationVersionKey);
      status['currentVersion'] = _currentVersion;
      
      if (status['lastInitialization'] != null) {
        final lastInit = DateTime.fromMillisecondsSinceEpoch(status['lastInitialization']);
        status['lastInitializationDate'] = lastInit.toIso8601String();
        status['daysSinceLastInit'] = DateTime.now().difference(lastInit).inDays;
      }
      
      // Get service statuses
      if (_isInitialized) {
        status['healthServiceStatus'] = await HealthService.hasPermissions();
        status['backgroundServiceStatus'] = await HealthHabitBackgroundService.getStatus();
        
        final habitBox = await DatabaseService.getInstance();
        final habitService = HabitService(habitBox);
        status['integrationStatus'] = await HealthHabitIntegrationService.getIntegrationStatus(
          habitService: habitService,
        );
      }
      
    } catch (e) {
      AppLogger.error('Failed to get initialization status', e);
      status['error'] = e.toString();
    }
    
    return status;
  }

  /// Force reinitialization
  static Future<HealthHabitInitializationResult> forceReinitialize() async {
    AppLogger.info('Force reinitialization requested');
    _isInitialized = false;
    return await initialize(forceReinit: true);
  }

  /// Shutdown all services
  static Future<void> shutdown() async {
    try {
      AppLogger.info('Shutting down Health-Habit Integration services...');
      
      // Stop background service
      await HealthHabitBackgroundService.dispose();
      
      // Mark as not initialized
      _isInitialized = false;
      
      AppLogger.info('Health-Habit Integration services shut down');
    } catch (e) {
      AppLogger.error('Failed to shutdown services', e);
    }
  }

  /// Check if initialization is required
  static Future<bool> isInitializationRequired() async {
    if (_isInitialized) return false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSuccess = prefs.getBool(_initializationStatusKey) ?? false;
      final storedVersion = prefs.getInt(_initializationVersionKey) ?? 0;
      
      // Require initialization if never successful or version changed
      return !lastSuccess || storedVersion < _currentVersion;
    } catch (e) {
      AppLogger.error('Failed to check initialization requirement', e);
      return true; // Default to requiring initialization
    }
  }

  /// Get comprehensive system status
  static Future<Map<String, dynamic>> getSystemStatus() async {
    final status = <String, dynamic>{};
    
    try {
      // Basic status
      status['initialized'] = _isInitialized;
      status['initializing'] = _isInitializing;
      
      // Initialization status
      status['initializationStatus'] = await getInitializationStatus();
      
      // Service statuses
      if (_isInitialized) {
        status['healthService'] = {
          'hasPermissions': await HealthService.hasPermissions(),
          'isAvailable': await HealthService.isHealthDataAvailable(),
        };
        
        status['backgroundService'] = await HealthHabitBackgroundService.getStatus();
        
        final habitBox = await DatabaseService.getInstance();
        final habitService = HabitService(habitBox);
        status['integration'] = await HealthHabitIntegrationService.getIntegrationStatus(
          habitService: habitService,
        );
        
        // Recent sync results
        final syncStream = HealthHabitBackgroundService.syncResultStream;
        if (syncStream != null) {
          status['hasSyncStream'] = true;
        }
      }
      
      // System health
      final healthCheck = await _performHealthCheck();
      status['healthCheck'] = {
        'passed': healthCheck.passed,
        'warnings': healthCheck.warnings,
      };
      
    } catch (e) {
      AppLogger.error('Failed to get system status', e);
      status['error'] = e.toString();
    }
    
    return status;
  }
}

/// Result of health-habit initialization
class HealthHabitInitializationResult {
  bool success = false;
  String message = '';
  String? error;
  
  bool healthServiceInitialized = false;
  bool integrationServiceInitialized = false;
  bool backgroundServiceInitialized = false;
  bool analyticsServiceInitialized = false;
  bool healthCheckPassed = false;
  
  List<String> warnings = [];
  
  bool get hasWarnings => warnings.isNotEmpty;
  bool get isFullyInitialized => success && 
      healthServiceInitialized && 
      integrationServiceInitialized && 
      backgroundServiceInitialized && 
      analyticsServiceInitialized;
}

/// Result of health check
class HealthCheckResult {
  bool passed = false;
  List<String> warnings = [];
}