import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database.dart';
import 'health_habit_integration_service.dart';
import 'logging_service.dart';
import 'notification_service.dart';

/// Background service for continuous health-habit integration
/// 
/// This service runs periodic health-habit synchronization in the background
/// to ensure habits are automatically completed based on health data without
/// requiring user interaction.
class HealthHabitBackgroundService {
  static const String _backgroundServiceEnabledKey = 'background_service_enabled';
  static const String _syncIntervalKey = 'sync_interval_minutes';
  static const String _lastBackgroundSyncKey = 'last_background_sync';
  
  static Timer? _syncTimer;
  static bool _isRunning = false;
  static StreamController<HealthHabitSyncResult>? _syncResultController;
  
  // Default sync interval: 30 minutes
  static const int _defaultSyncIntervalMinutes = 30;
  
  /// Initialize the background service
  static Future<bool> initialize() async {
    try {
      AppLogger.info('Initializing Health-Habit Background Service...');
      
      // Initialize the integration service first
      final integrationInitialized = await HealthHabitIntegrationService.initialize();
      if (!integrationInitialized) {
        AppLogger.warning('Health-Habit Integration Service not initialized');
        return false;
      }
      
      // Set up default preferences
      await _initializeDefaultPreferences();
      
      // Create sync result stream
      _syncResultController = StreamController<HealthHabitSyncResult>.broadcast();
      
      AppLogger.info('Health-Habit Background Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health-Habit Background Service', e);
      return false;
    }
  }

  /// Set up default preferences
  static Future<void> _initializeDefaultPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Enable background service by default
      if (!prefs.containsKey(_backgroundServiceEnabledKey)) {
        await prefs.setBool(_backgroundServiceEnabledKey, true);
      }
      
