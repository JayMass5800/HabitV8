import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/model/habit.dart';

/// Service for AI-powered insights using external AI APIs
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Logger _logger = Logger();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Configuration - these should be loaded from secure storage or environment variables
  static const String _openAiApiUrl =
      'https://api.openai.com/v1/chat/completions';
  static const String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Note: Never hardcode API keys - use secure storage or environment variables
  String? _openAiApiKey;
  String? _geminiApiKey;
  bool _isInitialized = false;

  /// Initialize API keys from secure storage
  Future<void> initializeApiKeys() async {
    if (_isInitialized) return;
    
    try {
      _openAiApiKey = await _secureStorage.read(key: 'openai_api_key');
      _geminiApiKey = await _secureStorage.read(key: 'gemini_api_key');
      _isInitialized = true;
      
      _logger.i('AI Service initialized - OpenAI: ${_openAiApiKey?.isNotEmpty == true ? "configured" : "not configured"}, '
                'Gemini: ${_geminiApiKey?.isNotEmpty == true ? "configured" : "not configured"}');
    } catch (e) {
      _logger.e('Failed to initialize AI keys from secure storage: $e');
      _isInitialized = false;
    }
  }

  /// Save API keys to secure storage
  Future<void> saveApiKeys({String? openAiKey, String? geminiKey}) async {
    try {
      if (openAiKey != null) {
        if (openAiKey.isEmpty) {
          await _secureStorage.delete(key: 'openai_api_key');
        } else {
          await _secureStorage.write(key: 'openai_api_key', value: openAiKey);
        }
        _openAiApiKey = openAiKey.isEmpty ? null : openAiKey;
      }
      
      if (geminiKey != null) {
        if (geminiKey.isEmpty) {
          await _secureStorage.delete(key: 'gemini_api_key');
        } else {
          await _secureStorage.write(key: 'gemini_api_key', value: geminiKey);
        }
        _geminiApiKey = geminiKey.isEmpty ? null : geminiKey;
      }
      
      _logger.i('API keys saved to secure storage');
    } catch (e) {
      _logger.e('Failed to save API keys: $e');
      throw Exception('Failed to save API keys: $e');
    }
  }

  /// Clear all stored API keys
  Future<void> clearApiKeys() async {
    try {
      await _secureStorage.delete(key: 'openai_api_key');
      await _secureStorage.delete(key: 'gemini_api_key');
      _openAiApiKey = null;
      _geminiApiKey = null;
      _logger.i('All API keys cleared from secure storage');
    } catch (e) {
      _logger.e('Failed to clear API keys: $e');
    }
  }

  /// Get a specific API key
  Future<String?> getApiKey(String provider) async {
    try {
      await initializeApiKeys();
      switch (provider.toLowerCase()) {
        case 'openai':
          return _openAiApiKey;
        case 'gemini':
          return _geminiApiKey;
        default:
          _logger.w('Unknown provider requested: $provider');
          return null;
      }
    } catch (e) {
      _logger.e('Error getting API key for $provider: $e');
      return null;
    }
  }

  /// Clear a specific API key
  Future<void> clearApiKey(String provider) async {
    try {
      switch (provider.toLowerCase()) {
        case 'openai':
          await _secureStorage.delete(key: 'openai_api_key');
          _openAiApiKey = null;
          _logger.i('OpenAI API key cleared');
          break;
        case 'gemini':
          await _secureStorage.delete(key: 'gemini_api_key');
          _geminiApiKey = null;
          _logger.i('Gemini API key cleared');
          break;
        default:
          _logger.w('Unknown provider for key clearing: $provider');
      }
    } catch (e) {
      _logger.e('Failed to clear API key for $provider: $e');
    }
  }

  /// Generate AI-powered insights using OpenAI GPT
  Future<List<Map<String, dynamic>>> generateOpenAIInsights(
      List<Habit> habits) async {
    await initializeApiKeys(); // Ensure keys are loaded
    
    if (_openAiApiKey == null || _openAiApiKey!.isEmpty) {
      _logger.w('OpenAI API key not configured, falling back to rule-based insights');
      return _getFallbackInsights(habits);
    }

    try {
      final habitSummary = _generateHabitSummary(habits);

      final response = await http.post(
        Uri.parse(_openAiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a habit coach AI assistant. Analyze habit data and provide personalized insights and recommendations. Return exactly 3 insights in JSON format with fields: type, title, description, icon.'
            },
            {
              'role': 'user',
              'content':
                  'Analyze these habits and provide insights: $habitSummary'
            }
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _parseAIResponse(content);
      }
    } catch (e) {
      _logger.e('OpenAI API error: $e');
    }

    return _getFallbackInsights(habits);
  }

  /// Generate AI insights using Google Gemini
  Future<List<Map<String, dynamic>>> generateGeminiInsights(
      List<Habit> habits) async {
    await initializeApiKeys(); // Ensure keys are loaded
    
    if (_geminiApiKey == null || _geminiApiKey!.isEmpty) {
      _logger.w('Gemini API key not configured, falling back to rule-based insights');
      return _getFallbackInsights(habits);
    }

    try {
      final habitSummary = _generateHabitSummary(habits);

      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      '''Analyze these habit tracking data and provide exactly 3 personalized insights.
                  
Habit Data: $habitSummary

Please provide insights in this JSON format:
[
  {
    "type": "motivational|pattern|insight|achievement",
    "title": "Short insight title",
    "description": "Detailed insight explanation",
    "icon": "rocket_launch|trending_up|emoji_events|wb_sunny"
  }
]'''
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        return _parseAIResponse(content);
      }
    } catch (e) {
      _logger.e('Gemini API error: $e');
    }

    return _getFallbackInsights(habits);
  }

  /// Generate habit summary for AI analysis
  String _generateHabitSummary(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits tracked yet.';

    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions =
        activeHabits.fold<int>(0, (sum, h) => sum + h.completions.length);
    final avgCompletionRate = activeHabits.isNotEmpty
        ? activeHabits.map((h) => h.completionRate).reduce((a, b) => a + b) /
            activeHabits.length
        : 0.0;

    final categories = activeHabits.map((h) => h.category).toSet().toList();
    final streaks = activeHabits.map((h) => h.streakInfo.current).toList();
    final bestStreak =
        streaks.isNotEmpty ? streaks.reduce((a, b) => a > b ? a : b) : 0;

    return '''
User has ${activeHabits.length} active habits across ${categories.length} categories: ${categories.join(', ')}.
Total completions: $totalCompletions
Average completion rate: ${(avgCompletionRate * 100).toStringAsFixed(1)}%
Best current streak: $bestStreak days
Categories: ${categories.join(', ')}
Recent performance trends: ${_getRecentTrends(activeHabits)}
''';
  }

  /// Get recent performance trends
  String _getRecentTrends(List<Habit> habits) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final previousWeek = now.subtract(const Duration(days: 14));

    int recentCompletions = 0;
    int previousCompletions = 0;

    for (final habit in habits) {
      recentCompletions += habit.completions
          .where((c) =>
              c.isAfter(lastWeek) &&
              c.isBefore(now.add(const Duration(days: 1))))
          .length;
      previousCompletions += habit.completions
          .where((c) =>
              c.isAfter(previousWeek) &&
              c.isBefore(lastWeek.add(const Duration(days: 1))))
          .length;
    }

    if (recentCompletions > previousCompletions) {
      return 'improving (${recentCompletions - previousCompletions} more completions this week)';
    } else if (recentCompletions < previousCompletions) {
      return 'declining (${previousCompletions - recentCompletions} fewer completions this week)';
    } else {
      return 'stable performance';
    }
  }

  /// Parse AI response and extract insights
  List<Map<String, dynamic>> _parseAIResponse(String content) {
    try {
      // Try to extract JSON from the response
      final jsonStart = content.indexOf('[');
      final jsonEnd = content.lastIndexOf(']') + 1;

      if (jsonStart != -1 && jsonEnd != -1) {
        final jsonString = content.substring(jsonStart, jsonEnd);
        final List<dynamic> parsed = jsonDecode(jsonString);

        return parsed.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      _logger.e('Error parsing AI response: $e');
    }

    return [];
  }

  /// Fallback insights when AI is not available
  List<Map<String, dynamic>> _getFallbackInsights(List<Habit> habits) {
    return [
      {
        'type': 'motivational',
        'title': 'Keep Building',
        'description':
            'Every small step counts towards building lasting habits. Your consistency matters more than perfection.',
        'icon': 'rocket_launch',
      },
      {
        'type': 'pattern',
        'title': 'Track Your Progress',
        'description':
            'Continue logging your habits to unlock personalized AI insights and recommendations.',
        'icon': 'trending_up',
      },
      {
        'type': 'achievement',
        'title': 'You\'re Growing',
        'description':
            'Each day you track is a step towards better self-awareness and habit mastery.',
        'icon': 'emoji_events',
      },
    ];
  }

  /// Check if AI services are configured
  bool get isConfigured {
    // Return true if we have at least one non-empty API key
    return (_openAiApiKey != null && _openAiApiKey!.isNotEmpty) || 
           (_geminiApiKey != null && _geminiApiKey!.isNotEmpty);
  }

  /// Check if AI services are configured (async version that ensures initialization)
  Future<bool> get isConfiguredAsync async {
    await initializeApiKeys();
    return isConfigured;
  }

  /// Get available AI providers
  List<String> get availableProviders {
    final providers = <String>[];
    if (_openAiApiKey != null && _openAiApiKey!.isNotEmpty) {
      providers.add('OpenAI');
    }
    if (_geminiApiKey != null && _geminiApiKey!.isNotEmpty) {
      providers.add('Gemini');
    }
    return providers;
  }

  /// Get available AI providers (async version that ensures initialization)
  Future<List<String>> get availableProvidersAsync async {
    await initializeApiKeys();
    return availableProviders;
  }

  /// Get current API key status for debugging
  Map<String, bool> get apiKeyStatus {
    return {
      'openai_configured': _openAiApiKey != null && _openAiApiKey!.isNotEmpty,
      'gemini_configured': _geminiApiKey != null && _geminiApiKey!.isNotEmpty,
      'initialized': _isInitialized,
    };
  }
}
