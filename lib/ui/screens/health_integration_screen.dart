import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../services/health_habit_integration_service.dart';
import '../../services/health_habit_analytics_service.dart';
import '../../services/health_habit_background_service.dart';
import '../../services/health_habit_ui_service.dart';
import '../../services/health_service.dart';
import '../../services/logging_service.dart';

/// Comprehensive Health Integration Dashboard
/// 
/// This screen provides a complete overview of health-habit integration
/// including status, analytics, controls, and insights.
class HealthIntegrationScreen extends ConsumerStatefulWidget {
  const HealthIntegrationScreen({super.key});

  @override
  ConsumerState<HealthIntegrationScreen> createState() => _HealthIntegrationScreenState();
}

class _HealthIntegrationScreenState extends ConsumerState<HealthIntegrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Integration'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
            Tab(icon: Icon(Icons.insights), text: 'Insights'),
            Tab(icon: Icon(Icons.help_outline), text: 'Help'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAnalyticsTab(),
          _buildSettingsTab(),
          _buildInsightsTab(),
          _buildHelpTab(),
        ],
      ),
    );
  }

  /// Overview tab showing integration status and recent activity
  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Health permissions status
            FutureBuilder<bool>(
              future: HealthService.hasPermissions(),
              builder: (context, snapshot) {
                final hasPermissions = snapshot.data ?? false;
                
                return Card(
                  child: ListTile(
                    leading: Icon(
                      hasPermissions ? Icons.check_circle : Icons.warning,
                      color: hasPermissions ? Colors.green : Colors.orange,
                    ),
                    title: const Text('Health Permissions'),
                    subtitle: Text(
                      hasPermissions 
                          ? 'Health data access granted'
                          : 'Health permissions needed for full integration',
                    ),
                    trailing: hasPermissions 
                        ? null 
                        : ElevatedButton(
                            onPressed: _requestHealthPermissions,
                            child: const Text('Grant'),
                          ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Integration status card
            FutureBuilder<HabitService>(
              future: _getHabitService(),
              builder: (context, habitServiceSnapshot) {
                if (!habitServiceSnapshot.hasData) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                
                return HealthHabitUIService.buildIntegrationStatusCard(
                  context: context,
                  habitService: habitServiceSnapshot.data!,
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Today's health metrics
            HealthHabitUIService.buildHealthMetricsSummary(context: context),
            
            const SizedBox(height: 16),
            
            // Background service status
            HealthHabitUIService.buildBackgroundServiceStatus(context: context),
            
            const SizedBox(height: 16),
            
            // Recent sync results
            StreamBuilder<HealthHabitSyncResult>(
              stream: HealthHabitBackgroundService.syncResultStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                
                return HealthHabitUIService.buildSyncResultsCard(
                  context: context,
                  syncStream: HealthHabitBackgroundService.syncResultStream!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Analytics tab showing detailed health-habit correlations and insights
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Analytics summary
          FutureBuilder<HabitService>(
            future: _getHabitService(),
            builder: (context, habitServiceSnapshot) {
              if (!habitServiceSnapshot.hasData) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              
              return HealthHabitUIService.buildAnalyticsSummary(
                context: context,
                habitService: habitServiceSnapshot.data!,
              );
            },
          ),
          
          const SizedBox(height: 16),
          
          // Detailed analytics report
          FutureBuilder<HealthHabitAnalyticsReport>(
            future: _generateDetailedAnalytics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 8),
                        const Text('Analytics Unavailable'),
                        const SizedBox(height: 4),
                        Text(
                          snapshot.data?.error ?? 'Failed to generate analytics',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return _buildAnalyticsReport(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }

  /// Settings tab for configuring health integration
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthHabitUIService.buildHealthHabitSettings(
            context: context,
            onSettingsChanged: () {
              setState(() {}); // Refresh the UI
            },
          ),
          
          const SizedBox(height: 16),
          
          // Advanced settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Advanced Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sync interval setting
                  FutureBuilder<int>(
                    future: HealthHabitBackgroundService.getSyncIntervalMinutes(),
                    builder: (context, snapshot) {
                      final interval = snapshot.data ?? 30;
                      
                      return ListTile(
                        title: const Text('Sync Interval'),
                        subtitle: Text('$interval minutes'),
                        trailing: PopupMenuButton<int>(
                          onSelected: (value) async {
                            await HealthHabitBackgroundService.setSyncIntervalMinutes(value);
                            setState(() {});
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 15, child: Text('15 minutes')),
                            const PopupMenuItem(value: 30, child: Text('30 minutes')),
                            const PopupMenuItem(value: 60, child: Text('1 hour')),
                            const PopupMenuItem(value: 120, child: Text('2 hours')),
                          ],
                          child: const Icon(Icons.more_vert),
                        ),
                      );
                    },
                  ),
                  
                  // Force sync button
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _forceSyncNow,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync),
                      label: Text(_isLoading ? 'Syncing...' : 'Force Sync Now'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // System status
                  FutureBuilder<Map<String, dynamic>>(
                    future: HealthHabitBackgroundService.getStatus(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();
                      
                      final status = snapshot.data!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'System Status',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text('Service Running: ${status['isRunning'] ?? false}'),
                          Text('Last Sync: ${_formatLastSync(status['lastSyncTime'])}'),
                          if (status['nextSyncTime'] != null)
                            Text('Next Sync: ${_formatNextSync(status['nextSyncTime'])}'),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Insights tab showing predictive insights and recommendations
  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health-Habit Insights',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          FutureBuilder<HealthHabitAnalyticsReport>(
            future: _generateDetailedAnalytics(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.hasError) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Insights unavailable'),
                  ),
                );
              }
              
              final report = snapshot.data!;
              
              return Column(
                children: [
                  // Predictive insights
                  if (report.predictiveInsights.isNotEmpty) ...[
                    _buildInsightsSection(
                      'Predictive Insights',
                      Icons.psychology,
                      report.predictiveInsights.map((insight) => ListTile(
                        leading: const Icon(
                          Icons.lightbulb,
                          color: Colors.orange,
                        ),
                        title: Text(insight),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Recommendations
                  if (report.recommendations.isNotEmpty) ...[
                    _buildInsightsSection(
                      'Recommendations',
                      Icons.tune,
                      report.recommendations.map((rec) => ListTile(
                        leading: const Icon(Icons.trending_up, color: Colors.blue),
                        title: Text(rec),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsReport(HealthHabitAnalyticsReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall score card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Health-Habit Score',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: report.overallScore / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          report.overallScore >= 75 ? Colors.green :
                          report.overallScore >= 50 ? Colors.orange : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${report.overallScore.round()}/100',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getScoreDescription(report.overallScore),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Individual habit analyses
        if (report.habitAnalytics.isNotEmpty) ...[
          const Text(
            'Habit Analysis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...report.habitAnalytics.values.map((analysis) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.habitName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          'Completion',
                          '${(analysis.completionRate * 100).round()}%',
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildMetricTile(
                          'Streak',
                          '${analysis.currentStreak}',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (analysis.healthDataType != null)
                    Text(
                      'Health data type: ${analysis.healthDataType}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildInsightsSection(String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildBenchmarkSection(Map<String, dynamic> benchmarks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.leaderboard, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Benchmark Comparison',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...benchmarks.entries.map((entry) {
              final comparison = entry.value;
              final percentage = comparison.percentageOfBenchmark;
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comparison.metric),
                        Text(
                          '${comparison.userValue.round()} ${comparison.unit}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (percentage / 100).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        comparison.exceedsBenchmark ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${percentage.round()}% of benchmark (${comparison.benchmarkValue.round()} ${comparison.unit})',
                      style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreDescription(double score) {
    if (score >= 90) return 'Excellent health-habit integration! 🌟';
    if (score >= 75) return 'Great integration with room for optimization 👍';
    if (score >= 50) return 'Good foundation, consider enabling more features 📈';
    if (score >= 25) return 'Basic integration, significant improvement potential 🚀';
    return 'Limited integration, enable health permissions for better experience 💡';
  }

  String _formatLastSync(dynamic lastSyncTime) {
    if (lastSyncTime == null) return 'Never';
    
    try {
      final DateTime syncTime;
      if (lastSyncTime is String) {
        syncTime = DateTime.parse(lastSyncTime);
      } else if (lastSyncTime is int) {
        syncTime = DateTime.fromMillisecondsSinceEpoch(lastSyncTime);
      } else {
        return 'Unknown';
      }
      
      final now = DateTime.now();
      final difference = now.difference(syncTime);
      
      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      return '${difference.inDays}d ago';
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatNextSync(dynamic nextSyncTime) {
    if (nextSyncTime == null) return 'Unknown';
    
    try {
      final DateTime syncTime;
      if (nextSyncTime is String) {
        syncTime = DateTime.parse(nextSyncTime);
      } else if (nextSyncTime is int) {
        syncTime = DateTime.fromMillisecondsSinceEpoch(nextSyncTime);
      } else {
        return 'Unknown';
      }
      
      final now = DateTime.now();
      final difference = syncTime.difference(now);
      
      if (difference.inMinutes < 1) return 'Soon';
      if (difference.inMinutes < 60) return 'In ${difference.inMinutes}m';
      if (difference.inHours < 24) return 'In ${difference.inHours}h';
      return 'In ${difference.inDays}d';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Refresh health permissions
      await HealthService.refreshPermissions();
      
      // Force a background sync if enabled
      final isEnabled = await HealthHabitBackgroundService.isBackgroundServiceEnabled();
      if (isEnabled) {
        await HealthHabitBackgroundService.forceSyncNow();
      }
      
    } catch (e) {
      AppLogger.error('Error refreshing health integration data', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _requestHealthPermissions() async {
    try {
      final granted = await HealthService.requestPermissions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              granted
                  ? 'Health permissions granted! Integration is now active.'
                  : 'Health permissions denied. Some features may be limited.',
            ),
            backgroundColor: granted ? Colors.green : Colors.orange,
          ),
        );
        
        if (granted) {
          setState(() {}); // Refresh the UI
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request permissions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _forceSyncNow() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final result = await HealthHabitBackgroundService.forceSyncNow();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.hasCompletions
                  ? 'Sync completed! ${result.completionCount} habits auto-completed.'
                  : 'Sync completed - no habits auto-completed.',
            ),
            backgroundColor: result.hasCompletions ? Colors.green : Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<HabitService> _getHabitService() async {
    final habitBox = await DatabaseService.getInstance();
    return HabitService(habitBox);
  }

  Future<HealthHabitAnalyticsReport> _generateDetailedAnalytics() async {
    final habitService = await _getHabitService();
    return await HealthHabitAnalyticsService.generateAnalyticsReport(
      habitService: habitService,
      analysisWindowDays: 90,
    );
  }

  /// Help tab with comprehensive guide on how health integration works
  Widget _buildHelpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introduction
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'How Health Auto-Completion Works',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Health integration automatically completes your habits based on data from your device\'s health app. '
                    'The system analyzes your habit names and descriptions to determine which health metrics to track.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Steps/Walking Section
          _buildHelpSection(
            icon: Icons.directions_walk,
            title: 'Steps & Walking Habits',
            color: Colors.blue,
            description: 'Tracks your daily step count and walking activities',
            keywords: [
              'walk', 'walking', 'step', 'steps', 'jog', 'jogging', 'run', 'running',
              'hike', 'hiking', 'treadmill', 'commute', 'errands', 'shopping'
            ],
            examples: [
              '• "Morning walk" → Auto-completes when you reach 3,000+ steps',
              '• "10,000 steps daily" → Uses custom threshold of 10,000 steps',
              '• "Evening jog" → Completes based on step activity',
              '• "Commute on foot" → Tracks walking during commute times'
            ],
            tips: [
              'Include specific step numbers (e.g., "5000 steps") for custom thresholds',
              'Use words like "walk", "jog", "run", "hike" in habit names',
              'Default thresholds: Light (2K), Moderate (5K), Active (8K), Very Active (12K+ steps)'
            ],
          ),
          
          // Exercise/Fitness Section
          _buildHelpSection(
            icon: Icons.fitness_center,
            title: 'Exercise & Fitness Habits',
            color: Colors.red,
            description: 'Tracks calories burned during active exercise',
            keywords: [
              'exercise', 'workout', 'gym', 'fitness', 'training', 'cardio',
              'weights', 'lifting', 'yoga', 'pilates', 'crossfit', 'boxing',
              'tennis', 'basketball', 'swimming', 'cycling', 'vibration plate'
            ],
            examples: [
              '• "Gym workout" → Auto-completes when you burn 250+ calories',
              '• "Vibration plate exercise" → Now detects this activity type',
              '• "Morning yoga" → Completes based on active energy burned',
              '• "Burn 400 calories" → Uses custom threshold of 400 calories'
            ],
            tips: [
              'Include calorie numbers (e.g., "burn 300 calories") for custom targets',
              'Use activity names like "gym", "workout", "yoga", "cardio"',
              'Default thresholds: Light (100), Moderate (250), Active (400), Intense (600+ calories)'
            ],
          ),
          
          // Sleep Section
          _buildHelpSection(
            icon: Icons.bedtime,
            title: 'Sleep & Rest Habits',
            color: Colors.indigo,
            description: 'Tracks your sleep duration and bedtime routines',
            keywords: [
              'sleep', 'sleeping', 'rest', 'bed', 'bedtime', 'nap', 'napping',
              'night', 'slumber', 'dream', 'tired', 'recovery'
            ],
            examples: [
              '• "Get 8 hours sleep" → Auto-completes when you sleep 8+ hours',
              '• "Early bedtime" → Tracks sleep duration',
              '• "Afternoon nap" → Detects nap periods',
              '• "Sleep 7.5 hours" → Uses custom threshold of 7.5 hours'
            ],
            tips: [
              'Include hour numbers (e.g., "sleep 8 hours") for custom targets',
              'Use words like "sleep", "rest", "bed", "nap" in habit names',
              'Default thresholds: Minimum (6h), Good (7h), Optimal (8h), Extended (9h+)'
            ],
          ),
          
          // Water/Hydration Section
          _buildHelpSection(
            icon: Icons.local_drink,
            title: 'Water & Hydration Habits ⚠️',
            color: Colors.cyan,
            description: 'Tracks water intake from health apps (requires manual logging)',
            keywords: [
              'water', 'hydrate', 'hydration', 'drink', 'drinking', 'fluid',
              'bottle', 'glass', 'cup', 'liter', 'ml', 'thirst'
            ],
            examples: [
              '• "Drink 2 liters water" → Auto-completes when you log 2L in health app',
              '• "Morning hydration" → Requires water logging in Apple Health/Google Health',
              '• "8 glasses of water" → Only works if you track water in health apps',
              '• "Stay hydrated" → Needs manual water entry in health apps'
            ],
            tips: [
              '⚠️ IMPORTANT: Water intake is NOT automatically tracked by most devices',
              '⚠️ You must manually log water in Apple Health, Google Health, or compatible apps',
              '⚠️ Consider using manual completion for water habits instead',
              'Popular water tracking apps: WaterMinder, Hydro Coach, MyFitnessPal',
              'Alternative: Set reminders and complete manually when you drink water'
            ],
          ),
          
          // Mindfulness Section
          _buildHelpSection(
            icon: Icons.self_improvement,
            title: 'Mindfulness & Meditation Habits',
            color: Colors.purple,
            description: 'Tracks meditation and mindfulness practice time',
            keywords: [
              'meditate', 'meditation', 'mindful', 'mindfulness', 'breathe',
              'breathing', 'zen', 'calm', 'peace', 'relax', 'focus'
            ],
            examples: [
              '• "10 minutes meditation" → Auto-completes after 10+ minutes',
              '• "Morning mindfulness" → Tracks meditation sessions',
              '• "Breathing exercises" → Detects mindfulness activities',
              '• "Daily zen practice" → Uses default moderate threshold (10 min)'
            ],
            tips: [
              'Include time amounts (e.g., "15 minutes", "20 min") for custom durations',
              'Use words like "meditate", "mindful", "breathe", "zen", "calm"',
              'Default thresholds: Brief (5min), Standard (10min), Extended (20min), Deep (30min+)'
            ],
          ),
          
          // Weight Tracking Section
          _buildHelpSection(
            icon: Icons.monitor_weight,
            title: 'Weight & Body Tracking Habits',
            color: Colors.orange,
            description: 'Tracks weight measurements and body monitoring',
            keywords: [
              'weight', 'weigh', 'weighing', 'scale', 'body', 'mass',
              'track', 'monitor', 'measure', 'bmi', 'health'
            ],
            examples: [
              '• "Daily weigh-in" → Auto-completes when you record weight',
              '• "Track body weight" → Detects any weight measurement',
              '• "Morning scale check" → Completes on weight entry',
              '• "Monitor health metrics" → Tracks weight recordings'
            ],
            tips: [
              'Any weight measurement counts as completion',
              'Use words like "weight", "weigh", "scale", "body", "track"',
              'Perfect for building consistent weighing habits'
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Pro Tips Section
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Pro Tips for Best Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('✅ Include specific numbers in habit names (e.g., "300 steps", "burn 150 calories")'),
                  const SizedBox(height: 6),
                  const Text('✅ Use clear, descriptive keywords from the categories above'),
                  const SizedBox(height: 6),
                  const Text('✅ Add relevant details in the habit description field'),
                  const SizedBox(height: 6),
                  const Text('✅ Check the Overview tab to see which habits are being tracked'),
                  const SizedBox(height: 6),
                  const Text('✅ Grant health permissions for full functionality'),
                  const SizedBox(height: 6),
                  const Text('✅ Habits work across all categories - not just "Health" category'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Troubleshooting Section
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Troubleshooting',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('❓ Habit not auto-completing? Check if it contains relevant keywords'),
                  const SizedBox(height: 6),
                  const Text('❓ Custom threshold not working? Include numbers in the habit name'),
                  const SizedBox(height: 6),
                  const Text('❓ No health data? Ensure your device is tracking the relevant metrics'),
                  const SizedBox(height: 6),
                  const Text('❓ Water habits not working? You must manually log water in health apps'),
                  const SizedBox(height: 6),
                  const Text('❓ Permissions issues? Check Settings tab and grant health access'),
                  const SizedBox(height: 6),
                  const Text('❓ Still having issues? Try the "Force Sync" button in Settings'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection({
    required IconData icon,
    required String title,
    required Color color,
    required String description,
    required List<String> keywords,
    required List<String> examples,
    required List<String> tips,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            
            // Keywords
            ExpansionTile(
              title: const Text('Trigger Keywords', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: keywords.take(15).map((keyword) => Chip(
                      label: Text(keyword, style: const TextStyle(fontSize: 12)),
                      backgroundColor: color.withValues(alpha: 0.1),
                      side: BorderSide(color: color.withValues(alpha: 0.3)),
                    )).toList(),
                  ),
                ),
                if (keywords.length > 15)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '...and ${keywords.length - 15} more',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
            
            // Examples
            ExpansionTile(
              title: const Text('Examples', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: examples.map((example) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(example, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                  ),
                ),
              ],
            ),
            
            // Tips
            ExpansionTile(
              title: const Text('Tips', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tips.map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text('💡 $tip', style: const TextStyle(fontSize: 13)),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}