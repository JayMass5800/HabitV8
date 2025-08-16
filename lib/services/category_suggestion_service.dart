import '../services/health_habit_mapping_service.dart';
import '../services/logging_service.dart';

/// Comprehensive Category Suggestion Service
/// 
/// This service provides intelligent category suggestions for all types of habits,
/// not just health-related ones. It analyzes habit names and descriptions to
/// suggest the most appropriate categories.
class CategorySuggestionService {
  
  /// Comprehensive category mappings for all habit types
  static const Map<String, CategoryMapping> categoryMappings = {
    // Health & Fitness Categories
    'health': CategoryMapping(
      keywords: [
        'health', 'healthy', 'wellness', 'wellbeing', 'medical', 'doctor',
        'checkup', 'appointment', 'medicine', 'medication', 'pill', 'vitamin',
        'supplement', 'blood', 'pressure', 'diabetes', 'cholesterol', 'weight',
        'diet', 'nutrition', 'hydration', 'water', 'sleep', 'rest', 'recovery',
      ],
      priority: 0.9,
    ),
    'fitness': CategoryMapping(
      keywords: [
        'exercise', 'workout', 'gym', 'fitness', 'training', 'cardio', 'strength',
        'run', 'running', 'jog', 'walk', 'walking', 'bike', 'cycling', 'swim',
        'swimming', 'yoga', 'pilates', 'stretch', 'stretching', 'sports', 'athletic',
        'muscle', 'abs', 'core', 'legs', 'arms', 'chest', 'back', 'shoulders',
        'steps', 'calories', 'active', 'movement', 'physical',
      ],
      priority: 0.9,
    ),
    'mental health': CategoryMapping(
      keywords: [
        'mental', 'mindfulness', 'meditation', 'meditate', 'stress', 'anxiety',
        'depression', 'mood', 'therapy', 'counseling', 'psychology', 'mindful',
        'calm', 'peace', 'relax', 'breathe', 'breathing', 'gratitude', 'journal',
        'journaling', 'reflection', 'self-care', 'emotional', 'feelings',
      ],
      priority: 0.9,
    ),
    
    // Productivity Categories
    'productivity': CategoryMapping(
      keywords: [
        'productive', 'productivity', 'work', 'task', 'todo', 'organize',
        'planning', 'schedule', 'time', 'management', 'efficiency', 'focus',
        'concentration', 'deadline', 'project', 'goal', 'target', 'achievement',
        'complete', 'finish', 'accomplish', 'priority', 'urgent', 'important',
      ],
      priority: 0.8,
    ),
    'work': CategoryMapping(
      keywords: [
        'work', 'job', 'career', 'office', 'meeting', 'email', 'report',
        'presentation', 'client', 'customer', 'colleague', 'boss', 'manager',
        'professional', 'business', 'corporate', 'company', 'team', 'project',
        'deadline', 'conference', 'networking', 'skill', 'development',
      ],
      priority: 0.8,
    ),
    
    // Learning Categories
    'learning': CategoryMapping(
      keywords: [
        'learn', 'learning', 'study', 'studying', 'education', 'course',
        'class', 'lesson', 'tutorial', 'book', 'reading', 'research',
        'knowledge', 'skill', 'practice', 'training', 'development', 'improve',
        'language', 'programming', 'coding', 'math', 'science', 'history',
        'art', 'music', 'instrument', 'guitar', 'piano', 'drawing', 'painting',
      ],
      priority: 0.8,
    ),
    'education': CategoryMapping(
      keywords: [
        'education', 'school', 'university', 'college', 'degree', 'diploma',
        'certificate', 'exam', 'test', 'quiz', 'homework', 'assignment',
        'thesis', 'dissertation', 'research', 'academic', 'student', 'teacher',
        'professor', 'lecture', 'seminar', 'workshop', 'library', 'textbook',
      ],
      priority: 0.8,
    ),
    
    // Personal Development Categories
    'personal': CategoryMapping(
      keywords: [
        'personal', 'self', 'improvement', 'development', 'growth', 'habit',
        'routine', 'discipline', 'motivation', 'inspiration', 'confidence',
        'self-esteem', 'character', 'values', 'principles', 'mindset',
        'attitude', 'behavior', 'change', 'transform', 'better', 'progress',
      ],
      priority: 0.7,
    ),
    'hobbies': CategoryMapping(
      keywords: [
        'hobby', 'hobbies', 'fun', 'enjoyment', 'leisure', 'recreation',
        'entertainment', 'game', 'gaming', 'puzzle', 'craft', 'crafting',
        'diy', 'build', 'create', 'make', 'art', 'creative', 'photography',
        'music', 'instrument', 'sing', 'singing', 'dance', 'dancing',
        'collect', 'collection', 'model', 'gardening', 'cooking', 'baking',
      ],
      priority: 0.7,
    ),
    
    // Social Categories
    'social': CategoryMapping(
      keywords: [
        'social', 'friend', 'friends', 'family', 'relationship', 'connect',
        'communication', 'talk', 'conversation', 'call', 'text', 'message',
        'visit', 'meet', 'gathering', 'party', 'event', 'community', 'group',
        'club', 'volunteer', 'help', 'support', 'network', 'networking',
      ],
      priority: 0.7,
    ),
    
    // Finance Categories
    'finance': CategoryMapping(
      keywords: [
        'money', 'finance', 'financial', 'budget', 'budgeting', 'save',
        'saving', 'savings', 'invest', 'investment', 'investing', 'expense',
        'spending', 'income', 'salary', 'pay', 'payment', 'bill', 'debt',
        'loan', 'credit', 'bank', 'banking', 'account', 'retirement', 'pension',
      ],
      priority: 0.7,
    ),
    
    // Lifestyle Categories
    'lifestyle': CategoryMapping(
      keywords: [
        'lifestyle', 'life', 'living', 'daily', 'routine', 'habit', 'home',
        'house', 'clean', 'cleaning', 'organize', 'tidy', 'maintenance',
        'chore', 'chores', 'laundry', 'dishes', 'shopping', 'grocery',
        'meal', 'prep', 'cook', 'cooking', 'eat', 'eating', 'breakfast',
        'lunch', 'dinner', 'snack', 'drink', 'morning', 'evening', 'night',
      ],
      priority: 0.6,
    ),
    'travel': CategoryMapping(
      keywords: [
        'travel', 'traveling', 'trip', 'vacation', 'holiday', 'journey',
        'adventure', 'explore', 'exploration', 'visit', 'destination',
        'flight', 'hotel', 'booking', 'itinerary', 'sightseeing', 'tourist',
        'culture', 'local', 'experience', 'memory', 'photo', 'souvenir',
      ],
      priority: 0.6,
    ),
  };
  
