import 'package:flutter/material.dart';
import 'package:habitv8/services/alarm_service.dart';

/// Test script to verify alarm functionality
/// Run this to test the enhanced alarm system
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚨 Testing Enhanced Alarm System...\n');

  // Test 1: Initialize AlarmService
  print('1. Initializing AlarmService...');
  try {
    await AlarmService.initialize();
    print('   ✅ AlarmService initialized successfully\n');
  } catch (e) {
    print('   ❌ Failed to initialize AlarmService: $e\n');
    return;
  }

  // Test 2: Get available alarm sounds
  print('2. Getting available alarm sounds...');
  try {
    final sounds = await AlarmService.getAvailableAlarmSounds();
    print('   ✅ Found ${sounds.length} alarm sounds:');

    for (final sound in sounds) {
      final name = sound['name'];
      final type = sound['type'];
      final uri = sound['uri'];
      print('      - $name ($type): $uri');
    }
    print('');
  } catch (e) {
    print('   ❌ Failed to get alarm sounds: $e\n');
  }

  // Test 3: Test sound preview (system sound only for testing)
  print('3. Testing sound preview...');
  try {
    print('   Playing system alarm preview...');
    await AlarmService.playAlarmSoundPreview('alarm');

    // Wait 2 seconds then stop
    await Future.delayed(const Duration(seconds: 2));
    await AlarmService.stopAlarmSoundPreview();
    print('   ✅ Sound preview test completed\n');
  } catch (e) {
    print('   ❌ Failed to test sound preview: $e\n');
  }

  // Test 4: Schedule a test alarm (5 seconds from now)
  print('4. Testing alarm scheduling...');
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
    print('   ✅ Test alarm scheduled for: $testTime');
    print('   📱 Check your notifications in 5 seconds!\n');
  } catch (e) {
    print('   ❌ Failed to schedule test alarm: $e\n');
  }

  // Test 5: Cancel the test alarm after 10 seconds
  print('5. Scheduling alarm cancellation...');
  Future.delayed(const Duration(seconds: 10), () async {
    try {
      await AlarmService.cancelAlarm(999);
      print('   ✅ Test alarm cancelled successfully');
    } catch (e) {
      print('   ❌ Failed to cancel test alarm: $e');
    }
  });

  print('🎉 Alarm system test completed!');
  print('📝 Check the results above and your device notifications.');
  print(
    '⏰ The test alarm should trigger in 5 seconds and be cancelled after 10 seconds.',
  );
}
