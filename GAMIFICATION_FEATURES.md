# Gamification Features Documentation

## Overview

HabitV8 includes a comprehensive gamification system to motivate users through achievements, levels, experience points (XP), and streaks. The gamification tab in the Insights screen provides a dedicated view for all gamification elements.

## Components

### 1. Insights Screen Gamification Tab

**Location**: `lib/ui/screens/insights_screen.dart`

The insights screen now includes three tabs:
- **Analytics**: Performance metrics and completion rates
- **AI Insights**: Smart recommendations and patterns
- **Gamification**: Achievement system, levels, and rewards

#### Features:
- Player level and XP display with progress bar
- Achievement grid showing unlocked and available achievements
- Performance statistics (streaks, perfect days, completion rates)
- Level progression information

### 2. Gamification Widgets

**Location**: `lib/ui/widgets/gamification_widgets.dart`

Reusable widgets for displaying gamification elements:

#### `GamificationWidgets.buildLevelBadge()`
- Displays user level in a circular badge
- Customizable size, colors, and rank display
- Usage: `GamificationWidgets.buildLevelBadge(level: 5, rank: 'Expert')`

#### `GamificationWidgets.buildXPProgressBar()`
- Shows XP progress toward next level
- Includes current XP, target XP, and percentage
- Usage: `GamificationWidgets.buildXPProgressBar(currentXP: 150, nextLevelXP: 200, progress: 0.75)`

#### `GamificationWidgets.buildAchievementBadge()`
- Displays achievement badges with icons
- Shows locked/unlocked states
- Supports tap interactions
- Usage: `GamificationWidgets.buildAchievementBadge(achievement: achievement, isUnlocked: true)`

#### `GamificationWidgets.buildStreakFlame()`
- Flame indicator for streak counts
- Color-coded based on streak length
- Usage: `GamificationWidgets.buildStreakFlame(streakCount: 14)`

#### `GamificationWidgets.buildStatCard()`
- Generic stat display card
- Customizable colors and icons
- Usage: `GamificationWidgets.buildStatCard(title: 'Total XP', value: '1250', icon: Icons.star, color: Colors.blue)`

#### `GamificationWidgets.showAchievementDialog()`
- Celebratory dialog for new achievements
- Shows achievement details and XP reward
- Usage: `GamificationWidgets.showAchievementDialog(context: context, achievement: achievement)`

#### `GamificationWidgets.showLevelUpDialog()`
- Celebration dialog for level increases
- Displays new level and rank
- Usage: `GamificationWidgets.showLevelUpDialog(context: context, newLevel: 6, newRank: 'Expert')`

### 3. Gamification Dashboard

**Location**: `lib/ui/widgets/gamification_dashboard.dart`

Comprehensive dashboard widget that can be embedded anywhere in the app:

#### Compact Mode
- Minimal space footprint
- Shows level, rank, achievements count, and best streak
- Perfect for home screen or sidebar usage

#### Full Mode
- Complete gamification overview
- Player level card with XP progress
- Stats grid with achievements, streaks, and perfect days
- Recent achievements preview

#### Usage:
```dart
// Compact dashboard
GamificationDashboard(
  habits: userHabits,
  isCompact: true,
  onAchievementTap: () => navigateToAchievements(),
)

// Full dashboard
GamificationDashboard(
  habits: userHabits,
  isCompact: false,
  onAchievementTap: () => navigateToAchievements(),
  onLevelTap: () => showLevelDetails(),
)
```

## Achievement System

### Achievement Types
- **Streak Achievements**: Based on consecutive habit completions
- **Perfect Days**: Completing all habits on specific days
- **Habit Count**: Creating and maintaining multiple habits
- **Total Completions**: Cumulative habit completions
- **Category Specific**: Achievements for specific habit categories
- **Time Specific**: Completions at specific times of day
- **Comeback**: Restarting habits after breaks

### XP and Leveling
- XP is awarded for:
  - Completing habits (variable XP based on difficulty)
  - Unlocking achievements (bonus XP)
  - Maintaining streaks (bonus XP)
- Level calculation: `level = floor(sqrt(xp / 100)) + 1`
- XP required for level N: `xp = (level - 1)^2 * 100`

### Ranks
Based on level and achievement count:
- **Novice**: Starting rank
- **Beginner**: Level 3+
- **Intermediate**: Level 5+ with 2+ achievements
- **Advanced**: Level 7+ with 4+ achievements
- **Expert**: Level 10+ with 6+ achievements
- **Master**: Level 15+ with 8+ achievements
- **Grandmaster**: Level 20+ with 10+ achievements

## Integration Points

### Services Used
- `AchievementsService`: Core gamification logic and data management
- `InsightsService`: Analytics and performance calculations
- `HabitService`: Habit data and completion tracking

### Data Flow
1. Habits and completions are fetched from the database
2. Data is converted to the format expected by `AchievementsService`
3. Gamification stats are calculated and cached
4. UI widgets display the processed data with animations

## Customization

### Adding New Achievement Types
1. Update `AchievementType` enum in `achievements_service.dart`
2. Add achievement logic to `checkForNewAchievements()` method
3. Update progress calculation in `getAchievementProgress()` method

### Modifying XP Rewards
- Edit individual achievement XP values in `getAllAchievements()`
- Modify level calculation formula in `_calculateLevel()`
- Adjust XP requirements in `_getXPRequiredForLevel()`

### Custom Widgets
Use the base `GamificationWidgets` class methods to create custom gamification displays:
```dart
class CustomGamificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          GamificationWidgets.buildLevelBadge(/* ... */),
          GamificationWidgets.buildXPProgressBar(/* ... */),
          // Add custom elements
        ],
      ),
    );
  }
}
```

## Performance Considerations

- Gamification data is calculated asynchronously to avoid blocking UI
- Results are cached and only recalculated when habit data changes
- Heavy computations are performed in background isolates where possible
- Achievement checks are optimized to avoid redundant calculations

## Future Enhancements

Potential additions to the gamification system:
- Social features (leaderboards, friend comparisons)
- Seasonal challenges and limited-time achievements
- Customizable avatar system
- Badge collection and showcase
- Weekly/monthly gamification challenges
- Integration with device fitness data
- Habit difficulty multipliers for XP calculation
