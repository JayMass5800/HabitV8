import 'dart:async';
import 'preferences_service.dart';
import '../domain/model/habit.dart';
import '../data/database_isar.dart';
import 'notification_service.dart';
import 'widget_integration_service.dart';
import 'rrule_service.dart';
import 'logging_service.dart';
import 'time_service.dart';
import 'notifications/scheduling_reliability_service.dart';
import 'notifications/notification_budget_service.dart';

/// Service responsible for resetting habits at midnight based on their frequency
/// This replaces the complex renewal system with a simple, predictable midnight reset
/// Also handles widget refresh at midnight to ensure widgets show current day data
///
/// Timer Resilience Strategy:
/// - Uses one-time timers with self-rescheduling (avoids drift)
/// - Stores timer state in preferences for recovery
/// - Validates timer is scheduled on app resume
/// - Falls back to catch-up reset if timer was missed
class MidnightHabitResetService {
  static Timer? _midnightTimer;
  static bool _isInitialized = false;
  static const String _lastResetKey = 'last_midnight_reset';
  static const String _timerScheduledKey = 'midnight_timer_scheduled_for';
  static final TimeService _time = TimeService.instance;

  /// Initialize the midnight reset service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🌙 Initializing Midnight Habit Reset Service');

      // Start the midnight timer
      await _startMidnightTimer();

      // Check if we missed a reset (app was closed at midnight)
      await _checkMissedReset();

