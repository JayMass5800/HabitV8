import 'package:flutter/material.dart';
import '../services/widget_integration_service.dart';
import '../data/database.dart';
import '../services/habit_service.dart';

class WidgetDebugScreen extends StatefulWidget {
  const WidgetDebugScreen({super.key});

  @override
  State<WidgetDebugScreen> createState() => _WidgetDebugScreenState();
}

class _WidgetDebugScreenState extends State<WidgetDebugScreen> {
  String _debugInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    try {
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final allHabits = await habitService.getAllHabits();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      String debugText = '';
      debugText += 'Database Status:\n';
      debugText += '- Total habits: ${allHabits.length}\n';
      debugText += '- Date: ${today.toString().split(' ')[0]}\n';
      debugText +=
          '- Weekday: ${today.weekday} (${_getWeekdayName(today.weekday)})\n\n';

      debugText += 'Habits:\n';
      for (var habit in allHabits) {
        debugText += '- ${habit.name}\n';
        debugText += '  Frequency: ${habit.frequency.toString()}\n';
        if (habit.frequency.toString().contains('weekly')) {
          debugText += '  Weekdays: ${habit.selectedWeekdays}\n';
        }
        debugText += '  Active: ${habit.isActive}\n';
        debugText +=
            '  Scheduled for today: ${_isScheduledForToday(habit, today)}\n\n';
      }

      // Test widget data preparation
      final widgetData =
          await WidgetIntegrationService.instance.testPrepareData();
      debugText += 'Widget Data:\n';
      debugText +=
          '- habits JSON length: ${widgetData['habits']?.toString().length ?? 0}\n';
      debugText += '- theme: ${widgetData['themeMode']}\n';
      debugText += '- primaryColor: ${widgetData['primaryColor']}\n';

      setState(() {
        _debugInfo = debugText;
      });
    } catch (e) {
      setState(() {
        _debugInfo = 'Error loading debug info: $e';
      });
    }
  }

  String _getWeekdayName(int weekday) {
    const names = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[weekday];
  }

  bool _isScheduledForToday(dynamic habit, DateTime today) {
    // Simple check - expand this based on your habit model
    final frequency = habit.frequency.toString();
    if (frequency.contains('daily')) return true;
    if (frequency.contains('weekly')) {
      return habit.selectedWeekdays?.contains(today.weekday) ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDebugInfo,
          ),
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () async {
              await WidgetIntegrationService.instance.updateAllWidgets();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Widgets updated')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Debug Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _debugInfo,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
