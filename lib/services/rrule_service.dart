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
    List<int>? byWeekDays,
    List<int>? byMonthDays,
    int? bySetPos,
    DateTime? until,
    int? count,
  }) {
    try {
      // Build RRule string manually for better control
      final freq = frequency.toString().split('.').last.toUpperCase();
      final parts = <String>['FREQ=$freq'];
      
      if (interval > 1) {
        parts.add('INTERVAL=$interval');
      }
      
      if (byWeekDays != null && byWeekDays.isNotEmpty) {
        final days = byWeekDays.map((day) {
          const dayCodes = {
            DateTime.monday: 'MO',
            DateTime.tuesday: 'TU',
            DateTime.wednesday: 'WE',
            DateTime.thursday: 'TH',
            DateTime.friday: 'FR',
            DateTime.saturday: 'SA',
            DateTime.sunday: 'SU',
          };
          return dayCodes[day] ?? 'MO';
        }).join(',');
        parts.add('BYDAY=$days');
      }
      
      if (byMonthDays != null && byMonthDays.isNotEmpty) {
        parts.add('BYMONTHDAY=${byMonthDays.join(',')}');
      }
      
      if (bySetPos != null) {
        parts.add('BYSETPOS=$bySetPos');
      }
      
      if (count != null) {
        parts.add('COUNT=$count');
      }
      
      if (until != null) {
        final formatted = until.toUtc().toIso8601String().replaceAll(RegExp(r'[-:]'), '').split('.')[0] + 'Z';
        parts.add('UNTIL=$formatted');
      }
      
      return parts.join(';');
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
      // The rrule package expects "RRULE:FREQ=..." format
      final rruleWithPrefix = rruleString.startsWith('RRULE:') 
          ? rruleString 
          : 'RRULE:$rruleString';
      final rule = RecurrenceRule.fromString(rruleWithPrefix);
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

      // The rrule package requires dates to be in UTC without milliseconds
      final start = DateTime.utc(
        rangeStart.year,
        rangeStart.month,
        rangeStart.day,
      );

      // Get all instances starting from the start date
      final allInstances = rule.getAllInstances(start: start).take(1000);
      
      // Filter to only those in range
      final occurrences = allInstances.where((date) {
        return (date.isAfter(rangeStart) || date.isAtSameMomentAs(rangeStart)) &&
               (date.isBefore(rangeEnd) || date.isAtSameMomentAs(rangeEnd));
      }).toList();
      
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
      // Simple parsing for common patterns
      if (rruleString.contains('FREQ=HOURLY')) return 'Every hour';
      if (rruleString.contains('FREQ=DAILY')) return 'Every day';
      if (rruleString.contains('FREQ=WEEKLY')) {
        if (rruleString.contains('INTERVAL=2')) {
          return 'Every 2 weeks';
        }
        return 'Every week';
      }
      if (rruleString.contains('FREQ=MONTHLY')) return 'Every month';
      if (rruleString.contains('FREQ=YEARLY')) return 'Every year';
      
      return 'Custom schedule';
    } catch (e) {
      AppLogger.error('Failed to get RRule summary: $e');
      return 'Custom schedule';
    }
  }

  /// Validate an RRule string
  /// 
  /// Returns true if the RRule string is valid and can be parsed.
  static bool isValidRRule(String rruleString) {
    try {
      // The rrule package expects "RRULE:FREQ=..." format
      final rruleWithPrefix = rruleString.startsWith('RRULE:') 
          ? rruleString 
          : 'RRULE:$rruleString';
      RecurrenceRule.fromString(rruleWithPrefix);
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

      // The rrule package requires dates to be in UTC without milliseconds
      final now = DateTime.now();
      final start = DateTime.utc(now.year, now.month, now.day);
      
      final occurrences = rule.getAllInstances(start: start).take(count).toList();
      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get next occurrences: $e');
      return [];
    }
  }
}
