import 'package:flutter/material.dart';
import '../../services/achievements_service.dart';
import '../../domain/model/habit.dart';
import 'gamification_widgets.dart';

/// A comprehensive gamification dashboard widget that displays
/// user level, achievements, streaks, and other gamification elements
class GamificationDashboard extends StatefulWidget {
  final List<Habit> habits;
  final bool isCompact;
  final VoidCallback? onAchievementTap;
  final VoidCallback? onLevelTap;

  const GamificationDashboard({
    super.key,
    required this.habits,
    this.isCompact = false,
    this.onAchievementTap,
    this.onLevelTap,
  });

  @override
  State<GamificationDashboard> createState() => _GamificationDashboardState();
}

class _GamificationDashboardState extends State<GamificationDashboard> {
  Map<String, dynamic>? _gamificationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGamificationData();
  }

  @override
  void didUpdateWidget(GamificationDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habits != widget.habits) {
      _loadGamificationData();
    }
  }

  Future<void> _loadGamificationData() async {
    setState(() => _isLoading = true);

    try {
      // Convert habits to the format expected by AchievementsService
      final habitData = widget.habits
          .map((h) => {
                'id': h.id,
                'name': h.name,
                'category': h.category,
                'currentStreak': h.streakInfo.current,
                'longestStreak': h.streakInfo.longest,
                'completionRate': h.completionRate,
                'completions': h.completions
                    .map((c) => {
                          'timestamp': c.millisecondsSinceEpoch,
                          'hour': c.hour,
                        })
                    .toList(),
              })
          .toList();

      final completionData = widget.habits
          .expand((h) => h.completions)
          .map((c) => {
                'timestamp': c.millisecondsSinceEpoch,
                'habitId': widget.habits
                    .firstWhere((h) => h.completions.contains(c))
                    .id,
                'hour': c.hour,
              })
          .toList();

      final data = await AchievementsService.getGamificationStats(
        habits: habitData,
        completions: completionData,
      );

      if (mounted) {
        setState(() {
          _gamificationData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _gamificationData = {
            'level': 1,
            'xp': 0,
            'nextLevelXP': 100,
            'levelProgress': 0.0,
            'achievementsUnlocked': 0,
            'totalAchievements':
                AchievementsService.getAllAchievements().length,
            'rank': 'Novice',
            'totalStreak': 0,
            'maxStreak': 0,
            'perfectDays': 0,
            'completionRate': 0.0,
          };
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = _gamificationData!;

    if (widget.isCompact) {
      return _buildCompactDashboard(data);
    } else {
      return _buildFullDashboard(data);
    }
  }

  Widget _buildCompactDashboard(Map<String, dynamic> data) {
    final level = data['level'] ?? 1;
    final rank = data['rank'] ?? 'Novice';
    final xp = data['xp'] ?? 0;
    final nextLevelXP = data['nextLevelXP'] ?? 100;
    final progress = data['levelProgress'] ?? 0.0;
    final achievementsUnlocked = data['achievementsUnlocked'] ?? 0;
    final maxStreak = data['maxStreak'] ?? 0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GamificationWidgets.buildLevelBadge(
                  level: level,
                  rank: rank,
                  size: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Level $level',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          GamificationWidgets.buildRankDisplay(
                            rank: rank,
                            rankColor: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            showIcon: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      GamificationWidgets.buildXPProgressBar(
                        currentXP: xp,
                        nextLevelXP: nextLevelXP,
                        progress: progress,
                        height: 6,
                        showLabels: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCompactStat(
                    'Achievements',
                    '$achievementsUnlocked',
                    Icons.emoji_events,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactStat(
                    'Best Streak',
                    '$maxStreak',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStat(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullDashboard(Map<String, dynamic> data) {
    final level = data['level'] ?? 1;
    final rank = data['rank'] ?? 'Novice';
    final xp = data['xp'] ?? 0;
    final nextLevelXP = data['nextLevelXP'] ?? 100;
    final progress = data['levelProgress'] ?? 0.0;
    final achievementsUnlocked = data['achievementsUnlocked'] ?? 0;
    final totalAchievements = data['totalAchievements'] ?? 0;
    final totalStreak = data['totalStreak'] ?? 0;
    final maxStreak = data['maxStreak'] ?? 0;
    final perfectDays = data['perfectDays'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Player Level Card
        Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GamificationWidgets.buildLevelBadge(
                      level: level,
                      rank: rank,
                      size: 60,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      textColor: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $level',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GamificationWidgets.buildRankDisplay(
                            rank: rank,
                            rankColor: Colors.white,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$xp XP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GamificationWidgets.buildXPProgressBar(
                  currentXP: xp,
                  nextLevelXP: nextLevelXP,
                  progress: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  progressColor: Colors.white,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Stats Grid
        Row(
          children: [
            Expanded(
              child: GamificationWidgets.buildStatCard(
                title: 'Achievements',
                value: '$achievementsUnlocked/$totalAchievements',
                icon: Icons.emoji_events,
                color: Colors.amber,
                onTap: widget.onAchievementTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GamificationWidgets.buildStatCard(
                title: 'Total Streak',
                value: '$totalStreak',
                icon: Icons.local_fire_department,
                color: Colors.orange,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: GamificationWidgets.buildStatCard(
                title: 'Best Streak',
                value: '$maxStreak',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GamificationWidgets.buildStatCard(
                title: 'Perfect Days',
                value: '$perfectDays',
                icon: Icons.star,
                color: Colors.purple,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Recent Achievements Preview
        FutureBuilder<List<Achievement>>(
          future: AchievementsService.getUnlockedAchievements(),
          builder: (context, snapshot) {
            final achievements = snapshot.data ?? [];
            if (achievements.isEmpty) {
              return const SizedBox.shrink();
            }

            return Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Achievements',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Spacer(),
                        if (widget.onAchievementTap != null)
                          TextButton(
                            onPressed: widget.onAchievementTap,
                            child: const Text('View All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: achievements.take(5).length,
                        itemBuilder: (context, index) {
                          final achievement = achievements[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < achievements.length - 1 ? 12 : 0,
                            ),
                            child: GamificationWidgets.buildAchievementBadge(
                              achievement: achievement,
                              isUnlocked: true,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
