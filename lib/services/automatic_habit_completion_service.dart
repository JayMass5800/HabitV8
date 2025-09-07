import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database.dart';
import '../domain/model/habit.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'notification_service.dart';
import 'logging_service.dart';
import 'health_habit_mapping_test.dart';
import 'background_task_service.dart';

/// Automatic Habit Completion Service
///
/// This service is the core implementation of automatic habit completion
/// based on health data. It runs continuously in the background and
/// automatically marks habits as complete when health data indicates
/// the habit activity has been performed.
class AutomaticHabitCompletionService {
  static const String _serviceEnabledKey = 'auto_completion_service_enabled';
  static const String _lastCompletionCheckKey = 'last_completion_check';
  static const String _completionIntervalKey =
      'completion_check_interval_minutes';
  static const String _completionHistoryKey = 'completion_history';
  static const String _realTimeEnabledKey = 'real_time_completion_enabled';
  static const String _smartThresholdsEnabledKey = 'smart_thresholds_enabled';
  static const String _lastHealthDataCheckKey = 'last_health_data_check';

  static Timer? _completionTimer;
  static Timer? _realTimeTimer;
  static bool _isRunning = false;
  static bool _realTimeEnabled = true;
  static StreamController<AutoCompletionEvent>? _eventController;
  static int _recentErrorCount = 0;
  static DateTime? _lastErrorTime;
  static final Map<String, DateTime> _lastHealthDataValues = {};
  static final Set<String> _pendingCompletions = {};

  /// Stream of auto-completion events
  static Stream<AutoCompletionEvent>? get eventStream =>
      _eventController?.stream;

  /// Initialize the automatic completion service
  static Future<bool> initialize() async {
    try {
      AppLogger.info('Initializing Automatic Habit Completion Service...');

      // Initialize event stream
      _eventController ??= StreamController<AutoCompletionEvent>.broadcast();

      // Check if service should be enabled with timeout to prevent hanging
      final isEnabled = await isServiceEnabled().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.warning(
              'Service enabled check timed out - defaulting to false');
          return false;
        },
      );