      // Set default sync interval
      if (!prefs.containsKey(_syncIntervalKey)) {
        await prefs.setInt(_syncIntervalKey, _defaultSyncIntervalMinutes);
      }
    } catch (e) {
      AppLogger.error('Failed to initialize default preferences', e);
    }
  }

  /// Start the background service
  static Future<void> start() async {
    try {
      if (_isRunning) {
        AppLogger.info('Background service already running');
        return;
      }
      
      final enabled = await isBackgroundServiceEnabled();
      if (!enabled) {
        AppLogger.info('Background service disabled, not starting');
        return;
      }
      
      final intervalMinutes = await getSyncIntervalMinutes();
      final interval = Duration(minutes: intervalMinutes);
      
      AppLogger.info('Starting background service with ${intervalMinutes}min interval');
      
      _isRunning = true;
      
      // Perform initial sync
      await _performBackgroundSync();
      
      // Set up periodic sync
      _syncTimer = Timer.periodic(interval, (timer) async {
        await _performBackgroundSync();
      });
      
      AppLogger.info('Background service started successfully');
    } catch (e) {
      AppLogger.error('Failed to start background service', e);
      _isRunning = false;
    }
  }

  /// Stop the background service
  static Future<void> stop() async {
    try {
      AppLogger.info('Stopping background service...');
      
      _syncTimer?.cancel();
      _syncTimer = null;
      _isRunning = false;
      
      AppLogger.info('Background service stopped');
    } catch (e) {
      AppLogger.error('Failed to stop background service', e);
    }
  }

  /// Restart the background service with new settings
  static Future<void> restart() async {
    await stop();
    await start();
  }

  /// Check if background service is enabled
  static Future<bool> isBackgroundServiceEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_backgroundServiceEnabledKey) ?? true;
    } catch (e) {
      AppLogger.error('Failed to get background service preference', e);
      return false;
    }
  }

  /// Enable or disable background service
  static Future<void> setBackgroundServiceEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_backgroundServiceEnabledKey, enabled);
      
      AppLogger.info('Background service ${enabled ? 'enabled' : 'disabled'}');
      
      if (enabled && !_isRunning) {
        await start();
      } else if (!enabled && _isRunning) {
        await stop();
      }
    } catch (e) {
      AppLogger.error('Failed to set background service preference', e);
    }
  }

  /// Get sync interval in minutes
  static Future<int> getSyncIntervalMinutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_syncIntervalKey) ?? _defaultSyncIntervalMinutes;
    } catch (e) {
      AppLogger.error('Failed to get sync interval', e);
      return _defaultSyncIntervalMinutes;
    }
  }

  /// Set sync interval in minutes
  static Future<void> setSyncIntervalMinutes(int minutes) async {
    try {
      if (minutes < 5) {
        throw ArgumentError('Sync interval must be at least 5 minutes');
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_syncIntervalKey, minutes);
      
      AppLogger.info('Sync interval set to $minutes minutes');
      
      // Restart service with new interval if running
      if (_isRunning) {
        await restart();
      }
    } catch (e) {
      AppLogger.error('Failed to set sync interval', e);
    }
  }

  /// Perform background sync
  static Future<void> _performBackgroundSync() async {
    try {
      AppLogger.debug('Performing background health-habit sync...');
      
      // Get habit service
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      
      // Perform sync
      final result = await HealthHabitIntegrationService.performHealthHabitSync(
        habitService: habitService,
      );
      
      // Update last sync time
      await _updateLastBackgroundSyncTime();
      
      // Emit result to stream
      _syncResultController?.add(result);
      
      // Log results
      if (result.hasError) {
        AppLogger.error('Background sync failed: ${result.error}');
      } else if (result.hasCompletions) {
        AppLogger.info('Background sync completed ${result.completionCount} habits');
        
        // Send summary notification if multiple habits completed
        if (result.completionCount > 1) {
          await _sendBackgroundSyncNotification(result);
        }
      } else {
        AppLogger.debug('Background sync completed - no habits auto-completed');
      }
      
    } catch (e) {
      AppLogger.error('Error during background sync', e);
      
      // Emit error result
      final errorResult = HealthHabitSyncResult();
      errorResult.error = e.toString();
      _syncResultController?.add(errorResult);
    }
  }

  /// Update last background sync time
  static Future<void> _updateLastBackgroundSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastBackgroundSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.error('Failed to update last background sync time', e);
    }
  }

  /// Get last background sync time
  static Future<DateTime?> getLastBackgroundSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastBackgroundSyncKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      AppLogger.error('Failed to get last background sync time', e);
    }
    return null;
  }

  /// Send notification about background sync results
  static Future<void> _sendBackgroundSyncNotification(HealthHabitSyncResult result) async {
    try {
      if (!result.hasCompletions) return;
      
      final completedCount = result.completionCount;
      final habitNames = result.completedHabits
          .take(3) // Show up to 3 habit names
          .map((h) => h.habitName)
          .join(', ');
      
      String body;
      if (completedCount == 1) {
        body = 'Great! "$habitNames" was automatically completed based on your health data.';
      } else if (completedCount <= 3) {
        body = 'Awesome! $habitNames were automatically completed based on your health data.';
      } else {
        body = 'Amazing! $completedCount habits were automatically completed based on your health data.';
      }
      
      await NotificationService.showNotification(
        id: 9998, // Different ID from manual sync notifications
        title: 'Habits Auto-Completed! 🎯',
        body: body,
      );
    } catch (e) {
      AppLogger.error('Failed to send background sync notification', e);
    }
  }

  /// Get stream of sync results
  static Stream<HealthHabitSyncResult>? get syncResultStream => 
      _syncResultController?.stream;

  /// Check if background service is currently running
  static bool get isRunning => _isRunning;

  /// Get background service status
  static Future<Map<String, dynamic>> getStatus() async {
    final status = <String, dynamic>{};
    
    try {
      status['isRunning'] = _isRunning;
      status['isEnabled'] = await isBackgroundServiceEnabled();
      status['syncIntervalMinutes'] = await getSyncIntervalMinutes();
      
      final lastSync = await getLastBackgroundSyncTime();
      status['lastSyncTime'] = lastSync?.toIso8601String();
      status['lastSyncTimestamp'] = lastSync?.millisecondsSinceEpoch;
      
      if (lastSync != null) {
        final timeSinceSync = DateTime.now().difference(lastSync);
        status['minutesSinceLastSync'] = timeSinceSync.inMinutes;
        status['hoursSinceLastSync'] = (timeSinceSync.inMinutes / 60).round();
      }
      
      // Next sync time estimate
      if (_isRunning && lastSync != null) {
        final intervalMinutes = await getSyncIntervalMinutes();
        final nextSync = lastSync.add(Duration(minutes: intervalMinutes));
        status['nextSyncTime'] = nextSync.toIso8601String();
        status['nextSyncTimestamp'] = nextSync.millisecondsSinceEpoch;
        status['minutesUntilNextSync'] = nextSync.difference(DateTime.now()).inMinutes;
      }
      
    } catch (e) {
      AppLogger.error('Failed to get background service status', e);
      status['error'] = e.toString();
    }
    
    return status;
  }

  /// Force immediate background sync
  static Future<HealthHabitSyncResult> forceSyncNow() async {
    AppLogger.info('Force background sync triggered');
    
    try {
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      
      final result = await HealthHabitIntegrationService.performHealthHabitSync(
        habitService: habitService,
        forceSync: true,
      );
      
      await _updateLastBackgroundSyncTime();
      _syncResultController?.add(result);
      
      return result;
    } catch (e) {
      AppLogger.error('Failed to force background sync', e);
      final errorResult = HealthHabitSyncResult();
      errorResult.error = e.toString();
      return errorResult;
    }
  }

  /// Dispose resources
  static Future<void> dispose() async {
    try {
      await stop();
      await _syncResultController?.close();
      _syncResultController = null;
      AppLogger.info('Background service disposed');
    } catch (e) {
      AppLogger.error('Failed to dispose background service', e);
    }
  }

  /// Get sync statistics
  static Future<Map<String, dynamic>> getSyncStatistics() async {
    final stats = <String, dynamic>{};
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get stored statistics (you might want to implement these)
      stats['totalSyncs'] = prefs.getInt('total_background_syncs') ?? 0;
      stats['totalAutoCompletions'] = prefs.getInt('total_auto_completions') ?? 0;
      stats['averageCompletionsPerSync'] = prefs.getDouble('avg_completions_per_sync') ?? 0.0;
      
      final lastSync = await getLastBackgroundSyncTime();
      if (lastSync != null) {
        stats['daysSinceFirstSync'] = DateTime.now().difference(lastSync).inDays;
      }
      
    } catch (e) {
      AppLogger.error('Failed to get sync statistics', e);
      stats['error'] = e.toString();
    }
    
    return stats;
  }


}

/// Configuration for background service
class BackgroundServiceConfig {
  final bool enabled;
  final int syncIntervalMinutes;
  final bool notificationsEnabled;
  
  const BackgroundServiceConfig({
    this.enabled = true,
    this.syncIntervalMinutes = 30,
    this.notificationsEnabled = true,
  });
  
  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'syncIntervalMinutes': syncIntervalMinutes,
    'notificationsEnabled': notificationsEnabled,
  };
  
  factory BackgroundServiceConfig.fromJson(Map<String, dynamic> json) {
    return BackgroundServiceConfig(
      enabled: json['enabled'] ?? true,
      syncIntervalMinutes: json['syncIntervalMinutes'] ?? 30,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }
}