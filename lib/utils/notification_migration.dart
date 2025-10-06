// Optional Migration Utility - Can be called once to reschedule all notifications
// This ensures all existing notifications use the correct habit ID format

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database_isar.dart';
import '../services/notification_service.dart';
import '../services/logging_service.dart';

/// One-time migration to reschedule all habit notifications with correct IDs
///
/// This fixes any notifications that were scheduled with the old .toString() format
/// Call this once after updating to the fixed notification scheduler
class NotificationMigration {
  static const String _migrationKey = 'notification_id_migration_v1_completed';

  /// Check if migration has already been run
  static Future<bool> isMigrationCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_migrationKey) ?? false;
    } catch (e) {
      AppLogger.error('Error checking migration status', e);
      return false;
    }
  }

  /// Mark migration as completed
  static Future<void> markMigrationCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_migrationKey, true);
      AppLogger.info('✅ Migration marked as completed');
    } catch (e) {
      AppLogger.error('Error marking migration as completed', e);
    }
  }

  /// Perform the migration - reschedule all notifications
  static Future<void> migrateNotificationPayloads(BuildContext context) async {
    try {
      AppLogger.info('🔄 Starting notification ID migration...');

      // Show progress indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rescheduling notifications with updated format...'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Get database instance
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);

      // Cancel all existing notifications
      AppLogger.info('📝 Cancelling all existing notifications...');
      await NotificationService.cancelAllNotifications();

      // Reschedule for all active habits
      final habits = await habitService.getAllHabits();
      int rescheduledCount = 0;

      for (var habit in habits) {
        if (habit.isActive && habit.notificationsEnabled) {
          try {
            await NotificationService.scheduleHabitNotifications(habit);
            rescheduledCount++;
            AppLogger.debug('✅ Rescheduled: ${habit.name} (ID: ${habit.id})');
          } catch (e) {
            AppLogger.error('❌ Failed to reschedule ${habit.name}: $e');
          }
        }
      }

      // Mark migration as completed
      await markMigrationCompleted();

      AppLogger.info(
          '✅ Migration complete! Rescheduled $rescheduledCount habits');

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully rescheduled $rescheduledCount notifications'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('❌ Notification migration failed: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Migration failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Run migration automatically on app startup (if not completed)
  static Future<void> autoMigrateIfNeeded() async {
    final completed = await isMigrationCompleted();
    if (!completed) {
      AppLogger.info('🔄 Auto-migration needed, running in background...');

      try {
        // Get database instance
        final habitBox = await DatabaseService.getInstance();
        final habitService = HabitService(habitBox);

        // Cancel all existing notifications
        await NotificationService.cancelAllNotifications();

        // Reschedule for all active habits
        final habits = await habitService.getAllHabits();
        int rescheduledCount = 0;

        for (var habit in habits) {
          if (habit.isActive && habit.notificationsEnabled) {
            try {
              await NotificationService.scheduleHabitNotifications(habit);
              rescheduledCount++;
            } catch (e) {
              AppLogger.error('Failed to reschedule ${habit.name}: $e');
            }
          }
        }

        // Mark migration as completed
        await markMigrationCompleted();

        AppLogger.info(
            '✅ Auto-migration complete! Rescheduled $rescheduledCount habits');
      } catch (e) {
        AppLogger.error('❌ Auto-migration failed: $e');
      }
    }
  }
}

/* USAGE EXAMPLES:

1. Manual trigger (add button in settings):
   ```dart
   ElevatedButton(
     onPressed: () => NotificationMigration.migrateNotificationPayloads(context),
     child: Text('Fix Notification IDs'),
   )
   ```

2. Auto-run on app startup (in main.dart):
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     // ... other initialization ...
     
     // Run migration if needed
     await NotificationMigration.autoMigrateIfNeeded();
     
     runApp(MyApp());
   }
   ```

3. Check migration status:
   ```dart
   final completed = await NotificationMigration.isMigrationCompleted();
   if (!completed) {
     // Show prompt to user
   }
   ```
*/
