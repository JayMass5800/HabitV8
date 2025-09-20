import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import '../services/theme_service.dart';
import 'dart:convert';
import 'dart:ui' as ui;

/// Service to manage widget integration and updates
class WidgetIntegrationService {
  static const String _timelineWidgetName = 'HabitTimelineWidgetProvider';
  static const String _compactWidgetName = 'HabitCompactWidgetProvider';

  static WidgetIntegrationService? _instance;
  static WidgetIntegrationService get instance =>
      _instance ??= WidgetIntegrationService._();

  WidgetIntegrationService._();

  /// Initialize widget integration and set up background handlers
  Future<void> initialize() async {
    try {
      // Register background callback for widget interactions
      await HomeWidget.registerInteractivityCallback(_backgroundCallback);

      // Set initial widget data
      await updateAllWidgets();

      debugPrint('Widget integration initialized successfully');
    } catch (e) {
      debugPrint('Error initializing widget integration: $e');
    }
  }

  /// Update all widgets with current habit data
  Future<void> updateAllWidgets() async {
    try {
      final widgetData = await _prepareWidgetData();

      // Update timeline widget
      await _updateWidget(_timelineWidgetName, widgetData);

      // Update compact widget
      await _updateWidget(_compactWidgetName, widgetData);

      debugPrint('All widgets updated successfully');
    } catch (e) {
      debugPrint('Error updating widgets: $e');
    }
  }

  /// Update a specific widget with data
  Future<void> _updateWidget(
      String widgetName, Map<String, dynamic> data) async {
    try {
      debugPrint(
          'Updating widget $widgetName with data keys: ${data.keys.toList()}');

      // Set widget data
      for (final entry in data.entries) {
        await HomeWidget.saveWidgetData(entry.key, entry.value);
        debugPrint(
            'Saved ${entry.key}: ${entry.value.toString().length > 100 ? "${entry.value.toString().substring(0, 100)}..." : entry.value}');
      }

      // Small delay to ensure data is written to SharedPreferences
      await Future.delayed(const Duration(milliseconds: 100));

      // Update the widget
      await HomeWidget.updateWidget(
        name: widgetName,
        androidName: widgetName,
      );

      debugPrint('Widget $widgetName update completed');
    } catch (e) {
      debugPrint('Error updating widget $widgetName: $e');
    }
  }

