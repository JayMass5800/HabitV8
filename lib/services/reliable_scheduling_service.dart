import 'dart:async';
import 'preferences_service.dart';
import 'dart:io';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';
import 'notification_service.dart';
import 'notifications/notification_validation_service.dart';
import 'widget_integration_service.dart';
import 'rrule_service.dart';
import 'logging_service.dart';
import 'work_manager_habit_service.dart';
import 'ios_background_tasks_service.dart';
import 'time_service.dart';

/// **Reliable Scheduling Service - Production-Grade Midnight Reset**
///
/// This service implements the "Resilient Chain" pattern recommended for production apps.
/// It uses a multi-layered approach to ensure daily habit resets ALWAYS happen, even under
/// adverse conditions (phone off, Doze mode, battery optimization, timezone changes, etc.).
///
/// ## Architecture Layers (from most to least reliable):
///
/// **Layer 1: OS-Backed Task Scheduler (PRIMARY)**
/// - Android: WorkManager OneTimeWorkRequest
/// - iOS: BGTaskScheduler BGAppRefreshTaskRequest
/// - Survives: App kills, reboots, Doze mode, battery optimization
/// - Scheduled using UTC timestamps for timezone safety
/// - Creates self-rescheduling chain: each task schedules the next one
///
/// **Layer 2: In-App Timer (OPTIMISTIC FAST PATH)**
/// - Dart Timer scheduled to next midnight
/// - Fastest response when app is active
/// - If succeeds, cancels pending OS task and reschedules
/// - Fails when: App killed, phone asleep, aggressive battery saving
///
/// **Layer 3: App Launch Safety Net (CATCH-UP)**
/// - Runs on every app launch
/// - Checks if reset was missed (last reset date < current date)
/// - Performs immediate catch-up reset if needed
/// - Ensures user is never blocked by failed background tasks
///
/// ## Key Features:
/// - ✅ **Timezone-aware**: Calculates next local midnight and converts to UTC
/// - ✅ **DST-safe**: Handles Daylight Saving Time transitions automatically
/// - ✅ **Travel-safe**: Recalculates midnight when timezone changes
/// - ✅ **Diagnostics**: Tracks which layer performed reset and success rates
/// - ✅ **Self-healing**: Automatically recovers from any failure state
///
/// ## Usage:
/// ```dart
/// await ReliableSchedulingService.initialize();
/// ```
class ReliableSchedulingService {
  // Constants
  static const String _lastResetKey = 'reliable_scheduling_last_reset';
  static const String _lastResetMethodKey = 'reliable_scheduling_last_method';
  static const String _resetCountKey = 'reliable_scheduling_reset_count';
  static const String _timerSuccessCountKey =
      'reliable_scheduling_timer_success';
  static const String _workmanagerSuccessCountKey =
      'reliable_scheduling_workmanager_success';
  static const String _catchupSuccessCountKey =
      'reliable_scheduling_catchup_success';
  static const String _lastTimezoneKey = 'reliable_scheduling_last_timezone';

  // State
  static bool _isInitialized = false;
  static Completer<void>? _initializationCompleter;
  static Timer? _optimisticTimer;
  static String? _currentTimezone;
  static final TimeService _time = TimeService.instance;

  /// Initialize the reliable scheduling service
  ///
  /// Uses Completer pattern to prevent race conditions when called
  /// from multiple places simultaneously.
  static Future<void> initialize() async {
    // Already initialized
    if (_isInitialized) {
      AppLogger.info('⏰ ReliableSchedulingService already initialized');
      return;
    }

    // Initialization in progress - wait for it
    if (_initializationCompleter != null) {
      AppLogger.debug(
          '⏰ ReliableSchedulingService initialization in progress, waiting...');
      return _initializationCompleter!.future;
    }

    // Start initialization
    _initializationCompleter = Completer<void>();

    try {
      AppLogger.info(
          '⏰ Initializing ReliableSchedulingService (Resilient Chain Architecture)');

      // Get current timezone for tracking
      _currentTimezone = _time.timezoneName;

      // Layer 3: Safety net - check for missed resets on app launch
      await _performSafetyNetCheck();

      // Layer 1: Schedule OS-backed task (WorkManager/BGTaskScheduler)
      await _scheduleOSBackedTask();

      // Layer 2: Schedule optimistic in-app timer
      await _scheduleOptimisticTimer();

      _isInitialized = true;
      _initializationCompleter!.complete();
      await _logDiagnostics();
      AppLogger.info('✅ ReliableSchedulingService initialized successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize ReliableSchedulingService', e);
      _initializationCompleter!.completeError(e);
      _initializationCompleter = null;
      rethrow;
    }
  }

