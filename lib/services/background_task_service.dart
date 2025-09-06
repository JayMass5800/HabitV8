// Background Task Service for HabitV8
// Handles heavy operations off the main thread to prevent UI blocking

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

/// Background task service that manages heavy operations to prevent main thread blocking
class BackgroundTaskService {
  static const int _maxConcurrentTasks = 2; // Reduced for better performance
  static int _currentTasks = 0;
  static final List<Completer> _taskQueue = [];
  static final Map<String, Timer> _debouncers = {};

  /// Execute a task in the background with proper queuing
  static Future<T> executeBackgroundTask<T>(
    String taskName,
    Future<T> Function() task, {
    Duration? timeout,
    bool highPriority = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // High priority tasks skip the queue
      if (!highPriority && _currentTasks >= _maxConcurrentTasks) {
        final completer = Completer<void>();
        _taskQueue.add(completer);
        await completer.future;
      }

      _currentTasks++;
      AppLogger.debug('🔄 Starting background task: $taskName');

      T result;
      if (timeout != null) {
        result = await task().timeout(timeout);
      } else {
        result = await task();
      }

      stopwatch.stop();

      // Log performance metrics
      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed > 200) {
        AppLogger.warning(
          '⚠️ Background task "$taskName" took ${elapsed}ms (consider optimization)',
        );
      } else {
        AppLogger.debug(
            '✅ Background task "$taskName" completed in ${elapsed}ms');
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        '❌ Background task "$taskName" failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    } finally {
      _currentTasks--;

      // Process next task in queue
      if (_taskQueue.isNotEmpty) {
        final nextCompleter = _taskQueue.removeAt(0);
        nextCompleter.complete();
      }
    }
  }

  /// Execute multiple tasks in optimized batches
  static Future<List<T>> executeBatchTasks<T>(
    String batchName,
    List<Future<T> Function()> tasks, {
    int batchSize = 2, // Smaller batches for better responsiveness
    Duration batchDelay = const Duration(milliseconds: 100), // Longer delays
    bool showProgress = false,
  }) async {
    final results = <T>[];
    final stopwatch = Stopwatch()..start();
    final totalTasks = tasks.length;

    try {
      AppLogger.info('🚀 Starting batch "$batchName" with $totalTasks tasks');

      for (int i = 0; i < tasks.length; i += batchSize) {
        final batch = tasks.skip(i).take(batchSize);
        final batchNumber = (i ~/ batchSize) + 1;
        final totalBatches = (tasks.length / batchSize).ceil();

        // Add delay between batches to prevent main thread blocking
        if (i > 0) {
          await Future.delayed(batchDelay);
        }

        if (showProgress) {
          AppLogger.info('📊 Processing batch $batchNumber/$totalBatches');
        }

        // Execute batch with individual error handling
        final batchResults = <T>[];
        for (final taskFunc in batch) {
          try {
            final result = await taskFunc();
            batchResults.add(result);
          } catch (e) {
            AppLogger.warning('⚠️ Task in batch "$batchName" failed: $e');
            // Continue with other tasks in the batch
          }
        }

        results.addAll(batchResults);

        // Yield control to the main thread periodically
        if (batchNumber % 3 == 0) {
          await Future.delayed(const Duration(milliseconds: 1));
        }
      }

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      AppLogger.info(
        '✅ Batch "$batchName" completed $totalTasks tasks in ${elapsed}ms (${(elapsed / totalTasks).round()}ms per task)',
      );

      return results;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        '❌ Batch "$batchName" failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    }
  }

  /// Debounce task execution to prevent excessive calls
  static void debounceTask(
    String taskName,
    VoidCallback task, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    // Cancel existing debouncer for this task
    _debouncers[taskName]?.cancel();

    // Create new debouncer
    _debouncers[taskName] = Timer(delay, () {
      AppLogger.debug('🔄 Executing debounced task: $taskName');
      try {
        task();
      } catch (e) {
        AppLogger.error('❌ Debounced task "$taskName" failed', e);
      } finally {
        _debouncers.remove(taskName);
      }
    });
  }

  /// Execute a task with automatic retry logic
  static Future<T> executeWithRetry<T>(
    String taskName,
    Future<T> Function() task, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      attempts++;
      try {
        AppLogger.debug(
            '🔄 Attempting task "$taskName" (attempt $attempts/$maxRetries)');
        return await task();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        AppLogger.warning(
          '⚠️ Task "$taskName" failed on attempt $attempts: $e',
        );

        if (attempts < maxRetries) {
          await Future.delayed(retryDelay);
        }
      }
    }

    AppLogger.error('❌ Task "$taskName" failed after $maxRetries attempts');
    throw lastException!;
  }

