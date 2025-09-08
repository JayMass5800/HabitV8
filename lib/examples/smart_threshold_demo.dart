import 'package:flutter/material.dart';
import '../services/automatic_habit_completion_service.dart';
import '../services/smart_threshold_service.dart';
import '../services/logging_service.dart';

/// Smart Threshold Demo
///
/// This demonstrates how the smart threshold system works with automatic habit completion.
/// This is for demonstration purposes and shows the integration between services.
class SmartThresholdDemo {
  /// Simulate a complete smart threshold learning cycle
  static Future<Map<String, dynamic>> simulateLearningCycle() async {
    final results = <String, dynamic>{
      'initialStats': {},
      'learningPhase': [],
      'finalStats': {},
      'adaptiveResults': [],
    };

    try {
      AppLogger.info('🧠 Starting Smart Threshold Learning Simulation');

      // 1. Get initial stats
      results['initialStats'] =
          await SmartThresholdService.getSmartThresholdStats();
      AppLogger.info('📊 Initial stats: ${results['initialStats']}');

      // 2. Simulate habit initialization
      const habitId = 'demo_walking_habit';
      await SmartThresholdService.initializeHabitThresholds(habitId);
      AppLogger.info('✅ Initialized thresholds for demo habit');

      // 3. Simulate learning from multiple days of data
      final learningPhase = <Map<String, dynamic>>[];
      final baseDate = DateTime.now().subtract(const Duration(days: 14));

      for (int day = 0; day < 14; day++) {
        final currentDate = baseDate.add(Duration(days: day));
        final isWeekend = currentDate.weekday >= 6;

        // Simulate realistic step patterns
        double stepCount;
        if (isWeekend) {
          // Weekend: more variable, sometimes higher, sometimes lower
          stepCount = 4000 + (day % 3) * 2000 + (day % 2) * 1000;
        } else {
          // Weekday: more consistent, work-related walking
          stepCount = 6000 + (day % 4) * 1500;
        }

        // Simulate different completion scenarios
        final wasAutoCompleted = stepCount >= 5000;
        final wasManuallyCompleted =
            !wasAutoCompleted && (day % 3 == 0); // Sometimes manually completed

        // Learn from this completion
        await SmartThresholdService.learnFromCompletion(
          habitId: habitId,
          healthDataType: 'STEPS',
          healthValue: stepCount,
          usedThreshold: 5000.0, // Original threshold
          wasAutoCompleted: wasAutoCompleted,
          wasManuallyCompleted: wasManuallyCompleted,
          date: currentDate,
        );

        final dayResult = {
          'day': day + 1,
          'date': currentDate.toIso8601String(),
          'stepCount': stepCount,
          'isWeekend': isWeekend,
          'wasAutoCompleted': wasAutoCompleted,
          'wasManuallyCompleted': wasManuallyCompleted,
        };

        learningPhase.add(dayResult);
        AppLogger.info(
            '📈 Day ${day + 1}: $stepCount steps, auto: $wasAutoCompleted, manual: $wasManuallyCompleted');
      }

      results['learningPhase'] = learningPhase;

      // 4. Get updated stats after learning
      results['finalStats'] =
          await SmartThresholdService.getSmartThresholdStats();
      AppLogger.info('📊 Final stats: ${results['finalStats']}');

      // 5. Test adaptive thresholds for different scenarios
      final adaptiveResults = <Map<String, dynamic>>[];
      final testDates = [
        DateTime.now(), // Today
        DateTime.now().add(const Duration(days: 1)), // Tomorrow (weekday)
        DateTime.now().add(const Duration(days: 6)), // Next weekend
      ];

      for (final testDate in testDates) {
        final adaptiveResult = await SmartThresholdService.getAdaptiveThreshold(
          habitId: habitId,
          healthDataType: 'STEPS',
          originalThreshold: 5000.0,
          date: testDate,
        );

        final testResult = {
          'date': testDate.toIso8601String(),
          'isWeekend': testDate.weekday >= 6,
          'originalThreshold': 5000.0,
          'adaptiveThreshold': adaptiveResult.threshold,
          'confidence': adaptiveResult.confidence,
          'reason': adaptiveResult.reason,
          'isAdapted': adaptiveResult.isAdapted,
          'adjustment':
              ((adaptiveResult.threshold - 5000.0) / 5000.0 * 100).round(),
        };

        adaptiveResults.add(testResult);
        AppLogger.info(
            '🎯 ${testDate.weekday >= 6 ? 'Weekend' : 'Weekday'} threshold: ${adaptiveResult.threshold.round()} (${testResult['adjustment']}% adjustment)');
      }

      results['adaptiveResults'] = adaptiveResults;

      AppLogger.info('🎉 Smart Threshold Learning Simulation Complete!');
      return results;
    } catch (e) {
      AppLogger.error('❌ Error in smart threshold simulation', e);
      results['error'] = e.toString();
      return results;
    }
  }