  /// Prepare data for widget consumption
  Future<Map<String, dynamic>> _prepareWidgetData() async {
    try {
      final selectedDate = DateTime.now();

      // Get habit data - use database directly since WidgetService methods are private
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final allHabits = await habitService.getAllHabits();
      final habits = _filterHabitsForDate(allHabits, selectedDate);
      final nextHabit = _findNextHabit(allHabits);

      debugPrint(
          'Widget data preparation: Found ${allHabits.length} total habits, ${habits.length} for today');

      // Get theme data
      final themeData = await _getThemeData();

      // Convert habits to JSON for widget consumption
      final habitsWithStatus =
          await _enrichHabitsWithStatus(habits, selectedDate);
      final habitsJson = jsonEncode(
          habitsWithStatus.map((h) => _habitToJson(h, selectedDate)).toList());
      final nextHabitJson = nextHabit != null
          ? jsonEncode(_habitToJson(nextHabit, selectedDate))
          : null;

      debugPrint(
          'Widget data: habits JSON length: ${habitsJson.length}, theme: ${themeData['themeMode']}, primary: ${themeData['primaryColor']}');

      return {
        'habits': habitsJson,
        'nextHabit': nextHabitJson,
        'selectedDate': _formatDateForWidget(selectedDate),
        'themeMode': themeData['themeMode'],
        'primaryColor': themeData['primaryColor'],
        'lastUpdate': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      debugPrint('Error preparing widget data: $e');
      return {
        'habits': '[]',
        'nextHabit': null,
        'selectedDate': _formatDateForWidget(DateTime.now()),
        'themeMode': 'light',
        'primaryColor': 0x6366F1,
        'lastUpdate': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }

  /// Enrich habits with completion status for the given date
  Future<List<Habit>> _enrichHabitsWithStatus(
      List<Habit> habits, DateTime date) async {
    // Habits already contain completion data, just return them
    return habits;
  }

  /// Convert habit to JSON format for widget
  Map<String, dynamic> _habitToJson(Habit habit, DateTime date) {
    final isCompleted = _isHabitCompletedOnDate(habit, date);
    final status = _getHabitStatus(habit, date);
    final timeDisplay = _getHabitTimeDisplay(habit);

    return {
      'id': habit.id,
      'name': habit.name,
      'category': habit.category,
      'colorValue': habit.colorValue,
      'isCompleted': isCompleted,
      'status': status,
      'timeDisplay': timeDisplay,
      'frequency': habit.frequency.toString(),
    };
  }

  /// Get current theme data
  Future<Map<String, dynamic>> _getThemeData() async {
    try {
      final themeMode = await ThemeService.getThemeMode();
      final primaryColor = await ThemeService.getPrimaryColor();

      // Properly handle system theme mode by checking platform brightness
      String actualThemeMode;
      if (themeMode == ThemeMode.dark) {
        actualThemeMode = 'dark';
      } else if (themeMode == ThemeMode.light) {
        actualThemeMode = 'light';
      } else {
        // ThemeMode.system - check system brightness
        final brightness = ui.PlatformDispatcher.instance.platformBrightness;
        actualThemeMode = brightness == Brightness.dark ? 'dark' : 'light';
      }

      return {
        'themeMode': actualThemeMode,
        'primaryColor': primaryColor.value,
      };
    } catch (e) {
      debugPrint('Error getting theme data: $e');
      return {
        'themeMode': 'light',
        'primaryColor': 0x6366F1,
      };
    }
  }

  /// Format date for widget consumption
  String _formatDateForWidget(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Handle widget interactions from background
  static Future<void> _backgroundCallback(Uri? uri) async {
    try {
      if (uri == null) return;

      debugPrint('Widget background callback: $uri');

      final action = uri.host;
      final params = uri.queryParameters;

      switch (action) {
        case 'complete_habit':
          final habitId = params['habitId'];
          if (habitId != null) {
            await _handleCompleteHabit(habitId);
          }
          break;

        case 'refresh_widget':
          await _handleRefreshWidget();
          break;

        default:
          debugPrint('Unknown widget action: $action');
      }
    } catch (e) {
      debugPrint('Error handling widget callback: $e');
    }
  }

  /// Handle habit completion from widget
  static Future<void> _handleCompleteHabit(String habitId) async {
    try {
      debugPrint('Completing habit from widget: $habitId');

      // Get database service
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);

      // Load habit
      final habit = await habitService.getHabitById(habitId);
      if (habit == null) {
        debugPrint('Habit not found: $habitId');
        return;
      }

      // Add completion using the habit service
      await habitService.markHabitComplete(habitId, DateTime.now());

      // Update widgets with new data
      await instance.updateAllWidgets();

      debugPrint('Habit completed successfully from widget');
    } catch (e) {
      debugPrint('Error completing habit from widget: $e');
    }
  }

  /// Handle widget refresh request
  static Future<void> _handleRefreshWidget() async {
    try {
      debugPrint('Refreshing widgets');
      await instance.updateAllWidgets();
    } catch (e) {
      debugPrint('Error refreshing widgets: $e');
    }
  }

  /// Schedule periodic widget updates
  Future<void> schedulePeriodicUpdates() async {
    try {
      // Update widgets every 30 minutes
      await HomeWidget.updateWidget(
        name: _timelineWidgetName,
        androidName: _timelineWidgetName,
      );

      await HomeWidget.updateWidget(
        name: _compactWidgetName,
        androidName: _compactWidgetName,
      );
    } catch (e) {
      debugPrint('Error scheduling periodic updates: $e');
    }
  }

  /// Check if the app was launched from a widget
  Future<bool> wasLaunchedFromWidget() async {
    try {
      final launchData = await HomeWidget.initiallyLaunchedFromHomeWidget();
      return launchData != null;
    } catch (e) {
      debugPrint('Error checking widget launch: $e');
      return false;
    }
  }

  /// Get the data from widget launch
  Future<Map<String, dynamic>?> getWidgetLaunchData() async {
    try {
      final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (launchUri != null) {
        return launchUri.queryParameters;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting widget launch data: $e');
      return null;
    }
  }

  /// Handle app launch from widget with specific route
  Future<void> handleWidgetLaunch() async {
    try {
      final launchData = await getWidgetLaunchData();
      if (launchData != null) {
        final route = launchData['route'] as String?;
        if (route != null) {
          debugPrint('App launched from widget with route: $route');
          // Handle navigation to specific route
          // This would typically be handled by the main app's navigation system
        }
      }
    } catch (e) {
      debugPrint('Error handling widget launch: $e');
    }
  }

  /// Update widgets when habits change
  Future<void> onHabitsChanged() async {
    await updateAllWidgets();
  }

  /// Update widgets when theme changes
  Future<void> onThemeChanged() async {
    await updateAllWidgets();
  }

  /// Test method to expose data preparation for debugging
  Future<Map<String, dynamic>> testPrepareData() async {
    return await _prepareWidgetData();
  }

  /// Update widgets when a habit is completed
  Future<void> onHabitCompleted() async {
    await updateAllWidgets();
  }

  /// Filter habits for a specific date
  List<Habit> _filterHabitsForDate(List<Habit> habits, DateTime date) {
    final filtered =
        habits.where((habit) => _isHabitScheduledForDate(habit, date)).toList();

    debugPrint(
        'Filtering ${habits.length} habits for date ${_formatDateForWidget(date)}:');
    for (var habit in habits) {
      final isScheduled = _isHabitScheduledForDate(habit, date);
      debugPrint(
          '  - ${habit.name}: ${habit.frequency.toString()} -> ${isScheduled ? "INCLUDED" : "EXCLUDED"}');
    }
    debugPrint('Result: ${filtered.length} habits for today');

    // Sort habits chronologically by time
    filtered.sort((a, b) => _getHabitSortTime(a).compareTo(_getHabitSortTime(b)));

    return filtered;
  }

  /// Get habit sort time for chronological ordering
  DateTime _getHabitSortTime(Habit habit) {
    // Handle single habits with specific date/time
    if (habit.singleDateTime != null) {
      return habit.singleDateTime!;
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

  /// Check if habit is scheduled for a specific date
  bool _isHabitScheduledForDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        return habit.selectedWeekdays.contains(date.weekday);
      case HabitFrequency.monthly:
        return habit.monthlySchedule.contains(date.day);
      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final habitDate = DateTime(
            habit.singleDateTime!.year,
            habit.singleDateTime!.month,
            habit.singleDateTime!.day,
          );
          return habitDate
              .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
        }
        return false;
      case HabitFrequency.hourly:
        return true;
      default:
        return false;
    }
  }

  /// Find the next habit due
  Habit? _findNextHabit(List<Habit> habits) {
    final now = DateTime.now();
    Habit? nextHabit;
    DateTime? nextTime;

    for (final habit in habits) {
      if (_isHabitScheduledForDate(habit, now) &&
          !_isHabitCompletedToday(habit)) {
        final habitTime = _getHabitTime(habit);
        if (habitTime != null && habitTime.isAfter(now)) {
          if (nextTime == null || habitTime.isBefore(nextTime)) {
            nextTime = habitTime;
            nextHabit = habit;
          }
        }
      }
    }

    return nextHabit;
  }

  /// Get the next scheduled time for a habit
  DateTime? _getHabitTime(Habit habit) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (habit.frequency) {
      case HabitFrequency.single:
        return habit.singleDateTime;
      case HabitFrequency.hourly:
        // Find next hourly time
        for (final timeStr in habit.hourlyTimes) {
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);
            if (hour != null && minute != null) {
              final time = today.add(Duration(hours: hour, minutes: minute));
              if (time.isAfter(now)) {
                return time;
              }
            }
          }
        }
        return null;
      default:
        if (habit.notificationTime != null) {
          return today.add(Duration(
            hours: habit.notificationTime!.hour,
            minutes: habit.notificationTime!.minute,
          ));
        }
        return null;
    }
  }

  /// Check if habit is completed today
  bool _isHabitCompletedToday(Habit habit) {
    final today = DateTime.now();
    return _isHabitCompletedOnDate(habit, today);
  }

  /// Check if habit is completed on a specific date
  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completion) {
      final completionDate =
          DateTime(completion.year, completion.month, completion.day);
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
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

  /// Get time display for habit
  String _getHabitTimeDisplay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          if (habit.hourlyTimes.length == 1) {
            return habit.hourlyTimes.first;
          } else {
            return '${habit.hourlyTimes.first} +${habit.hourlyTimes.length - 1}';
          }
        }
        return 'Hourly';

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final hour = habit.singleDateTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.singleDateTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';

      default:
        if (habit.notificationTime != null) {
          final hour = habit.notificationTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.notificationTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';
    }
  }
}
