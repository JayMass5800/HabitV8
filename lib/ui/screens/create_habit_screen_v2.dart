import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/category_suggestion_service.dart';
import '../../services/comprehensive_habit_suggestions_service.dart';
import '../../services/alarm_manager_service.dart';
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
  bool _alarmEnabled = false;
  String? _selectedAlarmSoundName;
  String? _selectedAlarmSoundUri;

  // Habit suggestions
  List<HabitSuggestion> _habitSuggestions = [];
  bool _loadingSuggestions = false;
  bool _showSuggestions = false;

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
    _loadHabitSuggestions();

    // Add listeners to text controllers for category suggestions
    _nameController.addListener(_onHabitTextChanged);
    _descriptionController.addListener(_onHabitTextChanged);
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
    return TimeOfDay.now();
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
            // Habit suggestions section
            if (_habitSuggestions.isNotEmpty) ...[
              _buildHabitSuggestionsDropdown(),
              const SizedBox(height: 24),
            ],
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
            // Header with mode toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Schedule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _selectedColor,
                        ),
                  ),
                ),
                // Mode toggle at top level
                Container(
                  decoration: BoxDecoration(
                    color: _useAdvancedMode
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _useAdvancedMode = !_useAdvancedMode;
                      });
                    },
                    icon: Icon(
                      _useAdvancedMode ? Icons.light_mode : Icons.tune,
                      size: 18,
                    ),
                    label: Text(
                      _useAdvancedMode ? 'Simple' : 'Custom Schedules',
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
            ),
            const SizedBox(height: 16),

            // Mode-specific UI
            if (_useAdvancedMode)
              _buildAdvancedModeUI()
            else
              _buildSimpleModeWithFrequencySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleModeWithFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
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
                  });
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // Show frequency-specific UI
        _buildSimpleModeUI(),
      ],
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
                  'Create custom schedules: Choose your frequency (daily/weekly/monthly/yearly), set intervals like "every 2 weeks" or "every 3 days", pick specific days, and see a preview of your pattern.',
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
          forceAdvancedMode:
              true, // Show all advanced options immediately (no nested toggle)
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
              'Notifications & Alarms',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),

            // Time selector - shown first for all frequencies except hourly and single
            if (_selectedFrequency != HabitFrequency.hourly &&
                _selectedFrequency != HabitFrequency.single) ...[
              ListTile(
                title: Text(
                  _alarmEnabled ? 'Alarm Time' : 'Notification Time',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _notificationTime != null
                      ? _notificationTime!.format(context)
                      : 'Tap to set time',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _selectNotificationTime,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
            ],

            // Notification/Alarm toggles
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Get reminded about your habit'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (value) {
                    // Disable alarms when enabling notifications
                    _alarmEnabled = false;
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Enable Alarms'),
              subtitle: Text(
                _alarmEnabled
                    ? 'System alarms are more persistent than notifications'
                    : 'Use system alarms instead of notifications',
              ),
              value: _alarmEnabled,
              onChanged: (value) {
                setState(() {
                  _alarmEnabled = value;
                  if (value) {
                    // Disable notifications when enabling alarms
                    _notificationsEnabled = false;
                  }
                });
              },
            ),

            // Alarm-specific settings
            if (_alarmEnabled) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Alarm Sound'),
                subtitle: Text(
                  _selectedAlarmSoundName ?? 'Default system alarm',
                ),
                trailing: const Icon(Icons.music_note),
                onTap: _selectAlarmSound,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Alarms require exact alarm permissions on Android 12+. The app will request this permission when needed.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade700,
                            ),
                      ),
                    ),
                  ],
                ),
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
      initialTime: _notificationTime ?? TimeOfDay.now(),
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

      // Create habit - V1 style with proper data structure
      final habit = Habit.create(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        colorValue: _selectedColor.toARGB32(),
        frequency: _selectedFrequency,
        targetCount: 1,
        notificationsEnabled: _notificationsEnabled,
        notificationTime: notificationDateTime,
        selectedWeekdays: _selectedFrequency == HabitFrequency.hourly
            ? _selectedWeekdays
            : _simpleWeekdays.toList(), // Use simple weekdays for weekly habits
        selectedMonthDays: _simpleMonthDays.toList(), // From simple mode
        hourlyTimes: _hourlyTimes
            .map(
              (time) =>
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            )
            .toList(),
        selectedYearlyDates: _simpleYearlyDates
            .map(
              (date) =>
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            )
            .toList(),
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
        setState(() {
          _isSaving = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Habit service not available'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Save habit with V1's retry logic
      try {
        await habitService.addHabit(habit);
      } catch (e) {
        // If it's a database connection error, try to refresh the provider and retry once
        if (e.toString().contains('Database box is closed') ||
            e.toString().contains('Database connection lost')) {
          AppLogger.info(
              'Database connection lost, refreshing providers and retrying...');

          // Invalidate the providers to force refresh
          ref.invalidate(databaseProvider);
          ref.invalidate(habitServiceProvider);

          // Wait a moment for providers to refresh
          await Future.delayed(const Duration(milliseconds: 500));

          // Try to get fresh service and retry
          try {
            final freshServiceAsync = ref.read(habitServiceProvider);
            final freshService = freshServiceAsync.value;

            if (freshService == null) {
              throw StateError(
                  'Could not obtain fresh habit service after refresh');
            }

            AppLogger.info(
                'Retrying habit creation with fresh database connection...');
            await freshService.addHabit(habit);
            AppLogger.info('✅ Habit created successfully on retry');
          } catch (retryError) {
            AppLogger.error('Retry failed: $retryError');
            rethrow; // Rethrow the retry error
          }
        } else {
          rethrow; // Re-throw other errors
        }
      }

      // NOTE: Notification/alarm scheduling is handled by addHabit() in database.dart
      // to avoid double scheduling. Removed from here to fix performance issue.

      // Log the habit creation
      if (mounted) {
        AppLogger.info('Habit created: ${habit.name}');
      }

      // Show success message - V1 style
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit "${habit.name}" created successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

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
          // Sort dates by month and day
          final sortedDates = _simpleYearlyDates.toList()
            ..sort((a, b) {
              if (a.month != b.month) return a.month.compareTo(b.month);
              return a.day.compareTo(b.day);
            });

          // Group by month to get unique months and days
          final monthGroups = <int, List<int>>{};
          for (final date in sortedDates) {
            monthGroups.putIfAbsent(date.month, () => []).add(date.day);
          }

          // Check if all dates are in the same month
          if (monthGroups.length == 1) {
            // Single month: FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15,20,25
            final month = monthGroups.keys.first;
            final days = monthGroups[month]!.join(',');
            rruleString = 'FREQ=YEARLY;BYMONTH=$month;BYMONTHDAY=$days';
          } else {
            // Multiple months: Check if we can use BYMONTH with BYMONTHDAY
            // RRule expands BYMONTH and BYMONTHDAY as a Cartesian product
            // So we need to check if all selected dates match this pattern

            // Get all unique months and days
            final allMonths = monthGroups.keys.toList()..sort();
            final allDays = <int>{};
            for (final days in monthGroups.values) {
              allDays.addAll(days);
            }
            final sortedDays = allDays.toList()..sort();

            // Check if the Cartesian product matches our selected dates
            final expectedDates = <String>{};
            for (final month in allMonths) {
              for (final day in sortedDays) {
                // Check if this day is valid for this month
                try {
                  DateTime(2024, month, day); // Use leap year to validate
                  expectedDates.add('$month-$day');
                } catch (e) {
                  // Invalid date (e.g., Feb 31), skip
                }
              }
            }

            final selectedDates =
                sortedDates.map((d) => '${d.month}-${d.day}').toSet();

            // If the pattern matches, use BYMONTH and BYMONTHDAY
            if (expectedDates.length == selectedDates.length &&
                expectedDates.containsAll(selectedDates)) {
              final months = allMonths.join(',');
              final days = sortedDays.join(',');
              rruleString = 'FREQ=YEARLY;BYMONTH=$months;BYMONTHDAY=$days';
            } else {
              // Pattern doesn't match Cartesian product
              // Use RDATE for specific dates (requires dtStart + RDATE list)
              // For now, fall back to creating multiple simple rules
              // or use the most common pattern

              // Strategy: Use the month with the most dates
              final maxMonth = monthGroups.entries
                  .reduce((a, b) => a.value.length > b.value.length ? a : b)
                  .key;
              final days = monthGroups[maxMonth]!.join(',');
              rruleString = 'FREQ=YEARLY;BYMONTH=$maxMonth;BYMONTHDAY=$days';

              AppLogger.warning(
                  'Yearly habit has complex date pattern. Using primary month ($maxMonth) only. '
                  'Consider using Advanced Mode for full control.');
            }
          }
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

  // ==================== HABIT SUGGESTIONS ====================

  /// Load comprehensive habit suggestions
  Future<void> _loadHabitSuggestions() async {
    setState(() {
      _loadingSuggestions = true;
    });

    try {
      final suggestions =
          await ComprehensiveHabitSuggestionsService.generateSuggestions();
      if (mounted) {
        setState(() {
          _habitSuggestions = suggestions;
          _loadingSuggestions = false;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading habit suggestions', e);
      if (mounted) {
        setState(() {
          _loadingSuggestions = false;
        });
      }
    }
  }

  /// Update category suggestions when text changes
  void _onHabitTextChanged() {
    setState(() {
      // This will trigger a rebuild and update category suggestions
    });
  }

  /// Build comprehensive habit suggestions dropdown
  Widget _buildHabitSuggestionsDropdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Habit Suggestions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showSuggestions = !_showSuggestions;
                    });
                  },
                  icon: Icon(
                    _showSuggestions ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  label: Text(_showSuggestions ? 'Hide' : 'Show'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Get inspired with personalized habit suggestions.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            if (_showSuggestions) ...[
              const SizedBox(height: 16),
              _buildSuggestionsGrid(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsGrid() {
    if (_loadingSuggestions) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_habitSuggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No suggestions available at the moment.',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // Group suggestions by type
    final groupedSuggestions = <String, List<HabitSuggestion>>{};
    for (final suggestion in _habitSuggestions) {
      groupedSuggestions.putIfAbsent(suggestion.type, () => []).add(suggestion);
    }

    return Column(
      children: groupedSuggestions.entries.map((entry) {
        final type = entry.key;
        final suggestions =
            entry.value.take(3).toList(); // Show max 3 per category

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _getTypeIcon(type),
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    type,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            ...suggestions.map((suggestion) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      _getCategoryIcon(suggestion.category),
                      color: _getCategoryColor(suggestion.category),
                    ),
                    title: Text(suggestion.name),
                    subtitle: Text(
                      suggestion.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.add),
                    onTap: () => _applySuggestion(suggestion),
                  ),
                )),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'fitness':
        return Icons.fitness_center;
      case 'productivity':
        return Icons.work;
      case 'learning':
        return Icons.school;
      case 'mindfulness':
        return Icons.self_improvement;
      default:
        return Icons.star;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
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
        return Icons.emoji_objects;
    }
  }

  void _applySuggestion(HabitSuggestion suggestion) {
    setState(() {
      _nameController.text = suggestion.name;
      _descriptionController.text = suggestion.description;
      _selectedCategory = suggestion.category;
      _selectedColor = _getCategoryColor(suggestion.category);
      _selectedFrequency = suggestion.frequency;
      _notificationsEnabled = true;
      _notificationTime = TimeOfDay.now();
    });

    // Close suggestions after applying
    setState(() {
      _showSuggestions = false;
    });
  }

  // ==================== ALARM SELECTION ====================

  Future<void> _selectAlarmSound() async {
    final availableSounds = await AlarmManagerService.getAvailableAlarmSounds();

    if (!mounted) return;

    String? currentlyPlaying;

    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.music_note, color: _selectedColor),
              const SizedBox(width: 8),
              const Text('Select Alarm Sound'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: _selectedColor, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Tap the play button to preview sounds.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableSounds.length,
                    itemBuilder: (context, index) {
                      final sound = availableSounds[index];
                      final soundName = sound['name']!;
                      final soundUri = sound['uri']!;
                      final isSelected = soundName == _selectedAlarmSoundName;
                      final isPlaying = currentlyPlaying == soundUri;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        elevation: isSelected ? 3 : 1,
                        color: isSelected
                            ? _selectedColor.withValues(alpha: 0.1)
                            : null,
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPlaying
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : Colors.blue.withValues(alpha: 0.1),
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.stop : Icons.play_arrow,
                                color: isPlaying ? Colors.red : Colors.blue,
                              ),
                              onPressed: () async {
                                if (isPlaying) {
                                  await AlarmManagerService
                                      .stopAlarmSoundPreview();
                                  setDialogState(() {
                                    currentlyPlaying = null;
                                  });
                                } else {
                                  await AlarmManagerService
                                      .stopAlarmSoundPreview();
                                  await AlarmManagerService
                                      .playAlarmSoundPreview(soundUri);
                                  setDialogState(() {
                                    currentlyPlaying = soundUri;
                                  });

                                  // Auto-stop after 4 seconds
                                  Future.delayed(
                                    const Duration(seconds: 4),
                                    () async {
                                      await AlarmManagerService
                                          .stopAlarmSoundPreview();
                                      try {
                                        setDialogState(() {
                                          currentlyPlaying = null;
                                        });
                                      } catch (e) {
                                        // Dialog was closed, ignore
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          title: Text(soundName),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: _selectedColor)
                              : null,
                          onTap: () {
                            Navigator.of(context).pop({
                              'name': soundName,
                              'uri': soundUri,
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedAlarmSoundName = selected['name'];
        _selectedAlarmSoundUri = selected['uri'];
      });
    }

    // Stop any playing sound when dialog closes
    await AlarmManagerService.stopAlarmSoundPreview();
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
