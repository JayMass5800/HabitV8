import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'notification_service.dart';
import 'logging_service.dart';

/// Service responsible for resetting habits at midnight based on their frequency
/// This replaces the complex renewal system with a simple, predictable midnight reset
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
        final daysSinceReset = now.difference(lastReset).inDays;

        if (daysSinceReset >= 1) {
          AppLogger.info('📅 Missed reset detected, performing catch-up reset');
          await _performMidnightReset();
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

      // Schedule notifications for the new period
      if (habit.notificationsEnabled) {
        await _scheduleHabitNotifications(habit);
      }

      AppLogger.debug('🔄 Successfully reset habit: ${habit.name}');
    } catch (e) {
      AppLogger.error('❌ Error resetting habit: ${habit.name}', e);
      rethrow;
    }
  }

  /// Schedule notifications for a habit based on its frequency
  static Future<void> _scheduleHabitNotifications(Habit habit) async {
    try {
      // Cancel any existing notifications for this habit
      await NotificationService.cancelHabitNotifications(
        NotificationService.generateSafeId(habit.id),
      );

      // Schedule new notifications based on frequency
      switch (habit.frequency) {
        case HabitFrequency.daily:
          await _scheduleDailyNotifications(habit);
          break;
        case HabitFrequency.weekly:
          await _scheduleWeeklyNotifications(habit);
          break;
        case HabitFrequency.monthly:
          await _scheduleMonthlyNotifications(habit);
          break;
        case HabitFrequency.yearly:
          await _scheduleYearlyNotifications(habit);
          break;
        case HabitFrequency.hourly:
          await _scheduleHourlyNotifications(habit);
          break;
        case HabitFrequency.single:
          await _scheduleSingleNotifications(habit);
          break;
      }

      AppLogger.debug('📅 Scheduled notifications for habit: ${habit.name}');
    } catch (e) {
      AppLogger.error(
          '❌ Error scheduling notifications for habit: ${habit.name}', e);
    }
  }

  /// Schedule daily notifications
  static Future<void> _scheduleDailyNotifications(Habit habit) async {
    if (habit.notificationTime == null) return;

    final now = DateTime.now();
    final notificationTime = habit.notificationTime!;

    // Schedule for today if time hasn't passed, otherwise tomorrow
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await NotificationService.scheduleNotification(
      id: NotificationService.generateSafeId('${habit.id}_daily'),
      title: '🎯 ${habit.name}',
      body: 'Time to complete your daily habit! Keep your streak going.',
      scheduledTime: scheduledTime,
      payload: 'habit_${habit.id}_daily',
    );
  }

  /// Schedule weekly notifications
  static Future<void> _scheduleWeeklyNotifications(Habit habit) async {
    if (habit.notificationTime == null || habit.selectedWeekdays.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final notificationTime = habit.notificationTime!;

    for (final weekday in habit.selectedWeekdays) {
      // Find next occurrence of this weekday
      int daysUntilWeekday = (weekday - now.weekday) % 7;
      if (daysUntilWeekday == 0) {
        // Today - check if time has passed
        final todayTime = DateTime(now.year, now.month, now.day,
            notificationTime.hour, notificationTime.minute);
        if (todayTime.isBefore(now)) {
          daysUntilWeekday = 7; // Next week
        }
      }

      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day + daysUntilWeekday,
        notificationTime.hour,
        notificationTime.minute,
      );

      await NotificationService.scheduleNotification(
        id: NotificationService.generateSafeId('${habit.id}_weekly_$weekday'),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit! Don\'t break your streak.',
        scheduledTime: scheduledTime,
        payload: 'habit_${habit.id}_weekly',
      );
    }
  }

  /// Schedule monthly notifications
  static Future<void> _scheduleMonthlyNotifications(Habit habit) async {
    if (habit.notificationTime == null || habit.selectedMonthDays.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final notificationTime = habit.notificationTime!;

    for (final day in habit.selectedMonthDays) {
      DateTime scheduledTime;

      if (day <= now.day) {
        // Next month
        scheduledTime = DateTime(now.year, now.month + 1, day,
            notificationTime.hour, notificationTime.minute);
      } else {
        // This month
        scheduledTime = DateTime(now.year, now.month, day,
            notificationTime.hour, notificationTime.minute);
      }

      await NotificationService.scheduleNotification(
        id: NotificationService.generateSafeId('${habit.id}_monthly_$day'),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your monthly habit! Stay consistent.',
        scheduledTime: scheduledTime,
        payload: 'habit_${habit.id}_monthly',
      );
    }
  }

  /// Schedule yearly notifications
  static Future<void> _scheduleYearlyNotifications(Habit habit) async {
    if (habit.notificationTime == null || habit.selectedYearlyDates.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final notificationTime = habit.notificationTime!;

    for (final dateStr in habit.selectedYearlyDates) {
      final parts = dateStr.split('-');
      if (parts.length != 3) continue;

      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);
      if (month == null || day == null) continue;

      DateTime scheduledTime = DateTime(
        now.year,
        month,
        day,
        notificationTime.hour,
        notificationTime.minute,
      );

      // If the date has passed this year, schedule for next year
      if (scheduledTime.isBefore(now)) {
        scheduledTime = DateTime(
          now.year + 1,
          month,
          day,
          notificationTime.hour,
          notificationTime.minute,
        );
      }

      await NotificationService.scheduleNotification(
        id: NotificationService.generateSafeId(
            '${habit.id}_yearly_${month}_$day'),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your yearly habit! Make it count.',
        scheduledTime: scheduledTime,
        payload: 'habit_${habit.id}_yearly',
      );
    }
  }

  /// Schedule hourly notifications (public method for use by NotificationService)
  static Future<void> scheduleHourlyNotifications(Habit habit) async {
    await _scheduleHourlyNotifications(habit);
  }

  /// Schedule hourly notifications
  static Future<void> _scheduleHourlyNotifications(Habit habit) async {
    if (habit.hourlyTimes.isEmpty) return;

    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 48)); // Schedule for next 48 hours

    int scheduledCount = 0;

    for (final timeStr in habit.hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) continue;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      // Schedule for each day in the next 48 hours
      for (DateTime date = now;
          date.isBefore(endTime);
          date = date.add(const Duration(days: 1))) {
        DateTime scheduledTime = 
            DateTime(date.year, date.month, date.day, hour, minute);

        // Only schedule future notifications
        if (scheduledTime.isAfter(now)) {
          await NotificationService.scheduleNotification(
            id: NotificationService.generateSafeId(
                '${habit.id}_hourly_${date.day}_${hour}_$minute'),
            title: '⏰ ${habit.name}',
            body: 'Time for your hourly habit!',
            scheduledTime: scheduledTime,
            payload: 'habit_${habit.id}_hourly',
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount hourly notifications for ${habit.name}');
  }

  /// Schedule single habit notifications
  static Future<void> _scheduleSingleNotifications(Habit habit) async {
    final singleDateTime = habit.singleDateTime;
    if (singleDateTime == null) return;

    final now = DateTime.now();

    // Only schedule if the single date/time is in the future
    if (singleDateTime.isAfter(now)) {
      await NotificationService.scheduleNotification(
        id: NotificationService.generateSafeId('${habit.id}_single'),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your one-time habit!',
        scheduledTime: singleDateTime,
        payload: 'habit_${habit.id}_single',
      );
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
