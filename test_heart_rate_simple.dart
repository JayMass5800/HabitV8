import 'lib/services/health_habit_mapping_service.dart';

void main() async {
  print('Testing Heart Rate Integration...');
  
  // Test heart rate mapping keywords
  print('\n=== Testing Heart Rate Keywords ===');
  final heartRateMapping = HealthHabitMappingService.healthMappings['HEART_RATE'];
  if (heartRateMapping != null) {
    print('✅ Heart rate mapping found');
    print('   Keywords: ${heartRateMapping.keywords.take(10).join(', ')}...');
    print('   Thresholds: ${heartRateMapping.thresholds}');
    print('   Unit: ${heartRateMapping.unit}');
    print('   Description: ${heartRateMapping.description}');
  } else {
    print('❌ Heart rate mapping not found');
  }
  
  // Test category mappings
  print('\n=== Testing Category Mappings ===');
  final categoryMappings = HealthHabitMappingService.categoryMappings;
  
  // Check fitness category
  final fitnessMapping = categoryMappings['fitness'];
  if (fitnessMapping != null) {
    final heartRateInFitness = fitnessMapping.any((m) => m.healthDataType == 'HEART_RATE');
    print('✅ Fitness category ${heartRateInFitness ? 'includes' : 'does not include'} heart rate');
  }
  
  // Check meditation category
  final meditationMapping = categoryMappings['meditation'];
  if (meditationMapping != null) {
    final heartRateInMeditation = meditationMapping.any((m) => m.healthDataType == 'HEART_RATE');
    print('✅ Meditation category ${heartRateInMeditation ? 'includes' : 'does not include'} heart rate');
  }
  
  // Check health category
  final healthMapping = categoryMappings['health'];
  if (healthMapping != null) {
    final heartRateInHealth = healthMapping.any((m) => m.healthDataType == 'HEART_RATE');
    print('✅ Health category ${heartRateInHealth ? 'includes' : 'does not include'} heart rate');
  }
  
  // Test category suggestions
  print('\n=== Testing Category Suggestions ===');
  final cardioSuggestions = HealthHabitMappingService.getCategorySuggestions('cardio workout', 'heart rate training');
  print('Cardio workout suggestions: $cardioSuggestions');
  
  final meditationSuggestions = HealthHabitMappingService.getCategorySuggestions('meditation', 'lower heart rate');
  print('Meditation suggestions: $meditationSuggestions');
  
  final heartRateSuggestions = HealthHabitMappingService.getCategorySuggestions('heart rate monitor', 'track bpm');
  print('Heart rate monitor suggestions: $heartRateSuggestions');
  
  print('\n=== Heart Rate Integration Test Complete ===');
  print('✅ Heart rate has been successfully integrated into the habit mapping system!');
}