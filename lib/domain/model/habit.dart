import 'package:hive/hive.dart';
import '../../services/habit_stats_service.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late int colorValue;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  DateTime? nextDueDate;

  @HiveField(7)
  late HabitFrequency frequency;

  @HiveField(8)
  late int targetCount;

  @HiveField(9)
  List<DateTime> completions = [];

  @HiveField(10)
  int currentStreak = 0;

  @HiveField(11)
  int longestStreak = 0;

  @HiveField(12)
  bool isActive = true;

  @HiveField(13)
  bool notificationsEnabled = true;

  @HiveField(14)
  DateTime? notificationTime;

  @HiveField(15)
  List<int> weeklySchedule = [];

  @HiveField(16)
  List<int> monthlySchedule = [];

  @HiveField(17)
  DateTime? reminderTime;

  @HiveField(18)
  HabitDifficulty difficulty = HabitDifficulty.medium;

  // Add new fields for frequency-specific data
  @HiveField(19)
  List<int> selectedWeekdays = [];

  @HiveField(20)
  List<int> selectedMonthDays = [];

  @HiveField(21)
  List<String> hourlyTimes = []; // Store as string format "HH:mm"

  @HiveField(22)
  List<String> selectedYearlyDates = []; // Store as string format "yyyy-MM-dd"

  // Single habit date/time - stores the exact date and time for one-off habits
  @HiveField(26)
  DateTime? singleDateTime;

  // Alarm-specific fields
  @HiveField(23)
  bool alarmEnabled = false;

  @HiveField(24)
  String? alarmSoundName; // System alarm sound display name

  @HiveField(27)
  String? alarmSoundUri; // System alarm sound URI

  @HiveField(25)
  int snoozeDelayMinutes = 10; // Default 10 minutes snooze

  Habit() {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Habit.create({
    required this.name,
    this.description,
    required this.category,
    required this.colorValue,
    required this.frequency,
    this.targetCount = 1,
    this.notificationsEnabled = true,
    this.notificationTime,
    this.reminderTime,
    this.weeklySchedule = const [],
    this.monthlySchedule = const [],
    this.difficulty = HabitDifficulty.medium,
    this.selectedWeekdays = const [],
    this.selectedMonthDays = const [],
    this.hourlyTimes = const [],
    this.selectedYearlyDates = const [],
    this.singleDateTime,
    this.alarmEnabled = false,
    this.alarmSoundName,
    this.alarmSoundUri,
    this.snoozeDelayMinutes = 10,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    createdAt = DateTime.now();
    isActive = true;
    currentStreak = 0;
    longestStreak = 0;
    completions = [];
  }

  // Private cache reference for efficient access
  static final HabitStatsService _statsService = HabitStatsService();

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
        // Check if completed in the current hour
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
        // Check if completed today
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
        // Check if completed in the current week (Monday to Sunday)
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
        // Check if completed in the current month
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
        // Check if completed in the current year
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
        // Check if completed (single habits can only be completed once)
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
    // Get the Monday of the current week
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
        // Single habits don't repeat, so return null to indicate no next completion
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

  // Override save method to invalidate cache
  @override
  Future<void> save() async {
    await super.save();
    invalidateCache();
  }

  // Override delete method to invalidate cache
  @override
  Future<void> delete() async {
    invalidateCache();
    await super.delete();
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
      'frequency': frequency.toString().split('.').last,
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
      'difficulty': difficulty.toString().split('.').last,
      'selectedWeekdays': selectedWeekdays,
      'selectedMonthDays': selectedMonthDays,
      'hourlyTimes': hourlyTimes,
      'selectedYearlyDates': selectedYearlyDates,
      'singleDateTime': singleDateTime?.toIso8601String(),
      'alarmEnabled': alarmEnabled,
      'alarmSoundName': alarmSoundName,
      'alarmSoundUri': alarmSoundUri,
      'snoozeDelayMinutes': snoozeDelayMinutes,
    };
  }
}

@HiveType(typeId: 1)
enum HabitFrequency {
  @HiveField(0)
  hourly,
  @HiveField(1)
  daily,
  @HiveField(2)
  weekly,
  @HiveField(3)
  monthly,
  @HiveField(4)
  yearly,
  @HiveField(5)
  single,
}

@HiveType(typeId: 2)
enum HabitDifficulty {
  @HiveField(0)
  easy,
  @HiveField(1)
  medium,
  @HiveField(2)
  hard,
}
