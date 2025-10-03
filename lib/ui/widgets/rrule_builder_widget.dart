import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/rrule_service.dart';
import '../../domain/model/habit.dart';

/// RRule Builder Widget - Visual interface for creating recurrence patterns
///
/// This widget provides a user-friendly interface for building RRule patterns
/// that comply with RFC 5545 (iCalendar) specification.
///
/// Features:
/// - Simple and Advanced modes
/// - Real-time preview of next 5 occurrences
/// - Human-readable pattern summary
/// - Support for all frequency types
/// - Termination options (Never, After X, Until Date)
class RRuleBuilderWidget extends StatefulWidget {
  final String? initialRRuleString;
  final DateTime? initialStartDate;
  final Function(String? rruleString, DateTime startDate) onRRuleChanged;
  final HabitFrequency? initialFrequency; // For simple mode

  const RRuleBuilderWidget({
    super.key,
    this.initialRRuleString,
    this.initialStartDate,
    required this.onRRuleChanged,
    this.initialFrequency,
  });

  @override
  State<RRuleBuilderWidget> createState() => _RRuleBuilderWidgetState();
}

class _RRuleBuilderWidgetState extends State<RRuleBuilderWidget> {
  // Mode toggle
  bool _isAdvancedMode = false;

  // Common fields
  late DateTime _startDate;
  HabitFrequency _frequency = HabitFrequency.daily;
  int _interval = 1;

  // Termination options
  _TerminationType _terminationType = _TerminationType.never;
  int _count = 10;
  DateTime? _untilDate;

  // Weekly options
  final Set<int> _selectedWeekdays = {};

  // Monthly options
  final Set<int> _selectedMonthDays = {};
  _MonthlyPatternType _monthlyPatternType =
      _MonthlyPatternType.onDays; // New: Day of month vs. position
  int _monthlyWeekdayPosition =
      1; // New: 1=First, 2=Second, 3=Third, 4=Fourth, -1=Last
  int _monthlyWeekday = 1; // New: 1=Monday, 2=Tuesday, etc.

  // Yearly options
  int _yearlyMonth = 1;
  int _yearlyDay = 1;

  // Preview
  List<DateTime> _previewOccurrences = [];
  String _patternSummary = '';

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate ?? DateTime.now();

    // Initialize from existing RRule or frequency
    if (widget.initialRRuleString != null) {
      _isAdvancedMode = true;
      _parseExistingRRule(widget.initialRRuleString!);
    } else if (widget.initialFrequency != null) {
      _frequency = widget.initialFrequency!;
    }

