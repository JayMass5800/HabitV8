import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logging_service.dart';
import '../../domain/model/habit_isar.dart';
import '../widget_integration_service.dart';
import 'notification_helpers.dart';
import 'notification_storage.dart';
import 'notification_scheduler.dart';

// ============================================================================
// TOP-LEVEL FUNCTIONS - Required for background isolate communication
// These MUST be top-level functions (not class methods) for Flutter's
// background notification system to work properly in release builds
// ============================================================================

/// Background notification response handler (TOP-LEVEL FUNCTION)
/// This is called when the app is not running or in background
/// MUST be a top-level function for background isolate to work!
/// 
/// ISAR VERSION - Multi-isolate safe!
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationResponseIsar(
    NotificationResponse response) async {
  try {
    AppLogger.info('🔔 BACKGROUND notification response received (Isar)');
    AppLogger.info('Background action ID: ${response.actionId}');
    AppLogger.info('Background payload: ${response.payload}');

    if (response.payload != null) {
      try {
        final payload = jsonDecode(response.payload!);
        final habitId = payload['habitId'] as String?;

        if (habitId != null) {
          AppLogger.info('Extracted habitId from payload: $habitId');

          // Process the action in background
          if (response.actionId != null) {
            AppLogger.info(
                'Processing background action: ${response.actionId}');

            // CRITICAL FIX: Try to use callback first (app might be running)
            // Android sometimes routes action button taps to background handler
            // even when app is in foreground
            final callback = NotificationActionHandlerIsar.onNotificationAction;
            final directHandler =
                NotificationActionHandlerIsar.directCompletionHandler;

            if (callback != null) {
              AppLogger.info('✅ Using callback handler (app is running)');
              callback(habitId, response.actionId!);
            } else if (directHandler != null) {
              AppLogger.info(
                  '✅ Using direct completion handler (app is running)');
              await directHandler(habitId);
            } else {
              AppLogger.info(
                  '⚠️ No handlers available, using background Isar access');
              // Open Isar in background isolate - THIS IS THE KEY ADVANTAGE!
              await NotificationActionHandlerIsar.completeHabitInBackground(
                  habitId);
            }
          }
        }
      } catch (e) {
        AppLogger.error('Error parsing background notification payload', e);
      }
    }

    AppLogger.info('✅ Background notification response processed');
  } catch (e) {
    AppLogger.error('Error in background notification handler', e);
  }
}

/// Foreground notification tap handler (TOP-LEVEL FUNCTION)
/// This is called when the app is running and notification is tapped
/// MUST be a top-level function for proper notification handling!
@pragma('vm:entry-point')
Future<void> onNotificationTappedIsar(NotificationResponse response) async {
  AppLogger.info('=== NOTIFICATION TAPPED (ISAR) - DETAILED DEBUG LOG ===');
  AppLogger.info('📱 Notification Response Details:');
  AppLogger.info('  - ID: ${response.id}');
  AppLogger.info('  - Action ID: ${response.actionId}');
  AppLogger.info('  - Payload: ${response.payload}');
  AppLogger.info('  - Input: ${response.input}');
  AppLogger.info('  - Notification Type: ${response.notificationResponseType}');
  AppLogger.info('================================================');

  if (response.payload != null) {
    try {
      AppLogger.debug('🔍 DEBUG: Attempting to parse payload JSON');
      final payload = jsonDecode(response.payload!);
      AppLogger.debug('🔍 DEBUG: Payload parsed successfully: $payload');

      final habitId =
          NotificationHelpers.extractHabitIdFromPayload(response.payload!);
      AppLogger.debug('🔍 DEBUG: Extracted habitId: $habitId');

      if (habitId != null) {
        AppLogger.debug('🔍 DEBUG: Checking if actionId is "complete"');
        if (response.actionId == 'complete') {
          AppLogger.info('✅ Complete action detected - calling handler');
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          if (callback != null) {
            AppLogger.debug(
                '🔍 DEBUG: Callback is not null, invoking callback');
            callback(habitId, 'complete');
          } else {
            AppLogger.warning(
                '⚠️ WARNING: Callback is null, cannot process action');
          }
        } else {
          AppLogger.info(
              'ℹ️ Non-complete action or no action, just opening app');
        }
      } else {
        AppLogger.warning('⚠️ WARNING: Could not extract habitId from payload');
      }
    } catch (e) {
      AppLogger.error('Error processing notification tap', e);
    }
  }
}

