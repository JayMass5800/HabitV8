import 'package:flutter/material.dart';
import 'lib/services/calendar_service.dart';
import 'lib/domain/model/habit.dart';
import 'lib/services/logging_service.dart';

/// Simple test script to verify calendar integration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('=== Calendar Integration Test ===');

  try {
    // Initialize calendar service
    AppLogger.info('1. Initializing calendar service...');
    final initialized = await CalendarService.initialize();
    AppLogger.info('   Calendar service initialized: $initialized');

    // Check permissions
    AppLogger.info('2. Checking calendar permissions...');
    final hasPermissions = await CalendarService.hasPermissions();
    AppLogger.info('   Has calendar permissions: $hasPermissions');

    // Check if sync is enabled
    AppLogger.info('3. Checking calendar sync status...');
    final syncEnabled = await CalendarService.isCalendarSyncEnabled();
    AppLogger.info('   Calendar sync enabled: $syncEnabled');

    // Get available calendars
    AppLogger.info('4. Getting available calendars...');
    final calendars = await CalendarService.getAvailableCalendars();
    AppLogger.info('   Found ${calendars.length} writable calendars:');
    for (final calendar in calendars) {
      AppLogger.info('     - ${calendar.name} (${calendar.id})');
    }

    // Get selected calendar
    AppLogger.info('5. Getting selected calendar...');
    final selectedCalendarId = CalendarService.getSelectedCalendarId();
    AppLogger.info('   Selected calendar ID: $selectedCalendarId');

    if (selectedCalendarId != null) {
      final selectedCalendar = await CalendarService.getSelectedCalendar();
      AppLogger.info('   Selected calendar name: ${selectedCalendar?.name}');
    }

    // Get sync status
    AppLogger.info('6. Getting detailed sync status...');
    final syncStatus = await CalendarService.getCalendarSyncStatus();
    AppLogger.info('   Sync status: $syncStatus');

    AppLogger.info('\n=== Test Results ===');
    AppLogger.info('Calendar service working: ${initialized ? "✓" : "✗"}');
    AppLogger.info('Has permissions: ${hasPermissions ? "✓" : "✗"}');
    AppLogger.info('Sync enabled: ${syncEnabled ? "✓" : "✗"}');
    AppLogger.info('Calendars available: ${calendars.isNotEmpty ? "✓" : "✗"}');
    AppLogger.info(
      'Calendar selected: ${selectedCalendarId != null ? "✓" : "✗"}',
    );

    if (syncEnabled && selectedCalendarId != null && hasPermissions) {
      AppLogger.info('\n🎉 Calendar integration is properly configured!');

      // Test creating a sample habit event
      AppLogger.info('\n7. Testing habit sync...');
      final testHabit = Habit.create(
        name: 'Test Calendar Sync',
        description: 'Testing calendar integration',
        category: 'Test',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
        difficulty: HabitDifficulty.easy,
        weeklySchedule: [1, 2, 3, 4, 5, 6, 7], // All days
        monthlySchedule: [],
        hourlyTimes: [],
        selectedYearlyDates: [],
      );

      await CalendarService.syncHabitChanges(testHabit);
      AppLogger.info('   Test habit sync completed');
    } else {
      AppLogger.info('\n⚠️  Calendar integration needs setup:');
      if (!hasPermissions) {
        AppLogger.info('   - Grant calendar permissions');
      }
      if (!syncEnabled) {
        AppLogger.info('   - Enable calendar sync in settings');
      }
      if (selectedCalendarId == null) {
        AppLogger.info('   - Select a calendar in settings');
      }
    }
  } catch (e, stackTrace) {
    AppLogger.error('❌ Error during calendar integration test', e);
    AppLogger.debug('Stack trace: $stackTrace');
  }

  AppLogger.info('\n=== Test Complete ===');
}
