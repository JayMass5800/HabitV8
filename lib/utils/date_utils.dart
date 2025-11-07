/// Date and time utility functions for the HabitV8 app
///
/// This file contains common date/time operations that are used across
/// multiple screens and widgets. Centralizing these utilities ensures
/// consistency and reduces code duplication.
library;

/// Utility class for date and time operations
class DateTimeUtils {
  /// Check if two DateTime objects represent the same calendar day
  ///
  /// Compares year, month, and day, ignoring time components.
  ///
  /// Example:
  /// ```dart
  /// final date1 = DateTime(2025, 11, 7, 10, 30);
  /// final date2 = DateTime(2025, 11, 7, 18, 45);
  /// print(DateTimeUtils.isSameDay(date1, date2)); // true
  /// ```
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Normalize a DateTime to the start of the day (midnight)
  ///
  /// Returns a new DateTime with time set to 00:00:00.000
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 7, 15, 30, 45);
  /// final normalized = DateTimeUtils.startOfDay(date);
  /// print(normalized); // 2025-11-07 00:00:00.000
  /// ```
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Normalize a DateTime to the end of the day (23:59:59.999)
  ///
  /// Returns a new DateTime with time set to 23:59:59.999
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 7, 10, 15, 30);
  /// final normalized = DateTimeUtils.endOfDay(date);
  /// print(normalized); // 2025-11-07 23:59:59.999
  /// ```
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of the week for a given date (Monday)
  ///
  /// Returns a DateTime representing the Monday of the week containing [date]
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 7); // Thursday
  /// final monday = DateTimeUtils.startOfWeek(date);
  /// print(monday); // 2025-11-04 (Monday)
  /// ```
  static DateTime startOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    return startOfDay(date.subtract(Duration(days: dayOfWeek - 1)));
  }

  /// Get the end of the week for a given date (Sunday)
  ///
  /// Returns a DateTime representing the Sunday of the week containing [date]
  static DateTime endOfWeek(DateTime date) {
    final dayOfWeek = date.weekday;
    return endOfDay(date.add(Duration(days: 7 - dayOfWeek)));
  }

  /// Get the start of the month for a given date
  ///
  /// Returns a DateTime representing the first day of the month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month for a given date
  ///
  /// Returns a DateTime representing the last day of the month
  static DateTime endOfMonth(DateTime date) {
    // Get first day of next month, then subtract one day
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return endOfDay(nextMonth.subtract(const Duration(days: 1)));
  }

  /// Get the start of the year for a given date
  ///
  /// Returns a DateTime representing January 1st of the year
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Get the end of the year for a given date
  ///
  /// Returns a DateTime representing December 31st at 23:59:59.999
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  /// Check if a date is today
  ///
  /// Compares the given date with the current date
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if a date is in the past (before today)
  ///
  /// Returns true if the date is before today (not including today)
  static bool isPast(DateTime date) {
    final today = startOfDay(DateTime.now());
    final compareDate = startOfDay(date);
    return compareDate.isBefore(today);
  }

  /// Check if a date is in the future (after today)
  ///
  /// Returns true if the date is after today (not including today)
  static bool isFuture(DateTime date) {
    final today = startOfDay(DateTime.now());
    final compareDate = startOfDay(date);
    return compareDate.isAfter(today);
  }

  /// Get the number of days between two dates
  ///
  /// Returns the absolute difference in days, ignoring time components
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = startOfDay(from);
    final toDate = startOfDay(to);
    return toDate.difference(fromDate).inDays;
  }
}