  /// Get category suggestions based on habit name and description
  static List<String> getCategorySuggestions(String habitName, String? habitDescription) {
    try {
      final searchText = '$habitName ${habitDescription ?? ''}'.toLowerCase().trim();
      
      if (searchText.isEmpty) return [];
      
      final suggestions = <CategorySuggestion>[];
      
      // Analyze text against all category mappings
      for (final entry in categoryMappings.entries) {
        final category = entry.key;
        final mapping = entry.value;
        
        double score = 0.0;
        int matchCount = 0;
        
        // Check for keyword matches
        for (final keyword in mapping.keywords) {
          if (searchText.contains(keyword.toLowerCase())) {
            score += 1.0;
            matchCount++;
            
            // Bonus for exact word matches
            final words = searchText.split(' ');
            if (words.contains(keyword.toLowerCase())) {
              score += 0.5;
            }
            
            // Bonus for matches in habit name vs description
            if (habitName.toLowerCase().contains(keyword.toLowerCase())) {
              score += 0.3;
            }
          }
        }
        
        if (score > 0) {
          // Apply priority weighting
          final finalScore = score * mapping.priority;
          suggestions.add(CategorySuggestion(category, finalScore, matchCount));
        }
      }
      
      // Also get health-related suggestions
      final healthSuggestions = HealthHabitMappingService.getCategorySuggestions(habitName, habitDescription);
      for (final healthCategory in healthSuggestions) {
        final existing = suggestions.where((s) => s.category.toLowerCase() == healthCategory.toLowerCase()).firstOrNull;
        if (existing == null) {
          suggestions.add(CategorySuggestion(healthCategory, 0.8, 1));
        }
      }
      
      // Sort by score (highest first)
      suggestions.sort((a, b) => b.score.compareTo(a.score));
      
      // Return top suggestions, capitalized
      return suggestions
          .take(5)
          .map((s) => _capitalizeCategory(s.category))
          .toList();
          
    } catch (e) {
      AppLogger.error('Error getting category suggestions', e);
      return [];
    }
  }
  
  /// Get all available categories
  static List<String> getAllCategories() {
    final categories = <String>[];
    
    // Add general categories
    categories.addAll(categoryMappings.keys.map(_capitalizeCategory));
    
    // Add health-related categories
    final healthCategories = HealthHabitMappingService.getHealthRelatedCategories();
    for (final category in healthCategories) {
      final capitalized = _capitalizeCategory(category);
      if (!categories.contains(capitalized)) {
        categories.add(capitalized);
      }
    }
    
    // Add some additional standard categories
    const additionalCategories = [
      'Other',
      'Custom',
    ];
    
    for (final category in additionalCategories) {
      if (!categories.contains(category)) {
        categories.add(category);
      }
    }
    
    categories.sort();
    return categories;
  }
  
  /// Capitalize category name properly
  static String _capitalizeCategory(String category) {
    if (category.isEmpty) return category;
    
    // Handle special cases
    if (category.toLowerCase() == 'diy') return 'DIY';
    
    // Split by spaces and capitalize each word
    return category.split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

/// Category mapping configuration
class CategoryMapping {
  final List<String> keywords;
  final double priority;
  
  const CategoryMapping({
    required this.keywords,
    required this.priority,
  });
}

/// Category suggestion with score
class CategorySuggestion {
  final String category;
  final double score;
  final int matchCount;
  
  CategorySuggestion(this.category, this.score, this.matchCount);
}