      if (isEnabled) {
        // Add timeout to prevent hanging during startup
        await startService().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            AppLogger.warning(
                'Service start timed out - continuing without auto-completion');
          },
        );
      }

      AppLogger.info('Automatic Habit Completion Service initialized');
      return true;
    } catch (e) {
      AppLogger.error(
          'Failed to initialize Automatic Habit Completion Service', e);
      // Don't let this service failure crash the app
      return true; // Return true to allow app to continue
    }
  }

  /// Start the automatic completion service
  static Future<void> startService() async {
    if (_isRunning) {
      AppLogger.info('Automatic completion service already running');
      return;
    }

    try {
      AppLogger.info('Starting automatic habit completion service...');

      // Get check interval (adaptive based on recent errors)
      final intervalMinutes = await _getAdaptiveCheckInterval();

      // Start periodic completion checks
      _completionTimer = Timer.periodic(
        Duration(minutes: intervalMinutes),
        (_) => _performCompletionCheckInBackground(),
      );

      // Start real-time monitoring if enabled
      _realTimeEnabled = await isRealTimeEnabled();
      if (_realTimeEnabled) {
        await _startRealTimeMonitoring();
      }

      _isRunning = true;

      // Delay initial check to prevent immediate crashes after health permissions are granted
      await Future.delayed(const Duration(seconds: 10));

      // Perform initial check in background
      BackgroundTaskService.scheduleDelayedTask(
        'initial_completion_check',
        () => _performCompletionCheckInBackground(),
        const Duration(seconds: 2),
      );

      // Emit service started event
      _eventController?.add(AutoCompletionEvent(
        type: AutoCompletionEventType.serviceStarted,
        message: 'Automatic habit completion service started',
        timestamp: DateTime.now(),
      ));

      AppLogger.info('Automatic habit completion service started successfully');
    } catch (e) {
      AppLogger.error('Failed to start automatic completion service', e);
      _isRunning = false;
    }
  }

  /// Stop the automatic completion service
  static Future<void> stopService() async {
    if (!_isRunning) {
      AppLogger.info('Automatic completion service not running');
      return;
    }

    try {
      AppLogger.info('Stopping automatic habit completion service...');

      _completionTimer?.cancel();
      _completionTimer = null;
      _realTimeTimer?.cancel();
      _realTimeTimer = null;
      _isRunning = false;
      _realTimeEnabled = false;

      // Clear pending completions
      _pendingCompletions.clear();
      _lastHealthDataValues.clear();

      // Emit service stopped event
      _eventController?.add(AutoCompletionEvent(
        type: AutoCompletionEventType.serviceStopped,
        message: 'Automatic habit completion service stopped',
        timestamp: DateTime.now(),
      ));

      AppLogger.info('Automatic habit completion service stopped');
    } catch (e) {
      AppLogger.error('Failed to stop automatic completion service', e);
    }
  }

  /// Check if the service is enabled
  static Future<bool> isServiceEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_serviceEnabledKey) ??
          false; // Default disabled for stability
    } catch (e) {
      AppLogger.error('Error checking service enabled status', e);
      return false;
    }
  }

  /// Enable or disable the service
  static Future<void> setServiceEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_serviceEnabledKey, enabled);

      if (enabled && !_isRunning) {
        await startService();
      } else if (!enabled && _isRunning) {
        await stopService();
      }

      AppLogger.info(
          'Automatic completion service ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting service enabled status', e);
    }
  }

  /// Get the check interval in minutes
  static Future<int> getCheckIntervalMinutes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_completionIntervalKey) ??
          30; // Default 30 minutes (battery-friendly)
    } catch (e) {
      AppLogger.error('Error getting check interval', e);
      return 30;
    }
  }

  /// Set the check interval in minutes
  static Future<void> setCheckIntervalMinutes(int minutes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_completionIntervalKey, minutes);

      // Restart service with new interval if running
      if (_isRunning) {
        await stopService();
        await startService();
      }

      AppLogger.info('Check interval set to $minutes minutes');
    } catch (e) {
      AppLogger.error('Error setting check interval', e);
    }
  }

  /// Get adaptive check interval that balances battery life with responsiveness
  static Future<int> _getAdaptiveCheckInterval() async {
    final baseInterval = await getCheckIntervalMinutes();

    // If no recent errors, use base interval
    if (_recentErrorCount == 0 || _lastErrorTime == null) {
      return baseInterval;
    }

    // If last error was more than 1 hour ago, reset error count
    final now = DateTime.now();
    if (now.difference(_lastErrorTime!).inHours >= 1) {
      _recentErrorCount = 0;
      _lastErrorTime = null;
      return baseInterval;
    }

    // Increase interval based on error count (but cap at 2x base interval)
    final multiplier = (1 + (_recentErrorCount * 0.5)).clamp(1.0, 2.0);
    final adaptiveInterval = (baseInterval * multiplier).round();

    if (adaptiveInterval > baseInterval) {
      AppLogger.info(
          'Using adaptive interval: ${adaptiveInterval}min (base: ${baseInterval}min, errors: $_recentErrorCount)');
    }

    return adaptiveInterval;
  }

  /// Check if real-time monitoring is enabled
  static Future<bool> isRealTimeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_realTimeEnabledKey) ??
          false; // Default disabled for battery
    } catch (e) {
      AppLogger.error('Error checking real-time enabled status', e);
      return false;
    }
  }

  /// Enable or disable real-time monitoring
  static Future<void> setRealTimeEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_realTimeEnabledKey, enabled);

      _realTimeEnabled = enabled;

      if (_isRunning) {
        if (enabled) {
          await _startRealTimeMonitoring();
        } else {
          _realTimeTimer?.cancel();
          _realTimeTimer = null;
        }
      }

      AppLogger.info(
          'Real-time monitoring ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting real-time enabled status', e);
    }
  }

  /// Start real-time monitoring (battery-conscious)
  static Future<void> _startRealTimeMonitoring() async {
    if (_realTimeTimer != null) return;

    AppLogger.info('Starting battery-conscious real-time monitoring...');

    // Use a longer interval for real-time checks to preserve battery
    // Only check every 5 minutes for "real-time" responsiveness
    _realTimeTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _performLightweightHealthCheck(),
    );
  }

  /// Perform lightweight health check for real-time monitoring
  static Future<void> _performLightweightHealthCheck() async {
    if (!_realTimeEnabled || !_isRunning) return;

    try {
      // Only check if we haven't checked recently (prevent excessive calls)
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastHealthDataCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Skip if we checked less than 3 minutes ago
      if (now - lastCheck < 180000) return;

      await prefs.setInt(_lastHealthDataCheckKey, now);

      // Perform a quick check for high-priority habits only
      await BackgroundTaskService.executeLightweightTask<void>(
        'realtime_health_check',
        () async => await _performQuickCompletionCheck(),
      );
    } catch (e) {
      AppLogger.warning('Real-time health check failed: $e');
    }
  }

  /// Perform quick completion check for high-priority habits
  static Future<void> _performQuickCompletionCheck() async {
    try {
      // Check if health operations should proceed
      final shouldProceed =
          await HealthService.shouldPerformHealthOperations().timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );

      if (!shouldProceed) return;

      // Get only habits that are likely to be completed today
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final allHabits = await habitService.getActiveHabits();

      // Filter to habits that haven't been completed today and are health-mappable
      final today = DateTime.now();
      final todayHabits = allHabits.where((habit) {
        final completions = habit.completions;
        final todayCompletion = completions.any((completion) {
          return completion.year == today.year &&
              completion.month == today.month &&
              completion.day == today.day;
        });
        return !todayCompletion;
      }).toList();

      if (todayHabits.isEmpty) return;

      // Only check the first few habits to keep it lightweight
      final priorityHabits = todayHabits.take(3).toList();

      for (final habit in priorityHabits) {
        if (_pendingCompletions.contains(habit.id)) continue;

        final result = await HealthHabitMappingService.checkHabitCompletion(
          habit: habit,
          date: today,
        );

        if (result.shouldComplete) {
          _pendingCompletions.add(habit.id);
          await _completeHabitWithNotification(habit, result);
        }
      }
    } catch (e) {
      AppLogger.warning('Quick completion check failed: $e');
    }
  }

  /// Perform completion check in background to prevent UI blocking
  static Future<void> _performCompletionCheckInBackground() async {
    try {
      await BackgroundTaskService.executeBackgroundTask<AutoCompletionResult>(
        'habit_completion_check',
        () => _performCompletionCheck(),
        timeout: const Duration(minutes: 2),
      );
    } catch (e) {
      AppLogger.error('Background completion check failed', e);
      _recentErrorCount++;
      _lastErrorTime = DateTime.now();
    }
  }

  /// Complete habit with notification
  static Future<void> _completeHabitWithNotification(
    Habit habit,
    HabitCompletionResult result,
  ) async {
    try {
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);

      // Mark habit as complete
      await habitService.markHabitComplete(habit.id, DateTime.now());

      // Send notification
      await NotificationService.showNotification(
        id: habit.id.hashCode,
        title: 'Habit Completed! 🎉',
        body: '${habit.name} - ${result.reason}',
      );

      // Emit completion event
      _eventController?.add(AutoCompletionEvent(
        type: AutoCompletionEventType.habitCompleted,
        message: 'Auto-completed: ${habit.name}',
        habitId: habit.id,
        habitName: habit.name,
        timestamp: DateTime.now(),
        healthValue: result.healthValue,
        threshold: result.threshold,
        healthDataType: result.healthDataType,
        confidence: result.confidence,
      ));

      // Add to completion history
      final completion = HabitAutoCompletion(
        habitId: habit.id,
        habitName: habit.name,
        completedAt: DateTime.now(),
        healthDataType: result.healthDataType,
        healthValue: result.healthValue,
        threshold: result.threshold,
        confidence: result.confidence,
        reason: result.reason,
      );
      await _addToCompletionHistory(completion);

      AppLogger.info('Auto-completed habit: ${habit.name} (${result.reason})');
    } catch (e) {
      AppLogger.error('Failed to complete habit ${habit.name}', e);
      _pendingCompletions.remove(habit.id);
    }
  }

  /// Perform a manual completion check
  static Future<AutoCompletionResult> performManualCheck() async {
    AppLogger.info('Performing manual habit completion check...');
    return await _performCompletionCheck();
  }

  /// Get service status
  static Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheck = prefs.getInt(_lastCompletionCheckKey) ?? 0;
      final intervalMinutes = await getCheckIntervalMinutes();

      return {
        'isRunning': _isRunning,
        'isEnabled': await isServiceEnabled(),
        'realTimeEnabled': _realTimeEnabled,
        'lastCheckTime': lastCheck,
        'lastCheckDate': lastCheck > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastCheck).toIso8601String()
            : null,
        'checkIntervalMinutes': intervalMinutes,
        'nextCheckTime': _isRunning && lastCheck > 0
            ? lastCheck + (intervalMinutes * 60 * 1000)
            : null,
        'recentErrorCount': _recentErrorCount,
        'pendingCompletions': _pendingCompletions.length,
        'batteryOptimized': true,
      };
    } catch (e) {
      AppLogger.error('Error getting service status', e);
      return {
        'isRunning': false,
        'isEnabled': false,
        'error': e.toString(),
      };
    }
  }

  /// Get battery optimization recommendations
  static Future<Map<String, dynamic>> getBatteryOptimizationStatus() async {
    try {
      final intervalMinutes = await getCheckIntervalMinutes();
      final realTimeEnabled = await isRealTimeEnabled();

      final recommendations = <String>[];
      var batteryScore = 100; // Start with perfect score

      // Check interval frequency
      if (intervalMinutes < 30) {
        recommendations.add(
            'Consider increasing check interval to 30+ minutes for better battery life');
        batteryScore -= 20;
      }

      // Real-time monitoring impact
      if (realTimeEnabled) {
        recommendations.add(
            'Real-time monitoring uses additional battery. Disable if not needed.');
        batteryScore -= 15;
      }

      // Error rate impact
      if (_recentErrorCount > 3) {
        recommendations.add(
            'High error rate detected. Service will automatically reduce frequency.');
        batteryScore -= 10;
      }

      // Optimal settings
      if (intervalMinutes >= 30 && !realTimeEnabled && _recentErrorCount == 0) {
        recommendations.add('Battery optimization is excellent! 🔋');
      }

      return {
        'batteryScore': batteryScore,
        'recommendations': recommendations,
        'checkIntervalMinutes': intervalMinutes,
        'realTimeEnabled': realTimeEnabled,
        'errorCount': _recentErrorCount,
        'estimatedBatteryImpact':
            _calculateBatteryImpact(intervalMinutes, realTimeEnabled),
      };
    } catch (e) {
      AppLogger.error('Error getting battery optimization status', e);
      return {
        'batteryScore': 0,
        'error': e.toString(),
      };
    }
  }

  /// Calculate estimated battery impact
  static String _calculateBatteryImpact(
      int intervalMinutes, bool realTimeEnabled) {
    var impact = 'Low';

    if (intervalMinutes < 15) {
      impact = 'High';
    } else if (intervalMinutes < 30) {
      impact = 'Medium';
    }

    if (realTimeEnabled) {
      if (impact == 'Low') {
        impact = 'Medium';
      } else if (impact == 'Medium') {
        impact = 'High';
      }
    }

    return impact;
  }

  /// Get completion history
  static Future<List<Map<String, dynamic>>> getCompletionHistory(
      {int limit = 50}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_completionHistoryKey) ?? [];

      // Parse and return recent completions
      final history = historyJson
          .map((json) => _parseCompletionHistoryEntry(json))
          .where((entry) => entry != null)
          .cast<Map<String, dynamic>>()
          .take(limit)
          .toList();

      return history;
    } catch (e) {
      AppLogger.error('Error getting completion history', e);
      return [];
    }
  }

  /// Clear completion history
  static Future<void> clearCompletionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_completionHistoryKey);
      AppLogger.info('Completion history cleared');
    } catch (e) {
      AppLogger.error('Error clearing completion history', e);
    }
  }

  /// Run health habit mapping test for debugging
  static Future<void> runMappingTest() async {
    AppLogger.info('Running health habit mapping test...');
    await HealthHabitMappingTest.testMappings();
  }

  /// Test specific habit mapping
  static Future<void> testSpecificHabit(
      String habitName, String category) async {
    await HealthHabitMappingTest.testSpecificHabit(habitName, category);
  }

  /// Dispose of the service
  static Future<void> dispose() async {
    await stopService();
    await _eventController?.close();
    _eventController = null;
  }

  /// Core completion check logic
  static Future<AutoCompletionResult> _performCompletionCheck() async {
    final result = AutoCompletionResult();

    try {
      AppLogger.info('Performing automatic habit completion check...');

      // Update last check time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          _lastCompletionCheckKey, DateTime.now().millisecondsSinceEpoch);

      // Check if health operations should proceed (includes both user preference and permissions)
      final shouldProceed =
          await HealthService.shouldPerformHealthOperations().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.warning(
              'Health operations check timed out - assuming false');
          return false;
        },
      );

      if (!shouldProceed) {
        AppLogger.info(
            'Health operations disabled - skipping completion check');
        result.skippedReason = 'Health operations disabled';
        return result;
      }

      // Get active habits and filter for health-mappable habits
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final allHabits = await habitService.getActiveHabits();

      // Use mapping service to find health-related habits regardless of category
      AppLogger.info('Found ${allHabits.length} active habits total');
      for (final habit in allHabits) {
        AppLogger.info(
            'Active habit: "${habit.name}" (category: ${habit.category})');
      }

      final mappableHabits =
          await HealthHabitMappingService.getMappableHabits(allHabits);
      AppLogger.info('Found ${mappableHabits.length} mappable habits');
      for (final mapping in mappableHabits) {
        final habit = allHabits.firstWhere((h) => h.id == mapping.habitId);
        AppLogger.info(
            'Mappable habit: "${habit.name}" -> ${mapping.healthDataType} (threshold: ${mapping.threshold})');
      }

      final habits = allHabits
          .where((habit) =>
              mappableHabits.any((mapping) => mapping.habitId == habit.id))
          .toList();

      if (habits.isEmpty) {
        AppLogger.info('No active health-mappable habits found');
        result.skippedReason = 'No active health-mappable habits';
        return result;
      }

      // Get current time for completion checks
      final now = DateTime.now();

      // Process each habit for potential completion
      for (final habit in habits) {
        try {
          AppLogger.info('Processing habit for auto-completion: ${habit.name}');

          // Skip if already completed today
          if (habit.isCompletedToday) {
            AppLogger.info(
                'Habit ${habit.name} already completed today, skipping');
            continue;
          }

          // Check if habit can be auto-completed based on health data
          // Add timeout and error handling to prevent crashes
          final completionCheck =
              await HealthHabitMappingService.checkHabitCompletion(
            habit: habit,
            date: now,
          ).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              AppLogger.warning(
                  'Habit completion check timed out for ${habit.name}');
              return HabitCompletionResult(
                shouldComplete: false,
                reason: 'Health data check timed out',
              );
            },
          );

          if (completionCheck.shouldComplete) {
            // Mark habit as complete
            await habitService.markHabitComplete(habit.id, now);

            // Record the completion
            final completion = HabitAutoCompletion(
              habitId: habit.id,
              habitName: habit.name,
              completedAt: now,
              healthDataType: completionCheck.healthDataType,
              healthValue: completionCheck.healthValue,
              threshold: completionCheck.threshold,
              confidence: completionCheck.confidence,
              reason: completionCheck.reason,
            );

            result.completions.add(completion);

            // Store in history
            await _addToCompletionHistory(completion);

            // Emit completion event
            _eventController?.add(AutoCompletionEvent(
              type: AutoCompletionEventType.habitCompleted,
              habitId: habit.id,
              habitName: habit.name,
              message: 'Auto-completed: ${habit.name}',
              timestamp: now,
              healthValue: completionCheck.healthValue,
              confidence: completionCheck.confidence,
            ));

            AppLogger.info(
                'Auto-completed habit: ${habit.name} (${completionCheck.reason})');
          }
        } catch (e) {
          AppLogger.error(
              'Error checking habit ${habit.name} for completion', e);
          result.errors.add('Error checking ${habit.name}: $e');
        }
      }

      result.success = true;
      result.checkedHabits = habits.length;
      result.completedHabits = result.completions.length;

      // Send notification if habits were completed
      if (result.completions.isNotEmpty) {
        await _sendCompletionNotification(result.completions);
      }

      // Emit check completed event
      _eventController?.add(AutoCompletionEvent(
        type: AutoCompletionEventType.checkCompleted,
        message:
            'Completion check finished: ${result.completedHabits}/${result.checkedHabits} habits completed',
        timestamp: now,
      ));

      AppLogger.info(
          'Completion check finished: ${result.completedHabits}/${result.checkedHabits} habits auto-completed');

      // Reset error count on successful completion
      _recentErrorCount = 0;
      _lastErrorTime = null;
    } catch (e) {
      AppLogger.error('Error during completion check', e);
      result.success = false;
      result.error = e.toString();

      // Track errors for adaptive interval
      _recentErrorCount++;
      _lastErrorTime = DateTime.now();

      AppLogger.warning(
          'Recent completion check errors: $_recentErrorCount (will increase check interval temporarily)');

      // Emit error event
      _eventController?.add(AutoCompletionEvent(
        type: AutoCompletionEventType.error,
        message: 'Completion check failed: $e',
        timestamp: DateTime.now(),
      ));
    }

    return result;
  }

  /// Add completion to history
  static Future<void> _addToCompletionHistory(
      HabitAutoCompletion completion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_completionHistoryKey) ?? [];

      // Add new completion to the beginning
      historyJson.insert(0, _serializeCompletionHistoryEntry(completion));

      // Keep only the last 100 entries
      if (historyJson.length > 100) {
        historyJson.removeRange(100, historyJson.length);
      }

      await prefs.setStringList(_completionHistoryKey, historyJson);
    } catch (e) {
      AppLogger.error('Error adding to completion history', e);
    }
  }

  /// Send notification for completed habits
  static Future<void> _sendCompletionNotification(
      List<HabitAutoCompletion> completions) async {
    try {
      if (completions.isEmpty) return;

      String title;
      String body;

      if (completions.length == 1) {
        final completion = completions.first;
        title = 'Habit Auto-Completed! 🎉';
        body =
            '${completion.habitName} was automatically marked as complete based on your health data.';
      } else {
        title = 'Multiple Habits Auto-Completed! 🎉';
        body =
            '${completions.length} habits were automatically completed based on your health data.';
      }

      await NotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        payload: 'auto_completion',
      );
    } catch (e) {
      AppLogger.error('Error sending completion notification', e);
    }
  }

  /// Serialize completion history entry
  static String _serializeCompletionHistoryEntry(
      HabitAutoCompletion completion) {
    return '${completion.completedAt.millisecondsSinceEpoch}|${completion.habitId}|${completion.habitName}|${completion.healthDataType?.name ?? ''}|${completion.healthValue ?? ''}|${completion.confidence}|${completion.reason}';
  }

  /// Parse completion history entry
  static Map<String, dynamic>? _parseCompletionHistoryEntry(String entry) {
    try {
      final parts = entry.split('|');
      if (parts.length < 7) return null;

      return {
        'completedAt': DateTime.fromMillisecondsSinceEpoch(int.parse(parts[0])),
        'habitId': parts[1],
        'habitName': parts[2],
        'healthDataType': parts[3].isNotEmpty ? parts[3] : null,
        'healthValue': parts[4].isNotEmpty ? double.tryParse(parts[4]) : null,
        'confidence': double.tryParse(parts[5]) ?? 0.0,
        'reason': parts[6],
      };
    } catch (e) {
      AppLogger.error('Error parsing completion history entry', e);
      return null;
    }
  }
}

