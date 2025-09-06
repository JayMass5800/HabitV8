import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';

import 'notification_service.dart';
import 'logging_service.dart';

/// Service responsible for ensuring habits continue to work indefinitely
/// using WorkManager for guaranteed execution on Android
class WorkManagerHabitService {
  // Constants for WorkManager task names
  static const String _renewalTaskName = 'com.habitv8.HABIT_RENEWAL_TASK';
  static const String _bootCompletionTaskName =
      'com.habitv8.BOOT_COMPLETION_TASK';
  static const String _lastRenewalKey = 'last_habit_continuation_renewal';
  static const String _renewalIntervalKey = 'habit_continuation_interval_hours';

  // Default renewal every 12 hours to ensure notifications don't expire
  static const int _defaultRenewalIntervalHours = 12;
  static bool _isInitialized = false;

  /// Initialize the WorkManager habit service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing WorkManager Habit Service');

      // Initialize WorkManager
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      // Schedule periodic renewal task
      await _schedulePeriodicRenewalTask();

      // Register boot completion task to reschedule after device restart
      await _registerBootCompletionTask();

      // Perform initial renewal check to ensure all habits are properly scheduled
      await _performRenewalCheck();

      _isInitialized = true;
      AppLogger.info('✅ WorkManager Habit Service initialized successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize WorkManager Habit Service', e);
    }
  }

  /// The callback dispatcher for WorkManager tasks
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      try {
        AppLogger.info('🔄 Executing WorkManager task: $taskName');

        switch (taskName) {
          case _renewalTaskName:
            await _performRenewalCheck();
            break;
          case _bootCompletionTaskName:
            await _handleBootCompletion();
            break;
          default:
            AppLogger.warning('Unknown task name: $taskName');
        }

        return true; // Task completed successfully
      } catch (e) {
        AppLogger.error('❌ Error executing WorkManager task: $taskName', e);
        return false; // Task failed
      }
    });
  }

  /// Schedule the periodic renewal task
  static Future<void> _schedulePeriodicRenewalTask() async {
    try {
      // Get renewal interval from preferences
      final prefs = await SharedPreferences.getInstance();
      final intervalHours =
          prefs.getInt(_renewalIntervalKey) ?? _defaultRenewalIntervalHours;

      // Cancel any existing periodic task
      await Workmanager().cancelByUniqueName(_renewalTaskName);

      // Schedule new periodic task with better constraints
      await Workmanager().registerPeriodicTask(
        _renewalTaskName,
        _renewalTaskName,
        frequency: Duration(hours: intervalHours),
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: Duration(minutes: 15),
      );

      AppLogger.info(
          '🔄 Scheduled periodic renewal task (interval: ${intervalHours}h)');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule periodic renewal task', e);
    }
  }

  /// Register the boot completion task
  static Future<void> _registerBootCompletionTask() async {
    try {
      await Workmanager().registerOneOffTask(
        _bootCompletionTaskName,
        _bootCompletionTaskName,
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        initialDelay: Duration(minutes: 1),
        existingWorkPolicy: ExistingWorkPolicy.keep,
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: Duration(minutes: 5),
        inputData: {'trigger': 'boot_completed'},
      );

      AppLogger.info('✅ Registered boot completion task');
    } catch (e) {
      AppLogger.error('❌ Failed to register boot completion task', e);
    }
  }

  /// Handle boot completion - reschedule all active habits
  static Future<void> _handleBootCompletion() async {
    try {
      AppLogger.info(
          '🔄 Handling boot completion - rescheduling all active habits');

      // Perform full renewal of all habits that should be active
      // We use forceRenewal: true to ensure all habits are properly rescheduled after boot
      await _performHabitContinuationRenewal(forceRenewal: true);

      // Update last renewal timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRenewalKey, DateTime.now().toIso8601String());

      // Re-register the boot completion task for future reboots
      await _registerBootCompletionTask();

      // Re-schedule the periodic renewal task
      await _schedulePeriodicRenewalTask();

      AppLogger.info('✅ Boot completion handling completed successfully');
    } catch (e) {
      AppLogger.error('❌ Error handling boot completion', e);
    }
  }

  /// Perform renewal check and extend notifications/alarms if needed
  static Future<void> _performRenewalCheck() async {
    try {
      AppLogger.info('🔍 Performing habit continuation renewal check');

      final prefs = await SharedPreferences.getInstance();
      final lastRenewalStr = prefs.getString(_lastRenewalKey);
      final now = DateTime.now();

      DateTime? lastRenewal;
      if (lastRenewalStr != null) {
        try {
          lastRenewal = DateTime.parse(lastRenewalStr);
        } catch (e) {
          AppLogger.warning(
              'Invalid last renewal date format: $lastRenewalStr');
        }
      }

      // Check if renewal is needed (every 6 hours or if never renewed)
      bool needsRenewal = false;
      if (lastRenewal == null) {
        needsRenewal = true;
        AppLogger.info('No previous renewal found, performing initial renewal');
      } else {
        final hoursSinceRenewal = now.difference(lastRenewal).inHours;
        if (hoursSinceRenewal >= 6) {
          needsRenewal = true;
          AppLogger.info(
              '$hoursSinceRenewal hours since last renewal, renewal needed');
        } else {
          AppLogger.info(
              '$hoursSinceRenewal hours since last renewal, no renewal needed yet');
        }
      }

      if (needsRenewal) {
        // Only renew habits that should be active at the current time
        await _performHabitContinuationRenewal(forceRenewal: false);

        // Update last renewal timestamp
        await prefs.setString(_lastRenewalKey, now.toIso8601String());
        AppLogger.info(
            '✅ Habit continuation renewal completed and timestamp updated');
      }
    } catch (e) {
      AppLogger.error('❌ Error during habit continuation renewal check', e);
    }
  }

  /// Perform the actual habit continuation renewal
  static Future<void> _performHabitContinuationRenewal({
    bool forceRenewal = false,
    String? specificHabitId,
  }) async {
    try {
      AppLogger.info(
          '🔄 Starting habit continuation renewal process${forceRenewal ? ' (forced)' : ''}${specificHabitId != null ? ' for habit ID: ' : ''}');

      // Get all active habits
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final habits = await habitService.getAllHabits();

      // Filter habits based on parameters
      List<dynamic> habitsToRenew;
      if (specificHabitId != null) {
        // If a specific habit ID is provided, only renew that habit
        habitsToRenew =
            habits.where((h) => h.id == specificHabitId && h.isActive).toList();
      } else {
        // Otherwise, renew all active habits
        habitsToRenew = habits.where((h) => h.isActive).toList();
      }

      AppLogger.info(
          '🔄 Renewing continuation for ${habitsToRenew.length} active habits');

      int renewedCount = 0;
      int errorCount = 0;

      for (final habit in habitsToRenew) {
        try {
          // Only renew habits that should be active now based on their schedule
          // or if force renewal is requested for a specific habit
          bool shouldRenew = forceRenewal && specificHabitId == habit.id;

          if (!shouldRenew) {
            shouldRenew = _shouldRenewHabit(habit);
          }

          if (shouldRenew) {
            if (habit.notificationsEnabled) {
              await _renewHabitNotifications(habit);
              renewedCount++;
              AppLogger.info(
                  '✅ Renewed notifications for habit: ${habit.name}');
            }
          } else {
            AppLogger.info(
                '⏭️ Skipped renewal for habit: ${habit.name} (not scheduled for current time/day)');
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('❌ Error renewing habit: ${habit.name}', e);
        }
      }

      AppLogger.info(
          '✅ Habit continuation renewal completed: $renewedCount renewed, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during habit continuation renewal', e);
    }
  }

  /// Check if a habit should be renewed based on its schedule
  static bool _shouldRenewHabit(dynamic habit, {bool forceRenewal = false}) {
    // If force renewal is requested for a specific habit, allow it
    if (forceRenewal && habit.id != null) return true;

    final now = DateTime.now();

    switch (habit.frequency) {
      case HabitFrequency.hourly:
        // For hourly habits, check if any of the specified times match the current hour
        if (habit.hourlyTimes != null && habit.hourlyTimes.isNotEmpty) {
          for (final timeStr in habit.hourlyTimes) {
            try {
              final parts = timeStr.split(':');
              final hour = int.parse(parts[0]);
              // final minute = int.parse(parts[1]); // Not used for hourly check

              // Check if this time is within the current hour
              if (hour == now.hour) {
                return true;
              }
            } catch (e) {
              // Invalid time format, skip
            }
          }
          return false;
        }
        return true; // Default hourly habit with no specific times

      case HabitFrequency.daily:
        // For daily habits, check if the notification time matches the current time
        if (habit.notificationTime != null) {
          final targetHour = habit.notificationTime.hour;
          final targetMinute = habit.notificationTime.minute;

          // Only renew if we're within 15 minutes of the target time
          final targetTime =
              DateTime(now.year, now.month, now.day, targetHour, targetMinute);
          final diff = now.difference(targetTime).inMinutes.abs();
          return diff <= 15;
        }
        return true; // Default daily habit with no specific time

      case HabitFrequency.weekly:
        // For weekly habits, check if today is one of the selected weekdays
        if (habit.selectedWeekdays != null &&
            habit.selectedWeekdays.isNotEmpty) {
          if (!habit.selectedWeekdays.contains(now.weekday)) {
            return false; // Not scheduled for today
          }

          // Check if the notification time matches the current time
          if (habit.notificationTime != null) {
            final targetHour = habit.notificationTime.hour;
            final targetMinute = habit.notificationTime.minute;

            // Only renew if we're within 15 minutes of the target time
            final targetTime = DateTime(
                now.year, now.month, now.day, targetHour, targetMinute);
            final diff = now.difference(targetTime).inMinutes.abs();
            return diff <= 15;
          }
        }
        return true; // Default weekly habit with no specific weekdays

      case HabitFrequency.monthly:
        // For monthly habits, check if today is one of the selected month days
        if (habit.selectedMonthDays != null &&
            habit.selectedMonthDays.isNotEmpty) {
          if (!habit.selectedMonthDays.contains(now.day)) {
            return false; // Not scheduled for today
          }

          // Check if the notification time matches the current time
          if (habit.notificationTime != null) {
            final targetHour = habit.notificationTime.hour;
            final targetMinute = habit.notificationTime.minute;

            // Only renew if we're within 15 minutes of the target time
            final targetTime = DateTime(
                now.year, now.month, now.day, targetHour, targetMinute);
            final diff = now.difference(targetTime).inMinutes.abs();
            return diff <= 15;
          }
        }
        return true; // Default monthly habit with no specific month days

      case HabitFrequency.yearly:
        // For yearly habits, check if today is one of the selected yearly dates
        if (habit.selectedYearlyDates != null &&
            habit.selectedYearlyDates.isNotEmpty) {
          bool isScheduledForToday = false;

          for (final dateStr in habit.selectedYearlyDates) {
            try {
              final dateParts = dateStr.split('-');
              if (dateParts.length >= 2) {
                final month = int.parse(dateParts[0]);
                final day = int.parse(dateParts[1]);

                if (month == now.month && day == now.day) {
                  isScheduledForToday = true;
                  break;
                }
              }
            } catch (e) {
              // Invalid date format, skip
            }
          }

          if (!isScheduledForToday) {
            return false; // Not scheduled for today
          }

          // Check if the notification time matches the current time
          if (habit.notificationTime != null) {
            final targetHour = habit.notificationTime.hour;
            final targetMinute = habit.notificationTime.minute;

            // Only renew if we're within 15 minutes of the target time
            final targetTime = DateTime(
                now.year, now.month, now.day, targetHour, targetMinute);
            final diff = now.difference(targetTime).inMinutes.abs();
            return diff <= 15;
          }
        }
        return true; // Default yearly habit with no specific dates

      default:
        return false;
    }
  }

  /// Renew notifications for a habit
  static Future<void> _renewHabitNotifications(dynamic habit) async {
    try {
      // Cancel existing notifications first
      await NotificationService.cancelHabitNotifications(
        NotificationService.generateSafeId(habit.id),
      );

      // Schedule new notifications for the habit
      await NotificationService.scheduleHabitNotifications(habit);
    } catch (e) {
      AppLogger.error(
          '❌ Error renewing notifications for habit: ${habit.name}', e);
      rethrow;
    }
  }

  /// Force a manual renewal (useful for testing or user-triggered renewal)
  static Future<void> forceRenewal({String? specificHabitId}) async {
    AppLogger.info(
        '🔄 Force renewal requested${specificHabitId != null ? ' for habit ID: $specificHabitId' : ''}');

    await _performHabitContinuationRenewal(
      forceRenewal: true,
      specificHabitId: specificHabitId,
    );

    // Update the last renewal timestamp
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRenewalKey, DateTime.now().toIso8601String());
  }

  /// Set custom renewal interval
  static Future<void> setRenewalInterval(int hours) async {
    if (hours < 1 || hours > 24) {
      throw ArgumentError('Renewal interval must be between 1 and 24 hours');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_renewalIntervalKey, hours);

    // Reschedule periodic task with new interval
    if (_isInitialized) {
      await _schedulePeriodicRenewalTask();
    }

    AppLogger.info('🔄 Renewal interval set to $hours hours');
  }

  /// Stop the continuation service
  static Future<void> stop() async {
    try {
      await Workmanager().cancelByUniqueName(_renewalTaskName);
      _isInitialized = false;
      AppLogger.info('🔄 WorkManager Habit Service stopped');
    } catch (e) {
      AppLogger.error('❌ Error stopping WorkManager Habit Service', e);
    }
  }

  /// Restart the continuation service
  static Future<void> restart() async {
    await stop();
    await initialize();
  }
}
