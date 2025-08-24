import 'package:flutter/material.dart';
import 'package:habitv8/services/alarm_service.dart';
import 'package:habitv8/services/logging_service.dart';

/// Test script to verify alarm functionality
/// Run this to test the enhanced alarm system
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('🚨 Testing Enhanced Alarm System...\n');

  // Test 1: Initialize AlarmService
  AppLogger.info('1. Initializing AlarmService...');
  try {
    await AlarmService.initialize();
    AppLogger.info('   ✅ AlarmService initialized successfully\n');
  } catch (e) {
    AppLogger.error('   ❌ Failed to initialize AlarmService: $e\n');
    return;
  }

  // Test 2: Get available alarm sounds
  AppLogger.info('2. Getting available alarm sounds...');
  try {
    final sounds = await AlarmService.getAvailableAlarmSounds();
    AppLogger.info('   ✅ Found ${sounds.length} alarm sounds:');

    for (final sound in sounds) {
      final name = sound['name'];
      final type = sound['type'];
      final uri = sound['uri'];
      AppLogger.info('      - $name ($type): $uri');
    }
    AppLogger.info('');
  } catch (e) {
    AppLogger.error('   ❌ Failed to get alarm sounds: $e\n');
  }

  // Test 3: Test sound preview (system sound only for testing)
  AppLogger.info('3. Testing sound preview...');
  try {
    AppLogger.info('   Playing system alarm preview...');
    await AlarmService.playAlarmSoundPreview('alarm');

    // Wait 2 seconds then stop
    await Future.delayed(const Duration(seconds: 2));
    await AlarmService.stopAlarmSoundPreview();
    AppLogger.info('   ✅ Sound preview test completed\n');
  } catch (e) {
    AppLogger.error('   ❌ Failed to test sound preview: $e\n');
  }

  // Test 4: Schedule a test alarm (5 seconds from now)
  AppLogger.info('4. Testing alarm scheduling...');
  try {
    final testTime = DateTime.now().add(const Duration(seconds: 5));
    await AlarmService.scheduleExactAlarm(
      alarmId: 999,
      habitId: 'test-habit',
      habitName: 'Test Habit',
      scheduledTime: testTime,
      frequency: 'daily',
      alarmSoundName: 'System Alarm',
      snoozeDelayMinutes: 5,
    );
    AppLogger.info('   ✅ Test alarm scheduled for: $testTime');
    AppLogger.info('   📱 Check your notifications in 5 seconds!\n');
  } catch (e) {
    AppLogger.error('   ❌ Failed to schedule test alarm: $e\n');
  }

  // Test 5: Cancel the test alarm after 10 seconds
  AppLogger.info('5. Scheduling alarm cancellation...');
  Future.delayed(const Duration(seconds: 10), () async {
    try {
      await AlarmService.cancelAlarm(999);
      AppLogger.info('   ✅ Test alarm cancelled successfully');
    } catch (e) {
      AppLogger.error('   ❌ Failed to cancel test alarm: $e');
    }
  });

  AppLogger.info('🎉 Alarm system test completed!');
  AppLogger.info('📝 Check the results above and your device notifications.');
  AppLogger.info(
    '⏰ The test alarm should trigger in 5 seconds and be cancelled after 10 seconds.',
  );
}
