import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import '../logging_service.dart';
import '../preferences_service.dart';
import '../time_service.dart';
import '../rrule_service.dart';
import '../../domain/model/habit.dart';
import 'notification_helpers.dart';

/// Manages notification budget allocation across all habits to stay within
/// Android's 500 concurrent alarm limit.
///
/// ## Strategy: Rolling Window with Priority-Based Allocation
///
/// Instead of scheduling all notifications for each habit indefinitely,
/// this service:
///
/// 1. **Allocates a budget** to each habit based on its frequency
/// 2. **Prioritizes near-term** notifications (next 3 days get more slots)
/// 3. **Uses a rolling window** that auto-refreshes via midnight reset
/// 4. **Reserves emergency slots** for snooze/test notifications
///
/// ## Budget Distribution:
/// - Total Android limit: 500 alarms
/// - Reserved for system: 50 (snooze, test, boot recovery)
/// - Available for habits: 450
/// - Per-habit allocation: 450 / activeHabitCount (with min/max bounds)
///
/// ## Example with 10 daily habits:
/// - Each habit gets 45 notification slots
/// - With 14-day window: 14 notifications per habit (well under limit)
/// - System handles this automatically via rolling refresh
class NotificationBudgetService {
  NotificationBudgetService._();

  static final NotificationBudgetService instance =
      NotificationBudgetService._();

  // Android's hard limit for concurrent alarms
  static const int _androidAlarmLimit = 500;

  // Reserved for system operations (snooze, test, boot recovery)
  static const int _reservedSlots = 50;

  // Available for habit notifications
  static const int _availableSlots = _androidAlarmLimit - _reservedSlots;

  // Minimum slots per habit (ensures at least some notifications)
  static const int _minSlotsPerHabit = 3;

  // Maximum slots per habit (prevents one habit from dominating)
  static const int _maxSlotsPerHabit = 50;

  // Default look-ahead days when budget allows
  static const int _defaultLookAheadDays = 14;

  // Minimum look-ahead (always schedule at least this far)
  static const int _minLookAheadDays = 3;

  // Preference keys
  static const String _lastBudgetCalculationKey =
      'notification_budget_last_calc';
  static const String _budgetAllocationKey = 'notification_budget_allocation';

  static final TimeService _time = TimeService.instance;

  // Cached budget allocation
  static Map<String, int> _habitBudgets = {};
  static int _currentTotalBudget = _availableSlots;
  static DateTime? _lastCalculation;

  // ==================== PUBLIC API ====================

  /// Calculate and cache budget allocation for all active habits.
  ///
  /// Call this:
  /// - On app startup
  /// - When habits are added/deleted
  /// - At midnight reset
  ///
  /// Returns a map of habitId -> allocated notification slots
  static Future<Map<String, int>> calculateBudgetAllocation(
    List<Habit> activeHabits,
  ) async {
    try {
      AppLogger.info('📊 Calculating notification budget allocation...');
      AppLogger.info('   Active habits: ${activeHabits.length}');
      AppLogger.info('   Available slots: $_availableSlots');

      if (activeHabits.isEmpty) {
        _habitBudgets = {};
        _lastCalculation = _time.nowLocal();
        return {};
      }

      // Filter to only habits with notifications enabled
      final notifyingHabits = activeHabits
          .where((h) => h.notificationsEnabled || h.alarmEnabled)
          .toList();

      if (notifyingHabits.isEmpty) {
        AppLogger.info('   No habits with notifications enabled');
        _habitBudgets = {};
        _lastCalculation = _time.nowLocal();
        return {};
      }

      // Calculate base allocation (equal distribution)
      final baseAllocation = _availableSlots ~/ notifyingHabits.length;

      // Apply min/max bounds
      final boundedAllocation = baseAllocation.clamp(
        _minSlotsPerHabit,
        _maxSlotsPerHabit,
      );

      // Calculate priority-weighted allocation
      final allocation = <String, int>{};
      int totalAllocated = 0;

      for (final habit in notifyingHabits) {
        // Weight by frequency (more frequent = needs more slots)
        final weight = _getFrequencyWeight(habit);
        final slots = (boundedAllocation * weight).round().clamp(
              _minSlotsPerHabit,
              _maxSlotsPerHabit,
            );

        allocation[habit.id] = slots;
        totalAllocated += slots;
      }

      // If we're over budget, scale down proportionally
      if (totalAllocated > _availableSlots) {
        final scaleFactor = _availableSlots / totalAllocated;
        for (final habitId in allocation.keys) {
          allocation[habitId] = max(
            _minSlotsPerHabit,
            (allocation[habitId]! * scaleFactor).floor(),
          );
        }
        AppLogger.warning(
          '   Budget exceeded, scaled down by factor: ${scaleFactor.toStringAsFixed(2)}',
        );
      }

      // Cache the allocation
      _habitBudgets = allocation;
      _lastCalculation = _time.nowLocal();
      _currentTotalBudget = allocation.values.fold(0, (a, b) => a + b);

      // Persist for recovery
      await _persistBudgetAllocation(allocation);

      AppLogger.info(
          '   Total allocated: $_currentTotalBudget / $_availableSlots');
      AppLogger.info(
          '   Per-habit average: ${(_currentTotalBudget / notifyingHabits.length).toStringAsFixed(1)} slots');

      return allocation;
    } catch (e) {
      AppLogger.error('❌ Error calculating budget allocation', e);
      // Fallback: equal distribution with safe defaults
      return _getFallbackAllocation(activeHabits);
    }
  }

