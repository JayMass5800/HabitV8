import 'package:flutter/material.dart';
import 'lib/services/enhanced_insights_service.dart';
import 'lib/services/insights_service.dart';
import 'lib/services/ai_service.dart';
import 'lib/domain/model/habit.dart';

/// Test file to debug the fallback system for habit analysis
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 Testing Fallback System for Habit Analysis');
  print('=' * 50);
  
  // Create test habits
  final testHabits = createTestHabits();
  print('✅ Created ${testHabits.length} test habits');
  
  // Test InsightsService directly
  print('\n📊 Testing InsightsService directly...');
  final insightsService = InsightsService();
  final ruleBasedInsights = insightsService.generateAIInsights(testHabits);
  print('✅ Rule-based insights count: ${ruleBasedInsights.length}');
  for (final insight in ruleBasedInsights) {
    print('   - ${insight['title']}: ${insight['description']}');
  }
  
  // Test AIService configuration
  print('\n🤖 Testing AIService configuration...');
  final aiService = AIService();
  await aiService.initializeApiKeys();
  print('✅ AI Service initialized');
  print('   - isConfigured: ${aiService.isConfigured}');
  print('   - isConfiguredAsync: ${await aiService.isConfiguredAsync}');
  print('   - availableProviders: ${aiService.availableProviders}');
  print('   - availableProvidersAsync: ${await aiService.availableProvidersAsync}');
  
  // Test EnhancedInsightsService
  print('\n🚀 Testing EnhancedInsightsService...');
  final enhancedService = EnhancedInsightsService();
  print('   - isAIAvailable: ${enhancedService.isAIAvailable}');
  print('   - isAIAvailableAsync: ${await enhancedService.isAIAvailableAsync}');
  
  try {
    print('\n📈 Generating comprehensive insights...');
    final comprehensiveInsights = await enhancedService.generateComprehensiveInsights(testHabits);
    print('✅ Comprehensive insights count: ${comprehensiveInsights.length}');
    for (final insight in comprehensiveInsights) {
      print('   - ${insight['title']}: ${insight['description']}');
    }
  } catch (e) {
    print('❌ Error generating comprehensive insights: $e');
  }
  
  // Test getRuleBasedInsights method
  print('\n📋 Testing getRuleBasedInsights method...');
  try {
    final ruleBasedOnly = enhancedService.getRuleBasedInsights(testHabits);
    print('✅ Rule-based only insights count: ${ruleBasedOnly.length}');
    for (final insight in ruleBasedOnly) {
      print('   - ${insight['title']}: ${insight['description']}');
    }
  } catch (e) {
    print('❌ Error generating rule-based insights: $e');
  }
  
  print('\n' + '=' * 50);
  print('🏁 Testing completed');
}

List<Habit> createTestHabits() {
  // Create some test habits with different patterns
  final now = DateTime.now();
  
  return [
    // High-performing habit
    Habit(
      id: '1',
      name: 'Morning Exercise',
      category: 'Health',
      icon: 'fitness_center',
      color: 0xFF4CAF50,
      isActive: true,
      completions: List.generate(15, (i) => now.subtract(Duration(days: i))),
      // Add other required fields with defaults
      reminder: null,
      weekdaySchedule: List.filled(7, true),
      difficulty: 1,
      priority: 1,
      notes: '',
      isArchived: false,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    ),
    
    // Inconsistent habit
    Habit(
      id: '2',
      name: 'Read Books',
      category: 'Learning',
      icon: 'book',
      color: 0xFF2196F3,
      isActive: true,
      completions: [
        now.subtract(const Duration(days: 1)),
        now.subtract(const Duration(days: 4)),
        now.subtract(const Duration(days: 8)),
        now.subtract(const Duration(days: 12)),
        now.subtract(const Duration(days: 20)),
      ],
      reminder: null,
      weekdaySchedule: List.filled(7, true),
      difficulty: 2,
      priority: 2,
      notes: '',
      isArchived: false,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    ),
    
    // Weekend-dropping habit
    Habit(
      id: '3',
      name: 'Meal Prep',
      category: 'Health',
      icon: 'restaurant',
      color: 0xFFFF9800,
      isActive: true,
      completions: [
        // Weekday completions only
        now.subtract(const Duration(days: 1)), // Tuesday
        now.subtract(const Duration(days: 2)), // Monday
        now.subtract(const Duration(days: 5)), // Friday
        now.subtract(const Duration(days: 8)), // Tuesday
        now.subtract(const Duration(days: 9)), // Monday
      ],
      reminder: null,
      weekdaySchedule: List.filled(7, true),
      difficulty: 3,
      priority: 1,
      notes: '',
      isArchived: false,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    ),
  ];
}