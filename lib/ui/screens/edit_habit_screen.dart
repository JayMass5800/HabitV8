import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/model/habit.dart';
import '../../services/notification_service.dart';

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
  late final List<int> _selectedWeekdays;
  late final List<int> _selectedMonthDays;
  late int _targetCount;
  late int _originalHashCode; // Store original hash code for notification management

  final List<String> _categories = [
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Personal',
    'Social',
    'Finance',
    'Mindfulness',
  ];

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
    _descriptionController = TextEditingController(text: widget.habit.description ?? '');

    _selectedFrequency = widget.habit.frequency;
    _selectedCategory = widget.habit.category;
    _selectedColor = Color(widget.habit.colorValue);
    _notificationsEnabled = widget.habit.notificationsEnabled;
    // Convert DateTime? to TimeOfDay? for UI compatibility
    _notificationTime = widget.habit.notificationTime != null
        ? TimeOfDay.fromDateTime(widget.habit.notificationTime!)
        : null;
    _selectedWeekdays = List<int>.from(widget.habit.weeklySchedule);
    _selectedMonthDays = List<int>.from(widget.habit.monthlySchedule);
    _targetCount = widget.habit.targetCount;
    _originalHashCode = widget.habit.hashCode; // Store original for notification cleanup
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
          TextButton(
            onPressed: _saveHabit,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildFrequencySection(),
              const SizedBox(height: 24),
              _buildNotificationSection(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
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
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedColor: _selectedColor.withValues(alpha: 0.2),
                  checkmarkColor: _selectedColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Color',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelector(),
            ],
            if (_selectedFrequency == HabitFrequency.monthly) ...[
              const SizedBox(height: 16),
              Text(
                'Select Days of Month',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildMonthDaySelector(),
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
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: Text(_selectedFrequency == HabitFrequency.hourly 
                  ? 'Get reminded at your selected times throughout the day'
                  : 'Get reminded when it\'s time for your habit'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: _selectedColor,
            ),
            // Only show time picker for non-hourly habits
            if (_notificationsEnabled && _selectedFrequency != HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Notification Time'),
                subtitle: Text(_notificationTime != null
                    ? _notificationTime!.format(context)
                    : 'No time selected'),
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
            if (_notificationsEnabled && _selectedFrequency == HabitFrequency.hourly) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _selectedColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: _selectedColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hourly habits will send notifications every hour during your active hours (8 AM - 10 PM)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _selectedColor,
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

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate schedule selections
    if (_selectedFrequency == HabitFrequency.weekly && _selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day for weekly habits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFrequency == HabitFrequency.monthly && _selectedMonthDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day for monthly habits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Only require notification time for non-hourly habits
    if (_notificationsEnabled && _selectedFrequency != HabitFrequency.hourly && _notificationTime == null) {
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
          ? DateTime(2000, 1, 1, _notificationTime!.hour, _notificationTime!.minute)
          : null;
      widget.habit.weeklySchedule = List<int>.from(_selectedWeekdays);
      widget.habit.monthlySchedule = List<int>.from(_selectedMonthDays);

      // Save to database
      await widget.habit.save();

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
            await NotificationService.cancelNotification(_originalHashCode + weekday);
          }
          break;

        case HabitFrequency.monthly:
          for (int monthDay in widget.habit.monthlySchedule) {
            await NotificationService.cancelNotification(_originalHashCode + monthDay + 1000);
          }
          break;

        case HabitFrequency.hourly:
          for (int i = 1; i <= 24; i++) {
            await NotificationService.cancelNotification(_originalHashCode + i + 2000);
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
    if (!habit.notificationsEnabled) {
      return;
    }

    // For hourly habits, use the notification service directly
    if (habit.frequency == HabitFrequency.hourly) {
      try {
        await NotificationService.scheduleHabitNotifications(habit);
      } catch (e) {
        // Error scheduling hourly notifications
      }
      return;
    }

    // For other frequencies, require notification time
    if (habit.notificationTime == null) {
      return;
    }

    final notificationTime = habit.notificationTime!;
    final hour = notificationTime.hour;
    final minute = notificationTime.minute;

    try {
      switch (habit.frequency) {
        case HabitFrequency.daily:
          final now = DateTime.now();
          DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, minute);
          
          // If the time has passed today, schedule for tomorrow
          if (nextNotification.isBefore(now)) {
            nextNotification = nextNotification.add(const Duration(days: 1));
          }
          
          await NotificationService.scheduleHabitNotification(
            id: habit.hashCode,
            habitId: habit.id,
            title: '🎯 ${habit.name}',
            body: 'Time to complete your daily habit! Keep your streak going.',
            scheduledTime: nextNotification,
          );
          break;

        case HabitFrequency.weekly:
          for (int weekday in habit.weeklySchedule) {
            final now = DateTime.now();
            DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, minute);

            while (nextNotification.weekday != weekday) {
              nextNotification = nextNotification.add(const Duration(days: 1));
            }

            if (nextNotification.isBefore(now)) {
              nextNotification = nextNotification.add(const Duration(days: 7));
            }

            await NotificationService.scheduleHabitNotification(
              id: habit.hashCode + weekday,
              habitId: habit.id,
              title: '🎯 ${habit.name}',
              body: 'Time to complete your habit! Don\'t break your streak.',
              scheduledTime: nextNotification,
            );
          }
          break;

        case HabitFrequency.monthly:
          for (int monthDay in habit.monthlySchedule) {
            final now = DateTime.now();
            DateTime nextNotification = DateTime(now.year, now.month, monthDay, hour, minute);

            if (nextNotification.isBefore(now)) {
              nextNotification = DateTime(now.year, now.month + 1, monthDay, hour, minute);
            }

            await NotificationService.scheduleHabitNotification(
              id: habit.hashCode + monthDay + 1000,
              habitId: habit.id,
              title: '🎯 ${habit.name}',
              body: 'Monthly habit reminder - keep up the great work!',
              scheduledTime: nextNotification,
            );
          }
          break;

        case HabitFrequency.yearly:
          // For yearly habits, schedule next occurrence
          final now = DateTime.now();
          DateTime nextNotification = DateTime(now.year + 1, now.month, now.day, hour, minute);

          await NotificationService.scheduleHabitNotification(
            id: habit.hashCode,
            habitId: habit.id,
            title: '🎯 ${habit.name}',
            body: 'Annual habit reminder - time for your yearly goal!',
            scheduledTime: nextNotification,
          );
          break;

        case HabitFrequency.hourly:
          // This case is handled above
          break;
      }
    } catch (e) {
      // Error scheduling notifications
    }
  }
}
