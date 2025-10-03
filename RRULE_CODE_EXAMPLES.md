# 🚀 RRule Refactoring - Code Examples & Templates

This document provides ready-to-use code templates for implementing the RRule refactoring.

---

## 1. Core RRuleService Implementation

### File: `lib/services/rrule_service.dart`

```dart
import 'package:rrule/rrule.dart';
import '../domain/model/habit.dart';
import 'app_logger.dart';

/// Centralized service for all RRule (Recurrence Rule) operations.
/// Handles conversion, generation, parsing, and validation of RRule patterns.
class RRuleService {
  // Cache for parsed RRule objects to improve performance
  static final Map<String, RecurrenceRule> _rruleCache = {};

  /// Convert a legacy Habit to an RRule string
  static String? convertLegacyToRRule(Habit habit) {
    try {
      switch (habit.frequency) {
        case HabitFrequency.hourly:
          return 'FREQ=HOURLY';

        case HabitFrequency.daily:
          return 'FREQ=DAILY';

        case HabitFrequency.weekly:
          if (habit.selectedWeekdays.isEmpty) {
            return 'FREQ=WEEKLY';
          }
          final days = habit.selectedWeekdays
              .map((day) => _weekdayToRRuleDay(day))
              .join(',');
          return 'FREQ=WEEKLY;BYDAY=$days';

        case HabitFrequency.monthly:
          if (habit.selectedMonthDays.isEmpty) {
            return 'FREQ=MONTHLY';
          }
          final days = habit.selectedMonthDays.join(',');
          return 'FREQ=MONTHLY;BYMONTHDAY=$days';

        case HabitFrequency.yearly:
          return _convertYearlyDates(habit.selectedYearlyDates);

        case HabitFrequency.single:
          // Single events don't have recurrence
          return null;
      }
    } catch (e) {
      AppLogger.error('Failed to convert legacy habit to RRule: $e');
      return null;
    }
  }

  /// Convert a weekday index (0=Sunday, 1=Monday, etc.) to RRule day code
  static String _weekdayToRRuleDay(int weekday) {
    const days = {
      0: 'SU', // Sunday
      1: 'MO', // Monday
      2: 'TU', // Tuesday
      3: 'WE', // Wednesday
      4: 'TH', // Thursday
      5: 'FR', // Friday
      6: 'SA', // Saturday
      7: 'SU', // Sunday (alternative)
    };
    return days[weekday] ?? 'MO';
  }

  /// Convert yearly dates (format: "yyyy-MM-dd") to RRule
  static String? _convertYearlyDates(List<String> yearlyDates) {
    if (yearlyDates.isEmpty) {
      return 'FREQ=YEARLY';
    }

    try {
      // Parse the first date to get month and day
      final date = DateTime.parse(yearlyDates.first);
      return 'FREQ=YEARLY;BYMONTH=${date.month};BYMONTHDAY=${date.day}';
    } catch (e) {
      AppLogger.error('Failed to parse yearly date: $e');
      return 'FREQ=YEARLY';
    }
  }

  /// Create an RRule string from UI components
  static String createRRule({
    required Frequency frequency,
    int interval = 1,
    List<ByWeekDayEntry>? byWeekDays,
    List<int>? byMonthDays,
    int? bySetPos,
    DateTime? until,
    int? count,
  }) {
    try {
      final rule = RecurrenceRule(
        frequency: frequency,
        interval: interval,
        byWeekDays: byWeekDays?.toSet(),
        byMonthDays: byMonthDays?.toSet(),
        bySetPositions: bySetPos != null ? {bySetPos} : null,
        until: until,
        count: count,
      );

      return rule.toString();
    } catch (e) {
      AppLogger.error('Failed to create RRule: $e');
      rethrow;
    }
  }

  /// Get a parsed RecurrenceRule object (with caching)
  static RecurrenceRule? parseRRule(String rruleString, DateTime startDate) {
    final cacheKey = '$rruleString|${startDate.toIso8601String()}';

    if (_rruleCache.containsKey(cacheKey)) {
      return _rruleCache[cacheKey];
    }

    try {
      final rule = RecurrenceRule.fromString(
        rruleString,
        dtStart: startDate,
      );
      _rruleCache[cacheKey] = rule;
      return rule;
    } catch (e) {
      AppLogger.error('Failed to parse RRule: $e');
      return null;
    }
  }

  /// Get list of occurrence dates within a range
  static List<DateTime> getOccurrences({
    required String rruleString,
    required DateTime startDate,
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) {
    try {
      final rule = parseRRule(rruleString, startDate);
      if (rule == null) return [];

      final occurrences = rule.between(rangeStart, rangeEnd);
      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get occurrences: $e');
      return [];
    }
  }

  /// Check if habit is due on a specific date
  static bool isDueOnDate({
    required String rruleString,
    required DateTime startDate,
    required DateTime checkDate,
  }) {
    try {
      // Create a date range for the entire day
      final dayStart = DateTime(checkDate.year, checkDate.month, checkDate.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final occurrences = getOccurrences(
        rruleString: rruleString,
        startDate: startDate,
        rangeStart: dayStart,
        rangeEnd: dayEnd,
      );

      return occurrences.isNotEmpty;
    } catch (e) {
      AppLogger.error('Failed to check if due on date: $e');
      return false;
    }
  }

  /// Get a human-readable summary of the RRule
  static String getRRuleSummary(String rruleString) {
    try {
      final rule = RecurrenceRule.fromString(rruleString);
      
      // Build summary based on frequency
      String summary = _getFrequencySummary(rule);
      
      // Add interval if not 1
      if (rule.interval > 1) {
        summary = summary.replaceFirst(
          'every',
          'every ${rule.interval}',
        );
      }

      // Add day-specific info
      if (rule.byWeekDays?.isNotEmpty ?? false) {
        final days = rule.byWeekDays!
            .map((day) => _formatWeekDay(day))
            .join(', ');
        summary += ' on $days';
      }

      if (rule.byMonthDays?.isNotEmpty ?? false) {
        final days = rule.byMonthDays!.join(', ');
        summary += ' on day(s) $days';
      }

      return summary;
    } catch (e) {
      AppLogger.error('Failed to get RRule summary: $e');
      return 'Custom schedule';
    }
  }

  static String _getFrequencySummary(RecurrenceRule rule) {
    switch (rule.frequency) {
      case Frequency.hourly:
        return 'Every hour';
      case Frequency.daily:
        return 'Every day';
      case Frequency.weekly:
        return 'Every week';
      case Frequency.monthly:
        return 'Every month';
      case Frequency.yearly:
        return 'Every year';
      default:
        return 'Custom';
    }
  }

  static String _formatWeekDay(ByWeekDayEntry day) {
    const dayNames = {
      DateTime.monday: 'Monday',
      DateTime.tuesday: 'Tuesday',
      DateTime.wednesday: 'Wednesday',
      DateTime.thursday: 'Thursday',
      DateTime.friday: 'Friday',
      DateTime.saturday: 'Saturday',
      DateTime.sunday: 'Sunday',
    };

    final dayName = dayNames[day.day] ?? 'Unknown';
    
    if (day.occurrence != 0) {
      final ordinal = _getOrdinal(day.occurrence);
      return '$ordinal $dayName';
    }
    
    return dayName;
  }

  static String _getOrdinal(int n) {
    if (n == -1) return 'Last';
    if (n == 1) return 'First';
    if (n == 2) return 'Second';
    if (n == 3) return 'Third';
    if (n == 4) return 'Fourth';
    return '${n}th';
  }

  /// Validate an RRule string
  static bool isValidRRule(String rruleString) {
    try {
      RecurrenceRule.fromString(rruleString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear the cache (call when habits are modified)
  static void clearCache() {
    _rruleCache.clear();
  }

  /// Get next N occurrences
  static List<DateTime> getNextOccurrences({
    required String rruleString,
    required DateTime startDate,
    required int count,
  }) {
    try {
      final rule = parseRRule(rruleString, startDate);
      if (rule == null) return [];

      final now = DateTime.now();
      final occurrences = rule.getAllInstances(start: now).take(count).toList();
      return occurrences;
    } catch (e) {
      AppLogger.error('Failed to get next occurrences: $e');
      return [];
    }
  }
}
```