  /// Get the allocated budget for a specific habit.
  ///
  /// Returns the number of notification slots this habit can use.
  /// If budget hasn't been calculated, returns a safe default.
  static int getBudgetForHabit(String habitId) {
    if (_habitBudgets.containsKey(habitId)) {
      return _habitBudgets[habitId]!;
    }

    // Return safe default if not calculated
    return _minSlotsPerHabit;
  }

  /// Calculate optimal look-ahead days for a habit based on its budget.
  ///
  /// Takes into account:
  /// - Allocated budget (from calculateBudgetAllocation)
  /// - Habit frequency (daily needs more slots than weekly)
  /// - Ensures minimum coverage
  static int calculateLookAheadDays(Habit habit) {
    final budget = getBudgetForHabit(habit.id);

    // Calculate how many notifications per day this habit generates
    final notificationsPerDay = _getNotificationsPerDay(habit);

    if (notificationsPerDay <= 0) {
      return _defaultLookAheadDays;
    }

    // Calculate how many days we can cover with the budget
    final coverableDays = (budget / notificationsPerDay).floor();

    // Clamp to reasonable bounds
    return coverableDays.clamp(_minLookAheadDays, _defaultLookAheadDays);
  }

  /// Get current budget statistics for diagnostics.
  static Map<String, dynamic> getBudgetStats() {
    return {
      'androidLimit': _androidAlarmLimit,
      'reservedSlots': _reservedSlots,
      'availableSlots': _availableSlots,
      'currentTotalAllocated': _currentTotalBudget,
      'remainingSlots': _availableSlots - _currentTotalBudget,
      'habitCount': _habitBudgets.length,
      'lastCalculation': _lastCalculation?.toIso8601String(),
      'habitBudgets': Map.from(_habitBudgets),
    };
  }

  /// Check if we're approaching the budget limit.
  ///
  /// Returns true if more than 80% of available slots are allocated.
  static bool isApproachingLimit() {
    return _currentTotalBudget > (_availableSlots * 0.8);
  }

  /// Get the current pending notification count from Android.
  ///
  /// Use this to verify actual usage vs calculated budget.
  static Future<int> getCurrentPendingCount() async {
    try {
      final pending = await AwesomeNotifications().listScheduledNotifications();
      return pending.length;
    } catch (e) {
      AppLogger.error('Error getting pending notification count', e);
      return 0;
    }
  }

  /// Validate that current pending notifications are within budget.
  ///
  /// Returns a report with warnings if over budget.
  static Future<Map<String, dynamic>> validateBudget() async {
    final pendingCount = await getCurrentPendingCount();
    final isOverBudget = pendingCount > _availableSlots;
    final isApproaching = pendingCount > (_availableSlots * 0.8);

    final report = {
      'pendingCount': pendingCount,
      'availableSlots': _availableSlots,
      'utilizationPercent':
          ((pendingCount / _availableSlots) * 100).toStringAsFixed(1),
      'isOverBudget': isOverBudget,
      'isApproachingLimit': isApproaching,
      'status': isOverBudget ? 'CRITICAL' : (isApproaching ? 'WARNING' : 'OK'),
    };

    if (isOverBudget) {
      AppLogger.error(
        '🚨 NOTIFICATION BUDGET EXCEEDED: $pendingCount / $_availableSlots',
      );
    } else if (isApproaching) {
      AppLogger.warning(
        '⚠️ Notification budget approaching limit: $pendingCount / $_availableSlots',
      );
    }

    return report;
  }

  // ==================== BATCH SCHEDULING ====================