  /// Layer 3: Safety net check on app launch
  static Future<void> _performSafetyNetCheck() async {
    try {
      AppLogger.info('🛡️ Layer 3: Running safety net check...');

      final lastResetStr = await PreferencesService.getString(_lastResetKey);
      final now = _time.nowLocal();
      final currentDate = _time.startOfDayLocal(now);

      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);
        final lastResetDate = _time.startOfDayLocal(lastReset);

        if (currentDate.isAfter(lastResetDate)) {
          final daysMissed = currentDate.difference(lastResetDate).inDays;
          AppLogger.warning('⚠️ SAFETY NET TRIGGERED: Missed reset detected! '
              'Last reset: ${lastResetDate.toIso8601String()}, '
              'Current: ${currentDate.toIso8601String()}, '
              'Days missed: $daysMissed');

          await _performReset(
            method: 'safety_net',
            reason: 'Missed $daysMissed day(s) - background tasks failed',
          );

          // Reschedule both layers since they clearly failed
          await _scheduleOSBackedTask();
          await _scheduleOptimisticTimer();

          AppLogger.info('✅ Safety net reset completed and tasks rescheduled');
        } else {
          AppLogger.info('✅ Safety net check passed - no missed resets');
        }
      } else {
        // First run - perform initial reset
        AppLogger.info('🆕 First run detected - performing initial reset');
        await _performReset(
          method: 'safety_net',
          reason: 'First run initialization',
        );
      }
    } catch (e) {
      AppLogger.error('❌ Error in safety net check', e);
    }
  }

  /// Layer 1: Schedule OS-backed task (WorkManager on Android, BGTaskScheduler on iOS)
  static Future<void> _scheduleOSBackedTask() async {
    try {
      AppLogger.info(
          '🏗️ Layer 1: Scheduling OS-backed midnight reset task...');

      final nextMidnightUtc = _calculateNextMidnightUtc();
      final now = _time.nowUtc();
      final delay = nextMidnightUtc.difference(now);

      AppLogger.info(
          '📅 Next midnight UTC: ${nextMidnightUtc.toIso8601String()} '
          '(${delay.inHours}h ${delay.inMinutes % 60}m from now)');

      if (Platform.isAndroid) {
        // Use WorkManager for Android
        await WorkManagerHabitService.scheduleMidnightResetTask(delay);
        AppLogger.info('✅ WorkManager midnight reset task scheduled');
      } else if (Platform.isIOS) {
        // iOS BGTaskScheduler will be implemented via platform channel
        await _scheduleIOSBackgroundTask(nextMidnightUtc);
        AppLogger.info('✅ BGTaskScheduler midnight reset task scheduled');
      } else {
        AppLogger.warning(
            '⚠️ Platform not supported for OS-backed tasks: ${Platform.operatingSystem}');
      }
    } catch (e) {
      AppLogger.error('❌ Error scheduling OS-backed task', e);
    }
  }

  /// Layer 2: Schedule optimistic in-app timer
  static Future<void> _scheduleOptimisticTimer() async {
    try {
      AppLogger.info('⏱️ Layer 2: Scheduling optimistic in-app timer...');

      // Cancel existing timer
      _optimisticTimer?.cancel();

      // Calculate time until next midnight (local time)
      final now = _time.nowLocal();
      final nextMidnight = _time.nextMidnightLocal(from: now);
      final delay = nextMidnight.difference(now);

      AppLogger.info('⏰ Next local midnight: ${nextMidnight.toIso8601String()} '
          '(${delay.inHours}h ${delay.inMinutes % 60}m from now)');

      // Schedule one-time timer
      _optimisticTimer = Timer(delay, () async {
        AppLogger.info('⏱️ Optimistic timer fired!');

        await _performReset(
          method: 'timer',
          reason: 'Scheduled timer executed successfully',
        );

        // Self-reschedule: both layers
        await _scheduleOSBackedTask();
        await _scheduleOptimisticTimer();
      });

      AppLogger.info('✅ Optimistic timer scheduled');
    } catch (e) {
      AppLogger.error('❌ Error scheduling optimistic timer', e);
    }
  }

  /// Calculate next midnight in UTC (timezone-safe)
  static DateTime _calculateNextMidnightUtc() {
    return _time.nextMidnightUtc();
  }

  /// Schedule iOS background task via platform channel
  static Future<void> _scheduleIOSBackgroundTask(DateTime targetTimeUtc) async {
    if (!Platform.isIOS) return;

    try {
      await IOSBackgroundTasksService.scheduleMidnightResetTask(targetTimeUtc);
    } catch (e) {
      AppLogger.error('❌ Error scheduling iOS background task', e);
    }
  }

  /// Perform the actual midnight reset
  static Future<void> _performReset({
    required String method,
    required String reason,
  }) async {
    try {
      final now = _time.nowLocal();
      AppLogger.info('🌙 PERFORMING MIDNIGHT RESET at ${now.toIso8601String()} '
          'via $method: $reason');

      // Check for timezone change
      await _checkTimezoneChange();

      // Get all active habits
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final habits = await habitService.getAllHabits();
      final activeHabits = habits.where((habit) => habit.isActive).toList();

      AppLogger.info(
          '🔄 Processing ${activeHabits.length} active habits for reset');

      int resetCount = 0;
      int errorCount = 0;

      for (final habit in activeHabits) {
        try {
          if (_shouldResetHabit(habit, now)) {
            await _resetHabit(habit);
            resetCount++;
            AppLogger.debug('✅ Reset habit: ${habit.name}');
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('❌ Error resetting habit: ${habit.name}', e);
        }
      }

      final habitsForAudit = activeHabits
          .where((habit) => habit.notificationsEnabled || habit.alarmEnabled)
          .toList();

      if (habitsForAudit.isNotEmpty) {
        final auditResults = await NotificationValidationService.auditHabits(
          habitsForAudit,
        );
        NotificationValidationService.logAuditDiscrepancies(
          habits: habitsForAudit,
          results: auditResults,
          context: 'midnight_reset_$method',
        );
      }

      // Update widgets with fresh data
      await _updateWidgets();

      // Record successful reset
      await _recordResetSuccess(method, now);

      AppLogger.info('✅ Midnight reset completed via $method: '
          '$resetCount reset, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during midnight reset', e);
      rethrow;
    }
  }

  /// Check if timezone has changed and handle accordingly
  static Future<void> _checkTimezoneChange() async {
    try {
      final currentTz = _time.timezoneName;
      final lastTz = await PreferencesService.getString(_lastTimezoneKey);

      if (lastTz != null && lastTz != currentTz) {
        AppLogger.warning('🌍 TIMEZONE CHANGE DETECTED: $lastTz → $currentTz');
        AppLogger.info('🔄 Rescheduling tasks for new timezone...');

        // Reschedule all tasks for new timezone
        await _scheduleOSBackedTask();
        await _scheduleOptimisticTimer();

        await PreferencesService.setString(_lastTimezoneKey, currentTz);
      } else if (lastTz == null) {
        await PreferencesService.setString(_lastTimezoneKey, currentTz);
      }

      _currentTimezone = currentTz;
    } catch (e) {
      AppLogger.error('❌ Error checking timezone change', e);
    }
  }

  /// Check if a habit should be reset
  static bool _shouldResetHabit(Habit habit, DateTime now) {
    if (habit.usesRRule && habit.rruleString != null) {
      return RRuleService.isDueOnDate(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        checkDate: now,
      );
    }

    // Legacy frequency logic
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        return habit.selectedWeekdays.contains(now.weekday);
      case HabitFrequency.monthly:
        return habit.selectedMonthDays.contains(now.day);
      case HabitFrequency.yearly:
        if (habit.selectedYearlyDates.isNotEmpty) {
          return habit.selectedYearlyDates.any((dateStr) {
            final parts = dateStr.split('-');
            if (parts.length == 3) {
              return parts[1] == now.month.toString().padLeft(2, '0') &&
                  parts[2] == now.day.toString().padLeft(2, '0');
            }
            return false;
          });
        }
        return false;
      case HabitFrequency.hourly:
        return true;
      case HabitFrequency.single:
        return false;
    }
  }

  /// Reset a single habit
  static Future<void> _resetHabit(Habit habit) async {
    try {
      if (habit.notificationsEnabled) {
        await NotificationService.scheduleHabitNotificationsOnly(habit);
      }
      AppLogger.debug('🔄 Successfully reset habit: ${habit.name}');
    } catch (e) {
      AppLogger.error('❌ Error resetting habit: ${habit.name}', e);
      rethrow;
    }
  }

  /// Update widgets with fresh data
  static Future<void> _updateWidgets() async {
    try {
      AppLogger.info('🔄 Updating widgets with fresh data for new day...');
      await WidgetIntegrationService.instance.updateAllWidgets();
      AppLogger.info('✅ Widgets updated successfully');

      // Trigger Android WorkManager update as backup
      try {
        await WidgetIntegrationService.instance.forceWidgetUpdate();
        AppLogger.info('✅ Android WorkManager widget update triggered');
      } catch (e) {
        AppLogger.warning(
            '⚠️ Android WorkManager widget update failed (non-critical): $e');
      }
    } catch (e) {
      AppLogger.error('❌ Error updating widgets during midnight reset', e);

      // Retry once
      try {
        AppLogger.info('🔄 Retrying widget update...');
        await Future.delayed(const Duration(seconds: 2));
        await WidgetIntegrationService.instance.updateAllWidgets();
        AppLogger.info('✅ Widget update retry successful');
      } catch (retryError) {
        AppLogger.error('❌ Widget update retry failed', retryError);
      }
    }
  }

  /// Record successful reset for diagnostics
  static Future<void> _recordResetSuccess(
      String method, DateTime timestamp) async {
    try {
      // Update last reset timestamp
      await PreferencesService.setString(
          _lastResetKey, timestamp.toIso8601String());
      await PreferencesService.setString(_lastResetMethodKey, method);

      // Increment counters
      final totalResets =
          (await PreferencesService.getIntOrDefault(_resetCountKey, 0)) + 1;
      await PreferencesService.setInt(_resetCountKey, totalResets);

      switch (method) {
        case 'timer':
          final timerCount = (await PreferencesService.getIntOrDefault(
                  _timerSuccessCountKey, 0)) +
              1;
          await PreferencesService.setInt(_timerSuccessCountKey, timerCount);
          break;
        case 'workmanager':
        case 'ios_background':
          final wmCount = (await PreferencesService.getIntOrDefault(
                  _workmanagerSuccessCountKey, 0)) +
              1;
          await PreferencesService.setInt(_workmanagerSuccessCountKey, wmCount);
          break;
        case 'safety_net':
          final catchupCount = (await PreferencesService.getIntOrDefault(
                  _catchupSuccessCountKey, 0)) +
              1;
          await PreferencesService.setInt(
              _catchupSuccessCountKey, catchupCount);
          break;
      }

      AppLogger.debug(
          '📊 Reset statistics updated: method=$method, total=$totalResets');
    } catch (e) {
      AppLogger.error('❌ Error recording reset success', e);
    }
  }

  /// Get diagnostic information
  static Future<Map<String, dynamic>> getDiagnostics() async {
    try {
      final now = _time.nowLocal();
      final nextMidnight = _time.nextMidnightLocal(from: now);

      return {
        'isInitialized': _isInitialized,
        'currentTimezone': _currentTimezone ?? _time.timezoneName,
        'lastReset': await PreferencesService.getString(_lastResetKey),
        'lastResetMethod':
            await PreferencesService.getString(_lastResetMethodKey),
        'nextScheduledReset': nextMidnight.toIso8601String(),
        'timeUntilNextReset': nextMidnight.difference(now).toString(),
        'totalResets':
            await PreferencesService.getIntOrDefault(_resetCountKey, 0),
        'timerSuccesses':
            await PreferencesService.getIntOrDefault(_timerSuccessCountKey, 0),
        'workmanagerSuccesses': await PreferencesService.getIntOrDefault(
            _workmanagerSuccessCountKey, 0),
        'safetyNetSuccesses': await PreferencesService.getIntOrDefault(
            _catchupSuccessCountKey, 0),
        'platform': Platform.operatingSystem,
        'timerActive': _optimisticTimer?.isActive ?? false,
      };
    } catch (e) {
      AppLogger.error('❌ Error getting diagnostics', e);
      return {'error': e.toString()};
    }
  }

  /// Log diagnostic information
  static Future<void> _logDiagnostics() async {
    try {
      final diag = await getDiagnostics();
      AppLogger.info('📊 RELIABLE SCHEDULING DIAGNOSTICS:');
      AppLogger.info('   Platform: ${diag['platform']}');
      AppLogger.info('   Timezone: ${diag['currentTimezone']}');
      AppLogger.info(
          '   Last Reset: ${diag['lastReset']} via ${diag['lastResetMethod']}');
      AppLogger.info('   Next Reset: ${diag['nextScheduledReset']}');
      AppLogger.info('   Time Until: ${diag['timeUntilNextReset']}');
      AppLogger.info('   Statistics:');
      AppLogger.info('     Total Resets: ${diag['totalResets']}');
      AppLogger.info('     Timer Successes: ${diag['timerSuccesses']}');
      AppLogger.info(
          '     WorkManager Successes: ${diag['workmanagerSuccesses']}');
      AppLogger.info(
          '     Safety Net Activations: ${diag['safetyNetSuccesses']}');
      AppLogger.info('   Timer Active: ${diag['timerActive']}');
    } catch (e) {
      AppLogger.error('❌ Error logging diagnostics', e);
    }
  }

  /// Force immediate reset (for testing)
  static Future<void> forceReset({String reason = 'Manual force reset'}) async {
    AppLogger.info('🔄 Force reset requested: $reason');
    await _performReset(method: 'manual', reason: reason);

    // Reschedule both layers
    await _scheduleOSBackedTask();
    await _scheduleOptimisticTimer();
  }

  /// Stop the service
  static Future<void> stop() async {
    try {
      _optimisticTimer?.cancel();
      _optimisticTimer = null;
      _isInitialized = false;
      AppLogger.info('⏰ ReliableSchedulingService stopped');
    } catch (e) {
      AppLogger.error('❌ Error stopping ReliableSchedulingService', e);
    }
  }

  /// Handle timezone change notification from system
  static Future<void> onTimezoneChanged() async {
    AppLogger.info('🌍 System timezone change notification received');
    await _checkTimezoneChange();
  }

  /// Handle app resume (check if tasks are still valid)
  static Future<void> onAppResume() async {
    try {
      AppLogger.debug('📱 App resumed - verifying scheduled tasks...');

      // Check if timer is still active
      if (_optimisticTimer == null || !_optimisticTimer!.isActive) {
        AppLogger.warning('⚠️ Timer not active after resume - rescheduling');
        await _scheduleOptimisticTimer();
      }

      // Run safety net check
      await _performSafetyNetCheck();
    } catch (e) {
      AppLogger.error('❌ Error handling app resume', e);
    }
  }
}
