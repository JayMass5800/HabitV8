import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import '../logging_service.dart';
import '../../domain/model/habit.dart';
import '../../domain/model/scheduled_notification.dart';
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

    // When user taps action button, notification is auto-dismissed
    // System automatically stops the alarm sound when notification is dismissed
    if (receivedAction.buttonKeyPressed == 'complete' ||
        receivedAction.buttonKeyPressed == 'snooze' ||
        receivedAction.buttonKeyPressed == 'snooze_alarm') {
      AppLogger.info('✅ Alarm action received - notification auto-dismissing');
    }

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
            // CRITICAL: Pass RAW habitId (with time slot for hourly habits)
            // The callback handler needs the full "habitId|HH:mm" format to properly
            // identify which time slot to complete for hourly habits
            callback(rawHabitId, buttonKey);
          } else if (directHandler != null) {
            AppLogger.info(
                '✅ Using direct completion handler (app is running)');
            // CRITICAL: Pass RAW habitId (with time slot for hourly habits)
            await directHandler(rawHabitId);
          } else {
            AppLogger.info(
                '⚠️ No handlers available, using background Isar access');
            // Handle different actions in background
            if (buttonKey == 'complete') {
              // Pass RAW habitId (with time slot for hourly habits) to background handler
              await NotificationActionHandlerIsar.completeHabitInBackground(
                  rawHabitId, receivedAction.payload!['data']!);
            } else if (buttonKey == 'snooze' || buttonKey == 'snooze_alarm') {
              // Handle snooze in background
              await NotificationActionHandlerIsar.snoozeAlarmInBackground(
                  rawHabitId, receivedAction.payload!['data']!);
            }
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

      // CRITICAL: Get RAW habitId (with time slot for hourly habits)
      // For hourly habits, this will be in format "habitId|HH:mm"
      final rawHabitId = payload['habitId'] as String?;
      AppLogger.debug('🔍 DEBUG: Raw habitId from payload: $rawHabitId');

      if (rawHabitId != null) {
        AppLogger.debug('🔍 DEBUG: Checking if button key is "complete"');

        // System automatically stops alarm sound when notification is dismissed via button
        if (receivedAction.buttonKeyPressed == 'complete' ||
            receivedAction.buttonKeyPressed == 'snooze' ||
            receivedAction.buttonKeyPressed == 'snooze_alarm') {
          AppLogger.info('✅ Alarm action - notification auto-dismissing');
        }

        if (receivedAction.buttonKeyPressed == 'complete') {
          AppLogger.info('✅ Complete action detected - calling handler');
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          if (callback != null) {
            AppLogger.debug(
                '🔍 DEBUG: Callback is not null, invoking callback');
            // Pass RAW habitId to preserve time slot for hourly habits
            callback(rawHabitId, 'complete');
          } else {
            AppLogger.warning(
                '⚠️ WARNING: Callback is null, cannot process action');
          }
        } else if (receivedAction.buttonKeyPressed == 'snooze') {
          AppLogger.info('⏰ Snooze action detected - calling handler');
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          if (callback != null) {
            // Pass RAW habitId to preserve time slot for hourly habits
            callback(rawHabitId, 'snooze');
          }
        } else if (receivedAction.buttonKeyPressed == 'snooze_alarm') {
          AppLogger.info('⏰ Alarm snooze action detected - calling handler');
          final callback = NotificationActionHandlerIsar.onNotificationAction;
          if (callback != null) {
            // Pass RAW habitId to preserve time slot for hourly habits
            callback(rawHabitId, 'snooze_alarm');
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

/// Notification displayed handler (TOP-LEVEL FUNCTION)
/// This is called when a notification is displayed on the screen
/// MUST be a top-level function for background isolate to work!
///
/// With proper Awesome Notifications alarm setup, the system handles sound playback.
/// We don't need to manually play sounds anymore.
@pragma('vm:entry-point')
Future<void> onNotificationDisplayed(
    ReceivedNotification receivedNotification) async {
  try {
    AppLogger.info('🔔 Notification displayed: ${receivedNotification.id}');
    AppLogger.info('   Channel: ${receivedNotification.channelKey}');
    AppLogger.info('   Category: ${receivedNotification.category}');

    // System now handles alarm sound via channel configuration
    if (receivedNotification.channelKey == 'habit_alarms') {
      AppLogger.info(
          '🚨 Alarm notification displayed - sound handled by system');
    }
  } catch (e) {
    AppLogger.error('Error in onNotificationDisplayed', e);
  }
}

/// Notification dismissed handler (TOP-LEVEL FUNCTION)
/// This is called when a notification is dismissed/swiped away
/// MUST be a top-level function for background isolate to work!
///
/// Called when a notification is dismissed (swiped away or cleared from notification shade)
/// For alarm notifications, this cancels the sound if user swipes away the notification
@pragma('vm:entry-point')
Future<void> onNotificationDismissed(ReceivedAction receivedAction) async {
  try {
    AppLogger.info('🗑️ Notification dismissed: ${receivedAction.id}');
    AppLogger.info('   Channel: ${receivedAction.channelKey}');

    // Even though alarms are locked with locked=true, some Android versions
    // may still allow swiping. In that case, we should stop the alarm.
    // Check if this is an alarm notification by checking the channel
    if (receivedAction.channelKey?.contains('alarm') ?? false) {
      AppLogger.info('🛑 Alarm notification dismissed - canceling alarm');

      // Try to extract habitId from payload to properly cancel the alarm
      if (receivedAction.payload != null &&
          receivedAction.payload!['data'] != null) {
        try {
          final payload = jsonDecode(receivedAction.payload!['data']!);
          final baseHabitId = payload['habitId'] as String?;

          if (baseHabitId != null) {
            // Cancel the notification to stop the sound
            final baseAlarmId =
                NotificationHelpers.generateSafeId('${baseHabitId}_daily');
            await AwesomeNotifications().cancel(baseAlarmId);
            AppLogger.info('✅ Cancelled alarm notification on dismissal');
          }
        } catch (e) {
          AppLogger.warning(
              'Failed to parse payload in onNotificationDismissed: $e');
          // Fall back to canceling by ID
          await AwesomeNotifications().cancel(receivedAction.id ?? 0);
        }
      } else {
        // Fall back to canceling by ID
        await AwesomeNotifications().cancel(receivedAction.id ?? 0);
      }
    }
  } catch (e) {
    AppLogger.error('Error in onNotificationDismissed', e);
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
      // CRITICAL: Must use same database name as main app ('habitv8_db')
      // CRITICAL: Must use same inspector setting as main app for multi-isolate compatibility
      // CRITICAL: Must include ALL schemas used by the app
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [HabitSchema, ScheduledNotificationSchema],
        directory: dir.path,
        name: 'habitv8_db', // MUST match database name in database_isar.dart
        inspector: true, // MUST match inspector setting in database_isar.dart
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

      AppLogger.info('🔍 Searching for habit with string ID: $baseHabitId');

      // Find the habit by string ID field (not isarId)
      final habit =
          await isar.habits.filter().idEqualTo(baseHabitId).findFirst();

      if (habit == null) {
        AppLogger.error('❌ Habit not found in background: $baseHabitId');
        await isar.close();
        return;
      }

      AppLogger.info('✅ Found habit in background: ${habit.name}');

      // Determine completion time based on habit frequency
      final now = DateTime.now();
      DateTime completionTime = now;

      // For hourly habits, extract the specific time slot from payload
      if (habit.frequency == HabitFrequency.hourly) {
        AppLogger.info('🕐 Processing HOURLY habit: ${habit.name}');
        AppLogger.info('🕐 Raw habitId from payload: $rawHabitId');
        AppLogger.info('🕐 Payload JSON: $payloadJson');

        final timeSlot =
            NotificationHelpers.extractTimeSlotFromPayload(payloadJson);
        if (timeSlot != null) {
          final hour = timeSlot['hour']!;
          final minute = timeSlot['minute']!;
          completionTime = DateTime(now.year, now.month, now.day, hour, minute);
          AppLogger.info(
              '✅ Hourly habit - extracted time slot: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
          AppLogger.info('✅ Completion time set to: $completionTime');
        } else {
          AppLogger.warning(
              '⚠️ Hourly habit but no time slot in payload, using current time');
          AppLogger.warning('⚠️ Raw habitId: $rawHabitId');
          AppLogger.warning('⚠️ This may cause incorrect completion tracking!');
        }
      }

      // Check if already completed for this specific time
      bool alreadyCompleted = false;
      if (habit.frequency == HabitFrequency.hourly) {
        AppLogger.info('🕐 Checking if time slot already completed...');
        AppLogger.info(
            '🕐 Total completions for this habit: ${habit.completions.length}');

        // For hourly habits, check if this specific time slot is already completed
        alreadyCompleted = habit.completions.any((completion) {
          final matches = completion.year == completionTime.year &&
              completion.month == completionTime.month &&
              completion.day == completionTime.day &&
              completion.hour == completionTime.hour &&
              completion.minute == completionTime.minute;

          if (matches) {
            AppLogger.info('🕐 Found existing completion at: $completion');
          }

          return matches;
        });

        AppLogger.info('🕐 Already completed: $alreadyCompleted');
      } else {
        // For non-hourly habits, check if completed today
        final today = DateTime(now.year, now.month, now.day);
        alreadyCompleted = habit.completions.any((completion) {
          final completionDate = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDate.isAtSameMomentAs(today);
        });
      }

      if (!alreadyCompleted) {
        AppLogger.info('💾 Saving new completion...');

        // Add completion with the correct time
        habit.completions.add(completionTime);
        AppLogger.info(
            '💾 Completion added to list. New total: ${habit.completions.length}');

        // Update streak
        habit.currentStreak = _calculateStreak(habit.completions);
        if (habit.currentStreak > habit.longestStreak) {
          habit.longestStreak = habit.currentStreak;
        }
        AppLogger.info('💾 Streak updated: ${habit.currentStreak}');

        // Save to database
        await isar.writeTxn(() async {
          await isar.habits.put(habit);
        });
        AppLogger.info('💾 Saved to Isar database');

        // CRITICAL: Cancel all alarms for this habit to stop the notification sound
        try {
          // Import AlarmService if available, otherwise use AwesomeNotifications directly
          // We need to cancel the notification that was just displayed
          // Get all possible alarm IDs for this habit and cancel them
          final baseAlarmId =
              NotificationHelpers.generateSafeId('${baseHabitId}_daily');
          await AwesomeNotifications().cancel(baseAlarmId);
          AppLogger.info(
              '✅ Cancelled alarm notification for habit: $baseHabitId');
        } catch (e) {
          AppLogger.warning('Failed to cancel alarm notification: $e');
        }

        final timeInfo = habit.frequency == HabitFrequency.hourly
            ? ' at ${completionTime.hour.toString().padLeft(2, '0')}:${completionTime.minute.toString().padLeft(2, '0')}'
            : '';
        AppLogger.info(
            '✅ Habit completed in background: ${habit.name}$timeInfo (Streak: ${habit.currentStreak})');

        // Update widget - CRITICAL for homescreen widget updates when app is closed
        try {
          AppLogger.info('📱 Triggering widget update from background...');

          // Use Workmanager to trigger immediate native widget update
          // This is the MOST RELIABLE method because Workmanager runs in native Android context
          // and doesn't depend on Flutter engine or method channels.
          //
          // Task name 'widgetUpdate' is handled by callbackDispatcher() in
          // widget_background_update_service.dart which is registered in main.dart.
          // The callback handles both 'widgetUpdate' (immediate) and 'widget_background_update' (periodic).
          if (Platform.isAndroid) {
            await Workmanager().registerOneOffTask(
              'widget-update-${DateTime.now().millisecondsSinceEpoch}',
              'widgetUpdate', // Handled by widget_background_update_service.dart callback
              initialDelay: Duration.zero, // Execute immediately
              constraints: Constraints(
                networkType: NetworkType.notRequired,
              ),
            );
            AppLogger.info('✅ Widget update scheduled via Workmanager');
          }
        } catch (e) {
          AppLogger.error(
              'Failed to schedule widget update from background', e);
        }
      } else {
        final timeInfo = habit.frequency == HabitFrequency.hourly
            ? ' for time slot ${completionTime.hour.toString().padLeft(2, '0')}:${completionTime.minute.toString().padLeft(2, '0')}'
            : ' today';
        AppLogger.info('Habit already completed$timeInfo: ${habit.name}');
      }

      await isar.close();
      AppLogger.info('✅ Background habit completion finished');
    } catch (e) {
      AppLogger.error('Error completing habit in background', e);
    }
  }

  /// Snooze an alarm from background notification action
  ///
  /// This method runs in a background isolate and schedules a new alarm notification.
  /// It directly accesses the Isar database to get habit details for the snooze.
  @pragma('vm:entry-point')
  static Future<void> snoozeAlarmInBackground(
      String rawHabitId, String payloadJson) async {
    try {
      AppLogger.info('⏰ Starting background alarm snooze for: $rawHabitId');

      // Initialize Isar in background isolate
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open(
        [HabitSchema, ScheduledNotificationSchema],
        directory: dir.path,
        name: 'habitv8_db',
        inspector: true,
      );

      AppLogger.info('✅ Isar opened in background isolate for snooze');

      // Extract base habit ID
      final baseHabitId =
          NotificationHelpers.extractHabitIdFromPayload(payloadJson);
      if (baseHabitId == null) {
        AppLogger.error('Failed to extract base habit ID from payload');
        await isar.close();
        return;
      }

      // Find the habit to get snooze settings
      final habit =
          await isar.habits.filter().idEqualTo(baseHabitId).findFirst();

      if (habit == null) {
        AppLogger.error('❌ Habit not found in background: $baseHabitId');
        await isar.close();
        return;
      }

      AppLogger.info('✅ Found habit for snooze: ${habit.name}');
      AppLogger.info('   Snooze delay: ${habit.snoozeDelayMinutes} minutes');

      // Parse payload to get alarm details
      final payload = jsonDecode(payloadJson);
      final alarmSoundName = payload['alarmSoundName'] as String?;
      final snoozeDelayMinutes = habit.snoozeDelayMinutes;

      // Schedule snooze alarm
      final snoozeTime = DateTime.now().add(
        Duration(minutes: snoozeDelayMinutes),
      );
      final snoozeId =
          NotificationHelpers.generateSnoozeNotificationId(baseHabitId);

      // Create snooze text
      String snoozeText = '⏰ Snooze ';
      if (snoozeDelayMinutes < 60) {
        snoozeText += '${snoozeDelayMinutes}min';
      } else {
        final hours = snoozeDelayMinutes ~/ 60;
        final minutes = snoozeDelayMinutes % 60;
        if (minutes == 0) {
          snoozeText += '${hours}h';
        } else {
          snoozeText += '${hours}h ${minutes}min';
        }
      }

      // CRITICAL: Cancel the current alarm notification to stop the sound
      try {
        final baseAlarmId =
            NotificationHelpers.generateSafeId('${baseHabitId}_daily');
        await AwesomeNotifications().cancel(baseAlarmId);
        AppLogger.info('✅ Cancelled current alarm before snooze');
      } catch (e) {
        AppLogger.warning('Failed to cancel alarm before snooze: $e');
      }

      // Determine the custom sound for the snooze notification
      String normalizedSoundName =
          _normalizeAlarmSoundNameForSnooze(alarmSoundName);
      String channelKey = normalizedSoundName == 'default'
          ? 'habit_alarms'
          : 'habit_alarm_$normalizedSoundName';

      // Create a custom channel for snooze with the same sound
      if (normalizedSoundName != 'default') {
        try {
          await AwesomeNotifications().setChannel(
            NotificationChannel(
              channelKey: channelKey,
              channelName: 'Habit Alarm - $normalizedSoundName',
              channelDescription: 'Alarm channel with custom sound',
              importance: NotificationImportance.Max,
              defaultColor: const Color(0xFFFF0000),
              ledColor: Colors.red,
              playSound: true,
              soundSource:
                  'resource://raw/$normalizedSoundName', // Custom sound for snooze
              enableVibration: true,
              enableLights: true,
              locked: true,
              defaultPrivacy: NotificationPrivacy.Public,
              criticalAlerts: true,
              channelShowBadge: true,
              onlyAlertOnce: false,
            ),
          );
        } catch (e) {
          AppLogger.warning(
              'Failed to create snooze channel with custom sound: $e');
          channelKey = 'habit_alarms';
        }
      }

      // Determine custom sound URI
      String? customSound;
      if (normalizedSoundName != 'default') {
        customSound = 'resource://raw/$normalizedSoundName';
      } else {
        customSound = 'resource://raw/alarm';
      }

      // Create the snooze alarm notification with the same custom sound
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: snoozeId,
          channelKey: channelKey,
          title: '🚨 HABIT ALARM: ${habit.name}',
          body:
              'Time to complete your habit! Tap to mark as complete or snooze.',
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.Default,
          fullScreenIntent: true,
          wakeUpScreen: true,
          criticalAlert: true,
          locked: true,
          customSound:
              customSound, // Use the same custom sound as original alarm
          payload: {
            'data': jsonEncode({
              'habitId': baseHabitId,
              'alarmSoundName': alarmSoundName,
              'snoozeDelayMinutes': snoozeDelayMinutes,
            })
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'complete',
            label: '✅ COMPLETE',
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'snooze_alarm',
            label: snoozeText,
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: false,
          ),
        ],
        schedule: NotificationCalendar.fromDate(
          date: snoozeTime,
          allowWhileIdle: true,
          preciseAlarm: true,
        ),
      );

      AppLogger.info(
          '✅ Snooze alarm scheduled in background for: ${habit.name} at $snoozeTime with custom sound: $normalizedSoundName');

      await isar.close();
      AppLogger.info('✅ Background alarm snooze finished');
    } catch (e) {
      AppLogger.error('Error snoozing alarm in background', e);
    }
  }

  /// Calculate current streak from completions
  ///
  /// CRITICAL: @pragma annotation prevents tree-shaking in release builds
  /// This method is called from completeHabitInBackground() which runs in background isolate
  @pragma('vm:entry-point')
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

  /// Normalize alarm sound name for snooze notifications
  /// Converts display names to lowercase underscore format for Android raw resource lookup
  @pragma('vm:entry-point')
  static String _normalizeAlarmSoundNameForSnooze(String? soundName) {
    if (soundName == null || soundName.isEmpty || soundName == 'default') {
      return 'default';
    }

    // Extract filename from path and remove extension
    String filename =
        soundName.contains('/') ? soundName.split('/').last : soundName;

    // Remove .mp3 extension if present
    if (filename.endsWith('.mp3')) {
      filename = filename.substring(0, filename.length - 4);
    }

    // Convert to lowercase and normalize spaces/hyphens to underscores
    return filename.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
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
          channelKey: 'habit_scheduled_channel',
          title: 'Snoozed: $habitName',
          body: 'Time to complete your habit!',
          category: NotificationCategory.Reminder,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          payload: {
            'data': jsonEncode({'habitId': habitId})
          },
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'complete',
            label: 'Complete',
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'snooze',
            label: 'Snooze',
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
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