  /// Schedule a task to run after a delay (non-blocking)
  static void scheduleDelayedTask(
    String taskName,
    VoidCallback task,
    Duration delay,
  ) {
    Timer(delay, () {
      AppLogger.debug('⏰ Executing scheduled task: $taskName');
      try {
        task();
      } catch (e) {
        AppLogger.error('❌ Scheduled task "$taskName" failed', e);
      }
    });
  }

  /// Get current task metrics
  static Map<String, dynamic> getTaskMetrics() {
    return {
      'currentTasks': _currentTasks,
      'queuedTasks': _taskQueue.length,
      'maxConcurrentTasks': _maxConcurrentTasks,
      'activeDebouncers': _debouncers.length,
    };
  }

  /// Check if the system is under heavy load and should skip non-critical tasks
  static bool isSystemUnderHeavyLoad() {
    final metrics = getTaskMetrics();
    final currentTasks = metrics['currentTasks'] as int;
    final queuedTasks = metrics['queuedTasks'] as int;

    // Consider system under heavy load if we have max concurrent tasks running
    // and additional tasks queued
    return currentTasks >= _maxConcurrentTasks && queuedTasks > 0;
  }

  /// Clear all queued tasks and debouncers (use with caution)
  static void clearAll() {
    // Clear task queue
    for (final completer in _taskQueue) {
      completer.completeError('Task queue cleared');
    }
    _taskQueue.clear();

    // Clear debouncers
    for (final timer in _debouncers.values) {
      timer.cancel();
    }
    _debouncers.clear();

    AppLogger.warning('🧹 Background task service cleared');
  }

  /// Dispose all resources properly - call this when app is shutting down
  static void dispose() {
    AppLogger.info('🔄 Disposing BackgroundTaskService resources...');

    // Cancel all active timers
    for (final timer in _debouncers.values) {
      if (timer.isActive) {
        timer.cancel();
      }
    }
    _debouncers.clear();

    // Complete all pending tasks with cancellation
    for (final completer in _taskQueue) {
      if (!completer.isCompleted) {
        completer.completeError('Service disposed');
      }
    }
    _taskQueue.clear();

    // Reset counters
    _currentTasks = 0;

    AppLogger.info('✅ BackgroundTaskService disposed successfully');
  }

  /// Execute notification scheduling in optimized batches with aggressive throttling
  static Future<List<String>> scheduleNotificationsBatch(
    List<Future<String> Function()> notificationTasks,
  ) async {
    return await executeBatchTasks(
      'notificationScheduling',
      notificationTasks,
      batchSize: 1, // Process one notification at a time to prevent overload
      batchDelay: const Duration(
          milliseconds: 500), // Much longer delay between notifications
      showProgress: true,
    );
  }

  /// Execute notification scheduling with extreme throttling for main thread protection
  static Future<List<String>> scheduleNotificationsBatchUltraThrottled(
    List<Future<String> Function()> notificationTasks,
  ) async {
    final results = <String>[];
    final stopwatch = Stopwatch()..start();
    final totalTasks = notificationTasks.length;

    try {
      AppLogger.info(
          '🐌 Starting ultra-throttled notification scheduling with $totalTasks tasks');

      for (int i = 0; i < notificationTasks.length; i++) {
        final taskFunc = notificationTasks[i];

        // Add significant delay between each notification to prevent main thread blocking
        if (i > 0) {
          await Future.delayed(
              const Duration(seconds: 1)); // 1 second between each notification
        }

        // Yield control to main thread every notification
        await Future.delayed(const Duration(milliseconds: 1));

        try {
          AppLogger.debug('📱 Processing notification ${i + 1}/$totalTasks');
          final result = await taskFunc();
          results.add(result);

          // Additional yield after each successful notification
          await Future.delayed(const Duration(milliseconds: 10));
        } catch (e) {
          AppLogger.warning('⚠️ Notification task ${i + 1} failed: $e');
          results.add('failed:task_${i + 1}');
        }

        // Every 5 notifications, take a longer break
        if ((i + 1) % 5 == 0) {
          AppLogger.debug(
              '🛑 Taking extended break after ${i + 1} notifications');
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      stopwatch.stop();
      final elapsed = stopwatch.elapsedMilliseconds;
      AppLogger.info(
        '✅ Ultra-throttled notification scheduling completed $totalTasks tasks in ${elapsed}ms (${(elapsed / totalTasks).round()}ms per task)',
      );

      return results;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        '❌ Ultra-throttled notification scheduling failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    }
  }

  /// Execute a lightweight task that should complete quickly
  static Future<T> executeLightweightTask<T>(
    String taskName,
    Future<T> Function() task,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await task();
      stopwatch.stop();

      final elapsed = stopwatch.elapsedMilliseconds;
      if (elapsed > 50) {
        AppLogger.warning(
          '⚠️ Lightweight task "$taskName" took ${elapsed}ms (expected <50ms)',
        );
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error('❌ Lightweight task "$taskName" failed', e);
      rethrow;
    }
  }
}
