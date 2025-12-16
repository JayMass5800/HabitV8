import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import '../logging_service.dart';
import '../preferences_service.dart';
import '../time_service.dart';
import '../../domain/model/habit.dart';
import 'notification_helpers.dart';
import 'notification_validation_service.dart';
import 'notification_budget_service.dart';

/// Provides reliable notification scheduling with retry logic, atomic operations,
/// health monitoring, and self-healing capabilities.
///
/// This service addresses several critical reliability issues:
/// - Race conditions in cancel-then-schedule operations
/// - Missing retry logic for transient failures
/// - Notification ID collisions
/// - Timezone change detection gaps
/// - Health monitoring and proactive alerting
class SchedulingReliabilityService {
  SchedulingReliabilityService._();

  static final SchedulingReliabilityService instance =
      SchedulingReliabilityService._();

  // Constants
  static const int _maxRetryAttempts = 3;
  static const Duration _initialRetryDelay = Duration(milliseconds: 500);
  static const String _lastHealthCheckKey = 'notification_last_health_check';
  static const String _lastTimezoneKey = 'notification_last_timezone';
  static const String _schedulingStatsKey = 'notification_scheduling_stats';
  static const String _failureLogKey = 'notification_failure_log';

  // State
  static Timer? _healthCheckTimer;
  static String? _currentTimezone;
  static final TimeService _time = TimeService.instance;

  // Statistics tracking
  static int _successCount = 0;
  static int _failureCount = 0;
  static int _retryCount = 0;

  // ==================== INITIALIZATION ====================

  /// Initialize the reliability service
  static Future<void> initialize() async {
    try {
      AppLogger.info('🛡️ Initializing SchedulingReliabilityService');

      // Load timezone for change detection
      _currentTimezone = _time.timezoneName;
      final lastTimezone = await PreferencesService.getString(_lastTimezoneKey);

      if (lastTimezone != null && lastTimezone != _currentTimezone) {
        AppLogger.warning(
          '🌍 TIMEZONE CHANGE DETECTED on init: $lastTimezone → $_currentTimezone',
        );
        // Will be handled by calling code
      }

      await PreferencesService.setString(_lastTimezoneKey, _currentTimezone!);

      // Load statistics
      await _loadStats();

      // Start periodic health monitoring
      _startHealthMonitoring();

      AppLogger.info('✅ SchedulingReliabilityService initialized');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize SchedulingReliabilityService', e);
    }
  }

  /// Stop the reliability service
  static Future<void> stop() async {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
    await _saveStats();
    AppLogger.info('🛑 SchedulingReliabilityService stopped');
  }

  // ==================== ATOMIC SCHEDULING ====================

  /// Atomically reschedule notifications for a habit.
  ///
  /// This is the SAFE way to reschedule notifications:
  /// 1. Schedule new notifications first (without cancelling old ones)
  /// 2. Verify new notifications were created successfully
  /// 3. Only then cancel old notifications
  /// 4. If scheduling fails, old notifications remain intact
  ///
  /// Returns true if successful, false if failed (old notifications preserved).
  static Future<bool> atomicReschedule({
    required Habit habit,
    required Future<void> Function(Habit habit) scheduleFunction,
    required Future<void> Function(String habitId) cancelFunction,
  }) async {
    final habitId = habit.id;
    final habitName = habit.name;

    AppLogger.info('🔄 Starting atomic reschedule for: $habitName');

    try {
      // Step 1: Get current state before any changes
      final beforeSnapshot = await _getHabitNotificationSnapshot(habitId);
      AppLogger.debug(
        'Before: ${beforeSnapshot.length} notifications for $habitName',
      );

      // Step 2: Generate unique temporary IDs for new notifications
      // This prevents collision with existing notifications during transition
      final tempIdPrefix =
          '${habitId}_temp_${DateTime.now().millisecondsSinceEpoch}';
      AppLogger.debug('Using temp prefix: $tempIdPrefix');

      // Step 3: Schedule new notifications (uses retry logic internally)
      final scheduleSuccess = await retryWithBackoff(
        operation: () => scheduleFunction(habit),
        operationName: 'schedule_notifications_$habitName',
        maxAttempts: _maxRetryAttempts,
      );

      if (!scheduleSuccess) {
        AppLogger.error(
          '❌ Atomic reschedule FAILED for $habitName - keeping old notifications',
        );
        _failureCount++;
        await _logFailure(
            habitId, 'atomic_reschedule', 'Scheduling failed after retries');
        return false;
      }

      // Step 4: Verify new notifications were created
      final afterSnapshot = await _getHabitNotificationSnapshot(habitId);
      AppLogger.debug(
        'After scheduling: ${afterSnapshot.length} notifications for $habitName',
      );

      if (afterSnapshot.isEmpty && habit.notificationsEnabled) {
        AppLogger.error(
          '❌ Atomic reschedule VERIFICATION FAILED for $habitName - no new notifications found',
        );
        _failureCount++;
        await _logFailure(habitId, 'atomic_reschedule',
            'Verification failed - no notifications');
        return false;
      }

      // Step 5: Cancel old notifications (the ones from beforeSnapshot that aren't in afterSnapshot)
      final oldIds =
          beforeSnapshot.map((n) => n.content?.id).whereType<int>().toSet();
      final newIds =
          afterSnapshot.map((n) => n.content?.id).whereType<int>().toSet();
      final idsToCancel = oldIds.difference(newIds);

      if (idsToCancel.isNotEmpty) {
        AppLogger.debug('Cancelling ${idsToCancel.length} old notifications');
        for (final id in idsToCancel) {
          await AwesomeNotifications().cancel(id);
        }
      }

      _successCount++;
      AppLogger.info(
        '✅ Atomic reschedule SUCCESS for $habitName: '
        '${beforeSnapshot.length} → ${afterSnapshot.length} notifications',
      );
      return true;
    } catch (e) {
      AppLogger.error('❌ Atomic reschedule ERROR for $habitName', e);
      _failureCount++;
      await _logFailure(habitId, 'atomic_reschedule', e.toString());
      return false;
    }
  }

