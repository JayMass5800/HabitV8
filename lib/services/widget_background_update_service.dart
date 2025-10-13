import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';
// CRITICAL: Import prevents tree-shaking of ScheduledNotificationSchema in release builds
// ignore: unused_import
import '../domain/model/scheduled_notification.dart' as notification_model;
import 'rrule_service.dart';

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
///
/// HANDLES MULTIPLE TASK TYPES:
/// - 'widget_background_update': Periodic background updates (every 30 min)
/// - 'widgetUpdate': Immediate updates triggered from notification actions
/// - 'alarmComplete': Alarm completion triggered from AlarmActionReceiver
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('🔄 [Background] Widget update task started: $task');

      // Handle alarm completion task
      if (task == 'alarmComplete') {
        return await _handleAlarmCompletion(inputData);
      }

      // Handle both task types - they both do the same thing: update widgets
      if (task == 'widget_background_update' || task == 'widgetUpdate') {
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

        // Sort habits chronologically by time (same as foreground service)
        todayHabits.sort(
            (a, b) => _getHabitSortTime(a).compareTo(_getHabitSortTime(b)));

        debugPrint(
            '🔄 [Background] Found ${allHabits.length} total habits, ${todayHabits.length} for today');

        // Convert habits to JSON
        final habitsList =
            todayHabits.map((h) => _habitToJson(h, today)).toList();
        final habitsJson = jsonEncode(habitsList);

        debugPrint(
            '🔄 [Background] Preparing to save ${habitsList.length} habits (${habitsJson.length} chars)');
        debugPrint(
            '🔄 [Background] Habit names: ${habitsList.map((h) => h['name']).join(', ')}');
        debugPrint(
            '🔄 [Background] JSON preview: ${habitsJson.length > 200 ? habitsJson.substring(0, 200) : habitsJson}');

        // Save to SharedPreferences via home_widget
        await HomeWidget.saveWidgetData<String>('habits', habitsJson);
        await HomeWidget.saveWidgetData<String>('today_habits', habitsJson);
        await HomeWidget.saveWidgetData<int>(
          'lastUpdate',
          DateTime.now().millisecondsSinceEpoch,
        );

        debugPrint(
            '✅ [Background] Saved widget data: ${habitsList.length} habits, ${habitsJson.length} characters');

        // Trigger widget UI refresh
        await HomeWidget.updateWidget(
          name: 'HabitTimelineWidgetProvider',
          androidName: 'HabitTimelineWidgetProvider',
        );

        await HomeWidget.updateWidget(
          name: 'HabitCompactWidgetProvider',
          androidName: 'HabitCompactWidgetProvider',
        );

        debugPrint(
            '✅ [Background] Widget update completed successfully for task: $task');

        return Future.value(true);
      } else {
        debugPrint('⚠️ [Background] Unknown task type: $task');
        return Future.value(false);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ [Background] Error updating widgets: $e');
      debugPrint('❌ [Background] Stack trace: $stackTrace');
      return Future.value(false);
    }
  });
}

