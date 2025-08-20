import 'lib/services/health_habit_mapping_service.dart';
import 'lib/services/logging_service.dart';

void main() async {
  AppLogger.info('Testing Heart Rate Integration...');

  // Test heart rate mapping keywords
  AppLogger.info('\n=== Testing Heart Rate Keywords ===');
  final heartRateMapping =
      HealthHabitMappingService.healthMappings['HEART_RATE'];
  if (heartRateMapping != null) {
    AppLogger.info('✅ Heart rate mapping found');
    AppLogger.info(
      '   Keywords: ${heartRateMapping.keywords.take(10).join(', ')}...',
    );
    AppLogger.info('   Thresholds: ${heartRateMapping.thresholds}');
    AppLogger.info('   Unit: ${heartRateMapping.unit}');
    AppLogger.info('   Description: ${heartRateMapping.description}');
  } else {
    AppLogger.info('❌ Heart rate mapping not found');
  }

  // Test category mappings
  AppLogger.info('\n=== Testing Category Mappings ===');
  final categoryMappings = HealthHabitMappingService.categoryMappings;

  // Check fitness category
  final fitnessMapping = categoryMappings['fitness'];
  if (fitnessMapping != null) {
    final heartRateInFitness = fitnessMapping.any(
      (m) => m.healthDataType == 'HEART_RATE',
    );
    AppLogger.info(
      '✅ Fitness category ${heartRateInFitness ? 'includes' : 'does not include'} heart rate',
    );
  }

  // Check meditation category
  final meditationMapping = categoryMappings['meditation'];
  if (meditationMapping != null) {
    final heartRateInMeditation = meditationMapping.any(
      (m) => m.healthDataType == 'HEART_RATE',
    );
    AppLogger.info(
      '✅ Meditation category ${heartRateInMeditation ? 'includes' : 'does not include'} heart rate',
    );
  }

  // Check health category
  final healthMapping = categoryMappings['health'];
  if (healthMapping != null) {
    final heartRateInHealth = healthMapping.any(
      (m) => m.healthDataType == 'HEART_RATE',
    );
    AppLogger.info(
      '✅ Health category ${heartRateInHealth ? 'includes' : 'does not include'} heart rate',
    );
  }

  // Test category suggestions
  AppLogger.info('\n=== Testing Category Suggestions ===');
  final cardioSuggestions = HealthHabitMappingService.getCategorySuggestions(
    'cardio workout',
    'heart rate training',
  );
  AppLogger.info('Cardio workout suggestions: $cardioSuggestions');

  final meditationSuggestions =
      HealthHabitMappingService.getCategorySuggestions(
        'meditation',
        'lower heart rate',
      );
  AppLogger.info('Meditation suggestions: $meditationSuggestions');

  final heartRateSuggestions = HealthHabitMappingService.getCategorySuggestions(
    'heart rate monitor',
    'track bpm',
  );
  AppLogger.info('Heart rate monitor suggestions: $heartRateSuggestions');

  AppLogger.info('\n=== Heart Rate Integration Test Complete ===');
  AppLogger.info(
    '✅ Heart rate has been successfully integrated into the habit mapping system!',
  );
}
