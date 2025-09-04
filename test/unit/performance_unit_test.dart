import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habit_v8/domain/model/habit.dart';
import 'package:habit_v8/data/database.dart';

void main() {
  group('Performance Unit Tests', () {
    late Box<Habit> testBox;
    late HabitService habitService;

    setUpAll(() async {
      // Initialize Hive for testing
      Hive.init('./test_db');
      Hive.registerAdapter(HabitAdapter());
      Hive.registerAdapter(HabitFrequencyAdapter());
      Hive.registerAdapter(HabitDifficultyAdapter());
    });

    setUp(() async {
      testBox = await Hive.openBox<Habit>(
          'test_habits_${DateTime.now().millisecondsSinceEpoch}');
      habitService = HabitService(testBox);
    });

    tearDown(() async {
      await testBox.clear();
      await testBox.close();
    });

    test('Database caching should improve performance for repeated calls',
        () async {
      // Add test habits
      final habits = List.generate(
          50,
          (index) => Habit.create(
                name: 'Cached Habit $index',
                description: 'Description $index',
                category: 'Test',
                colorValue: 0xFF2196F3, // Blue color value
                frequency: HabitFrequency.daily,
              ));

      for (final habit in habits) {
        await testBox.add(habit);
      }

      // First call - should populate cache
      final stopwatch1 = Stopwatch()..start();
      final result1 = await habitService.getAllHabits();
      stopwatch1.stop();

      // Second call - should use cache
      final stopwatch2 = Stopwatch()..start();
      final result2 = await habitService.getAllHabits();
      stopwatch2.stop();

      // Third call - should still use cache
      final stopwatch3 = Stopwatch()..start();
      final result3 = await habitService.getAllHabits();
      stopwatch3.stop();

      expect(result1.length, equals(50));
      expect(result2.length, equals(50));
      expect(result3.length, equals(50));

      // Cached calls should be faster than the first call
      expect(stopwatch2.elapsedMicroseconds,
          lessThan(stopwatch1.elapsedMicroseconds));
      expect(stopwatch3.elapsedMicroseconds,
          lessThan(stopwatch1.elapsedMicroseconds));

      print('First call: ${stopwatch1.elapsedMicroseconds}μs');
      print('Second call (cached): ${stopwatch2.elapsedMicroseconds}μs');
      print('Third call (cached): ${stopwatch3.elapsedMicroseconds}μs');
    });

    test('Cache should be invalidated after habit updates', () async {
      // Add initial habit
      final habit = Habit.create(
        name: 'Test Habit',
        description: 'Test Description',
        category: 'Test',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
      );

      await habitService.addHabit(habit);

      // Get habits (should populate cache)
      final result1 = await habitService.getAllHabits();
      expect(result1.length, equals(1));

      // Update the habit
      habit.name = 'Updated Habit';
      await habitService.updateHabit(habit);

      // Get habits again (cache should be invalidated and fresh data returned)
      final result2 = await habitService.getAllHabits();
      expect(result2.length, equals(1));
      expect(result2.first.name, equals('Updated Habit'));
    });

    test('Habit completion operations should be efficient', () async {
      final habit = Habit.create(
        name: 'Performance Test Habit',
        description: 'Test Description',
        category: 'Test',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
      );

      await habitService.addHabit(habit);

      // Test multiple completion operations
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        final completionDate = DateTime.now().subtract(Duration(days: i));
        habit.completions.add(completionDate);
      }

      await habitService.updateHabit(habit);
      stopwatch.stop();

      expect(habit.completions.length, equals(10));

      // Should complete within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));

      print('10 completions processed in: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Large habit list operations should be performant', () async {
      // Create a large number of habits
      final stopwatch = Stopwatch()..start();

      final habits = List.generate(
          200,
          (index) => Habit.create(
                name: 'Habit $index',
                description: 'Description for habit $index',
                category: 'Category ${index % 5}',
                colorValue: 0xFF2196F3,
                frequency: HabitFrequency.daily,
              ));

      // Add all habits
      for (final habit in habits) {
        await habitService.addHabit(habit);
      }

      stopwatch.stop();

      // Verify all habits were added
      final allHabits = await habitService.getAllHabits();
      expect(allHabits.length, equals(200));

      // Should complete within reasonable time
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      print('200 habits created in: ${stopwatch.elapsedMilliseconds}ms');
    });

    test('Optimistic completion simulation should work correctly', () {
      final habit = Habit.create(
        name: 'Optimistic Test Habit',
        description: 'Test Description',
        category: 'Test',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
      );

      final originalCompletions = habit.completions.length;
      final testDate = DateTime.now();

      // Simulate optimistic UI update
      final optimisticCompletions = List<DateTime>.from(habit.completions);
      optimisticCompletions.add(testDate);

      expect(optimisticCompletions.length, equals(originalCompletions + 1));

      // Verify the completion was added optimistically
      final hasCompletion = optimisticCompletions.any((completion) =>
          completion.year == testDate.year &&
          completion.month == testDate.month &&
          completion.day == testDate.day);

      expect(hasCompletion, isTrue);

      // Original habit should remain unchanged until actual save
      expect(habit.completions.length, equals(originalCompletions));
    });

    test('Habit filtering should be efficient', () async {
      // Create habits with different categories
      final categories = ['Health', 'Work', 'Personal', 'Fitness', 'Learning'];
      final habits = <Habit>[];

      for (int i = 0; i < 100; i++) {
        final habit = Habit.create(
          name: 'Habit $i',
          description: 'Description $i',
          category: categories[i % categories.length],
          colorValue: 0xFF2196F3,
          frequency: HabitFrequency.daily,
        );
        habits.add(habit);
        await habitService.addHabit(habit);
      }

      final allHabits = await habitService.getAllHabits();

      // Test filtering performance
      final stopwatch = Stopwatch()..start();

      final healthHabits =
          allHabits.where((habit) => habit.category == 'Health').toList();
      final workHabits =
          allHabits.where((habit) => habit.category == 'Work').toList();
      final personalHabits =
          allHabits.where((habit) => habit.category == 'Personal').toList();

      stopwatch.stop();

      expect(healthHabits.length, equals(20));
      expect(workHabits.length, equals(20));
      expect(personalHabits.length, equals(20));

      // Filtering should be very fast
      expect(stopwatch.elapsedMicroseconds, lessThan(10000)); // 10ms

      print(
          'Filtering 100 habits by category: ${stopwatch.elapsedMicroseconds}μs');
    });
  });
}