/// Handle alarm completion in background
///
/// This function processes alarm completions that were triggered from AlarmActionReceiver.
/// It reads the habit ID from inputData, completes the habit in Isar, and updates widgets.
@pragma('vm:entry-point')
Future<bool> _handleAlarmCompletion(Map<String, dynamic>? inputData) async {
  try {
    debugPrint('🔔 [Background] Processing alarm completion');
    debugPrint('🔔 [Background] Input data: $inputData');

    if (inputData == null) {
      debugPrint('❌ [Background] No input data provided for alarm completion');
      return false;
    }

    // Extract habitId and habitName from inputData
    // The data comes from AlarmActionReceiver as a JSON string
    String? habitId;
    String? habitName;

    // Try to get data directly from inputData map
    if (inputData.containsKey('habitId')) {
      habitId = inputData['habitId'] as String?;
      habitName = inputData['habitName'] as String?;
    } else {
      // Data might be in a nested structure from Workmanager
      debugPrint('🔔 [Background] Trying to parse nested data structure');
      for (var key in inputData.keys) {
        debugPrint('🔔 [Background] Key: $key, Value: ${inputData[key]}');
      }

      // Workmanager might pass data in different formats
      if (inputData.containsKey('habitId')) {
        habitId = inputData['habitId'] as String?;
      }
      if (inputData.containsKey('habitName')) {
        habitName = inputData['habitName'] as String?;
      }
    }

    if (habitId == null) {
      debugPrint('❌ [Background] No habitId in alarm completion data');
      debugPrint('❌ [Background] Available keys: ${inputData.keys.join(', ')}');
      return false;
    }

    debugPrint('🔔 [Background] Completing habit: $habitName (ID: $habitId)');

    // Initialize Isar in the background isolate
    final isar = await IsarDatabaseService.getInstance();
    final habitService = HabitServiceIsar(isar);

    // Get the habit
    final habit = await habitService.getHabitById(habitId);

    if (habit == null) {
      debugPrint('❌ [Background] Habit not found: $habitId');
      return false;
    }

    // Complete the habit for now
    final completionTime = DateTime.now();
    await habitService.markHabitComplete(habitId, completionTime);

    debugPrint(
        '✅ [Background] Habit completed: ${habit.name} (Streak: ${habit.currentStreak})');

    // Update widgets with fresh data
    final allHabits = await habitService.getAllHabits();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Filter habits for today
    final todayHabits = allHabits.where((habit) {
      return _shouldShowHabitOnDate(habit, today);
    }).toList();

    // Sort habits chronologically by time (same as foreground service)
    todayHabits
        .sort((a, b) => _getHabitSortTime(a).compareTo(_getHabitSortTime(b)));

    // Convert habits to JSON
    final habitsList = todayHabits.map((h) => _habitToJson(h, today)).toList();
    final habitsJson = jsonEncode(habitsList);

    // Save to SharedPreferences via home_widget
    await HomeWidget.saveWidgetData<String>('habits', habitsJson);
    await HomeWidget.saveWidgetData<String>('today_habits', habitsJson);
    await HomeWidget.saveWidgetData<int>(
      'lastUpdate',
      DateTime.now().millisecondsSinceEpoch,
    );

    debugPrint('✅ [Background] Widget data updated after alarm completion');

    // Trigger widget UI refresh
    await HomeWidget.updateWidget(
      name: 'HabitTimelineWidgetProvider',
      androidName: 'HabitTimelineWidgetProvider',
    );

    await HomeWidget.updateWidget(
      name: 'HabitCompactWidgetProvider',
      androidName: 'HabitCompactWidgetProvider',
    );

    debugPrint('✅ [Background] Alarm completion processed successfully');

    return true;
  } catch (e, stackTrace) {
    debugPrint('❌ [Background] Error processing alarm completion: $e');
    debugPrint('❌ [Background] Stack trace: $stackTrace');
    return false;
  }
}

/// Check if a habit should be shown on a specific date
bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
  if (!habit.isActive) return false;

  // CRITICAL: Check if habit uses RRule system first
  // Many habits use RRule for scheduling, and we must respect that
  if (habit.usesRRule && habit.rruleString != null) {
    return RRuleService.isDueOnDate(
      rruleString: habit.rruleString!,
      startDate: habit.dtStart ?? habit.createdAt,
      checkDate: date,
    );
  }

  // Legacy frequency-based logic for old habits
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
      // FIXED: Check if today matches any of the yearly dates
      // Previously this always returned true, causing yearly habits to show every day!
      return habit.selectedYearlyDates.any((yearlyDateString) {
        try {
          final yearlyDate = DateTime.parse(yearlyDateString);
          return date.month == yearlyDate.month && date.day == yearlyDate.day;
        } catch (e) {
          return false;
        }
      });
  }
}