// ============================================================================
// NOTIFICATION ACTION HANDLER CLASS
// ============================================================================

class NotificationActionHandlerIsar {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Callback for when a notification action is triggered in foreground
  /// This is set by the main app to handle UI updates
  static void Function(String habitId, String actionId)? onNotificationAction;

  /// Direct completion handler (bypasses UI callback)
  /// Used when app is running but we want to complete habit directly
  static Future<void> Function(String habitId)? directCompletionHandler;

  /// Register the notification action callback
  static void registerActionCallback(
      void Function(String habitId, String actionId) callback) {
    onNotificationAction = callback;
    AppLogger.info('✅ Notification action callback registered (Isar)');
  }

  /// Register direct completion handler
  static void setDirectCompletionHandler(
      Future<void> Function(String habitId) handler) {
    directCompletionHandler = handler;
    AppLogger.info('✅ Direct completion handler registered (Isar)');
  }

  /// Complete a habit in background when app is not running
  /// Made public so it can be called from top-level background handler
  /// 
  /// ISAR VERSION - Multi-isolate safe! No complex workarounds needed!
  static Future<void> completeHabitInBackground(String habitId) async {
    try {
      AppLogger.info('⚙️ Completing habit in background (Isar): $habitId');

      // Open Isar in background isolate - THIS WORKS PERFECTLY WITH ISAR!
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [HabitSchema],
        directory: dir.path,
        name: 'habitv8_db',
      );

      AppLogger.info('✅ Isar opened in background isolate');

      // DEBUG: Log all habits in the database
      try {
        final allHabits = await isar.habits.where().findAll();
        AppLogger.info(
            '🔍 DEBUG: Database contains ${allHabits.length} habits');
        for (final h in allHabits) {
          AppLogger.info(
              '🔍 DEBUG: Habit in DB: id=${h.habitId}, name=${h.name}');
        }
      } catch (e) {
        AppLogger.error('🔍 DEBUG: Failed to list habits', e);
      }

      // Get the habit
      final habit = await isar.habits
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();

      if (habit == null) {
        AppLogger.warning('❌ Habit not found in background: $habitId');
        AppLogger.info(
            '🧹 This is likely an orphaned notification. Attempting to cancel it...');

        // Try to cancel the orphaned notification
        try {
          final scheduler = NotificationScheduler(_notificationsPlugin);
          await scheduler.cancelHabitNotificationsByHabitId(habitId);
          AppLogger.info(
              '✅ Cancelled orphaned notification for habit: $habitId');
        } catch (e) {
          AppLogger.error('Failed to cancel orphaned notification', e);
        }

        // Store the failed action for retry when app opens (in case it's a sync issue)
        try {
          final prefs = await SharedPreferences.getInstance();
          final pendingActions =
              prefs.getStringList('pending_habit_completions') ?? [];
          final actionData = jsonEncode({
            'habitId': habitId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
          pendingActions.add(actionData);
          await prefs.setStringList(
              'pending_habit_completions', pendingActions);
          AppLogger.info(
              '📝 Stored pending completion for retry when app opens');
        } catch (e) {
          AppLogger.error('Failed to store pending completion', e);
        }

        return;
      }

      // Mark the habit as complete for today
      // Isar transaction - automatically synced across isolates!
      await isar.writeTxn(() async {
        habit.completions.add(DateTime.now());
        await isar.habits.put(habit);
      });

      AppLogger.info('✅ Habit completed in background: ${habit.name}');

      // NO NEED FOR FLUSH - Isar handles this automatically!
      // NO NEED FOR FLAGS - Isar streams update automatically!
      
      // The main isolate will automatically see this change via Isar's
      // reactive streams - this is the POWER of Isar!

      // Update widget data
      try {
        await WidgetIntegrationService.instance.onHabitsChanged();
        AppLogger.info('✅ Widget data updated after background completion');
      } catch (e) {
        AppLogger.error('Failed to update widget data', e);
      }

      AppLogger.info('🎉 Background completion successful with Isar!');
    } catch (e, stackTrace) {
      AppLogger.error('Error completing habit in background', e, stackTrace);

      // Store the failed action for retry
      try {
        final prefs = await SharedPreferences.getInstance();
        final pendingActions =
            prefs.getStringList('pending_habit_completions') ?? [];
        final actionData = jsonEncode({
          'habitId': habitId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'error': e.toString(),
        });
        pendingActions.add(actionData);
        await prefs.setStringList('pending_habit_completions', pendingActions);
        AppLogger.info('📝 Stored failed completion for retry');
      } catch (e2) {
        AppLogger.error('Failed to store failed completion', e2);
      }
    }
  }

  /// Handle snooze action
  static Future<void> handleSnoozeAction(
    String habitId,
    int snoozeMinutes,
  ) async {
    try {
      AppLogger.info('⏰ Handling snooze for habit: $habitId');

      // Schedule a new notification after snooze delay
      final scheduler = NotificationScheduler(_notificationsPlugin);
      final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));

      // Open Isar to get habit details
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [HabitSchema],
        directory: dir.path,
        name: 'habitv8_db',
      );