    _updatePreview();
  }

  void _parseExistingRRule(String rruleString) {
    try {
      final components = RRuleService.parseRRuleToComponents(rruleString);
      if (components == null) return;

      // Parse frequency
      if (components.containsKey('frequency')) {
        switch (components['frequency']) {
          case 'HOURLY':
            _frequency = HabitFrequency.hourly;
            break;
          case 'DAILY':
            _frequency = HabitFrequency.daily;
            break;
          case 'WEEKLY':
            _frequency = HabitFrequency.weekly;
            break;
          case 'MONTHLY':
            _frequency = HabitFrequency.monthly;
            break;
          case 'YEARLY':
            _frequency = HabitFrequency.yearly;
            break;
        }
      }

      // Parse interval
      if (components.containsKey('interval')) {
        _interval = components['interval'];
      }

      // Parse weekdays (for weekly frequency)
      if (components.containsKey('weekdays')) {
        _selectedWeekdays.clear();
        _selectedWeekdays.addAll((components['weekdays'] as List).cast<int>());
      }

      // Parse month days (for monthly frequency - day of month pattern)
      if (components.containsKey('monthDays')) {
        _selectedMonthDays.clear();
        _selectedMonthDays.addAll((components['monthDays'] as List).cast<int>());
        _monthlyPatternType = _MonthlyPatternType.onDays;
      }

      // Parse monthly position pattern (e.g., 2nd Tuesday)
      if (components.containsKey('monthlyWeekdayPosition') &&
          components.containsKey('monthlyWeekday')) {
        _monthlyPatternType = _MonthlyPatternType.onPosition;
        _monthlyWeekdayPosition = components['monthlyWeekdayPosition'];
        _monthlyWeekday = components['monthlyWeekday'];
      }

      // Parse yearly options
      if (components.containsKey('yearlyMonth')) {
        _yearlyMonth = components['yearlyMonth'];
      }
      if (components.containsKey('yearlyDay')) {
        _yearlyDay = components['yearlyDay'];
      }

      // Parse termination options
      if (components.containsKey('count')) {
        _terminationType = _TerminationType.count;
        _count = components['count'];
      } else if (components.containsKey('until')) {
        _terminationType = _TerminationType.until;
        _untilDate = components['until'];
      } else {
        _terminationType = _TerminationType.never;
      }
    } catch (e) {
      // If parsing fails, log it but don't crash - just use defaults
      debugPrint('Failed to parse RRule: $e');
    }
  }

  void _updatePreview() {
    try {
      final rruleString = _buildRRuleString();

      if (rruleString == null) {
        setState(() {
          _previewOccurrences = [];
          _patternSummary = 'Please select frequency options';
        });
        return;
      }

      // Get next 5 occurrences
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 365)); // Look ahead 1 year

      final occurrences = RRuleService.getOccurrences(
        rruleString: rruleString,
        startDate: _startDate,
        rangeStart: now,
        rangeEnd: endDate,
      );

      // Get human-readable summary
      final summary = RRuleService.getRRuleSummary(rruleString);

      setState(() {
        _previewOccurrences = occurrences.take(5).toList();
        _patternSummary = summary;
      });

      // Notify parent
      widget.onRRuleChanged(rruleString, _startDate);
    } catch (e) {
      setState(() {
        _previewOccurrences = [];
        _patternSummary = 'Error: ${e.toString()}';
      });
      widget.onRRuleChanged(null, _startDate);
    }
  }

  String? _buildRRuleString() {
    String freq;
    switch (_frequency) {
      case HabitFrequency.hourly:
        freq = 'HOURLY';
        break;
      case HabitFrequency.daily:
        freq = 'DAILY';
        break;
      case HabitFrequency.weekly:
        freq = 'WEEKLY';
        break;
      case HabitFrequency.monthly:
        freq = 'MONTHLY';
        break;
      case HabitFrequency.yearly:
        freq = 'YEARLY';
        break;
      case HabitFrequency.single:
        return null; // Single events don't use RRule
    }

    final parts = <String>['FREQ=$freq'];

    // Interval
    if (_interval > 1) {
      parts.add('INTERVAL=$_interval');
    }

    // Weekly: BYDAY
    if (_frequency == HabitFrequency.weekly && _selectedWeekdays.isNotEmpty) {
      final days =
          _selectedWeekdays.map((day) => _weekdayToRRule(day)).join(',');
      parts.add('BYDAY=$days');
    }

    // Monthly: Two patterns supported
    if (_frequency == HabitFrequency.monthly) {
      if (_monthlyPatternType == _MonthlyPatternType.onDays) {
        // Pattern: "On day 15, 20 of the month"
        if (_selectedMonthDays.isNotEmpty) {
          final days = _selectedMonthDays.toList()..sort();
          parts.add('BYMONTHDAY=${days.join(',')}');
        }
      } else {
        // Pattern: "On the 2nd Tuesday of the month"
        // Uses BYDAY with position prefix (e.g., "2TU" = 2nd Tuesday, "-1FR" = Last Friday)
        final dayCode = _weekdayToRRule(_monthlyWeekday);
        final positionPrefix =
            _monthlyWeekdayPosition == 0 ? '' : '$_monthlyWeekdayPosition';
        parts.add('BYDAY=$positionPrefix$dayCode');
        // Note: BYSETPOS is an alternative but BYDAY with position is more standard
      }
    }

    // Yearly: BYMONTH and BYMONTHDAY
    if (_frequency == HabitFrequency.yearly) {
      parts.add('BYMONTH=$_yearlyMonth');
      parts.add('BYMONTHDAY=$_yearlyDay');
    }

    // Termination
    switch (_terminationType) {
      case _TerminationType.count:
        parts.add('COUNT=$_count');
        break;
      case _TerminationType.until:
        if (_untilDate != null) {
          final formatted = DateFormat('yyyyMMdd').format(_untilDate!);
          parts.add('UNTIL=${formatted}T235959Z');
        }
        break;
      case _TerminationType.never:
        // No termination clause
        break;
    }

    return parts.join(';');
  }

  String _weekdayToRRule(int weekday) {
    const days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Toggle
        _buildModeToggle(),
        const SizedBox(height: 16),

        // Main Builder UI
        _isAdvancedMode ? _buildAdvancedMode() : _buildSimpleMode(),

        const SizedBox(height: 24),

        // Preview Panel
        _buildPreviewPanel(),
      ],
    );
  }

  Widget _buildModeToggle() {
    return Row(
      children: [
        Text(
          'Schedule Pattern',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isAdvancedMode = !_isAdvancedMode;
            });
          },
          icon: Icon(_isAdvancedMode ? Icons.light_mode : Icons.settings),
          label: Text(_isAdvancedMode ? 'Simple Mode' : 'Advanced Mode'),
        ),
      ],
    );
  }

  Widget _buildSimpleMode() {
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
          children: [
            HabitFrequency.hourly,
            HabitFrequency.daily,
            HabitFrequency.weekly,
            HabitFrequency.monthly,
            HabitFrequency.yearly,
          ].map((freq) {
            return ChoiceChip(
              label: Text(_getFrequencyDisplayName(freq)),
              selected: _frequency == freq,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _frequency = freq;
                    _selectedWeekdays.clear();
                    _selectedMonthDays.clear();
                  });
                  _updatePreview();
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Frequency-specific options
        if (_frequency == HabitFrequency.weekly) _buildWeekdaySelector(),
        if (_frequency == HabitFrequency.monthly) _buildMonthDaySelector(),
        if (_frequency == HabitFrequency.yearly) _buildYearlySelector(),
      ],
    );
  }

  Widget _buildAdvancedMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency
        _buildFrequencySelector(),
        const SizedBox(height: 16),

        // Interval
        _buildIntervalSelector(),
        const SizedBox(height: 16),

        // Frequency-specific options
        if (_frequency == HabitFrequency.weekly) _buildWeekdaySelector(),
        if (_frequency == HabitFrequency.monthly) _buildMonthDaySelector(),
        if (_frequency == HabitFrequency.yearly) _buildYearlySelector(),

        if (_frequency != HabitFrequency.single) ...[
          const SizedBox(height: 16),
          _buildTerminationSelector(),
        ],
      ],
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeats',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<HabitFrequency>(
          value: _frequency,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            HabitFrequency.hourly,
            HabitFrequency.daily,
            HabitFrequency.weekly,
            HabitFrequency.monthly,
            HabitFrequency.yearly,
          ].map((freq) {
            return DropdownMenuItem(
              value: freq,
              child: Text(_getFrequencyDisplayName(freq)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _frequency = value;
                _selectedWeekdays.clear();
                _selectedMonthDays.clear();
              });
              _updatePreview();
            }
          },
        ),
      ],
    );
  }

  Widget _buildIntervalSelector() {
    String unit;
    switch (_frequency) {
      case HabitFrequency.hourly:
        unit = 'hour(s)';
        break;
      case HabitFrequency.daily:
        unit = 'day(s)';
        break;
      case HabitFrequency.weekly:
        unit = 'week(s)';
        break;
      case HabitFrequency.monthly:
        unit = 'month(s)';
        break;
      case HabitFrequency.yearly:
        unit = 'year(s)';
        break;
      case HabitFrequency.single:
        unit = '';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Repeat every',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: _interval.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final interval = int.tryParse(value);
                  if (interval != null && interval > 0) {
                    setState(() {
                      _interval = interval;
                    });
                    _updatePreview();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              unit,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (_interval > 1) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getIntervalExampleText(unit),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getIntervalExampleText(String unit) {
    switch (unit.toLowerCase()) {
      case 'day':
      case 'days':
        return _interval == 2
            ? 'Every other day (Monday, Wednesday, Friday...)'
            : 'Every $_interval days';
      case 'week':
      case 'weeks':
        return _interval == 2
            ? 'Every other week (biweekly)'
            : 'Every $_interval weeks';
      case 'month':
      case 'months':
        return _interval == 2 ? 'Every other month' : 'Every $_interval months';
      case 'year':
      case 'years':
        return _interval == 2 ? 'Every other year' : 'Every $_interval years';
      default:
        return 'Repeats every $_interval $unit';
    }
  }

  Widget _buildWeekdaySelector() {
    const weekdays = [
      (1, 'M'),
      (2, 'T'),
      (3, 'W'),
      (4, 'T'),
      (5, 'F'),
      (6, 'S'),
      (7, 'S'),
    ];
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weekdays.asMap().entries.map((entry) {
            final index = entry.key;
            final weekday = entry.value.$1;

            return FilterChip(
              label: Text(weekdayNames[index]),
              selected: _selectedWeekdays.contains(weekday),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedWeekdays.add(weekday);
                  } else {
                    _selectedWeekdays.remove(weekday);
                  }
                });
                _updatePreview();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Pattern:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 12),

        // Pattern type selector
        SegmentedButton<_MonthlyPatternType>(
          segments: const [
            ButtonSegment(
              value: _MonthlyPatternType.onDays,
              label: Text('On Days'),
              icon: Icon(Icons.calendar_today, size: 16),
            ),
            ButtonSegment(
              value: _MonthlyPatternType.onPosition,
              label: Text('On Position'),
              icon: Icon(Icons.calendar_view_week, size: 16),
            ),
          ],
          selected: {_monthlyPatternType},
          onSelectionChanged: (Set<_MonthlyPatternType> newSelection) {
            setState(() {
              _monthlyPatternType = newSelection.first;
              // Clear selections when switching pattern type
              _selectedMonthDays.clear();
            });
            _updatePreview();
          },
        ),
        const SizedBox(height: 16),

        // Show different UI based on pattern type
        if (_monthlyPatternType == _MonthlyPatternType.onDays) ...[
          Text(
            'Select days of the month:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(31, (index) {
              final day = index + 1;
              return FilterChip(
                label: Text(day.toString()),
                selected: _selectedMonthDays.contains(day),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedMonthDays.add(day);
                    } else {
                      _selectedMonthDays.remove(day);
                    }
                  });
                  _updatePreview();
                },
              );
            }),
          ),
        ] else ...[
          // Position-based pattern (e.g., "2nd Tuesday")
          Text(
            'Select position and day:',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _monthlyWeekdayPosition,
                  decoration: const InputDecoration(
                    labelText: 'Position',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('First')),
                    DropdownMenuItem(value: 2, child: Text('Second')),
                    DropdownMenuItem(value: 3, child: Text('Third')),
                    DropdownMenuItem(value: 4, child: Text('Fourth')),
                    DropdownMenuItem(value: -1, child: Text('Last')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _monthlyWeekdayPosition = value;
                      });
                      _updatePreview();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _monthlyWeekday,
                  decoration: const InputDecoration(
                    labelText: 'Day',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Monday')),
                    DropdownMenuItem(value: 2, child: Text('Tuesday')),
                    DropdownMenuItem(value: 3, child: Text('Wednesday')),
                    DropdownMenuItem(value: 4, child: Text('Thursday')),
                    DropdownMenuItem(value: 5, child: Text('Friday')),
                    DropdownMenuItem(value: 6, child: Text('Saturday')),
                    DropdownMenuItem(value: 7, child: Text('Sunday')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _monthlyWeekday = value;
                      });
                      _updatePreview();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getPositionPreviewText(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _getPositionPreviewText() {
    const positions = {
      1: 'first',
      2: 'second',
      3: 'third',
      4: 'fourth',
      -1: 'last',
    };
    const weekdays = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };

    final position = positions[_monthlyWeekdayPosition] ?? '';
    final weekday = weekdays[_monthlyWeekday] ?? '';

    return 'Example: The $position $weekday of each month';
  }

  Widget _buildYearlySelector() {
    const months = [
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
      'December'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select date:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                value: _yearlyMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(months[index]),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _yearlyMonth = value;
                    });
                    _updatePreview();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _yearlyDay,
                decoration: const InputDecoration(
                  labelText: 'Day',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(31, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text((index + 1).toString()),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _yearlyDay = value;
                    });
                    _updatePreview();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTerminationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ends',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        RadioListTile<_TerminationType>(
          title: const Text('Never'),
          value: _TerminationType.never,
          groupValue: _terminationType,
          onChanged: (value) {
            setState(() {
              _terminationType = value!;
            });
            _updatePreview();
          },
        ),
        RadioListTile<_TerminationType>(
          title: Row(
            children: [
              const Text('After'),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: _count.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    final count = int.tryParse(value);
                    if (count != null && count > 0) {
                      setState(() {
                        _count = count;
                      });
                      if (_terminationType == _TerminationType.count) {
                        _updatePreview();
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              const Text('occurrences'),
            ],
          ),
          value: _TerminationType.count,
          groupValue: _terminationType,
          onChanged: (value) {
            setState(() {
              _terminationType = value!;
            });
            _updatePreview();
          },
        ),
        RadioListTile<_TerminationType>(
          title: Row(
            children: [
              const Text('On date:'),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _untilDate ??
                        DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    setState(() {
                      _untilDate = picked;
                      _terminationType = _TerminationType.until;
                    });
                    _updatePreview();
                  }
                },
                child: Text(
                  _untilDate != null
                      ? DateFormat('MMM d, y').format(_untilDate!)
                      : 'Pick Date',
                ),
              ),
            ],
          ),
          value: _TerminationType.until,
          groupValue: _terminationType,
          onChanged: (value) {
            setState(() {
              _terminationType = value!;
            });
            _updatePreview();
          },
        ),
      ],
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Preview',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pattern summary
          Text(
            _patternSummary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),

          if (_previewOccurrences.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Next ${_previewOccurrences.length} occurrences:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            ..._previewOccurrences.map((date) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMM d, y').format(date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
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
        return 'One-time';
    }
  }
}

enum _TerminationType {
  never,
  count,
  until,
}

enum _MonthlyPatternType {
  onDays, // e.g., "on day 15 of the month"
  onPosition, // e.g., "on the 2nd Tuesday of the month"
}
