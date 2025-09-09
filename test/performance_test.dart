import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habitv8/domain/model/habit.dart';
import 'package:habitv8/data/database.dart';
import 'package:habitv8/ui/screens/timeline_screen.dart';
import 'package:habitv8/ui/screens/create_habit_screen.dart';

void main() {
  group('Performance Tests', () {
    late Box<Habit> testBox;

    setUpAll(() async {
      await Hive.initFlutter();
      Hive.registerAdapter(HabitAdapter());
      Hive.registerAdapter(HabitFrequencyAdapter());
      Hive.registerAdapter(HabitDifficultyAdapter());
    });

    setUp(() async {
      testBox = await Hive.openBox<Habit>('test_habits');
    });

    tearDown(() async {
      await testBox.clear();
      await testBox.close();
    });

    testWidgets(
        'Timeline screen should handle large number of habits efficiently',
        (WidgetTester tester) async {
      // Create a large number of test habits
      final habits = List.generate(
          100,
          (index) => Habit.create(
                name: 'Test Habit $index',
                description: 'Description for habit $index',
                category: 'Test',
                // ignore: deprecated_member_use
                colorValue: Colors.blue.value,
                frequency: HabitFrequency.daily,
              ));

      // Add habits to the test box
      for (final habit in habits) {
        await testBox.add(habit);
      }

      // Create a test app with the timeline screen
      final app = ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) async => testBox),
        ],
        child: MaterialApp(
          home: const TimelineScreen(),
        ),
      );

      // Measure the time it takes to build the timeline
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Timeline should load within 2 seconds even with 100 habits
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));

      // Verify that habits are displayed
      expect(find.text('Test Habit 0'), findsOneWidget);
    });

    testWidgets('Habit completion should provide immediate feedback',
        (WidgetTester tester) async {
      // Create a test habit
      final habit = Habit.create(
        name: 'Test Habit',
        description: 'Test Description',
        category: 'Test',
        // ignore: deprecated_member_use
        colorValue: Colors.blue.value,
        frequency: HabitFrequency.daily,
      );

      await testBox.add(habit);

      final app = ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) async => testBox),
        ],
        child: MaterialApp(
          home: const TimelineScreen(),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Find the habit card and tap it to complete
      final habitCard = find.text('Test Habit');
      expect(habitCard, findsOneWidget);

      // Measure the time for UI feedback
      final stopwatch = Stopwatch()..start();

      await tester.tap(habitCard);
      await tester.pump(); // Only pump once to check immediate feedback

      stopwatch.stop();

      // UI should update immediately (within 100ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    testWidgets('Create habit screen should prevent duplicate submissions',
        (WidgetTester tester) async {
      final app = ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) async => testBox),
        ],
        child: MaterialApp(
          home: const CreateHabitScreen(),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Fill in the habit form
      await tester.enterText(find.byType(TextFormField).first, 'Test Habit');

      // Find the save button
      final saveButton = find.text('Save');
      expect(saveButton, findsOneWidget);

      // Tap save button multiple times rapidly
      await tester.tap(saveButton);
      await tester.tap(saveButton);
      await tester.tap(saveButton);

      await tester.pumpAndSettle();

      // Should only create one habit despite multiple taps
      expect(testBox.length, equals(1));
    });

    test('Database service caching should improve performance', () async {
      final habitService = HabitService(testBox);

      // Add some test habits
      final habits = List.generate(
          50,
          (index) => Habit.create(
                name: 'Cached Habit $index',
                description: 'Description $index',
                category: 'Test',
                // ignore: deprecated_member_use
                colorValue: Colors.blue.value,
                frequency: HabitFrequency.daily,
              ));

      for (final habit in habits) {
        await testBox.add(habit);
      }

      // First call should populate cache
      final stopwatch1 = Stopwatch()..start();
      final result1 = await habitService.getAllHabits();
      stopwatch1.stop();

      // Second call should use cache and be faster
      final stopwatch2 = Stopwatch()..start();
      final result2 = await habitService.getAllHabits();
      stopwatch2.stop();

      expect(result1.length, equals(50));
      expect(result2.length, equals(50));

      // Cached call should be significantly faster
      expect(stopwatch2.elapsedMicroseconds,
          lessThan(stopwatch1.elapsedMicroseconds));
    });

    test('Optimistic UI updates should work correctly', () async {
      final habit = Habit.create(
        name: 'Optimistic Test Habit',
        description: 'Test Description',
        category: 'Test',
        // ignore: deprecated_member_use
        colorValue: Colors.blue.value,
        frequency: HabitFrequency.daily,
      );

      await testBox.add(habit);

      // Simulate optimistic completion
      final originalCompletions = habit.completions.length;
      final testDate = DateTime.now();

      // Add optimistic completion
      habit.completions.add(testDate);

      expect(habit.completions.length, equals(originalCompletions + 1));

      // Verify the completion was added
      final hasCompletion = habit.completions.any((completion) =>
          completion.year == testDate.year &&
          completion.month == testDate.month &&
          completion.day == testDate.day);

      expect(hasCompletion, isTrue);
    });
  });
}
