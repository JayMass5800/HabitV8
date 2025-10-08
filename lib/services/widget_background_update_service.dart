import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';

/// Background service for updating widgets when app is closed
///
/// This service uses WorkManager to run a background task that:
/// 1. Reads fresh data from Isar database
/// 2. Updates SharedPreferences with the latest habit data
/// 3. Triggers widget UI refresh
///
/// This ensures widgets stay up-to-date even when the Flutter app is not running.
class WidgetBackgroundUpdateService {
  static const String _taskName = 'widget_background_update';
  static const String _uniqueName = 'widget_background_update_unique';

  /// Initialize the background update service
  ///
  /// This must be called during app initialization (in main.dart)
  /// BEFORE runApp() to ensure the callback is registered.
  static Future<void> initialize() async {
    try {
      // Register the background callback with WorkManager
      // This callback will be executed even when the app is closed
      await Workmanager().initialize(
        callbackDispatcher,
      );

      debugPrint('✅ WidgetBackgroundUpdateService initialized');
    } catch (e) {
      debugPrint('❌ Error initializing WidgetBackgroundUpdateService: $e');
    }
  }

  /// Schedule periodic background updates
  ///
  /// This schedules a background task that runs every 30 minutes
  /// to update widget data from the Isar database.
  ///
  /// Note: This is a safety net. The primary update mechanism is
  /// the Isar listener in WidgetIntegrationService (when app is running).
  static Future<void> schedulePeriodicUpdates() async {
    try {
      await Workmanager().registerPeriodicTask(
        _uniqueName,
        _taskName,
        frequency: const Duration(minutes: 30),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );

      debugPrint(
          '✅ Scheduled periodic widget background updates (every 30 minutes)');
    } catch (e) {
      debugPrint('❌ Error scheduling periodic widget updates: $e');
    }
  }

  /// Trigger an immediate background update
  ///
  /// This can be called to force an immediate widget update
  /// without waiting for the periodic task.
  static Future<void> triggerImmediateUpdate() async {
    try {
      await Workmanager().registerOneOffTask(
        'widget_immediate_update_${DateTime.now().millisecondsSinceEpoch}',
        _taskName,
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );

      debugPrint('✅ Triggered immediate widget background update');
    } catch (e) {
      debugPrint('❌ Error triggering immediate widget update: $e');
    }
  }

  /// Cancel all scheduled background updates
  static Future<void> cancelAll() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('✅ Cancelled all widget background updates');
    } catch (e) {
      debugPrint('❌ Error cancelling widget background updates: $e');
    }
  }
}

/// Background callback dispatcher
///
/// This function is called by WorkManager when the background task runs.
/// It MUST be a top-level function (not a class method) and MUST be annotated with @pragma.
///
/// CRITICAL: This function runs in a separate isolate with no access to the main app state.
/// It must initialize its own Isar instance and read data independently.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('🔄 [Background] Widget update task started: $task');

      // Initialize Isar in the background isolate
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Get fresh habit data from database
      final allHabits = await habitService.getAllHabits();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Filter habits for today
      final todayHabits = allHabits.where((habit) {
        return _shouldShowHabitOnDate(habit, today);
      }).toList();

      debugPrint(
          '🔄 [Background] Found ${allHabits.length} total habits, ${todayHabits.length} for today');

      // Convert habits to JSON
      final habitsJson = jsonEncode(
        todayHabits.map((h) => _habitToJson(h, today)).toList(),
      );

      // Save to SharedPreferences via home_widget
      await HomeWidget.saveWidgetData<String>('habits', habitsJson);
      await HomeWidget.saveWidgetData<String>('today_habits', habitsJson);
      await HomeWidget.saveWidgetData<int>(
        'lastUpdate',
        DateTime.now().millisecondsSinceEpoch,
      );

      debugPrint(
          '🔄 [Background] Saved widget data: ${habitsJson.length} characters');

      // Trigger widget UI refresh
      await HomeWidget.updateWidget(
        name: 'HabitTimelineWidgetProvider',
        androidName: 'HabitTimelineWidgetProvider',
      );

      await HomeWidget.updateWidget(
        name: 'HabitCompactWidgetProvider',
        androidName: 'HabitCompactWidgetProvider',
      );

      debugPrint('✅ [Background] Widget update completed successfully');

      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('❌ [Background] Error updating widgets: $e');
      debugPrint('❌ [Background] Stack trace: $stackTrace');
      return Future.value(false);
    }
  });
}

