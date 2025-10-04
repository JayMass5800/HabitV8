import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/notification_service.dart';
import '../../services/category_suggestion_service.dart';
import '../../services/logging_service.dart';
import '../widgets/rrule_builder_widget.dart';

/// Streamlined Create Habit Screen V2
///
/// Features:
/// - Uses RRule for daily through yearly frequencies
/// - Keeps old hourly system for hourly frequency
/// - Uses table_calendar consistently
/// - Conditional UI based on selected frequency
/// - Advanced mode toggle only for complex patterns
class CreateHabitScreenV2 extends ConsumerStatefulWidget {
  final Map<String, dynamic>? prefilledData;

  const CreateHabitScreenV2({super.key, this.prefilledData});

  @override
  ConsumerState<CreateHabitScreenV2> createState() =>
      _CreateHabitScreenV2State();
}

class _CreateHabitScreenV2State extends ConsumerState<CreateHabitScreenV2> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Basic settings
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  String _selectedCategory = 'Health';
  Color _selectedColor = Colors.blue;
  bool _notificationsEnabled = true;
  TimeOfDay? _notificationTime;
  bool _isSaving = false;

  // RRule integration (for daily through yearly)
  bool _useAdvancedMode = false;
  String? _rruleString;
  DateTime _rruleStartDate = DateTime.now();

  // Hourly frequency (legacy system)
  final List<TimeOfDay> _hourlyTimes = [];
  final List<int> _selectedWeekdays = [];

  // Simple mode selections (converted to RRule on save)
  final Set<int> _simpleWeekdays = {}; // For weekly
  final Set<int> _simpleMonthDays = {}; // For monthly
  DateTime _focusedMonth = DateTime.now(); // For calendar navigation
  final Set<DateTime> _simpleYearlyDates = {}; // For yearly

  // Single habit date/time
  DateTime? _singleDateTime;

  // Alarm settings
  final bool _alarmEnabled = false;
  String? _selectedAlarmSoundName;
  String? _selectedAlarmSoundUri;

  // Categories
  List<String> get _categories => CategorySuggestionService.getAllCategories();

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _initializeFromPrefilledData();
  }

  void _initializeFromPrefilledData() {
    if (widget.prefilledData != null) {
      final data = widget.prefilledData!;

      if (data['name'] != null) {
        _nameController.text = data['name'];
      }
      if (data['description'] != null) {
        _descriptionController.text = data['description'];
      }
      if (data['category'] != null && _categories.contains(data['category'])) {
        _selectedCategory = data['category'];
      }

      // Set frequency based on difficulty
      if (data['difficulty'] != null) {
        switch (data['difficulty'].toString().toLowerCase()) {
          case 'easy':
            _selectedFrequency = HabitFrequency.daily;
            break;
          case 'medium':
            _selectedFrequency = HabitFrequency.daily;
            break;
          case 'hard':
            _selectedFrequency = HabitFrequency.weekly;
            break;
        }
      }

      // Set notification time
      if (data['suggestedTime'] != null) {
        _notificationsEnabled = true;
        final timeString = data['suggestedTime'].toString();
        _notificationTime = _parseTimeString(timeString);
      }

      // Set color based on category
      _selectedColor = _getCategoryColor(data['category'] ?? 'Health');
    }
  }

  TimeOfDay? _parseTimeString(String timeString) {
    try {
      if (timeString.toLowerCase().contains('morning')) {
        return const TimeOfDay(hour: 8, minute: 0);
      } else if (timeString.toLowerCase().contains('afternoon')) {
        return const TimeOfDay(hour: 14, minute: 0);
      } else if (timeString.toLowerCase().contains('evening')) {
        return const TimeOfDay(hour: 18, minute: 0);
      } else if (timeString.toLowerCase().contains('night')) {
        return const TimeOfDay(hour: 21, minute: 0);
      }

      final timeRegex = RegExp(
        r'(\d{1,2}):(\d{2})(?:\s*(AM|PM))?',
        caseSensitive: false,
      );
      final match = timeRegex.firstMatch(timeString);

      if (match != null) {
        int hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        final amPm = match.group(3)?.toUpperCase();

        if (amPm == 'PM' && hour != 12) {
          hour += 12;
        } else if (amPm == 'AM' && hour == 12) {
          hour = 0;
        }

        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // If parsing fails, return default
    }
    return const TimeOfDay(hour: 9, minute: 0);
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red;
      case 'fitness':
        return Colors.orange;
      case 'productivity':
        return Colors.blue;
      case 'learning':
        return Colors.purple;
      case 'personal':
        return Colors.green;
      case 'social':
        return Colors.teal;
      case 'finance':
        return Colors.indigo;
      case 'mindfulness':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.prefilledData != null
              ? 'Create Recommended Habit'
              : 'Create Habit',
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: _isSaving ? null : _saveHabit,
                  child: const Text('Save'),
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Recommendation banner
            if (widget.prefilledData != null) ...[
              _buildRecommendationBanner(),
              const SizedBox(height: 16),
            ],
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            _buildFrequencySection(),
            const SizedBox(height: 24),
            _buildNotificationSection(),
            const SizedBox(height: 24),
            _buildCustomizationSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationBanner() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Habit',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Pre-filled based on recommendations. Customize as needed!',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                hintText: 'e.g., Drink 8 glasses of water',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a habit name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add more details about your habit',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with advanced mode toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Frequency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _selectedColor,
                        ),
                  ),
                ),
                // Only show advanced toggle for non-hourly, non-single frequencies
                if (_selectedFrequency != HabitFrequency.hourly &&
                    _selectedFrequency != HabitFrequency.single) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: _useAdvancedMode
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _useAdvancedMode = !_useAdvancedMode;
                        });
                      },
                      icon: Icon(
                        _useAdvancedMode ? Icons.tune : Icons.auto_awesome,
                        size: 18,
                      ),
                      label: Text(
                        _useAdvancedMode ? 'Simple' : 'Advanced',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _useAdvancedMode
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Frequency selector
            _buildFrequencyChips(),
            const SizedBox(height: 16),

            // Conditional UI based on frequency and mode
            if (_useAdvancedMode &&
                _selectedFrequency != HabitFrequency.hourly &&
                _selectedFrequency != HabitFrequency.single)
              _buildAdvancedModeUI()
            else
              _buildSimpleModeUI(),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: HabitFrequency.values.map((frequency) {
        return ChoiceChip(
          label: Text(_getFrequencyDisplayName(frequency)),
          selected: _selectedFrequency == frequency,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedFrequency = frequency;
                // Clear selections when changing frequency
                _simpleWeekdays.clear();
                _simpleMonthDays.clear();
                _simpleYearlyDates.clear();
                _hourlyTimes.clear();
                _selectedWeekdays.clear();
                _singleDateTime = null;
                _useAdvancedMode = false; // Reset to simple mode
              });
            }
          },
        );
      }).toList(),
    );
  }

  String _getFrequencyDisplayName(HabitFrequency frequency) {
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
        return 'One-time';
    }
  }

  Widget _buildSimpleModeUI() {
    switch (_selectedFrequency) {
      case HabitFrequency.hourly:
        return _buildHourlyUI();
      case HabitFrequency.daily:
        return _buildDailyUI();
      case HabitFrequency.weekly:
        return _buildWeeklyUI();
      case HabitFrequency.monthly:
        return _buildMonthlyUI();
      case HabitFrequency.yearly:
        return _buildYearlyUI();
      case HabitFrequency.single:
        return _buildSingleUI();
    }
  }

  Widget _buildAdvancedModeUI() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Advanced mode: Create complex patterns like "every other week" or "2nd Tuesday of each month"',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        RRuleBuilderWidget(
          initialRRuleString: _rruleString,
          initialStartDate: _rruleStartDate,
          initialFrequency: _selectedFrequency,
          onRRuleChanged: (rruleString, startDate) {
            setState(() {
              _rruleString = rruleString;
              _rruleStartDate = startDate;
            });
          },
        ),
      ],
    );
  }

  // ==================== FREQUENCY-SPECIFIC UI ====================

  Widget _buildHourlyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select times throughout the day:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildHourlyTimeSelector(),
        const SizedBox(height: 16),
        Text(
          'Select days of the week:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildWeekdaySelector(),
      ],
    );
  }

  Widget _buildDailyUI() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This habit will repeat every day',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select days of the week:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildWeekdaySelectorSimple(),
      ],
    );
  }

  Widget _buildMonthlyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select days of the month:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildMonthDayCalendar(),
      ],
    );
  }

  Widget _buildYearlyUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select dates throughout the year:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildYearlyCalendar(),
      ],
    );
  }

  Widget _buildSingleUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select the date and time for this one-time habit:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        _buildSingleDateTimeSelector(),
      ],
    );
  }

  // ==================== UI COMPONENTS ====================

  Widget _buildHourlyTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (_hourlyTimes.isEmpty)
            Text(
              'No times selected',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _hourlyTimes.map((time) {
                return Chip(
                  label: Text(time.format(context)),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _hourlyTimes.remove(time);
                    });
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _addHourlyTime,
            icon: const Icon(Icons.add_alarm),
            label: const Text('Add Time'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addHourlyTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (!_hourlyTimes.contains(time)) {
          _hourlyTimes.add(time);
          _hourlyTimes.sort((a, b) {
            if (a.hour != b.hour) return a.hour.compareTo(b.hour);
            return a.minute.compareTo(b.minute);
          });
        }
      });
    }
  }

  Widget _buildWeekdaySelector() {
    // For hourly habits (legacy system)
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        final isSelected = _selectedWeekdays.contains(dayNumber);
        return FilterChip(
          label: Text(weekdays[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedWeekdays.add(dayNumber);
              } else {
                _selectedWeekdays.remove(dayNumber);
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildWeekdaySelectorSimple() {
    // For weekly habits (RRule system)
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        final isSelected = _simpleWeekdays.contains(dayNumber);
        return FilterChip(
          label: Text(weekdays[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _simpleWeekdays.add(dayNumber);
              } else {
                _simpleWeekdays.remove(dayNumber);
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildMonthDayCalendar() {
    final now = DateTime.now();
    final focusedDay = DateTime(now.year, now.month, 1);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade600
              : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Tap days to select them for your monthly habit',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          TableCalendar<int>(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.red.shade300
                    : Colors.red.shade600,
              ),
              defaultTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            selectedDayPredicate: (day) {
              return _simpleMonthDays.contains(day.day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                final dayNumber = selectedDay.day;
                if (_simpleMonthDays.contains(dayNumber)) {
                  _simpleMonthDays.remove(dayNumber);
                } else {
                  _simpleMonthDays.add(dayNumber);
                }
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isSelected = _simpleMonthDays.contains(day.day);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColor : null,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_simpleMonthDays.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Selected days: ${_simpleMonthDays.toList()
                  ..sort()
                  ..map((d) => d.toString()).join(', ')}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYearlyCalendar() {
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade600
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Navigate months and tap dates to select them',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              TableCalendar<DateTime>(
                firstDay: DateTime(now.year, 1, 1),
                lastDay: DateTime(now.year, 12, 31),
                focusedDay: _focusedMonth,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.red.shade300
                        : Colors.red.shade600,
                  ),
                  defaultTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return _simpleYearlyDates.any(
                    (d) =>
                        d.year == day.year &&
                        d.month == day.month &&
                        d.day == day.day,
                  );
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    final normalizedDate = DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    );

                    final existingDate = _simpleYearlyDates.firstWhere(
                      (d) =>
                          d.year == normalizedDate.year &&
                          d.month == normalizedDate.month &&
                          d.day == normalizedDate.day,
                      orElse: () => DateTime(1900),
                    );

                    if (existingDate.year != 1900) {
                      _simpleYearlyDates.remove(existingDate);
                    } else {
                      _simpleYearlyDates.add(normalizedDate);
                    }
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedMonth = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final isSelected = _simpleYearlyDates.any(
                      (d) =>
                          d.year == day.year &&
                          d.month == day.month &&
                          d.day == day.day,
                    );
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedColor : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_simpleYearlyDates.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Selected dates: ${_simpleYearlyDates.map((d) => '${d.month}/${d.day}').join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleDateTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (_singleDateTime == null)
            Text(
              'No date/time selected',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Text(
              'Selected: ${_formatDateTime(_singleDateTime!)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: _selectedColor,
                  ),
            ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _selectSingleDateTime,
            icon: const Icon(Icons.calendar_today),
            label:
                Text(_singleDateTime == null ? 'Select Date & Time' : 'Change'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    final time = TimeOfDay.fromDateTime(dateTime).format(context);
    return '$date at $time';
  }

  Future<void> _selectSingleDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _singleDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: _singleDateTime != null
            ? TimeOfDay.fromDateTime(_singleDateTime!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _singleDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get reminded about your habit'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            if (_notificationsEnabled &&
                _selectedFrequency != HabitFrequency.hourly &&
                _selectedFrequency != HabitFrequency.single) ...[
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Notification Time'),
                subtitle: Text(
                  _notificationTime != null
                      ? _notificationTime!.format(context)
                      : 'Not set',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _selectNotificationTime,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectNotificationTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _notificationTime ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (time != null) {
      setState(() {
        _notificationTime = time;
      });
    }
  }

  Widget _buildCustomizationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customization',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Color',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SAVE LOGIC ====================

  Future<void> _saveHabit() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Validate frequency-specific requirements
      if (!_validateFrequencyRequirements()) {
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final databaseAsync = ref.read(databaseProvider);
      final database = databaseAsync.value;

      if (database == null) {
        _showError('Database not available');
        setState(() {
          _isSaving = false;
        });
        return;
      }

      // Convert TimeOfDay to DateTime if notification time is set
      DateTime? notificationDateTime;
      if (_notificationTime != null) {
        final now = DateTime.now();
        notificationDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          _notificationTime!.hour,
          _notificationTime!.minute,
        );
      }

      // Create habit
      final habit = Habit.create(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        colorValue: _selectedColor.toARGB32(),
        frequency: _selectedFrequency,
        targetCount: 1,
        notificationsEnabled: _notificationsEnabled,
        notificationTime: notificationDateTime,
        selectedWeekdays: _selectedWeekdays, // For hourly habits
        selectedMonthDays: [],
        hourlyTimes: _hourlyTimes
            .map(
              (time) =>
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            )
            .toList(),
        selectedYearlyDates: [],
        singleDateTime: _singleDateTime,
        alarmEnabled: _alarmEnabled,
        alarmSoundName: _selectedAlarmSoundName,
        alarmSoundUri: _selectedAlarmSoundUri,
      );

      // Apply RRule based on mode and frequency
      if (_useAdvancedMode && _rruleString != null) {
        // Advanced mode: Use the RRule from the builder
        habit.rruleString = _rruleString;
        habit.dtStart = _rruleStartDate;
        habit.usesRRule = true;
        AppLogger.info('✅ Using advanced RRule scheduling: $_rruleString');
      } else if (_selectedFrequency != HabitFrequency.hourly &&
          _selectedFrequency != HabitFrequency.single) {
        // Simple mode: Generate RRule from simple selections
        _generateRRuleFromSimpleMode(habit);
      }

      // Get HabitService
      final habitServiceAsync = ref.read(habitServiceProvider);
      final habitService = habitServiceAsync.value;

      if (habitService == null) {
        _showError('Habit service not available');
        setState(() {
          _isSaving = false;
        });
        return;
      }

      // Save habit
      await habitService.addHabit(habit);

      // Schedule notifications if enabled
      if (_notificationsEnabled || _alarmEnabled) {
        try {
          await NotificationService.scheduleHabitNotifications(habit);
          AppLogger.info(
            'Notifications scheduled successfully for habit: ${habit.name}',
          );
        } catch (e) {
          AppLogger.warning(
            'Failed to schedule notifications for habit: ${habit.name} - $e',
          );
        }
      }

      AppLogger.info('Habit created: ${habit.name}');

      // Navigate back
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      AppLogger.error('Failed to save habit: $e');
      _showError('Failed to save habit: ${e.toString()}');
      setState(() {
        _isSaving = false;
      });
    }
  }

  bool _validateFrequencyRequirements() {
    switch (_selectedFrequency) {
      case HabitFrequency.hourly:
        if (_hourlyTimes.isEmpty) {
          _showError('Please select at least one time for hourly reminders');
          return false;
        }
        if (_selectedWeekdays.isEmpty) {
          _showError('Please select at least one day of the week');
          return false;
        }
        break;

      case HabitFrequency.weekly:
        if (!_useAdvancedMode && _simpleWeekdays.isEmpty) {
          _showError('Please select at least one day of the week');
          return false;
        }
        break;

      case HabitFrequency.monthly:
        if (!_useAdvancedMode && _simpleMonthDays.isEmpty) {
          _showError('Please select at least one day of the month');
          return false;
        }
        break;

      case HabitFrequency.yearly:
        if (!_useAdvancedMode && _simpleYearlyDates.isEmpty) {
          _showError('Please select at least one date for the year');
          return false;
        }
        break;

      case HabitFrequency.single:
        if (_singleDateTime == null) {
          _showError('Please select a date and time for this one-time habit');
          return false;
        }
        break;

      case HabitFrequency.daily:
        // No additional validation needed
        break;
    }

    // Validate notification time for non-hourly, non-single habits
    if ((_notificationsEnabled || _alarmEnabled) &&
        _selectedFrequency != HabitFrequency.hourly &&
        _selectedFrequency != HabitFrequency.single &&
        _notificationTime == null) {
      _showError('Please select a notification time');
      return false;
    }

    return true;
  }

  void _generateRRuleFromSimpleMode(Habit habit) {
    try {
      String rruleString;

      switch (_selectedFrequency) {
        case HabitFrequency.daily:
          rruleString = 'FREQ=DAILY';
          break;

        case HabitFrequency.weekly:
          if (_simpleWeekdays.isEmpty) {
            throw Exception('No weekdays selected');
          }
          final weekdayStrings = _simpleWeekdays.map((day) {
            switch (day) {
              case 1:
                return 'MO';
              case 2:
                return 'TU';
              case 3:
                return 'WE';
              case 4:
                return 'TH';
              case 5:
                return 'FR';
              case 6:
                return 'SA';
              case 7:
                return 'SU';
              default:
                return 'MO';
            }
          }).join(',');
          rruleString = 'FREQ=WEEKLY;BYDAY=$weekdayStrings';
          break;

        case HabitFrequency.monthly:
          if (_simpleMonthDays.isEmpty) {
            throw Exception('No month days selected');
          }
          final monthDayStrings = _simpleMonthDays.toList()..sort();
          rruleString = 'FREQ=MONTHLY;BYMONTHDAY=${monthDayStrings.join(',')}';
          break;

        case HabitFrequency.yearly:
          if (_simpleYearlyDates.isEmpty) {
            throw Exception('No yearly dates selected');
          }
          // For yearly, we'll use the first date as the base and create multiple rules if needed
          // For simplicity, we'll just use BYMONTH and BYMONTHDAY
          final sortedDates = _simpleYearlyDates.toList()
            ..sort((a, b) {
              if (a.month != b.month) return a.month.compareTo(b.month);
              return a.day.compareTo(b.day);
            });

          // Group by month
          final monthGroups = <int, List<int>>{};
          for (final date in sortedDates) {
            monthGroups.putIfAbsent(date.month, () => []).add(date.day);
          }

          // For now, create a simple rule with the first date
          // TODO: Support multiple dates across different months
          final firstDate = sortedDates.first;
          rruleString =
              'FREQ=YEARLY;BYMONTH=${firstDate.month};BYMONTHDAY=${firstDate.day}';
          break;

        default:
          return; // Don't generate RRule for hourly or single
      }

      habit.rruleString = rruleString;
      habit.dtStart = DateTime.now();
      habit.usesRRule = true;
      AppLogger.info('✅ Generated RRule from simple mode: $rruleString');
    } catch (e) {
      AppLogger.warning('Failed to generate RRule from simple mode: $e');
      // Not critical - habit will work with legacy frequency system
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Extension to convert Color to ARGB32
extension ColorExtension on Color {
  int toARGB32() {
    return ((a * 255.0).round() & 0xff) << 24 |
        ((r * 255.0).round() & 0xff) << 16 |
        ((g * 255.0).round() & 0xff) << 8 |
        ((b * 255.0).round() & 0xff);
  }
}
