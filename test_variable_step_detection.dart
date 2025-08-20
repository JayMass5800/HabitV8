import 'lib/services/health_habit_mapping_service.dart';
import 'lib/services/logging_service.dart';
import 'lib/domain/model/habit.dart';

/// Test script to demonstrate variable step count detection for medical/recovery cases
void main() async {
  AppLogger.info('=== Variable Step Count Detection Test ===\n');

  // Test cases for different step count scenarios
  final testHabits = [
    // Medical/Recovery cases (very low step counts)
    Habit.create(
      name: 'Post-surgery walking 100 steps',
      description: 'Recovery walking after knee surgery',
      category: 'Health',
      colorValue: 0xFF4CAF50,
      frequency: HabitFrequency.daily,
    ),
    Habit.create(
      name: 'Physical therapy walk',
      description: 'Walk at least 250 steps for rehabilitation',
      category: 'Medical',
      colorValue: 0xFF2196F3,
      frequency: HabitFrequency.daily,
    ),
    Habit.create(
      name: 'Assisted mobility 50 steps',
      description: 'Walking with walker assistance',
      category: 'Recovery',
      colorValue: 0xFFFF9800,
      frequency: HabitFrequency.daily,
    ),

    // Regular cases
    Habit.create(
      name: 'Daily walk 5000 steps',
      description: 'Regular daily walking',
      category: 'Fitness',
      colorValue: 0xFF9C27B0,
      frequency: HabitFrequency.daily,
    ),
    Habit.create(
      name: 'Morning walk',
      description: 'Light morning exercise',
      category: 'Exercise',
      colorValue: 0xFFF44336,
      frequency: HabitFrequency.daily,
    ),
  ];

  for (final habit in testHabits) {
    AppLogger.info('Testing: "${habit.name}"');
    AppLogger.info('Description: ${habit.description}');

    // Check if it's identified as medical/recovery
    final isMedical = HealthHabitMappingService.isMedicalRecoveryHabit(habit);
    AppLogger.info('Medical/Recovery: $isMedical');

    // Analyze for health mapping
    final mapping =
        await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);

    if (mapping != null) {
      AppLogger.info('✅ Health mapping found:');
      AppLogger.info('   Health Type: ${mapping.healthDataType}');
      AppLogger.info('   Threshold: ${mapping.threshold} ${mapping.unit}');
      AppLogger.info('   Threshold Level: ${mapping.thresholdLevel}');
      AppLogger.info(
        '   Relevance Score: ${mapping.relevanceScore.toStringAsFixed(2)}',
      );
    } else {
      AppLogger.info('❌ No health mapping found');
    }

    AppLogger.info('---\n');
  }

  // Show step recommendations
  AppLogger.info('=== Step Count Recommendations ===\n');
  final recommendations = HealthHabitMappingService.getStepRecommendations();

  for (final entry in recommendations.entries) {
    final level = entry.key;
    final info = entry.value;

    AppLogger.info('$level:');
    AppLogger.info('  Range: ${info['range']}');
    AppLogger.info('  Description: ${info['description']}');
    AppLogger.info('  Threshold: ${info['threshold']} steps');
    AppLogger.info('  Examples: ${info['examples'].join(', ')}');
    AppLogger.info('');
  }
}
