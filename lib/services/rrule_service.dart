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
        final formatted =
            '${until.toUtc().toIso8601String().replaceAll(RegExp(r'[-:]'), '').split('.')[0]}Z';
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
      final rruleWithPrefix =
          rruleString.startsWith('RRULE:') ? rruleString : 'RRULE:$rruleString';
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

      // Convert to UTC as required by rrule package
      final start =
          DateTime.utc(startDate.year, startDate.month, startDate.day);
      final rangeStartUtc =
          DateTime.utc(rangeStart.year, rangeStart.month, rangeStart.day);
      final rangeEndUtc =
          DateTime.utc(rangeEnd.year, rangeEnd.month, rangeEnd.day, 23, 59, 59);

      // Get instances starting from the habit start date
      final instances = rule.getInstances(start: start);

      // Manually iterate and collect matches within range
      final occurrences = <DateTime>[];
      int checked = 0;
      const maxCheck = 10000; // Safety limit on iterations

      for (final date in instances) {
        checked++;

        // Stop if we've checked too many
        if (checked > maxCheck) {
          AppLogger.error(
              'Hit safety limit of $maxCheck iterations in getOccurrences');
          break;
        }

        // Stop if we've gone past the end of our range
        if (date.isAfter(rangeEndUtc)) break;

        // Add if within range
        if (!date.isBefore(rangeStartUtc)) {
          occurrences.add(date);
        }

        // Stop if we have enough results
        if (occurrences.length >= 1000) break;
      }

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
      final rruleWithPrefix =
          rruleString.startsWith('RRULE:') ? rruleString : 'RRULE:$rruleString';
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

      // Convert to UTC as required by rrule package
      final now = DateTime.now();
      final start = DateTime.utc(now.year, now.month, now.day);

      final occurrences = rule.getInstances(start: start).take(count).toList();

      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get next occurrences: $e');
      return [];
    }
  }

  /// Parse RRule string to extract UI components
  ///
  /// Returns a map with parsed values that can be used to populate the UI.
  /// Returns null if parsing fails.
  static Map<String, dynamic>? parseRRuleToComponents(String rruleString) {
    try {
      // Remove RRULE: prefix if present
      final cleanRRule = rruleString.startsWith('RRULE:')
          ? rruleString.substring(6)
          : rruleString;

      final parts = cleanRRule.split(';');
      final Map<String, String> components = {};

      for (final part in parts) {
        final keyValue = part.split('=');
        if (keyValue.length == 2) {
          components[keyValue[0]] = keyValue[1];
        }
      }

      final result = <String, dynamic>{};

      // Parse FREQ
      if (components.containsKey('FREQ')) {
        result['frequency'] = components['FREQ'];
      }

      // Parse INTERVAL
      if (components.containsKey('INTERVAL')) {
        result['interval'] = int.tryParse(components['INTERVAL']!) ?? 1;
      } else {
        result['interval'] = 1;
      }

      // Parse BYDAY (weekdays)
      if (components.containsKey('BYDAY')) {
        final byDayStr = components['BYDAY']!;

        // Check if it contains position prefix (e.g., "2TU" or "-1FR")
        final hasPosition = RegExp(r'^-?\d+[A-Z]{2}$').hasMatch(byDayStr);

        if (hasPosition) {
          // Monthly position pattern (e.g., "2TU" = 2nd Tuesday)
          final match = RegExp(r'^(-?\d+)([A-Z]{2})$').firstMatch(byDayStr);
          if (match != null) {
            result['monthlyWeekdayPosition'] = int.parse(match.group(1)!);
            result['monthlyWeekday'] = _rruleDayToWeekday(match.group(2)!);
          }
        } else {
          // Weekly pattern - parse multiple days
          final days = byDayStr.split(',');
          result['weekdays'] =
              days.map((day) => _rruleDayToWeekday(day)).toList();
        }
      }

      // Parse BYMONTHDAY
      if (components.containsKey('BYMONTHDAY')) {
        final monthDays = components['BYMONTHDAY']!
            .split(',')
            .map((day) => int.tryParse(day))
            .whereType<int>()
            .toList();
        result['monthDays'] = monthDays;
      }

      // Parse BYMONTH (yearly)
      if (components.containsKey('BYMONTH')) {
        result['yearlyMonth'] = int.tryParse(components['BYMONTH']!) ?? 1;
      }

      // Parse yearly day (from BYMONTHDAY when FREQ=YEARLY)
      if (components['FREQ'] == 'YEARLY' &&
          components.containsKey('BYMONTHDAY')) {
        result['yearlyDay'] = int.tryParse(components['BYMONTHDAY']!) ?? 1;
      }

      // Parse COUNT
      if (components.containsKey('COUNT')) {
        result['count'] = int.tryParse(components['COUNT']!);
      }

      // Parse UNTIL
      if (components.containsKey('UNTIL')) {
        try {
          final untilStr = components['UNTIL']!;
          // Format: YYYYMMDDTHHmmssZ or YYYYMMDD
          if (untilStr.contains('T')) {
            final dateStr = untilStr.split('T')[0];
            result['until'] = DateTime.parse(
              '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}',
            );
          } else {
            result['until'] = DateTime.parse(
              '${untilStr.substring(0, 4)}-${untilStr.substring(4, 6)}-${untilStr.substring(6, 8)}',
            );
          }
        } catch (e) {
          AppLogger.error('Failed to parse UNTIL date: $e');
        }
      }

      return result;
    } catch (e) {
      AppLogger.error('Failed to parse RRule to components: $e');
      return null;
    }
  }

  /// Convert RRule day code to weekday number
  static int _rruleDayToWeekday(String dayCode) {
    const days = {
      'MO': 1,
      'TU': 2,
      'WE': 3,
      'TH': 4,
      'FR': 5,
      'SA': 6,
      'SU': 7,
    };
    return days[dayCode.toUpperCase()] ?? 1;
  }
}
