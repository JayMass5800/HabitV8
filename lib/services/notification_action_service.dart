import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';
import 'notification_service.dart';
import 'logging_service.dart';
import 'alarm_service.dart';
import 'widget_integration_service.dart';

/// Service to handle notification actions and connect them to habit management
class NotificationActionService {
  static ProviderContainer? _container;
  static const MethodChannel _widgetUpdateChannel =
      MethodChannel('com.habittracker.habitv8/widget_update');

  /// Initialize the notification action service with a provider container
  static void initialize(ProviderContainer container) {
    _container = container;

    AppLogger.info('🔧 Initializing NotificationActionService...');
    AppLogger.info('📦 Container provided: true');

    // Set up the notification action callback using the new method
    NotificationService.setNotificationActionCallback(
      _handleNotificationAction,
    );

    // Set up the direct completion handler to avoid circular imports
    NotificationService.setDirectCompletionHandler(
      completeHabitDirectly,
    );

    AppLogger.info('✅ NotificationActionService initialized successfully');
    AppLogger.info('📦 Container set: ${_container != null}');
    AppLogger.info(
      '🔗 Callback registered: ${NotificationService.onNotificationAction != null}',
    );

    // Log pending actions count (async)
    NotificationService.getPendingActionsCount().then((count) {
      AppLogger.info('📋 Pending actions count: $count');
    });
  }

  /// Re-register the callback if it gets lost
  static void ensureCallbackRegistered() {
    AppLogger.info('🔍 Checking notification callback registration...');
    AppLogger.info('📦 Container available: ${_container != null}');
    AppLogger.info(
        '🔗 Callback currently set: ${NotificationService.onNotificationAction != null}');

    if (_container != null &&
        NotificationService.onNotificationAction == null) {
      AppLogger.warning('🔄 Re-registering notification action callback');
      NotificationService.setNotificationActionCallback(
        _handleNotificationAction,
      );
      AppLogger.info('✅ Callback re-registered successfully');
    } else if (_container != null) {
      AppLogger.info('✅ Notification action callback is properly registered');
    } else {
      AppLogger.error('❌ Container is null - cannot register callback');
    }
  }

  /// Send native Android broadcast to trigger widget update
  /// This works even when the Flutter engine is not running (app fully closed)
  static Future<void> _sendWidgetUpdateBroadcast() async {
    try {
      AppLogger.info(
          '📢 Sending native Android broadcast for widget update...');
      await _widgetUpdateChannel.invokeMethod('sendHabitCompletionBroadcast');
      AppLogger.info('✅ Native widget update broadcast sent successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to send native widget update broadcast', e);
      // Don't throw - this is a non-critical enhancement
    }
  }

  /// Handle notification actions (complete/snooze)
  static void _handleNotificationAction(String habitId, String action) async {
    AppLogger.info('🎯 _handleNotificationAction called');
    AppLogger.info('📋 Habit ID: $habitId');
    AppLogger.info('⚡ Action: $action');
    AppLogger.info('📦 Container available: ${_container != null}');

    if (_container == null) {
      AppLogger.error(
          '❌ NotificationActionService not initialized - container is null');
      return;
    }

    AppLogger.info(
      '🚀 Processing notification action: $action for habit: $habitId',
    );

    try {
      switch (action) {
        case 'complete':
          AppLogger.info(
            'Delegating to _handleCompleteAction for habit: $habitId',
          );
          await _handleCompleteAction(habitId);
          AppLogger.info('_handleCompleteAction completed for habit: $habitId');
          break;
        case 'snooze':
          AppLogger.info('Processing snooze action for habit: $habitId');
          await _handleSnoozeAction(habitId);
          AppLogger.info('Snooze action completed for habit: $habitId');
          break;
        case 'snooze_alarm':
          AppLogger.info('Processing alarm snooze action for habit: $habitId');
          await _handleAlarmSnoozeAction(habitId);
          AppLogger.info('Alarm snooze action completed for habit: $habitId');
          break;
        default:
          AppLogger.warning('Unknown notification action: $action');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error handling notification action: $action for habit: $habitId',
        e,
      );
      AppLogger.error('Stack trace: $stackTrace');
    }
  }

