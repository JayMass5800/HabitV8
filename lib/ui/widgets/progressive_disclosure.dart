import 'package:flutter/material.dart';
import 'smooth_transitions.dart';

/// Widget that implements progressive disclosure pattern for complex features
class ProgressiveDisclosure extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget summary;
  final Widget details;
  final bool initiallyExpanded;
  final IconData? expandIcon;
  final IconData? collapseIcon;
  final Color? headerColor;
  final EdgeInsetsGeometry? padding;
  final Duration animationDuration;
  final VoidCallback? onExpansionChanged;

  const ProgressiveDisclosure({
    super.key,
    required this.title,
    this.subtitle,
    required this.summary,
    required this.details,
    this.initiallyExpanded = false,
    this.expandIcon = Icons.expand_more,
    this.collapseIcon = Icons.expand_less,
    this.headerColor,
    this.padding = const EdgeInsets.all(16),
    this.animationDuration = const Duration(milliseconds: 300),
    this.onExpansionChanged,
  });

  @override
  State<ProgressiveDisclosure> createState() => _ProgressiveDisclosureState();
}

class _ProgressiveDisclosureState extends State<ProgressiveDisclosure>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onExpansionChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with summary
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.headerColor?.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        widget.summary,
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: widget.animationDuration,
                    child: Icon(
                      _isExpanded ? widget.collapseIcon : widget.expandIcon,
                      color: widget.headerColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable details section
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: widget.padding,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  SmoothTransitions.fadeTransition(
                    show: _isExpanded,
                    child: widget.details,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Specialized progressive disclosure for habit statistics
class HabitStatsDisclosure extends StatelessWidget {
  final String habitName;
  final int currentStreak;
  final double completionRate;
  final List<DateTime> recentCompletions;
  final Map<String, dynamic>? detailedStats;

  const HabitStatsDisclosure({
    super.key,
    required this.habitName,
    required this.currentStreak,
    required this.completionRate,
    required this.recentCompletions,
    this.detailedStats,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressiveDisclosure(
      title: habitName,
      subtitle: 'Tap to view detailed statistics',
      summary: _buildSummary(context),
      details: _buildDetails(context),
      headerColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Row(
      children: [
        _buildStatChip(
          context,
          'Streak',
          '$currentStreak days',
          Icons.local_fire_department,
          Colors.orange,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          context,
          'Rate',
          '${(completionRate * 100).toInt()}%',
          Icons.trending_up,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Statistics',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (detailedStats != null) ...[
          _buildDetailRow('Total Completions', '${detailedStats!['totalCompletions'] ?? 0}'),
          _buildDetailRow('Best Streak', '${detailedStats!['bestStreak'] ?? 0} days'),
          _buildDetailRow('Average per Week', '${detailedStats!['averagePerWeek'] ?? 0.0}'),
          _buildDetailRow('Last Completed', detailedStats!['lastCompleted'] ?? 'Never'),
        ] else ...[
          _buildDetailRow('Total Completions', '${recentCompletions.length}'),
          _buildDetailRow('Current Streak', '$currentStreak days'),
          _buildDetailRow('Completion Rate', '${(completionRate * 100).toInt()}%'),
          if (recentCompletions.isNotEmpty)
            _buildDetailRow('Last Completed', _formatDate(recentCompletions.last)),
        ],
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Progressive disclosure for complex settings
class SettingsDisclosure extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> basicSettings;
  final List<Widget> advancedSettings;
  final IconData? icon;

  const SettingsDisclosure({
    super.key,
    required this.title,
    required this.description,
    required this.basicSettings,
    required this.advancedSettings,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressiveDisclosure(
      title: title,
      subtitle: description,
      summary: Column(
        children: basicSettings,
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Settings',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...advancedSettings,
        ],
      ),
      headerColor: Theme.of(context).primaryColor,
    );
  }
}

/// Progressive disclosure for feature explanations
class FeatureExplanationDisclosure extends StatelessWidget {
  final String featureName;
  final String shortDescription;
  final Widget detailedExplanation;
  final List<Widget>? examples;
  final IconData? icon;

  const FeatureExplanationDisclosure({
    super.key,
    required this.featureName,
    required this.shortDescription,
    required this.detailedExplanation,
    this.examples,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressiveDisclosure(
      title: featureName,
      subtitle: 'Tap to learn more',
      summary: Text(
        shortDescription,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          detailedExplanation,
          if (examples != null && examples!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Examples',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...examples!,
          ],
        ],
      ),
      headerColor: Theme.of(context).primaryColor,
    );
  }
}