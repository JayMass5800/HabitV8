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
    _tabController = TabController(length: 4, vsync: this);
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
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
            Tab(icon: Icon(Icons.insights), text: 'Insights'),
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
                        leading: Icon(
                          Icons.lightbulb,
                          color: insight.confidence > 0.7 ? Colors.green : Colors.orange,
                        ),
                        title: Text(insight.habitName),
                        subtitle: Text(insight.message),
                        trailing: Text('${(insight.confidence * 100).round()}%'),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Optimization recommendations
                  if (report.optimizationRecommendations.isNotEmpty) ...[
                    _buildInsightsSection(
                      'Optimization Recommendations',
                      Icons.tune,
                      report.optimizationRecommendations.map((rec) => ExpansionTile(
                        leading: const Icon(Icons.trending_up, color: Colors.blue),
                        title: Text(rec.habitName),
                        subtitle: Text('${(rec.optimizationPotential * 100).round()}% improvement potential'),
                        children: rec.recommendations.map((recommendation) => 
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.arrow_right, size: 16),
                                const SizedBox(width: 8),
                                Expanded(child: Text(recommendation)),
                              ],
                            ),
                          ),
                        ).toList(),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Benchmark comparisons
                  if (report.benchmarkComparisons.isNotEmpty) ...[
                    _buildBenchmarkSection(report.benchmarkComparisons),
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
        if (report.habitAnalyses.isNotEmpty) ...[
          const Text(
            'Habit Analysis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...report.habitAnalyses.map((analysis) => Card(
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
                  if (analysis.strongestHealthMetric != null)
                    Text(
                      'Strongest correlation: ${analysis.strongestHealthMetric}',
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

  Widget _buildBenchmarkSection(Map<String, BenchmarkComparison> benchmarks) {
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
              color: color.withOpacity(0.8),
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
}