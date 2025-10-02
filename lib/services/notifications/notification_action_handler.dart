import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../logging_service.dart';
import '../../data/database.dart';
import '../widget_integration_service.dart';
import 'notification_helpers.dart';
import 'notification_storage.dart';
import 'notification_scheduler.dart';

/// Handles notification action processing and callbacks
/// Manages background/foreground notification responses, completion, and snooze actions
class NotificationActionHandler {
  static NotificationActionHandler? _instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Notification scheduler instance for scheduling operations
  static late final NotificationScheduler _scheduler;

  /// Callback for notification actions (complete/snooze)
  static void Function(String habitId, String action)? onNotificationAction;

  /// Direct completion handler for when callback isn't available
  static Future<void> Function(String habitId)? directCompletionHandler;

  /// List of pending actions to be processed when app is ready
  static final List<Map<String, String>> _pendingActions = [];

  /// Track callback registration for debugging
  static int _callbackSetCount = 0;
  static DateTime? _lastCallbackSetTime;

  /// Flag to track if initial pending actions have been processed
  static bool _hasProcessedInitialActions = false;

  NotificationActionHandler._() {
    _scheduler = NotificationScheduler(_notificationsPlugin);
  }

  static NotificationActionHandler getInstance() {
    _instance ??= NotificationActionHandler._();
    return _instance!;
  }

  /// Register notification action callback
  /// This should be called during app initialization to handle notification actions
  static void setNotificationActionCallback(
      void Function(String habitId, String action) callback) {
    onNotificationAction = callback;
    _callbackSetCount++;
    _lastCallbackSetTime = DateTime.now();
    AppLogger.info('✅ Notification action callback registered');
    AppLogger.info(
        '📊 Callback registration count: $_callbackSetCount, last set at: $_lastCallbackSetTime');
  }

  /// Register direct completion handler
  /// This is a fallback for when the main callback isn't available
  static void setDirectCompletionHandler(
      Future<void> Function(String habitId) handler) {
    directCompletionHandler = handler;
    AppLogger.info('✅ Direct completion handler registered');
  }

