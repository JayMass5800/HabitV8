import 'package:flutter/material.dart';
import '../domain/model/habit.dart';
import '../services/rrule_service.dart';
import '../services/time_service.dart';

/// Shared utility functions for habit display across screens and widgets.
///
/// This class centralizes common helper functions that were previously
/// duplicated across multiple files including:
/// - timeline_screen.dart
/// - calendar_screen.dart
/// - all_habits_screen.dart
/// - widget_timeline_view.dart
/// - day_detail_sheet.dart
/// - widget_integration_service.dart
/// - widget_background_update_service.dart
///
/// Usage: Import and call static methods directly.
/// Example: HabitDisplayUtils.isHabitCompletedOnDate(habit, date)
class HabitDisplayUtils {
  static final TimeService _time = TimeService.instance;

  // Prevent instantiation
  HabitDisplayUtils._();

  // ============================================================================
  // COMPLETION STATUS CHECKS
  // ============================================================================

  /// Check if a habit is completed on a specific date.
  ///
  /// Compares only the date portion (ignoring time) to determine if
  /// any completion entry exists for the given date.
  static bool isHabitCompletedOnDate(Habit habit, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate == dateOnly;
    });
  }

  /// Check if a specific hourly slot is completed.
  ///
  /// For hourly habits, checks if there's a completion entry that matches
  /// both the date AND the specific hour:minute combination.
  static bool isHourlySlotCompleted(
    Habit habit,
    DateTime date,
    int hour,
    int minute,
  ) {
    return habit.completions.any((completion) {
      return completion.year == date.year &&
          completion.month == date.month &&
          completion.day == date.day &&
          completion.hour == hour &&
          completion.minute == minute;
    });
  }

  /// Check if an hourly habit has been completed at a specific time string.
  ///
  /// [timeSlot] should be in "HH:mm" format (e.g., "09:00", "14:30").
  static bool isHourlyHabitCompletedAtTime(
    Habit habit,
    DateTime date,
    String timeSlot,
  ) {
    final parts = timeSlot.split(':');
    if (parts.length != 2) return false;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return false;

    return isHourlySlotCompleted(habit, date, hour, minute);
  }

  // ============================================================================
  // HABIT DUE DATE CHECKS
  // ============================================================================

  /// Check if a habit is due/scheduled on a specific date.
  ///
  /// Handles both RRule-based habits and legacy frequency-based habits.
  /// Takes into account the habit's creation date (habits aren't due before creation).
  static bool isHabitDueOnDate(Habit habit, DateTime date) {
    if (!habit.isActive) return false;

    // Don't show habits before their creation date
    final createdAt = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );
    final checkDate = DateTime(date.year, date.month, date.day);
    if (checkDate.isBefore(createdAt)) return false;

    // Use RRule if available
    if (habit.usesRRule && habit.rruleString != null) {
      return RRuleService.isDueOnDate(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        checkDate: date,
      );
    }

    // Legacy frequency-based logic
    return _isLegacyHabitDueOnDate(habit, date);
  }

  /// Legacy frequency-based due date check.
  static bool _isLegacyHabitDueOnDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;

      case HabitFrequency.weekly:
        if (habit.selectedWeekdays.isEmpty) return false;
        // Support both Sunday=0 and Sunday=7 conventions
        final weekday = date.weekday % 7;
        return habit.selectedWeekdays.contains(weekday) ||
            habit.selectedWeekdays.contains(date.weekday);

      case HabitFrequency.monthly:
        if (habit.selectedMonthDays.isEmpty) return false;
        return habit.selectedMonthDays.contains(date.day);

      case HabitFrequency.yearly:
        if (habit.selectedYearlyDates.isEmpty) return false;
        return habit.selectedYearlyDates.any((dateStr) {
          try {
            final parts = dateStr.split('-');
            if (parts.length >= 3) {
              final month = int.parse(parts[1]);
              final day = int.parse(parts[2]);
              return date.month == month && date.day == day;
            }
          } catch (_) {}
          return false;
        });

      case HabitFrequency.hourly:
        return true; // Hourly habits are shown every day

      case HabitFrequency.single:
        if (habit.singleDateTime == null) return false;
        final singleDate = habit.singleDateTime!;
        return date.year == singleDate.year &&
            date.month == singleDate.month &&
            date.day == singleDate.day;
    }
  }

  // ============================================================================
  // HABIT STATUS
  // ============================================================================

  /// Possible habit status values.
  static const String statusCompleted = 'Completed';
  static const String statusMissed = 'Missed';
  static const String statusDue = 'Due';
  static const String statusUpcoming = 'Upcoming';
  static const String statusPartial = 'Partial';
  static const String statusPending = 'Pending';

  /// Get the status of a habit on a specific date.
  ///
  /// Returns one of: 'Completed', 'Missed', 'Due', 'Upcoming'.
  static String getHabitStatus(Habit habit, DateTime date) {
    final now = _time.nowLocal();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (isHabitCompletedOnDate(habit, date)) {
      return statusCompleted;
    }

    if (selectedDay.isBefore(today)) {
      return statusMissed;
    } else if (selectedDay.isAfter(today)) {
      return statusUpcoming;
    } else {
      return statusDue;
    }
  }

  /// Get the status of an hourly habit on a specific date.
  ///
  /// Returns 'Completed' if all slots are done, 'Partial' if some are done,
  /// 'Pending' otherwise.
  static String getHourlyHabitStatus(Habit habit, DateTime date) {
    if (habit.hourlyTimes.isEmpty) return statusPending;

    int completedCount = 0;
    for (final time in habit.hourlyTimes) {
      if (isHourlyHabitCompletedAtTime(habit, date, time)) {
        completedCount++;
      }
    }

    if (completedCount == habit.hourlyTimes.length) {
      return statusCompleted;
    } else if (completedCount > 0) {
      return statusPartial;
    }
    return statusPending;
  }

  /// Get status color based on status string.
  ///
  /// Returns appropriate color for light/dark mode based on [isDarkMode].
  static Color getStatusColor(String status, {required bool isDarkMode}) {
    switch (status) {
      case statusCompleted:
        return isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32);
      case statusMissed:
        return isDarkMode ? const Color(0xFFE57373) : const Color(0xFFC62828);
      case statusDue:
      case statusPending:
        return isDarkMode ? const Color(0xFFFFB74D) : const Color(0xFFE65100);
      case statusUpcoming:
        return isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1565C0);
      case statusPartial:
        return isDarkMode ? const Color(0xFFFFD54F) : const Color(0xFFF57C00);
      default:
        return isDarkMode ? const Color(0xFF9E9E9E) : const Color(0xFF424242);
    }
  }

  // ============================================================================
  // CATEGORY ICONS
  // ============================================================================

  /// Get the icon for a habit category.
  ///
  /// Returns appropriate IconData for common category names.
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'fitness':
      case 'exercise':
        return Icons.fitness_center;
      case 'productivity':
        return Icons.trending_up;
      case 'learning':
      case 'education':
        return Icons.school;
      case 'mindfulness':
      case 'meditation':
        return Icons.self_improvement;
      case 'social':
        return Icons.people;
      case 'finance':
      case 'money':
        return Icons.attach_money;
      case 'creativity':
      case 'art':
        return Icons.palette;
      case 'reading':
        return Icons.book;
      case 'writing':
        return Icons.edit;
      case 'music':
        return Icons.music_note;
      case 'cooking':
      case 'food':
        return Icons.restaurant;
      case 'sleep':
        return Icons.bedtime;
      case 'hydration':
      case 'water':
        return Icons.water_drop;
      case 'work':
        return Icons.work;
      case 'home':
      case 'household':
        return Icons.home;
      case 'personal':
        return Icons.person;
      case 'spiritual':
      case 'religion':
        return Icons.church;
      case 'nature':
      case 'outdoors':
        return Icons.nature;
      case 'sports':
        return Icons.sports;
      case 'gaming':
        return Icons.videogame_asset;
      default:
        return Icons.check_circle_outline;
    }
  }

  // ============================================================================
  // TIME DISPLAY
  // ============================================================================

  /// Get display string for habit time/schedule.
  ///
  /// Returns formatted time string based on habit's notification time
  /// or schedule type.
  static String getHabitTimeDisplay(Habit habit) {
    // For hourly habits, show the number of times per day
    if (habit.frequency == HabitFrequency.hourly &&
        habit.hourlyTimes.isNotEmpty) {
      return '${habit.hourlyTimes.length}x daily';
    }

    // For habits with notification time, show the time
    if (habit.notificationTime != null) {
      final time = habit.notificationTime!;
      final hour = time.hour;
      final minute = time.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    }

    // Fallback: show frequency type
    return _getFrequencyLabel(habit.frequency);
  }

  /// Get human-readable label for frequency enum.
  static String _getFrequencyLabel(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.yearly:
        return 'Yearly';
      case HabitFrequency.hourly:
        return 'Hourly';
      case HabitFrequency.single:
        return 'One-time';
    }
  }

  // ============================================================================
  // SORTING HELPERS
  // ============================================================================

  /// Get sort time for a habit (used for chronological ordering).
  ///
  /// Returns minutes since midnight based on notification time,
  /// earliest hourly slot, or a default value.
  static int getHabitSortTime(Habit habit) {
    // For hourly habits, use earliest time slot
    if (habit.frequency == HabitFrequency.hourly &&
        habit.hourlyTimes.isNotEmpty) {
      int earliestMinutes = 24 * 60; // Default to end of day
      for (final time in habit.hourlyTimes) {
        final parts = time.split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          final totalMinutes = hour * 60 + minute;
          if (totalMinutes < earliestMinutes) {
            earliestMinutes = totalMinutes;
          }
        }
      }
      return earliestMinutes;
    }

    // For other habits, use notification time
    if (habit.notificationTime != null) {
      return habit.notificationTime!.hour * 60 + habit.notificationTime!.minute;
    }

    // Default: put at end of day
    return 24 * 60;
  }

  /// Get the earliest time slot from an hourly habit.
  ///
  /// Returns null if no valid time slots exist.
  static TimeOfDay? getEarliestTimeSlot(Habit habit) {
    if (habit.hourlyTimes.isEmpty) return null;

    TimeOfDay? earliest;
    for (final timeStr in habit.hourlyTimes) {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          final current = TimeOfDay(hour: hour, minute: minute);
          if (earliest == null ||
              (hour < earliest.hour ||
                  (hour == earliest.hour && minute < earliest.minute))) {
            earliest = current;
          }
        }
      }
    }
    return earliest;
  }

  // ============================================================================
  // PROGRESS CALCULATIONS
  // ============================================================================

  /// Calculate completion percentage for a habit on a specific date.
  ///
  /// For hourly habits, returns percentage of completed slots.
  /// For other habits, returns 100 if completed, 0 otherwise.
  static double getCompletionPercentage(Habit habit, DateTime date) {
    if (habit.frequency == HabitFrequency.hourly &&
        habit.hourlyTimes.isNotEmpty) {
      int completed = 0;
      for (final time in habit.hourlyTimes) {
        if (isHourlyHabitCompletedAtTime(habit, date, time)) {
          completed++;
        }
      }
      return (completed / habit.hourlyTimes.length) * 100;
    }

    return isHabitCompletedOnDate(habit, date) ? 100.0 : 0.0;
  }
}
