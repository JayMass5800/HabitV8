import 'package:flutter/material.dart';
import '../services/alarm_manager_service.dart';

class AlarmTestWidget extends StatefulWidget {
  const AlarmTestWidget({super.key});

  @override
  State<AlarmTestWidget> createState() => _AlarmTestWidgetState();
}

class _AlarmTestWidgetState extends State<AlarmTestWidget> {
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await AlarmManagerService.initialize();
      setState(() {
        _isInitialized = true;
        _status = 'Service initialized successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _testSystemSound() async {
    try {
      setState(() => _status = 'Testing system sound...');
      await AlarmManagerService.testSystemSound('Early Twilight');
      setState(() => _status = 'System sound test completed');
    } catch (e) {
      setState(() => _status = 'Sound test failed: $e');
    }
  }

  Future<void> _stopSystemSound() async {
    try {
      await AlarmManagerService.stopSystemSound();
      setState(() => _status = 'System sound stopped');
    } catch (e) {
      setState(() => _status = 'Failed to stop sound: $e');
    }
  }

  Future<void> _scheduleTestAlarm() async {
    try {
      setState(() => _status = 'Scheduling test alarm...');

      final alarmTime = DateTime.now().add(const Duration(seconds: 10));

      await AlarmManagerService.scheduleExactAlarm(
        alarmId: 999,
        habitId: 'test_habit',
        habitName: 'Test Alarm',
        scheduledTime: alarmTime,
        frequency: 'daily',
        alarmSoundName: 'Early Twilight',
      );

      setState(
          () => _status = 'Test alarm scheduled for ${alarmTime.toString()}');
    } catch (e) {
      setState(() => _status = 'Failed to schedule alarm: $e');
    }
  }

  Future<void> _cancelTestAlarm() async {
    try {
      await AlarmManagerService.cancelAlarm(999);
      setState(() => _status = 'Test alarm cancelled');
    } catch (e) {
      setState(() => _status = 'Failed to cancel alarm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm System Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: TextStyle(
                        color: _isInitialized ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isInitialized ? _testSystemSound : null,
              child: const Text('Test System Sound'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isInitialized ? _stopSystemSound : null,
              child: const Text('Stop System Sound'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isInitialized ? _scheduleTestAlarm : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Schedule Test Alarm (10 seconds)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isInitialized ? _cancelTestAlarm : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cancel Test Alarm'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Instructions:\n'
              '1. First test system sound to verify Platform Channel works\n'
              '2. Schedule a test alarm to verify background callback\n'
              '3. Wait 10 seconds for alarm to fire\n'
              '4. Check logs for alarm callback execution',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
