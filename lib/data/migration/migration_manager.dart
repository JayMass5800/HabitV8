import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../database_hive_backup.dart.bak' as hive_db;
import '../database_isar.dart';
import 'hive_to_isar_migrator.dart';
import '../../services/logging_service.dart';

class MigrationManager {
  static const String _migrationKey = 'hive_to_isar_migration_completed';
  static const String _migrationVersionKey = 'migration_version';
  static const int _currentMigrationVersion = 1;

  /// Check if migration is needed and perform it
  static Future<bool> performMigrationIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final migrationCompleted = prefs.getBool(_migrationKey) ?? false;

    if (migrationCompleted) {
      AppLogger.info('✅ Migration already completed, skipping');
      return true;
    }

    AppLogger.info('🔄 Starting Hive to Isar migration...');

    try {
      // Open Hive database
      final hiveBox = await hive_db.DatabaseService.getInstance();

      // Open Isar database
      final isar = await IsarDatabaseService.getInstance();

      // Perform migration
      final result = await HiveToIsarMigrator.migrateAllHabits(hiveBox, isar);

      // Verify migration
      if (result.isValid) {
        AppLogger.info(
          '✅ Migration successful: ${result.hiveCount} habits migrated',
        );

        // Mark migration as completed
        await prefs.setBool(_migrationKey, true);
        await prefs.setInt(_migrationVersionKey, _currentMigrationVersion);

        // Close Hive database (but don't delete yet - keep as backup)
        await hive_db.DatabaseService.closeDatabase();

        AppLogger.info('✅ Migration completed successfully');
        return true;
      } else {
        throw Exception(
          'Migration verification failed: ${result.errorMessage}',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('❌ Migration failed', e, stackTrace);
      return false;
    }
  }

  /// Reset migration flag (for testing/debugging)
  static Future<void> resetMigrationFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_migrationKey);
    await prefs.remove(_migrationVersionKey);
    AppLogger.info('⚠️ Migration flag reset - will migrate on next launch');
  }

  /// Check if migration has been completed
  static Future<bool> isMigrationCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_migrationKey) ?? false;
  }

  /// Get current migration version
  static Future<int?> getMigrationVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_migrationVersionKey);
  }

  /// Cleanup old Hive database (call after confirming migration success)
  static Future<void> cleanupHiveDatabase() async {
    try {
      AppLogger.info('🧹 Cleaning up old Hive database...');

      // Ensure Hive database is closed
      await hive_db.DatabaseService.closeDatabase();

      // Delete the Hive box from disk
      await Hive.deleteBoxFromDisk('habits');

      AppLogger.info('✅ Old Hive database cleaned up');
    } catch (e) {
      AppLogger.error('Failed to cleanup Hive database', e);
      // Don't throw - this is not critical
    }
  }
}