---

## 2. Updated Habit Model

### File: `lib/domain/model/habit.dart` (Additions)

```dart
// Add these fields to the existing Habit class

  // ==================== NEW RRULE FIELDS ====================
  
  /// RRule string defining the recurrence pattern
  /// Example: "FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR"
  @HiveField(28)
  String? rruleString;

  /// Start date for the RRule (DTSTART in iCalendar)
  @HiveField(29)
  DateTime? dtStart;

  /// Flag indicating whether this habit uses the RRule system
  /// (vs. legacy frequency system)
  @HiveField(30)
  bool usesRRule = false;

  // ==================== HELPER METHODS ====================

  /// Get or create the RRule string for this habit
  /// Performs lazy migration from legacy format if needed
  String? getOrCreateRRule() {
    // If already using RRule, return it
    if (usesRRule && rruleString != null) {
      return rruleString;
    }

    // Lazy migration: convert from legacy format
    if (!usesRRule) {
      rruleString = RRuleService.convertLegacyToRRule(this);
      dtStart = dtStart ?? createdAt;
      usesRRule = true;
      
      // Save the updated habit
      save();
      
      AppLogger.info('Migrated habit "${name}" to RRule: $rruleString');
    }

    return rruleString;
  }

  /// Check if this habit is RRule-based
  bool isRRuleBased() {
    return usesRRule && rruleString != null;
  }

  /// Get the RecurrenceRule object for this habit
  RecurrenceRule? getRecurrenceRule() {
    if (!isRRuleBased()) return null;
    
    return RRuleService.parseRRule(
      rruleString!,
      dtStart ?? createdAt,
    );
  }

  /// Get human-readable schedule summary
  String getScheduleSummary() {
    if (isRRuleBased()) {
      return RRuleService.getRRuleSummary(rruleString!);
    } else {
      // Legacy summary
      return _getLegacyScheduleSummary();
    }
  }

  String _getLegacyScheduleSummary() {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'Every hour';
      case HabitFrequency.daily:
        return 'Every day';
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

  /// Check if habit is due on a specific date
  bool isDueOnDate(DateTime date) {
    if (isRRuleBased()) {
      return RRuleService.isDueOnDate(
        rruleString: rruleString!,
        startDate: dtStart ?? createdAt,
        checkDate: date,
      );
    } else {
      // Use legacy logic
      return _isLegacyDueOnDate(date);
    }
  }

  bool _isLegacyDueOnDate(DateTime date) {
    // ... existing legacy logic ...
    // (Keep current implementation for backward compatibility)
    return false; // Placeholder
  }
```

