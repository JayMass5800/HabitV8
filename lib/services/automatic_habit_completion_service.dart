import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'notification_service.dart';
import 'logging_service.dart';
import 'health_habit_mapping_test.dart';

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

  static Timer? _completionTimer;
  static bool _isRunning = false;
  static StreamController<AutoCompletionEvent>? _eventController;

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

      // Get check interval
      final intervalMinutes = await getCheckIntervalMinutes();

      // Start periodic completion checks
      _completionTimer = Timer.periodic(
        Duration(minutes: intervalMinutes),
        (_) => _performCompletionCheck(),
      );

      _isRunning = true;

      // Perform initial check
      await _performCompletionCheck();

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
      _isRunning = false;

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
      return prefs.getInt(_completionIntervalKey) ?? 30; // Default 30 minutes
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
        'lastCheckTime': lastCheck,
        'lastCheckDate': lastCheck > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastCheck).toIso8601String()
            : null,
        'checkIntervalMinutes': intervalMinutes,
        'nextCheckTime': _isRunning && lastCheck > 0
            ? lastCheck + (intervalMinutes * 60 * 1000)
            : null,
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

      // Check health permissions with timeout to prevent hanging
      final hasHealthPermissions = await HealthService.hasPermissions().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.warning(
              'Health permissions check timed out - assuming false');
          return false;
        },
      );

      if (!hasHealthPermissions) {
        AppLogger.info('No health permissions - skipping completion check');
        result.skippedReason = 'No health permissions';
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
          // Skip if already completed today
          if (habit.isCompletedToday) {
            continue;
          }

          // Check if habit can be auto-completed based on health data
          final completionCheck =
              await HealthHabitMappingService.checkHabitCompletion(
            habit: habit,
            date: now,
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
    } catch (e) {
      AppLogger.error('Error during completion check', e);
      result.success = false;
      result.error = e.toString();

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
  final double? confidence;

  AutoCompletionEvent({
    required this.type,
    required this.message,
    required this.timestamp,
    this.habitId,
    this.habitName,
    this.healthValue,
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
