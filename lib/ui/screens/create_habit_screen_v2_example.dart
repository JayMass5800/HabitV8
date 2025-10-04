/// Example Usage of CreateHabitScreenV2
///
/// This file demonstrates various ways to use the streamlined
/// CreateHabitScreenV2 in your application.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Example 1: Basic Navigation
/// Navigate to the create habit screen without any prefilled data
class Example1BasicNavigation extends StatelessWidget {
  const Example1BasicNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Simple navigation to V2 screen
        context.push('/create-habit-v2');
      },
      child: const Text('Create New Habit'),
    );
  }
}

/// Example 2: Navigation with Prefilled Data
/// Navigate with recommendation data pre-filled
class Example2PrefilledData extends StatelessWidget {
  const Example2PrefilledData({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate with prefilled data from recommendations
        context.push('/create-habit-v2', extra: {
          'name': 'Drink 8 Glasses of Water',
          'description': 'Stay hydrated throughout the day',
          'category': 'Health',
          'difficulty': 'easy',
          'suggestedTime': '9:00 AM',
        });
      },
      child: const Text('Create Recommended Habit'),
    );
  }
}

/// Example 3: Different Time Formats
/// The screen supports various time format strings
class Example3TimeFormats extends StatelessWidget {
  const Example3TimeFormats({super.key});

  void _createHabitWithTime(BuildContext context, String timeString) {
    context.push('/create-habit-v2', extra: {
      'name': 'Example Habit',
      'category': 'Health',
      'suggestedTime': timeString,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Specific time formats
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, '9:00 AM'),
          child: const Text('9:00 AM'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, '14:30'),
          child: const Text('14:30 (24-hour)'),
        ),

        // General time descriptions
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, 'morning'),
          child: const Text('Morning (8:00 AM)'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, 'afternoon'),
          child: const Text('Afternoon (2:00 PM)'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, 'evening'),
          child: const Text('Evening (6:00 PM)'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithTime(context, 'night'),
          child: const Text('Night (9:00 PM)'),
        ),
      ],
    );
  }
}

/// Example 4: Category-Based Recommendations
/// Create habits with different categories
class Example4CategoryRecommendations extends StatelessWidget {
  const Example4CategoryRecommendations({super.key});

  void _createHabitWithCategory(
    BuildContext context,
    String name,
    String category,
  ) {
    context.push('/create-habit-v2', extra: {
      'name': name,
      'category': category,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _createHabitWithCategory(
            context,
            'Morning Workout',
            'Fitness',
          ),
          child: const Text('Fitness Habit'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithCategory(
            context,
            'Read for 30 minutes',
            'Learning',
          ),
          child: const Text('Learning Habit'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithCategory(
            context,
            'Meditate',
            'Mindfulness',
          ),
          child: const Text('Mindfulness Habit'),
        ),
        ElevatedButton(
          onPressed: () => _createHabitWithCategory(
            context,
            'Budget Review',
            'Finance',
          ),
          child: const Text('Finance Habit'),
        ),
      ],
    );
  }
}

/// Example 5: Difficulty-Based Frequency
/// The screen automatically suggests frequency based on difficulty
class Example5DifficultyBased extends StatelessWidget {
  const Example5DifficultyBased({super.key});

  void _createHabitWithDifficulty(
    BuildContext context,
    String difficulty,
  ) {
    context.push('/create-habit-v2', extra: {
      'name': 'Example Habit',
      'category': 'Health',
      'difficulty': difficulty,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Easy → Daily frequency
        ElevatedButton(
          onPressed: () => _createHabitWithDifficulty(context, 'easy'),
          child: const Text('Easy (Daily)'),
        ),

        // Medium → Daily frequency
        ElevatedButton(
          onPressed: () => _createHabitWithDifficulty(context, 'medium'),
          child: const Text('Medium (Daily)'),
        ),

        // Hard → Weekly frequency
        ElevatedButton(
          onPressed: () => _createHabitWithDifficulty(context, 'hard'),
          child: const Text('Hard (Weekly)'),
        ),
      ],
    );
  }
}

/// Example 6: Complete Recommendation
/// Full recommendation with all fields
class Example6CompleteRecommendation extends StatelessWidget {
  const Example6CompleteRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.push('/create-habit-v2', extra: {
          'name': 'Morning Meditation',
          'description': 'Start your day with 10 minutes of mindfulness',
          'category': 'Mindfulness',
          'difficulty': 'easy',
          'suggestedTime': '7:00 AM',
        });
      },
      child: const Text('Create Complete Habit'),
    );
  }
}

/// Example 7: Switching Between V1 and V2
/// Show how to conditionally use V1 or V2
class Example7ConditionalVersion extends StatelessWidget {
  final bool useV2;

  const Example7ConditionalVersion({
    super.key,
    this.useV2 = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Choose version based on flag
        final route = useV2 ? '/create-habit-v2' : '/create-habit';
        context.push(route);
      },
      child: Text('Create Habit (${useV2 ? 'V2' : 'V1'})'),
    );
  }
}

/// Example 8: A/B Testing Setup
/// Randomly assign users to V1 or V2 for testing
class Example8ABTesting extends StatelessWidget {
  const Example8ABTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Randomly choose version (for A/B testing)
        final useV2 = DateTime.now().millisecondsSinceEpoch % 2 == 0;
        final route = useV2 ? '/create-habit-v2' : '/create-habit';

