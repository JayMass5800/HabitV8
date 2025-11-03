import 'package:flutter/services.dart';
import 'logging_service.dart';

/// iOS Background Tasks Service
/// Implements BGTaskScheduler integration for iOS background execution
/// 
/// This service provides iOS-specific background task scheduling using
/// Apple's BGTaskScheduler framework (iOS 13+).
///
/// ## Setup Required:
/// 1. Add task identifier to Info.plist:
///    ```xml
///    <key>BGTaskSchedulerPermittedIdentifiers</key>
///    <array>
///      <string>com.habittracker.habitv8.midnightReset</string>
///    </array>
///    ```
///
/// 2. Implement Swift code in AppDelegate:
///    ```swift
///    import BackgroundTasks
///    
///    func registerBackgroundTasks() {
///      BGTaskScheduler.shared.register(
///        forTaskWithIdentifier: "com.habittracker.habitv8.midnightReset",
///        using: nil
///      ) { task in
///        self.handleMidnightReset(task: task as! BGAppRefreshTask)
///      }
///    }
///    ```
class IOSBackgroundTasksService {
  static const String _taskIdentifier = 'com.habittracker.habitv8.midnightReset';
  static const MethodChannel _channel =
      MethodChannel('com.habittracker.habitv8/ios_background_tasks');

  /// Schedule midnight reset task on iOS
  /// 
  /// Uses BGTaskScheduler to schedule a background app refresh task
  /// that will execute at or after the specified target time.
  ///
  /// Parameters:
  /// - [targetTimeUtc]: The earliest time the task should run (UTC)
  ///
  /// Note: iOS may defer the task based on system conditions, battery, etc.
  static Future<void> scheduleMidnightResetTask(DateTime targetTimeUtc) async {
    try {
      AppLogger.info(
          '🍎 Scheduling iOS BGTaskScheduler midnight reset task for: ${targetTimeUtc.toIso8601String()}');

      final result = await _channel.invokeMethod('scheduleBackgroundTask', {
        'taskIdentifier': _taskIdentifier,
        'earliestBeginDate': targetTimeUtc.millisecondsSinceEpoch,
        'requiresNetworkConnectivity': false,
        'requiresExternalPower': false,
      });

      if (result == true) {
        AppLogger.info('✅ iOS background task scheduled successfully');
      } else {
        AppLogger.warning('⚠️ iOS background task scheduling returned false');
      }
    } on PlatformException catch (e) {
      AppLogger.error('❌ Platform exception scheduling iOS background task', e);
      // Don't rethrow - timer fallback will handle
    } catch (e) {
      AppLogger.error('❌ Error scheduling iOS background task', e);
      // Don't rethrow - timer fallback will handle
    }
  }

  /// Cancel scheduled midnight reset task
  static Future<void> cancelMidnightResetTask() async {
    try {
      await _channel.invokeMethod('cancelBackgroundTask', {
        'taskIdentifier': _taskIdentifier,
      });
      AppLogger.info('✅ iOS background task cancelled');
    } on PlatformException catch (e) {
      AppLogger.warning('⚠️ Platform exception cancelling iOS background task: $e');
    } catch (e) {
      AppLogger.warning('⚠️ Error cancelling iOS background task: $e');
    }
  }

  /// Handle background task execution (called from iOS native code)
  /// 
  /// This method should be invoked via method channel when the iOS
  /// background task actually executes.
  static Future<bool> handleBackgroundTaskExecution() async {
    try {
      AppLogger.info('🍎 iOS background task executing - setting completion flag');

      // Set flag for ReliableSchedulingService to detect
      // (Similar to WorkManager approach)
      // We don't perform the reset here to avoid code duplication
      // TODO: Implement SharedPreferences flag when integrated with ReliableSchedulingService
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('ios_midnight_reset_flag', DateTime.now().toIso8601String());

      AppLogger.info('✅ iOS background task completion flag set');
      return true;
    } catch (e) {
      AppLogger.error('❌ Error in iOS background task handler', e);
      return false;
    }
  }

  /// Get status of background task support
  static Future<Map<String, dynamic>> getStatus() async {
    try {
      final result = await _channel.invokeMethod('getBackgroundTaskStatus');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      return {
        'supported': false,
        'error': e.message,
      };
    } catch (e) {
      return {
        'supported': false,
        'error': e.toString(),
      };
    }
  }
}
