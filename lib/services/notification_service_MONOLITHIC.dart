import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'logging_service.dart';
import 'notification_queue_processor.dart';
import 'alarm_manager_service.dart';
import 'widget_integration_service.dart';
import 'notifications/notification_storage.dart';
import 'notifications/notification_core.dart';
import 'notifications/notification_helpers.dart';
import '../data/database.dart';
import '../domain/model/habit.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Callback for handling notification actions
  static Function(String habitId, String action)? onNotificationAction;

  // Direct completion function (to avoid circular imports)
  static Future<void> Function(String habitId)? directCompletionHandler;

  // Debug tracking for callback state
  static int _callbackSetCount = 0;
  static DateTime? _lastCallbackSetTime;

  // Queue for storing pending actions when callback is not available
  static final List<Map<String, String>> _pendingActions = [];

  /// Initialize the notification service
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    if (NotificationCore.isInitialized) return;

    // Set up the callback for the queue processor
    NotificationQueueProcessor.setScheduleNotificationCallback(
        scheduleHabitNotification);

    // Initialize the core notification system
    await NotificationCore.initialize(
      plugin: _notificationsPlugin,
      onForegroundTap: _onNotificationTapped,
      onBackgroundTap: onBackgroundNotificationResponse,
      onPeriodicCleanup: _startPeriodicCleanup,
    );

    AppLogger.info('🔔 NotificationService initialized successfully');
  }

  /// Check if device is running Android 12+ (API level 31+)
  static Future<bool> isAndroid12Plus() async {
    return await NotificationCore.isAndroid12Plus();
  }

  /// Recreate notification channels with updated sound configuration
  static Future<void> recreateNotificationChannels() async {
    await NotificationCore.recreateNotificationChannels(_notificationsPlugin);
  }

  /// Handle background notification responses (when app is not in foreground)
  /// This method is called when the app is not running or in background
  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    AppLogger.info('🌙🌙🌙 BACKGROUND NOTIFICATION HANDLER CALLED! 🌙🌙🌙');
    AppLogger.info('=== BACKGROUND NOTIFICATION RESPONSE ===');
    AppLogger.info('Background notification ID: ${notificationResponse.id}');
    AppLogger.info('Background action ID: ${notificationResponse.actionId}');
    AppLogger.info('Background payload: ${notificationResponse.payload}');
    AppLogger.info(
      'Background response type: ${notificationResponse.notificationResponseType}',
    );
    AppLogger.info('Background input: ${notificationResponse.input}');

    // Log the raw response object for debugging
    AppLogger.info('Raw background response: $notificationResponse');

    // Process notification actions directly in background
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;

        if (habitId != null && action != null && action.isNotEmpty) {
          AppLogger.info(
            'Processing background action: $action for habit: $habitId',
          );

          // Store the action for fallback processing when app is opened
          NotificationStorage.storeAction(habitId, action);

          // Process the action directly in background
          try {
            if (action.toLowerCase() == 'complete') {
              AppLogger.info('Completing habit in background: $habitId');
              await _completeHabitInBackground(habitId);
              AppLogger.info(
                  '✅ Background completion successful for habit: $habitId');

              // Remove the stored action since we processed it successfully
              await NotificationStorage.removeAction(habitId, action);
            } else if (action.toLowerCase().contains('snooze')) {
              AppLogger.info('Snoozing habit in background: $habitId');
              await handleSnoozeActionWithName(habitId, 'Your habit');
              AppLogger.info(
                  '✅ Background snooze successful for habit: $habitId');

              // Remove the stored action since we processed it successfully
              await NotificationStorage.removeAction(habitId, action);
            }
          } catch (e) {
            AppLogger.error(
                '❌ Background action processing failed for habit: $habitId', e);
            // Keep the stored action for later processing
          }
        }
      } catch (e) {
        AppLogger.error('Error parsing background notification payload', e);
      }
    }
  }

  /// Complete habit directly in background without app context
  /// This method initializes Hive independently and updates the habit directly
  @pragma('vm:entry-point')
  static Future<void> _completeHabitInBackground(String habitId) async {
    try {
      AppLogger.info('🔧 Starting background habit completion for: $habitId');

      // Initialize Hive if not already initialized
      try {
        if (!Hive.isBoxOpen('habits')) {
          AppLogger.info('📦 Initializing Hive for background operation');
          await Hive.initFlutter();

          // Register adapters if not already registered
          if (!Hive.isAdapterRegistered(0)) {
            Hive.registerAdapter(HabitAdapter());
            AppLogger.info('✅ Registered HabitAdapter (typeId: 0)');
          }
          if (!Hive.isAdapterRegistered(1)) {
            Hive.registerAdapter(HabitFrequencyAdapter());
            AppLogger.info('✅ Registered HabitFrequencyAdapter (typeId: 1)');
          }
          if (!Hive.isAdapterRegistered(2)) {
            Hive.registerAdapter(HabitDifficultyAdapter());
            AppLogger.info('✅ Registered HabitDifficultyAdapter (typeId: 2)');
          }
        }
      } catch (e) {
        AppLogger.warning(
            'Hive already initialized or adapter already registered: $e');
      }

      // Open habits box
      Box<Habit> habitsBox;
      try {
        if (Hive.isBoxOpen('habits')) {
          habitsBox = Hive.box<Habit>('habits');
          AppLogger.info('📦 Using already open habits box');
        } else {
          habitsBox = await Hive.openBox<Habit>('habits');
          AppLogger.info('📦 Opened habits box');
        }
      } catch (e) {
        AppLogger.error('❌ Failed to open habits box', e);
        return;
      }

      // Parse habitId (handle hourly habits with time slots)
      String actualHabitId = habitId;
      if (habitId.contains('|')) {
        actualHabitId = habitId.split('|')[0];
        AppLogger.info(
            '📝 Parsed hourly habit ID: $actualHabitId from $habitId');
      }

      // Get the habit
      final habit = habitsBox.get(actualHabitId);
      if (habit == null) {
        AppLogger.error('❌ Habit not found: $actualHabitId');
        return;
      }

      AppLogger.info('✅ Found habit: ${habit.name}');

      // Check if already completed for current period
      final now = DateTime.now();
      if (NotificationHelpers.isHabitCompletedForPeriod(habit, now)) {
        AppLogger.info('ℹ️ Habit already completed for current period');
        return;
      }

      // Add completion timestamp
      habit.completions.add(now);

      // Update streak
      habit.currentStreak = NotificationHelpers.calculateStreak(
          habit.completions, habit.frequency);
      if (habit.currentStreak > habit.longestStreak) {
        habit.longestStreak = habit.currentStreak;
      }

      // Save to database
      await habit.save();
      AppLogger.info('💾 Saved habit completion to database');

      // Update home screen widget
      try {
        await WidgetIntegrationService.instance.forceWidgetUpdate();
        AppLogger.info('🔄 Updated home screen widget');
      } catch (e) {
        AppLogger.warning(
            '⚠️ Failed to update widget (may not be supported): $e');
      }

      AppLogger.info('✅ Background habit completion successful!');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Error completing habit in background', e);
      AppLogger.error('Stack trace: $stackTrace');
    }
  }

  // Helper methods _isHabitCompletedForPeriod and _calculateStreak
  // moved to NotificationHelpers module

  /// Handle notification tap and actions
  @pragma('vm:entry-point')
  static void _onNotificationTapped(
    NotificationResponse notificationResponse,
  ) async {
    // CRITICAL: Add debug statements that will show in Flutter console
    AppLogger.debug('🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨');
    AppLogger.info('🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨');
    AppLogger.debug('🔔 Notification ID: ${notificationResponse.id}');
    AppLogger.debug('🔔 Action ID: ${notificationResponse.actionId}');
    AppLogger.debug(
      '🔔 Response Type: ${notificationResponse.notificationResponseType}',
    );
    AppLogger.debug('🔔 Payload: ${notificationResponse.payload}');

    AppLogger.info('=== NOTIFICATION RESPONSE DEBUG ===');
    AppLogger.info('🔔 NOTIFICATION RECEIVED!');
    AppLogger.info('Notification ID: ${notificationResponse.id}');
    AppLogger.info('Action ID: ${notificationResponse.actionId}');
    AppLogger.info('Input: ${notificationResponse.input}');
    AppLogger.info('Payload: ${notificationResponse.payload}');
    AppLogger.info(
      'Notification response type: ${notificationResponse.notificationResponseType}',
    );

    // Log the raw response object for complete debugging
    AppLogger.info('Raw notification response: $notificationResponse');

    // Additional debugging for action button presses
    if (notificationResponse.actionId != null &&
        notificationResponse.actionId!.isNotEmpty) {
      AppLogger.debug(
        '🔥🔥🔥 ACTION BUTTON DETECTED: ${notificationResponse.actionId} 🔥🔥🔥',
      );
      AppLogger.info(
        '🔥🔥🔥 ACTION BUTTON PRESSED: ${notificationResponse.actionId}',
      );
      AppLogger.info(
        'Response type for action: ${notificationResponse.notificationResponseType}',
      );
      AppLogger.info('Action button working! Processing action...');
    } else {
      AppLogger.debug('📱 REGULAR NOTIFICATION TAP (no action button)');
      AppLogger.info('📱 NOTIFICATION TAPPED (no action button)');
    }

    // Always log that we received something
    AppLogger.info('✅ Notification handler called successfully');

    final String? payload = notificationResponse.payload;
    if (payload != null) {
      AppLogger.debug('📦 Processing payload: $payload');
      AppLogger.info('Processing notification with payload: $payload');

      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;

        AppLogger.debug('🎯 Parsed habitId: $habitId');
        AppLogger.debug('⚡ Parsed action: $action');
        AppLogger.info('Parsed habitId: $habitId');
        AppLogger.info('Parsed action: $action');

        if (habitId != null) {
          if (action != null && action.isNotEmpty) {
            // Handle the action button press
            AppLogger.debug(
              '🚀 CALLING _handleNotificationAction with: $action, $habitId',
            );
            AppLogger.info(
              'Processing action button: $action for habit: $habitId',
            );
            _handleNotificationAction(habitId, action);
          } else {
            // Handle regular notification tap (no action button)
            AppLogger.debug('👆 Regular tap for habit: $habitId');
            AppLogger.info('Regular notification tap for habit: $habitId');
            // You could open the app to the habit details or timeline here
            // For now, we'll just log it
          }
        } else {
          AppLogger.debug('❌ No habitId found in payload!');
          AppLogger.warning('No habitId found in notification payload');
        }
      } catch (e) {
        AppLogger.debug('💥 Error parsing payload: $e');
        AppLogger.error('Error parsing notification payload', e);
      }
    } else {
      AppLogger.debug('❌ No payload provided!');
      AppLogger.warning('Notification tapped but no payload provided');
    }

    AppLogger.debug('✅ _onNotificationTapped completed');
  }

  /// Process all pending notification actions stored during background execution
  static Future<void> processPendingActions() async {
    try {
      // Load all pending actions from storage
      final actions = await NotificationStorage.loadAllActions();

      if (actions.isEmpty) {
        AppLogger.debug('No pending actions found in any storage method');
        return;
      }

      AppLogger.info(
          'Processing ${actions.length} pending notification actions');

      // Process each action
      for (final actionData in actions) {
        try {
          final habitId = actionData['habitId'] as String;
          final action = actionData['action'] as String;
          final timestamp = actionData['timestamp'] as int;
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

          // Process the action
          await _processStoredAction(habitId, action, actionTime);
        } catch (e) {
          AppLogger.error('Error processing individual pending action', e);
        }
      }

      // Clear all processed actions
      await NotificationStorage.clearAll();
      AppLogger.info('Cleared all processed pending actions');
    } catch (e) {
      AppLogger.error('Error processing pending notification actions', e);
    }
  }

  /// Process a stored notification action
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
          await cancelNotification(notificationId);
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
            AppLogger.info('✅ Snooze action completed for habit: $habitId');
          } catch (snoozeError) {
            AppLogger.error(
              'Error processing snooze action for habit: $habitId',
              snoozeError,
            );
            // Store for later processing if snooze fails
            NotificationStorage.storeAction(habitId, 'snooze');
          }
          break;

        default:
          AppLogger.debug(
            '❓ Unknown action: $action (normalized: $normalizedAction)',
          );
          AppLogger.warning(
            'Unknown notification action: $action (normalized: $normalizedAction)',
          );
      }
    } catch (e) {
      AppLogger.debug('💥 Error in _handleNotificationAction: $e');
      AppLogger.error('Error handling notification action: $action', e);
    }
  }

  /// Set the direct completion handler (to avoid circular imports)
  static void setDirectCompletionHandler(
    Future<void> Function(String habitId) handler,
  ) {
    directCompletionHandler = handler;
    AppLogger.info('🎯 Direct completion handler set');
  }

  /// Set the notification action callback and process any pending actions
  static void setNotificationActionCallback(
    Function(String habitId, String action) callback,
  ) async {
    onNotificationAction = callback;
    _callbackSetCount++;
    _lastCallbackSetTime = DateTime.now();
    AppLogger.info(
      '🔗 Notification action callback set (count: $_callbackSetCount, time: $_lastCallbackSetTime)',
    );

    // Process any pending actions from memory queue
    if (_pendingActions.isNotEmpty) {
      AppLogger.info(
        '📦 Processing ${_pendingActions.length} pending notification actions from memory',
      );

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

    // Process persistent actions from SharedPreferences after a short delay
    // This ensures the provider container is fully initialized
    Future.delayed(const Duration(milliseconds: 500), () async {
      AppLogger.info('🔄 Processing persistent pending actions after delay');
      await processPendingActions();
    });
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
      await cancelNotification(originalNotificationId);
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
      final canScheduleExact = await canScheduleExactAlarms();
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
        await scheduleHabitNotification(
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
      await cancelNotification(originalNotificationId);
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
      final canScheduleExact = await canScheduleExactAlarms();
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
        await scheduleHabitNotification(
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

  // Helper methods _generateSnoozeNotificationId and _verifyNotificationScheduled
  // moved to NotificationHelpers module

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

      // Try scheduling as an alarm instead of a notification with personalized content
      await scheduleHabitAlarm(
        id: notificationId,
        habitId: habitId,
        title: '⏰ $habitName (Snoozed)',
        body: 'Time to complete "$habitName"! Don\'t break your streak.',
        scheduledTime: snoozeTime,
        snoozeDelayMinutes: 10,
      );

      AppLogger.info(
          '✅ Fallback alarm scheduling successful for habit: $habitName');
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
      await showNotification(
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

  /// Show an immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel',
      'Habit Notifications',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Schedule a notification for a specific time using device local time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    // Check and request all notification permissions if needed
    final bool permissionsGranted =
        await NotificationCore.ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Enhanced timezone handling with detailed debugging
    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    _debugLog('=== Notification Scheduling Debug ===');
    _debugLog('Device current time: $deviceNow');
    _debugLog('Original scheduled time: $scheduledTime');
    _debugLog('Local scheduled time: $localScheduledTime');
    _debugLog('Device timezone offset: ${deviceNow.timeZoneOffset}');
    _debugLog(
      'Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds',
    );

    // Validate scheduling time
    if (localScheduledTime.isBefore(deviceNow)) {
      _debugLog('WARNING - Scheduled time is in the past!');
      _debugLog(
        'Past by: ${deviceNow.difference(localScheduledTime).inSeconds} seconds',
      );
    }

    // Create TZDateTime with better error handling
    tz.TZDateTime tzScheduledTime;
    try {
      // First try to create from the local scheduled time
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      _debugLog('TZ Scheduled time (method 1): $tzScheduledTime');
    } catch (e) {
      _debugLog('TZDateTime.from failed: $e');
      // Fallback: create manually
      try {
        tzScheduledTime = tz.TZDateTime(
          tz.local,
          localScheduledTime.year,
          localScheduledTime.month,
          localScheduledTime.day,
          localScheduledTime.hour,
          localScheduledTime.minute,
          localScheduledTime.second,
        );
        AppLogger.debug('TZ Scheduled time (method 2): $tzScheduledTime');
      } catch (e2) {
        AppLogger.debug('Manual TZDateTime creation failed: $e2');
        // Ultimate fallback: use UTC
        tzScheduledTime = tz.TZDateTime.utc(
          localScheduledTime.year,
          localScheduledTime.month,
          localScheduledTime.day,
          localScheduledTime.hour,
          localScheduledTime.minute,
          localScheduledTime.second,
        );
        AppLogger.debug('TZ Scheduled time (UTC fallback): $tzScheduledTime');
      }
    }

    AppLogger.debug('TZ Local timezone: ${tz.local.name}');
    AppLogger.debug('TZ offset: ${tzScheduledTime.timeZoneOffset}');
    AppLogger.debug(
      'Device vs TZ offset match: ${deviceNow.timeZoneOffset == tzScheduledTime.timeZoneOffset}',
    );

    // Additional validation
    final secondsUntilNotification =
        tzScheduledTime.difference(tz.TZDateTime.now(tz.local)).inSeconds;
    AppLogger.debug('Seconds until TZ notification: $secondsUntilNotification');

    if (secondsUntilNotification < 0) {
      AppLogger.debug('ERROR - TZ scheduled time is in the past!');
      return; // Don't schedule past notifications
    }

    AppLogger.info('Device current time: $deviceNow');
    AppLogger.info('Target scheduled time: $localScheduledTime');
    AppLogger.info(
      'Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds',
    );
    AppLogger.info('TZ Scheduled time: $tzScheduledTime');
    AppLogger.info('TZ Local timezone: ${tz.local.name}');

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      AppLogger.debug('Notification successfully scheduled with plugin');
    } catch (e) {
      AppLogger.debug('Plugin scheduling failed: $e');
      throw Exception('Failed to schedule notification: $e');
    }
  }

  /// Schedule daily recurring notifications
  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    // Check and request all notification permissions if needed
    final bool permissionsGranted =
        await NotificationCore.ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel', // Use existing channel instead of undefined habit_daily_channel
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  /// Schedule daily habit reminder - wrapper method for specific habit reminders
  static Future<void> scheduleDailyHabitReminder({
    required String habitId,
    required String habitName,
    required DateTime reminderTime,
  }) async {
    final id = habitId.hashCode; // Generate unique ID from habit ID
    final hour = reminderTime.hour;
    final minute = reminderTime.minute;

    await scheduleDailyNotification(
      id: id,
      title: 'Habit Reminder',
      body: 'Time to complete your habit: $habitName',
      hour: hour,
      minute: minute,
      payload: jsonEncode({
        'habitId': habitId,
        'habitName': habitName,
        'type': 'habit_reminder',
      }),
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancel snooze notifications for a specific habit
  /// This prevents old snooze notifications from interfering with new notifications
  static Future<void> _cancelSnoozeNotificationsForHabit(String habitId) async {
    try {
      AppLogger.debug(
          '🧹 Checking for snooze notifications to cancel for habit: $habitId');

      // Get all pending notifications
      final pendingNotifications = await getPendingNotifications();
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
            '🧹 Cancelled $cancelledSnoozeCount snooze notification(s) for habit: $habitId');
      } else {
        AppLogger.debug('No snooze notifications found for habit: $habitId');
      }
    } catch (e) {
      AppLogger.error(
          'Error cancelling snooze notifications for habit $habitId', e);
    }
  }

  /// Cancel all notifications for a specific habit
  static Future<void> cancelHabitNotifications(int habitId) async {
    if (!NotificationCore.isInitialized) await initialize();

    // Cancel the main notification
    await _notificationsPlugin.cancel(habitId);

    // Cancel related notifications with safe approach - try common patterns
    // For weekly notifications (7 days)
    for (int weekday = 1; weekday <= 7; weekday++) {
      await _notificationsPlugin.cancel(
        NotificationHelpers.generateSafeId('${habitId}_week_$weekday'),
      );
    }

    // For monthly notifications (31 days)
    for (int monthDay = 1; monthDay <= 31; monthDay++) {
      await _notificationsPlugin.cancel(
        NotificationHelpers.generateSafeId('${habitId}_month_$monthDay'),
      );
    }

    // For yearly notifications (12 months x 31 days)
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        await _notificationsPlugin.cancel(
          NotificationHelpers.generateSafeId('${habitId}_year_${month}_$day'),
        );
      }
    }

    // For hourly notifications (24 hours x 60 minutes)
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        // Check every 15 minutes
        await _notificationsPlugin.cancel(
          NotificationHelpers.generateSafeId('${habitId}_hour_${hour}_$minute'),
        );
      }
    }

    AppLogger.info('Cancelled all notifications for habit ID: $habitId');
  }

  /// Cancel all notifications for a specific habit using the original habit ID string
  static Future<void> cancelHabitNotificationsByHabitId(String habitId) async {
    if (!NotificationCore.isInitialized) await initialize();

    AppLogger.info('🚫 Starting notification cancellation for habit: $habitId');

    // Cancel the main notification using the hashed habit ID
    final mainNotificationId = NotificationHelpers.generateSafeId(habitId);
    await _notificationsPlugin.cancel(mainNotificationId);
    AppLogger.debug('Cancelled main notification ID: $mainNotificationId');

    // Cancel related notifications with safe approach - try common patterns
    // For weekly notifications (7 days)
    for (int weekday = 1; weekday <= 7; weekday++) {
      final weeklyId =
          NotificationHelpers.generateSafeId('${habitId}_week_$weekday');
      await _notificationsPlugin.cancel(weeklyId);
      AppLogger.debug(
          'Cancelled weekly notification for weekday $weekday: $weeklyId');
    }

    // For monthly notifications (31 days)
    for (int monthDay = 1; monthDay <= 31; monthDay++) {
      final monthlyId =
          NotificationHelpers.generateSafeId('${habitId}_month_$monthDay');
      await _notificationsPlugin.cancel(monthlyId);
      AppLogger.debug(
          'Cancelled monthly notification for day $monthDay: $monthlyId');
    }

    // For yearly notifications (12 months x 31 days)
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        final yearlyId =
            NotificationHelpers.generateSafeId('${habitId}_year_${month}_$day');
        await _notificationsPlugin.cancel(yearlyId);
      }
    }

    // For hourly notifications (24 hours x 60 minutes)
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        // Check every 15 minutes
        final hourlyId = NotificationHelpers.generateSafeId(
            '${habitId}_hour_${hour}_$minute');
        await _notificationsPlugin.cancel(hourlyId);
      }
    }

    // For single habit notifications
    final singleId = NotificationHelpers.generateSafeId('${habitId}_single');
    await _notificationsPlugin.cancel(singleId);
    AppLogger.debug('Cancelled single notification: $singleId');

    // Cancel daily notifications
    final dailyId = NotificationHelpers.generateSafeId(habitId);
    await _notificationsPlugin.cancel(dailyId);
    AppLogger.debug('Cancelled daily notification: $dailyId');

    AppLogger.info('✅ Cancelled all notifications for habit: $habitId');
  }

  /// Schedule notifications for a habit based on its frequency and settings
  static Future<void> scheduleHabitNotifications(dynamic habit) async {
    AppLogger.debug(
      'Starting notification scheduling for habit: ${habit.name}',
    );
    AppLogger.debug('Notifications enabled: ${habit.notificationsEnabled}');
    AppLogger.debug('Alarm enabled: ${habit.alarmEnabled}');

    // Log the appropriate time information based on habit frequency
    final habitFrequency = habit.frequency.toString().split('.').last;
    if (habitFrequency == 'hourly') {
      AppLogger.debug('Hourly times: ${habit.hourlyTimes}');
    } else if (habitFrequency == 'single') {
      AppLogger.debug('Single date/time: ${habit.singleDateTime}');
    } else {
      AppLogger.debug('Notification time: ${habit.notificationTime}');
    }

    if (!NotificationCore.isInitialized) {
      AppLogger.debug('Initializing notification service');
      await initialize();
    }

    // Check and request all notification permissions if needed
    // Only do this if notifications or alarms are actually enabled
    if (habit.notificationsEnabled || habit.alarmEnabled) {
      try {
        final bool permissionsGranted =
            await NotificationCore.ensureNotificationPermissions();
        if (!permissionsGranted) {
          AppLogger.warning(
            'Cannot schedule notifications for habit: ${habit.name} - permissions not granted',
          );
          throw Exception('Notification permissions not granted');
        }
      } catch (e) {
        AppLogger.error(
          'Error checking notification permissions for habit: ${habit.name}',
          e,
        );
        throw Exception('Failed to verify notification permissions: $e');
      }
    }

    // If alarms are enabled, use alarms instead of notifications (mutually exclusive)
    if (habit.alarmEnabled) {
      AppLogger.debug(
        'Alarms enabled - scheduling alarms instead of notifications',
      );
      await scheduleHabitAlarms(habit);
      return;
    }

    // Continue with notification-only scheduling
    await _scheduleNotificationsOnly(habit);
  }

  /// Schedule ONLY notifications for a habit (never alarms) - safe for boot completion
  /// This method ensures no foreground services are started during Android 15+ boot completion
  static Future<void> scheduleHabitNotificationsOnly(dynamic habit) async {
    AppLogger.debug(
      'Starting NOTIFICATION-ONLY scheduling for habit: ${habit.name}',
    );
    AppLogger.debug('Notifications enabled: ${habit.notificationsEnabled}');
    AppLogger.debug(
        'Alarm enabled: ${habit.alarmEnabled} (IGNORED for safety)');

    if (!NotificationCore.isInitialized) {
      AppLogger.debug('Initializing notification service');
      await initialize();
    }

    // Only check notification permissions (not alarm permissions)
    if (habit.notificationsEnabled) {
      try {
        final bool permissionsGranted =
            await NotificationCore.ensureNotificationPermissions();
        if (!permissionsGranted) {
          AppLogger.warning(
            'Cannot schedule notifications for habit: ${habit.name} - permissions not granted',
          );
          throw Exception('Notification permissions not granted');
        }
      } catch (e) {
        AppLogger.error(
          'Error checking notification permissions for habit: ${habit.name}',
          e,
        );
        throw Exception('Failed to verify notification permissions: $e');
      }
    }

    // ALWAYS schedule notifications only, never alarms (Android 15+ boot safety)
    await _scheduleNotificationsOnly(habit);
  }

  /// Internal method to schedule only notifications (never alarms)
  static Future<void> _scheduleNotificationsOnly(dynamic habit) async {
    // Skip if notifications are disabled
    if (!habit.notificationsEnabled) {
      AppLogger.debug('Skipping notifications - disabled');
      AppLogger.info('Notifications disabled for habit: ${habit.name}');
      return;
    }

    // For non-hourly, non-single habits, require notification time
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' &&
        frequency != 'single' &&
        habit.notificationTime == null) {
      AppLogger.debug(
        'Skipping notifications - no time set for non-hourly habit',
      );
      AppLogger.info('No notification time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit');
    }

    try {
      // Cancel any existing notifications for this habit first
      await cancelHabitNotifications(
        NotificationHelpers.generateSafeId(habit.id),
      ); // Use safe ID generation
      AppLogger.debug(
        'Cancelled existing notifications for habit ID: ${habit.id}',
      );

      // Also cancel any existing snooze notifications for this habit
      // to prevent old snooze notifications from interfering with new schedules
      await _cancelSnoozeNotificationsForHabit(habit.id);
      AppLogger.debug(
        'Cancelled existing snooze notifications for habit ID: ${habit.id}',
      );

      final frequency = habit.frequency.toString().split('.').last;
      AppLogger.debug('Habit frequency: $frequency');

      switch (frequency) {
        case 'daily':
          AppLogger.debug('Scheduling daily notifications');
          await _scheduleDailyHabitNotifications(habit, hour, minute);
          break;

        case 'weekly':
          AppLogger.debug('Scheduling weekly notifications');
          await _scheduleWeeklyHabitNotifications(habit, hour, minute);
          break;

        case 'monthly':
          AppLogger.debug('Scheduling monthly notifications');
          await _scheduleMonthlyHabitNotifications(habit, hour, minute);
          break;

        case 'yearly':
          AppLogger.debug('Scheduling yearly notifications');
          await _scheduleYearlyHabitNotifications(habit, hour, minute);
          break;

        case 'single':
          AppLogger.debug('Scheduling single habit notification');
          await _scheduleSingleHabitNotifications(habit);
          break;

        case 'hourly':
          AppLogger.debug('Scheduling hourly notifications');
          await _scheduleHourlyHabitNotifications(habit, hour, minute);
          break;

        default:
          AppLogger.debug('Unknown frequency: $frequency');
          AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
      }

      AppLogger.debug(
        'Successfully scheduled notifications for habit: ${habit.name}',
      );
      AppLogger.info(
        'Successfully scheduled notifications for habit: ${habit.name}',
      );
    } catch (e) {
      AppLogger.debug('Error scheduling notifications: $e');
      AppLogger.error(
        'Failed to schedule notifications for habit: ${habit.name}',
        e,
      );
      rethrow; // Re-throw so the UI can show the error
    }
  }

  /// Schedule alarm notifications for a habit (mutually exclusive with regular notifications)
  static Future<void> scheduleHabitAlarms(dynamic habit) async {
    AppLogger.debug('Starting alarm scheduling for habit: ${habit.name}');
    AppLogger.debug('Alarm enabled: ${habit.alarmEnabled}');
    AppLogger.debug('Alarm sound: ${habit.alarmSoundName}');
    AppLogger.debug('Alarm sound URI: ${habit.alarmSoundUri}');
    AppLogger.debug('Snooze delay: 10 minutes (fixed default)');

    // Initialize AlarmManagerService to use system alarms for this habit
    await AlarmManagerService.initialize();

    // Skip if alarms are disabled
    if (!habit.alarmEnabled) {
      AppLogger.debug('Skipping alarms - disabled');
      AppLogger.info('Alarms disabled for habit: ${habit.name}');
      return;
    }

    // For non-hourly habits, require notification time (alarms use same time as notifications)
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' && habit.notificationTime == null) {
      AppLogger.debug('Skipping alarms - no time set for non-hourly habit');
      AppLogger.info('No alarm time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling alarm for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit alarm');
    }

    try {
      // Cancel any existing alarms for this habit first
      await AlarmManagerService.cancelHabitAlarms(habit.id);
      AppLogger.debug('Cancelled existing alarms for habit ID: ${habit.id}');

      final frequency = habit.frequency.toString().split('.').last;
      AppLogger.debug('Habit frequency: $frequency');

      switch (frequency) {
        case 'daily':
          AppLogger.debug('Scheduling daily alarms');
          await _scheduleDailyHabitAlarms(habit, hour, minute);
          break;

        case 'weekly':
          AppLogger.debug('Scheduling weekly alarms');
          await _scheduleWeeklyHabitAlarms(habit, hour, minute);
          break;

        case 'monthly':
          AppLogger.debug('Scheduling monthly alarms');
          await _scheduleMonthlyHabitAlarms(habit, hour, minute);
          break;

        case 'yearly':
          AppLogger.debug('Scheduling yearly alarms');
          await _scheduleYearlyHabitAlarms(habit, hour, minute);
          break;

        case 'single':
          AppLogger.debug('Scheduling single habit alarm');
          await _scheduleSingleHabitAlarms(habit, hour, minute);
          break;

        case 'hourly':
          AppLogger.debug('Scheduling hourly alarms');
          await _scheduleHourlyHabitAlarms(habit);
          break;

        default:
          AppLogger.debug('Unknown frequency: $frequency');
          AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
      }

      AppLogger.debug('Successfully scheduled alarms for habit: ${habit.name}');
      AppLogger.info('Successfully scheduled alarms for habit: ${habit.name}');
    } catch (e) {
      AppLogger.debug('Error scheduling alarms: $e');
      AppLogger.error('Failed to schedule alarms for habit: ${habit.name}', e);
      rethrow; // Re-throw so the UI can show the error
    }
  }

  /// Schedule daily habit notifications
  static Future<void> _scheduleDailyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    // Minimal logging to reduce main thread work
    final now = DateTime.now();
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

    try {
      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(
            habit.id), // Use safe ID generation
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your daily habit! Keep your streak going.',
        scheduledTime: nextNotification,
      );
      AppLogger.debug(
        'Successfully scheduled daily notification for ${habit.name}',
      );
    } catch (e) {
      AppLogger.debug('Error scheduling daily notification: $e');
      rethrow;
    }
  }

  /// Schedule weekly habit notifications
  static Future<void> _scheduleWeeklyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];
    final now = DateTime.now();

    for (int weekday in selectedWeekdays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Find the next occurrence of this weekday
      while (nextNotification.weekday != weekday) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      // If the time has passed today, schedule for next week
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 7));
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(
          habit.id + '_week_$weekday',
        ), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit! Don\'t break your streak.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule monthly habit notifications
  static Future<void> _scheduleMonthlyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedMonthDays = habit.selectedMonthDays ?? <int>[];
    final now = DateTime.now();

    for (int monthDay in selectedMonthDays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        monthDay,
        hour,
        minute,
      );

      // If the day has passed this month, schedule for next month
      if (nextNotification.isBefore(now)) {
        nextNotification = DateTime(
          now.year,
          now.month + 1,
          monthDay,
          hour,
          minute,
        );
      }

      // Handle case where the day doesn't exist in the target month
      try {
        nextNotification = DateTime(
          nextNotification.year,
          nextNotification.month,
          monthDay,
          hour,
          minute,
        );
      } catch (e) {
        // Skip this month if the day doesn't exist (e.g., Feb 30)
        continue;
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(
          habit.id + '_month_$monthDay',
        ), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your monthly habit! Stay consistent.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule yearly habit notifications
  static Future<void> _scheduleYearlyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedYearlyDates = habit.selectedYearlyDates ?? <String>[];
    final now = DateTime.now();

    for (String dateString in selectedYearlyDates) {
      try {
        // Parse the date string (format: "yyyy-MM-dd")
        final parts = dateString.split('-');
        if (parts.length != 3) continue;

        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);

        DateTime nextNotification = DateTime(
          now.year,
          month,
          day,
          hour,
          minute,
        );

        // If the date has passed this year, schedule for next year
        if (nextNotification.isBefore(now)) {
          nextNotification = DateTime(now.year + 1, month, day, hour, minute);
        }

        await scheduleHabitNotification(
          id: NotificationHelpers.generateSafeId(
            habit.id + '_year_${month}_$day',
          ), // Use string concatenation for uniqueness
          habitId: habit.id.toString(),
          title: '🎯 ${habit.name}',
          body: 'Time to complete your yearly habit! This is your special day.',
          scheduledTime: nextNotification,
        );
      } catch (e) {
        AppLogger.error('Error parsing yearly date: $dateString', e);
      }
    }
  }

  /// Schedule single habit notifications (one-time notification)
  static Future<void> _scheduleSingleHabitNotifications(
    dynamic habit,
  ) async {
    // Validate single habit requirements
    if (habit.singleDateTime == null) {
      final error =
          'Single habit "${habit.name}" requires a date/time to be set';
      AppLogger.error(error);
      throw ArgumentError(error);
    }

    final singleDateTime = habit.singleDateTime!;
    // Use timezone-aware current time for consistency with other frequency types
    final now = tz.TZDateTime.now(tz.local);
    final currentDateTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    AppLogger.debug('Single habit scheduling debug:');
    AppLogger.debug('  - Habit name: ${habit.name}');
    AppLogger.debug('  - Single date/time: $singleDateTime');
    AppLogger.debug('  - Current time (TZ): $now');
    AppLogger.debug('  - Current time (local): $currentDateTime');
    AppLogger.debug('  - Timezone: ${now.timeZoneName}');

    // Check if date/time is in the past
    if (singleDateTime.isBefore(currentDateTime)) {
      final error =
          'Single habit "${habit.name}" date/time is in the past: $singleDateTime (current: $currentDateTime)';
      AppLogger.error(error);
      throw StateError(error);
    }

    try {
      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}',
        ), // Use structured ID generation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your one-time habit!',
        scheduledTime: singleDateTime,
      );

      AppLogger.info(
          '✅ Scheduled single notification for "${habit.name}" at $singleDateTime');
    } catch (e) {
      final error =
          'Failed to schedule single habit notification for "${habit.name}": $e';
      AppLogger.error(error);
      throw Exception(error);
    }
  }

  /// Schedule hourly habit notifications
  static Future<void> _scheduleHourlyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final hourlyTimes = habit.hourlyTimes;
    if (hourlyTimes == null || hourlyTimes.isEmpty) {
      AppLogger.warning('No hourly times set for hourly habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();
    // Schedule for next 48 hours (similar to work manager service)
    final endTime = now.add(const Duration(hours: 48));

    // Check if weekdays are specified for this hourly habit
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];

    for (final timeStr in hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) continue;

      final timeHour = int.tryParse(timeParts[0]);
      final timeMinute = int.tryParse(timeParts[1]);
      if (timeHour == null || timeMinute == null) continue;

      // Schedule for each day in the next 48 hours
      for (DateTime date = now;
          date.isBefore(endTime);
          date = date.add(const Duration(days: 1))) {
        // Check if weekdays are specified and if this date matches
        if (selectedWeekdays.isNotEmpty &&
            !selectedWeekdays.contains(date.weekday)) {
          AppLogger.debug(
              'Skipping hourly notification for ${habit.name} - ${date.toString().split(' ')[0]} (weekday ${date.weekday}) is not in selected weekdays: $selectedWeekdays');
          continue; // Skip this day as it's not a selected weekday
        }

        DateTime notificationTime =
            DateTime(date.year, date.month, date.day, timeHour, timeMinute);

        // Only schedule future notifications
        if (notificationTime.isAfter(now)) {
          await scheduleHabitNotification(
            id: NotificationHelpers.generateSafeId(
              '${habit.id}_hourly_${date.day}_${timeHour}_$timeMinute',
            ),
            habitId:
                '${habit.id}|${timeHour.toString().padLeft(2, '0')}:${timeMinute.toString().padLeft(2, '0')}',
            title: '⏰ ${habit.name}',
            body: 'Time for your hourly habit!',
            scheduledTime: notificationTime,
          );
        }
      }
    }

    AppLogger.info(
      'Successfully scheduled hourly notifications for ${habit.name}',
    );
  }

  // ============ ALARM SCHEDULING METHODS (DEPRECATED - USING AlarmService) ============
  // Old alarm scheduling methods removed - now using AlarmService for exact alarms

  /// Schedule weekly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleWeeklyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling weekly alarms for ${habit.name}');

    if (habit.selectedWeekdays != null && habit.selectedWeekdays.isNotEmpty) {
      for (int weekday in habit.selectedWeekdays) {
        tz.TZDateTime baseTime = tz.TZDateTime.now(tz.local);
        tz.TZDateTime nextAlarm =
            _getNextWeekdayDateTime(baseTime, weekday, hour, minute);

        try {
          // Use the real alarm service instead of notification-based alarms
          await AlarmManagerService.scheduleExactAlarm(
            alarmId: NotificationHelpers.generateSafeId(
                '${habit.id}_weekly_$weekday'),
            habitId: habit.id.toString(),
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'weekly',
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
            snoozeDelayMinutes: 10,
          );

          AppLogger.debug(
            'Scheduled weekly native alarm for ${habit.name} on weekday $weekday at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error scheduling weekly alarm for ${habit.name} on weekday $weekday',
            e,
          );
        }
      }
    }
  }

  /// Schedule monthly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleMonthlyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling monthly alarms for ${habit.name}');
    final now = DateTime.now();

    if (habit.selectedMonthDays != null && habit.selectedMonthDays.isNotEmpty) {
      for (int day in habit.selectedMonthDays) {
        DateTime nextAlarm = DateTime(now.year, now.month, day, hour, minute);

        // If the day has passed this month, schedule for next month
        if (nextAlarm.isBefore(now)) {
          nextAlarm = DateTime(now.year, now.month + 1, day, hour, minute);
        }

        try {
          // Use the real alarm service instead of notification-based alarms
          await AlarmManagerService.scheduleExactAlarm(
            alarmId:
                NotificationHelpers.generateSafeId('${habit.id}_monthly_$day'),
            habitId: habit.id.toString(),
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'monthly',
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
            snoozeDelayMinutes: 10,
          );

          AppLogger.debug(
            'Scheduled monthly native alarm for ${habit.name} on day $day at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error scheduling monthly alarm for ${habit.name} on day $day',
            e,
          );
        }
      }
    }
  }

  /// Schedule yearly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleYearlyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling yearly alarms for ${habit.name}');
    final now = DateTime.now();

    if (habit.selectedYearlyDates != null &&
        habit.selectedYearlyDates.isNotEmpty) {
      for (String dateString in habit.selectedYearlyDates) {
        try {
          final dateParts = dateString.split('-');
          final month = int.parse(dateParts[1]);
          final day = int.parse(dateParts[2]);

          DateTime nextAlarm = DateTime(now.year, month, day, hour, minute);

          // If the date has passed this year, schedule for next year
          if (nextAlarm.isBefore(now)) {
            nextAlarm = DateTime(now.year + 1, month, day, hour, minute);
          }

          // Use the real alarm service instead of notification-based alarms
          await AlarmManagerService.scheduleExactAlarm(
            alarmId: NotificationHelpers.generateSafeId(
                '${habit.id}_yearly_${month}_$day'),
            habitId: habit.id.toString(),
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'yearly',
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
            snoozeDelayMinutes: 10,
          );

          AppLogger.debug(
            'Scheduled yearly alarm for ${habit.name} on $dateString at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error('Error parsing yearly date: $dateString', e);
        }
      }
    }
  }

  /// Schedule hourly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleHourlyHabitAlarms(dynamic habit) async {
    final now = DateTime.now();

    // Check if weekdays are specified for this hourly habit
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];

    // For hourly habits, use the specific times set by the user
    if (habit.hourlyTimes != null && habit.hourlyTimes.isNotEmpty) {
      AppLogger.debug(
        'Scheduling hourly alarms for specific times: ${habit.hourlyTimes}',
      );

      for (String timeString in habit.hourlyTimes) {
        try {
          // Parse the time string (format: "HH:mm")
          final timeParts = timeString.split(':');
          final hour = int.tryParse(timeParts[0]) ?? 9;
          final minute =
              timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

          // Check if weekdays are specified and if today matches
          if (selectedWeekdays.isNotEmpty &&
              !selectedWeekdays.contains(now.weekday)) {
            AppLogger.debug(
                'Skipping hourly alarm for ${habit.name} - today (weekday ${now.weekday}) is not in selected weekdays: $selectedWeekdays');
            continue; // Skip scheduling for today if it's not a selected weekday
          }

          DateTime nextAlarm = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // If the time has passed today, schedule for tomorrow
          if (nextAlarm.isBefore(now)) {
            nextAlarm = nextAlarm.add(const Duration(days: 1));

            // Check weekday constraint for next day too
            if (selectedWeekdays.isNotEmpty &&
                !selectedWeekdays.contains(nextAlarm.weekday)) {
              AppLogger.debug(
                  'Skipping hourly alarm for ${habit.name} - next day (weekday ${nextAlarm.weekday}) is not in selected weekdays: $selectedWeekdays');
              continue;
            }
          }

          // Use the real alarm service instead of notification-based alarms
          await AlarmManagerService.scheduleExactAlarm(
            alarmId: NotificationHelpers.generateSafeId(
                '${habit.id}_hourly_${hour}_$minute'),
            habitId: '${habit.id}|$hour:${minute.toString().padLeft(2, '0')}',
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'hourly',
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
            snoozeDelayMinutes: 10,
          );

          AppLogger.debug(
            'Scheduled hourly alarm for $timeString at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error parsing hourly time "$timeString" for habit ${habit.name}',
            e,
          );
        }
      }
    } else {
      // Fallback: For hourly habits without specific times, schedule every hour during active hours (8 AM - 10 PM)
      AppLogger.debug(
        'No specific hourly times set, using default hourly alarm schedule (8 AM - 10 PM)',
      );

      // Check if weekdays are specified and if today matches
      if (selectedWeekdays.isNotEmpty &&
          !selectedWeekdays.contains(now.weekday)) {
        AppLogger.debug(
            'Skipping default hourly alarms for ${habit.name} - today (weekday ${now.weekday}) is not in selected weekdays: $selectedWeekdays');
        return; // Don't schedule any alarms for today if it's not a selected weekday
      }

      for (int hour = 8; hour <= 22; hour++) {
        DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, 0);

        // If the time has passed today, schedule for tomorrow
        if (nextAlarm.isBefore(now)) {
          nextAlarm = nextAlarm.add(const Duration(days: 1));

          // Check weekday constraint for next day too
          if (selectedWeekdays.isNotEmpty &&
              !selectedWeekdays.contains(nextAlarm.weekday)) {
            continue; // Skip this hour if next day is not a selected weekday
          }
        }

        // Use the real alarm service instead of notification-based alarms
        await AlarmManagerService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_hourly_$hour'),
          habitId: '${habit.id}|$hour:00',
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'hourly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
          snoozeDelayMinutes: 10,
        );
      }
    }
  }

  /// Schedule daily habit alarms
  // ignore: unused_element
  static Future<void> _scheduleDailyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling daily alarm for ${habit.name}');

    // Calculate next alarm time
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime nextAlarm = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (nextAlarm.isBefore(now)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }

    try {
      await AlarmManagerService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId('${habit.id}_daily'),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: nextAlarm,
        frequency: 'daily',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
        snoozeDelayMinutes: 10,
      );

      AppLogger.debug(
        'Scheduled daily alarm for ${habit.name} at $nextAlarm',
      );
    } catch (e) {
      AppLogger.error('Error scheduling daily alarm for ${habit.name}', e);
    }
  }

  /// Schedule single habit alarm (one-time alarm)
  // ignore: unused_element
  static Future<void> _scheduleSingleHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling single alarm for ${habit.name}');

    if (habit.singleDateTime == null) {
      AppLogger.error('Single habit "${habit.name}" requires a date/time');
      return;
    }

    final singleDateTime = habit.singleDateTime!;
    final now = DateTime.now();

    // Check if date/time is in the past
    if (singleDateTime.isBefore(now)) {
      AppLogger.error(
        'Single habit "${habit.name}" date/time is in the past: $singleDateTime',
      );
      return;
    }

    try {
      await AlarmManagerService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}',
        ),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: singleDateTime,
        frequency: 'single',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
        snoozeDelayMinutes: 10,
      );

      AppLogger.debug(
        'Scheduled single alarm for ${habit.name} at $singleDateTime',
      );
    } catch (e) {
      AppLogger.error('Error scheduling single alarm for ${habit.name}', e);
    }
  }

  /// Helper method to calculate next occurrence of a weekday
  static tz.TZDateTime _getNextWeekdayDateTime(
    tz.TZDateTime baseTime,
    int targetWeekday,
    int hour,
    int minute,
  ) {
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      baseTime.year,
      baseTime.month,
      baseTime.day,
      hour,
      minute,
    );

    // If today is the target weekday but time has passed, or if it's a different weekday,
    // find the next occurrence
    while (scheduled.weekday != targetWeekday || scheduled.isBefore(baseTime)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Debug logging helper
  static void _debugLog(String message) {
    AppLogger.debug(message);
  }

  // generateSafeId method moved to NotificationHelpers module

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await NotificationHelpers.getPendingNotifications(
        _notificationsPlugin);
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        return await androidImplementation.areNotificationsEnabled() ?? false;
      }
    }

    // For iOS, we assume they're enabled if the user granted permission
    return true;
  }

  /// Test notification - useful for debugging
  static Future<void> showTestNotification() async {
    if (!NotificationCore.isInitialized) await initialize();

    AppLogger.info(
        '🧪 Creating SIMPLE test notification to verify handlers work...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications for debugging',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      // NO ACTIONS - just basic notification
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    final payload = jsonEncode({'habitId': 'test', 'type': 'test'});

    await _notificationsPlugin.show(
      999,
      '🧪 SIMPLE TEST',
      'Tap this notification (no buttons) to test basic handlers!',
      details,
      payload: payload,
    );

    AppLogger.info(
        '🧪 SIMPLE test notification created - tap the notification body (not buttons) to see if handlers are called');
  }

  /// Show an actionable habit notification with Complete and Snooze buttons
  static Future<void> showHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel',
      'Habit Notifications',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      enableVibration: true,
      playSound: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          'COMPLETE',
          showsUserInterface: false,
        ),
        const AndroidNotificationAction(
          'snooze',
          'SNOOZE 30MIN',
          showsUserInterface: false,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'habit_category');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    // Debug logging for notification creation
    AppLogger.info('🔔 Habit notification created with:');
    AppLogger.info('  - ID: $id');
    AppLogger.info('  - HabitID: $habitId');
    AppLogger.info('  - Title: $title');
    AppLogger.info('  - Body: $body');
    AppLogger.info('  - Payload: $payload');
    AppLogger.info('  - Actions: complete_action, snooze_action');
  }

  /// Schedule a habit notification with action buttons
  static Future<void> scheduleHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    // Check and request all notification permissions if needed
    final bool permissionsGranted =
        await NotificationCore.ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          'COMPLETE',
          showsUserInterface: false,
        ),
        const AndroidNotificationAction(
          'snooze',
          'SNOOZE 30MIN',
          showsUserInterface: false,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'habit_category');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    // Enhanced time validation and timezone handling
    final timeDiff = localScheduledTime.difference(deviceNow);
    AppLogger.debug('Device current time: $deviceNow');
    AppLogger.debug('Target scheduled time: $localScheduledTime');
    AppLogger.debug(
        'Time until notification: ${timeDiff.inSeconds} seconds (${timeDiff.inMinutes} minutes)');

    // Validate scheduling time is reasonable
    if (timeDiff.inSeconds < 0) {
      AppLogger.warning(
          '⚠️ Warning: Scheduling time is in the past! Adjusting to 1 minute from now.');
      final adjustedTime = deviceNow.add(const Duration(minutes: 1));
      return await scheduleHabitNotification(
        id: id,
        habitId: habitId,
        title: title,
        body: body,
        scheduledTime: adjustedTime,
      );
    }

    if (timeDiff.inDays > 1) {
      AppLogger.warning(
          '⚠️ Warning: Scheduling time is more than 1 day in the future (${timeDiff.inDays} days)');
    }

    // Create timezone-aware scheduled time with proper validation
    tz.TZDateTime tzScheduledTime;
    try {
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      AppLogger.debug('TZ Scheduled time: $tzScheduledTime');
      AppLogger.debug('TZ Local timezone: ${tz.local.name}');

      // Verify timezone conversion didn't cause time drift
      final tzTimeDiff =
          tzScheduledTime.difference(tz.TZDateTime.now(tz.local));
      if ((tzTimeDiff.inSeconds - timeDiff.inSeconds).abs() > 60) {
        AppLogger.warning(
            '⚠️ Timezone conversion caused significant time drift: ${tzTimeDiff.inSeconds - timeDiff.inSeconds} seconds');
      }
    } catch (tzError) {
      AppLogger.error('Timezone conversion failed, using UTC', tzError);
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime.toUtc(), tz.UTC);
    }

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule an alarm notification with custom sound and snooze delay
  static Future<void> scheduleHabitAlarm({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    AppLogger.info('🚨 Scheduling alarm notification:');
    AppLogger.info('  - ID: $id');
    AppLogger.info('  - Habit ID: $habitId');
    AppLogger.info('  - Title: $title');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Alarm sound: ${alarmSoundName ?? "default"}');
    AppLogger.info('  - Snooze delay: $snoozeDelayMinutes minutes');

    final payload = jsonEncode({
      'habitId': habitId,
      'action': 'alarm',
      'snoozeDelayMinutes': snoozeDelayMinutes,
    });

    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'habit_alarms',
      'Habit Alarms',
      channelDescription: 'Wake-device alarms for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: alarmSoundName != null
          ? RawResourceAndroidNotificationSound(alarmSoundName)
          : null,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      actions: [
        AndroidNotificationAction(
          'complete',
          'COMPLETE',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze',
          'SNOOZE ${snoozeDelayMinutes}MIN',
        ),
      ],
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: alarmSoundName != null ? '$alarmSoundName.mp3' : null,
      categoryIdentifier: 'habit_category',
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Snooze a notification for the specified duration
  static Future<void> snoozeNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
    int delayMinutes = 30,
  }) async {
    if (!NotificationCore.isInitialized) await initialize();

    final snoozeTime = DateTime.now().add(Duration(minutes: delayMinutes));

    await scheduleHabitNotification(
      id: id,
      habitId: habitId,
      title: '⏰ $title (Snoozed)',
      body: body,
      scheduledTime: snoozeTime,
    );

    AppLogger.info(
        '⏰ Notification snoozed for $delayMinutes minutes: $habitId');
  }

  // ==================== HELPER METHODS ====================

  /// Periodic cleanup for memory management
  static void _startPeriodicCleanup() {
    NotificationHelpers.startPeriodicCleanup();
  }

  /// Complete habit from notification action
  static Future<void> _completeHabitFromNotification(String habitId) async {
    AppLogger.info('Completing habit from notification: $habitId');
    if (directCompletionHandler != null) {
      await directCompletionHandler!(habitId);
    } else {
      AppLogger.warning('Direct completion handler not set');
    }
  }

  /// Check if exact alarms can be scheduled
  static Future<bool> canScheduleExactAlarms() async {
    return await NotificationHelpers.canScheduleExactAlarms();
  }

  /// Check battery optimization status
  static Future<void> checkBatteryOptimizationStatus() async {
    await NotificationHelpers.checkBatteryOptimizationStatus();
  }
}
