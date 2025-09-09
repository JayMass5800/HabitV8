import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'logging_service.dart';

/// Simple result class for habit completion checks
class HabitCompletionResult {
  final bool shouldComplete;
  final String reason;

  HabitCompletionResult({
    required this.shouldComplete,
    required this.reason,
  });
}

/// Automatic Habit Completion Service
///
/// This service handles basic automatic habit completion functionality.
/// Health data integration has been removed - this is now a simple
/// background service for habit processing.
class AutomaticHabitCompletionService {
  static const String _serviceEnabledKey = 'auto_completion_service_enabled';
  static const String _lastCompletionCheckKey = 'last_completion_check';
  static const String _completionIntervalKey =
      'completion_check_interval_minutes';

  static Timer? _completionTimer;
  static bool _isRunning = false;

  /// Initialize the automatic completion service
  static Future<bool> initialize() async {
    try {
      AppLogger.info(
          'Initializing Automatic Habit Completion Service (Health-free version)...');

      // Basic initialization without health dependencies
      await _loadSettings();

      // Start background processing if enabled
      if (await isEnabled()) {
        await startService();
      }

      AppLogger.info(
          'Automatic Habit Completion Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error(
          'Failed to initialize Automatic Habit Completion Service', e);
      return false;
    }
  }

  /// Load service settings
  static Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Load any saved settings here if needed
      AppLogger.debug('Automatic completion service settings loaded');
    } catch (e) {
      AppLogger.error('Error loading automatic completion service settings', e);
    }
  }

  /// Check if service is enabled
  static Future<bool> isEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_serviceEnabledKey) ?? false;
    } catch (e) {
      AppLogger.error(
          'Error checking if automatic completion service is enabled', e);
      return false;
    }
  }

  /// Enable or disable the service
  static Future<void> setEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_serviceEnabledKey, enabled);

      if (enabled) {
        await startService();
      } else {
        await stopService();
      }

      AppLogger.info(
          'Automatic completion service ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error(
          'Error setting automatic completion service enabled state', e);
    }
  }

  /// Start the service
  static Future<void> startService() async {
    if (_isRunning) {
      return;
    }

    try {
      _isRunning = true;

      // Start a simple background timer for basic processing
      _completionTimer = Timer.periodic(
        const Duration(minutes: 30), // Check every 30 minutes
        (timer) => _performPeriodicCheck(),
      );

      AppLogger.info('Automatic habit completion service started');
    } catch (e) {
      AppLogger.error('Error starting automatic completion service', e);
      _isRunning = false;
    }
  }

  /// Stop the service
  static Future<void> stopService() async {
    try {
      _completionTimer?.cancel();
      _completionTimer = null;
      _isRunning = false;

      AppLogger.info('Automatic habit completion service stopped');
    } catch (e) {
      AppLogger.error('Error stopping automatic completion service', e);
    }
  }

  /// Perform periodic checks
  static Future<void> _performPeriodicCheck() async {
    if (!_isRunning) return;

    try {
      AppLogger.debug('Performing automatic completion periodic check');

      // Update last check time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _lastCompletionCheckKey, DateTime.now().toIso8601String());

      // Basic habit processing could go here
      // For now, this is just a placeholder for future non-health functionality
    } catch (e) {
      AppLogger.error('Error during automatic completion periodic check', e);
    }
  }

  /// Get service status
  static Future<Map<String, dynamic>> getStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getString(_lastCompletionCheckKey);

      return {
        'enabled': await isEnabled(),
        'running': _isRunning,
        'lastCheck': lastCheck,
        'healthIntegration': false, // Always false now
      };
    } catch (e) {
      AppLogger.error('Error getting automatic completion service status', e);
      return {
        'enabled': false,
        'running': false,
        'lastCheck': null,
        'healthIntegration': false,
      };
    }
  }

  /// Test method - simplified without health dependencies
  static Future<void> testMappings() async {
    AppLogger.info(
        'Testing automatic completion service (health-free version)');
    // Basic testing without health integration
  }

  /// Test specific habit - simplified
  static Future<void> testSpecificHabit(
      String habitName, String category) async {
    AppLogger.info(
        'Testing habit completion for: $habitName in category: $category');
    // Basic testing without health integration
  }

  /// Cleanup method
  static Future<void> cleanup() async {
    try {
      await stopService();
      AppLogger.info('Automatic habit completion service cleaned up');
    } catch (e) {
      AppLogger.error('Error cleaning up automatic completion service', e);
    }
  }
}