---

## 3. RRule Builder Widget

### File: `lib/ui/widgets/rrule_builder_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import '../../services/rrule_service.dart';

class RRuleBuilderWidget extends StatefulWidget {
  final String? initialRRule;
  final DateTime? initialStartDate;
  final Function(String rrule, DateTime startDate) onRRuleChanged;

  const RRuleBuilderWidget({
    Key? key,
    this.initialRRule,
    this.initialStartDate,
    required this.onRRuleChanged,
  }) : super(key: key);

  @override
  State<RRuleBuilderWidget> createState() => _RRuleBuilderWidgetState();
}

class _RRuleBuilderWidgetState extends State<RRuleBuilderWidget> {
  late Frequency _frequency;
  late int _interval;
  late Set<int> _selectedWeekdays;
  late Set<int> _selectedMonthDays;
  late DateTime _startDate;
  
  // For monthly "Nth weekday" pattern
  int? _monthlySetPos;
  int? _monthlyWeekday;

  @override
  void initState() {
    super.initState();
    _frequency = Frequency.daily;
    _interval = 1;
    _selectedWeekdays = {};
    _selectedMonthDays = {};
    _startDate = widget.initialStartDate ?? DateTime.now();

    // Parse initial RRule if provided
    if (widget.initialRRule != null) {
      _parseInitialRRule();
    }
  }

  void _parseInitialRRule() {
    try {
      final rule = RecurrenceRule.fromString(widget.initialRRule!);
      setState(() {
        _frequency = rule.frequency;
        _interval = rule.interval;
        
        if (rule.byWeekDays != null) {
          _selectedWeekdays = rule.byWeekDays!.map((e) => e.day).toSet();
        }
        
        if (rule.byMonthDays != null) {
          _selectedMonthDays = rule.byMonthDays!;
        }
      });
    } catch (e) {
      // Invalid RRule, use defaults
    }
  }