  /// Demonstrate integration with automatic habit completion
  static Future<Map<String, dynamic>> demonstrateIntegration() async {
    final results = <String, dynamic>{
      'serviceStatus': {},
      'smartThresholdStatus': {},
      'integrationTest': {},
    };

    try {
      AppLogger.info('🔗 Demonstrating Smart Threshold Integration');

      // 1. Check service status
      results['serviceStatus'] =
          await AutomaticHabitCompletionService.getServiceStatus();

      // 2. Check smart threshold status
      results['smartThresholdStatus'] =
          await SmartThresholdService.getSmartThresholdStats();

      // 3. Enable smart thresholds if not already enabled
      final isEnabled =
          await AutomaticHabitCompletionService.isSmartThresholdsEnabled();
      if (!isEnabled) {
        await AutomaticHabitCompletionService.setSmartThresholdsEnabled(true);
        AppLogger.info('✅ Enabled smart thresholds for integration test');
      }

      // 4. Simulate a manual check with smart thresholds
      AppLogger.info('🔄 Performing manual check with smart thresholds...');
      final checkResult =
          await AutomaticHabitCompletionService.performManualCheck();

      results['integrationTest'] = {
        'smartThresholdsEnabled':
            await AutomaticHabitCompletionService.isSmartThresholdsEnabled(),
        'checkResult': {
          'completedHabits': checkResult.completedHabits,
          'totalChecked': checkResult.totalChecked,
          'errors': checkResult.errors,
        },
        'finalServiceStatus':
            await AutomaticHabitCompletionService.getServiceStatus(),
      };

      AppLogger.info('🎯 Integration demonstration complete');
      return results;
    } catch (e) {
      AppLogger.error('❌ Error in integration demonstration', e);
      results['error'] = e.toString();
      return results;
    }
  }

  /// Generate a comprehensive report of smart threshold performance
  static Future<Map<String, dynamic>> generatePerformanceReport() async {
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'systemStatus': {},
      'learningMetrics': {},
      'recommendations': <String>[],
    };

    try {
      AppLogger.info('📋 Generating Smart Threshold Performance Report');

      // System status
      report['systemStatus'] = {
        'serviceEnabled':
            await AutomaticHabitCompletionService.isServiceEnabled(),
        'smartThresholdsEnabled':
            await AutomaticHabitCompletionService.isSmartThresholdsEnabled(),
        'realTimeEnabled':
            await AutomaticHabitCompletionService.isRealTimeEnabled(),
        'serviceStatus':
            await AutomaticHabitCompletionService.getServiceStatus(),
      };

      // Learning metrics
      final stats = await SmartThresholdService.getSmartThresholdStats();
      report['learningMetrics'] = stats;

      // Generate recommendations
      final recommendations = <String>[];

      if (!(report['systemStatus']['smartThresholdsEnabled'] as bool)) {
        recommendations.add(
            'Enable smart thresholds to improve automatic completion accuracy');
      }

      final totalHabits = stats['totalHabits'] as int;
      final habitsWithAdjustments = stats['habitsWithAdjustments'] as int;

      if (totalHabits > 0) {
        final adaptationRate = habitsWithAdjustments / totalHabits;
        if (adaptationRate < 0.3) {
          recommendations.add(
              'Consider using the system longer to allow more habits to adapt');
        } else if (adaptationRate > 0.8) {
          recommendations.add(
              'Excellent adaptation rate! Smart thresholds are working well');
        }
      }

      final averageConfidence = stats['averageConfidence'] as double;
      if (averageConfidence < 0.6) {
        recommendations.add(
            'Low confidence detected. More learning data needed for better accuracy');
      } else if (averageConfidence > 0.8) {
        recommendations.add(
            'High confidence achieved! Smart thresholds are highly reliable');
      }

      final totalLearningPoints = stats['totalLearningPoints'] as int;
      if (totalLearningPoints < 50) {
        recommendations
            .add('Continue using the system to gather more learning data');
      } else if (totalLearningPoints > 200) {
        recommendations
            .add('Rich learning dataset available for accurate predictions');
      }

      if (recommendations.isEmpty) {
        recommendations.add('System is operating normally');
      }

      report['recommendations'] = recommendations;

      AppLogger.info(
          '📊 Performance report generated with ${recommendations.length} recommendations');
      return report;
    } catch (e) {
      AppLogger.error('❌ Error generating performance report', e);
      report['error'] = e.toString();
      return report;
    }
  }
}

