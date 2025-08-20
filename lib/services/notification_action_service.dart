import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database.dart';
import '../domain/model/habit.dart';
import 'notification_service.dart';
import 'logging_service.dart';

/// Service to handle notification actions and connect them to habit management
class NotificationActionService {
  static ProviderContainer? _container;

  /// Initialize the notification action service with a provider container
  static void initialize(ProviderContainer container) {
    _container = container;

    // Set up the notification action callback using the new method
    NotificationService.setNotificationActionCallback(
      _handleNotificationAction,
    );

    AppLogger.info('🔧 NotificationActionService initialized');
    AppLogger.info('📦 Container set: ${_container != null}');
    AppLogger.info(
      '🔗 Callback registered: ${NotificationService.onNotificationAction != null}',
    );
    AppLogger.info(
      '📋 Pending actions processed: ${NotificationService.getPendingActionsCount() == 0}',
    );
  }

  /// Re-register the callback if it gets lost
  static void ensureCallbackRegistered() {
    if (_container != null &&
        NotificationService.onNotificationAction == null) {
      AppLogger.warning('🔄 Re-registering notification action callback');
      NotificationService.setNotificationActionCallback(
        _handleNotificationAction,
      );
    }
  }

  /// Handle notification actions (complete/snooze)
  static void _handleNotificationAction(String habitId, String action) async {
    if (_container == null) {
      AppLogger.error('NotificationActionService not initialized');
      return;
    }

    AppLogger.info(
      'Processing notification action: $action for habit: $habitId',
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

      // Get the habit service from the provider
      final habitServiceAsync = _container!.read(habitServiceProvider);

      habitServiceAsync.when(
        data: (habitService) async {
          try {
            AppLogger.info('Habit service obtained successfully');

            // Get the habit
            final habit = await habitService.getHabitById(habitId);
            if (habit == null) {
              AppLogger.warning('Habit not found: $habitId');
              return;
            }

            AppLogger.info('Found habit: ${habit.name}');

            // Check if already completed for the current time period
            final now = DateTime.now();
            final isCompleted = habitService.isHabitCompletedForCurrentPeriod(
              habitId,
              now,
            );

            AppLogger.info('Habit completion status: $isCompleted');

            if (!isCompleted) {
              // Mark the habit as complete for this time period
              await habitService.markHabitComplete(habitId, now);

              // Log with frequency-specific message
              final frequencyText = _getFrequencyText(habit.frequency);
              AppLogger.info(
                '✅ SUCCESS: Habit marked as complete from notification: ${habit.name} $frequencyText',
              );

              // Force save to ensure persistence
              await habitService.updateHabit(habit);
              AppLogger.info('Habit data saved to database');
            } else {
              // Log with frequency-specific message
              final frequencyText = _getFrequencyText(habit.frequency);
              AppLogger.info(
                'ℹ️ INFO: Habit already completed $frequencyText: ${habit.name}',
              );
            }
          } catch (e, stackTrace) {
            AppLogger.error('Error in habit completion process', e);
            AppLogger.error('Stack trace: $stackTrace');
          }
        },
        loading: () {
          AppLogger.info('Habit service loading...');
        },
        error: (error, stack) {
          AppLogger.error('Error accessing habit service', error);
        },
      );
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
      final habitServiceAsync = _container!.read(habitServiceProvider);

      habitServiceAsync.when(
        data: (habitService) async {
          try {
            // Get the habit for better notification content
            final habit = await habitService.getHabitById(habitId);
            if (habit != null) {
              AppLogger.info('Found habit for snooze: ${habit.name}');
              // The actual snooze scheduling is handled in the notification service
              // This callback is just for any additional business logic if needed
            } else {
              AppLogger.warning('Habit not found for snooze: $habitId');
            }
          } catch (e, stackTrace) {
            AppLogger.error('Error getting habit details for snooze', e);
            AppLogger.error('Stack trace: $stackTrace');
          }
        },
        loading: () {
          AppLogger.info('Habit service loading for snooze...');
        },
        error: (error, stack) {
          AppLogger.error('Error accessing habit service for snooze', error);
        },
      );

      AppLogger.info('✅ Snooze action processed for habit: $habitId');
    } catch (e, stackTrace) {
      AppLogger.error('Error in _handleSnoozeAction for habit $habitId', e);
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
    }
  }
}
