import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import '../domain/model/habit.dart';
import 'logging_service.dart';

/// Calendar service that integrates with table_calendar for consistent habit display
/// This service manages calendar sync preferences and enhances the existing table_calendar
/// implementation with additional features like event highlighting and sync status.
class CalendarService {
  static bool _isInitialized = false;
  static DeviceCalendarPlugin? _deviceCalendarPlugin;
  static String? _selectedCalendarId;

  /// Initialize the calendar service
  static Future<bool> initialize([ProviderContainer? container]) async {
    if (_isInitialized) return true;

    try {
      _deviceCalendarPlugin = DeviceCalendarPlugin();

      // Request calendar permissions for device calendar integration
      final permissionGranted = await _requestCalendarPermissions();
      if (!permissionGranted) {
        AppLogger.warning(
          'Calendar permissions not granted - using table_calendar only',
        );
        // Still initialize successfully since we can use table_calendar without device permissions
      } else {
        // Load selected calendar ID from preferences
        final prefs = await SharedPreferences.getInstance();
        _selectedCalendarId = prefs.getString('selected_calendar_id');
        AppLogger.info(
          'Calendar service initialized with device calendar support',
        );
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize calendar service', e);
      return false;
    }
  }

  /// Reinitialize the calendar service after permissions are granted
  static Future<bool> reinitializeAfterPermissions() async {
    try {
      AppLogger.info(
          'Reinitializing calendar service after permissions granted');

      // Reset initialization flag to force reinitialization
      _isInitialized = false;
      _deviceCalendarPlugin = null;

      // Reinitialize
      final success = await initialize();

      if (success) {
        AppLogger.info('Calendar service reinitialized successfully');
      } else {
        AppLogger.error('Failed to reinitialize calendar service');
      }

      return success;
    } catch (e) {
      AppLogger.error('Error during calendar service reinitialization', e);
      return false;
    }
  }

  /// Request calendar permissions (for future device calendar integration)
  static Future<bool> _requestCalendarPermissions() async {
    try {
      final status = await Permission.calendarFullAccess.request();
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error requesting calendar permissions', e);
      return false;
    }
  }

  /// Check if calendar permissions are granted
  static Future<bool> hasPermissions() async {
    try {
      final status = await Permission.calendarFullAccess.status;
      return status.isGranted;
    } catch (e) {
      AppLogger.error('Error checking calendar permissions', e);
      return false;
    }
  }

  /// Check if calendar sync is enabled in settings
  static Future<bool> isCalendarSyncEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('calendar_sync_enabled') ?? false;
    } catch (e) {
      AppLogger.error('Error checking calendar sync setting', e);
      return false;
    }
  }

  /// Set calendar sync enabled status
  static Future<void> setCalendarSyncEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('calendar_sync_enabled', enabled);
      AppLogger.info('Calendar sync ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Error setting calendar sync status', e);
    }
  }

  /// Get available device calendars
  static Future<List<Calendar>> getAvailableCalendars() async {
    if (_deviceCalendarPlugin == null) {
      AppLogger.warning('Device calendar plugin not initialized');
      return [];
    }

    try {
      final permissionsGranted = await hasPermissions();
      if (!permissionsGranted) {
        AppLogger.warning('Calendar permissions not granted');
        return [];
      }

      final calendarsResult = await _deviceCalendarPlugin!.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        // Filter to only writable calendars
        final writableCalendars = calendarsResult.data!
            .where((calendar) => !(calendar.isReadOnly ?? true))
            .toList();
        AppLogger.info('Found ${writableCalendars.length} writable calendars');
        return writableCalendars;
      } else {
        AppLogger.error(
          'Failed to retrieve calendars: ${calendarsResult.errors}',
        );
        return [];
      }
    } catch (e) {
      AppLogger.error('Error getting available calendars', e);
      return [];
    }
  }

  /// Set the selected calendar for habit sync
  static Future<bool> setSelectedCalendar(String calendarId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_calendar_id', calendarId);
      _selectedCalendarId = calendarId;
      AppLogger.info('Selected calendar set to: $calendarId');
      return true;
    } catch (e) {
      AppLogger.error('Error setting selected calendar', e);
      return false;
    }
  }

  /// Get the currently selected calendar
  static String? getSelectedCalendarId() {
    return _selectedCalendarId;
  }

  /// Get the selected calendar details
  static Future<Calendar?> getSelectedCalendar() async {
    if (_selectedCalendarId == null) return null;

    final calendars = await getAvailableCalendars();
    try {
      return calendars.firstWhere((cal) => cal.id == _selectedCalendarId);
    } catch (e) {
      AppLogger.warning('Selected calendar not found: $_selectedCalendarId');
      return null;
    }
  }

  /// Get habits that are due on a specific date (integrates with table_calendar)
  static List<Habit> getHabitsForDate(DateTime date, List<Habit> allHabits) {
    return allHabits.where((habit) => isHabitDueOnDate(habit, date)).toList();
  }

  /// Check if a habit is due on a specific date (matches calendar_screen logic)
  static bool isHabitDueOnDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        final weekday = date.weekday;
        // Check both old and new fields for backward compatibility
        return habit.selectedWeekdays.contains(weekday) ||
            habit.weeklySchedule.contains(weekday);
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        final weekday = date.weekday;
        // Check both old and new fields for backward compatibility
        return habit.selectedWeekdays.contains(weekday) ||
            habit.weeklySchedule.contains(weekday);
      case HabitFrequency.monthly:
        final day = date.day;
        // Check both old and new fields for backward compatibility
        return habit.selectedMonthDays.contains(day) ||
            habit.monthlySchedule.contains(day);
      case HabitFrequency.yearly:
        return habit.selectedYearlyDates.any((dateStr) {
          final parts = dateStr.split('-');
          if (parts.length == 3) {
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            return month == date.month && day == date.day;
          }
          return false;
        });
    }
  }

  /// Check if a habit is completed on a specific date (matches calendar_screen logic)
  static bool isHabitCompletedOnDate(Habit habit, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate == dateOnly;
    });
  }

  /// Get completion statistics for a date (for calendar markers)
  static Map<String, int> getDateCompletionStats(
    DateTime date,
    List<Habit> allHabits,
  ) {
    final habitsForDate = getHabitsForDate(date, allHabits);
    final completedHabits = habitsForDate
        .where((habit) => isHabitCompletedOnDate(habit, date))
        .length;

    return {
      'total': habitsForDate.length,
      'completed': completedHabits,
      'remaining': habitsForDate.length - completedHabits,
    };
  }

  /// Get habits for a date range (useful for calendar view optimization)
  static Map<DateTime, List<Habit>> getHabitsForDateRange(
    DateTime startDate,
    DateTime endDate,
    List<Habit> allHabits,
  ) {
    final Map<DateTime, List<Habit>> habitsByDate = {};

    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      habitsByDate[currentDate] = getHabitsForDate(currentDate, allHabits);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return habitsByDate;
  }

  /// Sync habit changes to calendar display (called when habits are modified)
  static Future<void> syncHabitChanges(
    Habit habit, {
    bool isDeleted = false,
  }) async {
    AppLogger.info(
      'syncHabitChanges called for habit "${habit.name}", isDeleted: $isDeleted',
    );

    final syncEnabled = await isCalendarSyncEnabled();
    if (!syncEnabled) {
      AppLogger.debug(
        'Calendar sync disabled, skipping habit sync for "${habit.name}"',
      );
      return;
    }

    if (_deviceCalendarPlugin == null) {
      AppLogger.warning(
        'Device calendar plugin not initialized, skipping sync for "${habit.name}"',
      );
      return;
    }

    if (_selectedCalendarId == null) {
      AppLogger.warning(
        'No calendar selected, skipping sync for "${habit.name}"',
      );
      return;
    }

    try {
      if (isDeleted) {
        AppLogger.info(
          'Calendar sync: Removing habit "${habit.name}" from calendar',
        );
        await removeHabitFromDeviceCalendar(habit);
      } else {
        AppLogger.info(
          'Calendar sync: Syncing habit "${habit.name}" to calendar',
        );
        await _syncHabitToDeviceCalendar(habit);
      }
    } catch (e) {
      AppLogger.error(
        'Error syncing habit changes to calendar for "${habit.name}"',
        e,
      );
    }
  }

  /// Sync a habit to the device calendar
  static Future<void> _syncHabitToDeviceCalendar(Habit habit) async {
    if (_deviceCalendarPlugin == null || _selectedCalendarId == null) {
      AppLogger.debug('Device calendar not configured, skipping sync');
      return;
    }

    try {
      final hasPermissions = await CalendarService.hasPermissions();
      if (!hasPermissions) {
        AppLogger.warning('Calendar permissions not granted');
        return;
      }

      // First, remove any existing events for this habit to avoid duplicates
      await removeHabitFromDeviceCalendar(habit);

      // Create calendar events for the next 90 days based on habit frequency
      // Extended from 30 to 90 days to reduce renewal frequency
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 90));

      for (DateTime date = now;
          date.isBefore(endDate);
          date = date.add(const Duration(days: 1))) {
        if (isHabitDueOnDate(habit, date)) {
          await createHabitEvent(habit, date);
        }
      }

      AppLogger.info('Synced habit "${habit.name}" to device calendar');
    } catch (e) {
      AppLogger.error('Error syncing habit to device calendar', e);
    }
  }

  /// Create a calendar event for a habit on a specific date
  static Future<void> createHabitEvent(Habit habit, DateTime date) async {
    if (_deviceCalendarPlugin == null || _selectedCalendarId == null) return;

    try {
      // For hourly habits, create multiple events for each scheduled time
      if (habit.frequency == HabitFrequency.hourly &&
          habit.hourlyTimes.isNotEmpty) {
        for (String timeString in habit.hourlyTimes) {
          await _createSingleHabitEvent(habit, date, timeString);
        }
      } else {
        // For non-hourly habits, use the habit's notification time or default to midnight (00:00)
        String timeString = '00:00';
        if (habit.notificationTime != null) {
          timeString =
              '${habit.notificationTime!.hour.toString().padLeft(2, '0')}:${habit.notificationTime!.minute.toString().padLeft(2, '0')}';
        }
        await _createSingleHabitEvent(habit, date, timeString);
      }
    } catch (e) {
      AppLogger.error('Error creating habit event', e);
    }
  }

  /// Create a single calendar event for a habit at a specific time
  static Future<void> _createSingleHabitEvent(
    Habit habit,
    DateTime date,
    String timeString,
  ) async {
    if (_deviceCalendarPlugin == null || _selectedCalendarId == null) return;

    try {
      // Parse the time string (format: "HH:mm")
      final timeParts = timeString.split(':');
      final hour = int.tryParse(timeParts[0]) ??
          0; // Default to midnight (0) instead of 9 AM
      final minute =
          timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

      final event = Event(_selectedCalendarId);
      event.title = habit.name;
      event.description =
          '${habit.description ?? 'Habit reminder'}\n\nHabit ID: ${habit.id}'; // Include habit ID for tracking

      // Create DateTime objects first, then convert to TZDateTime
      final startDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
      final endDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute + 30,
      );

      // Use local timezone with proper conversion
      final localLocation = tz.local;

      // Convert to TZDateTime using the local timezone
      event.start = tz.TZDateTime.from(startDateTime, localLocation);
      event.end = tz.TZDateTime.from(endDateTime, localLocation);

      // Add habit-specific properties
      event.allDay = false;
      event.availability = Availability.Busy;

      AppLogger.info(
        'Creating calendar event for habit "${habit.name}" on ${date.toIso8601String()}',
      );
      AppLogger.info(
        'Parsed time: $hour:${minute.toString().padLeft(2, '0')} from timeString: $timeString',
      );
      AppLogger.info('Local DateTime: $startDateTime');
      AppLogger.info('TZDateTime start: ${event.start}');
      AppLogger.info('TZDateTime end: ${event.end}');
      AppLogger.info('Local timezone: ${localLocation.name}');
      AppLogger.debug(
        'Event details: title="${event.title}", start=${event.start}, end=${event.end}, calendarId=$_selectedCalendarId',
      );

      final result = await _deviceCalendarPlugin!.createOrUpdateEvent(event);
      if (result?.isSuccess == true && result?.data != null) {
        // Store the event ID for future deletion
        await _storeEventId(habit.id, result!.data!, date);
        AppLogger.info(
          'Successfully created calendar event for habit "${habit.name}" with ID: ${result.data}',
        );
      } else {
        String errorMessage = 'Unknown error';
        if (result != null && result.errors.isNotEmpty) {
          errorMessage = result.errors.join(', ');
        }
        AppLogger.error(
          'Failed to create calendar event for habit "${habit.name}": $errorMessage',
        );
      }
    } catch (e) {
      AppLogger.error('Error creating habit event', e);
    }
  }

  /// Store event ID for a habit and date
  static Future<void> _storeEventId(
    String habitId,
    String eventId,
    DateTime date,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key =
          'habit_event_${habitId}_${date.toIso8601String().split('T')[0]}';
      await prefs.setString(key, eventId);
      AppLogger.debug(
        'Stored event ID $eventId for habit $habitId on ${date.toIso8601String()}',
      );
    } catch (e) {
      AppLogger.error('Error storing event ID', e);
    }
  }

  /// Get stored event IDs for a habit
  static Future<List<String>> _getStoredEventIds(String habitId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) => key.startsWith('habit_event_$habitId'))
          .toList();
      final eventIds = <String>[];

      for (final key in keys) {
        final eventId = prefs.getString(key);
        if (eventId != null) {
          eventIds.add(eventId);
        }
      }

      AppLogger.debug(
        'Found ${eventIds.length} stored event IDs for habit $habitId',
      );
      return eventIds;
    } catch (e) {
      AppLogger.error('Error getting stored event IDs', e);
      return [];
    }
  }

  /// Remove stored event IDs for a habit
  static Future<void> _removeStoredEventIds(String habitId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) => key.startsWith('habit_event_$habitId'))
          .toList();

      for (final key in keys) {
        await prefs.remove(key);
      }

      AppLogger.debug(
        'Removed ${keys.length} stored event IDs for habit $habitId',
      );
    } catch (e) {
      AppLogger.error('Error removing stored event IDs', e);
    }
  }

  /// Remove habit events from device calendar
  static Future<void> removeHabitFromDeviceCalendar(Habit habit) async {
    if (_deviceCalendarPlugin == null || _selectedCalendarId == null) return;

    try {
      // Get all stored event IDs for this habit
      final eventIds = await _getStoredEventIds(habit.id);

      if (eventIds.isEmpty) {
        AppLogger.info(
          'No stored event IDs found for habit "${habit.name}", trying alternative removal method',
        );
        await _removeHabitEventsBySearch(habit);
        return;
      }

      // Delete each event
      int deletedCount = 0;
      for (final eventId in eventIds) {
        try {
          final result = await _deviceCalendarPlugin!.deleteEvent(
            _selectedCalendarId,
            eventId,
          );
          if (result.isSuccess == true) {
            deletedCount++;
            AppLogger.debug(
              'Deleted calendar event $eventId for habit "${habit.name}"',
            );
          } else {
            AppLogger.warning(
              'Failed to delete calendar event $eventId: ${result.errors}',
            );
          }
        } catch (e) {
          AppLogger.error('Error deleting individual event $eventId', e);
        }
      }

      // Remove the stored event IDs
      await _removeStoredEventIds(habit.id);

      AppLogger.info(
        'Removed $deletedCount calendar events for habit "${habit.name}"',
      );
    } catch (e) {
      AppLogger.error('Error removing habit from device calendar', e);
    }
  }

  /// Alternative method to remove habit events by searching for them
  static Future<void> _removeHabitEventsBySearch(Habit habit) async {
    if (_deviceCalendarPlugin == null || _selectedCalendarId == null) return;

    try {
      // Get events from the calendar for the next 30 days
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 30));

      final eventsResult = await _deviceCalendarPlugin!.retrieveEvents(
        _selectedCalendarId,
        RetrieveEventsParams(startDate: now, endDate: endDate),
      );

      if (eventsResult.isSuccess && eventsResult.data != null) {
        final habitEvents = eventsResult.data!.where((event) {
          // Match by title and check if description contains habit ID
          return event.title == habit.name &&
              (event.description?.contains('Habit ID: ${habit.id}') ?? false);
        }).toList();

        int deletedCount = 0;
        for (final event in habitEvents) {
          if (event.eventId != null) {
            try {
              final result = await _deviceCalendarPlugin!.deleteEvent(
                _selectedCalendarId,
                event.eventId!,
              );
              if (result.isSuccess == true) {
                deletedCount++;
                AppLogger.debug(
                  'Deleted calendar event ${event.eventId} for habit "${habit.name}" by search',
                );
              }
            } catch (e) {
              AppLogger.error(
                'Error deleting event ${event.eventId} by search',
                e,
              );
            }
          }
        }

        AppLogger.info(
          'Removed $deletedCount calendar events for habit "${habit.name}" by search method',
        );
      }
    } catch (e) {
      AppLogger.error('Error removing habit events by search', e);
    }
  }

  /// Get calendar event markers for table_calendar
  static List<String> getEventMarkersForDate(
    DateTime date,
    List<Habit> allHabits,
  ) {
    final stats = getDateCompletionStats(date, allHabits);
    final markers = <String>[];

    if (stats['total']! > 0) {
      if (stats['completed']! == stats['total']!) {
        markers.add('all_complete');
      } else if (stats['completed']! > 0) {
        markers.add('partial_complete');
      } else {
        markers.add('none_complete');
      }
    }

    return markers;
  }

  /// Get calendar sync status for display in settings
  static Future<Map<String, dynamic>> getCalendarSyncStatus() async {
    final syncEnabled = await isCalendarSyncEnabled();
    final hasCalendarPermissions = await hasPermissions();
    final selectedCalendar = await getSelectedCalendar();
    final availableCalendars = await getAvailableCalendars();

    return {
      'enabled': syncEnabled,
      'hasPermissions': hasCalendarPermissions,
      'mode': 'device_calendar', // Now using device calendar integration
      'deviceCalendarAvailable': _deviceCalendarPlugin != null,
      'selectedCalendar': selectedCalendar?.name,
      'selectedCalendarId': _selectedCalendarId,
      'availableCalendarsCount': availableCalendars.length,
      'isInitialized': _isInitialized,
    };
  }

  /// Debug method to print current calendar sync status
  static Future<void> debugCalendarStatus() async {
    AppLogger.info('=== Calendar Service Debug Status ===');
    AppLogger.info('Initialized: $_isInitialized');
    AppLogger.info('Device calendar plugin: ${_deviceCalendarPlugin != null}');
    AppLogger.info('Selected calendar ID: $_selectedCalendarId');

    final syncEnabled = await isCalendarSyncEnabled();
    AppLogger.info('Sync enabled: $syncEnabled');

    final hasCalendarPermissions = await hasPermissions();
    AppLogger.info('Has permissions: $hasCalendarPermissions');

    final availableCalendars = await getAvailableCalendars();
    AppLogger.info('Available calendars: ${availableCalendars.length}');

    for (final calendar in availableCalendars) {
      AppLogger.info('  - ${calendar.name} (${calendar.id})');
    }

    AppLogger.info('=== End Debug Status ===');
  }

  /// Debug method to test habit frequency detection
  static void debugHabitFrequency(Habit habit, DateTime testDate) {
    AppLogger.info('=== Habit Frequency Debug for "${habit.name}" ===');
    AppLogger.info('Frequency: ${habit.frequency}');
    AppLogger.info('Test date: ${testDate.toIso8601String()}');

    switch (habit.frequency) {
      case HabitFrequency.weekly:
        AppLogger.info('Weekly schedule: ${habit.weeklySchedule}');
        AppLogger.info('Test date weekday: ${testDate.weekday}');
        AppLogger.info(
          'Is due: ${habit.weeklySchedule.contains(testDate.weekday)}',
        );
        break;
      case HabitFrequency.monthly:
        AppLogger.info('Monthly schedule: ${habit.monthlySchedule}');
        AppLogger.info('Test date day: ${testDate.day}');
        AppLogger.info(
          'Is due: ${habit.monthlySchedule.contains(testDate.day)}',
        );
        break;
      case HabitFrequency.yearly:
        AppLogger.info('Yearly dates: ${habit.selectedYearlyDates}');
        AppLogger.info(
          'Test date month/day: ${testDate.month}/${testDate.day}',
        );
        final isDue = habit.selectedYearlyDates.any((dateStr) {
          final parts = dateStr.split('-');
          if (parts.length == 3) {
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            return month == testDate.month && day == testDate.day;
          }
          return false;
        });
        AppLogger.info('Is due: $isDue');
        break;
      default:
        AppLogger.info('Daily/hourly habit - always due');
    }

    final actualResult = isHabitDueOnDate(habit, testDate);
    AppLogger.info('Final result: $actualResult');
    AppLogger.info('=== End Habit Frequency Debug ===');
  }

  /// Enhanced habit filtering for calendar view
  static List<Habit> filterHabitsForCalendar(
    List<Habit> allHabits, {
    String? category,
    bool? completedOnly,
    DateTime? forDate,
  }) {
    var filteredHabits = allHabits;

    // Filter by category
    if (category != null && category != 'All') {
      filteredHabits =
          filteredHabits.where((habit) => habit.category == category).toList();
    }

    // Filter by date if specified
    if (forDate != null) {
      filteredHabits = getHabitsForDate(forDate, filteredHabits);
    }

    // Filter by completion status if specified
    if (completedOnly != null && forDate != null) {
      filteredHabits = filteredHabits
          .where(
            (habit) => isHabitCompletedOnDate(habit, forDate) == completedOnly,
          )
          .toList();
    }

    return filteredHabits;
  }

  /// Clean up old event IDs (for events older than 30 days)
  static Future<void> cleanupOldEventIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) => key.startsWith('habit_event_'))
          .toList();
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      int removedCount = 0;
      for (final key in keys) {
        // Extract date from key format: habit_event_{habitId}_{date}
        final parts = key.split('_');
        if (parts.length >= 4) {
          try {
            final dateStr =
                parts.sublist(3).join('_'); // Handle dates with underscores
            final eventDate = DateTime.parse(dateStr);

            if (eventDate.isBefore(cutoffDate)) {
              await prefs.remove(key);
              removedCount++;
            }
          } catch (e) {
            // If we can't parse the date, remove the key as it's likely corrupted
            await prefs.remove(key);
            removedCount++;
          }
        }
      }

      if (removedCount > 0) {
        AppLogger.info('Cleaned up $removedCount old calendar event IDs');
      }
    } catch (e) {
      AppLogger.error('Error cleaning up old event IDs', e);
    }
  }

  /// Sync all habits to calendar (useful for bulk operations)
  static Future<void> syncAllHabitsToCalendar(List<Habit> habits) async {
    AppLogger.info(
      'syncAllHabitsToCalendar called with ${habits.length} habits',
    );

    if (!await isCalendarSyncEnabled()) {
      AppLogger.debug('Calendar sync disabled, skipping bulk sync');
      return;
    }

    if (_deviceCalendarPlugin == null) {
      AppLogger.warning(
        'Device calendar plugin not initialized, skipping bulk sync',
      );
      return;
    }

    if (_selectedCalendarId == null) {
      AppLogger.warning('No calendar selected, skipping bulk sync');
      return;
    }

    AppLogger.info(
      'Starting bulk sync of ${habits.length} habits to calendar $_selectedCalendarId',
    );

    int successCount = 0;
    int errorCount = 0;

    for (final habit in habits) {
      try {
        AppLogger.debug('Bulk syncing habit: "${habit.name}"');
        await _syncHabitToDeviceCalendar(habit);
        successCount++;
        // Small delay to avoid overwhelming the calendar API
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        errorCount++;
        AppLogger.error(
          'Error syncing habit "${habit.name}" during bulk sync',
          e,
        );
      }
    }

    // Clean up old event IDs after bulk sync
    await cleanupOldEventIds();

    AppLogger.info(
      'Completed bulk sync: $successCount successful, $errorCount errors',
    );
  }

  /// Remove all habit events from the calendar when sync is disabled
  static Future<void> removeAllHabitsFromCalendar(List<Habit> habits) async {
    AppLogger.info(
      'removeAllHabitsFromCalendar called with ${habits.length} habits',
    );

    if (_deviceCalendarPlugin == null) {
      AppLogger.warning(
        'Device calendar plugin not initialized, skipping bulk removal',
      );
      return;
    }

    if (_selectedCalendarId == null) {
      AppLogger.warning('No calendar selected, skipping bulk removal');
      return;
    }

    AppLogger.info(
      'Starting bulk removal of ${habits.length} habits from calendar $_selectedCalendarId',
    );

    int successCount = 0;
    int errorCount = 0;

    for (final habit in habits) {
      try {
        AppLogger.debug('Bulk removing habit: "${habit.name}"');
        await removeHabitFromDeviceCalendar(habit);
        successCount++;
        // Small delay to avoid overwhelming the calendar API
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        errorCount++;
        AppLogger.error(
          'Error removing habit "${habit.name}" during bulk removal',
          e,
        );
      }
    }

    // Clean up all stored event IDs
    await _clearAllStoredEventIds();

    AppLogger.info(
      'Completed bulk removal: $successCount successful, $errorCount errors',
    );
  }

  /// Clear all stored event IDs from preferences
  static Future<void> _clearAllStoredEventIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final eventIdKeys =
          keys.where((key) => key.startsWith('habit_events_')).toList();

      for (final key in eventIdKeys) {
        await prefs.remove(key);
      }

      AppLogger.info('Cleared ${eventIdKeys.length} stored event ID entries');
    } catch (e) {
      AppLogger.error('Error clearing stored event IDs', e);
    }
  }
}
