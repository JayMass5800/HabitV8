import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/ui/screens/calendar_screen.dart';

void main() {
  runApp(const ProviderScope(child: TestCalendarApp()));
}

class TestCalendarApp extends StatelessWidget {
  const TestCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalendarScreen(),
    );
  }
}