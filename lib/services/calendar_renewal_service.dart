import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'calendar_service.dart';
import 'logging_service.dart';

/// Service to handle automatic calendar sync renewal
/// Ensures habit events continue to be created beyond the initial sync period
class CalendarRenewalService {
  static Timer? _renewalTimer;
  static bool _isInitialized = false;
  
  /// Initialize the calendar renewal service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      AppLogger.info('Initializing calendar renewal service');
      
      // Check if calendar sync is enabled
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (!syncEnabled) {
        AppLogger.info('Calendar sync disabled, skipping renewal service initialization');
        return;
      }
      
      // Start the renewal timer
      await _startRenewalTimer();
      
      _isInitialized = true;
      AppLogger.info('Calendar renewal service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize calendar renewal service', e);
    }
  }
  
  /// Start the automatic renewal timer
  static Future<void> _startRenewalTimer() async {
    // Cancel existing timer if any
    _renewalTimer?.cancel();
    
    // Check for renewal every 24 hours
    _renewalTimer = Timer.periodic(const Duration(hours: 24), (timer) async {
      await _performRenewalCheck();
    });
    
    // Also perform an initial check
    await _performRenewalCheck();
    
    AppLogger.info('Calendar renewal timer started');
  }
  
  /// Perform renewal check and extend calendar events if needed
  static Future<void> _performRenewalCheck() async {
    try {
      AppLogger.info('Performing calendar renewal check');
      
      // Check if calendar sync is still enabled
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (!syncEnabled) {
        AppLogger.info('Calendar sync disabled, stopping renewal checks');
        _renewalTimer?.cancel();
        return;
      }
      
      // Get the last renewal date
      final prefs = await SharedPreferences.getInstance();
      final lastRenewalStr = prefs.getString('last_calendar_renewal');
      final now = DateTime.now();
      
      DateTime? lastRenewal;
      if (lastRenewalStr != null) {
        try {
          lastRenewal = DateTime.parse(lastRenewalStr);
        } catch (e) {
          AppLogger.warning('Invalid last renewal date format: $lastRenewalStr');
        }
      }
      
      // Check if renewal is needed (every 30 days or if never renewed)
      bool needsRenewal = false;
      if (lastRenewal == null) {
        needsRenewal = true;
        AppLogger.info('No previous renewal found, performing initial renewal');
      } else {
        final daysSinceRenewal = now.difference(lastRenewal).inDays;
        if (daysSinceRenewal >= 30) {
          needsRenewal = true;
          AppLogger.info('$daysSinceRenewal days since last renewal, renewal needed');
        } else {
          AppLogger.info('$daysSinceRenewal days since last renewal, no renewal needed yet');
        }
      }
      
      if (needsRenewal) {
        await _performCalendarRenewal();
        
        // Update last renewal date
        await prefs.setString('last_calendar_renewal', now.toIso8601String());
        AppLogger.info('Calendar renewal completed and timestamp updated');
      }
    } catch (e) {
      AppLogger.error('Error during calendar renewal check', e);
    }
  }
  
  /// Perform the actual calendar renewal
  static Future<void> _performCalendarRenewal() async {
    try {
      AppLogger.info('Starting calendar renewal process');
      
      // Get all active habits
      final database = HabitDatabase();
      final habits = await database.getAllHabits();
      final activeHabits = habits.where((habit) => !habit.isArchived).toList();
      
      AppLogger.info('Renewing calendar events for ${activeHabits.length} active habits');
      
      // Sync all habits with extended period
      await _syncHabitsWithExtendedPeriod(activeHabits);
      
      AppLogger.info('Calendar renewal process completed');
    } catch (e) {
      AppLogger.error('Error during calendar renewal', e);
    }
  }
  
  /// Sync habits with extended period (90 days instead of 30)
  static Future<void> _syncHabitsWithExtendedPeriod(List<Habit> habits) async {
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (!syncEnabled) {
        AppLogger.debug('Calendar sync disabled, skipping extended sync');
        return;
      }

      if (CalendarService.getSelectedCalendarId() == null) {
        AppLogger.warning('No calendar selected, skipping extended sync');
        return;
      }

      AppLogger.info('Starting extended sync of ${habits.length} habits to calendar');
      
      int successCount = 0;
      int errorCount = 0;
      
      for (final habit in habits) {
        try {
          AppLogger.debug('Extended syncing habit: "${habit.name}"');
          await _syncSingleHabitExtended(habit);
          successCount++;
          
          // Small delay to avoid overwhelming the calendar API
          await Future.delayed(const Duration(milliseconds: 200));
        } catch (e) {
          errorCount++;
          AppLogger.error('Error syncing habit "${habit.name}" during extended sync', e);
        }
      }
      
      AppLogger.info('Completed extended sync: $successCount successful, $errorCount errors');
    } catch (e) {
      AppLogger.error('Error during extended habit sync', e);
    }
  }
  
  /// Sync a single habit with extended 90-day period
  static Future<void> _syncSingleHabitExtended(Habit habit) async {
    try {
      final hasPermissions = await CalendarService.hasPermissions();
      if (!hasPermissions) {
        AppLogger.warning('Calendar permissions not granted');
        return;
      }

      // Create calendar events for the next 90 days (extended period)
      final now = DateTime.now();
      final endDate = now.add(const Duration(days: 90));
      
      int eventsCreated = 0;
      
      for (DateTime date = now; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
        if (CalendarService.isHabitDueOnDate(habit, date)) {
          // Check if event already exists for this date to avoid duplicates
          final eventExists = await _checkIfEventExists(habit, date);
          if (!eventExists) {
            await CalendarService.createHabitEvent(habit, date);
            eventsCreated++;
          }
        }
      }
      
      AppLogger.info('Extended sync for habit "${habit.name}": $eventsCreated new events created');
    } catch (e) {
      AppLogger.error('Error in extended sync for habit "${habit.name}"', e);
    }
  }
  

  
  /// Check if an event already exists for a habit on a specific date
  static Future<bool> _checkIfEventExists(Habit habit, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'habit_event_${habit.id}_${date.toIso8601String().split('T')[0]}';
      final eventId = prefs.getString(key);
      return eventId != null;
    } catch (e) {
      AppLogger.warning('Error checking if event exists for habit "${habit.name}" on $date: $e');
      return false; // Assume it doesn't exist if we can't check
    }
  }
  

  
  /// Force a manual renewal (useful for testing or user-triggered renewal)
  static Future<void> forceRenewal() async {
    AppLogger.info('Force renewal requested');
    await _performCalendarRenewal();
    
    // Update the last renewal timestamp
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_calendar_renewal', DateTime.now().toIso8601String());
  }
  
  /// Stop the renewal service
  static void stop() {
    _renewalTimer?.cancel();
    _renewalTimer = null;
    _isInitialized = false;
    AppLogger.info('Calendar renewal service stopped');
  }
  
  /// Get renewal status information
  static Future<Map<String, dynamic>> getRenewalStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRenewalStr = prefs.getString('last_calendar_renewal');
      
      DateTime? lastRenewal;
      if (lastRenewalStr != null) {
        try {
          lastRenewal = DateTime.parse(lastRenewalStr);
        } catch (e) {
          // Invalid date format
        }
      }
      
      final now = DateTime.now();
      final daysSinceRenewal = lastRenewal != null ? now.difference(lastRenewal).inDays : null;
      final nextRenewal = lastRenewal?.add(const Duration(days: 30));
      
      return {
        'isActive': _isInitialized && _renewalTimer != null,
        'lastRenewal': lastRenewal?.toIso8601String(),
        'daysSinceRenewal': daysSinceRenewal,
        'nextRenewal': nextRenewal?.toIso8601String(),
        'needsRenewal': daysSinceRenewal == null || daysSinceRenewal >= 30,
      };
    } catch (e) {
      AppLogger.error('Error getting renewal status', e);
      return {
        'isActive': false,
        'error': e.toString(),
      };
    }
  }
}

