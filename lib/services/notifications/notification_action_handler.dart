import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import '../logging_service.dart';
import '../../domain/model/habit.dart';
import '../widget_integration_service.dart';
import 'notification_helpers.dart';
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
        final rawHabitId = payload['habitId'] as String?;

        if (rawHabitId != null) {
          AppLogger.info('Extracted habitId from payload: $rawHabitId');

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
              // Extract base habitId for callback (callbacks expect base ID)
              final baseHabitId = NotificationHelpers.extractHabitIdFromPayload(
                  response.payload!);
              if (baseHabitId != null) {
                callback(baseHabitId, response.actionId!);
              }
            } else if (directHandler != null) {
              AppLogger.info(
                  '✅ Using direct completion handler (app is running)');
              // Extract base habitId for direct handler
              final baseHabitId = NotificationHelpers.extractHabitIdFromPayload(
                  response.payload!);
              if (baseHabitId != null) {
                await directHandler(baseHabitId);
              }
            } else {
              AppLogger.info(
                  '⚠️ No handlers available, using background Isar access');
              // Pass RAW habitId (with time slot for hourly habits) to background handler
              await NotificationActionHandlerIsar.completeHabitInBackground(
                  rawHabitId, response.payload!);
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
  ///
  /// @param rawHabitId - The raw habitId from payload (may include time slot for hourly habits)
  /// @param payload - The full notification payload JSON string
  static Future<void> completeHabitInBackground(
    String rawHabitId,
    String payload,
  ) async {
    // Extract base habitId (without time slot) - declare outside try for error handler
    final habitId = NotificationHelpers.extractHabitIdFromPayload(payload);
    if (habitId == null) {
      AppLogger.error('❌ Failed to extract base habitId from payload');
      return;
    }

    try {
      AppLogger.info('⚙️ Completing habit in background (Isar): $habitId');

      // Extract time slot for hourly habits
      final timeSlot = NotificationHelpers.extractTimeSlotFromPayload(payload);
      if (timeSlot != null) {
        AppLogger.info(
          '⏰ Hourly habit detected - time slot: ${timeSlot['hour']}:${timeSlot['minute']}',
        );
      }

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
          AppLogger.info('🔍 DEBUG: Habit in DB: id=${h.id}, name=${h.name}');
        }
      } catch (e) {
        AppLogger.error('🔍 DEBUG: Failed to list habits', e);
      }

      // Get the habit
      final habit = await isar.habits.filter().idEqualTo(habitId).findFirst();

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

      // Mark the habit as complete
      // For hourly habits, use the specific time slot from the notification payload
      // For other habits, use the current time
      // Isar transaction - automatically synced across isolates!
      await isar.writeTxn(() async {
        DateTime completionTime;

        if (timeSlot != null && habit.frequency == HabitFrequency.hourly) {
          // Use the specific time slot from the notification
          final now = DateTime.now();
          completionTime = DateTime(
            now.year,
            now.month,
            now.day,
            timeSlot['hour']!,
            timeSlot['minute']!,
          );
          AppLogger.info(
            '⏰ Hourly habit: Completing at time slot ${timeSlot['hour']}:${timeSlot['minute']}',
          );
        } else {
          // For non-hourly habits, use current time
          completionTime = DateTime.now();
          AppLogger.info('✅ Regular habit: Completing at current time');
        }

        habit.completions.add(completionTime);
        await isar.habits.put(habit);
      });

      AppLogger.info('✅ Habit completed in background: ${habit.name}');

      // NO NEED FOR FLUSH - Isar handles this automatically!
      // NO NEED FOR FLAGS - Isar streams update automatically!

      // The main isolate will automatically see this change via Isar's
      // reactive streams AND lazy watchers - this triggers instant updates
      // across Timeline, All Habits, Stats, Widgets, and all other screens!

      // CRITICAL FIX: Update widgets DIRECTLY in background
      // This ensures widgets update instantly even when the app is fully closed
      // We MUST update SharedPreferences immediately, not via WorkManager
      try {
        AppLogger.info('🔄 Updating widget data directly in background...');
        await _updateWidgetDataDirectly(isar);
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

      final habit = await isar.habits.filter().idEqualTo(habitId).findFirst();

      if (habit != null) {
        await scheduler.scheduleHabitNotification(
          id: habitId.hashCode + snoozeTime.millisecondsSinceEpoch ~/ 1000,
          habitId: habit.id,
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
          final completionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

          // Get the habit
          final habit =
              await isar.habits.filter().idEqualTo(habitId).findFirst();

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
        pendingActions
            .removeWhere((action) => processedActions.contains(action));
        await prefs.setStringList('pending_habit_completions', pendingActions);
        AppLogger.info(
            '✅ Removed ${processedActions.length} processed actions');
      }
    } catch (e) {
      AppLogger.error('Error processing pending completions', e);
    }
  }

  /// Process pending habit completions that failed during background execution
  /// This is called when the app opens to retry failed completions
  /// Enhanced version for public API with better error handling and widget updates
  static Future<void> processPendingActionsManually(Isar isar) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingActions =
          prefs.getStringList('pending_habit_completions') ?? [];

      if (pendingActions.isEmpty) {
        AppLogger.info('✅ No pending habit completions to process');
        return;
      }

      AppLogger.info(
          '🔄 Processing ${pendingActions.length} pending completions...');

      int successCount = 0;
      int failCount = 0;
      final failedActions = <String>[];

      for (final actionJson in pendingActions) {
        try {
          final action = jsonDecode(actionJson) as Map<String, dynamic>;
          final habitId = action['habitId'] as String;
          final timestamp = action['timestamp'] as int;
          final completionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

          // Attempt to complete the habit
          final habit =
              await isar.habits.filter().idEqualTo(habitId).findFirst();

          if (habit == null) {
            AppLogger.warning(
                '⚠️ Habit not found for pending action: $habitId');
            failCount++;
            continue; // Don't retry, habit was probably deleted
          }

          // Complete the habit with the original timestamp
          await isar.writeTxn(() async {
            habit.completions.add(completionTime);
            await isar.habits.put(habit);
          });

          AppLogger.info('✅ Processed pending completion: ${habit.name}');
          successCount++;
        } catch (e) {
          AppLogger.error('❌ Failed to process pending action', e);
          failedActions.add(actionJson);
          failCount++;
        }
      }

      // Update SharedPreferences with only failed actions
      await prefs.setStringList('pending_habit_completions', failedActions);

      AppLogger.info(
        '📊 Pending actions processed: $successCount succeeded, $failCount failed',
      );

      if (successCount > 0) {
        // Trigger widget update after processing completions
        try {
          await WidgetIntegrationService.instance.onHabitsChanged();
          AppLogger.info('✅ Widgets updated after pending completions');
        } catch (e) {
          AppLogger.error('Failed to update widgets', e);
        }
      }
    } catch (e) {
      AppLogger.error('Error processing pending actions', e);
    }
  }

  /// Get count of pending actions (for debugging and monitoring)
  static Future<int> getPendingActionsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingActions =
          prefs.getStringList('pending_habit_completions') ?? [];
      return pendingActions.length;
    } catch (e) {
      AppLogger.error('Error getting pending actions count', e);
      return 0;
    }
  }

  /// Update widget data DIRECTLY in background with correct format
  /// This is called immediately after completing a habit in background
  /// to ensure widgets update instantly even when app is closed
  static Future<void> _updateWidgetDataDirectly(Isar isar) async {
    try {
      AppLogger.info('� Preparing widget data with correct format...');

      // Get all active habits
      final allHabits = await isar.habits.where().findAll();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Filter habits for today using the same logic as widget_background_update_service
      final todayHabits = allHabits.where((habit) {
        return _shouldShowHabitOnDate(habit, today);
      }).toList();

      AppLogger.info('📊 Found ${todayHabits.length} habits for today');

      // Convert habits to JSON using the SAME format as widget_background_update_service
      final habitsJson = jsonEncode(
        todayHabits.map((h) => _habitToJsonForWidget(h, today)).toList(),
      );

      AppLogger.info('📊 Generated JSON: ${habitsJson.length} characters');

      // Save to SharedPreferences via home_widget (CRITICAL: Must use exact keys)
      await HomeWidget.saveWidgetData<String>('habits', habitsJson);
      await HomeWidget.saveWidgetData<String>('today_habits', habitsJson);
      await HomeWidget.saveWidgetData<int>(
        'lastUpdate',
        DateTime.now().millisecondsSinceEpoch,
      );

      AppLogger.info('✅ Widget data saved to SharedPreferences');

      // CRITICAL: Add delay to ensure SharedPreferences write completes
      await Future.delayed(const Duration(milliseconds: 200));

      // CRITICAL FIX: Send native broadcast to trigger widget update
      // This works even when the app is completely closed because it uses
      // native Android BroadcastReceiver instead of Flutter platform channels
      try {
        AppLogger.info('📢 Sending habit completion broadcast...');
        await const MethodChannel('com.habittracker.habitv8/widget_update')
            .invokeMethod('sendHabitCompletionBroadcast');
        AppLogger.info('✅ Habit completion broadcast sent successfully');
      } catch (e) {
        AppLogger.warning(
            '⚠️ Failed to send broadcast, trying direct refresh: $e');

        // Fallback: Try direct platform channel refresh
        // (This only works if MainActivity is active)
        try {
          await const MethodChannel('com.habittracker.habitv8/widget_update')
              .invokeMethod('forceWidgetRefresh');
          AppLogger.info('✅ Platform channel widget refresh triggered');
        } catch (e2) {
          AppLogger.warning(
              '⚠️ Platform channel failed, using HomeWidget fallback: $e2');

          // Last resort: HomeWidget.updateWidget
          // (This also requires Flutter engine to be running)
          await HomeWidget.updateWidget(
            name: 'HabitTimelineWidgetProvider',
            androidName: 'HabitTimelineWidgetProvider',
          );

          await HomeWidget.updateWidget(
            name: 'HabitCompactWidgetProvider',
            androidName: 'HabitCompactWidgetProvider',
          );
        }
      }

      AppLogger.info('✅ Widget refresh completed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update widget data directly', e, stackTrace);
    }
  }

  /// Check if a habit should be shown on a specific date
  /// COPIED from widget_background_update_service.dart to ensure consistency
  static bool _shouldShowHabitOnDate(Habit habit, DateTime date) {
    if (!habit.isActive) return false;

    // Use createdAt as start date
    final startDate = DateTime(
      habit.createdAt.year,
      habit.createdAt.month,
      habit.createdAt.day,
    );

    if (date.isBefore(startDate)) return false;

    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;

      case HabitFrequency.weekly:
        if (habit.selectedWeekdays.isEmpty) return false;
        final weekday = date.weekday % 7; // Convert to 0-6 (Sunday = 0)
        return habit.selectedWeekdays.contains(weekday);

      case HabitFrequency.monthly:
        if (habit.selectedMonthDays.isEmpty) return false;
        return habit.selectedMonthDays.contains(date.day);

      case HabitFrequency.hourly:
        return true; // Hourly habits show every day

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final scheduledDate = DateTime(
            habit.singleDateTime!.year,
            habit.singleDateTime!.month,
            habit.singleDateTime!.day,
          );
          return date.isAtSameMomentAs(scheduledDate);
        }
        return false;

      case HabitFrequency.yearly:
        return true; // Yearly habits show (simplified)
    }
  }

  /// Convert habit to JSON for widget consumption
  /// COPIED from widget_background_update_service.dart to ensure exact format match
  static Map<String, dynamic> _habitToJsonForWidget(
      Habit habit, DateTime date) {
    final isCompleted = _isHabitCompletedOnDate(habit, date);

    return {
      'id': habit.id,
      'name': habit.name,
      'category': habit.category,
      'colorValue': habit.colorValue,
      'isCompleted': isCompleted,
      'status': isCompleted ? 'Completed' : 'Due',
      'timeDisplay': _getHabitTimeDisplay(habit),
      'frequency': habit.frequency.toString().split('.').last,
      'streak': habit.currentStreak,
      'completedSlots': habit.frequency == HabitFrequency.hourly
          ? _getCompletedSlotsCount(habit, date)
          : 0,
      'totalSlots': habit.frequency == HabitFrequency.hourly
          ? habit.hourlyTimes.length
          : 0,
    };
  }

  /// Check if habit is completed on a specific date
  static bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    if (habit.frequency == HabitFrequency.hourly) {
      // For hourly habits, check if at least one slot is completed
      return habit.completions.any((completion) {
        return completion.year == date.year &&
            completion.month == date.month &&
            completion.day == date.day;
      });
    }

    // For other frequencies, check for any completion on the date
    return habit.completions.any((completion) {
      final completionDate =
          DateTime(completion.year, completion.month, completion.day);
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
  }

  /// Get completed slots count for hourly habits
  static int _getCompletedSlotsCount(Habit habit, DateTime date) {
    return habit.completions.where((completion) {
      return completion.year == date.year &&
          completion.month == date.month &&
          completion.day == date.day;
    }).length;
  }

  /// Get time display for habit
  static String _getHabitTimeDisplay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          return habit.hourlyTimes.first;
        }
        return 'Hourly';

      case HabitFrequency.daily:
        if (habit.reminderTime != null) {
          final time = habit.reminderTime!;
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
        return 'Daily';

      case HabitFrequency.weekly:
        return 'Weekly';

      case HabitFrequency.monthly:
        return 'Monthly';

      case HabitFrequency.yearly:
        return 'Yearly';

      case HabitFrequency.single:
        return 'Single';
    }
  }
}
