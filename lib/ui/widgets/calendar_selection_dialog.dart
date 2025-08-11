import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import '../../services/calendar_service.dart';

class CalendarSelectionDialog extends StatefulWidget {
  const CalendarSelectionDialog({super.key});

  @override
  State<CalendarSelectionDialog> createState() => _CalendarSelectionDialogState();
}

class _CalendarSelectionDialogState extends State<CalendarSelectionDialog> {
  List<Calendar> _calendars = [];
  String? _selectedCalendarId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final calendars = await CalendarService.getAvailableCalendars();
      final currentSelection = CalendarService.getSelectedCalendarId();

      setState(() {
        _calendars = calendars;
        _selectedCalendarId = currentSelection;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load calendars: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Calendar'),
      content: SizedBox(
        width: double.maxFinite,
        child: _buildContent(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedCalendarId != null ? _saveSelection : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCalendars,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_calendars.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No writable calendars found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please create a calendar in your device\'s calendar app first.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose which calendar to sync your habits to:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _calendars.length,
            itemBuilder: (context, index) {
              final calendar = _calendars[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  value: calendar.id!,
                  groupValue: _selectedCalendarId,
                  onChanged: (value) {
                    setState(() {
                      _selectedCalendarId = value;
                    });
                  },
                  title: Text(
                    calendar.name ?? 'Unnamed Calendar',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: calendar.accountName != null
                      ? Text(
                          'Account: ${calendar.accountName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : null,
                  secondary: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: calendar.color != null 
                          ? Color(calendar.color!) 
                          : Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }



  Future<void> _saveSelection() async {
    if (_selectedCalendarId == null) return;

    try {
      final success = await CalendarService.setSelectedCalendar(_selectedCalendarId!);
      if (success && mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calendar selection saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save selection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}