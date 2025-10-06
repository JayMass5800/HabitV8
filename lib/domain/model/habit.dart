import 'package:isar/isar.dart';
import '../../services/habit_stats_service.dart';
import '../../services/logging_service.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id isarId = Isar.autoIncrement; // Auto-incrementing ID for Isar
  
  @Index(unique: true)
  late String id; // Original string ID for compatibility
  
  late String name;
  
  String? description;
  
  late String category;
  
  late int colorValue;
  
  late DateTime createdAt;
  
  DateTime? nextDueDate;
  
  @Enumerated(EnumType.name)
  late HabitFrequency frequency;
  
  late int targetCount;
  
  // Isar supports List<DateTime> natively!
  List<DateTime> completions = [];
  
  int currentStreak = 0;
  
  int longestStreak = 0;
  
  bool isActive = true;
  
  bool notificationsEnabled = true;
  
  DateTime? notificationTime;
  
  List<int> weeklySchedule = [];
  
  List<int> monthlySchedule = [];
  
  DateTime? reminderTime;
  
  @Enumerated(EnumType.name)
  HabitDifficulty difficulty = HabitDifficulty.medium;
  
  List<int> selectedWeekdays = [];
  
  List<int> selectedMonthDays = [];
  
  List<String> hourlyTimes = [];
  
  List<String> selectedYearlyDates = [];
  
  DateTime? singleDateTime;
  
  bool alarmEnabled = false;
  
  String? alarmSoundName;
  
  String? alarmSoundUri;
  
  int snoozeDelayMinutes = 10;
  
  // RRule fields
  String? rruleString;
  
  DateTime? dtStart;
  
  bool usesRRule = false;

  // ==================== COMPUTED PROPERTIES AND METHODS ====================

  // Private cache reference for efficient access
  static final HabitStatsService _statsService = HabitStatsService();

  // Named constructor for creating new habits
  static Habit create({
    required String name,
    String? description,
    required String category,
    required int colorValue,
    required HabitFrequency frequency,
    int targetCount = 1,
    bool notificationsEnabled = true,
    DateTime? notificationTime,
    DateTime? reminderTime,
    List<int> weeklySchedule = const [],
    List<int> monthlySchedule = const [],
    HabitDifficulty difficulty = HabitDifficulty.medium,
    List<int> selectedWeekdays = const [],
    List<int> selectedMonthDays = const [],
    List<String> hourlyTimes = const [],
    List<String> selectedYearlyDates = const [],
    DateTime? singleDateTime,
    bool alarmEnabled = false,
    String? alarmSoundName,
    String? alarmSoundUri,
    int snoozeDelayMinutes = 10,
  }) {
    return Habit()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..name = name
      ..description = description
      ..category = category
      ..colorValue = colorValue
      ..createdAt = DateTime.now()
      ..frequency = frequency
      ..targetCount = targetCount
      ..isActive = true
      ..currentStreak = 0
      ..longestStreak = 0
      ..completions = []
      ..notificationsEnabled = notificationsEnabled
      ..notificationTime = notificationTime
      ..reminderTime = reminderTime
      ..weeklySchedule = List.from(weeklySchedule)
      ..monthlySchedule = List.from(monthlySchedule)
      ..difficulty = difficulty
      ..selectedWeekdays = List.from(selectedWeekdays)
      ..selectedMonthDays = List.from(selectedMonthDays)
      ..hourlyTimes = List.from(hourlyTimes)
      ..selectedYearlyDates = List.from(selectedYearlyDates)
      ..singleDateTime = singleDateTime
      ..alarmEnabled = alarmEnabled
      ..alarmSoundName = alarmSoundName
      ..alarmSoundUri = alarmSoundUri
      ..snoozeDelayMinutes = snoozeDelayMinutes;
  }

  // Calculate completion rate based on the last 30 days (now cached)
  double get completionRate => _statsService.getCompletionRate(this);

  // Get completion rate for specific number of days
  double getCompletionRate({int days = 30}) =>
      _statsService.getCompletionRate(this, days: days);

  // Get cached streak information
  StreakInfo get streakInfo => _statsService.getStreakInfo(this);

  // Override current and longest streak to use cached values
  int get currentStreakCached => streakInfo.current;
  int get longestStreakCached => streakInfo.longest;

  // Get weekly completion pattern
  List<double> get weeklyPattern => _statsService.getWeeklyPattern(this);

  // Get monthly statistics
  MonthlyStats get monthlyStats => _statsService.getMonthlyStats(this);

  // Get consistency score (0-100)
  double get consistencyScore => _statsService.getConsistencyScore(this);

  // Get habit momentum
  double get momentum => _statsService.getMomentum(this);

  // Check if habit was completed today (cached)
  bool get isCompletedToday {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';

    return _statsService.cache.getOrCompute(
      'completed_today_${id}_$todayKey',
      () => _checkCompletedToday(),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_$id'],
    );
  }

  // Check if habit was completed for the current period based on frequency (cached)
  bool get isCompletedForCurrentPeriod {
    final now = DateTime.now();
    final periodKey = _getPeriodKey(now);

    return _statsService.cache.getOrCompute(
      'completed_period_${id}_$periodKey',
      () => _checkCompletedForCurrentPeriod(now),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_$id'],
    );
  }

  bool _checkCompletedToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return completions.any((completion) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDay.isAtSameMomentAs(today);
    });
  }

  bool _checkCompletedForCurrentPeriod(DateTime checkTime) {
    switch (frequency) {
      case HabitFrequency.hourly:
        final currentHour = DateTime(
          checkTime.year,
          checkTime.month,
          checkTime.day,
          checkTime.hour,
        );
        return completions.any((completion) {
          final completionHour = DateTime(
            completion.year,
            completion.month,
            completion.day,
            completion.hour,
          );
          return completionHour.isAtSameMomentAs(currentHour);
        });

      case HabitFrequency.daily:
        final today = DateTime(checkTime.year, checkTime.month, checkTime.day);
        return completions.any((completion) {
          final completionDay = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDay.isAtSameMomentAs(today);
        });

      case HabitFrequency.weekly:
        final weekStart = _getWeekStart(checkTime);
        final weekEnd = weekStart.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        return completions.any((completion) {
          return completion.isAfter(
                weekStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(weekEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.monthly:
        final monthStart = DateTime(checkTime.year, checkTime.month, 1);
        final monthEnd = DateTime(
          checkTime.year,
          checkTime.month + 1,
          1,
        ).subtract(const Duration(seconds: 1));
        return completions.any((completion) {
          return completion.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(monthEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.yearly:
        final yearStart = DateTime(checkTime.year, 1, 1);
        final yearEnd = DateTime(
          checkTime.year + 1,
          1,
          1,
        ).subtract(const Duration(seconds: 1));
        return completions.any((completion) {
          return completion.isAfter(
                yearStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(yearEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.single:
        return completions.isNotEmpty;
    }
  }

  String _getPeriodKey(DateTime date) {
    switch (frequency) {
      case HabitFrequency.hourly:
        return '${date.year}-${date.month}-${date.day}-${date.hour}';
      case HabitFrequency.daily:
        return '${date.year}-${date.month}-${date.day}';
      case HabitFrequency.weekly:
        final weekStart = _getWeekStart(date);
        return '${weekStart.year}-W${_getWeekOfYear(weekStart)}';
      case HabitFrequency.monthly:
        return '${date.year}-${date.month}';
      case HabitFrequency.yearly:
        return '${date.year}';
      case HabitFrequency.single:
        return 'single-${singleDateTime?.millisecondsSinceEpoch ?? 'no-date'}';
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final daysFromMonday = (date.weekday - 1) % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromMonday));
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil();
  }

  // Get days since last completion (cached)
  int get daysSinceLastCompletion {
    return _statsService.cache.getOrCompute(
      'days_since_last_$id',
      () => _calculateDaysSinceLastCompletion(),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_$id'],
    );
  }

  int _calculateDaysSinceLastCompletion() {
    if (completions.isEmpty) return -1;

    final now = DateTime.now();
    final lastCompletion = completions.reduce((a, b) => a.isAfter(b) ? a : b);
    return now.difference(lastCompletion).inDays;
  }

  // Get next expected completion date (cached)
  DateTime? get nextExpectedCompletion {
    return _statsService.cache.getOrCompute(
      'next_expected_$id',
      () => _calculateNextExpectedCompletion(),
      ttl: const Duration(hours: 6),
      dependsOn: ['habit_completions_$id', 'habit_frequency_$id'],
    );
  }

  DateTime? _calculateNextExpectedCompletion() {
    if (completions.isEmpty) return DateTime.now();

    final lastCompletion = completions.reduce((a, b) => a.isAfter(b) ? a : b);

    switch (frequency) {
      case HabitFrequency.hourly:
        return lastCompletion.add(const Duration(hours: 1));
      case HabitFrequency.daily:
        return lastCompletion.add(const Duration(days: 1));
      case HabitFrequency.weekly:
        return lastCompletion.add(const Duration(days: 7));
      case HabitFrequency.monthly:
        return DateTime(
          lastCompletion.year,
          lastCompletion.month + 1,
          lastCompletion.day,
        );
      case HabitFrequency.yearly:
        return DateTime(
          lastCompletion.year + 1,
          lastCompletion.month,
          lastCompletion.day,
        );
      case HabitFrequency.single:
        return null;
    }
  }

  // Check if habit is overdue (cached)
  bool get isOverdue {
    return _statsService.cache.getOrCompute(
      'is_overdue_$id',
      () => _checkIsOverdue(),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_$id', 'habit_frequency_$id'],
    );
  }

  bool _checkIsOverdue() {
    final nextExpected = nextExpectedCompletion;
    if (nextExpected == null) return false;

    return DateTime.now().isAfter(nextExpected);
  }

  // Invalidate all cached values for this habit when data changes
  void invalidateCache() {
    _statsService.invalidateHabitCache(id);
  }

  // ==================== RRULE HELPER METHODS ====================

  /// Get or create the RRule string for this habit
  String? getOrCreateRRule() {
    if (usesRRule && rruleString != null) {
      return rruleString;
    }

    if (frequency == HabitFrequency.single) {
      return null;
    }

    if (!usesRRule) {
      try {
        final convertedRRule = _convertToRRule();

        if (convertedRRule != null) {
          rruleString = convertedRRule;
          dtStart = dtStart ?? createdAt;
          usesRRule = true;
          AppLogger.info('Migrated habit "$name" to RRule: $rruleString');
        }
      } catch (e) {
        AppLogger.error('Failed to migrate habit "$name" to RRule: $e');
      }
    }

    return rruleString;
  }

  /// Internal method to convert legacy format to RRule
  String? _convertToRRule() {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'FREQ=HOURLY';
      case HabitFrequency.daily:
        return 'FREQ=DAILY';
      case HabitFrequency.weekly:
        if (selectedWeekdays.isEmpty) return 'FREQ=WEEKLY';
        final days = selectedWeekdays.map(_weekdayToRRuleDay).join(',');
        return 'FREQ=WEEKLY;BYDAY=$days';
      case HabitFrequency.monthly:
        if (selectedMonthDays.isEmpty) return 'FREQ=MONTHLY';
        return 'FREQ=MONTHLY;BYMONTHDAY=${selectedMonthDays.join(',')}';
      case HabitFrequency.yearly:
        if (selectedYearlyDates.isEmpty) return 'FREQ=YEARLY';
        try {
          final date = DateTime.parse(selectedYearlyDates.first);
          return 'FREQ=YEARLY;BYMONTH=${date.month};BYMONTHDAY=${date.day}';
        } catch (e) {
          return 'FREQ=YEARLY';
        }
      case HabitFrequency.single:
        return null;
    }
  }

  String _weekdayToRRuleDay(int weekday) {
    const days = {
      0: 'SU',
      1: 'MO',
      2: 'TU',
      3: 'WE',
      4: 'TH',
      5: 'FR',
      6: 'SA',
      7: 'SU',
    };
    return days[weekday] ?? 'MO';
  }

  /// Check if this habit is RRule-based
  bool isRRuleBased() {
    return usesRRule && rruleString != null;
  }

  /// Get human-readable schedule summary
  String getScheduleSummary() {
    if (isRRuleBased()) {
      return _getSimpleRRuleSummary();
    } else {
      return _getLegacyScheduleSummary();
    }
  }

  String _getSimpleRRuleSummary() {
    if (rruleString == null) return 'Custom schedule';

    if (rruleString!.contains('FREQ=DAILY')) return 'Every day';
    if (rruleString!.contains('FREQ=WEEKLY')) return 'Weekly';
    if (rruleString!.contains('FREQ=MONTHLY')) return 'Monthly';
    if (rruleString!.contains('FREQ=YEARLY')) return 'Yearly';
    if (rruleString!.contains('FREQ=HOURLY')) return 'Every hour';

    return 'Custom schedule';
  }

  String _getLegacyScheduleSummary() {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'Every hour';
      case HabitFrequency.daily:
        return 'Every day';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.yearly:
        return 'Yearly';
      case HabitFrequency.single:
        return 'One time';
    }
  }

  // Convert habit to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'frequency': frequency.name,
      'targetCount': targetCount,
      'completions': completions.map((date) => date.toIso8601String()).toList(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'isActive': isActive,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime?.toIso8601String(),
      'weeklySchedule': weeklySchedule,
      'monthlySchedule': monthlySchedule,
      'reminderTime': reminderTime?.toIso8601String(),
      'difficulty': difficulty.name,
      'selectedWeekdays': selectedWeekdays,
      'selectedMonthDays': selectedMonthDays,
      'hourlyTimes': hourlyTimes,
      'selectedYearlyDates': selectedYearlyDates,
      'singleDateTime': singleDateTime?.toIso8601String(),
      'alarmEnabled': alarmEnabled,
      'alarmSoundName': alarmSoundName,
      'alarmSoundUri': alarmSoundUri,
      'snoozeDelayMinutes': snoozeDelayMinutes,
      'rruleString': rruleString,
      'dtStart': dtStart?.toIso8601String(),
      'usesRRule': usesRRule,
    };
  }

  // Create from JSON (for import)
  static Habit fromJson(Map<String, dynamic> json) {
    return Habit()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..category = json['category'] as String
      ..colorValue = json['colorValue'] as int
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..nextDueDate = json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'] as String)
          : null
      ..frequency = HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
      )
      ..targetCount = json['targetCount'] as int
      ..completions = (json['completions'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList()
      ..currentStreak = json['currentStreak'] as int
      ..longestStreak = json['longestStreak'] as int
      ..isActive = json['isActive'] as bool
      ..notificationsEnabled = json['notificationsEnabled'] as bool
      ..notificationTime = json['notificationTime'] != null
          ? DateTime.parse(json['notificationTime'] as String)
          : null
      ..weeklySchedule = (json['weeklySchedule'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..monthlySchedule = (json['monthlySchedule'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..reminderTime = json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null
      ..difficulty = HabitDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      )
      ..selectedWeekdays = (json['selectedWeekdays'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..selectedMonthDays = (json['selectedMonthDays'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..hourlyTimes = (json['hourlyTimes'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..selectedYearlyDates = (json['selectedYearlyDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..singleDateTime = json['singleDateTime'] != null
          ? DateTime.parse(json['singleDateTime'] as String)
          : null
      ..alarmEnabled = json['alarmEnabled'] as bool? ?? false
      ..alarmSoundName = json['alarmSoundName'] as String?
      ..alarmSoundUri = json['alarmSoundUri'] as String?
      ..snoozeDelayMinutes = json['snoozeDelayMinutes'] as int? ?? 10
      ..rruleString = json['rruleString'] as String?
      ..dtStart = json['dtStart'] != null
          ? DateTime.parse(json['dtStart'] as String)
          : null
      ..usesRRule = json['usesRRule'] as bool? ?? false;
  }
}

// Enums remain the same
enum HabitFrequency {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
  single,
}

enum HabitDifficulty {
  easy,
  medium,
  hard,
}
