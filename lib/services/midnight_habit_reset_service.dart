import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'notification_service.dart';
import 'widget_integration_service.dart';
import 'logging_service.dart';

/// Service responsible for resetting habits at midnight based on their frequency
/// This replaces the complex renewal system with a simple, predictable midnight reset
/// Also handles widget refresh at midnight to ensure widgets show current day data
class MidnightHabitResetService {
  static Timer? _midnightTimer;
  static bool _isInitialized = false;
  static const String _lastResetKey = 'last_midnight_reset';

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

  /// Start the midnight timer
  static Future<void> _startMidnightTimer() async {
    // Cancel existing timer if any
    _midnightTimer?.cancel();

    // Calculate time until next midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final timeUntilMidnight = nextMidnight.difference(now);

    AppLogger.info(
        '⏰ Next midnight reset in: ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');

    // Set timer for next midnight
    _midnightTimer = Timer(timeUntilMidnight, () async {
      await _performMidnightReset();

      // Set up daily recurring timer after first midnight
      _midnightTimer = Timer.periodic(const Duration(days: 1), (timer) async {
        await _performMidnightReset();
      });
    });

    AppLogger.info('🌙 Midnight reset timer started');
  }

  /// Check if we missed a reset while the app was closed
  static Future<void> _checkMissedReset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastResetStr = prefs.getString(_lastResetKey);
      final now = DateTime.now();

      if (lastResetStr != null) {
        final lastReset = DateTime.parse(lastResetStr);

        // Check if we've crossed midnight since the last reset
        final lastResetDate =
            DateTime(lastReset.year, lastReset.month, lastReset.day);
        final currentDate = DateTime(now.year, now.month, now.day);

        if (currentDate.isAfter(lastResetDate)) {
          AppLogger.info(
              '📅 Missed reset detected (last: ${lastResetDate.toIso8601String()}, current: ${currentDate.toIso8601String()}), performing catch-up reset');
          await _performMidnightReset();
        } else {
          AppLogger.debug('✅ No missed reset - last reset was today');
        }
      } else {
        // First time running, perform initial reset
        AppLogger.info('🆕 First time running, performing initial reset');
        await _performMidnightReset();
      }
    } catch (e) {
      AppLogger.error('❌ Error checking missed reset', e);
    }
  }

  /// Perform the midnight reset
  static Future<void> _performMidnightReset() async {
    try {
      final now = DateTime.now();
      AppLogger.info(
          '🌙 Performing midnight habit reset at ${now.toIso8601String()}');

      // Get all active habits
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
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
            AppLogger.info('✅ Reset habit: ${habit.name}');
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('❌ Error resetting habit: ${habit.name}', e);
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
          AppLogger.info('✅ Android WorkManager widget update triggered');
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastResetKey, now.toIso8601String());

      AppLogger.info(
          '✅ Midnight reset completed: $resetCount reset, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during midnight reset', e);
    }
  }

  /// Check if a habit should be reset based on its frequency and current time
  static bool _shouldResetHabit(Habit habit, DateTime now) {
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

      // Schedule notifications for the new period (SAFE: no alarms during boot)
      if (habit.notificationsEnabled) {
        await NotificationService.scheduleHabitNotificationsOnly(habit);
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
      await _checkMissedReset();
    } catch (e) {
      AppLogger.error(
          '❌ Error checking for missed resets on app activation', e);
    }
  }

  /// Get service status
  static Map<String, dynamic> getStatus() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final timeUntilMidnight = nextMidnight.difference(now);

    return {
      'isActive': _isInitialized,
      'nextReset': nextMidnight.toIso8601String(),
      'timeUntilReset':
          '${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m',
    };
  }
}