/// Check if a habit should be shown on a specific date
bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
  if (!habit.isActive) return false;

  // Use createdAt as start date
  final startDate = DateTime(
    habit.createdAt.year,
    habit.createdAt.month,
    habit.createdAt.day,
  );

  if (date.isBefore(startDate)) return false;

  switch (habit.frequency) {
    case HabitFrequency.daily:
      return true;

    case HabitFrequency.weekly:
      if (habit.selectedWeekdays.isEmpty) return false;
      final weekday = date.weekday % 7; // Convert to 0-6 (Sunday = 0)
      return habit.selectedWeekdays.contains(weekday);

    case HabitFrequency.monthly:
      if (habit.selectedMonthDays.isEmpty) return false;
      return habit.selectedMonthDays.contains(date.day);

    case HabitFrequency.hourly:
      return true; // Hourly habits show every day

    case HabitFrequency.single:
      // For single frequency, check if it matches the scheduled date
      if (habit.singleDateTime != null) {
        final scheduledDate = DateTime(
          habit.singleDateTime!.year,
          habit.singleDateTime!.month,
          habit.singleDateTime!.day,
        );
        return date.isAtSameMomentAs(scheduledDate);
      }
      return false;

    case HabitFrequency.yearly:
      // For yearly frequency, show all habits (simplified)
      return true;
  }
}

/// Convert habit to JSON for widget consumption
Map<String, dynamic> _habitToJson(Habit habit, DateTime date) {
  final isCompleted = _isHabitCompletedOnDate(habit, date);

  return {
    'id': habit.id,
    'name': habit.name,
    'category': habit.category,
    'colorValue': habit.colorValue,
    'isCompleted': isCompleted,
    'status': isCompleted ? 'Completed' : 'Due',
    'timeDisplay': _getHabitTimeDisplay(habit),
    'frequency': habit.frequency.toString().split('.').last,
    'streak': habit.currentStreak,
    'completedSlots': habit.frequency == HabitFrequency.hourly
        ? _getCompletedSlotsCount(habit, date)
        : 0,
    'totalSlots':
        habit.frequency == HabitFrequency.hourly ? habit.hourlyTimes.length : 0,
  };
}

/// Check if habit is completed on a specific date
bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
  if (habit.frequency == HabitFrequency.hourly) {
    // For hourly habits, check if at least one slot is completed
    return habit.completions.any((completion) {
      return completion.year == date.year &&
          completion.month == date.month &&
          completion.day == date.day;
    });
  }

  // For other frequencies, check for any completion on the date
  return habit.completions.any((completion) {
    final completionDate =
        DateTime(completion.year, completion.month, completion.day);
    return completionDate
        .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
  });
}

/// Get completed slots count for hourly habits
int _getCompletedSlotsCount(Habit habit, DateTime date) {
  return habit.completions.where((completion) {
    return completion.year == date.year &&
        completion.month == date.month &&
        completion.day == date.day;
  }).length;
}

/// Get time display for habit
String _getHabitTimeDisplay(Habit habit) {
  switch (habit.frequency) {
    case HabitFrequency.hourly:
      if (habit.hourlyTimes.isNotEmpty) {
        return habit.hourlyTimes.first;
      }
      return 'Hourly';

    case HabitFrequency.daily:
      if (habit.reminderTime != null) {
        final time = habit.reminderTime!;
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
      return 'Daily';

    case HabitFrequency.weekly:
      return 'Weekly';

    case HabitFrequency.monthly:
      return 'Monthly';

    case HabitFrequency.yearly:
      return 'Yearly';

    case HabitFrequency.single:
      return 'Single';
  }
}