  void _updateRRule() {
    try {
      final rrule = RRuleService.createRRule(
        frequency: _frequency,
        interval: _interval,
        byWeekDays: _selectedWeekdays.isEmpty
            ? null
            : _selectedWeekdays.map((day) => ByWeekDayEntry(day)).toList(),
        byMonthDays: _selectedMonthDays.isEmpty 
            ? null 
            : _selectedMonthDays.toList(),
      );

      widget.onRRuleChanged(rrule, _startDate);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Start Date Picker
        _buildStartDatePicker(),
        
        const SizedBox(height: 16),
        
        // Frequency Selector
        _buildFrequencySelector(),
        
        const SizedBox(height: 16),
        
        // Interval Selector
        _buildIntervalSelector(),
        
        const SizedBox(height: 16),
        
        // Frequency-specific options
        _buildFrequencySpecificOptions(),
        
        const SizedBox(height: 16),
        
        // Preview
        _buildPreview(),
      ],
    );
  }

  Widget _buildStartDatePicker() {
    return ListTile(
      title: const Text('Start Date'),
      subtitle: Text(_startDate.toString().split(' ')[0]),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _startDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() {
            _startDate = picked;
          });
          _updateRRule();
        }
      },
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildFrequencyChip('Daily', Frequency.daily),
            _buildFrequencyChip('Weekly', Frequency.weekly),
            _buildFrequencyChip('Monthly', Frequency.monthly),
            _buildFrequencyChip('Yearly', Frequency.yearly),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyChip(String label, Frequency frequency) {
    return ChoiceChip(
      label: Text(label),
      selected: _frequency == frequency,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _frequency = frequency;
            // Clear frequency-specific selections
            _selectedWeekdays.clear();
            _selectedMonthDays.clear();
          });
          _updateRRule();
        }
      },
    );
  }

  Widget _buildIntervalSelector() {
    return Row(
      children: [
        const Text('Repeat every'),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            controller: TextEditingController(text: _interval.toString()),
            onChanged: (value) {
              final interval = int.tryParse(value);
              if (interval != null && interval > 0) {
                setState(() {
                  _interval = interval;
                });
                _updateRRule();
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(_getFrequencyLabel()),
      ],
    );
  }

  String _getFrequencyLabel() {
    switch (_frequency) {
      case Frequency.daily:
        return _interval == 1 ? 'day' : 'days';
      case Frequency.weekly:
        return _interval == 1 ? 'week' : 'weeks';
      case Frequency.monthly:
        return _interval == 1 ? 'month' : 'months';
      case Frequency.yearly:
        return _interval == 1 ? 'year' : 'years';
      default:
        return 'units';
    }
  }

  Widget _buildFrequencySpecificOptions() {
    switch (_frequency) {
      case Frequency.weekly:
        return _buildWeekdaySelector();
      case Frequency.monthly:
        return _buildMonthDaySelector();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWeekdaySelector() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const dayValues = [
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
      DateTime.saturday,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('On days:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final isSelected = _selectedWeekdays.contains(dayValues[index]);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.remove(dayValues[index]);
                  } else {
                    _selectedWeekdays.add(dayValues[index]);
                  }
                });
                _updateRRule();
              },
              child: CircleAvatar(
                backgroundColor: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                child: Text(
                  days[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMonthDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('On day(s):', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(31, (index) {
            final day = index + 1;
            final isSelected = _selectedMonthDays.contains(day);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedMonthDays.remove(day);
                  } else {
                    _selectedMonthDays.add(day);
                  }
                });
                _updateRRule();
              },
              child: CircleAvatar(
                backgroundColor: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                radius: 16,
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    final rrule = RRuleService.createRRule(
      frequency: _frequency,
      interval: _interval,
      byWeekDays: _selectedWeekdays.isEmpty
          ? null
          : _selectedWeekdays.map((day) => ByWeekDayEntry(day)).toList(),
      byMonthDays: _selectedMonthDays.isEmpty 
          ? null 
          : _selectedMonthDays.toList(),
    );

    final summary = RRuleService.getRRuleSummary(rrule);
    final nextOccurrences = RRuleService.getNextOccurrences(
      rruleString: rrule,
      startDate: _startDate,
      count: 5,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(summary),
            const SizedBox(height: 12),
            const Text(
              'Next occurrences:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...nextOccurrences.map((date) => Text(
              '• ${date.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 12),
            )),
          ],
        ),
      ),
    );
  }
}
```

---

## 4. Service Update Example

### File: `lib/services/calendar_service.dart` (Update)

```dart
// BEFORE (Old implementation with switch statement)
static bool isHabitDueOnDate(Habit habit, DateTime date) {
  switch (habit.frequency) {
    case HabitFrequency.daily:
      return true;
    case HabitFrequency.weekly:
      final habitWeekday = habit.selectedWeekdays.isNotEmpty
          ? habit.selectedWeekdays.first
          : DateTime.sunday;
      return date.weekday == habitWeekday;
    case HabitFrequency.monthly:
      final habitDay = habit.selectedMonthDays.isNotEmpty
          ? habit.selectedMonthDays.first
          : 1;
      return date.day == habitDay;
    case HabitFrequency.yearly:
      return habit.selectedYearlyDates.any((yearlyDateString) {
        try {
          final yearlyDate = DateTime.parse(yearlyDateString);
          return date.month == yearlyDate.month && date.day == yearlyDate.day;
        } catch (e) {
          return false;
        }
      });
    case HabitFrequency.hourly:
      return true;
    case HabitFrequency.single:
      if (habit.singleDateTime != null) {
        return date.year == habit.singleDateTime!.year &&
               date.month == habit.singleDateTime!.month &&
               date.day == habit.singleDateTime!.day;
      }
      return false;
  }
}

