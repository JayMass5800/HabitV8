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
    Key? key,
    this.initialRRuleString,
    this.initialStartDate,
    required this.onRRuleChanged,
    this.initialFrequency,
  }) : super(key: key);

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
  Set<int> _selectedWeekdays = {};
  
  // Monthly options
  Set<int> _selectedMonthDays = {};
  
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
    // TODO: Parse existing RRule string to populate UI
    // For now, we'll start fresh in advanced mode
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
      final days = _selectedWeekdays
          .map((day) => _weekdayToRRule(day))
          .join(',');
      parts.add('BYDAY=$days');
    }
    
    // Monthly: BYMONTHDAY
    if (_frequency == HabitFrequency.monthly && _selectedMonthDays.isNotEmpty) {
      final days = _selectedMonthDays.toList()..sort();
      parts.add('BYMONTHDAY=${days.join(',')}');
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
    
    return Row(
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
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
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
          'Select days of the month:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
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
      ],
    );
  }
  
  Widget _buildYearlySelector() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    initialDate: _untilDate ?? DateTime.now().add(const Duration(days: 30)),
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
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
            }).toList(),
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
