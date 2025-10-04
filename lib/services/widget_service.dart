import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'theme_service.dart';
import 'logging_service.dart';
import 'rrule_service.dart';
import 'package:intl/intl.dart';

class WidgetService {
  static const String _groupId = 'group.com.habittracker.habitv8.widget';
  static const String _widgetName = 'HabitTimelineWidget';
  static const String _lastUpdateKey = 'widget_last_update';
  static const String _habitsDataKey = 'habits_data';

  /// Initialize the widget service
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(_groupId);
      AppLogger.info('Widget service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize widget service', e);
    }
  }

  /// Update widget data with current habits for the selected date
  static Future<void> updateWidgetData({
    DateTime? selectedDate,
    List<Habit>? habits,
  }) async {
    try {
      final date = selectedDate ?? DateTime.now();
      List<Habit> habitsToUse = habits ?? [];

      // If no habits provided, we'll need to get them from the database
      if (habitsToUse.isEmpty) {
        try {
          final habitBox = await DatabaseService.getInstance();
          final habitService = HabitService(habitBox);
          habitsToUse = await habitService.getAllHabits();
        } catch (e) {
          AppLogger.error('Failed to get habits from database for widget', e);
          habitsToUse = [];
        }
      }

      // Filter habits for the selected date
      final relevantHabits = _getHabitsForDate(habitsToUse, date);

      // Get current time and next habit
      final now = DateTime.now();
      final nextHabit = _findNextHabit(relevantHabits, now);

      // Get theme information
      final themeMode = await ThemeService.getThemeMode();
      final primaryColor = await ThemeService.getPrimaryColor();

      // Prepare widget data
      final widgetData = {
        'habits': relevantHabits
            .map((habit) => _habitToWidgetMap(habit, date))
            .toList(),
        'currentTime': now.millisecondsSinceEpoch,
        'selectedDate': date.millisecondsSinceEpoch,
        'nextHabit':
            nextHabit != null ? _habitToWidgetMap(nextHabit, date) : null,
        'themeMode': themeMode.name,
        'primaryColor': primaryColor.toARGB32(),
        'lastUpdate': DateTime.now().millisecondsSinceEpoch,
      };

      // Store data for widget access
      await HomeWidget.saveWidgetData<String>(
        _habitsDataKey,
        jsonEncode(widgetData),
      );

      // Update widget UI
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
        iOSName: _widgetName,
      );

      // Save last update timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);

      AppLogger.info(
          'Widget data updated successfully for ${relevantHabits.length} habits');
    } catch (e) {
      AppLogger.error('Failed to update widget data', e);
    }
  }

  /// Get habits relevant for the specified date
  static List<Habit> _getHabitsForDate(List<Habit> allHabits, DateTime date) {
    final relevantHabits = <Habit>[];
    final dateOnly = DateTime(date.year, date.month, date.day);

    for (final habit in allHabits) {
      if (_isHabitActiveOnDate(habit, dateOnly)) {
        relevantHabits.add(habit);
      }
    }

    // Sort habits by time (prioritize those with specific times)
    relevantHabits.sort((a, b) {
      final aTime = _getHabitTimeOfDay(a);
      final bTime = _getHabitTimeOfDay(b);

      if (aTime != null && bTime != null) {
        final aMinutes = aTime.hour * 60 + aTime.minute;
        final bMinutes = bTime.hour * 60 + bTime.minute;
        return aMinutes.compareTo(bMinutes);
      } else if (aTime != null) {
        return -1; // Habits with time come first
      } else if (bTime != null) {
        return 1;
      } else {
        return a.name.compareTo(b.name); // Alphabetical for habits without time
      }
    });

    return relevantHabits;
  }

  /// Check if habit is active/relevant for the specified date
  static bool _isHabitActiveOnDate(Habit habit, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If habit uses RRule, delegate to RRuleService
    if (habit.isRRuleBased()) {
      final rruleString = habit.rruleString;
      final startDate = habit.dtStart ?? habit.createdAt;

      if (rruleString != null) {
        return RRuleService.isDueOnDate(
          rruleString: rruleString,
          startDate: startDate,
          checkDate: date,
        );
      }
    }

    // Check if habit uses RRule system
    if (habit.usesRRule && habit.rruleString != null) {
      return RRuleService.isDueOnDate(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        checkDate: date,
      );
    }

    // Legacy frequency-based logic for old habits
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true; // Daily habits are always relevant

      case HabitFrequency.weekly:
        final habitWeekday = habit.selectedWeekdays.isNotEmpty
            ? habit.selectedWeekdays.first
            : DateTime.sunday;
        return date.weekday == habitWeekday;

      case HabitFrequency.monthly:
        final habitDay = habit.selectedMonthDays.isNotEmpty
            ? habit.selectedMonthDays.first
            : 1;
        return date.day == habitDay;

      case HabitFrequency.yearly:
        return habit.selectedYearlyDates.any((yearlyDateString) {
          try {
            final yearlyDate = DateTime.parse(yearlyDateString);
            return date.month == yearlyDate.month && date.day == yearlyDate.day;
          } catch (e) {
            return false;
          }
        });

      case HabitFrequency.hourly:
        return date.isAtSameMomentAs(today) || date.isAfter(today);

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final habitDate = DateTime(
            habit.singleDateTime!.year,
            habit.singleDateTime!.month,
            habit.singleDateTime!.day,
          );
          return date.isAtSameMomentAs(habitDate);
        }
        return false;
    }
  }

  /// Find the next upcoming habit based on current time
  static Habit? _findNextHabit(List<Habit> habits, DateTime currentTime) {
    final now = TimeOfDay.fromDateTime(currentTime);
    final currentMinutes = now.hour * 60 + now.minute;

    Habit? nextHabit;
    int closestTimeDiff = 24 * 60; // Maximum difference (24 hours)

    for (final habit in habits) {
      final habitTime = _getHabitTimeOfDay(habit);
      if (habitTime != null) {
        final habitMinutes = habitTime.hour * 60 + habitTime.minute;

        // Calculate time difference (considering next day)
        int timeDiff = habitMinutes - currentMinutes;
        if (timeDiff <= 0) {
          timeDiff += 24 * 60; // Next day
        }

        if (timeDiff < closestTimeDiff) {
          closestTimeDiff = timeDiff;
          nextHabit = habit;
        }
      }
    }

    return nextHabit;
  }

  /// Get the primary time of day for a habit
  static TimeOfDay? _getHabitTimeOfDay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          final timeString = habit.hourlyTimes.first;
          final parts = timeString.split(':');
          if (parts.length == 2) {
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        }
        return null;

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          return TimeOfDay.fromDateTime(habit.singleDateTime!);
        }
        return null;

      default:
        if (habit.notificationTime != null) {
          return TimeOfDay.fromDateTime(habit.notificationTime!);
        }
        return null;
    }
  }

  /// Convert habit to widget-friendly map
  static Map<String, dynamic> _habitToWidgetMap(
      Habit habit, DateTime selectedDate) {
    final isCompleted = _isHabitCompletedOnDate(habit, selectedDate);
    final status = _getHabitStatus(habit, selectedDate);
    final timeDisplay = _getHabitTimeDisplay(habit);

    return {
      'id': habit.id,
      'name': habit.name,
      'description': habit.description ?? '',
      'category': habit.category,
      'colorValue': habit.colorValue,
      'isCompleted': isCompleted,
      'status': status,
      'timeDisplay': timeDisplay,
      'frequency': habit.frequency.name,
      'canComplete': status == 'Due' && !isCompleted,
    };
  }

  /// Check if habit is completed on specified date
  static bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
  }

  /// Get habit status for the specified date
  static String _getHabitStatus(Habit habit, DateTime date) {
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

  /// Get display time for habit
  static String _getHabitTimeDisplay(Habit habit) {
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
          return DateFormat('HH:mm').format(habit.singleDateTime!);
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

  /// Handle widget interactions (habit completion, navigation)
  static Future<void> handleWidgetInteraction(
      String action, Map<String, dynamic> data) async {
    try {
      AppLogger.info('Handling widget interaction: $action');

      switch (action) {
        case 'complete_habit':
          await _handleHabitCompletion(data);
          break;
        case 'open_timeline':
          await _openApp('/timeline');
          break;
        case 'open_create_habit':
          await _openApp('/create-habit-v2');
          break;
        case 'open_edit_habit':
          final habitId = data['habitId'] as String?;
          if (habitId != null) {
            await _openApp('/edit-habit/$habitId');
          }
          break;
        case 'refresh_widget':
          await updateWidgetData();
          break;
        default:
          await _openApp('/timeline');
      }
    } catch (e) {
      AppLogger.error('Failed to handle widget interaction', e);
    }
  }

  /// Handle habit completion from widget
  static Future<void> _handleHabitCompletion(Map<String, dynamic> data) async {
    try {
      final habitId = data['habitId'] as String?;
      if (habitId == null) return;

      // We'll need to trigger app to handle completion
      // For now, just update widget and open app
      await _openApp('/timeline?completeHabit=$habitId');
    } catch (e) {
      AppLogger.error('Failed to complete habit from widget', e);
    }
  }

  /// Open the main app with specific route
  static Future<void> _openApp(String route) async {
    try {
      // Store the route to navigate to when app opens
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('widget_navigation_route', route);

      // Launch the app - use a different approach since launchApp may not exist
      await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (e) {
      AppLogger.error('Failed to open app from widget', e);
    }
  }

  /// Get pending navigation route from widget
  static Future<String?> getPendingNavigationRoute() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final route = prefs.getString('widget_navigation_route');
      if (route != null) {
        await prefs.remove('widget_navigation_route');
      }
      return route;
    } catch (e) {
      AppLogger.error('Failed to get pending navigation route', e);
      return null;
    }
  }

  /// Register widget update callbacks
  static Future<void> registerUpdateCallbacks() async {
    try {
      // HomeWidget callbacks setup would go here if supported
      AppLogger.info('Widget update callbacks setup attempted');
    } catch (e) {
      AppLogger.error('Failed to register widget callbacks', e);
    }
  }

  /// Get last widget update time
  static Future<DateTime?> getLastUpdateTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastUpdateKey);
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      AppLogger.error('Failed to get last update time', e);
      return null;
    }
  }

  /// Check if widget needs update (based on time threshold)
  static Future<bool> needsUpdate(
      {Duration threshold = const Duration(minutes: 15)}) async {
    try {
      final lastUpdate = await getLastUpdateTime();
      if (lastUpdate == null) return true;

      return DateTime.now().difference(lastUpdate) > threshold;
    } catch (e) {
      AppLogger.error('Failed to check if widget needs update', e);
      return true;
    }
  }

  /// Clear all widget data
  static Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData<String>(_habitsDataKey, '{}');
      await HomeWidget.updateWidget(name: _widgetName);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdateKey);

      AppLogger.info('Widget data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear widget data', e);
    }
  }
}
