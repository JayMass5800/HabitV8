import 'package:flutter/material.dart';
import 'lib/services/calendar_service.dart';
import 'lib/domain/model/habit.dart';

/// Simple test script to verify calendar integration
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('=== Calendar Integration Test ===');
  
  try {
    // Initialize calendar service
    print('1. Initializing calendar service...');
    final initialized = await CalendarService.initialize();
    print('   Calendar service initialized: $initialized');
    
    // Check permissions
    print('2. Checking calendar permissions...');
    final hasPermissions = await CalendarService.hasPermissions();
    print('   Has calendar permissions: $hasPermissions');
    
    // Check if sync is enabled
    print('3. Checking calendar sync status...');
    final syncEnabled = await CalendarService.isCalendarSyncEnabled();
    print('   Calendar sync enabled: $syncEnabled');
    
    // Get available calendars
    print('4. Getting available calendars...');
    final calendars = await CalendarService.getAvailableCalendars();
    print('   Found ${calendars.length} writable calendars:');
    for (final calendar in calendars) {
      print('     - ${calendar.name} (${calendar.id})');
    }
    
    // Get selected calendar
    print('5. Getting selected calendar...');
    final selectedCalendarId = CalendarService.getSelectedCalendarId();
    print('   Selected calendar ID: $selectedCalendarId');
    
    if (selectedCalendarId != null) {
      final selectedCalendar = await CalendarService.getSelectedCalendar();
      print('   Selected calendar name: ${selectedCalendar?.name}');
    }
    
    // Get sync status
    print('6. Getting detailed sync status...');
    final syncStatus = await CalendarService.getCalendarSyncStatus();
    print('   Sync status: $syncStatus');
    
    print('\n=== Test Results ===');
    print('Calendar service working: ${initialized ? "✓" : "✗"}');
    print('Has permissions: ${hasPermissions ? "✓" : "✗"}');
    print('Sync enabled: ${syncEnabled ? "✓" : "✗"}');
    print('Calendars available: ${calendars.isNotEmpty ? "✓" : "✗"}');
    print('Calendar selected: ${selectedCalendarId != null ? "✓" : "✗"}');
    
    if (syncEnabled && selectedCalendarId != null && hasPermissions) {
      print('\n🎉 Calendar integration is properly configured!');
      
      // Test creating a sample habit event
      print('\n7. Testing habit sync...');
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
      print('   Test habit sync completed');
      
    } else {
      print('\n⚠️  Calendar integration needs setup:');
      if (!hasPermissions) print('   - Grant calendar permissions');
      if (!syncEnabled) print('   - Enable calendar sync in settings');
      if (selectedCalendarId == null) print('   - Select a calendar in settings');
    }
    
  } catch (e, stackTrace) {
    print('❌ Error during calendar integration test: $e');
    print('Stack trace: $stackTrace');
  }
  
  print('\n=== Test Complete ===');
}