/// Auto-completion result
class AutoCompletionResult {
  bool success = false;
  int checkedHabits = 0;
  int completedHabits = 0;
  List<HabitAutoCompletion> completions = [];
  List<String> errors = [];
  String? error;
  String? skippedReason;

  bool get hasCompletions => completions.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty || error != null;
}

/// Individual habit auto-completion record
class HabitAutoCompletion {
  final String habitId;
  final String habitName;
  final DateTime completedAt;
  final dynamic healthDataType;
  final double? healthValue;
  final double? threshold;
  final double confidence;
  final String reason;

  HabitAutoCompletion({
    required this.habitId,
    required this.habitName,
    required this.completedAt,
    this.healthDataType,
    this.healthValue,
    this.threshold,
    required this.confidence,
    required this.reason,
  });
}

/// Auto-completion event
class AutoCompletionEvent {
  final AutoCompletionEventType type;
  final String message;
  final DateTime timestamp;
  final String? habitId;
  final String? habitName;
  final double? healthValue;
  final double? threshold;
  final String? healthDataType;
  final double? confidence;

  AutoCompletionEvent({
    required this.type,
    required this.message,
    required this.timestamp,
    this.habitId,
    this.habitName,
    this.healthValue,
    this.threshold,
    this.healthDataType,
    this.confidence,
  });
}

/// Auto-completion event types
enum AutoCompletionEventType {
  serviceStarted,
  serviceStopped,
  checkCompleted,
  habitCompleted,
  error,
}
