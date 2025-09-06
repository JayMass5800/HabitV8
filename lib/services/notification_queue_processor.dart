// Notification Queue Processor for HabitV8
// Handles notification scheduling completely off the main thread

import 'dart:async';
import 'logging_service.dart';

/// A specialized processor for handling notification scheduling in the background
/// to prevent main thread blocking during app startup
class NotificationQueueProcessor {
  static Timer? _processingTimer;
  static final List<NotificationTask> _taskQueue = [];
  static bool _isProcessing = false;
  static int _processedCount = 0;
  static int _failedCount = 0;

  // Callback function for scheduling notifications (to avoid circular imports)
  static Future<void> Function({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  })? _scheduleNotificationCallback;

  /// Set the callback function for scheduling notifications
  static void setScheduleNotificationCallback(
    Future<void> Function({
      required int id,
      required String habitId,
      required String title,
      required String body,
      required DateTime scheduledTime,
    }) callback,
  ) {
    _scheduleNotificationCallback = callback;
  }

  /// Add a notification task to the queue for background processing
  static void enqueueNotificationTask(NotificationTask task) {
    _taskQueue.add(task);
    AppLogger.debug(
        '📥 Queued notification task: ${task.habitName} (queue size: ${_taskQueue.length})');

    // Start processing if not already running
    if (!_isProcessing) {
      _startProcessing();
    }
  }

  /// Start the background processing of queued notification tasks
  static void _startProcessing() {
    if (_isProcessing) return;

    _isProcessing = true;
    _processedCount = 0;
    _failedCount = 0;

    AppLogger.info('🚀 Starting notification queue processor');

    // Use a timer to process tasks with significant delays to prevent main thread blocking
    _processingTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) async {
      await _processNextTask();

      // Stop processing when queue is empty
      if (_taskQueue.isEmpty) {
        _stopProcessing();
      }
    });
  }

  /// Process the next task in the queue
  static Future<void> _processNextTask() async {
    if (_taskQueue.isEmpty) return;

    final task = _taskQueue.removeAt(0);

    try {
      AppLogger.debug('🔄 Processing notification for: ${task.habitName}');

      // Add a small delay before processing to ensure main thread responsiveness
      await Future.delayed(const Duration(milliseconds: 100));

      // Use the callback to schedule the notification
      if (_scheduleNotificationCallback != null) {
        await _scheduleNotificationCallback!(
          id: task.id,
          habitId: task.habitId,
          title: task.title,
          body: task.body,
          scheduledTime: task.scheduledTime,
        );
      } else {
        throw Exception('Schedule notification callback not set');
      }

      _processedCount++;
      AppLogger.debug(
          '✅ Successfully processed notification for: ${task.habitName}');

      // Additional delay after successful processing
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      _failedCount++;
      AppLogger.warning(
          '❌ Failed to process notification for ${task.habitName}: $e');
    }
  }

  /// Stop the background processing
  static void _stopProcessing() {
    _processingTimer?.cancel();
    _processingTimer = null;
    _isProcessing = false;

    AppLogger.info(
        '🏁 Notification queue processing completed. Processed: $_processedCount, Failed: $_failedCount');
  }

  /// Get current queue status
  static Map<String, dynamic> getQueueStatus() {
    return {
      'isProcessing': _isProcessing,
      'queueSize': _taskQueue.length,
      'processedCount': _processedCount,
      'failedCount': _failedCount,
    };
  }

  /// Clear the queue (use with caution)
  static void clearQueue() {
    _taskQueue.clear();
    _stopProcessing();
    AppLogger.warning('🧹 Notification queue cleared');
  }

  /// Dispose all resources properly - call this when app is shutting down
  static void dispose() {
    AppLogger.info('🔄 Disposing NotificationQueueProcessor resources...');

    // Cancel the processing timer if active
    if (_processingTimer != null && _processingTimer!.isActive) {
      _processingTimer!.cancel();
    }
    _processingTimer = null;

    // Clear the task queue
    _taskQueue.clear();

    // Reset state
    _isProcessing = false;
    _processedCount = 0;
    _failedCount = 0;

    // Clear the callback
    _scheduleNotificationCallback = null;

    AppLogger.info('✅ NotificationQueueProcessor disposed successfully');
  }

  /// Process all habits for notification scheduling using the queue
  static Future<void> processHabitsForNotifications(
      List<dynamic> habits) async {
    AppLogger.info(
        '📋 Queuing ${habits.length} habits for notification processing');

    for (final habit in habits) {
      // Only queue if notifications or alarms are enabled
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        // Calculate next notification time
        final now = DateTime.now();
        final hour = habit.reminderTime?.hour ?? 9;
        final minute = habit.reminderTime?.minute ?? 0;

        DateTime nextNotification = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // If the time has passed today, schedule for tomorrow
        if (nextNotification.isBefore(now)) {
          nextNotification = nextNotification.add(const Duration(days: 1));
        }

        final task = NotificationTask(
          id: _generateSafeId(habit.id),
          habitId: habit.id.toString(),
          habitName: habit.name,
          title: '🎯 ${habit.name}',
          body: 'Time to complete your daily habit! Keep your streak going.',
          scheduledTime: nextNotification,
        );

        enqueueNotificationTask(task);

        // Small delay between queuing to prevent overwhelming
        await Future.delayed(const Duration(milliseconds: 10));
      }
    }

    AppLogger.info('📤 Finished queuing habits for notification processing');
  }

  /// Generate a safe ID for notifications (copied from NotificationService to avoid circular imports)
  static int _generateSafeId(dynamic habitId) {
    // Convert habit ID to a safe integer for notifications
    final idString = habitId.toString();
    int hash = 0;
    for (int i = 0; i < idString.length; i++) {
      hash = ((hash << 5) - hash + idString.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    // Ensure the ID is within the valid range for notifications (0 to 2^31-1)
    return hash.abs() % 2147483647;
  }
}

/// Represents a notification task to be processed
class NotificationTask {
  final int id;
  final String habitId;
  final String habitName;
  final String title;
  final String body;
  final DateTime scheduledTime;

  NotificationTask({
    required this.id,
    required this.habitId,
    required this.habitName,
    required this.title,
    required this.body,
    required this.scheduledTime,
  });

  @override
  String toString() {
    return 'NotificationTask(habitName: $habitName, scheduledTime: $scheduledTime)';
  }
}
