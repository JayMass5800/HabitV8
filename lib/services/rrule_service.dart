import 'package:rrule/rrule.dart';
import '../domain/model/habit.dart';
import 'logging_service.dart';

/// Centralized service for all RRule (Recurrence Rule) operations.
/// Handles conversion, generation, parsing, and validation of RRule patterns.
/// 
/// RRule is an industry-standard way to define repeating events based on
/// the iCalendar specification (RFC 5545).
class RRuleService {
  // Cache for parsed RRule objects to improve performance
  static final Map<String, RecurrenceRule> _rruleCache = {};

  /// Convert a legacy Habit to an RRule string
  /// 
  /// Takes the old frequency-based system and converts it to a standardized
  /// RRule string that can represent the same recurrence pattern.
  static String? convertLegacyToRRule(Habit habit) {
    try {
      switch (habit.frequency) {
        case HabitFrequency.hourly:
          return 'FREQ=HOURLY';

        case HabitFrequency.daily:
          return 'FREQ=DAILY';

        case HabitFrequency.weekly:
          if (habit.selectedWeekdays.isEmpty) {
            return 'FREQ=WEEKLY';
          }
          final days = habit.selectedWeekdays
              .map((day) => _weekdayToRRuleDay(day))
              .join(',');
          return 'FREQ=WEEKLY;BYDAY=$days';

        case HabitFrequency.monthly:
          if (habit.selectedMonthDays.isEmpty) {
            return 'FREQ=MONTHLY';
          }
          final days = habit.selectedMonthDays.join(',');
          return 'FREQ=MONTHLY;BYMONTHDAY=$days';

        case HabitFrequency.yearly:
          return _convertYearlyDates(habit.selectedYearlyDates);

        case HabitFrequency.single:
          // Single events don't have recurrence
          return null;
      }
    } catch (e) {
      AppLogger.error('Failed to convert legacy habit to RRule: $e');
      return null;
    }
  }

  /// Convert a weekday index to RRule day code
  /// 
  /// Handles both formats:
  /// - 0=Sunday, 1=Monday, ... 6=Saturday
  /// - 7=Sunday (alternative)
  static String _weekdayToRRuleDay(int weekday) {
    const days = {
      0: 'SU', // Sunday
      1: 'MO', // Monday
      2: 'TU', // Tuesday
      3: 'WE', // Wednesday
      4: 'TH', // Thursday
      5: 'FR', // Friday
      6: 'SA', // Saturday
      7: 'SU', // Sunday (alternative)
    };
    return days[weekday] ?? 'MO';
  }

  /// Convert yearly dates (format: "yyyy-MM-dd") to RRule
  static String? _convertYearlyDates(List<String> yearlyDates) {
    if (yearlyDates.isEmpty) {
      return 'FREQ=YEARLY';
    }

    try {
      // Parse the first date to get month and day
      final date = DateTime.parse(yearlyDates.first);
      return 'FREQ=YEARLY;BYMONTH=${date.month};BYMONTHDAY=${date.day}';
    } catch (e) {
      AppLogger.error('Failed to parse yearly date: $e');
      return 'FREQ=YEARLY';
    }
  }

  /// Create an RRule string from UI components
  /// 
  /// This is used when creating new habits with the RRule builder UI.
  static String createRRule({
    required Frequency frequency,
    int interval = 1,
    List<ByWeekDayEntry>? byWeekDays,
    List<int>? byMonthDays,
    int? bySetPos,
    DateTime? until,
    int? count,
  }) {
    try {
      final rule = RecurrenceRule(
        frequency: frequency,
        interval: interval,
        byWeekDays: byWeekDays?.toSet(),
        byMonthDays: byMonthDays?.toSet(),
        bySetPositions: bySetPos != null ? {bySetPos} : null,
        until: until,
        count: count,
      );

      return rule.toString();
    } catch (e) {
      AppLogger.error('Failed to create RRule: $e');
      rethrow;
    }
  }

  /// Get a parsed RecurrenceRule object (with caching)
  /// 
  /// Parses the RRule string and caches the result for performance.
  /// The cache key includes both the RRule string and start date.
  static RecurrenceRule? parseRRule(String rruleString, DateTime startDate) {
    final cacheKey = '$rruleString|${startDate.toIso8601String()}';

    if (_rruleCache.containsKey(cacheKey)) {
      return _rruleCache[cacheKey];
    }

    try {
      final rule = RecurrenceRule.fromString(
        rruleString,
        dtStart: startDate,
      );
      _rruleCache[cacheKey] = rule;
      return rule;
    } catch (e) {
      AppLogger.error('Failed to parse RRule: $e');
      return null;
    }
  }

