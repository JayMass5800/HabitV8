// Performance optimization service for HabitV8
// Helps manage heavy operations to prevent main thread blocking

import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

class PerformanceService {
  static const int _maxConcurrentOperations = 3;
  static int _currentOperations = 0;
  static final List<Completer> _operationQueue = [];

  /// Execute a heavy operation with performance monitoring
  static Future<T> executeHeavyOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    Duration? timeout,
    bool useIsolate = false,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Wait for available slot if too many operations are running
      if (_currentOperations >= _maxConcurrentOperations) {
        final completer = Completer<void>();
        _operationQueue.add(completer);
        await completer.future;
      }

      _currentOperations++;

      T result;
      if (useIsolate && !kIsWeb) {
        // Use isolate for CPU-intensive operations (not available on web)
        result = await _executeInIsolate(operation);
      } else {
        // Execute with timeout if specified
        if (timeout != null) {
          result = await operation().timeout(timeout);
        } else {
          result = await operation();
        }
      }

      stopwatch.stop();

      // Log performance if operation took too long
      if (stopwatch.elapsedMilliseconds > 100) {
        AppLogger.warning(
          'Heavy operation "$operationName" took ${stopwatch.elapsedMilliseconds}ms',
        );
      } else {
        AppLogger.debug(
          'Operation "$operationName" completed in ${stopwatch.elapsedMilliseconds}ms',
        );
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        'Operation "$operationName" failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    } finally {
      _currentOperations--;

      // Process next operation in queue
      if (_operationQueue.isNotEmpty) {
        final nextCompleter = _operationQueue.removeAt(0);
        nextCompleter.complete();
      }
    }
  }

  /// Execute operation in isolate (for CPU-intensive tasks)
  static Future<T> _executeInIsolate<T>(Future<T> Function() operation) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
      final sendPort = await receivePort.first as SendPort;

      final responsePort = ReceivePort();
      sendPort.send([responsePort.sendPort, operation]);

      final result = await responsePort.first;
      if (result is Exception) {
        throw result;
      }

      return result as T;
    } finally {
      receivePort.close();
    }
  }

  /// Entry point for isolate execution
  static void _isolateEntryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final message in port) {
      final responsePort = message[0] as SendPort;
      final operation = message[1] as Future Function();

      try {
        final result = await operation();
        responsePort.send(result);
      } catch (e) {
        responsePort.send(e);
      }

      break;
    }
  }

  /// Execute operations in batches to prevent main thread blocking
  static Future<List<T>> executeBatch<T>(
    String batchName,
    List<Future<T> Function()> operations, {
    int batchSize = 5,
    Duration batchDelay = const Duration(milliseconds: 10),
  }) async {
    final results = <T>[];
    final stopwatch = Stopwatch()..start();

    try {
      for (int i = 0; i < operations.length; i += batchSize) {
        final batch = operations.skip(i).take(batchSize);

        // Add small delay between batches to prevent main thread blocking
        if (i > 0) {
          await Future.delayed(batchDelay);
        }

        final batchResults = await Future.wait(
          batch.map((op) => op()).toList(),
        );

        results.addAll(batchResults);
      }

      stopwatch.stop();
      AppLogger.debug(
        'Batch "$batchName" completed ${operations.length} operations in ${stopwatch.elapsedMilliseconds}ms',
      );

      return results;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        'Batch "$batchName" failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
      );
      rethrow;
    }
  }

  /// Debounce function calls to prevent excessive execution
  static Timer? _debounceTimer;
  static void debounce(
    String operationName,
    VoidCallback operation, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, () {
      AppLogger.debug('Executing debounced operation: $operationName');
      operation();
    });
  }

  /// Throttle function calls to limit execution frequency
  static DateTime? _lastThrottleTime;
  static void throttle(
    String operationName,
    VoidCallback operation, {
    Duration interval = const Duration(milliseconds: 100),
  }) {
    final now = DateTime.now();
    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!) >= interval) {
      _lastThrottleTime = now;
      AppLogger.debug('Executing throttled operation: $operationName');
      operation();
    }
  }

  /// Get current performance metrics
  static Map<String, dynamic> getPerformanceMetrics() {
    return {
      'currentOperations': _currentOperations,
      'queuedOperations': _operationQueue.length,
      'maxConcurrentOperations': _maxConcurrentOperations,
    };
  }

  /// Clear all queued operations (use with caution)
  static void clearQueue() {
    for (final completer in _operationQueue) {
      completer.completeError('Operation queue cleared');
    }
    _operationQueue.clear();
    AppLogger.warning('Performance service queue cleared');
  }
}
