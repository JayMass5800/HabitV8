import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:home_widget/home_widget.dart';
import '../logging_service.dart';
import '../../domain/model/habit.dart';
import 'notification_helpers.dart';

// ============================================================================
// TOP-LEVEL FUNCTIONS - Required for background isolate communication
// These MUST be top-level functions (not class methods) for Flutter's
// background notification system to work properly in release builds
// ============================================================================

/// Background notification action handler (TOP-LEVEL FUNCTION)
/// This is called when the app is not running or in background
/// MUST be a top-level function for background isolate to work!
///
/// ISAR VERSION - Multi-isolate safe!
///
/// BATTERY EFFICIENCY APPROACH:
/// This handler is highly battery-efficient because:
/// 1. ON-DEMAND: Only executes when user taps "Complete" button
/// 2. MINIMAL EXECUTION: Isolate starts, updates DB, triggers widget, then shuts down
/// 3. NO PERIODIC POLLING: Avoids WorkManager periodic tasks that wake device unnecessarily
/// 4. INSTANT SHUTDOWN: No background services remain active after completion
@pragma('vm:entry-point')
Future<void> onBackgroundNotificationActionIsar(
    ReceivedAction receivedAction) async {
  try {
    AppLogger.info('🔔 BACKGROUND notification action received (Isar)');
    AppLogger.info('Background action key: ${receivedAction.buttonKeyPressed}');
    AppLogger.info('Background payload: ${receivedAction.payload}');

    // CRITICAL: Ensure Flutter binding is initialized for this background isolate
    // This allows us to use Flutter services (like path_provider) in the background
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.info('✅ Flutter binding initialized in background isolate');

    if (receivedAction.payload != null &&
        receivedAction.payload!['data'] != null) {
      try {
        final payload = jsonDecode(receivedAction.payload!['data']!);
        final rawHabitId = payload['habitId'] as String?;

        if (rawHabitId != null) {
          AppLogger.info('Extracted habitId from payload: $rawHabitId');

          // Process the action in background
          final buttonKey = receivedAction.buttonKeyPressed;
          AppLogger.info('Processing background action: $buttonKey');

          // CRITICAL FIX: Try to use callback first (app might be running)
          // Android sometimes routes action button taps to background handler
          // even when app is in foreground
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          final directHandler =
              NotificationActionHandlerIsar.directCompletionHandler;

          if (callback != null) {
            AppLogger.info('✅ Using callback handler (app is running)');
            // Extract base habitId for callback (callbacks expect base ID)
            final baseHabitId = NotificationHelpers.extractHabitIdFromPayload(
                receivedAction.payload!['data']!);
            if (baseHabitId != null) {
              callback(baseHabitId, buttonKey);
            }
          } else if (directHandler != null) {
            AppLogger.info(
                '✅ Using direct completion handler (app is running)');
            // Extract base habitId for direct handler
            final baseHabitId = NotificationHelpers.extractHabitIdFromPayload(
                receivedAction.payload!['data']!);
            if (baseHabitId != null) {
              await directHandler(baseHabitId);
            }
          } else {
            AppLogger.info(
                '⚠️ No handlers available, using background Isar access');
            // Pass RAW habitId (with time slot for hourly habits) to background handler
            await NotificationActionHandlerIsar.completeHabitInBackground(
                rawHabitId, receivedAction.payload!['data']!);
          }
        }
      } catch (e) {
        AppLogger.error('Error parsing background notification payload', e);
      }
    }

    AppLogger.info('✅ Background notification action processed');
  } catch (e) {
    AppLogger.error('Error in background notification handler', e);
  }
}

/// Foreground notification action handler (TOP-LEVEL FUNCTION)
/// This is called when the app is running and notification action is triggered
/// MUST be a top-level function for proper notification handling!
@pragma('vm:entry-point')
Future<void> onNotificationActionIsar(ReceivedAction receivedAction) async {
  AppLogger.info('=== NOTIFICATION ACTION (ISAR) - DETAILED DEBUG LOG ===');
  AppLogger.info('📱 Notification Action Details:');
  AppLogger.info('  - ID: ${receivedAction.id}');
  AppLogger.info('  - Button Key: ${receivedAction.buttonKeyPressed}');
  AppLogger.info('  - Payload: ${receivedAction.payload}');
  AppLogger.info('  - Action Type: ${receivedAction.actionType}');
  AppLogger.info('================================================');

  if (receivedAction.payload != null &&
      receivedAction.payload!['data'] != null) {
    try {
      AppLogger.debug('🔍 DEBUG: Attempting to parse payload JSON');
      final payload = jsonDecode(receivedAction.payload!['data']!);
      AppLogger.debug('🔍 DEBUG: Payload parsed successfully: $payload');

      final habitId = NotificationHelpers.extractHabitIdFromPayload(
          receivedAction.payload!['data']!);
      AppLogger.debug('🔍 DEBUG: Extracted habitId: $habitId');

      if (habitId != null) {
        AppLogger.debug('🔍 DEBUG: Checking if button key is "complete"');
        if (receivedAction.buttonKeyPressed == 'complete') {
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
        } else if (receivedAction.buttonKeyPressed == 'snooze') {
          AppLogger.info('⏰ Snooze action detected - calling handler');
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          if (callback != null) {
            callback(habitId, 'snooze');
          }
        } else {
          AppLogger.info('ℹ️ Non-action button or no button, just opening app');
        }
      } else {
        AppLogger.warning('⚠️ WARNING: Could not extract habitId from payload');
      }
    } catch (e) {
      AppLogger.error('Error processing notification action', e);
    }
  }
}

