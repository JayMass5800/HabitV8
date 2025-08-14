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
    NotificationService.setNotificationActionCallback(_handleNotificationAction);
    
    AppLogger.info('🔧 NotificationActionService initialized');
    AppLogger.info('📦 Container set: ${_container != null}');
    AppLogger.info('🔗 Callback registered: ${NotificationService.onNotificationAction != null}');
    AppLogger.info('📋 Pending actions processed: ${NotificationService.getPendingActionsCount() == 0}');
  }
  
  /// Re-register the callback if it gets lost
  static void ensureCallbackRegistered() {
    if (_container != null && NotificationService.onNotificationAction == null) {
      AppLogger.warning('🔄 Re-registering notification action callback');
      NotificationService.setNotificationActionCallback(_handleNotificationAction);
    }
  }
  
  /// Handle notification actions (complete/snooze)
  static void _handleNotificationAction(String habitId, String action) async {
    if (_container == null) {
      AppLogger.error('NotificationActionService not initialized');
      return;
    }
    
    AppLogger.info('Processing notification action: $action for habit: $habitId');
    
    try {
      switch (action) {
        case 'complete':
          AppLogger.info('Delegating to _handleCompleteAction for habit: $habitId');
          await _handleCompleteAction(habitId);
          AppLogger.info('_handleCompleteAction completed for habit: $habitId');
          break;
        case 'snooze':
          // Snooze is already handled in the notification service
          AppLogger.info('Habit snoozed: $habitId');
          break;
        default:
          AppLogger.warning('Unknown notification action: $action');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Error handling notification action: $action for habit: $habitId', e);
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
            final isCompleted = habitService.isHabitCompletedForCurrentPeriod(habitId, now);
            
            AppLogger.info('Habit completion status: $isCompleted');
            
            if (!isCompleted) {
              // Mark the habit as complete for this time period
              await habitService.markHabitComplete(habitId, now);
              
              // Log with frequency-specific message
              final frequencyText = habit.frequency == HabitFrequency.hourly 
                  ? 'for this hour' 
                  : 'for today';
              AppLogger.info('✅ SUCCESS: Habit marked as complete from notification: ${habit.name} $frequencyText');
              
              // Force save to ensure persistence
              await habitService.updateHabit(habit);
              AppLogger.info('Habit data saved to database');
            } else {
              // Log with frequency-specific message
              final frequencyText = habit.frequency == HabitFrequency.hourly 
                  ? 'for this hour' 
                  : 'for today';
              AppLogger.info('ℹ️ INFO: Habit already completed $frequencyText: ${habit.name}');
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
}