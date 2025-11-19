import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../domain/model/habit.dart';
import 'insights_service.dart';

/// Service for AI-powered insights using external AI APIs
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Logger _logger = Logger();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final InsightsService _insightsService = InsightsService();

  // Configuration - these should be loaded from secure storage or environment variables
  static const String _openAiApiUrl =
      'https://api.openai.com/v1/chat/completions';
  static const String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static const String _geminiAlternativeApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent'; // Note: Never hardcode API keys - use secure storage or environment variables
  String? _openAiApiKey;
  String? _geminiApiKey;
  bool _isInitialized = false;

  // Cache keys
  static const String _insightsCacheKey = 'ai_insights_cache';
  static const String _insightsCacheTimeKey = 'ai_insights_cache_time';
  static const Duration _cacheDuration = Duration(hours: 6);

  /// Initialize API keys from secure storage
  Future<void> initializeApiKeys() async {
    if (_isInitialized) return;

    try {
      _openAiApiKey = await _secureStorage.read(key: 'openai_api_key');
      _geminiApiKey = await _secureStorage.read(key: 'gemini_api_key');
      _isInitialized = true;

      _logger.i(
        'AI Service initialized - OpenAI: ${_openAiApiKey?.isNotEmpty == true ? "configured" : "not configured"}, '
        'Gemini: ${_geminiApiKey?.isNotEmpty == true ? "configured" : "not configured"}',
      );
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
    List<Habit> habits, {
    bool forceRefresh = false,
  }) async {
    debugPrint(
        '🚨 OpenAI: generateOpenAIInsights invoked with ${habits.length} habits (forceRefresh: $forceRefresh)');
    await initializeApiKeys(); // Ensure keys are loaded

    // Check cache first if not forcing refresh
    if (!forceRefresh) {
      final cached = await _getCachedInsights();
      if (cached != null) {
        debugPrint('🚨 OpenAI: Returning cached insights');
        return cached;
      }
    }

    if (_openAiApiKey == null || _openAiApiKey!.isEmpty) {
      debugPrint('🚨 OpenAI: API key missing, returning fallback insights');
      _logger.w('OpenAI API key not configured, using fallback insights');
      return _getFallbackInsights(habits);
    }

    // Validate API key format (OpenAI keys typically start with 'sk-')
    if (!_openAiApiKey!.startsWith('sk-')) {
      debugPrint('🚨 OpenAI: API key invalid format, returning fallback');
      _logger.w(
        'OpenAI API key appears invalid (should start with sk-), using fallback insights',
      );
      return _getFallbackInsights(habits);
    }

    try {
      debugPrint('🚨 OpenAI: Preparing request payload');
      final habitSummary = _generateHabitSummary(habits);
      _logger.i('=== OPENAI API REQUEST ===');
      _logger.i('Habit summary length: ${habitSummary.length} characters');
      final summaryPreviewLength =
          habitSummary.length < 500 ? habitSummary.length : 500;
      _logger.i(
        'Habit summary preview: ${habitSummary.substring(0, summaryPreviewLength)}...',
      );
      _logger.d('Sending request to OpenAI API: $_openAiApiUrl');

      final response = await http.post(
        Uri.parse(_openAiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: jsonEncode({
          'model':
              'gpt-4o-mini', // Updated to use the latest cost-effective model
          'messages': [
            {
              'role': 'system',
              'content':
                  '''You are an expert habit formation coach and behavioral psychologist with deep knowledge of habit science and motivation theory. When analyzing habit data, you MUST:

1. Reference specific habits by their actual names
2. Cite exact metrics (completion rates, streaks, consistency scores)
3. Identify concrete temporal patterns with specific days/times
4. Provide actionable recommendations tailored to individual habit performance
5. Be highly personal and specific, as if you're their dedicated coach
6. Identify correlations between habits (e.g., "You tend to miss 'Reading' when you miss 'Meditation'")

Focus on individual habit details, not just aggregates. Find the weakest link and strongest performer. Spot momentum trends and correlations. Consider difficulty vs. performance.''',
            },
            {
              'role': 'user',
              'content':
                  '''Analyze this DETAILED habit tracking data and provide exactly 3 HIGHLY PERSONALIZED, SPECIFIC insights.
                  
$habitSummary

REQUIREMENTS:
- Mention habits by their actual names (e.g., "Your 'Morning Meditation' has...")
- Use exact numbers from the data (completion rates, streaks, momentum values)
- Reference the last 7 days pattern (✓✗ symbols) when relevant
- Suggest specific time changes, habit stacking opportunities, or tactical adjustments
- Celebrate specific achievements with quantified success

INSIGHT DISTRIBUTION:
1. One insight about a specific struggling habit (name it, cite metrics, suggest fix)
2. One insight celebrating a specific high performer (name it, quantify success)
3. One insight about optimization (habit pairing, timing, streak preservation)

EXAMPLE STYLE:
"Your 'Evening Reading' is struggling at 31% with declining momentum (-0.15). The ✗✗✓✗✗✗✓ pattern shows weekend-only success. Try moving it 2 hours earlier to 8 PM on weekdays to align with your 'Dinner Prep' completion window."

Provide insights in this exact JSON format:
[
  {
    "type": "motivational|pattern|insight|achievement|actionable",
    "title": "Short, specific title with habit name",
    "description": "2-3 sentences with SPECIFIC habit names, ACTUAL numbers, and CONCRETE recommendations",
    "icon": "rocket_launch|trending_up|emoji_events|wb_sunny|weekend|local_fire_department|psychology|lightbulb|fitness_center"
  }
]''',
            },
          ],
          'max_tokens': 1500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('🚨 OpenAI: Received HTTP 200 response');
        final data = jsonDecode(response.body);
        _logger.i('=== OPENAI API RESPONSE ===');
        _logger.i('Response status: ${response.statusCode}');
        if (data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
          final content = data['choices'][0]['message']['content'];
          _logger.i('OpenAI endpoint succeeded');
          _logger.i('Response content length: ${content.length} characters');
          final previewLength = content.length < 300 ? content.length : 300;
          _logger.i(
            'Response preview: ${content.substring(0, previewLength)}...',
          );
          final parsedInsights = _parseAIResponse(content);
          debugPrint('🚨 OpenAI: Parsed ${parsedInsights.length} insights');
          _logger.i('Parsed ${parsedInsights.length} insights from OpenAI');

          // Cache the successful response
          if (parsedInsights.isNotEmpty) {
            await _cacheInsights(parsedInsights);
          }

          for (var i = 0; i < parsedInsights.length; i++) {
            _logger.i('Insight ${i + 1}: ${parsedInsights[i]['title']}');
          }
          return parsedInsights;
        } else {
          _logger.w('OpenAI API response structure unexpected: $data');
          return _getFallbackInsights(habits);
        }
      } else {
        _logger.w('OpenAI API returned status ${response.statusCode}');
        _logger.w('Response body: ${response.body}');
        debugPrint('🚨 OpenAI: HTTP ${response.statusCode}, falling back');

        // Provide specific handling for different error types
        if (response.statusCode == 503) {
          _logger.i(
            'OpenAI service is temporarily overloaded, trying alternative model...',
          );
        } else if (response.statusCode == 429) {
          _logger.i('OpenAI rate limit exceeded, trying alternative model...');
        } else if (response.statusCode == 404) {
          _logger.i('OpenAI model not found, trying alternative model...');
        } else if (response.statusCode == 400) {
          _logger.i('OpenAI bad request, trying alternative model...');
        } else if (response.statusCode >= 500) {
          _logger.i('OpenAI server error, trying alternative model...');
        }

        // Try alternative model for various error conditions
        if (response.statusCode == 404 ||
            response.statusCode == 400 ||
            response.statusCode == 503 ||
            response.statusCode == 429 ||
            response.statusCode >= 500) {
          return _tryAlternativeOpenAIModel(habits, habitSummary);
        }

        return _getFallbackInsights(habits);
      }
    } catch (e) {
      _logger.e('OpenAI API error: $e');
      debugPrint('🚨 OpenAI: Exception encountered - $e');
      return _getFallbackInsights(habits);
    }
  }

  /// Generate AI insights using Google Gemini
  Future<List<Map<String, dynamic>>> generateGeminiInsights(
    List<Habit> habits, {
    bool forceRefresh = false,
  }) async {
    debugPrint(
        '🚨 Gemini: generateGeminiInsights invoked with ${habits.length} habits (forceRefresh: $forceRefresh)');
    await initializeApiKeys(); // Ensure keys are loaded

    // Check cache first if not forcing refresh
    if (!forceRefresh) {
      final cached = await _getCachedInsights();
      if (cached != null) {
        debugPrint('🚨 Gemini: Returning cached insights');
        return cached;
      }
    }

    if (_geminiApiKey == null || _geminiApiKey!.isEmpty) {
      debugPrint('🚨 Gemini: API key missing, returning fallback insights');
      _logger.w('Gemini API key not configured, using fallback insights');
      return _getFallbackInsights(habits);
    }

    // Validate API key format
    if (!_geminiApiKey!.startsWith('AIza')) {
      debugPrint('🚨 Gemini: API key invalid format, returning fallback');
      _logger.w(
        'Gemini API key appears invalid (should start with AIza), using fallback insights',
      );
      return _getFallbackInsights(habits);
    }

    try {
      debugPrint('🚨 Gemini: Preparing request payload');
      final habitSummary = _generateHabitSummary(habits);
      _logger.i('=== GEMINI API REQUEST ===');
      _logger.i('Habit summary length: ${habitSummary.length} characters');
      final summaryPreviewLength =
          habitSummary.length < 500 ? habitSummary.length : 500;
      _logger.i(
        'Habit summary preview: ${habitSummary.substring(0, summaryPreviewLength)}...',
      );
      _logger.d('Sending request to Gemini API: $_geminiApiUrl');

      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      '''You are an expert habit formation coach and behavioral psychologist with deep knowledge of habit science, behavioral psychology, and motivation theory. You've been provided with DETAILED tracking data for specific habits. Your task is to analyze this data deeply and provide 3 HIGHLY PERSONALIZED, SPECIFIC insights.

$habitSummary

CRITICAL REQUIREMENTS:
1. REFERENCE SPECIFIC HABITS BY NAME - mention actual habit names, not generic "your habits"
2. USE ACTUAL DATA POINTS - reference exact completion rates, streaks, consistency scores, momentum values
3. IDENTIFY CONCRETE PATTERNS - cite specific days/times when habits succeed or fail
4. GIVE ACTIONABLE RECOMMENDATIONS - suggest specific changes based on individual habit performance
5. BE PERSONAL AND SPECIFIC - as if you're their personal coach who knows their exact routine
6. IDENTIFY CORRELATIONS - "You tend to miss 'Reading' when you miss 'Meditation'"

ANALYSIS FRAMEWORK:
- Look at INDIVIDUAL habit details, not just aggregates
- Identify the weakest link (lowest completion rate or consistency)
- Find the strongest performer and explain what's working
- Spot temporal patterns (weekday vs weekend, time of day effects)
- Notice momentum trends (improving vs declining habits)
- Detect correlations between habits
- Consider difficulty levels vs. actual performance
- Look for habits close to breaking personal records

INSIGHT TYPES TO PROVIDE:
1. One insight about a SPECIFIC habit that needs attention (name it, cite its metrics, suggest concrete fix)
2. One insight celebrating a SPECIFIC achievement or pattern (name the habit(s), quantify the success)
3. One insight about optimization opportunities (specific habit combinations, timing changes, or streak preservation)

EXAMPLE OF GOOD vs BAD:
❌ BAD (generic): "Your morning habits are doing well. Keep up the good work with consistency."
✅ GOOD (specific): "Your 'Morning Meditation' has an exceptional 94% completion rate with a 23-day streak—just 2 days shy of your 25-day record! The ✓✓✓✓✓✓✓ pattern shows perfect weekly consistency. Lock this in by pairing it with your morning coffee routine."

❌ BAD (generic): "Some habits need more attention to improve performance."
✅ GOOD (specific): "Your 'Evening Reading' is struggling at 31% completion with momentum of -0.15 (declining). The ✗✗✓✗✗✗✓ pattern shows you only succeed on weekends. Try moving it 2 hours earlier to 8 PM on weekdays when your 'Dinner Prep' habit (78% rate) naturally creates a calm transition window."

Provide insights in this exact JSON format:
[
  {
    "type": "motivational|pattern|insight|achievement|actionable",
    "title": "Short, specific title with habit name if possible", 
    "description": "2-3 sentences with SPECIFIC habit names, ACTUAL numbers, and CONCRETE recommendations. Must feel personalized to their exact data.",
    "icon": "rocket_launch|trending_up|emoji_events|wb_sunny|weekend|local_fire_department|psychology|lightbulb|fitness_center"
  }
]''',
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('🚨 Gemini: Received HTTP 200 response');
        final data = jsonDecode(response.body);
        _logger.i('=== GEMINI API RESPONSE ===');
        _logger.i('Response status: ${response.statusCode}');
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final content = data['candidates'][0]['content']['parts'][0]['text'];
          _logger.i('Primary Gemini endpoint succeeded');
          _logger.i('Response content length: ${content.length} characters');
          final previewLength = content.length < 300 ? content.length : 300;
          _logger.i(
            'Response preview: ${content.substring(0, previewLength)}...',
          );
          final parsedInsights = _parseAIResponse(content);
          debugPrint('🚨 Gemini: Parsed ${parsedInsights.length} insights');
          _logger.i('Parsed ${parsedInsights.length} insights from Gemini');

          // Cache the successful response
          if (parsedInsights.isNotEmpty) {
            await _cacheInsights(parsedInsights);
          }

          for (var i = 0; i < parsedInsights.length; i++) {
            _logger.i('Insight ${i + 1}: ${parsedInsights[i]['title']}');
          }
          return parsedInsights;
        } else {
          _logger.w('Gemini API response structure unexpected: $data');
          return _getFallbackInsights(habits);
        }
      } else {
        _logger.w('Gemini API returned status ${response.statusCode}');
        _logger.w('Response body: ${response.body}');
        debugPrint('🚨 Gemini: HTTP ${response.statusCode}, falling back');
        debugPrint('🚨 Gemini: Response body: ${response.body}');

        // Provide specific handling for different error types
        if (response.statusCode == 503) {
          _logger.i(
            'Gemini service is temporarily overloaded, trying alternative endpoint...',
          );
        } else if (response.statusCode == 429) {
          _logger.i(
            'Gemini rate limit exceeded, trying alternative endpoint...',
          );
        } else if (response.statusCode == 404) {
          _logger.i('Gemini model not found, trying alternative endpoint...');
        } else if (response.statusCode >= 500) {
          _logger.i('Gemini server error, trying alternative endpoint...');
        }

        // Try alternative API endpoint for various error conditions
        if (response.statusCode == 404 ||
            response.statusCode == 503 ||
            response.statusCode == 429 ||
            response.statusCode >= 500) {
          return _tryAlternativeGeminiEndpoint(habits, habitSummary);
        }

        return _getFallbackInsights(habits);
      }
    } catch (e) {
      _logger.e('Gemini API error: $e');
      debugPrint('🚨 Gemini: Exception encountered - $e');
      return _getFallbackInsights(habits);
    }
  }

  /// Try alternative Gemini API endpoint
  Future<List<Map<String, dynamic>>> _tryAlternativeGeminiEndpoint(
    List<Habit> habits,
    String habitSummary,
  ) async {
    try {
      debugPrint('🚨 Gemini: Attempting alternative endpoint');
      final response = await http.post(
        Uri.parse('$_geminiAlternativeApiUrl?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text':
                      '''You are an expert habit formation coach. Analyze this habit data and provide exactly 3 personalized, actionable insights.

$habitSummary

Focus on actionable patterns, achievements, and specific improvement opportunities.

Provide insights in this exact JSON format:
[
  {
    "type": "motivational|pattern|insight|achievement|actionable",
    "title": "Short insight title", 
    "description": "Detailed insight explanation with specific actionable advice",
    "icon": "rocket_launch|trending_up|emoji_events|wb_sunny|weekend|local_fire_department|psychology|lightbulb|fitness_center"
  }
]''',
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('🚨 Gemini: Alternative endpoint returned 200');
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final content = data['candidates'][0]['content']['parts'][0]['text'];
          _logger.i('Alternative Gemini endpoint succeeded');
          debugPrint('🚨 Gemini: Alternative endpoint succeeded');
          return _parseAIResponse(content);
        }
      }

      _logger.w(
        'Alternative Gemini endpoint also failed with status ${response.statusCode}',
      );
      debugPrint(
          '🚨 Gemini: Alternative endpoint failed with status ${response.statusCode}');
      return _getFallbackInsights(habits);
    } catch (e) {
      _logger.e('Alternative Gemini API error: $e');
      debugPrint('🚨 Gemini: Alternative endpoint exception - $e');
      return _getFallbackInsights(habits);
    }
  }

  /// Try alternative OpenAI model
  Future<List<Map<String, dynamic>>> _tryAlternativeOpenAIModel(
    List<Habit> habits,
    String habitSummary,
  ) async {
    try {
      debugPrint('🚨 OpenAI: Attempting alternative model');
      // Try gpt-3.5-turbo as fallback
      final response = await http.post(
        Uri.parse(_openAiApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Fallback to the stable model
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an expert habit coach. Analyze habit data and provide actionable insights in JSON format.',
            },
            {
              'role': 'user',
              'content':
                  '''Analyze this habit data and provide exactly 3 personalized insights.
                  
$habitSummary

Provide insights in this exact JSON format:
[
  {
    "type": "motivational|pattern|insight|achievement|actionable",
    "title": "Short insight title",
    "description": "Detailed insight explanation with specific actionable advice",
    "icon": "rocket_launch|trending_up|emoji_events|wb_sunny|weekend|local_fire_department|psychology|lightbulb|fitness_center"
  }
]''',
            },
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('🚨 OpenAI: Alternative model returned 200');
        final data = jsonDecode(response.body);
        if (data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
          final content = data['choices'][0]['message']['content'];
          _logger.i('Alternative OpenAI model succeeded');
          debugPrint('🚨 OpenAI: Alternative model succeeded');
          return _parseAIResponse(content);
        }
      }

      _logger.w(
        'Alternative OpenAI model also failed with status ${response.statusCode}',
      );
      debugPrint(
          '🚨 OpenAI: Alternative model failed with status ${response.statusCode}');
      return _getFallbackInsights(habits);
    } catch (e) {
      _logger.e('Alternative OpenAI API error: $e');
      debugPrint('🚨 OpenAI: Alternative model exception - $e');
      return _getFallbackInsights(habits);
    }
  }

  /// Generate habit summary for AI analysis
  String _generateHabitSummary(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits tracked yet.';

    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions = activeHabits.fold<int>(
      0,
      (sum, h) => sum + h.completions.length,
    );
    final avgCompletionRate = activeHabits.isNotEmpty
        ? activeHabits.map((h) => h.completionRate).reduce((a, b) => a + b) /
            activeHabits.length
        : 0.0;

    final categories = activeHabits.map((h) => h.category).toSet().toList();
    final streaks = activeHabits.map((h) => h.streakInfo.current).toList();
    final bestStreak =
        streaks.isNotEmpty ? streaks.reduce((a, b) => a > b ? a : b) : 0;

    // Enhanced analysis sections
    final temporalPatterns = _analyzeTemporalPatterns(activeHabits);
    final difficultyAnalysis = _analyzeDifficulty(activeHabits);
    final categoryPerformance = _analyzeCategoryPerformance(activeHabits);
    final streakAnalysis = _analyzeStreakPatterns(activeHabits);
    final consistencyMetrics = _analyzeConsistencyMetrics(activeHabits);
    final habitCorrelations = _analyzeHabitCorrelations(activeHabits);
    final individualHabits = _getDetailedHabitBreakdown(activeHabits);

    return '''
HABIT OVERVIEW:
- ${activeHabits.length} active habits across ${categories.length} categories
- Total completions: $totalCompletions
- Average completion rate: ${(avgCompletionRate * 100).toStringAsFixed(1)}%
- Best current streak: $bestStreak days

INDIVIDUAL HABIT DETAILS:
$individualHabits

TEMPORAL PATTERNS:
$temporalPatterns

DIFFICULTY ANALYSIS:
$difficultyAnalysis

CATEGORY PERFORMANCE:
$categoryPerformance

STREAK PATTERNS:
$streakAnalysis

CONSISTENCY METRICS:
$consistencyMetrics

HABIT CORRELATIONS:
$habitCorrelations

RECENT TRENDS:
${_getRecentTrends(activeHabits)}
''';
  }

  /// Get detailed breakdown of individual habits with specific metrics
  String _getDetailedHabitBreakdown(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits to analyze.';

    final buffer = StringBuffer();
    for (var i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final completionRate = (habit.completionRate * 100).toStringAsFixed(1);
      final consistency = habit.consistencyScore.toStringAsFixed(1);
      final streak = habit.streakInfo.current;
      final longestStreak = habit.streakInfo.longest;
      final momentum = habit.momentum.toStringAsFixed(2);

      // Get recent completion pattern (last 7 days)
      final now = DateTime.now();
      final last7Days =
          List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
      final recentPattern = last7Days.map((day) {
        final dayStart = DateTime(day.year, day.month, day.day);
        final dayEnd = dayStart.add(const Duration(days: 1));
        final completed = habit.completions.any((c) =>
            c.isAfter(dayStart.subtract(const Duration(seconds: 1))) &&
            c.isBefore(dayEnd));
        return completed ? '✓' : '✗';
      }).join(' ');

      // Get notification time if set
      final notifTime = habit.notificationTime != null
          ? '${habit.notificationTime!.hour.toString().padLeft(2, '0')}:${habit.notificationTime!.minute.toString().padLeft(2, '0')}'
          : 'none';

      // Get frequency description
      String frequencyDesc = habit.frequency.name;
      if (habit.usesRRule && habit.rruleString != null) {
        frequencyDesc = 'Custom schedule (RRule)';
      } else if (habit.selectedWeekdays.isNotEmpty) {
        final days = habit.selectedWeekdays
            .map(
                (d) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1])
            .join(', ');
        frequencyDesc = 'Weekly: $days';
      }

      buffer.writeln('\nHabit ${i + 1}: "${habit.name}"');
      buffer.writeln('  Category: ${habit.category}');
      buffer.writeln('  Description: ${habit.description ?? "No description"}');
      buffer.writeln('  Frequency: $frequencyDesc');
      buffer.writeln('  Difficulty: ${habit.difficulty.name}');
      buffer.writeln(
          '  Completion Rate: $completionRate% (${habit.completions.length} total completions)');
      buffer.writeln('  Consistency Score: $consistency/100');
      buffer.writeln(
          '  Current Streak: $streak days (best: $longestStreak days)');
      buffer.writeln(
          '  Momentum: $momentum (${momentum == "0.00" ? "stagnant" : double.parse(momentum) > 0 ? "improving" : "declining"})');
      buffer.writeln(
          '  Reminder: $notifTime${habit.alarmEnabled ? " (alarm)" : ""}');
      buffer.writeln('  Last 7 days: $recentPattern');

      // Add specific insights for this habit
      if (habit.completionRate < 0.3) {
        buffer.writeln('  ⚠️ Low engagement - needs attention');
      } else if (habit.completionRate > 0.8) {
        buffer.writeln('  🌟 Strong performance');
      }

      if (streak > 0 &&
          longestStreak > streak &&
          (longestStreak - streak) <= 3) {
        buffer.writeln(
            '  🔥 ${longestStreak - streak} day(s) from personal best!');
      }

      if (habit.consistencyScore < 50) {
        buffer.writeln('  📊 Inconsistent pattern detected');
      }
    }

    return buffer.toString().trim();
  }

  /// Analyze temporal patterns (weekday vs weekend, morning vs evening)
  String _analyzeTemporalPatterns(List<Habit> habits) {
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    int weekdayCompletions = 0;
    int weekendCompletions = 0;
    int morningCompletions = 0;
    int afternoonCompletions = 0;
    int eveningCompletions = 0;

    for (final habit in habits) {
      final recentCompletions =
          habit.completions.where((c) => c.isAfter(last30Days)).toList();

      for (final completion in recentCompletions) {
        // Weekday vs weekend
        if (completion.weekday >= 6) {
          weekendCompletions++;
        } else {
          weekdayCompletions++;
        }

        // Time of day (if we have notification time as proxy)
        if (habit.notificationTime != null) {
          final hour = habit.notificationTime!.hour;
          if (hour < 12) {
            morningCompletions++;
          } else if (hour < 17) {
            afternoonCompletions++;
          } else {
            eveningCompletions++;
          }
        }
      }
    }

    final totalCompletions = weekdayCompletions + weekendCompletions;
    if (totalCompletions == 0) {
      return 'Insufficient data for temporal analysis.';
    }

    final weekdayRate =
        (weekdayCompletions / totalCompletions * 100).toStringAsFixed(1);
    final weekendRate =
        (weekendCompletions / totalCompletions * 100).toStringAsFixed(1);

    String timeDistribution = '';
    if (morningCompletions + afternoonCompletions + eveningCompletions > 0) {
      final total =
          morningCompletions + afternoonCompletions + eveningCompletions;
      timeDistribution =
          '\n- Time distribution: Morning ${(morningCompletions / total * 100).toStringAsFixed(0)}%, '
          'Afternoon ${(afternoonCompletions / total * 100).toStringAsFixed(0)}%, '
          'Evening ${(eveningCompletions / total * 100).toStringAsFixed(0)}%';
    }

    return '- Weekday completion: $weekdayRate%\n'
        '- Weekend completion: $weekendRate%'
        '$timeDistribution';
  }

  /// Analyze habit difficulty distribution and performance
  String _analyzeDifficulty(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits to analyze.';

    final difficultyGroups = <HabitDifficulty, List<Habit>>{};
    for (final habit in habits) {
      difficultyGroups.putIfAbsent(habit.difficulty, () => []).add(habit);
    }

    final buffer = StringBuffer();
    for (final difficulty in HabitDifficulty.values) {
      final habitsInGroup = difficultyGroups[difficulty] ?? [];
      if (habitsInGroup.isEmpty) continue;

      final avgRate =
          habitsInGroup.map((h) => h.completionRate).reduce((a, b) => a + b) /
              habitsInGroup.length;
      buffer.writeln(
        '- ${difficulty.name.toUpperCase()}: ${habitsInGroup.length} habits, ${(avgRate * 100).toStringAsFixed(1)}% avg completion',
      );
    }

    return buffer.toString().trim();
  }

  /// Analyze performance by category
  String _analyzeCategoryPerformance(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits to analyze.';

    final categoryGroups = <String, List<Habit>>{};
    for (final habit in habits) {
      categoryGroups.putIfAbsent(habit.category, () => []).add(habit);
    }

    // Find best and worst performing categories
    String bestCategory = '';
    double bestRate = 0;
    String worstCategory = '';
    double worstRate = 1.0;

    for (final entry in categoryGroups.entries) {
      final avgRate =
          entry.value.map((h) => h.completionRate).reduce((a, b) => a + b) /
              entry.value.length;
      if (avgRate > bestRate) {
        bestRate = avgRate;
        bestCategory = entry.key;
      }
      if (avgRate < worstRate && avgRate > 0) {
        worstRate = avgRate;
        worstCategory = entry.key;
      }
    }

    return '- Best category: $bestCategory (${(bestRate * 100).toStringAsFixed(1)}%)\n'
        '- Needs attention: ${worstCategory.isNotEmpty ? '$worstCategory (${(worstRate * 100).toStringAsFixed(1)}%)' : 'N/A'}\n'
        '- Total categories: ${categoryGroups.length}';
  }

  /// Analyze streak patterns
  String _analyzeStreakPatterns(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits to analyze.';

    final activeStreaks = habits.where((h) => h.streakInfo.current > 0).length;
    final longestCurrentStreak =
        habits.map((h) => h.streakInfo.current).reduce((a, b) => a > b ? a : b);
    final longestEverStreak =
        habits.map((h) => h.streakInfo.longest).reduce((a, b) => a > b ? a : b);
    final avgCurrentStreak =
        habits.map((h) => h.streakInfo.current).reduce((a, b) => a + b) /
            habits.length;

    // Find habits close to breaking their record
    final nearRecord = habits.where((h) {
      final current = h.streakInfo.current;
      final longest = h.streakInfo.longest;
      return current > 0 && longest > current && (longest - current) <= 3;
    }).toList();

    final buffer = StringBuffer();
    buffer.writeln(
      '- Active streaks: $activeStreaks of ${habits.length} habits',
    );
    buffer.writeln('- Longest current: $longestCurrentStreak days');
    buffer.writeln('- Best ever: $longestEverStreak days');
    buffer.writeln(
      '- Average current: ${avgCurrentStreak.toStringAsFixed(1)} days',
    );
    if (nearRecord.isNotEmpty) {
      buffer.writeln('- ${nearRecord.length} habit(s) near personal record');
    }

    return buffer.toString().trim();
  }

  /// Analyze consistency metrics
  String _analyzeConsistencyMetrics(List<Habit> habits) {
    if (habits.isEmpty) return 'No habits to analyze.';

    final consistencyScores = habits.map((h) => h.consistencyScore).toList();
    final avgConsistency =
        consistencyScores.reduce((a, b) => a + b) / consistencyScores.length;
    final highConsistency = habits.where((h) => h.consistencyScore > 80).length;
    final lowConsistency = habits.where((h) => h.consistencyScore < 50).length;

    // Calculate variance in completion rates
    final avgRate =
        habits.map((h) => h.completionRate).reduce((a, b) => a + b) /
            habits.length;
    final variance = habits
            .map(
              (h) =>
                  (h.completionRate - avgRate) * (h.completionRate - avgRate),
            )
            .reduce((a, b) => a + b) /
        habits.length;
    final volatility =
        variance > 0.04 ? 'HIGH' : (variance > 0.02 ? 'MODERATE' : 'LOW');

    return '- Average consistency: ${avgConsistency.toStringAsFixed(1)}/100\n'
        '- High performers (>80): $highConsistency habits\n'
        '- Struggling (<50): $lowConsistency habits\n'
        '- Volatility: $volatility';
  }

  /// Analyze correlations between habits (simple co-occurrence analysis)
  String _analyzeHabitCorrelations(List<Habit> habits) {
    if (habits.length < 2) {
      return 'Need multiple habits for correlation analysis.';
    }

    final now = DateTime.now();
    final last14Days = now.subtract(const Duration(days: 14));

    // Find habits that tend to be completed on the same days
    final correlations = <String, int>{};

    for (int i = 0; i < habits.length; i++) {
      for (int j = i + 1; j < habits.length; j++) {
        final habit1 = habits[i];
        final habit2 = habits[j];

        final completions1 = habit1.completions
            .where((c) => c.isAfter(last14Days))
            .map((c) => '${c.year}-${c.month}-${c.day}')
            .toSet();
        final completions2 = habit2.completions
            .where((c) => c.isAfter(last14Days))
            .map((c) => '${c.year}-${c.month}-${c.day}')
            .toSet();

        final overlap = completions1.intersection(completions2).length;
        if (overlap >= 3) {
          final key = '${habit1.name} + ${habit2.name}';
          correlations[key] = overlap;
        }
      }
    }

    if (correlations.isEmpty) {
      return '- No strong habit correlations detected';
    }

    // Get top correlation
    final topCorrelation = correlations.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    return '- Strong correlation: ${topCorrelation.key} (${topCorrelation.value} days together)\n'
        '- Total correlations found: ${correlations.length}';
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
          .where(
            (c) =>
                c.isAfter(lastWeek) &&
                c.isBefore(now.add(const Duration(days: 1))),
          )
          .length;
      previousCompletions += habit.completions
          .where(
            (c) =>
                c.isAfter(previousWeek) &&
                c.isBefore(lastWeek.add(const Duration(days: 1))),
          )
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
    // Use the intelligent insights service instead of static messages
    try {
      return _insightsService.generateAIInsights(habits);
    } catch (e) {
      _logger.w('Failed to generate insights from InsightsService: $e');
      // Only use static fallback if insights service fails
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
  }

  /// Get cached insights if valid
  Future<List<Map<String, dynamic>>?> _getCachedInsights() async {
    try {
      final cacheTimeStr =
          await _secureStorage.read(key: _insightsCacheTimeKey);
      if (cacheTimeStr == null) return null;

      final cacheTime = DateTime.parse(cacheTimeStr);
      if (DateTime.now().difference(cacheTime) > _cacheDuration) {
        _logger.i('Cached insights expired');
        return null;
      }

      final cachedData = await _secureStorage.read(key: _insightsCacheKey);
      if (cachedData == null) return null;

      final List<dynamic> decoded = jsonDecode(cachedData);
      _logger
          .i('Returning cached insights from ${cacheTime.toIso8601String()}');
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      _logger.e('Error reading cached insights: $e');
      return null;
    }
  }

  /// Cache generated insights
  Future<void> _cacheInsights(List<Map<String, dynamic>> insights) async {
    try {
      await _secureStorage.write(
        key: _insightsCacheKey,
        value: jsonEncode(insights),
      );
      await _secureStorage.write(
        key: _insightsCacheTimeKey,
        value: DateTime.now().toIso8601String(),
      );
      _logger.i('Insights cached successfully');
    } catch (e) {
      _logger.e('Error caching insights: $e');
    }
  }

  /// Get the timestamp of the last cached insights
  Future<DateTime?> getLastInsightsTime() async {
    try {
      final cacheTimeStr =
          await _secureStorage.read(key: _insightsCacheTimeKey);
      if (cacheTimeStr == null) return null;
      return DateTime.parse(cacheTimeStr);
    } catch (e) {
      return null;
    }
  }

  /// Check if AI services are configured
  bool get isConfigured {
    // Return true if we have at least one valid API key
    final hasValidOpenAI = _openAiApiKey != null &&
        _openAiApiKey!.isNotEmpty &&
        _openAiApiKey!.startsWith('sk-');
    final hasValidGemini = _geminiApiKey != null &&
        _geminiApiKey!.isNotEmpty &&
        _geminiApiKey!.startsWith('AIza');

    // Debug logging
    _logger.i('🔍 AIService.isConfigured check:');
    _logger.i(
        '  - _openAiApiKey: ${_openAiApiKey == null ? "null" : (_openAiApiKey!.isEmpty ? "empty" : "has value (${_openAiApiKey!.substring(0, 6)}...)")}');
    _logger.i('  - hasValidOpenAI: $hasValidOpenAI');
    _logger.i(
        '  - _geminiApiKey: ${_geminiApiKey == null ? "null" : (_geminiApiKey!.isEmpty ? "empty" : "has value (${_geminiApiKey!.substring(0, 6)}...)")}');
    _logger.i('  - hasValidGemini: $hasValidGemini');
    _logger.i('  - isConfigured result: ${hasValidOpenAI || hasValidGemini}');

    return hasValidOpenAI || hasValidGemini;
  }

  /// Check if AI services are configured (async version that ensures initialization)
  Future<bool> get isConfiguredAsync async {
    _logger.i('🔍 isConfiguredAsync: START');
    await initializeApiKeys();
    _logger.i('🔍 isConfiguredAsync: After initializeApiKeys');
    final result = isConfigured;
    _logger.i('🔍 isConfiguredAsync: isConfigured returned $result');
    return result;
  }

  /// Get available AI providers
  List<String> get availableProviders {
    debugPrint('🚨 availableProviders getter called');
    debugPrint(
        '🚨 _openAiApiKey: ${_openAiApiKey == null ? "null" : (_openAiApiKey!.isEmpty ? "empty" : "length ${_openAiApiKey!.length}, starts with ${_openAiApiKey!.substring(0, 3)}")}');
    debugPrint(
        '🚨 _geminiApiKey: ${_geminiApiKey == null ? "null" : (_geminiApiKey!.isEmpty ? "empty" : "length ${_geminiApiKey!.length}, starts with ${_geminiApiKey!.substring(0, 6)}")}');

    final providers = <String>[];
    if (_openAiApiKey != null &&
        _openAiApiKey!.isNotEmpty &&
        _openAiApiKey!.startsWith('sk-')) {
      debugPrint('🚨 Adding OpenAI to providers');
      providers.add('OpenAI');
    }
    if (_geminiApiKey != null &&
        _geminiApiKey!.isNotEmpty &&
        _geminiApiKey!.startsWith('AIza')) {
      debugPrint('🚨 Adding Gemini to providers');
      providers.add('Gemini');
    }
    debugPrint('🚨 availableProviders returning: $providers');
    return providers;
  }

  /// Get available AI providers (async version that ensures initialization)
  Future<List<String>> get availableProvidersAsync async {
    debugPrint('🚨 availableProvidersAsync: START');
    await initializeApiKeys();
    debugPrint('🚨 availableProvidersAsync: After initializeApiKeys');
    final result = availableProviders;
    debugPrint(
        '🚨 availableProvidersAsync: availableProviders returned $result');
    return result;
  }

  /// Get current API key status for debugging
  Map<String, dynamic> get apiKeyStatus {
    final openAiValid = _openAiApiKey != null &&
        _openAiApiKey!.isNotEmpty &&
        _openAiApiKey!.startsWith('sk-');
    final geminiValid = _geminiApiKey != null &&
        _geminiApiKey!.isNotEmpty &&
        _geminiApiKey!.startsWith('AIza');

    return {
      'openai_configured': _openAiApiKey != null && _openAiApiKey!.isNotEmpty,
      'openai_valid': openAiValid,
      'gemini_configured': _geminiApiKey != null && _geminiApiKey!.isNotEmpty,
      'gemini_valid': geminiValid,
      'initialized': _isInitialized,
      'available_providers': availableProviders,
    };
  }
}