  /// Schedule notifications for a habit respecting its budget allocation.
  ///
  /// This is the main entry point for budget-aware scheduling.
  /// It will schedule up to [budget] notifications for the habit,
  /// prioritizing near-term dates.
  ///
  /// Returns the number of notifications actually scheduled.
  static Future<int> scheduleWithBudget({
    required Habit habit,
    required Future<void> Function({
      required int id,
      required String habitId,
      required String title,
      required String body,
      required DateTime scheduledTime,
    }) scheduleFunction,
  }) async {
    final budget = getBudgetForHabit(habit.id);
    final lookAheadDays = calculateLookAheadDays(habit);

    AppLogger.debug(
      'Scheduling ${habit.name} with budget: $budget slots, '
      'look-ahead: $lookAheadDays days',
    );

    if (!habit.notificationsEnabled) {
      return 0;
    }

    // Get occurrences within our budget window
    final now = _time.nowLocal();
    final rangeStart = _time.startOfDayLocal(now);
    final rangeEnd = now.add(Duration(days: lookAheadDays));

    List<DateTime> occurrences;

    if (habit.usesRRule && habit.rruleString != null) {
      occurrences = RRuleService.getOccurrences(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
    } else {
      // Legacy frequency - generate occurrences manually
      occurrences = _generateLegacyOccurrences(habit, rangeStart, rangeEnd);
    }

    // Filter to future times and limit to budget
    final notificationTime = habit.notificationTime;
    final hour = notificationTime?.hour ?? 9;
    final minute = notificationTime?.minute ?? 0;

    final schedulableTimes = <DateTime>[];

    for (final occurrence in occurrences) {
      final scheduledTime = _resolveScheduledTime(occurrence, hour, minute);
      if (scheduledTime.isAfter(now)) {
        schedulableTimes.add(scheduledTime);
        if (schedulableTimes.length >= budget) break; // Respect budget
      }
    }

    // Schedule each notification
    int scheduledCount = 0;
    for (final scheduledTime in schedulableTimes) {
      try {
        await scheduleFunction(
          id: NotificationHelpers.generateSafeId(
            '${habit.id}_${scheduledTime.toIso8601String()}',
          ),
          habitId: habit.id,
          title: '🎯 ${habit.name}',
          body: _getNotificationBody(habit),
          scheduledTime: scheduledTime,
        );
        scheduledCount++;
      } catch (e) {
        AppLogger.error(
          'Failed to schedule notification for ${habit.name} at $scheduledTime',
          e,
        );
      }
    }

    AppLogger.info(
      '✅ Scheduled $scheduledCount / $budget notifications for ${habit.name} '
      '(${schedulableTimes.length} available in $lookAheadDays-day window)',
    );

    return scheduledCount;
  }

  // ==================== PRIVATE HELPERS ====================

  /// Get frequency weight for budget allocation.
  /// More frequent habits get higher weight (need more slots).
  static double _getFrequencyWeight(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        // Hourly habits need many slots
        return 2.0 * max(1, habit.hourlyTimes.length);
      case HabitFrequency.daily:
        return 1.0;
      case HabitFrequency.weekly:
        // Weekly needs fewer (only selected days)
        return 0.5 * max(1, habit.selectedWeekdays.length) / 7;
      case HabitFrequency.monthly:
        return 0.3;
      case HabitFrequency.yearly:
        return 0.1;
      case HabitFrequency.single:
        return 0.1;
    }
  }