      final habit = await isar.habits
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();

      if (habit != null) {
        await scheduler.scheduleNotification(
          habit: habit,
          scheduledTime: snoozeTime,
          title: '⏰ Snoozed Reminder',
          body: 'Time to complete: ${habit.name}',
        );

        AppLogger.info(
            '✅ Snoozed notification scheduled for ${snoozeTime.toString()}');
      }
    } catch (e) {
      AppLogger.error('Error handling snooze action', e);
    }
  }

  /// Process pending completions (called when app starts)
  static Future<void> processPendingCompletions(Isar isar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingActions =
          prefs.getStringList('pending_habit_completions') ?? [];

      if (pendingActions.isEmpty) {
        return;
      }

      AppLogger.info(
          '🔄 Processing ${pendingActions.length} pending completions');

      final processedActions = <String>[];

      for (final actionJson in pendingActions) {
        try {
          final action = jsonDecode(actionJson) as Map<String, dynamic>;
          final habitId = action['habitId'] as String;
          final timestamp = action['timestamp'] as int;
          final completionTime =
              DateTime.fromMillisecondsSinceEpoch(timestamp);

          // Get the habit
          final habit = await isar.habits
              .filter()
              .habitIdEqualTo(habitId)
              .findFirst();

          if (habit != null) {
            // Complete the habit
            await isar.writeTxn(() async {
              habit.completions.add(completionTime);
              await isar.habits.put(habit);
            });

            AppLogger.info('✅ Processed pending completion for: ${habit.name}');
            processedActions.add(actionJson);
          } else {
            AppLogger.warning(
                '⚠️ Habit not found for pending completion: $habitId');
            processedActions.add(actionJson); // Remove it anyway
          }
        } catch (e) {
          AppLogger.error('Error processing pending completion', e);
          // Don't add to processedActions - will retry next time
        }
      }

      // Remove processed actions
      if (processedActions.isNotEmpty) {
        pendingActions.removeWhere((action) => processedActions.contains(action));
        await prefs.setStringList('pending_habit_completions', pendingActions);
        AppLogger.info('✅ Removed ${processedActions.length} processed actions');
      }
    } catch (e) {
      AppLogger.error('Error processing pending completions', e);
    }
  }
}