// AFTER (New implementation with RRule)
static bool isHabitDueOnDate(Habit habit, DateTime date) {
  // Use RRule system if available
  if (habit.isRRuleBased()) {
    return RRuleService.isDueOnDate(
      rruleString: habit.rruleString!,
      startDate: habit.dtStart ?? habit.createdAt,
      checkDate: date,
    );
  }
  
  // Legacy fallback for old habits
  return _legacyIsHabitDueOnDate(habit, date);
}

// Keep legacy logic for backward compatibility
static bool _legacyIsHabitDueOnDate(Habit habit, DateTime date) {
  switch (habit.frequency) {
    case HabitFrequency.daily:
      return true;
    case HabitFrequency.weekly:
      final habitWeekday = habit.selectedWeekdays.isNotEmpty
          ? habit.selectedWeekdays.first
          : DateTime.sunday;
      return date.weekday == habitWeekday;
    // ... rest of legacy logic
    default:
      return false;
  }
}
```

---

## 5. Migration Script

### File: `scripts/migrate_habits_to_rrule.dart`

```dart
import 'package:hive/hive.dart';
import '../lib/domain/model/habit.dart';
import '../lib/services/rrule_service.dart';
import '../lib/services/app_logger.dart';

/// One-time migration script to convert all habits to RRule format
Future<void> migrateAllHabitsToRRule() async {
  AppLogger.info('Starting RRule migration...');
  
  final habitsBox = await Hive.openBox<Habit>('habits');
  final allHabits = habitsBox.values.toList();
  
  int successCount = 0;
  int failCount = 0;
  int skippedCount = 0;
  
  for (final habit in allHabits) {
    try {
      // Skip if already migrated
      if (habit.usesRRule) {
        skippedCount++;
        continue;
      }
      
      // Skip single frequency (no recurrence)
      if (habit.frequency == HabitFrequency.single) {
        skippedCount++;
        continue;
      }
      
      // Convert to RRule
      final rruleString = RRuleService.convertLegacyToRRule(habit);
      
      if (rruleString == null) {
        AppLogger.warning('Could not convert habit: ${habit.name}');
        failCount++;
        continue;
      }
      
      // Validate the RRule
      if (!RRuleService.isValidRRule(rruleString)) {
        AppLogger.warning('Invalid RRule generated for: ${habit.name}');
        failCount++;
        continue;
      }
      
      // Update habit
      habit.rruleString = rruleString;
      habit.dtStart = habit.dtStart ?? habit.createdAt;
      habit.usesRRule = true;
      
      // Save to database
      await habit.save();
      
      AppLogger.info('Migrated: ${habit.name} -> $rruleString');
      successCount++;
      
    } catch (e) {
      AppLogger.error('Failed to migrate ${habit.name}: $e');
      failCount++;
    }
  }
  
  AppLogger.info('''
    Migration complete!
    ✅ Success: $successCount
    ❌ Failed: $failCount
    ⏭️  Skipped: $skippedCount
    📊 Total: ${allHabits.length}
  ''');
}

void main() async {
  await Hive.initFlutter();
  
  // Register adapters
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitFrequencyAdapter());
  Hive.registerAdapter(HabitDifficultyAdapter());
  
  // Run migration
  await migrateAllHabitsToRRule();
  
  await Hive.close();
}
```

---

## 6. Usage in Create Habit Screen

### File: `lib/ui/screens/create_habit_screen.dart` (Update)

```dart
class _CreateHabitScreenState extends State<CreateHabitScreen> {
  String? _rruleString;
  DateTime? _dtStart;
  
  // ... other state variables ...