/// Convert habit to JSON for widget consumption
/// CRITICAL: Must match widget_integration_service.dart exactly for consistency
Map<String, dynamic> _habitToJson(Habit habit, DateTime date) {
  final isCompleted = _isHabitCompletedOnDate(habit, date);
  final status = _getHabitStatus(habit, date);
  final timeDisplay = _getHabitTimeDisplay(habit);

  final json = <String, dynamic>{
    'id': habit.id,
    'name': habit.name,
    'category': habit.category,
    'colorValue': habit.colorValue,
    'isCompleted': isCompleted,
    'status': status,
    'timeDisplay': timeDisplay,
    'frequency': habit.frequency.toString(),
  };

  // For hourly habits, include detailed time slot information
  // This matches the foreground service implementation exactly
  if (habit.frequency == HabitFrequency.hourly &&
      habit.hourlyTimes.isNotEmpty) {
    final timeSlots = <Map<String, dynamic>>[];

    for (final timeStr in habit.hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length == 2) {
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);

        if (hour != null && minute != null) {
          // Check if this specific time slot is completed
          final isSlotCompleted =
              _isHourlySlotCompleted(habit, date, hour, minute);

          timeSlots.add({
            'time': timeStr,
            'hour': hour,
            'minute': minute,
            'isCompleted': isSlotCompleted,
          });
        }
      }
    }

    json['hourlySlots'] = timeSlots;
    json['completedSlots'] =
        timeSlots.where((slot) => slot['isCompleted'] == true).length;
    json['totalSlots'] = timeSlots.length;

    // Override isCompleted for hourly habits - only true if ALL slots are completed
    json['isCompleted'] = json['completedSlots'] == json['totalSlots'];
  }

  return json;
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

/// Get time display for habit
/// CRITICAL: Must match widget_integration_service.dart exactly
String _getHabitTimeDisplay(Habit habit) {
  switch (habit.frequency) {
    case HabitFrequency.hourly:
      if (habit.hourlyTimes.isNotEmpty) {
        // For hourly habits, show the next upcoming time or current time
        final now = DateTime.now();

        // Find the next time that hasn't passed yet
        String? nextTime;
        for (final timeStr in habit.hourlyTimes) {
          final timeParts = timeStr.split(':');
          final habitHour = int.parse(timeParts[0]);
          final habitMinute = int.parse(timeParts[1]);
          final habitDateTime =
              DateTime(now.year, now.month, now.day, habitHour, habitMinute);

          if (habitDateTime.isAfter(now) ||
              habitDateTime.isAtSameMomentAs(DateTime(
                  now.year, now.month, now.day, now.hour, now.minute))) {
            nextTime = timeStr;
            break;
          }
        }

        if (nextTime != null) {
          // Show next time with indicator of additional times
          if (habit.hourlyTimes.length == 1) {
            return nextTime;
          } else {
            return '$nextTime (+${habit.hourlyTimes.length - 1})';
          }
        } else {
          // All times have passed, show first time for tomorrow
          if (habit.hourlyTimes.length == 1) {
            return '${habit.hourlyTimes.first} (tomorrow)';
          } else {
            return '${habit.hourlyTimes.first} (+${habit.hourlyTimes.length - 1})';
          }
        }
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
      if (habit.singleDateTime != null) {
        final time = habit.singleDateTime!;
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      }
      return 'Single';
  }
}

/// Get the sort time for a habit (for chronological ordering)
DateTime _getHabitSortTime(Habit habit) {
  // Handle single habits with specific date/time
  if (habit.singleDateTime != null) {
    return habit.singleDateTime!;
  }

  // Handle hourly habits with multiple times
  if (habit.frequency == HabitFrequency.hourly &&
      habit.hourlyTimes.isNotEmpty) {
    // Use the earliest time from hourly times for sorting
    final earliestTime = habit.hourlyTimes.first;
    final timeParts = earliestTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // Handle recurring habits with notification time
  if (habit.notificationTime != null) {
    // Create a DateTime with today's date and the habit's notification time
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      habit.notificationTime!.hour,
      habit.notificationTime!.minute,
    );
  }

  // If no time is set, put it at the end of the day
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 23, 59);
}

/// Get habit status for a date
String _getHabitStatus(Habit habit, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selectedDay = DateTime(date.year, date.month, date.day);

  if (_isHabitCompletedOnDate(habit, date)) {
    return 'Completed';
  }

  if (selectedDay.isBefore(today)) {
    return 'Missed';
  } else if (selectedDay.isAfter(today)) {
    return 'Upcoming';
  } else {
    return 'Due';
  }
}

/// Check if a specific hourly slot is completed
bool _isHourlySlotCompleted(Habit habit, DateTime date, int hour, int minute) {
  return habit.completions.any((completion) {
    return completion.year == date.year &&
        completion.month == date.month &&
        completion.day == date.day &&
        completion.hour == hour;
    // Note: We only check hour, not minute, because completions are recorded per hour
  });
}
