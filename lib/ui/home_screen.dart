import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitV8'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Habit Tracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Quick notification test (keeping the working functionality)
            ElevatedButton(
              onPressed: () async {
                await NotificationService.showTestNotification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test notification sent!')),
                  );
                }
              },
              child: const Text('Test Notification'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await NotificationService.testScheduledNotification();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scheduled notification in 10s!')),
                  );
                }
              },
              child: const Text('Test Scheduled Notification'),
            ),

            const SizedBox(height: 32),

            // Placeholder for your habit features
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.construction, size: 48, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Habit Features Coming Soon',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('The notification system is now working perfectly!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
