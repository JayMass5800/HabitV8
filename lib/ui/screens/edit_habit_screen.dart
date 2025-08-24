import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/model/habit.dart';
import '../../services/notification_service.dart';
import '../../services/health_habit_mapping_service.dart';
import '../../services/category_suggestion_service.dart';
import '../../services/hybrid_alarm_service.dart';

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
  late int _snoozeDelayMinutes;

  late final List<int> _selectedWeekdays;
  late final List<int> _selectedMonthDays;
  late int _targetCount;
  late int
  _originalHashCode; // Store original hash code for notification management
  final List<TimeOfDay> _hourlyTimes = []; // For hourly habits

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
    _snoozeDelayMinutes = widget.habit.snoozeDelayMinutes;
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
        actions: [TextButton(onPressed: _saveHabit, child: const Text('Save'))],
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(31, (index) {
        final day = index + 1;
        final isSelected = _selectedMonthDays.contains(day);

        return FilterChip(
          label: Text(day.toString()),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              if (isSelected) {
                _selectedMonthDays.remove(day);
              } else {
                _selectedMonthDays.add(day);
              }
            });
          },
          selectedColor: _selectedColor.withValues(alpha: 0.2),
          checkmarkColor: _selectedColor,
        );
      }),
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
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No times selected. Add times when you want to be reminded.',
                    style: TextStyle(color: Colors.grey.shade600),
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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              activeThumbColor: _selectedColor,
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
              activeThumbColor: _selectedColor,
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
              const SizedBox(height: 8),
              ListTile(
                title: const Text('Snooze Delay'),
                subtitle: Text('$_snoozeDelayMinutes minutes'),
                trailing: const Icon(Icons.snooze),
                onTap: _selectSnoozeDelay,
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
                                await HybridAlarmService.stopAlarmSoundPreview();
                                setDialogState(() {
                                  currentlyPlaying = null;
                                });
                              } else {
                                await HybridAlarmService.stopAlarmSoundPreview();
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
                                    await HybridAlarmService.stopAlarmSoundPreview();
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

  Future<void> _selectSnoozeDelay() async {
    final delays = [5, 10, 15, 20, 30, 45, 60];

    final selected = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Snooze Delay'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: delays.length,
            itemBuilder: (context, index) {
              final delay = delays[index];
              final isSelected = delay == _snoozeDelayMinutes;

              return RadioListTile<int>(
                title: Text('$delay minutes'),
                value: delay,
                // ignore: deprecated_member_use
                groupValue: _snoozeDelayMinutes,
                selected: isSelected,
                // ignore: deprecated_member_use
                onChanged: (value) {
                  Navigator.of(context).pop(value);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      setState(() {
        _snoozeDelayMinutes = selected;
      });
    }
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate schedule selections
    if (_selectedFrequency == HabitFrequency.weekly &&
        _selectedWeekdays.isEmpty) {
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

    // Only require notification time for non-hourly habits
    if (_notificationsEnabled &&
        _selectedFrequency != HabitFrequency.hourly &&
        _notificationTime == null) {
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

      // Save alarm settings
      widget.habit.alarmEnabled = _alarmEnabled;
      widget.habit.alarmSoundName = _selectedAlarmSoundName;
      widget.habit.snoozeDelayMinutes = _snoozeDelayMinutes;

      // Save to database
      await widget.habit.save();

      // Analyze habit for health mapping after saving
      try {
        final healthMapping =
            await HealthHabitMappingService.analyzeHabitForHealthMapping(
              widget.habit,
            );
        if (healthMapping != null) {
          // Log successful health mapping analysis
          // Health mapping found for habit: ${widget.habit.name} -> ${healthMapping.healthDataType}
        }
      } catch (e) {
        // Log health mapping analysis error but don't fail the save operation
        // Error analyzing habit for health mapping: $e
      }

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
      await NotificationService.scheduleHabitNotifications(habit);
    } catch (e) {
      // Error scheduling notifications/alarms
    }
  }
}
