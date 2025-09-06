import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/notification_service.dart';
import '../../services/health_enhanced_habit_creation_service.dart';
import '../../services/health_habit_mapping_service.dart';
import '../../services/category_suggestion_service.dart';
import '../../services/comprehensive_habit_suggestions_service.dart';
import '../../services/logging_service.dart';
import '../../services/hybrid_alarm_service.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? prefilledData;

  const CreateHabitScreen({super.key, this.prefilledData});

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  String _selectedCategory = 'Health';
  Color _selectedColor = Colors.blue;
  bool _notificationsEnabled = true;
  TimeOfDay? _notificationTime;
  bool _isSaving = false;

  // Alarm-related fields
  bool _alarmEnabled = false;
  String? _selectedAlarmSoundName;
  final List<int> _selectedWeekdays = [];
  final List<int> _selectedMonthDays = [];
  final List<TimeOfDay> _hourlyTimes =
      []; // New: Multiple times for hourly habits
  final Set<DateTime> _selectedYearlyDates =
      {}; // New: Selected dates for yearly habits
  DateTime _focusedMonth = DateTime.now(); // New: For calendar navigation

  // Health integration fields
  bool _enableHealthIntegration = false;
  String? _selectedHealthDataType;
  double? _customThreshold;
  String _thresholdLevel = 'moderate';
  List<HabitSuggestion> _habitSuggestions = [];
  bool _loadingSuggestions = false;
  bool _showSuggestions = false;

  // Comprehensive categories from the category suggestion service
  List<String> get _categories {
    return CategorySuggestionService.getAllCategories();
  }

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

      // Set basic information
      if (data['name'] != null) {
        _nameController.text = data['name'];
      }
      if (data['description'] != null) {
        _descriptionController.text = data['description'];
      }
      if (data['category'] != null && _categories.contains(data['category'])) {
        _selectedCategory = data['category'];
      }

      // Set difficulty-based frequency (smart defaults)
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

      // Set notification time based on suggested time
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
      // Handle various time formats like "9:00 AM", "09:00", "morning", etc.
      if (timeString.toLowerCase().contains('morning')) {
        return const TimeOfDay(hour: 8, minute: 0);
      } else if (timeString.toLowerCase().contains('afternoon')) {
        return const TimeOfDay(hour: 14, minute: 0);
      } else if (timeString.toLowerCase().contains('evening')) {
        return const TimeOfDay(hour: 18, minute: 0);
      } else if (timeString.toLowerCase().contains('night')) {
        return const TimeOfDay(hour: 21, minute: 0);
      }

      // Try to parse specific time formats
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
      // If parsing fails, return a default time
    }
    return const TimeOfDay(hour: 9, minute: 0); // Default to 9 AM
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
            // Show recommendation banner if this is from a recommendation
            if (widget.prefilledData != null) ...[
              Card(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'This habit has been pre-filled based on our recommendations. Feel free to customize it!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildBasicInfoSection(),
            const SizedBox(height: 24),
            // Health suggestions section
            if (_habitSuggestions.isNotEmpty) ...[
              _buildHabitSuggestionsDropdown(),
              const SizedBox(height: 24),
            ],
            _buildFrequencySection(),
            const SizedBox(height: 24),
            _buildNotificationSection(), // Moved notifications below frequency
            const SizedBox(height: 24),
            _buildCustomizationSection(), // Moved color picker to bottom
            const SizedBox(height: 32),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
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
            _buildCategorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final suggestions = _getCategorySuggestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Suggested categories:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: suggestions.take(3).map((suggestion) {
              final isSelected = _selectedCategory == suggestion;
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  setState(() {
                    _selectedCategory = suggestion;
                  });
                },
                backgroundColor: isSelected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)
                    : null,
                side: isSelected
                    ? BorderSide(color: Theme.of(context).colorScheme.primary)
                    : null,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFrequencySection() {
    AppLogger.debug(
      'Building frequency section, current frequency: $_selectedFrequency',
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequency',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
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
                        _selectedWeekdays.clear();
                        _selectedMonthDays.clear();
                        _hourlyTimes.clear();
                        _selectedYearlyDates.clear();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            // Enhanced Hourly Habits - Multiple time picker
            if (_selectedFrequency == HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
              Text(
                'Select times throughout the day:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildHourlyTimeSelector(),
              const SizedBox(height: 16),
              Text(
                'Select days of the week:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelector(),
            ],
            if (_selectedFrequency == HabitFrequency.weekly) ...[
              const SizedBox(height: 16),
              Text(
                'Select days of the week:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelector(),
            ],
            // Enhanced Monthly Reminders - True calendar view
            if (_selectedFrequency == HabitFrequency.monthly) ...[
              const SizedBox(height: 16),
              Text(
                'Select days of the month:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildMonthDaySelector(),
            ],
            // Enhanced Yearly Habits - Calendar-style date picker
            if (_selectedFrequency == HabitFrequency.yearly) ...[
              const SizedBox(height: 16),
              Text(
                'Select dates throughout the year:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildYearlyCalendarSelector(),
            ],
            const SizedBox(height: 16),
            // Remove the target count section completely
          ],
        ),
      ),
    );
  }

  // New: Enhanced hourly time selector
  Widget _buildHourlyTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        ),
        if (_hourlyTimes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_hourlyTimes.length} times selected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }

  // Enhanced monthly calendar selector using table_calendar with timezone support
  Widget _buildMonthDaySelector() {
    final now = tz.TZDateTime.now(tz.local);
    final focusedDay = DateTime(now.year, now.month, 1);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Select days of the month for your habit',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          TableCalendar<int>(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red.shade600),
              selectedDecoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: _selectedColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return _selectedMonthDays.contains(day.day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                final dayNumber = selectedDay.day;
                if (_selectedMonthDays.contains(dayNumber)) {
                  _selectedMonthDays.remove(dayNumber);
                } else {
                  _selectedMonthDays.add(dayNumber);
                }
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isSelected = _selectedMonthDays.contains(day.day);
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? _selectedColor : null,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedMonthDays.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Selected days: ${_selectedMonthDays.map((d) => d.toString()).join(', ')}',
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

  // Enhanced yearly calendar selector using table_calendar with timezone support
  Widget _buildYearlyCalendarSelector() {
    final now = tz.TZDateTime.now(tz.local);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Select specific dates throughout the year',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
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
                  titleTextStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left),
                  rightChevronIcon: const Icon(Icons.chevron_right),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: TextStyle(color: Colors.red.shade600),
                  selectedDecoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: _selectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return _selectedYearlyDates.any(
                    (selectedDate) =>
                        selectedDate.year == day.year &&
                        selectedDate.month == day.month &&
                        selectedDate.day == day.day,
                  );
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    final normalizedDate = DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    );
                    if (_selectedYearlyDates.contains(normalizedDate)) {
                      _selectedYearlyDates.remove(normalizedDate);
                    } else {
                      _selectedYearlyDates.add(normalizedDate);
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
                    final isSelected = _selectedYearlyDates.any(
                      (selectedDate) =>
                          selectedDate.year == day.year &&
                          selectedDate.month == day.month &&
                          selectedDate.day == day.day,
                    );
                    final isToday = _isSameDay(day, now);

                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _selectedColor
                            : isToday
                                ? _selectedColor.withValues(alpha: 0.3)
                                : null,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected || isToday
                              ? Colors.transparent
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
                                : isToday
                                    ? _selectedColor
                                    : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (_selectedYearlyDates.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Selected dates (${_selectedYearlyDates.length}):',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _selectedYearlyDates.map((date) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Chip(
                    label: Text(
                      '${_getMonthName(date.month)} ${date.day}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _selectedYearlyDates.remove(date);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Helper method for adding hourly times
  Future<void> _addHourlyTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select a time for hourly reminders',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              entryModeIconColor: Theme.of(context).colorScheme.onSurface,
              helpTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Check if time is not already added
        bool timeExists = _hourlyTimes.any(
          (time) => time.hour == picked.hour && time.minute == picked.minute,
        );

        if (!timeExists) {
          _hourlyTimes.add(picked);
          // Sort times in chronological order
          _hourlyTimes.sort((a, b) {
            final aMinutes = a.hour * 60 + a.minute;
            final bMinutes = b.hour * 60 + b.minute;
            return aMinutes.compareTo(bMinutes);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This time is already selected'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  Widget _buildWeekdaySelector() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        return FilterChip(
          label: Text(weekdays[index]),
          selected: _selectedWeekdays.contains(dayNumber),
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

  Widget _buildCustomizationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customization',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose a color:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: _selectedColor == color
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

  Widget _buildNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: Text(
                _selectedFrequency == HabitFrequency.hourly
                    ? 'Get reminded at your selected times throughout the day'
                    : 'Get reminded to complete your habit',
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (!value) {
                    _notificationTime = null;
                  }
                });
              },
            ),
            // Show time picker for non-hourly habits when notifications OR alarms are enabled
            if ((_notificationsEnabled || _alarmEnabled) &&
                _selectedFrequency != HabitFrequency.hourly) ...[
              const SizedBox(height: 8),
              ListTile(
                title: Text(_alarmEnabled ? 'Alarm Time' : 'Notification Time'),
                subtitle: Text(
                  _notificationTime != null
                      ? _notificationTime!.format(context)
                      : 'Not set',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _selectNotificationTime,
              ),
            ],
            // Show info for hourly habits
            if ((_notificationsEnabled || _alarmEnabled) &&
                _selectedFrequency == HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
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
                    Expanded(
                      child: Text(
                        'Hourly habits will send notifications every hour during your active hours (8 AM - 10 PM)',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: _selectedColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Alarm Settings Section
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Alarm Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _selectedColor,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Alarms'),
              subtitle: Text(
                _alarmEnabled
                    ? 'Use system alarms instead of notifications (more persistent)'
                    : 'Alarms are more persistent than notifications and will wake the device',
              ),
              value: _alarmEnabled,
              onChanged: (value) {
                setState(() {
                  _alarmEnabled = value;
                  if (value) {
                    // When enabling alarms, disable notifications (mutually exclusive)
                    _notificationsEnabled = false;
                  }
                });
              },
            ),
            if (_alarmEnabled) ...[
              const SizedBox(height: 8),
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
    }
  }

  Future<void> _selectNotificationTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              entryModeIconColor: Theme.of(context).colorScheme.onSurface,
              helpTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  Future<void> _selectAlarmSound() async {
    final availableSounds = await HybridAlarmService.getAvailableAlarmSounds();

    if (!mounted) return;

    String? currentlyPlaying;

    final selected = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Select Alarm Sound'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                const Text(
                  'Tap the play button to preview sounds',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableSounds.length,
                    itemBuilder: (context, index) {
                      final sound = availableSounds[index];
                      final soundName = sound['name']!;
                      final soundUri = sound['uri']!;
                      final soundType = sound['type']!;
                      final isSelected = soundName == _selectedAlarmSoundName;
                      final isPlaying = currentlyPlaying == soundUri;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.stop : Icons.play_arrow,
                              color: isPlaying ? Colors.red : Colors.blue,
                            ),
                            onPressed: () async {
                              if (isPlaying) {
                                await HybridAlarmService
                                    .stopAlarmSoundPreview();
                                setDialogState(() {
                                  currentlyPlaying = null;
                                });
                              } else {
                                await HybridAlarmService
                                    .stopAlarmSoundPreview();
                                await HybridAlarmService.playAlarmSoundPreview(
                                  soundUri,
                                );
                                setDialogState(() {
                                  currentlyPlaying = soundUri;
                                });

                                // Auto-stop after 3 seconds
                                Future.delayed(
                                  const Duration(seconds: 3),
                                  () async {
                                    await HybridAlarmService
                                        .stopAlarmSoundPreview();
                                    if (mounted) {
                                      setDialogState(() {
                                        currentlyPlaying = null;
                                      });
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          title: Text(soundName),
                          subtitle: Text(
                            soundType == 'system'
                                ? 'System Sound'
                                : 'Custom Sound',
                            style: TextStyle(
                              fontSize: 12,
                              color: soundType == 'system'
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                          trailing: Radio<String>(
                            value: soundName,
                            // ignore: deprecated_member_use
                            groupValue: _selectedAlarmSoundName,
                            // ignore: deprecated_member_use
                            onChanged: (value) {
                              Navigator.of(context).pop(value);
                            },
                          ),
                          selected: isSelected,
                          onTap: () {
                            if (mounted) {
                              Navigator.of(context).pop(soundName);
                            }
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
              onPressed: () async {
                await HybridAlarmService.stopAlarmSoundPreview();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );

    // Stop any playing sound when dialog closes
    await HybridAlarmService.stopAlarmSoundPreview();

    if (selected != null) {
      setState(() {
        _selectedAlarmSoundName = selected;
      });
    }
  }

  Future<void> _saveHabit() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Validate frequency-specific requirements
      if (_selectedFrequency == HabitFrequency.weekly &&
          _selectedWeekdays.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one day of the week'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedFrequency == HabitFrequency.monthly &&
          _selectedMonthDays.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one day of the month'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedFrequency == HabitFrequency.yearly &&
          _selectedYearlyDates.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one date for the year'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedFrequency == HabitFrequency.hourly && _hourlyTimes.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select at least one time for hourly reminders',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedFrequency == HabitFrequency.hourly &&
          _selectedWeekdays.isEmpty) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select at least one day of the week for hourly habits',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Validate time for non-hourly habits when notifications or alarms are enabled
      if ((_notificationsEnabled || _alarmEnabled) &&
          _selectedFrequency != HabitFrequency.hourly &&
          _notificationTime == null) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _alarmEnabled
                  ? 'Please select an alarm time'
                  : 'Please select a notification time',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final databaseAsync = ref.read(databaseProvider);
      final database = databaseAsync.value;

      if (database == null) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database not available'),
            backgroundColor: Colors.red,
          ),
        );
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

      // Create habit - use health-integrated creation if health integration is enabled
      final Habit habit;
      if (_enableHealthIntegration && _selectedHealthDataType != null) {
        // Create health-integrated habit with custom threshold and level
        final baseHabit = await HealthEnhancedHabitCreationService
            .createHealthIntegratedHabit(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          frequency: _selectedFrequency,
          category: _selectedCategory,
          healthDataType: _selectedHealthDataType,
          customThreshold: _customThreshold,
          thresholdLevel: _thresholdLevel,
        );

        // Update with UI-specific properties
        baseHabit.colorValue = _selectedColor.toARGB32();
        baseHabit.targetCount = 1;
        baseHabit.notificationsEnabled = _notificationsEnabled;
        baseHabit.notificationTime = notificationDateTime;
        baseHabit.selectedWeekdays = _selectedWeekdays;
        baseHabit.selectedMonthDays = _selectedMonthDays;
        baseHabit.hourlyTimes = _hourlyTimes
            .map(
              (time) =>
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            )
            .toList();
        baseHabit.selectedYearlyDates = _selectedYearlyDates
            .map(
              (date) =>
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            )
            .toList();

        // Add alarm settings
        baseHabit.alarmEnabled = _alarmEnabled;
        baseHabit.alarmSoundName = _selectedAlarmSoundName;

        habit = baseHabit;
      } else {
        // Create regular habit
        habit = Habit.create(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          colorValue: _selectedColor.toARGB32(),
          frequency: _selectedFrequency,
          targetCount: 1,
          notificationsEnabled: _notificationsEnabled,
          notificationTime: notificationDateTime,
          selectedWeekdays: _selectedWeekdays,
          selectedMonthDays: _selectedMonthDays,
          hourlyTimes: _hourlyTimes
              .map(
                (time) =>
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              )
              .toList(),
          selectedYearlyDates: _selectedYearlyDates
              .map(
                (date) =>
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              )
              .toList(),
          alarmEnabled: _alarmEnabled,
          alarmSoundName: _selectedAlarmSoundName,
        );
      }

      // Get HabitService instead of direct database access
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

      await habitService.addHabit(habit);

      // Log health integration status and analyze for additional mappings
      if (_enableHealthIntegration && _selectedHealthDataType != null) {
        AppLogger.info(
          'Health-integrated habit created: ${habit.name} -> $_selectedHealthDataType (threshold: $_customThreshold, level: $_thresholdLevel)',
        );
      } else {
        // Analyze habit for automatic health mapping
        try {
          final healthMapping =
              await HealthHabitMappingService.analyzeHabitForHealthMapping(
            habit,
          );
          if (healthMapping != null) {
            AppLogger.info(
              'Automatic health mapping found for habit: ${habit.name} -> ${healthMapping.healthDataType}',
            );
          }
        } catch (e) {
          AppLogger.warning(
            'Error analyzing habit for health mapping: ${habit.name} - $e',
          );
        }
      }

      // Schedule notifications/alarms if enabled (non-blocking)
      if (_notificationsEnabled || _alarmEnabled) {
        try {
          await NotificationService.scheduleHabitNotifications(habit);
          AppLogger.info(
            'Notifications/alarms scheduled successfully for habit: ${habit.name}',
          );
        } catch (e) {
          AppLogger.warning(
            'Failed to schedule notifications/alarms for habit: ${habit.name} - $e',
          );
          // Don't block habit creation if notification scheduling fails
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Habit created but notifications/alarms could not be scheduled: ${e.toString()}',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }

      // Log the habit creation
      if (mounted) {
        AppLogger.info('Habit created: ${habit.name}');
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Habit "${habit.name}" created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppLogger.error('Failed to create habit', e);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create habit: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

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

  // Get category suggestions based on habit name and description
  List<String> _getCategorySuggestions() {
    final habitName = _nameController.text;
    final habitDescription = _descriptionController.text;

    if (habitName.isEmpty) return [];

    return CategorySuggestionService.getCategorySuggestions(
      habitName,
      habitDescription.isEmpty ? null : habitDescription,
    );
  }

  // Update category suggestions when text changes
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
              'Get inspired with personalized habit suggestions based on popular categories and your health data.',
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
            ...suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: suggestion.isHealthBased
                          ? Colors.green.withValues(alpha: 0.1)
                          : Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        _getIconData(suggestion.icon),
                        color: suggestion.isHealthBased
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      suggestion.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      suggestion.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (suggestion.isHealthBased)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Health',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _applySuggestion(suggestion),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  /// Get icon for suggestion type
  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'health':
        return Icons.health_and_safety;
      case 'productivity':
        return Icons.work;
      case 'learning':
        return Icons.school;
      case 'personal':
        return Icons.self_improvement;
      case 'social':
        return Icons.people;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'lifestyle':
        return Icons.home;
      case 'hobbies':
        return Icons.palette;
      default:
        return Icons.category;
    }
  }

  /// Get IconData from string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'checklist':
        return Icons.checklist;
      case 'email':
        return Icons.email;
      case 'psychology':
        return Icons.psychology;
      case 'menu_book':
        return Icons.menu_book;
      case 'translate':
        return Icons.translate;
      case 'school':
        return Icons.school;
      case 'favorite':
        return Icons.favorite;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'phone':
        return Icons.phone;
      case 'message':
        return Icons.message;
      case 'people':
        return Icons.people;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'trending_up':
        return Icons.trending_up;
      case 'savings':
        return Icons.savings;
      case 'bed':
        return Icons.bed;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'palette':
        return Icons.palette;
      case 'music_note':
        return Icons.music_note;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'bedtime':
        return Icons.bedtime;
      case 'water_drop':
        return Icons.water_drop;
      case 'monitor_weight':
        return Icons.monitor_weight;
      case 'medication':
        return Icons.medication;
      case 'health_and_safety':
        return Icons.health_and_safety;
      default:
        return Icons.star;
    }
  }

  /// Apply a habit suggestion to the form
  void _applySuggestion(HabitSuggestion suggestion) {
    setState(() {
      _nameController.text = suggestion.name;
      _descriptionController.text = suggestion.description;
      _selectedCategory = suggestion.category;
      _selectedFrequency = suggestion.frequency;

      // Enable health integration if it's a health-based suggestion
      if (suggestion.isHealthBased) {
        _enableHealthIntegration = true;
        _selectedHealthDataType = suggestion.healthDataType;
        _customThreshold = suggestion.suggestedThreshold;
        _thresholdLevel = 'custom';
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied suggestion: ${suggestion.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
