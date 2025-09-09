import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/calendar_service.dart';
import '../../data/database.dart';
import '../../services/logging_service.dart';

class CalendarSelectionDialog extends ConsumerStatefulWidget {
  const CalendarSelectionDialog({super.key});

  @override
  ConsumerState<CalendarSelectionDialog> createState() =>
      _CalendarSelectionDialogState();
}

class _CalendarSelectionDialogState
    extends ConsumerState<CalendarSelectionDialog> {
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

      AppLogger.info('Loading calendars in dialog...');

      // First check if calendar service is initialized
      final isInitialized = await CalendarService.initialize();
      if (!isInitialized) {
        throw Exception('Calendar service initialization failed');
      }

      // Check permissions explicitly
      final hasPermissions = await CalendarService.hasPermissions();
      AppLogger.info('Calendar permissions granted: $hasPermissions');

      if (!hasPermissions) {
        setState(() {
          _error =
              'Calendar permissions are required. Please enable calendar access in your device settings and try again.';
          _isLoading = false;
        });
        return;
      }

      // Get calendars with additional logging
      final calendars = await CalendarService.getAvailableCalendars();
      final currentSelection = CalendarService.getSelectedCalendarId();

      AppLogger.info('Retrieved ${calendars.length} calendars');
      for (final calendar in calendars) {
        AppLogger.info(
            'Calendar: ${calendar.name} (${calendar.id}) - ReadOnly: ${calendar.isReadOnly ?? false}');
      }

      setState(() {
        _calendars = calendars;
        _selectedCalendarId = currentSelection;
        _isLoading = false;
      });

      if (calendars.isEmpty) {
        setState(() {
          _error =
              'No writable calendars found on your device. Please ensure you have at least one calendar account set up.';
        });
      }
    } catch (e) {
      AppLogger.error('Error loading calendars in dialog', e);
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
      content: SizedBox(width: double.maxFinite, child: _buildContent()),
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
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
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
        height: 250,
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
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Please ensure you have at least one calendar account set up on your device.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await openAppSettings();
                    },
                    child: const Text('App Settings'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _loadCalendars,
                    child: const Text('Retry'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await CalendarService.debugCalendarStatus();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Debug info logged - check console'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text(
                  'Debug Info',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
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
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCalendarId = calendar.id!;
                      });
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedCalendarId == calendar.id!
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: _selectedCalendarId == calendar.id!
                          ? Center(
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedCalendarId = calendar.id!;
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
                  trailing: Container(
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
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Setting up calendar sync...'),
            ],
          ),
        ),
      );

      final success = await CalendarService.setSelectedCalendar(
        _selectedCalendarId!,
      );

      if (success) {
        // Get all existing habits and sync them to the calendar
        final habitServiceAsync = ref.read(habitServiceProvider);
        final habitService = habitServiceAsync.value;

        if (habitService != null) {
          final allHabits = await habitService.getAllHabits();
          AppLogger.info(
            'Syncing ${allHabits.length} existing habits to calendar',
          );

          // Sync all habits to the newly selected calendar
          await CalendarService.syncAllHabitsToCalendar(allHabits);

          AppLogger.info('Successfully synced all habits to calendar');
        }

        if (mounted) {
          // Close loading dialog
          Navigator.of(context).pop();
          // Close selection dialog
          Navigator.of(context).pop(true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar selection saved and habits synced! 📅'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save calendar selection'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.error('Error saving calendar selection', e);
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
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