  /// Get list of occurrence dates within a range
  /// 
  /// Returns all dates when the habit should occur between rangeStart and rangeEnd.
  static List<DateTime> getOccurrences({
    required String rruleString,
    required DateTime startDate,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    try {
      final rule = parseRRule(rruleString, startDate);
      if (rule == null) return [];

      final occurrences = rule.between(rangeStart, rangeEnd);
      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get occurrences: $e');
      return [];
    }
  }

  /// Check if habit is due on a specific date
  /// 
  /// This is the most commonly used method - checks if a habit should
  /// occur on the given date.
  static bool isDueOnDate({
    required String rruleString,
    required DateTime startDate,
    required DateTime checkDate,
  }) {
    try {
      // Create a date range for the entire day
      final dayStart = DateTime(checkDate.year, checkDate.month, checkDate.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final occurrences = getOccurrences(
        rruleString: rruleString,
        startDate: startDate,
        rangeStart: dayStart,
        rangeEnd: dayEnd,
      );

      return occurrences.isNotEmpty;
    } catch (e) {
      AppLogger.error('Failed to check if due on date: $e');
      return false;
    }
  }

  /// Get a human-readable summary of the RRule
  /// 
  /// Converts the RRule string into a user-friendly description like:
  /// - "Every 2 weeks on Tuesday and Thursday"
  /// - "Every month on the 15th"
  /// - "Every day"
  static String getRRuleSummary(String rruleString) {
    try {
      final rule = RecurrenceRule.fromString(rruleString);
      
      // Build summary based on frequency
      String summary = _getFrequencySummary(rule);
      
      // Add interval if not 1
      if (rule.interval > 1) {
        summary = summary.replaceFirst(
          'Every',
          'Every ${rule.interval}',
        );
      }

      // Add day-specific info
      if (rule.byWeekDays?.isNotEmpty ?? false) {
        final days = rule.byWeekDays!
            .map((day) => _formatWeekDay(day))
            .join(', ');
        summary += ' on $days';
      }

      if (rule.byMonthDays?.isNotEmpty ?? false) {
        final days = rule.byMonthDays!.join(', ');
        summary += ' on day(s) $days';
      }

      return summary;
    } catch (e) {
      AppLogger.error('Failed to get RRule summary: $e');
      return 'Custom schedule';
    }
  }

  static String _getFrequencySummary(RecurrenceRule rule) {
    switch (rule.frequency) {
      case Frequency.hourly:
        return 'Every hour';
      case Frequency.daily:
        return 'Every day';
      case Frequency.weekly:
        return 'Every week';
      case Frequency.monthly:
        return 'Every month';
      case Frequency.yearly:
        return 'Every year';
      default:
        return 'Custom';
    }
  }

  static String _formatWeekDay(ByWeekDayEntry day) {
    const dayNames = {
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
      DateTime.sunday: 'Sunday',
    };

    final dayName = dayNames[day.day] ?? 'Unknown';
    
    if (day.occurrence != 0) {
      final ordinal = _getOrdinal(day.occurrence);
      return '$ordinal $dayName';
    }
    
    return dayName;
  }

  static String _getOrdinal(int n) {
    if (n == -1) return 'Last';
    if (n == 1) return 'First';
    if (n == 2) return 'Second';
    if (n == 3) return 'Third';
    if (n == 4) return 'Fourth';
    return '${n}th';
  }

  /// Validate an RRule string
  /// 
  /// Returns true if the RRule string is valid and can be parsed.
  static bool isValidRRule(String rruleString) {
    try {
      RecurrenceRule.fromString(rruleString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear the cache
  /// 
  /// Call this when habits are modified to ensure fresh data.
  static void clearCache() {
    _rruleCache.clear();
  }

  /// Get next N occurrences from now
  /// 
  /// Useful for previewing upcoming dates in the UI.
  static List<DateTime> getNextOccurrences({
    required String rruleString,
    required DateTime startDate,
    required int count,
  }) {
    try {
      final rule = parseRRule(rruleString, startDate);
      if (rule == null) return [];

      final now = DateTime.now();
      final occurrences = rule.getAllInstances(start: now).take(count).toList();
      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get next occurrences: $e');
      return [];
    }
  }
}