// ============================================================================
// NOTIFICATION ACTION HANDLER CLASS
// ============================================================================

/// Handles notification actions (Complete, Snooze) with Isar database
///
/// This module handles:
/// - Foreground and background notification action processing
/// - Habit completion from notifications
/// - Snooze functionality
/// - Widget updates after actions
/// - Background isolate communication
class NotificationActionHandlerIsar {
  // Callback for notification actions (set by NotificationService)
  static Function(String habitId, String actionId)? onNotificationAction;

  // Direct completion handler (bypasses UI callback)
  static Future<void> Function(String habitId)? directCompletionHandler;

  /// Complete a habit from background notification action
  ///
  /// This method runs in a background isolate and has no access to the main app state.
  /// It directly accesses the Isar database to mark the habit as complete.
  static Future<void> completeHabitInBackground(
      String rawHabitId, String payloadJson) async {
    try {
      AppLogger.info(
          '🔄 Starting background habit completion for: $rawHabitId');

      // Initialize Isar in background isolate
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [HabitSchema],
        directory: dir.path,
        inspector: false,
      );

      AppLogger.info('✅ Isar opened in background isolate');

      // Extract base habit ID (remove time slot suffix for hourly habits)
      final baseHabitId =
          NotificationHelpers.extractHabitIdFromPayload(payloadJson);
      if (baseHabitId == null) {
        AppLogger.error('Failed to extract base habit ID from payload');
        await isar.close();
        return;
      }

      // Find the habit
      final habit =
          await isar.habits.filter().idEqualTo(baseHabitId).findFirst();

      if (habit == null) {
        AppLogger.error('Habit not found in background: $baseHabitId');
        await isar.close();
        return;
      }

      AppLogger.info('✅ Found habit in background: ${habit.name}');

      // Mark habit as complete for today
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Check if already completed today
      final alreadyCompleted = habit.completions.any((completion) {
        final completionDate = DateTime(
          completion.year,
          completion.month,
          completion.day,
        );
        return completionDate.isAtSameMomentAs(today);
      });

      if (!alreadyCompleted) {
        // Add completion
        habit.completions.add(now);

        // Update streak
        habit.currentStreak = _calculateStreak(habit.completions);
        if (habit.currentStreak > habit.longestStreak) {
          habit.longestStreak = habit.currentStreak;
        }

        // Save to database
        await isar.writeTxn(() async {
          await isar.habits.put(habit);
        });

        AppLogger.info(
            '✅ Habit completed in background: ${habit.name} (Streak: ${habit.currentStreak})');

        // Update widget
        try {
          await HomeWidget.saveWidgetData(
              'last_update', DateTime.now().millisecondsSinceEpoch.toString());
          await HomeWidget.updateWidget(
            name: 'HabitTimelineWidgetProvider',
            iOSName: 'HabitTimelineWidget',
          );
          await HomeWidget.updateWidget(
            name: 'HabitCompactWidgetProvider',
            iOSName: 'HabitCompactWidget',
          );
          AppLogger.info('✅ Widget updated from background');
        } catch (e) {
          AppLogger.error('Failed to update widget from background', e);
        }
      } else {
        AppLogger.info('Habit already completed today: ${habit.name}');
      }

      await isar.close();
      AppLogger.info('✅ Background habit completion finished');
    } catch (e) {
      AppLogger.error('Error completing habit in background', e);
    }
  }

  /// Calculate current streak from completions
  static int _calculateStreak(List<DateTime> completions) {
    if (completions.isEmpty) return 0;

    // Sort completions in descending order
    final sorted = List<DateTime>.from(completions)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    final today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    for (final completion in sorted) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );

      if (completionDate.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (completionDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  /// Initialize the notification action handler
  static Future<void> initialize({
    required Function(String habitId, String actionId) onAction,
    required Future<void> Function(String habitId) onDirectCompletion,
  }) async {
    onNotificationAction = onAction;
    directCompletionHandler = onDirectCompletion;

    AppLogger.info('✅ NotificationActionHandlerIsar initialized');
  }

  /// Reset the handler (for testing)
  static void reset() {
    onNotificationAction = null;
    directCompletionHandler = null;
  }

  /// Process pending completions (no-op for awesome_notifications)
  /// awesome_notifications processes actions immediately, so there's nothing to process
  static Future<void> processPendingCompletions() async {
    AppLogger.debug(
        'Processing pending completions (no-op for awesome_notifications)');
  }

  /// Handle snooze action for a habit
  static Future<void> handleSnoozeAction(
      String habitId, String habitName) async {
    try {
      AppLogger.info('⏰ Handling snooze action for habit: $habitName');

      // Schedule a new notification 10 minutes from now
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      final snoozeId =
          NotificationHelpers.generateSnoozeNotificationId(habitId);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: snoozeId,
          channelKey: 'habit_reminders',
          title: 'Snoozed: $habitName',
          body: 'Time to complete your habit!',
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.Default,
          payload: {
            'data': jsonEncode({'habitId': habitId})
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'complete',
            label: 'Complete',
            actionType: ActionType.Default,
          ),
          NotificationActionButton(
            key: 'snooze',
            label: 'Snooze',
            actionType: ActionType.Default,
          ),
        ],
        schedule: NotificationCalendar.fromDate(date: snoozeTime),
      );

      AppLogger.info('✅ Snooze notification scheduled for: $snoozeTime');
    } catch (e) {
      AppLogger.error('Error handling snooze action', e);
    }
  }
}