        // Log which version was shown (for analytics)
        debugPrint('Showing version: ${useV2 ? 'V2' : 'V1'}');

        context.push(route);
      },
      child: const Text('Create Habit (A/B Test)'),
    );
  }
}

/// Example 9: Feature Flag Based
/// Use feature flags to control which version is shown
class Example9FeatureFlag extends StatelessWidget {
  const Example9FeatureFlag({super.key});

  // Simulated feature flag (in real app, this would come from a service)
  bool get _isV2Enabled => true;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final route = _isV2Enabled ? '/create-habit-v2' : '/create-habit';
        context.push(route);
      },
      child: const Text('Create Habit'),
    );
  }
}

/// Example 10: User Preference Based
/// Let users choose their preferred version
class Example10UserPreference extends StatefulWidget {
  const Example10UserPreference({super.key});

  @override
  State<Example10UserPreference> createState() =>
      _Example10UserPreferenceState();
}

class _Example10UserPreferenceState extends State<Example10UserPreference> {
  bool _preferV2 = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Use Streamlined Interface'),
          subtitle: const Text('V2 provides a cleaner, simpler experience'),
          value: _preferV2,
          onChanged: (value) {
            setState(() {
              _preferV2 = value;
            });
            // In real app, save this preference
            // await SharedPreferences.getInstance()
            //   .then((prefs) => prefs.setBool('prefer_v2', value));
          },
        ),
        ElevatedButton(
          onPressed: () {
            final route = _preferV2 ? '/create-habit-v2' : '/create-habit';
            context.push(route);
          },
          child: const Text('Create Habit'),
        ),
      ],
    );
  }
}

/// Example 11: Integration with Insights Screen
/// Show how insights screen can use V2 for recommendations
class Example11InsightsIntegration extends StatelessWidget {
  const Example11InsightsIntegration({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.lightbulb),
          title: const Text('Recommended: Morning Workout'),
          subtitle: const Text('Based on your fitness goals'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            context.push('/create-habit-v2', extra: {
              'name': 'Morning Workout',
              'description': '30 minutes of exercise to start your day',
              'category': 'Fitness',
              'difficulty': 'medium',
              'suggestedTime': 'morning',
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb),
          title: const Text('Recommended: Evening Reading'),
          subtitle: const Text('Improve your learning consistency'),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            context.push('/create-habit-v2', extra: {
              'name': 'Read for 30 minutes',
              'description': 'Read books or articles before bed',
              'category': 'Learning',
              'difficulty': 'easy',
              'suggestedTime': 'evening',
            });
          },
        ),
      ],
    );
  }
}

/// Example 12: Quick Action Buttons
/// Provide quick actions for common habits
class Example12QuickActions extends StatelessWidget {
  const Example12QuickActions({super.key});

  void _createQuickHabit(
    BuildContext context, {
    required String name,
    required String category,
    required String time,
  }) {
    context.push('/create-habit-v2', extra: {
      'name': name,
      'category': category,
      'difficulty': 'easy',
      'suggestedTime': time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ActionChip(
          avatar: const Icon(Icons.water_drop),
          label: const Text('Drink Water'),
          onPressed: () => _createQuickHabit(
            context,
            name: 'Drink 8 Glasses of Water',
            category: 'Health',
            time: '9:00 AM',
          ),
        ),
        ActionChip(
          avatar: const Icon(Icons.fitness_center),
          label: const Text('Exercise'),
          onPressed: () => _createQuickHabit(
            context,
            name: 'Morning Workout',
            category: 'Fitness',
            time: 'morning',
          ),
        ),
        ActionChip(
          avatar: const Icon(Icons.book),
          label: const Text('Read'),
          onPressed: () => _createQuickHabit(
            context,
            name: 'Read for 30 minutes',
            category: 'Learning',
            time: 'evening',
          ),
        ),
        ActionChip(
          avatar: const Icon(Icons.self_improvement),
          label: const Text('Meditate'),
          onPressed: () => _createQuickHabit(
            context,
            name: 'Morning Meditation',
            category: 'Mindfulness',
            time: '7:00 AM',
          ),
        ),
      ],
    );
  }
}

/// Full Example Screen
/// Demonstrates all examples in one place
class CreateHabitV2ExamplesScreen extends StatelessWidget {
  const CreateHabitV2ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateHabitScreenV2 Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Basic Usage',
            const Example1BasicNavigation(),
          ),
          _buildSection(
            context,
            'With Prefilled Data',
            const Example2PrefilledData(),
          ),
          _buildSection(
            context,
            'Time Formats',
            const Example3TimeFormats(),
          ),
          _buildSection(
            context,
            'Category-Based',
            const Example4CategoryRecommendations(),
          ),
          _buildSection(
            context,
            'Difficulty-Based',
            const Example5DifficultyBased(),
          ),
          _buildSection(
            context,
            'Complete Recommendation',
            const Example6CompleteRecommendation(),
          ),
          _buildSection(
            context,
            'Quick Actions',
            const Example12QuickActions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 24),
      ],
    );
  }
}