      _isInitialized = true;
      AppLogger.info('✅ Midnight Habit Reset Service initialized successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize Midnight Habit Reset Service', e);
    }
  }

  /// Start the midnight timer with persistence for resilience
  /// PERFORMANCE: Uses one-time timer with rescheduling instead of periodic
  static Future<void> _startMidnightTimer() async {
    // Cancel existing timer if any
    _midnightTimer?.cancel();

    // Calculate time until next midnight
    final now = _time.nowLocal();
    final nextMidnight = _time.nextMidnightLocal(from: now);
    final timeUntilMidnight = nextMidnight.difference(now);

    AppLogger.info(
        '⏰ Next midnight reset in: ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');

    // Store when timer is scheduled for (for resilience checking)
    await PreferencesService.setString(
      _timerScheduledKey,
      nextMidnight.toIso8601String(),
    );

    // PERFORMANCE: Use one-time timer instead of periodic
    // After firing, it reschedules itself for the next midnight
    _midnightTimer = Timer(timeUntilMidnight, () async {
      try {
        await _performMidnightReset();
      } catch (e) {
        AppLogger.error('❌ Error in midnight reset timer callback', e);
      } finally {
        // CRITICAL: Always reschedule, even if reset failed
        // This ensures the timer chain isn't broken
        await _startMidnightTimer();
      }
    });

    AppLogger.info('🌙 Midnight reset timer scheduled (one-time)');
  }

  /// Validate that the timer is properly scheduled.
  /// Call this on app resume to catch cases where timer was killed.
  static Future<void> validateTimerOnResume() async {
    try {
      final scheduledForStr =
          await PreferencesService.getString(_timerScheduledKey);
      if (scheduledForStr == null) {
        AppLogger.warning(
            '⚠️ No timer scheduled timestamp found, restarting timer');
        await _startMidnightTimer();
        return;
      }

      final scheduledFor = DateTime.parse(scheduledForStr);
      final now = _time.nowLocal();

      // If scheduled time has passed but timer didn't fire, we missed it
      if (now.isAfter(scheduledFor)) {
        AppLogger.warning(
          '⚠️ Timer was scheduled for ${scheduledFor.toIso8601String()} '
          'but it\'s now ${now.toIso8601String()} - timer may have been killed',
        );

        // Perform catch-up reset
        await _checkMissedReset();

        // Restart timer for next midnight
        await _startMidnightTimer();
      } else if (_midnightTimer == null || !_midnightTimer!.isActive) {
        AppLogger.warning('⚠️ Timer is not active, restarting');
        await _startMidnightTimer();
      } else {
        AppLogger.debug('✅ Midnight timer is active and valid');
      }
    } catch (e) {
      AppLogger.error('❌ Error validating timer on resume', e);
      // Safety net: restart timer
      await _startMidnightTimer();
    }
  }

  /// Check if we missed a reset while the app was closed
  static Future<void> _checkMissedReset() async {
    try {
      final lastResetStr = await PreferencesService.getString(_lastResetKey);
      final now = _time.nowLocal();

      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);

        // Check if we've crossed midnight since the last reset
        final lastResetDate = _time.startOfDayLocal(lastReset);
        final currentDate = _time.startOfDayLocal(now);

        if (currentDate.isAfter(lastResetDate)) {
          final daysMissed = currentDate.difference(lastResetDate).inDays;
          AppLogger.info(
              '📅 Missed reset detected (last: ${lastResetDate.toIso8601String()}, '
              'current: ${currentDate.toIso8601String()}, days missed: $daysMissed), '
              'performing catch-up reset');
          await _performMidnightReset(isCatchUp: true);
        } else {
          AppLogger.debug('✅ No missed reset - last reset was today');
        }
      } else {
        // First time running, perform initial reset
        AppLogger.info('🆕 First time running, performing initial reset');
        await _performMidnightReset(isCatchUp: true);
      }
    } catch (e) {
      AppLogger.error('❌ Error checking missed reset', e);
    }
  }

  /// Perform the midnight reset with retry logic
  /// [isCatchUp] indicates if this is a catch-up reset (app started after midnight)
  /// or an actual scheduled midnight reset
  static Future<void> _performMidnightReset({bool isCatchUp = false}) async {
    final failedHabits = <String>[];

    try {
      final now = _time.nowLocal();
      final resetType = isCatchUp ? 'CATCH-UP' : 'SCHEDULED MIDNIGHT';
      AppLogger.info(
          '🌙 Performing $resetType habit reset at ${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}');

      // Get all active habits
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final habits = await habitService.getAllHabits();
      final activeHabits = habits.where((habit) => habit.isActive).toList();

      AppLogger.info(
          '🔄 Processing ${activeHabits.length} active habits for reset');

      // Recalculate notification budget for all habits at midnight
      // This ensures optimal budget distribution as the rolling window moves forward
      try {
        AppLogger.info('📊 Recalculating notification budget allocation...');
        await NotificationBudgetService.calculateBudgetAllocation(activeHabits);
        final stats = NotificationBudgetService.getBudgetStats();
        AppLogger.info(
          '📊 Budget recalculated: ${stats['currentTotalAllocated']}/${stats['availableSlots']} slots, '
          '${stats['habitCount']} habits with notifications',
        );
      } catch (e) {
        AppLogger.error(
            '❌ Failed to recalculate budget, using existing allocation', e);
        // Continue with existing budget - don't block the reset
      }

      int resetCount = 0;

      for (final habit in activeHabits) {
        if (_shouldResetHabit(habit, now)) {
          // Use retry logic for reliability
          final success = await SchedulingReliabilityService.retryWithBackoff(
            operation: () => _resetHabit(habit),
            operationName: 'midnight_reset_${habit.name}',
            maxAttempts:
                2, // Fewer retries during midnight (many habits to process)
          );

          if (success) {
            resetCount++;
            AppLogger.debug('✅ Reset habit: ${habit.name}');
          } else {
            failedHabits.add(habit.name);
            AppLogger.error(
                '❌ Failed to reset habit after retries: ${habit.name}');
          }
        }
      }

      // Update widgets with fresh data for the new day
      try {
        AppLogger.info('🔄 Updating widgets with fresh data for new day...');
        await WidgetIntegrationService.instance.updateAllWidgets();
        AppLogger.info('✅ Widgets updated successfully');

        // Also trigger Android WorkManager update as backup
        try {
          await WidgetIntegrationService.instance.forceWidgetUpdate();
          AppLogger.debug('✅ Android WorkManager widget update triggered');
        } catch (e) {
          AppLogger.warning(
              '⚠️ Android WorkManager widget update failed (non-critical): $e');
        }
      } catch (e) {
        AppLogger.error('❌ Error updating widgets during midnight reset', e);

        // Retry widget update once after a short delay
        try {
          AppLogger.info('🔄 Retrying widget update after error...');
          await Future.delayed(const Duration(seconds: 2));
          await WidgetIntegrationService.instance.updateAllWidgets();
          AppLogger.info('✅ Widget update retry successful');
        } catch (retryError) {
          AppLogger.error('❌ Widget update retry also failed', retryError);
          // Don't fail the entire reset if widget update fails
        }
      }

      // Update last reset timestamp
      await PreferencesService.setString(_lastResetKey, now.toIso8601String());

      final errorCount = failedHabits.length;
      AppLogger.info(
          '✅ Midnight reset completed: $resetCount reset, $errorCount errors');

      // Log failures for debugging
      if (failedHabits.isNotEmpty) {
        AppLogger.error(
          '⚠️ MIDNIGHT RESET FAILURES: ${failedHabits.join(", ")}',
        );
      }
    } catch (e) {
      AppLogger.error('❌ Error during midnight reset', e);
    }
  }

  /// Check if a habit should be reset based on its frequency and current time
  static bool _shouldResetHabit(Habit habit, DateTime now) {
    // Check if habit uses RRule system
    if (habit.usesRRule && habit.rruleString != null) {
      return RRuleService.isDueOnDate(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        checkDate: now,
      );
    }

    // Legacy frequency-based logic for old habits
    switch (habit.frequency) {
      case HabitFrequency.daily:
        // Daily habits reset every day at midnight
        return true;

      case HabitFrequency.weekly:
        // Weekly habits reset on their selected weekdays
        return habit.selectedWeekdays.contains(now.weekday);

      case HabitFrequency.monthly:
        // Monthly habits reset on their selected days of the month
        return habit.selectedMonthDays.contains(now.day);

      case HabitFrequency.yearly:
        // Yearly habits reset on their selected dates
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
        // Hourly habits need to be rescheduled daily to ensure they continue working
        // The previous day's notifications expire, so we need to schedule new ones
        return true;

      case HabitFrequency.single:
        // Single habits don't need midnight reset, they only fire once
        return false;
    }
  }

  /// Reset a single habit
  static Future<void> _resetHabit(Habit habit) async {
    try {
      // For the midnight reset, we don't need to modify the habit object itself
      // The habit's completion status is determined by checking completions list
      // We just need to ensure notifications are scheduled for the new period

      // Schedule notifications for the new period using budget-aware scheduling
      // This respects the pre-calculated budget allocation for optimal distribution
      if (habit.notificationsEnabled) {
        await NotificationService.scheduleHabitNotificationsWithBudget(habit);
      }

      AppLogger.debug('🔄 Successfully reset habit: ${habit.name}');
    } catch (e) {
      AppLogger.error('❌ Error resetting habit: ${habit.name}', e);
      rethrow;
    }
  }

  /// Stop the midnight reset service
  static Future<void> stop() async {
    try {
      _midnightTimer?.cancel();
      _midnightTimer = null;
      _isInitialized = false;
      AppLogger.info('🌙 Midnight Habit Reset Service stopped');
    } catch (e) {
      AppLogger.error('❌ Error stopping Midnight Habit Reset Service', e);
    }
  }

  /// Force an immediate reset (for testing)
  static Future<void> forceReset() async {
    AppLogger.info('🔄 Force reset requested');
    await _performMidnightReset();
  }

  /// Force widget refresh (can be called independently)
  static Future<void> refreshWidgets() async {
    try {
      AppLogger.info('🔄 Manual widget refresh requested');
      await WidgetIntegrationService.instance.updateAllWidgets();
      AppLogger.info('✅ Manual widget refresh completed');
    } catch (e) {
      AppLogger.error('❌ Error during manual widget refresh', e);
      rethrow;
    }
  }

  /// Check for missed resets when app becomes active (more efficient than hourly checks)
  static Future<void> checkForMissedResetOnAppActive() async {
    try {
      AppLogger.debug('🔍 Checking for missed resets on app activation');

      // Also validate timer is still running
      await validateTimerOnResume();

      await _checkMissedReset();
    } catch (e) {
      AppLogger.error(
          '❌ Error checking for missed resets on app activation', e);
    }
  }

  /// Get service status
  static Map<String, dynamic> getStatus() {
    final now = _time.nowLocal();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final timeUntilMidnight = nextMidnight.difference(now);

    return {
      'isActive': _isInitialized,
      'timerActive': _midnightTimer?.isActive ?? false,
      'nextReset': nextMidnight.toIso8601String(),
      'timeUntilReset':
          '${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m',
    };
  }
}