  /// Handle the complete action
  static Future<void> _handleCompleteAction(String habitId) async {
    try {
      AppLogger.info('Starting complete action for habit: $habitId');

      // Parse habitId to extract actual habit ID and time slot (for hourly habits)
      String actualHabitId = habitId;
      String? timeSlot;

      if (habitId.contains('|')) {
        final parts = habitId.split('|');
        actualHabitId = parts[0];
        timeSlot = parts.length > 1 ? parts[1] : null;
        AppLogger.info(
          'Parsed hourly habit - ID: $actualHabitId, Time slot: $timeSlot',
        );
      }

      // Get the habit service from the provider and wait for it to be ready
      AppLogger.info('Waiting for habit service to be ready...');
      final habitService =
          await _container!.read(habitServiceIsarProvider.future);

      try {
        AppLogger.info('Habit service obtained successfully');

        // Get the habit
        final habit = await habitService.getHabitById(actualHabitId);
        if (habit == null) {
          AppLogger.warning('Habit not found: $actualHabitId');
          return;
        }

        AppLogger.info('Found habit: ${habit.name}');

        // For hourly habits with time slots, use the specific time for completion
        DateTime completionTime = DateTime.now();
        if (timeSlot != null && habit.frequency == HabitFrequency.hourly) {
          try {
            final timeParts = timeSlot.split(':');
            final hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);

            // Use the specific time slot for completion
            completionTime = DateTime(
              completionTime.year,
              completionTime.month,
              completionTime.day,
              hour,
              minute,
            );
            AppLogger.info(
              'Using specific time slot for completion: $completionTime',
            );
          } catch (e) {
            AppLogger.warning(
              'Failed to parse time slot $timeSlot, using current time: $e',
            );
          }
        }

        // For hourly habits, check if this specific time slot is already completed
        bool isCompleted = false;
        if (habit.frequency == HabitFrequency.hourly && timeSlot != null) {
          // Check if this specific time slot is already completed
          isCompleted = habit.completions.any((completion) {
            return completion.year == completionTime.year &&
                completion.month == completionTime.month &&
                completion.day == completionTime.day &&
                completion.hour == completionTime.hour &&
                completion.minute == completionTime.minute;
          });
        } else {
          // For non-hourly habits, use the existing logic
          final habit = await habitService.getHabitById(actualHabitId);
          if (habit != null) {
            isCompleted = habitService.isHabitCompletedForCurrentPeriod(habit);
          }
        }

        AppLogger.info('Habit completion status: $isCompleted');

        if (!isCompleted) {
          // Mark the habit as complete for this time period
          AppLogger.info(
              '📝 About to call markHabitComplete for habit: ${habit.id}');
          AppLogger.info('   Completion time: $completionTime');
          AppLogger.info(
              '   Current completions count: ${habit.completions.length}');

          await habitService.markHabitComplete(
            actualHabitId,
            completionTime,
          );

          // Log with frequency-specific message
          final frequencyText = _getFrequencyText(habit.frequency);
          final timeInfo = timeSlot != null ? ' at $timeSlot' : '';
          AppLogger.info(
            '✅ SUCCESS: Habit marked as complete from notification: ${habit.name} $frequencyText$timeInfo',
          );

          // Verify completion was saved by re-fetching habit
          try {
            final verifyHabit = await habitService.getHabitById(actualHabitId);
            if (verifyHabit != null) {
              AppLogger.info(
                  '✅ VERIFICATION: Habit now has ${verifyHabit.completions.length} completions');
              if (verifyHabit.completions.isEmpty) {
                AppLogger.error(
                    '❌ CRITICAL: Completion was NOT saved to database!');
              } else {
                final latestCompletion = verifyHabit.completions.last;
                AppLogger.info('   Latest completion: $latestCompletion');
              }
            } else {
              AppLogger.error(
                  '❌ CRITICAL: Could not retrieve habit for verification!');
            }
          } catch (e) {
            AppLogger.error('Failed to verify completion: $e');
          }

          // markHabitComplete already saves to database and flushes, no need to save again

          // Add small delay to ensure database write completes
          await Future.delayed(const Duration(milliseconds: 100));
          AppLogger.info('⏱️ Waited for database write to complete');

          // **CRITICAL: Invalidate providers FIRST to ensure UI picks up changes**
          try {
            // Invalidate habits stream provider to force timeline screen refresh
            _container!.invalidate(habitsStreamIsarProvider);
            AppLogger.info(
                '✅ habitsStreamIsarProvider invalidated for UI refresh');

            // Also invalidate habitServiceIsarProvider for other dependent widgets
            _container!.invalidate(habitServiceIsarProvider);
            AppLogger.info(
                '✅ habitServiceIsarProvider invalidated for UI refresh');
          } catch (e) {
            AppLogger.warning('Could not invalidate providers: $e');
          }

          // Trigger immediate UI updates for faster feedback
          await _triggerImmediateUIUpdate();

          // **CRITICAL: Update widgets after habit completion from notification**
          try {
            AppLogger.info(
                '🔄 Updating widgets after notification completion...');

            // FIRST: Send native Android broadcast for widget update
            // This works even when the Flutter engine is not running (app fully closed)
            await _sendWidgetUpdateBroadcast();

            // SECOND: Use Flutter widget update as backup (only works when app is running)
            await WidgetIntegrationService.instance.forceWidgetUpdate();

            AppLogger.info(
                '✅ Widgets updated successfully (native broadcast + Flutter update)');
          } catch (e) {
            AppLogger.error(
                '❌ Failed to update widgets after notification completion', e);

            // Fallback to regular update
            try {
              await WidgetIntegrationService.instance.updateAllWidgets();
              AppLogger.info('✅ Fallback widget update completed');
            } catch (fallbackError) {
              AppLogger.error(
                  '❌ Fallback widget update also failed', fallbackError);
            }
          }
        } else {
          // Log with frequency-specific message
          final frequencyText = _getFrequencyText(habit.frequency);
          final timeInfo = timeSlot != null ? ' at $timeSlot' : '';
          AppLogger.info(
            'ℹ️ INFO: Habit already completed $frequencyText$timeInfo: ${habit.name}',
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Error in habit completion process', e);
        AppLogger.error('Stack trace: $stackTrace');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error in _handleCompleteAction for habit $habitId', e);
      AppLogger.error('Stack trace: $stackTrace');
    }
  }

  /// Handle the snooze action
  static Future<void> _handleSnoozeAction(String habitId) async {
    try {
      AppLogger.info('Starting snooze action for habit: $habitId');

      // Get the habit service from the provider to get habit details for better notification
      AppLogger.info('Waiting for habit service to be ready for snooze...');
      final habitService =
          await _container!.read(habitServiceIsarProvider.future);

      String habitName = 'Your habit'; // Default fallback
      try {
        // Get the habit for better notification content
        final habit = await habitService.getHabitById(habitId);
        if (habit != null) {
          habitName = habit.name;
          AppLogger.info('Found habit for snooze: ${habit.name}');
        } else {
          AppLogger.warning('Habit not found for snooze: $habitId');
        }
      } catch (e, stackTrace) {
        AppLogger.error('Error getting habit details for snooze', e);
        AppLogger.error('Stack trace: $stackTrace');
      }

      // Call the enhanced snooze action with habit details
      await NotificationService.handleSnoozeActionWithName(habitId, habitName);

      AppLogger.info(
          '✅ Snooze action processed for habit: $habitName ($habitId)');
    } catch (e, stackTrace) {
      AppLogger.error('Error in _handleSnoozeAction for habit $habitId', e);
      AppLogger.error('Stack trace: $stackTrace');
    }
  }

  /// Handle the alarm snooze action with custom delay
  static Future<void> _handleAlarmSnoozeAction(String habitId) async {
    try {
      AppLogger.info('Starting alarm snooze action for habit: $habitId');

      // Parse habitId to extract actual habit ID and time slot (for hourly habits)
      String actualHabitId = habitId;
      String? timeSlot;

      if (habitId.contains('|')) {
        final parts = habitId.split('|');
        actualHabitId = parts[0];
        timeSlot = parts.length > 1 ? parts[1] : null;
        AppLogger.info(
          'Parsed hourly habit - ID: $actualHabitId, Time slot: $timeSlot',
        );
      }

      // Get the habit service from the provider to get habit details
      AppLogger.info(
          'Waiting for habit service to be ready for alarm snooze...');
      final habitService =
          await _container!.read(habitServiceIsarProvider.future);

      try {
        // Get the habit for alarm details
        final habit = await habitService.getHabitById(actualHabitId);
        if (habit != null) {
          AppLogger.info('Found habit for alarm snooze: ${habit.name}');
          AppLogger.info(
            'Snooze delay: ${habit.snoozeDelayMinutes} minutes',
          );
          AppLogger.info('Alarm sound: ${habit.alarmSoundName}');

          // Schedule snooze alarm using AlarmService (awesome_notifications)
          await AlarmService.scheduleSnoozeAlarm(
            habitId: actualHabitId,
            habitName: habit.name,
            snoozeDelayMinutes: habit.snoozeDelayMinutes,
            alarmSoundName: habit.alarmSoundName,
          );

          AppLogger.info('✅ Snooze alarm scheduled for ${habit.name}');
        } else {
          AppLogger.warning(
            'Habit not found for alarm snooze: $actualHabitId',
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Error getting habit details for alarm snooze', e);
        AppLogger.error('Stack trace: $stackTrace');
      }

      AppLogger.info('✅ Alarm snooze action processed for habit: $habitId');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error in _handleAlarmSnoozeAction for habit $habitId',
        e,
      );
      AppLogger.error('Stack trace: $stackTrace');
    }
  }

  /// Get frequency-specific text for logging messages
  static String _getFrequencyText(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'for this hour';
      case HabitFrequency.daily:
        return 'for today';
      case HabitFrequency.weekly:
        return 'for this week';
      case HabitFrequency.monthly:
        return 'for this month';
      case HabitFrequency.yearly:
        return 'for this year';
      case HabitFrequency.single:
        return 'permanently';
    }
  }

  /// Trigger immediate UI updates for critical changes (like notification completions)
  static Future<void> _triggerImmediateUIUpdate() async {
    try {
      if (_container == null) {
        AppLogger.warning('Container not available for immediate UI update');
        return;
      }

      AppLogger.info(
          '🚀 Triggering immediate UI update for notification completion');

      // Invalidate stream provider to trigger immediate refresh from database
      try {
        _container!.invalidate(habitsStreamIsarProvider);
        AppLogger.info(
            '✅ Immediate habits refresh completed via stream provider invalidation');
      } catch (e) {
        AppLogger.warning('Could not invalidate habits stream provider: $e');
        // Fallback to service provider invalidation
        try {
          _container!.invalidate(habitServiceIsarProvider);
          AppLogger.info(
              '✅ Fallback habitService provider invalidation completed');
        } catch (invalidateError) {
          AppLogger.error(
              'Error in fallback provider invalidation', invalidateError);
        }
      }
    } catch (e) {
      AppLogger.error('Error in immediate UI update', e);
    }
  }

  /// Complete habit directly without relying on callback (for stored actions)
  static Future<void> completeHabitDirectly(String habitId) async {
    if (_container == null) {
      throw Exception(
          'NotificationActionService not initialized - container is null');
    }

    AppLogger.info('🎯 Direct completion requested for habit: $habitId');

    try {
      // Use the same logic as _handleCompleteAction but without the callback dependency
      await _handleCompleteAction(habitId);
      AppLogger.info('✅ Direct completion successful for habit: $habitId');
    } catch (e) {
      AppLogger.error('❌ Direct completion failed for habit: $habitId', e);
      rethrow;
    }
  }
}
