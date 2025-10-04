import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../domain/model/habit.dart';
import '../../services/notification_service.dart';
import '../../services/category_suggestion_service.dart';
import '../../services/alarm_manager_service.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final Habit habit;

  const EditHabitScreen({super.key, required this.habit});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  late HabitFrequency _selectedFrequency;
  late String _selectedCategory;
  late Color _selectedColor;
  late bool _notificationsEnabled;
  TimeOfDay? _notificationTime;

  // Alarm-related fields
  late bool _alarmEnabled;
  String? _selectedAlarmSoundName;
  String? _selectedAlarmSoundUri;

  late final List<int> _selectedWeekdays;
  late final List<int> _selectedMonthDays;
  late int _targetCount;
  late int
      _originalHashCode; // Store original hash code for notification management
  final List<TimeOfDay> _hourlyTimes = []; // For hourly habits
  bool _isSaving = false;

  // Calendar-related state variables
  DateTime _focusedMonth = DateTime.now(); // For calendar navigation
  final List<DateTime> _selectedYearlyDates = []; // For yearly habits
  DateTime? _singleDateTime; // For single habits

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

    // Initialize controllers and state with existing habit data
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController = TextEditingController(
      text: widget.habit.description ?? '',
    );

    _selectedFrequency = widget.habit.frequency;
    _selectedCategory = widget.habit.category;
    _selectedColor = Color(widget.habit.colorValue);
    _notificationsEnabled = widget.habit.notificationsEnabled;
    // Convert DateTime? to TimeOfDay? for UI compatibility
    _notificationTime = widget.habit.notificationTime != null
        ? TimeOfDay.fromDateTime(widget.habit.notificationTime!)
        : null;

    // Initialize alarm settings
    _alarmEnabled = widget.habit.alarmEnabled;
    _selectedAlarmSoundName = widget.habit.alarmSoundName;
    _selectedAlarmSoundUri = widget.habit.alarmSoundUri;
    // Load from new fields first, fall back to old fields for backward compatibility
    _selectedWeekdays = widget.habit.selectedWeekdays.isNotEmpty
        ? List<int>.from(widget.habit.selectedWeekdays)
        : List<int>.from(widget.habit.weeklySchedule);
    _selectedMonthDays = widget.habit.selectedMonthDays.isNotEmpty
        ? List<int>.from(widget.habit.selectedMonthDays)
        : List<int>.from(widget.habit.monthlySchedule);
    _targetCount = widget.habit.targetCount;
    _originalHashCode =
        widget.habit.hashCode; // Store original for notification cleanup

    // Initialize hourly times from existing habit data
    _hourlyTimes.clear();
    for (final timeString in widget.habit.hourlyTimes) {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          _hourlyTimes.add(TimeOfDay(hour: hour, minute: minute));
        }
      }
    }

    // Initialize yearly dates from existing habit data
    _selectedYearlyDates.clear();
    for (final dateString in widget.habit.selectedYearlyDates) {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        if (year != null && month != null && day != null) {
          _selectedYearlyDates.add(DateTime(year, month, day));
        }
      }
    }

    // Initialize single datetime from existing habit data
    _singleDateTime = widget.habit.singleDateTime;

    // Add listeners to text controllers for category suggestions
    _nameController.addListener(_onHabitTextChanged);
    _descriptionController.addListener(_onHabitTextChanged);
  }

  void _onHabitTextChanged() {
    // Trigger rebuild to update category suggestions
    setState(() {});
  }

  List<String> _getCategorySuggestions() {
    return CategorySuggestionService.getCategorySuggestions(
      _nameController.text,
      _descriptionController.text,
    );
  }

  Widget _buildCategorySection() {
    final suggestions = _getCategorySuggestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _selectedCategory,
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
        title: const Text('Edit Habit'),
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
              'Color',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colors.map((color) {
                final isSelected = color == _selectedColor;
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
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
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

  Widget _buildFrequencySection() {
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
                final isSelected = frequency == _selectedFrequency;
                return FilterChip(
                  label: Text(_getFrequencyDisplayName(frequency)),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedFrequency = frequency;
                      // Clear schedule when frequency changes
                      _selectedWeekdays.clear();
                      _selectedMonthDays.clear();
                    });
                  },
                  selectedColor: _selectedColor.withValues(alpha: 0.2),
                  checkmarkColor: _selectedColor,
                );
              }).toList(),
            ),
            if (_selectedFrequency == HabitFrequency.weekly) ...[
              const SizedBox(height: 16),
              Text(
                'Select Days',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelector(),
            ],
            if (_selectedFrequency == HabitFrequency.monthly) ...[
              const SizedBox(height: 16),
              Text(
                'Select Days of Month',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildMonthDaySelector(),
            ],
            if (_selectedFrequency == HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
              Text(
                'Select Days',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelector(),
              const SizedBox(height: 16),
              _buildHourlyTimeSelector(),
            ],
            if (_selectedFrequency == HabitFrequency.yearly) ...[
              const SizedBox(height: 16),
              Text(
                'Select Yearly Dates',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildYearlyCalendarSelector(),
            ],
            if (_selectedFrequency == HabitFrequency.single) ...[
              const SizedBox(height: 16),
              Text(
                'Select Date and Time',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _buildSingleDateTimeSelector(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(7, (index) {
        final weekdayNumber = index + 1;
        final isSelected = _selectedWeekdays.contains(weekdayNumber);

        return FilterChip(
          label: Text(weekdays[index]),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              if (isSelected) {
                _selectedWeekdays.remove(weekdayNumber);
              } else {
                _selectedWeekdays.add(weekdayNumber);
              }
            });
          },
          selectedColor: _selectedColor.withValues(alpha: 0.2),
          checkmarkColor: _selectedColor,
        );
      }),
    );
  }

  Widget _buildMonthDaySelector() {
    final now = tz.TZDateTime.now(tz.local);
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
              'Select days of the month for your habit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
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
          if (_selectedMonthDays.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Selected days: ${_selectedMonthDays.map((d) => d.toString()).join(', ')}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _selectedColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHourlyTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Times',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Time'),
              onPressed: _addHourlyTime,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_hourlyTimes.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No times selected. Add times when you want to be reminded.',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
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
                backgroundColor: _selectedColor.withValues(alpha: 0.1),
                side: BorderSide(color: _selectedColor.withValues(alpha: 0.3)),
              );
            }).toList(),
          ),
        if (_hourlyTimes.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_hourlyTimes.length} times selected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _selectedColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }

  Future<void> _addHourlyTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // Check if time already exists
      bool timeExists = _hourlyTimes.any(
        (time) => time.hour == picked.hour && time.minute == picked.minute,
      );

      if (!timeExists) {
        setState(() {
          _hourlyTimes.add(picked);
          // Sort times chronologically
          _hourlyTimes.sort((a, b) {
            if (a.hour != b.hour) return a.hour.compareTo(b.hour);
            return a.minute.compareTo(b.minute);
          });
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This time is already selected'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  Widget _buildYearlyCalendarSelector() {
    final now = tz.TZDateTime.now(tz.local);

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
                  'Select specific dates for your yearly habit',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              TableCalendar<DateTime>(
                firstDay: DateTime(2020, 1, 1),
                lastDay: DateTime(2030, 12, 31),
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
                                : isToday
                                    ? _selectedColor
                                    : Theme.of(context).colorScheme.onSurface,
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
                    backgroundColor: _selectedColor.withValues(alpha: 0.1),
                    side: BorderSide(
                        color: _selectedColor.withValues(alpha: 0.3)),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
                    : 'Get reminded when it\'s time for your habit',
              ),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return _selectedColor;
                  }
                  return null;
                },
              ),
            ),
            // Show time picker for non-hourly habits when notifications OR alarms are enabled
            if ((_notificationsEnabled || _alarmEnabled) &&
                _selectedFrequency != HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
              ListTile(
                title: Text(_alarmEnabled ? 'Alarm Time' : 'Notification Time'),
                subtitle: Text(
                  _notificationTime != null
                      ? _notificationTime!.format(context)
                      : 'No time selected',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _notificationTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _notificationTime = time;
                    });
                  }
                },
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
              thumbColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return _selectedColor;
                  }
                  return null;
                },
              ),
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
      case HabitFrequency.single:
        return 'Single';
    }
  }

  String _getSoundTypeDisplay(String soundType) {
    switch (soundType) {
      case 'system_alarm':
        return 'System Alarm';
      case 'system_ringtone':
        return 'System Ringtone';
      case 'system_notification':
        return 'System Notification';
      case 'custom':
        return 'Custom Sound';
      case 'system':
        return 'System Sound';
      default:
        return soundType.startsWith('system_')
            ? 'System Sound'
            : 'Custom Sound';
    }
  }

  Color _getSoundTypeColor(String soundType) {
    switch (soundType) {
      case 'system_alarm':
        return Colors.red;
      case 'system_ringtone':
        return Colors.blue;
      case 'system_notification':
        return Colors.orange;
      case 'custom':
        return Colors.green;
      case 'system':
        return Colors.blue;
      default:
        return soundType.startsWith('system_') ? Colors.blue : Colors.green;
    }
  }

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
                          'Tap the play button to preview sounds. System alarms are recommended for best reliability.',
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
                      final soundType = sound['type']!;
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
                                      .playAlarmSoundPreview(
                                    soundUri,
                                  );
                                  setDialogState(() {
                                    currentlyPlaying = soundUri;
                                  });

                                  // Auto-stop after 4 seconds
                                  Future.delayed(
                                    const Duration(seconds: 4),
                                    () async {
                                      await AlarmManagerService
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
                          ),
                          title: Text(soundName),
                          subtitle: Text(
                            _getSoundTypeDisplay(soundType),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getSoundTypeColor(soundType),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? _selectedColor
                                  : Colors.transparent,
                            ),
                            child: Radio<String>(
                              value: soundName,
                              // ignore: deprecated_member_use
                              groupValue: _selectedAlarmSoundName,
                              // ignore: deprecated_member_use
                              onChanged: (value) {
                                Navigator.of(context).pop({
                                  'name': soundName,
                                  'uri': soundUri,
                                });
                              },
                              fillColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return _selectedColor;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          selected: isSelected,
                          onTap: () {
                            if (mounted) {
                              Navigator.of(context).pop({
                                'name': soundName,
                                'uri': soundUri,
                              });
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
                await AlarmManagerService.stopAlarmSoundPreview();
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
    await AlarmManagerService.stopAlarmSoundPreview();

    if (selected != null) {
      setState(() {
        _selectedAlarmSoundName = selected['name'];
        _selectedAlarmSoundUri = selected['uri'];
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

    // Validate schedule selections
    if (_selectedFrequency == HabitFrequency.weekly &&
        _selectedWeekdays.isEmpty) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day for weekly habits'),
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
          content: Text('Please select at least one day for monthly habits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFrequency == HabitFrequency.hourly &&
        (_selectedWeekdays.isEmpty || _hourlyTimes.isEmpty)) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one day and one time for hourly habits',
          ),
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
          content: Text('Please select at least one date for yearly habits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFrequency == HabitFrequency.single &&
        _singleDateTime == null) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date and time for single habits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Only require notification time for non-hourly habits
    if (_notificationsEnabled &&
        _selectedFrequency != HabitFrequency.hourly &&
        _notificationTime == null) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a notification time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // First, cancel existing notifications using the original hash code
      await _cancelExistingNotifications();

      // Update the habit with new values
      widget.habit.name = _nameController.text.trim();
      widget.habit.description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();
      widget.habit.category = _selectedCategory;
      widget.habit.colorValue = _selectedColor.toARGB32();
      widget.habit.frequency = _selectedFrequency;
      widget.habit.targetCount = _targetCount;
      widget.habit.notificationsEnabled = _notificationsEnabled;
      // Convert TimeOfDay? back to DateTime? for storage
      widget.habit.notificationTime = _notificationTime != null
          ? DateTime(
              2000,
              1,
              1,
              _notificationTime!.hour,
              _notificationTime!.minute,
            )
          : null;
      // Save to both old and new fields for backward compatibility
      widget.habit.weeklySchedule = List<int>.from(_selectedWeekdays);
      widget.habit.selectedWeekdays = List<int>.from(_selectedWeekdays);
      widget.habit.monthlySchedule = List<int>.from(_selectedMonthDays);
      widget.habit.selectedMonthDays = List<int>.from(_selectedMonthDays);
      // Save hourly times
      widget.habit.hourlyTimes = _hourlyTimes
          .map(
            (time) =>
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
          )
          .toList();

      // Save yearly dates
      widget.habit.selectedYearlyDates = _selectedYearlyDates
          .map((date) =>
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}')
          .toList();

      // Save single datetime
      widget.habit.singleDateTime = _singleDateTime;

      // Save alarm settings
      widget.habit.alarmEnabled = _alarmEnabled;
      widget.habit.alarmSoundName = _selectedAlarmSoundName;
      widget.habit.alarmSoundUri = _selectedAlarmSoundUri;

      // Save to database
      await widget.habit.save();

      // Phase 4: Auto-generate RRule when editing habits (except single)
      // This seamlessly upgrades legacy habits to the modern RRule system
      if (_selectedFrequency != HabitFrequency.single) {
        try {
          // Use the habit's built-in conversion method
          widget.habit
              .getOrCreateRRule(); // Auto-converts and sets usesRRule flag
          await widget.habit.save(); // Save again to persist RRule changes
          debugPrint('✅ Auto-upgraded habit to RRule: ${widget.habit.name}');
        } catch (e) {
          debugPrint(
              '⚠️ Failed to auto-generate RRule for edited habit, using legacy format: $e');
          // Not critical - habit will work with legacy frequency system
        }
      }

      // Health mapping is no longer supported
      // Health integration has been removed from the app

      // Schedule new notifications with the updated habit
      await _scheduleHabitNotifications(widget.habit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating habit: $e'),
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

  /// Cancel existing notifications for the habit before updating
  Future<void> _cancelExistingNotifications() async {
    if (!widget.habit.notificationsEnabled) {
      return;
    }

    try {
      switch (widget.habit.frequency) {
        case HabitFrequency.daily:
          await NotificationService.cancelNotification(_originalHashCode);
          break;

        case HabitFrequency.weekly:
          for (int weekday in widget.habit.weeklySchedule) {
            await NotificationService.cancelNotification(
              _originalHashCode + weekday,
            );
          }
          break;

        case HabitFrequency.monthly:
          for (int monthDay in widget.habit.monthlySchedule) {
            await NotificationService.cancelNotification(
              _originalHashCode + monthDay + 1000,
            );
          }
          break;

        case HabitFrequency.hourly:
          for (int i = 1; i <= 24; i++) {
            await NotificationService.cancelNotification(
              _originalHashCode + i + 2000,
            );
          }
          break;

        case HabitFrequency.yearly:
          await NotificationService.cancelNotification(_originalHashCode);
          break;

        case HabitFrequency.single:
          await NotificationService.cancelNotification(_originalHashCode);
          break;
      }
      // Cancelled existing notifications for habit
    } catch (e) {
      // Error cancelling notifications: $e
    }
  }

  /// Schedule notifications for the updated habit based on its frequency
  Future<void> _scheduleHabitNotifications(Habit habit) async {
    // Skip if both notifications and alarms are disabled
    if (!habit.notificationsEnabled && !habit.alarmEnabled) {
      return;
    }

    // Use the comprehensive notification service that handles both notifications and alarms
    try {
      // Pass isNewHabit: false (default) - editing existing habit, need to cancel old notifications
      await NotificationService.scheduleHabitNotifications(
        habit,
        isNewHabit: false,
      );
    } catch (e) {
      // Error scheduling notifications/alarms
    }
  }

  // Helper method for selecting single date/time
  Future<void> _selectSingleDateTime() async {
    // First select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _singleDateTime ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now()
          .add(const Duration(days: 365 * 5)), // 5 years into future
      helpText: 'Select the date for this habit',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              headerBackgroundColor: _selectedColor,
              headerForegroundColor: Colors.white,
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Theme.of(context).colorScheme.onSurface;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return _selectedColor;
                }
                return null;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    if (!mounted) return;

    // Then select time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _singleDateTime != null
          ? TimeOfDay.fromDateTime(_singleDateTime!)
          : TimeOfDay.now(),
      helpText: 'Select the time for this habit (24-hour format)',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Theme.of(context).colorScheme.surface,
                hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
                dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
                dialHandColor: _selectedColor,
                dialTextColor: Theme.of(context).colorScheme.onSurface,
                entryModeIconColor: Theme.of(context).colorScheme.onSurface,
                helpTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime != null && mounted) {
      setState(() {
        _singleDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  // Build single date/time selector for one-off habits
  Widget _buildSingleDateTimeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_singleDateTime == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: Colors.grey.shade600,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No date and time selected',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _selectSingleDateTime,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Select Date & Time'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedColor.withValues(alpha: 0.1),
                  border: Border.all(color: _selectedColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      color: _selectedColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected Date & Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _selectedColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_getMonthName(_singleDateTime!.month)} ${_singleDateTime!.day}, ${_singleDateTime!.year}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      '${_singleDateTime!.hour.toString().padLeft(2, '0')}:${_singleDateTime!.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _selectedColor,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _selectSingleDateTime,
                          icon: const Icon(Icons.edit),
                          label: const Text('Change'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _singleDateTime = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
