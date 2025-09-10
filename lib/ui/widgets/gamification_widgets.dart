import 'package:flutter/material.dart';
import '../../services/achievements_service.dart';

/// A collection of reusable gamification UI widgets
class GamificationWidgets {
  /// Builds a player level display widget
  static Widget buildLevelBadge({
    required int level,
    required String rank,
    double size = 60,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? Colors.blue).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$level',
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (size > 50)
            Text(
              rank.substring(0, 3).toUpperCase(),
              style: TextStyle(
                color: (textColor ?? Colors.white).withValues(alpha: 0.8),
                fontSize: size * 0.15,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds an XP progress bar
  static Widget buildXPProgressBar({
    required int currentXP,
    required int nextLevelXP,
    required double progress,
    Color? backgroundColor,
    Color? progressColor,
    double height = 8,
    bool showLabels = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabels) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'XP: $currentXP',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                'Next: $nextLevelXP',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey.shade300,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressColor ?? Colors.blue,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
        if (showLabels) ...[
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}% to next level',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds an achievement badge
  static Widget buildAchievementBadge({
    required Achievement achievement,
    required bool isUnlocked,
    VoidCallback? onTap,
    double size = 80,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.amber.shade100 : Colors.grey.shade200,
          shape: BoxShape.circle,
          border: Border.all(
            color: isUnlocked ? Colors.amber : Colors.grey.shade400,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement.icon,
              style: TextStyle(
                fontSize: size * 0.3,
                color: isUnlocked ? null : Colors.grey.shade400,
              ),
            ),
            if (size > 60) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: (size * 0.08)
                        .clamp(8.0, 12.0), // Better font size calculation
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.black87 : Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a streak flame indicator
  static Widget buildStreakFlame({
    required int streakCount,
    double size = 40,
    Color? flameColor,
  }) {
    Color getFlameColor() {
      if (flameColor != null) return flameColor;
      if (streakCount >= 30) return Colors.purple;
      if (streakCount >= 14) return Colors.red;
      if (streakCount >= 7) return Colors.orange;
      if (streakCount >= 3) return Colors.amber;
      return Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(size * 0.1),
      decoration: BoxDecoration(
        color: getFlameColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: getFlameColor(),
            size: size * 0.6,
          ),
          SizedBox(width: size * 0.1),
          Text(
            '$streakCount',
            style: TextStyle(
              color: getFlameColor(),
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a gamification stat card
  static Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    double? width,
    double? height,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a rank display widget
  static Widget buildRankDisplay({
    required String rank,
    required Color rankColor,
    double fontSize = 16,
    bool showIcon = true,
  }) {
    IconData getRankIcon() {
      switch (rank.toLowerCase()) {
        case 'grandmaster':
          return Icons.diamond;
        case 'master':
          return Icons.star;
        case 'expert':
          return Icons.verified;
        case 'advanced':
          return Icons.trending_up;
        case 'intermediate':
          return Icons.person;
        case 'beginner':
          return Icons.child_care;
        default:
          return Icons.emoji_events;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rankColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              getRankIcon(),
              color: rankColor,
              size: fontSize * 1.2,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            rank,
            style: TextStyle(
              color: rankColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows an achievement unlock dialog
  static void showAchievementDialog({
    required BuildContext context,
    required Achievement achievement,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber.shade50,
        title: Row(
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    achievement.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(achievement.description),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  /// Shows a level up dialog
  static void showLevelUpDialog({
    required BuildContext context,
    required int newLevel,
    required String newRank,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade50,
        title: Row(
          children: [
            const Icon(
              Icons.celebration,
              size: 32,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Level Up!',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Level $newLevel',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Congratulations! You\'ve reached level $newLevel!'),
            const SizedBox(height: 16),
            buildRankDisplay(
              rank: newRank,
              rankColor: Colors.blue,
              fontSize: 18,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
