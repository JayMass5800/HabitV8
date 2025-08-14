import '../domain/model/habit.dart';
import 'health_habit_mapping_service.dart';
import 'logging_service.dart';

/// Test utility for debugging health habit mapping issues
class HealthHabitMappingTest {
  
  /// Test health habit mapping with sample habits
  static Future<void> testMappings() async {
    AppLogger.info('=== Testing Health Habit Mappings ===');
    
    // Create test habits based on user examples
    final testHabits = [
      Habit.create(
        name: 'take meds',
        category: 'health',
        colorValue: 0xFF4CAF50,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'walk 5000 steps',
        category: 'fitness',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'Walk 10000 steps daily',
        category: 'exercise',
        colorValue: 0xFF2196F3,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'Go to the gym',
        category: 'fitness',
        colorValue: 0xFFFF9800,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'Sleep 8 hours',
        category: 'health',
        colorValue: 0xFF9C27B0,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'Drink 2L water',
        category: 'health',
        colorValue: 0xFF00BCD4,
        frequency: HabitFrequency.daily,
      ),
      Habit.create(
        name: 'Meditate for 10 minutes',
        category: 'wellness',
        colorValue: 0xFF8BC34A,
        frequency: HabitFrequency.daily,
      ),
    ];
    
    AppLogger.info('Testing ${testHabits.length} sample habits...');
    
    for (final habit in testHabits) {
      AppLogger.info('\n--- Testing habit: "${habit.name}" (category: ${habit.category}) ---');
      
      try {
        final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
        
        if (mapping != null) {
          AppLogger.info('✅ MAPPED: ${habit.name}');
          AppLogger.info('   Health Type: ${mapping.healthDataType.name}');
          AppLogger.info('   Threshold: ${mapping.threshold} ${mapping.unit}');
          AppLogger.info('   Threshold Level: ${mapping.thresholdLevel}');
          AppLogger.info('   Relevance Score: ${mapping.relevanceScore.toStringAsFixed(3)}');
          AppLogger.info('   Description: ${mapping.description}');
        } else {
          AppLogger.info('❌ NOT MAPPED: ${habit.name}');
          AppLogger.info('   Reason: No health mapping found');
        }
        
      } catch (e) {
        AppLogger.error('❌ ERROR mapping habit: ${habit.name}', e);
      }
    }
    
    AppLogger.info('\n=== Health Habit Mapping Test Complete ===');
  }
  
  /// Test specific habit mapping
  static Future<void> testSpecificHabit(String habitName, String category) async {
    AppLogger.info('=== Testing Specific Habit: "$habitName" ===');
    
    final habit = Habit.create(
      name: habitName,
      category: category,
      colorValue: 0xFF4CAF50,
      frequency: HabitFrequency.daily,
    );
    
    try {
      final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
      
      if (mapping != null) {
        AppLogger.info('✅ Successfully mapped habit: $habitName');
        AppLogger.info('   Health Type: ${mapping.healthDataType.name}');
        AppLogger.info('   Threshold: ${mapping.threshold} ${mapping.unit}');
        AppLogger.info('   Relevance Score: ${mapping.relevanceScore.toStringAsFixed(3)}');
      } else {
        AppLogger.info('❌ Failed to map habit: $habitName');
      }
      
    } catch (e) {
      AppLogger.error('❌ Error testing habit: $habitName', e);
    }
  }
}