import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:home_widget/home_widget.      // Open Isar database with application support directory
      final dir = await getApplicationDocumentsDirectory();
      debugPrint('📂 Opening Isar database from: ${dir.path}');
      
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
import 'package:path_provider/path_provider.dart';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';
import 'rrule_service.dart';
import 'dart:convert';

/// Background service for updating widgets when app is closed
/// Uses WorkManager to run headless Dart code independently
/// 
/// This service ensures widgets update at 5 AM daily with fresh habit data,
/// even if the app hasn't been opened. Works alongside the existing
/// 15-minute WidgetUpdateWorker for frequent notification-triggered updates.
class WidgetBackgroundService {
  static const String _taskName = 'widgetBackgroundUpdate';
  static const String _uniqueName = 'widgetDailyUpdate';

  /// Initialize background widget update service
  /// Called once in main.dart
  static Future<void> initialize() async {
    try {
      debugPrint('🔧 Initializing Widget Background Service...');

      // Initialize WorkManager with callback dispatcher
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true, // Set to false in production builds
      );

      // Register daily task for morning updates at 5 AM
      await scheduleDailyUpdate();

      debugPrint('✅ Widget background service initialized successfully');
      debugPrint('📅 Daily updates scheduled for 5:00 AM');
    } catch (e) {
      debugPrint('❌ Error initializing widget background service: $e');
    }
  }

  /// Schedule daily widget update for 5:00 AM local time
  /// This ensures widgets show fresh habit data each morning
  static Future<void> scheduleDailyUpdate() async {
    try {
      final now = DateTime.now();
      
      // Calculate next 5 AM
      final nextRun = DateTime(now.year, now.month, now.day, 5, 0, 0);
      final initialDelay = nextRun.isAfter(now)
          ? nextRun.difference(now)
          : nextRun.add(const Duration(days: 1)).difference(now);

      debugPrint('⏰ Next widget update scheduled for: ${nextRun.isAfter(now) ? nextRun : nextRun.add(const Duration(days: 1))}');

      // Register periodic task (every 24 hours starting at 5 AM)
      await Workmanager().registerPeriodicTask(
        _uniqueName,
        _taskName,
        frequency: const Duration(hours: 24),
        initialDelay: initialDelay,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 5),
      );

      debugPrint('✅ Daily widget update scheduled (5 AM, every 24 hours)');
    } catch (e) {
      debugPrint('❌ Error scheduling daily widget update: $e');
    }
  }

  /// Cancel scheduled updates
  static Future<void> cancelScheduledUpdates() async {
    try {
      await Workmanager().cancelByUniqueName(_uniqueName);
      debugPrint('🔕 Widget background updates cancelled');
    } catch (e) {
      debugPrint('⚠️ Error cancelling widget updates: $e');
    }
  }

  /// Trigger immediate widget update (for testing)
  /// This allows testing the background update without waiting for 5 AM
  static Future<void> triggerImmediateUpdate() async {
    try {
      await Workmanager().registerOneOffTask(
        'immediateWidgetUpdate',
        _taskName,
        initialDelay: const Duration(seconds: 5),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
        ),
      );
      debugPrint('🧪 Immediate widget update triggered (5 seconds)');
    } catch (e) {
      debugPrint('❌ Error triggering immediate update: $e');
    }
  }
}

