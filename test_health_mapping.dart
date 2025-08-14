import 'lib/services/health_habit_mapping_test.dart';

void main() async {
  print('Testing health habit mapping fixes...');
  
  // Test the specific habits mentioned by the user
  await HealthHabitMappingTest.testSpecificHabit("take meds", "health");
  await HealthHabitMappingTest.testSpecificHabit("walk 5000 steps", "fitness");
  
  // Test category-based detection
  await HealthHabitMappingTest.testSpecificHabit("health habit without keywords", "health");
  await HealthHabitMappingTest.testSpecificHabit("fitness habit without keywords", "fitness");
  
  print('Test complete!');
}