/// Widget to display smart threshold demo results
class SmartThresholdDemoWidget extends StatefulWidget {
  const SmartThresholdDemoWidget({Key? key}) : super(key: key);

  @override
  State<SmartThresholdDemoWidget> createState() =>
      _SmartThresholdDemoWidgetState();
}

class _SmartThresholdDemoWidgetState extends State<SmartThresholdDemoWidget> {
  bool _isRunning = false;
  Map<String, dynamic>? _results;
  String _currentDemo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Threshold Demo'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Smart Threshold Demonstrations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'These demos show how smart thresholds learn and adapt to improve automatic habit completion accuracy.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Demo buttons
            ElevatedButton.icon(
              onPressed: _isRunning ? null : () => _runDemo('learning'),
              icon: const Icon(Icons.psychology),
              label: const Text('Run Learning Simulation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isRunning ? null : () => _runDemo('integration'),
              icon: const Icon(Icons.integration_instructions),
              label: const Text('Test Integration'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isRunning ? null : () => _runDemo('report'),
              icon: const Icon(Icons.assessment),
              label: const Text('Generate Performance Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Results display
            if (_isRunning)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text('Running demonstration...'),
                    ],
                  ),
                ),
              ),

            if (_results != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Results: $_currentDemo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _formatResults(_results!),
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _runDemo(String demoType) async {
    setState(() {
      _isRunning = true;
      _currentDemo = demoType;
      _results = null;
    });

    try {
      Map<String, dynamic> results;

      switch (demoType) {
        case 'learning':
          results = await SmartThresholdDemo.simulateLearningCycle();
          break;
        case 'integration':
          results = await SmartThresholdDemo.demonstrateIntegration();
          break;
        case 'report':
          results = await SmartThresholdDemo.generatePerformanceReport();
          break;
        default:
          results = {'error': 'Unknown demo type'};
      }

      setState(() {
        _results = results;
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _results = {'error': e.toString()};
        _isRunning = false;
      });
    }
  }

  String _formatResults(Map<String, dynamic> results) {
    final buffer = StringBuffer();

    void writeMap(Map<String, dynamic> map, [int indent = 0]) {
      final prefix = '  ' * indent;
      for (final entry in map.entries) {
        if (entry.value is Map<String, dynamic>) {
          buffer.writeln('$prefix${entry.key}:');
          writeMap(entry.value as Map<String, dynamic>, indent + 1);
        } else if (entry.value is List) {
          buffer.writeln(
              '$prefix${entry.key}: [${(entry.value as List).length} items]');
          for (int i = 0; i < (entry.value as List).length && i < 3; i++) {
            final item = (entry.value as List)[i];
            if (item is Map<String, dynamic>) {
              buffer.writeln('$prefix  [$i]:');
              writeMap(item, indent + 2);
            } else {
              buffer.writeln('$prefix  [$i]: $item');
            }
          }
          if ((entry.value as List).length > 3) {
            buffer.writeln(
                '$prefix  ... and ${(entry.value as List).length - 3} more');
          }
        } else {
          buffer.writeln('$prefix${entry.key}: ${entry.value}');
        }
      }
    }

    writeMap(results);
    return buffer.toString();
  }
}