/// Top-level callback dispatcher for WorkManager
/// CRITICAL: Must be a top-level function, not a class method
/// This function runs in a separate isolate and can execute even when app is closed
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final startTime = DateTime.now();
    debugPrint('🔄 [$startTime] Widget background task started: $taskName');

    try {
      // Initialize Flutter bindings for background execution
      WidgetsFlutterBinding.ensureInitialized();

      // Set app group ID for iOS widget data sharing
      // (Not critical for Android but good practice for cross-platform)
      try {
        await HomeWidget.setAppGroupId('group.com.habittracker.habitv8.widget');
      } catch (e) {
        debugPrint('⚠️ HomeWidget setAppGroupId warning: $e');
      }

      // Open Isar database with application support directory
      final dir = await getApplicationSupportDirectory();
      debugPrint('📂 Opening Isar database from: ${dir.path}');
      
      final isar = await IsarDatabaseService.getInstanceWithPath(dir.path);
      final habitService = HabitServiceIsar(isar);

      // Fetch all habits from database
      final habits = await habitService.getAllHabits();
      final activeHabits = habits.where((h) => h.isActive).toList();

      debugPrint('📊 Fetched ${habits.length} total habits (${activeHabits.length} active) from Isar');

      // Filter habits for today
      final today = DateTime.now();
      final todayHabits = _filterHabitsForToday(activeHabits, today);

      debugPrint('📅 Filtered to ${todayHabits.length} habits scheduled for today');

      // Prepare widget data as JSON
      final habitsJson = jsonEncode(
        todayHabits.map((h) => _habitToWidgetJson(h, today)).toList(),
      );

      debugPrint('💾 Saving widget data (${habitsJson.length} characters)...');

      // Save to HomeWidget preferences (SharedPreferences)
      // This is where WidgetUpdateWorker reads from
      await HomeWidget.saveWidgetData('habits', habitsJson);
      await HomeWidget.saveWidgetData('today_habits', habitsJson);
      await HomeWidget.saveWidgetData('habits_data', habitsJson);
      await HomeWidget.saveWidgetData('habit_count', activeHabits.length);
      await HomeWidget.saveWidgetData('today_habit_count', todayHabits.length);
      await HomeWidget.saveWidgetData(
        'last_update',
        DateTime.now().toIso8601String(),
      );

      debugPrint('✅ Widget data saved to SharedPreferences');

      // Trigger widget UI update
      await HomeWidget.updateWidget(
        name: 'HabitTimelineWidgetProvider',
        androidName: 'HabitTimelineWidgetProvider',
      );
      await HomeWidget.updateWidget(
        name: 'HabitCompactWidgetProvider',
        androidName: 'HabitCompactWidgetProvider',
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      debugPrint('✅ Widget background update completed in ${duration.inMilliseconds}ms');

      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('❌ Error in widget background task: $e');
      debugPrint('Stack trace: $stackTrace');
      return Future.value(false);
    }
  });
}

/// Filter habits for a specific date (using RRule or legacy logic)
/// Supports both the new RRule system and legacy frequency patterns
List<Habit> _filterHabitsForToday(List<Habit> habits, DateTime date) {
  return habits.where((habit) {
    try {
      // Use RRule if available (new system)
      if (habit.usesRRule && habit.rruleString != null) {
        return RRuleService.isDueOnDate(habit, date);
      }

      // Legacy frequency logic (fallback for habits not yet migrated)
      final dateOnly = DateTime(date.year, date.month, date.day);

      switch (habit.frequency) {
        case HabitFrequency.daily:
          return true;

        case HabitFrequency.weekly:
          final dayOfWeek = date.weekday % 7; // 0 = Sunday
          return habit.selectedWeekdays.contains(dayOfWeek);

        case HabitFrequency.monthly:
          return habit.selectedMonthDays.contains(date.day);

        case HabitFrequency.yearly:
          return habit.selectedYearlyDates.any((yearlyDate) {
            return yearlyDate.month == date.month &&
                yearlyDate.day == date.day;
          });

        case HabitFrequency.hourly:
          return habit.hourlyTimes.isNotEmpty;

        case HabitFrequency.single:
          if (habit.singleDateTime != null) {
            final singleDateOnly = DateTime(
              habit.singleDateTime!.year,
              habit.singleDateTime!.month,
              habit.singleDateTime!.day,
            );
            return singleDateOnly == dateOnly;
          }
          return false;

        default:
          return false;
      }
    } catch (e) {
      debugPrint('⚠️ Error filtering habit ${habit.name} for date: $e');
      return false;
    }
  }).toList();
}

/// Convert Habit to widget-compatible JSON
/// This mirrors the format expected by Android widget providers
Map<String, dynamic> _habitToWidgetJson(Habit habit, DateTime date) {
  // Check if habit is completed today
  final isCompleted = habit.completionDates.any((completionDate) {
    return completionDate.year == date.year &&
        completionDate.month == date.month &&
        completionDate.day == date.day;
  });

  return {
    'id': habit.id,
    'name': habit.name,
    'isActive': habit.isActive,
    'isCompleted': isCompleted,
    'frequency': habit.frequency.toString().split('.').last,
    'notificationTime': habit.notificationTime?.toIso8601String(),
    'selectedWeekdays': habit.selectedWeekdays,
    'selectedMonthDays': habit.selectedMonthDays,
    'selectedYearlyDates':
        habit.selectedYearlyDates.map((d) => d.toIso8601String()).toList(),
    'hourlyTimes': habit.hourlyTimes,
    'singleDateTime': habit.singleDateTime?.toIso8601String(),
    'difficulty': habit.difficulty.toString().split('.').last,
    'category': habit.category,
    'streakCount': habit.streakCount,
    'completionCount': habit.completionDates.length,
    'usesRRule': habit.usesRRule,
    'rruleString': habit.rruleString,
  };
}
