import 'lib/services/health_habit_mapping_service.dart';
import 'lib/domain/model/habit.dart';

/// Test script to demonstrate variable step count detection for medical/recovery cases
void main() async {
  print('=== Variable Step Count Detection Test ===\n');
  
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
    print('Testing: "${habit.name}"');
    print('Description: ${habit.description}');
    
    // Check if it's identified as medical/recovery
    final isMedical = HealthHabitMappingService.isMedicalRecoveryHabit(habit);
    print('Medical/Recovery: $isMedical');
    
    // Analyze for health mapping
    final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
    
    if (mapping != null) {
      print('✅ Health mapping found:');
      print('   Health Type: ${mapping.healthDataType}');
      print('   Threshold: ${mapping.threshold} ${mapping.unit}');
      print('   Threshold Level: ${mapping.thresholdLevel}');
      print('   Relevance Score: ${mapping.relevanceScore.toStringAsFixed(2)}');
    } else {
      print('❌ No health mapping found');
    }
    
    print('---\n');
  }
  
  // Show step recommendations
  print('=== Step Count Recommendations ===\n');
  final recommendations = HealthHabitMappingService.getStepRecommendations();
  
  for (final entry in recommendations.entries) {
    final level = entry.key;
    final info = entry.value;
    
    print('$level:');
    print('  Range: ${info['range']}');
    print('  Description: ${info['description']}');
    print('  Threshold: ${info['threshold']} steps');
    print('  Examples: ${info['examples'].join(', ')}');
    print('');
  }
}