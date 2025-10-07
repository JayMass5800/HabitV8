import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';
import '../data/database_isar.dart';
import 'widget_integration_service.dart';

/// Service to handle alarm completion callbacks from native Android
class AlarmCompleteService {
  static const MethodChannel _channel = MethodChannel(
    'com.habittracker.habitv8/alarm_complete',
  );

  static bool _isInitialized = false;
  static ProviderContainer? _container;

  /// Initialize the alarm complete service
  static Future<void> initialize(ProviderContainer container) async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing AlarmCompleteService...');

      _container = container;

      // Set up method call handler for complete callbacks
      _channel.setMethodCallHandler(_handleMethodCall);

      _isInitialized = true;
      AppLogger.info('✅ AlarmCompleteService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmCompleteService', e);
      rethrow;
    }
  }

  /// Handle method calls from native Android
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      AppLogger.info('Received method call: ${call.method}');

      switch (call.method) {
        case 'onAlarmComplete':
          final args = call.arguments as Map<Object?, Object?>;
          final habitId = args['habitId'] as String?;
          final habitName = args['habitName'] as String?;

          if (habitId != null) {
            await _handleComplete(habitId, habitName ?? 'Habit');
          } else {
            AppLogger.warning('Missing habitId in complete callback');
          }
          break;

        default:
          AppLogger.warning('Unknown method call: ${call.method}');
      }
    } catch (e) {
      AppLogger.error('Error handling method call: ${call.method}', e);
    }
  }

  /// Handle the complete action by marking the habit as completed
  static Future<void> _handleComplete(
    String habitId,
    String habitName,
  ) async {
    try {
      AppLogger.info('✅ Completing habit from alarm: $habitName');

      if (_container == null) {
        AppLogger.error('Container not initialized in AlarmCompleteService');
        return;
      }

      // Parse habitId to extract actual habit ID (for hourly habits with time slots)
      String actualHabitId = habitId;
      if (habitId.contains('|')) {
        final parts = habitId.split('|');
        actualHabitId = parts[0];
        AppLogger.info('Parsed hourly habit - ID: $actualHabitId');
      }

      // Get the habit service
      final habitService =
          await _container!.read(habitServiceIsarProvider.future);

      // Get the habit
      final habit = await habitService.getHabitById(actualHabitId);

      if (habit == null) {
        AppLogger.warning('Habit not found for completion: $actualHabitId');
        return;
      }

      // Complete the habit for today
      await habitService.markHabitComplete(
        actualHabitId,
        DateTime.now(),
      );

      AppLogger.info('✅ Habit completed successfully: ${habit.name}');

      // Add small delay to ensure database write completes
      await Future.delayed(const Duration(milliseconds: 100));
      AppLogger.info('⏱️ Waited for database write to complete');

      // **CRITICAL: Use forceWidgetUpdate() for immediate widget refresh**
      // The Isar listener may not fire immediately from background context
      try {
        AppLogger.info('🔄 Force-updating widgets after alarm completion...');
        await WidgetIntegrationService.instance.forceWidgetUpdate();
        AppLogger.info(
            '✅ Widgets force-updated successfully after alarm completion');
      } catch (e) {
        AppLogger.error(
            '❌ Failed to force-update widgets after alarm completion', e);

        // Fallback to regular update
        try {
          await WidgetIntegrationService.instance.onHabitsChanged();
          AppLogger.info('✅ Fallback widget update completed');
        } catch (fallbackError) {
          AppLogger.error(
              '❌ Fallback widget update also failed', fallbackError);
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to complete habit $habitName', e);
      AppLogger.error('Stack trace: $stackTrace');
    }
  }
}
