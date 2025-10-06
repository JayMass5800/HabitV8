import 'habit_isar.dart';

extension HabitComputedProperties on Habit {
  /// Get completion rate for the last 30 days
  double get completionRate => getCompletionRateForDays(30);
  
  /// Get completion rate for specific number of days
  double getCompletionRateForDays(int days) {
    if (completions.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    
    final recentCompletions = completions.where((completion) {
      return completion.isAfter(startDate);
    }).length;
    
    return (recentCompletions / days * 100).clamp(0.0, 100.0);
  }
  
  /// Check if habit is completed today
  bool get isCompletedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return completions.any((completion) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDay.isAtSameMomentAs(today);
    });
  }
  
  /// Check if habit was completed on a specific date
  bool isCompletedOnDate(DateTime date) {
    final targetDay = DateTime(date.year, date.month, date.day);
    
    return completions.any((completion) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDay.isAtSameMomentAs(targetDay);
    });
  }
  
  /// Get the display name for the frequency
  String get frequencyDisplayName {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'Hourly';
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.yearly:
        return 'Yearly';
      case HabitFrequency.single:
        return 'One time';
    }
  }
  
  /// Get completion count for today
  int get todayCompletionCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return completions.where((completion) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDay.isAtSameMomentAs(today);
    }).length;
  }
  
  /// Check if habit is completed for current period based on frequency
  bool get isCompletedForCurrentPeriod {
    final now = DateTime.now();
    
    switch (frequency) {
      case HabitFrequency.hourly:
        // Check if completed in the current hour
        return completions.any((completion) {
          return completion.year == now.year &&
              completion.month == now.month &&
              completion.day == now.day &&
              completion.hour == now.hour;
        });
        
      case HabitFrequency.daily:
        return isCompletedToday;
        
      case HabitFrequency.weekly:
        // Check if completed in current week
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return completions.any((completion) {
          return completion.isAfter(weekStart) &&
              completion.isBefore(weekEnd.add(const Duration(days: 1)));
        });
        
      case HabitFrequency.monthly:
        // Check if completed in current month
        return completions.any((completion) {
          return completion.year == now.year &&
              completion.month == now.month;
        });
        
      case HabitFrequency.yearly:
        // Check if completed in current year
        return completions.any((completion) {
          return completion.year == now.year;
        });
        
      case HabitFrequency.single:
        return completions.isNotEmpty;
    }
  }
  
  /// Calculate current streak
  int calculateCurrentStreak() {
    if (completions.isEmpty) return 0;
    
    final sortedCompletions = List<DateTime>.from(completions)
      ..sort((a, b) => b.compareTo(a)); // Most recent first
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int streak = 0;
    DateTime checkDate = today;
    
    for (final completion in sortedCompletions) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      
      if (completionDay.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (completionDay.isBefore(checkDate)) {
        break;
      }
    }
    
    return streak;
  }
  
  /// Get total completion count
  int get totalCompletions => completions.length;
  
  /// Get completions for a specific month
  List<DateTime> getCompletionsForMonth(int year, int month) {
    return completions.where((completion) {
      return completion.year == year && completion.month == month;
    }).toList();
  }
  
  /// Get completions for a specific week
  List<DateTime> getCompletionsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 7));
    return completions.where((completion) {
      return completion.isAfter(weekStart) && 
             completion.isBefore(weekEnd);
    }).toList();
  }
}