  Widget _buildScheduleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // RRule Builder Widget
            RRuleBuilderWidget(
              onRRuleChanged: (rrule, startDate) {
                setState(() {
                  _rruleString = rrule;
                  _dtStart = startDate;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createHabit() async {
    if (_rruleString == null || _dtStart == null) {
      // Show error
      return;
    }

    final habit = Habit.create(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      colorValue: _selectedColor.value,
      rruleString: _rruleString,
      dtStart: _dtStart,
      usesRRule: true,
      // ... other fields ...
    );

    // Save habit
    await HabitService.addHabit(habit);
    
    // Schedule notifications
    await WorkManagerHabitService.scheduleNotificationsForHabit(habit);
    
    Navigator.pop(context);
  }
}
```

---

## 7. Testing Examples

### File: `test/services/rrule_service_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/rrule_service.dart';
import 'package:habitv8/domain/model/habit.dart';

void main() {
  group('RRuleService', () {
    
    test('converts daily habit to FREQ=DAILY', () {
      final habit = Habit.create(
        name: 'Test',
        category: 'Test',
        colorValue: 0xFF000000,
        frequency: HabitFrequency.daily,
      );
      
      final rrule = RRuleService.convertLegacyToRRule(habit);
      expect(rrule, equals('FREQ=DAILY'));
    });

    test('converts weekly habit with days to correct RRule', () {
      final habit = Habit.create(
        name: 'Test',
        category: 'Test',
        colorValue: 0xFF000000,
        frequency: HabitFrequency.weekly,
        selectedWeekdays: [1, 3, 5], // Mon, Wed, Fri
      );
      
      final rrule = RRuleService.convertLegacyToRRule(habit);
      expect(rrule, equals('FREQ=WEEKLY;BYDAY=MO,WE,FR'));
    });

    test('isDueOnDate returns true for matching date', () {
      final startDate = DateTime(2025, 1, 1);
      final checkDate = DateTime(2025, 10, 3);
      
      final isDue = RRuleService.isDueOnDate(
        rruleString: 'FREQ=DAILY',
        startDate: startDate,
        checkDate: checkDate,
      );
      
      expect(isDue, isTrue);
    });

    test('isDueOnDate returns false for non-matching weekday', () {
      final startDate = DateTime(2025, 1, 1);
      final checkDate = DateTime(2025, 10, 4); // Saturday
      
      final isDue = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO,WE,FR',
        startDate: startDate,
        checkDate: checkDate,
      );
      
      expect(isDue, isFalse);
    });

    test('getRRuleSummary returns readable text', () {
      final summary = RRuleService.getRRuleSummary(
        'FREQ=WEEKLY;INTERVAL=2;BYDAY=TU,TH',
      );
      
      expect(summary, contains('Every 2 weeks'));
      expect(summary, contains('Tuesday'));
      expect(summary, contains('Thursday'));
    });

    test('getNextOccurrences returns correct dates', () {
      final startDate = DateTime(2025, 10, 1);
      
      final occurrences = RRuleService.getNextOccurrences(
        rruleString: 'FREQ=WEEKLY;BYDAY=TU',
        startDate: startDate,
        count: 3,
      );
      
      expect(occurrences.length, equals(3));
      // Verify all are Tuesdays
      for (final date in occurrences) {
        expect(date.weekday, equals(DateTime.tuesday));
      }
    });
  });
}
```

---

## 8. pubspec.yaml Update

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # ... existing dependencies ...
  
  # RRule support
  rrule: ^0.2.15  # Check pub.dev for latest version
  
  # Already in project (needed for RRule)
  intl: ^0.18.0
  
  # ... other dependencies ...
```

---

## Quick Start Checklist

- [ ] Add `rrule` package to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Create `lib/services/rrule_service.dart`
- [ ] Add RRule fields to `lib/domain/model/habit.dart`
- [ ] Run `flutter packages pub run build_runner build`
- [ ] Create `lib/ui/widgets/rrule_builder_widget.dart`
- [ ] Update one service (e.g., `calendar_service.dart`) as proof of concept
- [ ] Write tests for `rrule_service.dart`
- [ ] Test with sample habits
- [ ] Gradually update remaining services

---

**Pro Tips:**

1. **Start Small**: Begin with just the RRuleService and basic tests
2. **Test Thoroughly**: Edge cases are critical (leap years, DST, etc.)
3. **Keep Legacy Code**: Don't delete old code until RRule is proven stable
4. **Use Caching**: Parse RRule once, cache the result
5. **Validate Everything**: Always validate RRule strings before using them
6. **Log Migrations**: Keep detailed logs of what converts and what fails
7. **Feature Flags**: Use remote config to enable/disable RRule gradually

---

**Document Version:** 1.0  
**Last Updated:** October 3, 2025  
**Status:** Implementation Guide
