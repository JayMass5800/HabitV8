import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/ai_settings_screen.dart';

/// Enhanced empty state for AI insights with progressive guidance
class EnhancedEmptyInsightsState extends StatefulWidget {
  final int habitCount;
  final int completionCount;
  final ThemeData theme;

  const EnhancedEmptyInsightsState({
    super.key,
    required this.habitCount,
    required this.completionCount,
    required this.theme,
  });

  @override
  State<EnhancedEmptyInsightsState> createState() =>
      _EnhancedEmptyInsightsStateState();
}

class _EnhancedEmptyInsightsStateState
    extends State<EnhancedEmptyInsightsState> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isAIEnabled = false;
  bool _hasApiKey = false;

  @override
  void initState() {
    super.initState();
    _checkAIStatus();
  }

  Future<void> _checkAIStatus() async {
    final enableAI =
        await _secureStorage.read(key: 'enable_ai_insights') == 'true';
    final openAiKey = await _secureStorage.read(key: 'openai_api_key') ?? '';
    final geminiKey = await _secureStorage.read(key: 'gemini_api_key') ?? '';
    final hasKey = openAiKey.isNotEmpty || geminiKey.isNotEmpty;

    if (mounted) {
      setState(() {
        _isAIEnabled = enableAI;
        _hasApiKey = hasKey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main empty state card
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: widget.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              _buildMainIcon(),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 16),
              _buildDescription(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),

        // Progress indicators
        const SizedBox(height: 24),
        _buildProgressIndicators(),

        // Quick tips
        const SizedBox(height: 24),
        _buildQuickTips(),
      ],
    );
  }

  Widget _buildMainIcon() {
    IconData icon;
    Color color;

    if (!_isAIEnabled && !_hasApiKey) {
      icon = Icons.psychology_outlined;
      color = widget.theme.colorScheme.primary;
    } else if (!_hasApiKey) {
      icon = Icons.key_off;
      color = Colors.orange;
    } else if (widget.habitCount == 0) {
      icon = Icons.add_circle_outline;
      color = widget.theme.colorScheme.primary;
    } else if (widget.completionCount < 5) {
      icon = Icons.trending_up;
      color = widget.theme.colorScheme.primary;
    } else {
      icon = Icons.auto_awesome;
      color = widget.theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        size: 48,
        color: color,
      ),
    );
  }

  Widget _buildTitle() {
    String title;

    if (!_isAIEnabled && !_hasApiKey) {
      title = 'Ready for AI Insights?';
    } else if (!_hasApiKey) {
      title = 'Complete AI Setup';
    } else if (widget.habitCount == 0) {
      title = 'Create Your First Habit';
    } else if (widget.completionCount < 5) {
      title = 'Building Your Profile';
    } else {
      title = 'Generating Insights...';
    }

    return Text(
      title,
      style: widget.theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    String description;

    if (!_isAIEnabled && !_hasApiKey) {
      description =
          'Get personalized, AI-powered insights about your habits. See patterns, get recommendations, and discover optimization opportunities.';
    } else if (!_hasApiKey) {
      description =
          'You\'ve enabled AI insights but need to add an API key to unlock the full experience.';
    } else if (widget.habitCount == 0) {
      description =
          'AI insights are ready! Create some habits to start getting personalized recommendations.';
    } else if (widget.completionCount < 5) {
      description =
          'Great start! Complete a few more habits to give our AI enough data for meaningful insights.';
    } else {
      description =
          'Your AI insights are being generated. This may take a moment...';
    }

    return Text(
      description,
      style: widget.theme.textTheme.bodyLarge?.copyWith(
        color: widget.theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons() {
    if (!_isAIEnabled && !_hasApiKey) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AISettingsScreen()),
                );
                _checkAIStatus();
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Enable AI Insights'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              _showAIBenefitsDialog();
            },
            child: const Text('Learn more about AI insights'),
          ),
        ],
      );
    } else if (!_hasApiKey) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AISettingsScreen()),
            );
            _checkAIStatus();
          },
          icon: const Icon(Icons.key),
          label: const Text('Add API Key'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else if (widget.habitCount == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Go back to main screen to create habits
          },
          icon: const Icon(Icons.add),
          label: const Text('Create a Habit'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildProgressIndicators() {
    final steps = [
      {
        'title': 'Enable AI',
        'completed': _isAIEnabled,
        'description': 'Turn on AI-powered insights',
      },
      {
        'title': 'Add API Key',
        'completed': _hasApiKey,
        'description': 'Connect to AI service',
      },
      {
        'title': 'Create Habits',
        'completed': widget.habitCount > 0,
        'description': '${widget.habitCount} habits created',
      },
      {
        'title': 'Track Progress',
        'completed': widget.completionCount >= 5,
        'description': '${widget.completionCount}/5 completions',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setup Progress',
              style: widget.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isCompleted = step['completed'] as bool;

              return Padding(
                padding:
                    EdgeInsets.only(bottom: index < steps.length - 1 ? 12 : 0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? widget.theme.colorScheme.primary
                            : widget.theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle_outlined,
                        color: isCompleted
                            ? Colors.white
                            : widget.theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: widget.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isCompleted
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isCompleted
                                  ? widget.theme.colorScheme.onSurface
                                  : widget.theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            step['description'] as String,
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: widget.theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTips() {
    final tips = [
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Quality over Quantity',
        'description':
            'AI insights improve with consistent tracking rather than many habits.',
      },
      {
        'icon': Icons.schedule,
        'title': 'Give it Time',
        'description':
            'Meaningful patterns emerge after a few days of consistent tracking.',
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Your Privacy',
        'description':
            'Only anonymized habit data is sent to AI. No personal info is shared.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Tips',
          style: widget.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.theme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      tip['icon'] as IconData,
                      size: 20,
                      color: widget.theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip['title'] as String,
                          style: widget.theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          tip['description'] as String,
                          style: widget.theme.textTheme.bodySmall?.copyWith(
                            color: widget.theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void _showAIBenefitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Insights Benefits'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBenefit(
                Icons.psychology,
                'Personalized Analysis',
                'Get insights tailored to your unique habit patterns and lifestyle.',
              ),
              _buildBenefit(
                Icons.trending_up,
                'Pattern Recognition',
                'Discover hidden correlations between habits, time, and performance.',
              ),
              _buildBenefit(
                Icons.lightbulb,
                'Smart Recommendations',
                'Receive actionable suggestions to optimize your routines.',
              ),
              _buildBenefit(
                Icons.celebration,
                'Motivational Insights',
                'Get encouraging feedback and celebrate your progress.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI insights are optional and complement the existing analytics.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AISettingsScreen()),
              );
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Icon(icon, size: 20, color: widget.theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: widget.theme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