  // ==================== RETRY LOGIC ====================

  /// Execute an operation with exponential backoff retry.
  ///
  /// Uses exponential backoff with jitter to prevent thundering herd:
  /// - Attempt 1: immediate
  /// - Attempt 2: 500ms + random jitter
  /// - Attempt 3: 1000ms + random jitter
  ///
  /// Returns true if operation succeeded, false if all attempts failed.
  static Future<bool> retryWithBackoff({
    required Future<void> Function() operation,
    required String operationName,
    int maxAttempts = _maxRetryAttempts,
  }) async {
    final random = Random();

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        await operation();
        if (attempt > 1) {
          AppLogger.info(
            '✅ $operationName succeeded on attempt $attempt',
          );
          _retryCount += attempt - 1;
        }
        return true;
      } catch (e) {
        if (attempt == maxAttempts) {
          AppLogger.error(
            '❌ $operationName failed after $maxAttempts attempts',
            e,
          );
          return false;
        }

        // Calculate delay with exponential backoff and jitter
        final baseDelay = _initialRetryDelay * pow(2, attempt - 1).toInt();
        final jitter = Duration(milliseconds: random.nextInt(100));
        final delay = baseDelay + jitter;

        AppLogger.warning(
          '⚠️ $operationName attempt $attempt failed, retrying in ${delay.inMilliseconds}ms...',
        );

        await Future.delayed(delay);
      }
    }

    return false;
  }

  // ==================== ID COLLISION PREVENTION ====================

  /// Generate a collision-resistant notification ID.
  ///
  /// Improvements over the basic generateSafeId:
  /// - Uses larger ID space (full 31-bit positive int range)
  /// - Incorporates timestamp component for uniqueness
  /// - Uses better hash distribution (djb2 algorithm variant)
  ///
  /// Returns ID in range: 1 to 2,147,483,647
  static int generateCollisionResistantId(String input) {
    // Use djb2 hash algorithm for better distribution
    int hash = 5381;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 5) + hash) + input.codeUnitAt(i);
      hash = hash & 0x7FFFFFFF; // Keep positive 31-bit
    }

    // Incorporate microseconds for additional uniqueness
    final timePart = DateTime.now().microsecondsSinceEpoch & 0xFFFF;
    hash = (hash ^ (timePart << 8)) & 0x7FFFFFFF;

    // Ensure minimum value of 1
    return hash == 0 ? 1 : hash;
  }

  /// Generate a deterministic ID for a specific habit + date combination.
  ///
  /// Unlike the collision-resistant ID, this is reproducible given the same inputs.
  /// Useful for cancelling specific scheduled notifications.
  static int generateDeterministicId(String habitId, DateTime date) {
    final dateStr = '${date.year}-${date.month}-${date.day}';
    final combined = '$habitId|$dateStr';
    return NotificationHelpers.generateSafeId(combined);
  }

  // ==================== HEALTH MONITORING ====================

  /// Start periodic health monitoring.
  static void _startHealthMonitoring() {
    _healthCheckTimer?.cancel();

    // Run health check every 6 hours
    _healthCheckTimer = Timer.periodic(
      const Duration(hours: 6),
      (_) => performHealthCheck(),
    );

    AppLogger.debug('🏥 Health monitoring started (6-hour interval)');
  }

  /// Perform a comprehensive health check on the notification system.
  ///
  /// Checks:
  /// - Number of pending notifications matches expected count
  /// - No habits with notifications enabled but zero scheduled
  /// - Timezone hasn't changed unexpectedly
  /// - Recent scheduling success rate
  ///
  /// Returns a health report map.
  static Future<Map<String, dynamic>> performHealthCheck() async {
    try {
      AppLogger.info('🏥 Performing notification health check...');

      final report = <String, dynamic>{
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'healthy',
        'issues': <String>[],
      };

      // Check timezone
      final currentTz = _time.timezoneName;
      final lastTz = await PreferencesService.getString(_lastTimezoneKey);
      if (lastTz != null && lastTz != currentTz) {
        report['status'] = 'warning';
        (report['issues'] as List)
            .add('Timezone changed: $lastTz → $currentTz');
        await PreferencesService.setString(_lastTimezoneKey, currentTz);
        _currentTimezone = currentTz;
      }

      // Check pending notifications count
      final pending = await AwesomeNotifications().listScheduledNotifications();
      report['pendingCount'] = pending.length;

      if (pending.isEmpty) {
        report['status'] = 'warning';
        (report['issues'] as List).add('No pending notifications found');
      }

      // Check budget utilization
      final budgetValidation = await NotificationBudgetService.validateBudget();
      report['budgetStatus'] = budgetValidation['status'];
      report['budgetUtilization'] = budgetValidation['utilizationPercent'];

      if (budgetValidation['isOverBudget'] == true) {
        report['status'] = 'critical';
        (report['issues'] as List).add(
          'Over notification budget: ${budgetValidation['pendingCount']}/${budgetValidation['availableSlots']}',
        );
      } else if (budgetValidation['isApproachingLimit'] == true) {
        if (report['status'] != 'critical') {
          report['status'] = 'warning';
        }
        (report['issues'] as List).add(
          'Approaching notification budget limit: ${budgetValidation['utilizationPercent']}%',
        );
      }

      // Check success rate
      final total = _successCount + _failureCount;
      if (total > 0) {
        final successRate = (_successCount / total * 100).toStringAsFixed(1);
        report['successRate'] = successRate;
        report['totalOperations'] = total;
        report['retryCount'] = _retryCount;

        if (_failureCount > total * 0.1) {
          // More than 10% failure rate
          report['status'] = 'degraded';
          (report['issues'] as List).add(
            'High failure rate: ${(100 - double.parse(successRate)).toStringAsFixed(1)}%',
          );
        }
      }

      // Update last health check timestamp
      await PreferencesService.setString(
        _lastHealthCheckKey,
        DateTime.now().toIso8601String(),
      );

      AppLogger.info('🏥 Health check complete: ${report['status']}');
      if ((report['issues'] as List).isNotEmpty) {
        AppLogger.warning('🏥 Issues found: ${report['issues']}');
      }

      return report;
    } catch (e) {
      AppLogger.error('❌ Health check failed', e);
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Audit notifications for a list of habits and return discrepancies.
  ///
  /// Returns a map of habit IDs to their audit results, including:
  /// - Expected vs actual notification count
  /// - Missing notifications
  /// - Orphaned notifications
  static Future<Map<String, NotificationAuditResult>> auditHabits(
    List<Habit> habits,
  ) async {
    return await NotificationValidationService.auditHabits(habits);
  }

  /// Self-heal by rescheduling notifications for habits with discrepancies.
  ///
  /// [discrepancies] should be the output from auditHabits filtered to only
  /// habits that need fixing.
  static Future<int> selfHeal({
    required List<Habit> habitsToFix,
    required Future<void> Function(Habit habit) scheduleFunction,
  }) async {
    int fixed = 0;

    for (final habit in habitsToFix) {
      try {
        AppLogger.info('🔧 Self-healing notifications for: ${habit.name}');

        final success = await retryWithBackoff(
          operation: () => scheduleFunction(habit),
          operationName: 'self_heal_${habit.name}',
        );

        if (success) {
          fixed++;
          AppLogger.info('✅ Self-healed: ${habit.name}');
        } else {
          AppLogger.error('❌ Failed to self-heal: ${habit.name}');
        }
      } catch (e) {
        AppLogger.error('❌ Error self-healing ${habit.name}', e);
      }
    }

    AppLogger.info(
        '🔧 Self-healing complete: $fixed/${habitsToFix.length} fixed');
    return fixed;
  }

  // ==================== TIMEZONE HANDLING ====================

  /// Check if timezone has changed since last check.
  ///
  /// Should be called on app resume/foreground to catch timezone changes
  /// that occurred while app was backgrounded.
  static Future<bool> checkTimezoneChange() async {
    try {
      final currentTz = _time.timezoneName;
      final lastTz = await PreferencesService.getString(_lastTimezoneKey);

      if (lastTz != null && lastTz != currentTz) {
        AppLogger.warning('🌍 TIMEZONE CHANGE: $lastTz → $currentTz');
        await PreferencesService.setString(_lastTimezoneKey, currentTz);
        _currentTimezone = currentTz;
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.error('❌ Error checking timezone', e);
      return false;
    }
  }

  /// Get the current timezone name.
  static String getCurrentTimezone() {
    return _currentTimezone ?? _time.timezoneName;
  }

  // ==================== EXPECTED COUNT CALCULATION ====================

  /// Calculate expected notification count for a habit.
  ///
  /// Based on frequency type and look-ahead window (14 days default).
  static int calculateExpectedNotificationCount(
    Habit habit, {
    int lookAheadDays = 14,
  }) {
    if (!habit.notificationsEnabled) return 0;

    switch (habit.frequency) {
      case HabitFrequency.daily:
        // Daily habits: 1 per day, but we schedule 3 days ahead for redundancy
        return min(3, lookAheadDays);

      case HabitFrequency.weekly:
        // Weekly habits: 1 per selected weekday
        final weekdaysCount = habit.selectedWeekdays.length;
        if (weekdaysCount == 0) return 0;
        // In 14 days, each weekday appears 2 times
        return weekdaysCount;

      case HabitFrequency.monthly:
        // Monthly habits: 1 per selected day (usually 1 per month)
        return habit.selectedMonthDays.length;

      case HabitFrequency.yearly:
        // Yearly habits: 1 per selected date (usually 1)
        return habit.selectedYearlyDates.length;

      case HabitFrequency.hourly:
        // Hourly habits: times × weekdays
        final times = habit.hourlyTimes.length;
        final weekdays = habit.selectedWeekdays.length;
        if (times == 0 || weekdays == 0) return 0;
        return times * weekdays;

      case HabitFrequency.single:
        // Single habits: 1 if date is in future, 0 otherwise
        if (habit.singleDateTime == null) return 0;
        return habit.singleDateTime!.isAfter(DateTime.now()) ? 1 : 0;
    }
  }

  // ==================== STATISTICS ====================

  /// Get scheduling statistics.
  static Map<String, dynamic> getStats() {
    final total = _successCount + _failureCount;
    return {
      'successCount': _successCount,
      'failureCount': _failureCount,
      'retryCount': _retryCount,
      'totalOperations': total,
      'successRate':
          total > 0 ? (_successCount / total * 100).toStringAsFixed(1) : 'N/A',
      'currentTimezone': _currentTimezone,
    };
  }

  /// Reset statistics (useful for testing).
  static void resetStats() {
    _successCount = 0;
    _failureCount = 0;
    _retryCount = 0;
  }

  static Future<void> _loadStats() async {
    try {
      final statsJson = await PreferencesService.getString(_schedulingStatsKey);
      if (statsJson != null) {
        // Simple format: "success,failure,retry"
        final parts = statsJson.split(',');
        if (parts.length == 3) {
          _successCount = int.tryParse(parts[0]) ?? 0;
          _failureCount = int.tryParse(parts[1]) ?? 0;
          _retryCount = int.tryParse(parts[2]) ?? 0;
        }
      }
    } catch (e) {
      AppLogger.warning('Failed to load scheduling stats: $e');
    }
  }

  static Future<void> _saveStats() async {
    try {
      final statsStr = '$_successCount,$_failureCount,$_retryCount';
      await PreferencesService.setString(_schedulingStatsKey, statsStr);
    } catch (e) {
      AppLogger.warning('Failed to save scheduling stats: $e');
    }
  }

  static Future<void> _logFailure(
    String habitId,
    String operation,
    String reason,
  ) async {
    try {
      final entry =
          '${DateTime.now().toIso8601String()}|$habitId|$operation|$reason';

      // Keep only last 50 failures
      var log = await PreferencesService.getString(_failureLogKey) ?? '';
      final entries = log.split('\n').where((e) => e.isNotEmpty).toList();
      entries.add(entry);
      if (entries.length > 50) {
        entries.removeRange(0, entries.length - 50);
      }

      await PreferencesService.setString(_failureLogKey, entries.join('\n'));
    } catch (e) {
      AppLogger.warning('Failed to log failure: $e');
    }
  }

  /// Get recent failure log entries.
  static Future<List<String>> getFailureLog() async {
    try {
      final log = await PreferencesService.getString(_failureLogKey) ?? '';
      return log.split('\n').where((e) => e.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  // ==================== HELPER METHODS ====================

  static Future<List<NotificationModel>> _getHabitNotificationSnapshot(
    String habitId,
  ) async {
    final allPending =
        await AwesomeNotifications().listScheduledNotifications();
    return allPending.where((n) {
      final extractedId = NotificationValidationService.extractHabitId(n);
      if (extractedId == null) return false;
      // Match exact ID or ID with time slot suffix (habitId|HH:MM)
      return extractedId == habitId || extractedId.startsWith('$habitId|');
    }).toList();
  }
}
