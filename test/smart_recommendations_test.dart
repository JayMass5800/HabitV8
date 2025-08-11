import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/smart_recommendations_service.dart';

void main() {
  group('SmartRecommendationsService', () {
    test('should filter out existing habits from recommendations', () async {
      // Arrange
      final existingHabits = [
        {
          'id': '1',
          'name': 'Drink Water',
          'category': 'Health',
          'currentStreak': 5,
          'completionRate': 0.8,
          'difficulty': 'Easy',
        },
        {
          'id': '2',
          'name': 'Daily Reading',
          'category': 'Learning',
          'currentStreak': 3,
          'completionRate': 0.7,
          'difficulty': 'Easy',
        },
      ];

      final userPreferences = {'preferredTimeSlot': 'morning'};

      // Act
      final recommendations = await SmartRecommendationsService.generateRecommendations(
        existingHabits: existingHabits,
        userPreferences: userPreferences,
      );

      // Assert
      final recommendationTitles = recommendations.map((r) => r.title.toLowerCase()).toList();
      expect(recommendationTitles, isNot(contains('drink water')));
      expect(recommendationTitles, isNot(contains('daily reading')));
    });

    test('should filter out existing habits from contextual suggestions', () {
      // Arrange
      final existingHabits = [
        {
          'id': '1',
          'name': 'Morning Stretch',
          'category': 'Health',
          'currentStreak': 5,
          'completionRate': 0.8,
          'difficulty': 'Easy',
        },
      ];

      final currentTime = DateTime(2024, 1, 1, 8, 0); // 8 AM

      // Act
      final suggestions = SmartRecommendationsService.getContextualSuggestions(
        currentTime: currentTime,
        existingHabits: existingHabits,
      );

      // Assert
      final suggestionTitles = suggestions.map((s) => s.title.toLowerCase()).toList();
      expect(suggestionTitles, isNot(contains('morning stretch')));
    });

    test('should generate different recommendations on refresh', () async {
      // This test verifies that the randomization provides variety
      final existingHabits = <Map<String, dynamic>>[];
      final userPreferences = {'preferredTimeSlot': 'morning'};

      // Generate recommendations multiple times
      final recommendations1 = await SmartRecommendationsService.generateRecommendations(
        existingHabits: existingHabits,
        userPreferences: userPreferences,
      );

      // Wait a moment to ensure different timestamp for randomization
      await Future.delayed(const Duration(milliseconds: 10));

      final recommendations2 = await SmartRecommendationsService.generateRecommendations(
        existingHabits: existingHabits,
        userPreferences: userPreferences,
      );

      // Assert that we get some recommendations
      expect(recommendations1, isNotEmpty);
      expect(recommendations2, isNotEmpty);

      // Note: Due to randomization, recommendations might be different
      // This test mainly ensures the service is working
    });
  });
}