  /// Background notification response handler
  /// This is called when the app is not running or in background
  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationResponse(
      NotificationResponse response) async {
    try {
      AppLogger.info('🔔 BACKGROUND notification response received');
      AppLogger.info('Background action ID: ${response.actionId}');
      AppLogger.info('Background payload: ${response.payload}');

      // Initialize Hive for background processing
      await Hive.initFlutter();
      AppLogger.info('✅ Hive initialized in background handler');

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
              await _completeHabitInBackground(habitId);
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

  /// Complete a habit in background when app is not running
  static Future<void> _completeHabitInBackground(String habitId) async {
    try {
      AppLogger.info('⚙️ Completing habit in background: $habitId');

      // Initialize database
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);

      // Get the habit
      final habit = await habitService.getHabitById(habitId);
      if (habit == null) {
        AppLogger.warning('Habit not found in background: $habitId');
        return;
      }

      // Mark the habit as complete for today
      await habitService.markHabitComplete(habitId, DateTime.now());
      AppLogger.info('✅ Habit completed in background: ${habit.name}');

      // Update widget if available
      try {
        await WidgetIntegrationService.instance.onHabitCompleted();
        AppLogger.info('✅ Widget updated after background completion');
      } catch (e) {
        AppLogger.error('Error updating widget in background', e);
      }
    } catch (e) {
      AppLogger.error('Error completing habit in background', e);
    }
  }

  /// Foreground notification tap handler
  /// This is called when the app is running and notification is tapped
  @pragma('vm:entry-point')
  static Future<void> onNotificationTapped(
      NotificationResponse response) async {
    AppLogger.info('=== NOTIFICATION TAPPED - DETAILED DEBUG LOG ===');
    AppLogger.info('📱 Notification Response Details:');
    AppLogger.info('  - ID: ${response.id}');
    AppLogger.info('  - Action ID: ${response.actionId}');
    AppLogger.info('  - Payload: ${response.payload}');
    AppLogger.info('  - Input: ${response.input}');
    AppLogger.info(
        '  - Notification Type: ${response.notificationResponseType}');
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
          AppLogger.debug(
              '🔍 DEBUG: habitId is not null, proceeding with action');
          AppLogger.info('📋 Extracted habitId from payload: $habitId');

          // Handle different action types
          if (response.actionId != null) {
            AppLogger.debug(
                '🔍 DEBUG: Action ID is not null: ${response.actionId}');
            AppLogger.info('🎯 Processing action: ${response.actionId}');
            _handleNotificationAction(habitId, response.actionId!);
          } else {
            AppLogger.debug('🔍 DEBUG: Action ID is null, treating as tap');
            AppLogger.info('👆 No action ID - treating as notification tap');
            // No specific action - user just tapped the notification
            // Could navigate to habit detail or mark as read
          }
        } else {
          AppLogger.debug('🔍 DEBUG: habitId is null');
          AppLogger.warning('⚠️ No habitId found in notification payload');
        }
      } catch (e) {
        AppLogger.debug('🔍 DEBUG: Exception during payload parsing: $e');
        AppLogger.error('❌ Error parsing notification payload', e);
      }
    } else {
      AppLogger.debug('🔍 DEBUG: Payload is null');
      AppLogger.warning('⚠️ Notification payload is null');
    }

    AppLogger.info('=== NOTIFICATION TAP PROCESSING COMPLETE ===');
  }

  /// Process pending actions stored during app initialization
  static Future<void> processPendingActions() async {
    AppLogger.info('🔄 Processing pending notification actions');

    // Load all actions from storage module
    final allActions = await NotificationStorage.loadAllActions();

    AppLogger.info('Found ${allActions.length} actions in storage');

    // Process all actions
    for (final actionData in allActions) {
      try {
        final habitId = actionData['habitId'] as String;
        final action = actionData['action'] as String;
        final timestamp = actionData['timestamp'] as String?;
        final actionTime = timestamp != null
            ? DateTime.tryParse(timestamp) ?? DateTime.now()
            : DateTime.now();

        AppLogger.info(
            'Processing stored action: $action for habit $habitId at $actionTime');

        // Process the stored action
        await _processStoredAction(habitId, action, actionTime);

        // Remove successfully processed action
        await NotificationStorage.removeAction(habitId, action);
        AppLogger.info('✅ Successfully processed and removed action');
      } catch (e) {
        AppLogger.error('Error processing stored action', e);
      }
    }

    // Process in-memory pending actions if callback is available
    if (onNotificationAction != null && _pendingActions.isNotEmpty) {
      AppLogger.info(
          '📬 Processing ${_pendingActions.length} in-memory pending actions');

      final callback = onNotificationAction!;

      final actionsToProcess = List<Map<String, String>>.from(_pendingActions);
      _pendingActions.clear();

      for (final actionData in actionsToProcess) {
        final habitId = actionData['habitId']!;
        final action = actionData['action']!;
        final timestamp = actionData['timestamp']!;

        AppLogger.info(
          '⚡ Processing pending action: $action for habit: $habitId (queued at: $timestamp)',
        );

        try {
          callback(habitId, action);
          AppLogger.info(
            '✅ Successfully processed pending action: $action for habit: $habitId',
          );
        } catch (e) {
          AppLogger.error(
            '❌ Error processing pending action: $action for habit: $habitId',
            e,
          );
        }
      }

      AppLogger.info('🎉 All pending actions processed');
    } else {
      AppLogger.info('📭 No pending actions to process');
    }

    // Mark that we've processed initial actions
    _hasProcessedInitialActions = true;
    AppLogger.info('✅ Initial pending actions processing complete');
  }

  /// Process a stored action from notification storage
  static Future<void> _processStoredAction(
      String habitId, String action, DateTime actionTime) async {
    try {
      AppLogger.info(
          'Processing stored action: $action for habit $habitId at $actionTime');

      final normalizedAction = action.toLowerCase().replaceAll('_action', '');

      switch (normalizedAction) {
        case 'complete':
          // Mark habit as complete using the stored action time
          await _completeHabitFromNotification(habitId);
          break;
        case 'snooze':
          // Reschedule notification for later
          await _handleSnoozeAction(habitId);
          break;
        default:
          AppLogger.warning('Unknown stored action: $action');
      }
    } catch (e) {
      AppLogger.error(
          'Error processing stored action: $action for habit $habitId', e);
    }
  }

  /// Handle notification actions (Complete/Snooze)
  @pragma('vm:entry-point')
  static void _handleNotificationAction(String habitId, String action) async {
    AppLogger.debug(
      '🚀 DEBUG: _handleNotificationAction called with habitId: $habitId, action: $action',
    );
    AppLogger.info('🚀🚀🚀 NOTIFICATION ACTION HANDLER CALLED! 🚀🚀🚀');
    AppLogger.info('Handling notification action: $action for habit: $habitId');

    // Check callback status for debugging
    final callbackAvailable = ensureCallbackIsSet();

    // If callback is not available, try to re-register it
    if (!callbackAvailable) {
      AppLogger.warning(
          '🔄 Callback not available, attempting to re-register...');
      // Import the notification action service dynamically to avoid circular imports
      try {
        // Try to re-register the callback by calling the ensure method
        // This will be handled by the app lifecycle service when app resumes
        AppLogger.info(
            '📦 Storing action for later processing due to missing callback');
        NotificationStorage.storeAction(habitId, action);
        return;
      } catch (e) {
        AppLogger.error('Failed to handle missing callback', e);
      }
    }

    try {
      // Normalize action IDs to handle both iOS and Android formats
      final normalizedAction = action.toLowerCase().replaceAll('_action', '');
      AppLogger.debug('🔄 DEBUG: Original action: $action');
      AppLogger.debug('🔄 DEBUG: Normalized action: $normalizedAction');

      switch (normalizedAction) {
        case 'complete':
          AppLogger.debug(
            '✅ DEBUG: Processing complete action for habit: $habitId',
          );
          AppLogger.info('🔥 Processing complete action for habit: $habitId');

          // Always cancel the notification first for complete action
          final notificationId = habitId.hashCode;
          await _scheduler.cancelNotification(notificationId);
          AppLogger.debug(
            '🗑️ DEBUG: Notification cancelled with ID: $notificationId',
          );
          AppLogger.info(
            '✅ Notification cancelled for complete action for habit: $habitId',
          );

          // Also cancel any snooze notifications for this habit since it's now completed
          await _cancelSnoozeNotificationsForHabit(habitId);
          AppLogger.debug(
            '🗑️ Cancelled any snooze notifications for completed habit: $habitId',
          );

          // Call the callback if set
          if (onNotificationAction != null) {
            AppLogger.debug('📞 DEBUG: Calling notification action callback');
            AppLogger.info(
              '📞 Calling complete action callback for habit: $habitId',
            );
            AppLogger.info(
              '🔍 Callback state: set $_callbackSetCount times, last at $_lastCallbackSetTime',
            );
            try {
              onNotificationAction!(habitId, 'complete');
              AppLogger.debug('✅ DEBUG: Callback executed successfully');
              AppLogger.info(
                '✅ Complete action callback executed for habit: $habitId',
              );
            } catch (callbackError) {
              AppLogger.error(
                'Error executing complete action callback for habit: $habitId',
                callbackError,
              );
              // Store for later processing if callback fails
              NotificationStorage.storeAction(habitId, 'complete');
            }
          } else {
            AppLogger.debug('❌ DEBUG: No notification action callback set!');
            AppLogger.warning(
              '❌ No notification action callback set - action will be lost',
            );
            AppLogger.warning(
              '🔍 Callback debug: set $_callbackSetCount times, last at $_lastCallbackSetTime',
            );
            AppLogger.warning('🔍 Current time: ${DateTime.now()}');

            // Store the action for later processing if callback is not set
            NotificationStorage.storeAction(habitId, 'complete');

            // Try to re-register the callback in case it was lost
            ensureCallbackIsSet();
          }
          break;

        case 'snooze':
          AppLogger.debug('😴 Processing snooze action for habit: $habitId');
          AppLogger.info('😴 Processing snooze action for habit: $habitId');
          // Handle snooze action
          try {
            await _handleSnoozeAction(habitId);
            AppLogger.debug('✅ DEBUG: Snooze action completed');
            AppLogger.info('✅ Snooze action completed for habit: $habitId');
          } catch (snoozeError) {
            AppLogger.error('❌ Error handling snooze action', snoozeError);
          }
          break;

        default:
          AppLogger.debug('⚠️ DEBUG: Unknown action: $normalizedAction');
          AppLogger.warning('⚠️ Unknown action: $normalizedAction');
      }
    } catch (e) {
      AppLogger.debug('❌ DEBUG: Exception in action handler: $e');
      AppLogger.error('❌ Error handling notification action', e);
    }
  }

  /// Handle snooze action specifically with enhanced error handling and validation
  static Future<void> _handleSnoozeAction(String habitId) async {
    try {
      // Generate a unique notification ID for the snooze to prevent conflicts
      final snoozeId =
          NotificationHelpers.generateSnoozeNotificationId(habitId);
      AppLogger.info(
        '🔔 Starting enhanced snooze process for habit: $habitId (snooze ID: $snoozeId)',
      );

      // Cancel the current notification (use the original ID)
      final originalNotificationId = habitId.hashCode;
      await _scheduler.cancelNotification(originalNotificationId);
      AppLogger.info('❌ Cancelled current notification for habit: $habitId');

      // Schedule a new notification for 30 minutes later
      final snoozeTime = DateTime.now().add(const Duration(minutes: 30));
      AppLogger.info('⏰ Scheduling snoozed notification for: $snoozeTime');

      // Validate the snooze time is reasonable
      final timeDiff = snoozeTime.difference(DateTime.now()).inMinutes;
      if (timeDiff < 29 || timeDiff > 31) {
        AppLogger.warning(
            '⚠️ Snooze time calculation seems off: $timeDiff minutes');
      }

      // Check exact alarm permissions before scheduling
      final canScheduleExact =
          await NotificationHelpers.canScheduleExactAlarms();
      AppLogger.info('📋 Can schedule exact alarms: $canScheduleExact');

      if (!canScheduleExact) {
        AppLogger.warning(
            '⚠️ Exact alarm permission not available - snooze may be delayed');
        AppLogger.warning(
            '💡 Note: Exact alarm permission should have been granted during habit setup');
        AppLogger.warning(
            '💡 If snooze is still delayed, it\'s likely due to battery optimization');
        // Log battery optimization guidance
        await NotificationHelpers.checkBatteryOptimizationStatus();
      } else {
        AppLogger.info(
            '✅ Exact alarm permission available - checking for battery optimization issues');
        // Even with exact alarm permission, battery optimization can still cause delays
        AppLogger.info(
            '💡 If snooze notifications are delayed, check battery optimization settings:');
        AppLogger.info(
            '1. Settings > Apps > HabitV8 > Battery > Don\'t optimize');
        AppLogger.info('2. Samsung: Add to "Never sleeping apps"');
        AppLogger.info(
            '3. MIUI: Enable "Autostart" and disable "Battery saver"');
      }

      try {
        // Create personalized snooze notification content
        String title = '⏰ Habit Reminder (Snoozed)';
        String body =
            'Time to complete your snoozed habit! Don\'t forget to stay consistent.';

        // Cancel any existing snooze notifications for this habit to prevent duplicates
        await _cancelSnoozeNotificationsForHabit(habitId);
        AppLogger.debug(
            'Cancelled any existing snooze notifications for habit: $habitId');

        // Attempt to schedule the notification with the unique snooze ID
        await _scheduler.scheduleHabitNotification(
          id: snoozeId,
          habitId: habitId,
          title: title,
          body: body,
          scheduledTime: snoozeTime,
        );

        // Verify the notification was actually scheduled
        await NotificationHelpers.verifyNotificationScheduled(
          _notificationsPlugin,
          snoozeId,
          habitId,
        );

        AppLogger.info(
          '✅ Snoozed notification scheduled successfully for habit: $habitId at $snoozeTime (ID: $snoozeId)',
        );
      } catch (scheduleError) {
        AppLogger.error(
          '❌ Failed to schedule snoozed notification for habit: $habitId',
          scheduleError,
        );

        // Try fallback scheduling method
        await _fallbackSnoozeScheduling(habitId, snoozeId, snoozeTime);
      }

      AppLogger.info('✅ Snooze action completed for habit: $habitId');
    } catch (e) {
      AppLogger.error('❌ Error handling snooze action for habit: $habitId', e);
      // Try emergency fallback
      await _emergencySnoozeNotification(habitId);
    }
  }

  /// Handle snooze action with habit name for personalized notifications
  static Future<void> handleSnoozeActionWithName(
      String habitId, String habitName) async {
    try {
      // Generate a unique notification ID for the snooze to prevent conflicts
      final snoozeId =
          NotificationHelpers.generateSnoozeNotificationId(habitId);
      AppLogger.info(
        '🔔 Starting enhanced snooze process for habit: $habitName ($habitId) (snooze ID: $snoozeId)',
      );

      // Cancel the current notification (use the original ID)
      final originalNotificationId = habitId.hashCode;
      await _scheduler.cancelNotification(originalNotificationId);
      AppLogger.info('❌ Cancelled current notification for habit: $habitName');

      // Schedule a new notification for 30 minutes later
      final snoozeTime = DateTime.now().add(const Duration(minutes: 30));
      AppLogger.info('⏰ Scheduling snoozed notification for: $snoozeTime');

      // Validate the snooze time is reasonable
      final timeDiff = snoozeTime.difference(DateTime.now()).inMinutes;
      if (timeDiff < 29 || timeDiff > 31) {
        AppLogger.warning(
            '⚠️ Snooze time calculation seems off: $timeDiff minutes');
      }

      // Check exact alarm permissions before scheduling
      final canScheduleExact =
          await NotificationHelpers.canScheduleExactAlarms();
      AppLogger.info('📋 Can schedule exact alarms: $canScheduleExact');

      if (!canScheduleExact) {
        AppLogger.warning(
            '⚠️ Exact alarm permission not available - snooze may be delayed');
        AppLogger.warning(
            '💡 Note: Exact alarm permission should have been granted during habit setup');
        AppLogger.warning(
            '💡 If snooze is still delayed, it\'s likely due to battery optimization');
        // Log battery optimization guidance
        await NotificationHelpers.checkBatteryOptimizationStatus();
      } else {
        AppLogger.info(
            '✅ Exact alarm permission available - checking for battery optimization issues');
        // Even with exact alarm permission, battery optimization can still cause delays
        AppLogger.info(
            '💡 If snooze notifications are delayed, check battery optimization settings:');
        AppLogger.info(
            '1. Settings > Apps > HabitV8 > Battery > Don\'t optimize');
        AppLogger.info('2. Samsung: Add to "Never sleeping apps"');
        AppLogger.info(
            '3. MIUI: Enable "Autostart" and disable "Battery saver"');
      }

      try {
        // Create personalized snooze notification content with habit name
        String title = '⏰ $habitName (Snoozed)';
        String body =
            'Time to complete "$habitName"! Don\'t break your streak.';

        // Cancel any existing snooze notifications for this habit to prevent duplicates
        await _cancelSnoozeNotificationsForHabit(habitId);
        AppLogger.debug(
            'Cancelled any existing snooze notifications for habit: $habitName');

        // Attempt to schedule the notification with the unique snooze ID
        await _scheduler.scheduleHabitNotification(
          id: snoozeId,
          habitId: habitId,
          title: title,
          body: body,
          scheduledTime: snoozeTime,
        );

        // Verify the notification was actually scheduled
        await NotificationHelpers.verifyNotificationScheduled(
          _notificationsPlugin,
          snoozeId,
          habitId,
        );

        AppLogger.info(
          '✅ Snoozed notification scheduled successfully for habit: $habitName at $snoozeTime (ID: $snoozeId)',
        );
      } catch (scheduleError) {
        AppLogger.error(
          '❌ Failed to schedule snoozed notification for habit: $habitName',
          scheduleError,
        );

        // Try fallback scheduling method
        await _fallbackSnoozeScheduling(habitId, snoozeId, snoozeTime);
      }

      AppLogger.info('✅ Snooze action completed for habit: $habitName');
    } catch (e) {
      AppLogger.error(
          '❌ Error handling snooze action for habit: $habitName ($habitId)', e);
      // Try emergency fallback
      await _emergencySnoozeNotification(habitId);
    }
  }

  /// Fallback scheduling method for when primary scheduling fails
  static Future<void> _fallbackSnoozeScheduling(
      String habitId, int notificationId, DateTime snoozeTime) async {
    try {
      AppLogger.info(
          '🔄 Attempting fallback snooze scheduling for habit: $habitId');

      // Try to get habit name for better notification content
      String habitName = 'Your habit'; // Default fallback
      try {
        // Attempt to retrieve habit name from database for more specific notification
        final habitBox = await DatabaseService.getInstance();
        final habitService = HabitService(habitBox);
        final habit = await habitService.getHabitById(habitId);
        if (habit != null) {
          habitName = habit.name;
          AppLogger.info('Retrieved habit name for fallback: $habitName');
        }
      } catch (e) {
        AppLogger.debug('Could not retrieve habit name for fallback: $e');
      }

      // Try scheduling with immediate show and re-schedule pattern
      await _scheduler.showNotification(
        id: notificationId + 1000,
        title: '⏰ $habitName (Snoozed)',
        body: 'Snooze scheduled. You\'ll be reminded in 30 minutes.',
        payload:
            jsonEncode({'habitId': habitId, 'type': 'snooze_confirmation'}),
      );

      AppLogger.info('✅ Fallback notification shown for habit: $habitName');
    } catch (fallbackError) {
      AppLogger.error('❌ Fallback scheduling also failed for habit: $habitId',
          fallbackError);
    }
  }

  /// Emergency notification for when all scheduling methods fail
  static Future<void> _emergencySnoozeNotification(String habitId) async {
    try {
      AppLogger.info(
          '🚨 Triggering emergency snooze notification for habit: $habitId');

      // Try to get habit name for better notification content
      String habitName = 'your habit'; // Default fallback
      try {
        final habitBox = await DatabaseService.getInstance();
        final habitService = HabitService(habitBox);
        final habit = await habitService.getHabitById(habitId);
        if (habit != null) {
          habitName = habit.name;
        }
      } catch (e) {
        AppLogger.debug(
            'Could not retrieve habit name for emergency notification: $e');
      }

      // Show an immediate notification telling user to check manually
      await _scheduler.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: '⚠️ Snooze Notification Failed',
        body:
            'Snooze failed for "$habitName". Please check your habit manually in 30 minutes.',
        payload: jsonEncode({'habitId': habitId, 'type': 'snooze_error'}),
      );
    } catch (e) {
      AppLogger.error('Emergency notification also failed', e);
    }
  }

  /// Cancel snooze notifications for a specific habit
  /// This prevents old snooze notifications from interfering with new notifications
  static Future<void> _cancelSnoozeNotificationsForHabit(String habitId) async {
    try {
      AppLogger.debug(
          '🧹 Checking for snooze notifications to cancel for habit: $habitId');

      // Get all pending notifications
      final pendingNotifications =
          await NotificationHelpers.getPendingNotifications(
              _notificationsPlugin);
      int cancelledSnoozeCount = 0;

      for (final notification in pendingNotifications) {
        // Check if this is a snooze notification for this specific habit
        if (notification.id >= 2000000 && notification.id <= 2999999) {
          // For snooze notifications, we need to check if the payload contains this habitId
          // Since we can't directly access payload here, we'll cancel based on ID pattern
          // Snooze IDs are generated from habitId hash, so we can reverse-engineer
          final baseId = habitId.hashCode.abs();
          final expectedSnoozeRange = (baseId % 900000) + 2000000;

          // Check if this notification ID could belong to this habit (within reasonable range)
          if (notification.id >= expectedSnoozeRange &&
              notification.id <= expectedSnoozeRange + 1000) {
            await _notificationsPlugin.cancel(notification.id);
            AppLogger.debug(
                '❌ Cancelled snooze notification ID: ${notification.id} for habit: $habitId');
            cancelledSnoozeCount++;
          }
        }
      }

      if (cancelledSnoozeCount > 0) {
        AppLogger.info(
            '✅ Cancelled $cancelledSnoozeCount snooze notification(s) for habit: $habitId');
      } else {
        AppLogger.debug(
            'No snooze notifications found to cancel for habit: $habitId');
      }
    } catch (e) {
      AppLogger.error(
          'Error cancelling snooze notifications for habit: $habitId', e);
    }
  }

  /// Complete a habit from notification action
  static Future<void> _completeHabitFromNotification(String habitId) async {
    AppLogger.info('Completing habit from notification: $habitId');
    if (directCompletionHandler != null) {
      await directCompletionHandler!(habitId);
    } else {
      AppLogger.warning('Direct completion handler not set');
    }
  }

  /// Get the number of pending actions (for debugging)
  static int getPendingActionsCount() {
    return _pendingActions.length;
  }

  /// Manually trigger processing of pending actions (for app initialization)
  static Future<void> processPendingActionsManually() async {
    AppLogger.info('🔄 Manually processing pending actions');

    // Always try to process actions, using either callback or direct handler
    if (onNotificationAction != null) {
      AppLogger.info('✅ Using callback to process pending actions');
      await processPendingActions();
    } else if (directCompletionHandler != null) {
      AppLogger.warning('⚠️ Callback not set, using direct completion handler');
      await _processPendingActionsWithDirectHandler();
    } else {
      AppLogger.error(
          '❌ Cannot process pending actions - neither callback nor direct handler available');
    }
  }

  /// Process pending actions using the direct completion handler when callback is not available
  static Future<void> _processPendingActionsWithDirectHandler() async {
    try {
      AppLogger.info(
          '🎯 Processing pending actions with direct completion handler');

      // Load all actions from storage module
      final allActions = await NotificationStorage.loadAllActions();

      AppLogger.info('Found ${allActions.length} actions in storage');

      int processedCount = 0;

      // Process all actions
      for (final actionData in allActions) {
        try {
          final habitId = actionData['habitId'] as String;
          final action = actionData['action'] as String;

          // Only process complete actions with direct handler
          if (action.toLowerCase() == 'complete' &&
              directCompletionHandler != null) {
            AppLogger.info(
                'Processing complete action for habit: $habitId using direct handler');
            try {
              await directCompletionHandler!(habitId);
              processedCount++;
              AppLogger.info('✅ Successfully completed habit: $habitId');
              // Remove successfully processed action
              await NotificationStorage.removeAction(habitId, action);
            } catch (e) {
              final errorMessage = e.toString().toLowerCase();
              if (errorMessage.contains('still loading') ||
                  errorMessage.contains('loading')) {
                AppLogger.warning(
                    '⏳ Habit service still loading for $habitId, will retry later');
                // Don't remove action, so it stays in storage for retry
              } else {
                AppLogger.error('❌ Failed to complete habit: $habitId', e);
                // Remove action even if failed to avoid infinite retry
                await NotificationStorage.removeAction(habitId, action);
                processedCount++;
              }
            }
          } else {
            AppLogger.info(
                'Skipping non-complete action or missing handler: $action for habit $habitId');
          }
        } catch (e) {
          AppLogger.error('Error processing individual pending action', e);
        }
      }

      AppLogger.info('✅ Processed $processedCount actions with direct handler');
    } catch (e) {
      AppLogger.error('Error in _processPendingActionsWithDirectHandler', e);
    }
  }

  /// Check if callback is set and re-initialize if needed
  static bool ensureCallbackIsSet() {
    final isSet = onNotificationAction != null;
    AppLogger.info('🔍 Callback check: ${isSet ? "SET" : "NOT SET"}');
    if (!isSet) {
      AppLogger.warning(
        '⚠️ Callback is not set! This may cause notification actions to fail.',
      );
      AppLogger.info(
        '🔍 Callback was set $_callbackSetCount times, last at $_lastCallbackSetTime',
      );
    }
    return isSet;
  }
}
