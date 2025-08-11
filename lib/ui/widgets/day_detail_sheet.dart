import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/model/habit.dart';

class DayDetailSheet extends StatefulWidget {
  final DateTime selectedDay;
  final List<Habit> habits;
  final Function(Habit) onHabitToggle;

  const DayDetailSheet({
    super.key,
    required this.selectedDay,
    required this.habits,
    required this.onHabitToggle,
  });

  @override
  State<DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends State<DayDetailSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.green;
      case 'fitness':
        return Colors.orange;
      case 'productivity':
        return Colors.blue;
      case 'learning':
        return Colors.purple;
      case 'personal':
        return Colors.teal;
      case 'social':
        return Colors.pink;
      case 'finance':
        return Colors.indigo;
      case 'mindfulness':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.health_and_safety;
      case 'fitness':
        return Icons.fitness_center;
      case 'productivity':
        return Icons.work;
      case 'learning':
        return Icons.school;
      case 'personal':
        return Icons.person;
      case 'social':
        return Icons.people;
      case 'finance':
        return Icons.attach_money;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.track_changes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.habits
        .where((habit) => _isHabitCompletedOnDate(habit, widget.selectedDay))
        .length;
    final totalCount = widget.habits.length;
    final isToday = _isSameDay(widget.selectedDay, DateTime.now());
    final isPastDay = widget.selectedDay.isBefore(DateTime.now()) && !isToday;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 300),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, MMMM d').format(widget.selectedDay),
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    if (isToday) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Today',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    if (isPastDay) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Past',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      DateFormat('yyyy').format(widget.selectedDay),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      if (totalCount > 0) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getProgressColor(completedCount, totalCount).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _getProgressColor(completedCount, totalCount).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircularProgressIndicator(
                                value: totalCount > 0 ? completedCount / totalCount : 0,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getProgressColor(completedCount, totalCount),
                                ),
                                strokeWidth: 6,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$completedCount of $totalCount habits completed',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _getProgressMessage(completedCount, totalCount),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Habits list
                Expanded(
                  child: widget.habits.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: widget.habits.length,
                          itemBuilder: (context, index) {
                            final habit = widget.habits[index];
                            final isCompleted = _isHabitCompletedOnDate(habit, widget.selectedDay);
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildHabitCard(habit, isCompleted),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.free_breakfast_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No habits scheduled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free day!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Habit habit, bool isCompleted) {
    final categoryColor = _getCategoryColor(habit.category);
    final categoryIcon = _getCategoryIcon(habit.category);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => widget.onHabitToggle(habit),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Category icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Habit details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted 
                            ? Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6)
                            : null,
                      ),
                    ),
                    if (habit.description != null && habit.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        habit.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            habit.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: categoryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            habit.frequency.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Completion checkbox
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.grey.shade400,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(int completed, int total) {
    if (total == 0) return Colors.grey;
    final percentage = completed / total;
    if (percentage == 1.0) return Colors.green;
    if (percentage >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _getProgressMessage(int completed, int total) {
    if (total == 0) return 'No habits scheduled';
    final percentage = completed / total;
    if (percentage == 1.0) return 'All habits completed! 🎉';
    if (percentage >= 0.75) return 'Almost there! Keep going! 💪';
    if (percentage >= 0.5) return 'Good progress! 👍';
    if (percentage > 0) return 'Getting started! 🌱';
    return 'Ready to begin? 🚀';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}