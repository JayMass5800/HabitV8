import 'package:flutter/material.dart';
import 'lib/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  await NotificationService.initialize();

  print('🔔 Testing alarm sound...');

  // Test immediate notification with sound
  await NotificationService.showNotification(
    id: 999,
    title: '🚨 Test Alarm Sound',
    body: 'This should play a sound and vibrate!',
  );

  print('✅ Test notification sent!');
  print('📱 Check your device - you should hear a sound and feel vibration');

  // Test alarm notification
  final alarmTime = DateTime.now().add(const Duration(seconds: 5));
  await NotificationService.scheduleAlarmNotification(
    alarmId: 998,
    habitId: 'test-habit',
    habitName: 'Test Habit',
    scheduledTime: alarmTime,
    frequency: 'test',
  );

  print('⏰ Alarm scheduled for 5 seconds from now');
  print('🔊 The alarm should play sound when it triggers');
}