  /// Get estimated notifications per day for a habit.
  static double _getNotificationsPerDay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        // Each time slot per day on selected weekdays
        final times = habit.hourlyTimes.length;
        final days = habit.selectedWeekdays.length;
        if (days == 0) return times.toDouble();
        return times * (days / 7);
      case HabitFrequency.daily:
        return 1.0;
      case HabitFrequency.weekly:
        return habit.selectedWeekdays.length / 7;
      case HabitFrequency.monthly:
        return habit.selectedMonthDays.length / 30;
      case HabitFrequency.yearly:
        return habit.selectedYearlyDates.length / 365;
      case HabitFrequency.single:
        return 1.0 / 365; // One-time
    }
  }

  /// Generate occurrences for legacy (non-RRule) habits.
  static List<DateTime> _generateLegacyOccurrences(
    Habit habit,
    DateTime rangeStart,
    DateTime rangeEnd,
  ) {
    final occurrences = <DateTime>[];
    var current = rangeStart;

    while (!current.isAfter(rangeEnd) && occurrences.length < 100) {
      bool shouldInclude = false;

      switch (habit.frequency) {
        case HabitFrequency.daily:
          shouldInclude = true;
          break;
        case HabitFrequency.weekly:
          shouldInclude = habit.selectedWeekdays.contains(current.weekday);
          break;
        case HabitFrequency.monthly:
          shouldInclude = habit.selectedMonthDays.contains(current.day);
          break;
        case HabitFrequency.yearly:
          final dateStr =
              '${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}';
          shouldInclude =
              habit.selectedYearlyDates.any((d) => d.endsWith(dateStr));
          break;
        case HabitFrequency.hourly:
          // For hourly, each day with selected weekdays
          shouldInclude = habit.selectedWeekdays.isEmpty ||
              habit.selectedWeekdays.contains(current.weekday);
          break;
        case HabitFrequency.single:
          if (habit.singleDateTime != null) {
            final single = habit.singleDateTime!;
            shouldInclude = current.year == single.year &&
                current.month == single.month &&
                current.day == single.day;
          }
          break;
      }

      if (shouldInclude) {
        if (habit.frequency == HabitFrequency.hourly) {
          // Add an occurrence for each time slot
          for (final timeStr in habit.hourlyTimes) {
            final parts = timeStr.split(':');
            if (parts.length == 2) {
              final hour = int.tryParse(parts[0]) ?? 9;
              final minute = int.tryParse(parts[1]) ?? 0;
              occurrences.add(DateTime(
                current.year,
                current.month,
                current.day,
                hour,
                minute,
              ));
            }
          }
        } else {
          occurrences.add(current);
        }
      }

      current = current.add(const Duration(days: 1));
    }

    return occurrences;
  }

  /// Resolve the actual scheduled time from an occurrence date.
  static DateTime _resolveScheduledTime(
      DateTime occurrence, int hour, int minute) {
    // If occurrence already has a non-midnight time, use it
    if (occurrence.hour != 0 || occurrence.minute != 0) {
      return occurrence;
    }

    // Otherwise apply the notification time
    return DateTime(
      occurrence.year,
      occurrence.month,
      occurrence.day,
      hour,
      minute,
    );
  }

  /// Get appropriate notification body based on habit type.
  static String _getNotificationBody(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        return 'Time to complete your habit!';
      case HabitFrequency.daily:
        return 'Time to complete your daily habit! Keep your streak going.';
      case HabitFrequency.weekly:
        return 'Time to complete your weekly habit!';
      case HabitFrequency.monthly:
        return 'Time to complete your monthly habit!';
      case HabitFrequency.yearly:
        return 'Time to complete your yearly habit!';
      case HabitFrequency.single:
        return 'Time to complete your habit!';
    }
  }

  /// Fallback allocation when calculation fails.
  static Map<String, int> _getFallbackAllocation(List<Habit> habits) {
    final allocation = <String, int>{};
    for (final habit in habits) {
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        allocation[habit.id] = _minSlotsPerHabit;
      }
    }
    _habitBudgets = allocation;
    return allocation;
  }

  /// Persist budget allocation for recovery after restart.
  static Future<void> _persistBudgetAllocation(
      Map<String, int> allocation) async {
    try {
      final entries =
          allocation.entries.map((e) => '${e.key}:${e.value}').join(',');
      await PreferencesService.setString(_budgetAllocationKey, entries);
      await PreferencesService.setString(
        _lastBudgetCalculationKey,
        _time.nowLocal().toIso8601String(),
      );
    } catch (e) {
      AppLogger.error('Failed to persist budget allocation', e);
    }
  }

  /// Load persisted budget allocation.
  static Future<void> loadPersistedBudget() async {
    try {
      final stored = await PreferencesService.getString(_budgetAllocationKey);
      if (stored == null || stored.isEmpty) return;

      final allocation = <String, int>{};
      for (final entry in stored.split(',')) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final habitId = parts[0];
          final slots = int.tryParse(parts[1]);
          if (slots != null) {
            allocation[habitId] = slots;
          }
        }
      }

      _habitBudgets = allocation;
      _currentTotalBudget = allocation.values.fold(0, (a, b) => a + b);

      final lastCalcStr =
          await PreferencesService.getString(_lastBudgetCalculationKey);
      if (lastCalcStr != null) {
        _lastCalculation = DateTime.tryParse(lastCalcStr);
      }

      AppLogger.info(
          'Loaded persisted budget: ${allocation.length} habits, $_currentTotalBudget slots');
    } catch (e) {
      AppLogger.error('Failed to load persisted budget', e);
    }
  }
}
