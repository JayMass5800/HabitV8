import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database_isar.dart';
import '../services/theme_service.dart';
import 'rrule_service.dart';
import 'dart:convert';
import 'dart:ui' as ui;

/// Service to manage widget integration and updates
/// PERFORMANCE: Uses Isar listeners for event-driven updates instead of polling
class WidgetIntegrationService {
  static const String _timelineWidgetName = 'HabitTimelineWidgetProvider';
  static const String _compactWidgetName = 'HabitCompactWidgetProvider';
  static const MethodChannel _widgetUpdateChannel =
      MethodChannel('com.habittracker.habitv8/widget_update');

  static WidgetIntegrationService? _instance;
  static WidgetIntegrationService get instance =>
      _instance ??= WidgetIntegrationService._();

  StreamSubscription<void>?
      _habitWatchSubscription; // Isar lazy listener for habit changes (void events)
  Timer?
      _debounceTimer; // Debounce widget updates to prevent excessive refreshes
  bool _updatePending = false; // Track if an update is already scheduled

  WidgetIntegrationService._();

  /// Initialize widget integration and set up background handlers
  /// PERFORMANCE: Uses Isar listener for event-driven updates instead of polling
  Future<void> initialize() async {
    try {
      // Register background callback for widget interactions
      await HomeWidget.registerInteractivityCallback(_backgroundCallback);

      // Clean up old widget-specific preferences since we now follow app theme
      await _cleanupOldWidgetPreferences();

      // Set initial widget data
      await updateAllWidgets();

      // PERFORMANCE: Set up Isar listener for automatic widget updates on habit changes
      await _setupHabitListener();

      // Schedule Android WorkManager updates for independent widget updates
      await _scheduleAndroidWidgetUpdates();

      debugPrint('✅ Widget integration initialized with Isar listener');
    } catch (e) {
      debugPrint('Error initializing widget integration: $e');
    }
  }

  /// Set up Isar listener for automatic widget updates when habits change
  /// PERFORMANCE: Event-driven updates instead of polling every 30 minutes
  /// CRITICAL: Uses watchHabitsLazy() for efficient change detection (no data transfer)
  /// LIFECYCLE: Subscription is kept alive until dispose() is called by AppLifecycleService
  ///
  /// WHY watchHabitsLazy() instead of watchAllHabits():
  /// - watchHabitsLazy() only signals that a change occurred (void event)
  /// - watchAllHabits() transfers ALL habit data on EVERY change (inefficient)
  /// - We fetch fresh data in updateAllWidgets() anyway, so we don't need the data in the event
  /// - This prevents performance issues and potential missed events from large data transfers
  Future<void> _setupHabitListener() async {
    try {
      // Cancel any existing subscription to prevent duplicates
      await _habitWatchSubscription?.cancel();

      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Listen to habit changes and update widgets automatically
      // Using watchHabitsLazy() for efficient change detection (recommended by Isar docs)
      // This emits a void event whenever ANY habit changes, without transferring data
      _habitWatchSubscription = habitService.watchHabitsLazy().listen(
        (_) async {
          final timestamp = DateTime.now().toIso8601String();
          debugPrint(
              '🔔 [$timestamp] Isar lazy listener fired: habit change detected');
          debugPrint('🔔 Updating widgets via Isar listener...');

          // Save widget data to SharedPreferences (fetches fresh data from Isar)
          await updateAllWidgets();

          // CRITICAL: Add delay to ensure SharedPreferences write completes
          await Future.delayed(const Duration(milliseconds: 200));

          // Trigger Android widget UI refresh
          await _triggerAndroidWidgetUpdate();

          debugPrint(
              '🔔 Widget update completed from Isar listener (data + UI refresh)');
        },
        onError: (error) {
          debugPrint('❌ Error in Isar listener: $error');
          // Try to re-establish the listener after a delay
          Future.delayed(const Duration(seconds: 5), () {
            debugPrint(
                '🔄 Attempting to re-establish Isar listener after error...');
            _setupHabitListener();
          });
        },
        cancelOnError: false,
      );

      debugPrint(
          '✅ Widget Isar lazy listener initialized (efficient change detection)');
    } catch (e) {
      debugPrint('⚠️ Error setting up widget Isar listener: $e');
      // Try to re-establish the listener after a delay
      Future.delayed(const Duration(seconds: 5), () {
        debugPrint(
            '🔄 Attempting to re-establish Isar listener after setup error...');
        _setupHabitListener();
      });
    }
  }

  /// Re-establish Isar listener (called when app resumes from background)
  /// This ensures the listener is still active after the app was paused
  Future<void> reestablishListener() async {
    try {
      debugPrint('🔄 Re-establishing Isar listener after app resume...');
      await _setupHabitListener();
      debugPrint('✅ Isar listener re-established successfully');
    } catch (e) {
      debugPrint('⚠️ Error re-establishing Isar listener: $e');
    }
  }

  /// Clean up old widget-specific preferences since widgets now follow app theme
  Future<void> _cleanupOldWidgetPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove old widget-specific theme and color preferences
      await prefs.remove('widget_theme_mode');
      await prefs.remove('widget_primary_color');
      await prefs.remove('widget_auto_refresh');
      await prefs.remove('widget_refresh_interval');

      debugPrint('Old widget preferences cleaned up');
    } catch (e) {
      debugPrint('Error cleaning up old widget preferences: $e');
    }
  }

  /// Force immediate widget update (for testing)
  Future<void> forceWidgetUpdate() async {
    try {
      debugPrint('🧪 FORCE UPDATE: Starting immediate widget update...');
      debugPrint(
          '🧪 FORCE UPDATE: Called from notification completion handler');

      // Update data first
      await updateAllWidgets();
      debugPrint('🧪 FORCE UPDATE: updateAllWidgets() completed');

      // CRITICAL: Add delay to ensure SharedPreferences write completes
      // Widget data must be fully written before triggering UI refresh
      await Future.delayed(const Duration(milliseconds: 200));
      debugPrint('🧪 FORCE UPDATE: Waited for data persistence');

      // Force explicit widget refresh using method channel to trigger onUpdate
      debugPrint('🧪 FORCE UPDATE: Triggering immediate widget refresh');

      try {
        await _widgetUpdateChannel.invokeMethod('forceWidgetRefresh');
        debugPrint(
            '🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel');
      } catch (e) {
        debugPrint(
            '🧪 FORCE UPDATE: Method channel failed, falling back to HomeWidget.updateWidget - $e');

        // Fallback to HomeWidget.updateWidget if method channel fails
        await HomeWidget.updateWidget(
          name: _timelineWidgetName,
          androidName: _timelineWidgetName,
        );
        debugPrint('🧪 FORCE UPDATE: Timeline widget update called');

        await HomeWidget.updateWidget(
          name: _compactWidgetName,
          androidName: _compactWidgetName,
        );
        debugPrint('🧪 FORCE UPDATE: Compact widget update called');
      }

      debugPrint('🧪 FORCE UPDATE: Completed successfully');
    } catch (e) {
      debugPrint('🧪 FORCE UPDATE: Failed - $e');
    }
  }

  /// Update all widgets with current habit data (immediate, no debounce)
  Future<void> updateAllWidgets() async {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('📱 [$timestamp] updateAllWidgets() called');

    // Cancel any pending update
    _debounceTimer?.cancel();

    // If an update is already in progress, just mark that another is needed
    if (_updatePending) {
      debugPrint('⏱️ Widget update already pending, will schedule another');
      _debounceTimer = Timer(const Duration(milliseconds: 50), () {
        _performWidgetUpdate();
      });
      return;
    }

    // IMMEDIATE update - no delay for instant responsiveness!
    debugPrint('📱 Performing immediate widget update...');
    await _performWidgetUpdate();
    debugPrint('📱 [$timestamp] updateAllWidgets() completed');
  }

  /// Perform the actual widget update (internal method)
  Future<void> _performWidgetUpdate() async {
    if (_updatePending) {
      debugPrint('⏱️ Skipping duplicate widget update');
      return;
    }

    _updatePending = true;

    try {
      final widgetData = await _prepareWidgetData();

      // Always save theme and color data since _getThemeData() already handles widget preferences
      try {
        await HomeWidget.saveWidgetData('themeMode', widgetData['themeMode']);
        await HomeWidget.saveWidgetData(
            'primaryColor', widgetData['primaryColor']);
        debugPrint(
            'Saved widget theme data: ${widgetData['themeMode']}, color: ${widgetData['primaryColor']}');
      } catch (e) {
        debugPrint('Error saving widget theme data: $e');
      }

      // Update timeline widget
      await _updateWidget(_timelineWidgetName, widgetData);

      // Update compact widget
      await _updateWidget(_compactWidgetName, widgetData);

      debugPrint('✅ All widgets updated successfully (debounced)');
    } catch (e) {
      debugPrint('Error in debounced widget update: $e');
    } finally {
      _updatePending = false;
    }
  }

  /// Update a specific widget with data
  Future<void> _updateWidget(
      String widgetName, Map<String, dynamic> data) async {
    try {
      debugPrint(
          'Updating widget $widgetName with data keys: ${data.keys.toList()}');

      // Set widget data with retry logic
      for (final entry in data.entries) {
        bool saved = false;
        int retries = 0;
        while (!saved && retries < 3) {
          try {
            await HomeWidget.saveWidgetData(entry.key, entry.value);
            saved = true;
            if (entry.key == 'habits') {
              debugPrint(
                  '✅ Saved ${entry.key}: length=${entry.value.toString().length}, preview=${entry.value.toString().length > 150 ? "${entry.value.toString().substring(0, 150)}..." : entry.value}');
            } else {
              debugPrint(
                  '✅ Saved ${entry.key}: ${entry.value.toString().length > 100 ? "${entry.value.toString().substring(0, 100)}..." : entry.value}');
            }
          } catch (e) {
            retries++;
            debugPrint('❌ Error saving ${entry.key} (attempt $retries): $e');
            if (retries < 3) {
              await Future.delayed(Duration(milliseconds: 100 * retries));
            }
          }
        }
      }

      // Small delay to ensure data is written to SharedPreferences
      await Future.delayed(const Duration(milliseconds: 100));

      // Update the widget - this triggers onDataSetChanged in the Android RemoteViewsFactory
      await HomeWidget.updateWidget(
        name: widgetName,
        androidName: widgetName,
      );

      // Minimal delay to ensure the update propagates
      await Future.delayed(const Duration(milliseconds: 100));

      debugPrint('Widget $widgetName update completed');
    } catch (e) {
      debugPrint('Error updating widget $widgetName: $e');
    }
  }

  /// Prepare data for widget consumption
  Future<Map<String, dynamic>> _prepareWidgetData() async {
    try {
      final selectedDate = DateTime.now();

      // Get habit data - use database directly since WidgetService methods are private
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final allHabits = await habitService.getAllHabits();
      final habits = _filterHabitsForDate(allHabits, selectedDate);
      final nextHabit = _findNextHabit(allHabits);

      debugPrint(
          'Widget data preparation: Found ${allHabits.length} total habits, ${habits.length} for today');

      // Get theme data
      final themeData = await _getThemeData();

      // Convert habits to JSON for widget consumption
      final habitsWithStatus =
          await _enrichHabitsWithStatus(habits, selectedDate);
      final habitsList =
          habitsWithStatus.map((h) => _habitToJson(h, selectedDate)).toList();
      final habitsJson = jsonEncode(habitsList);
      final nextHabitJson = nextHabit != null
          ? jsonEncode(_habitToJson(nextHabit, selectedDate))
          : null;

      // Calculate completion status for logging
      final completedCount =
          habitsList.where((h) => h['isCompleted'] == true).length;
      final totalCount = habitsList.length;
      final allComplete = completedCount == totalCount && totalCount > 0;

      debugPrint(
          '🎯 Widget data prepared: ${habitsList.length} habits in list, JSON length: ${habitsJson.length}');
      debugPrint(
          '🎯 Completion status: $completedCount/$totalCount (allComplete: $allComplete)');

      // Log each habit's completion status
      for (final habit in habitsList) {
        final name = habit['name'];
        final isCompleted = habit['isCompleted'];
        final frequency = habit['frequency'];
        if (frequency.toString().contains('hourly')) {
          final completedSlots = habit['completedSlots'] ?? 0;
          final totalSlots = habit['totalSlots'] ?? 0;
          debugPrint(
              '  📋 $name (hourly): $completedSlots/$totalSlots slots, isCompleted=$isCompleted');
        } else {
          debugPrint('  📋 $name: isCompleted=$isCompleted');
        }
      }

      debugPrint(
          '🎯 First 200 chars of habits JSON: ${habitsJson.length > 200 ? habitsJson.substring(0, 200) : habitsJson}');
      debugPrint(
          '🎯 Theme data: ${themeData['themeMode']}, primary: ${themeData['primaryColor']}');

      return {
        'habits': habitsJson,
        'nextHabit': nextHabitJson,
        'selectedDate': _formatDateForWidget(selectedDate),
        'themeMode': themeData['themeMode'],
        'primaryColor': themeData['primaryColor'],
        'lastUpdate': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      debugPrint('Error preparing widget data: $e');
      return {
        'habits': '[]',
        'nextHabit': null,
        'selectedDate': _formatDateForWidget(DateTime.now()),
        'themeMode': 'light',
        'primaryColor': 0x6366F1,
        'lastUpdate': DateTime.now().millisecondsSinceEpoch,
      };
    }
  }

  /// Enrich habits with completion status for the given date
  Future<List<Habit>> _enrichHabitsWithStatus(
      List<Habit> habits, DateTime date) async {
    // Habits already contain completion data, just return them
    return habits;
  }

  /// Convert habit to JSON format for widget
  Map<String, dynamic> _habitToJson(Habit habit, DateTime date) {
    final isCompleted = _isHabitCompletedOnDate(habit, date);
    final status = _getHabitStatus(habit, date);
    final timeDisplay = _getHabitTimeDisplay(habit);

    final json = <String, dynamic>{
      'id': habit.id,
      'name': habit.name,
      'category': habit.category,
      'colorValue': habit.colorValue,
      'isCompleted': isCompleted,
      'status': status,
      'timeDisplay': timeDisplay,
      'frequency': habit.frequency.toString(),
    };

    // For hourly habits, include detailed time slot information
    if (habit.frequency == HabitFrequency.hourly &&
        habit.hourlyTimes.isNotEmpty) {
      final timeSlots = <Map<String, dynamic>>[];

      for (final timeStr in habit.hourlyTimes) {
        final timeParts = timeStr.split(':');
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]);
          final minute = int.tryParse(timeParts[1]);

          if (hour != null && minute != null) {
            // Check if this specific time slot is completed
            final isSlotCompleted =
                _isHourlySlotCompleted(habit, date, hour, minute);

            timeSlots.add({
              'time': timeStr,
              'hour': hour,
              'minute': minute,
              'isCompleted': isSlotCompleted,
            });
          }
        }
      }

      json['hourlySlots'] = timeSlots;
      json['completedSlots'] =
          timeSlots.where((slot) => slot['isCompleted'] == true).length;
      json['totalSlots'] = timeSlots.length;

      // Override isCompleted for hourly habits - only true if ALL slots are completed
      json['isCompleted'] = json['completedSlots'] == json['totalSlots'];
    }

    return json;
  }

  /// Get current theme data (always follows app theme)
  Future<Map<String, dynamic>> _getThemeData() async {
    try {
      // Always follow app theme - no widget-specific overrides
      final appThemeMode = await ThemeService.getThemeMode();
      debugPrint('🎨 Getting app theme: $appThemeMode');

      String actualThemeMode;
      if (appThemeMode == ThemeMode.dark) {
        actualThemeMode = 'dark';
        debugPrint('🎨 App is in DARK mode');
      } else if (appThemeMode == ThemeMode.light) {
        actualThemeMode = 'light';
        debugPrint('🎨 App is in LIGHT mode');
      } else {
        // ThemeMode.system - check system brightness
        final brightness = ui.PlatformDispatcher.instance.platformBrightness;
        actualThemeMode = brightness == Brightness.dark ? 'dark' : 'light';
        debugPrint(
            '🎨 App is in SYSTEM mode, device brightness: $brightness → $actualThemeMode');
      }

      debugPrint('🎨 Final theme mode to send to widgets: $actualThemeMode');

      // Always use app primary color
      final appPrimaryColor = await ThemeService.getPrimaryColor();
      final primaryColorValue = appPrimaryColor.toARGB32();
      debugPrint('🎨 Using app primary color: $primaryColorValue');

      return {
        'themeMode': actualThemeMode,
        'primaryColor': primaryColorValue,
      };
    } catch (e) {
      debugPrint('Error getting theme data: $e');
      return {
        'themeMode': 'light',
        'primaryColor': 0xFF2196F3, // Default blue color
      };
    }
  }

  /// Format date for widget consumption
  String _formatDateForWidget(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Public method to handle widget interactions (called from main.dart)
  static Future<void> handleWidgetInteraction(Uri? uri) async {
    await _backgroundCallback(uri);
  }

  /// Handle widget interactions from background
  @pragma('vm:entry-point')
  static Future<void> _backgroundCallback(Uri? uri) async {
    try {
      if (uri == null) return;

      debugPrint('🔧 Widget background callback received: $uri');

      // **CRITICAL: Initialize HomeWidget in background context**
      // This ensures the platform channel is properly initialized for background execution
      try {
        // Use the same group ID as the main widget service for consistency
        await HomeWidget.setAppGroupId('group.com.habittracker.habitv8.widget');
        debugPrint('✅ HomeWidget initialized in background context');
      } catch (e) {
        debugPrint(
            '⚠️ HomeWidget initialization warning (may be already initialized): $e');
      }

      final action = uri.host;
      final params = uri.queryParameters;

      debugPrint('🎯 Processing widget action: $action with params: $params');

      switch (action) {
        case 'complete_habit':
          final habitId = params['habitId'];
          if (habitId != null) {
            debugPrint('🔄 Handling habit completion from widget: $habitId');
            await _handleCompleteHabit(habitId);
          }
          break;

        case 'refresh_widget':
          debugPrint('🔄 Handling widget refresh request');
          await _handleRefreshWidget();
          break;

        default:
          debugPrint('❓ Unknown widget action: $action');
      }
    } catch (e) {
      debugPrint('❌ Error handling widget callback: $e');
    }
  }

  /// Handle habit completion from widget
  static Future<void> _handleCompleteHabit(String habitId) async {
    try {
      debugPrint('🎯 Starting habit completion from widget: $habitId');

      // **1. DATABASE UPDATE:**
      // Get database service and update habit data
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Load habit directly using habit service
      final habit = await habitService.getHabitById(habitId);
      if (habit == null) {
        debugPrint('❌ Habit not found: $habitId');
        return;
      }

      debugPrint(
          '✅ Found habit: ${habit.name} (frequency: ${habit.frequency})');

      // For hourly habits, complete the next pending time slot
      // For other habits, complete with current time
      DateTime completionTime = DateTime.now();

      if (habit.frequency == HabitFrequency.hourly &&
          habit.hourlyTimes.isNotEmpty) {
        // Find the next incomplete time slot
        final now = DateTime.now();
        String? nextSlot;

        for (final timeStr in habit.hourlyTimes) {
          final timeParts = timeStr.split(':');
          if (timeParts.length == 2) {
            final hour = int.tryParse(timeParts[0]);
            final minute = int.tryParse(timeParts[1]);

            if (hour != null && minute != null) {
              // Check if this slot is already completed
              final slotCompleted = habit.completions.any((completion) =>
                  completion.year == now.year &&
                  completion.month == now.month &&
                  completion.day == now.day &&
                  completion.hour == hour);

              if (!slotCompleted) {
                nextSlot = timeStr;
                completionTime =
                    DateTime(now.year, now.month, now.day, hour, minute);
                debugPrint('⏰ Completing hourly slot: $timeStr');
                break;
              }
            }
          }
        }

        if (nextSlot == null) {
          debugPrint('✅ All hourly slots already completed for today');
          // All slots complete - refresh widget to show updated state
          await instance.updateAllWidgets();
          return;
        }
      }

      // Add completion using habit service for proper transaction handling
      await habitService.markHabitComplete(habitId, completionTime);
      debugPrint('✅ Habit marked as complete in database at $completionTime');

      // **2. EXPLICIT WIDGET REFRESH (THE KEY STEP):**
      // Following the example pattern - update widgets with new data
      await instance.updateAllWidgets();
      debugPrint('✅ Widget data updated');

      // **3. FORCE WIDGET UI REFRESH:**
      // Explicitly tell the OS to refresh the widget UI
      try {
        await HomeWidget.updateWidget(
          name: _timelineWidgetName,
          androidName: _timelineWidgetName,
        );
        debugPrint('✅ Timeline widget UI refresh triggered');

        await HomeWidget.updateWidget(
          name: _compactWidgetName,
          androidName: _compactWidgetName,
        );
        debugPrint('✅ Compact widget UI refresh triggered');
      } catch (e) {
        debugPrint('⚠️ Widget UI refresh warning: $e');
      }

      debugPrint(
          '🎉 Habit completion from widget completed successfully: ${habit.name}');
    } catch (e) {
      debugPrint('❌ Error completing habit from widget: $e');
    }
  }

  /// Handle widget refresh request
  static Future<void> _handleRefreshWidget() async {
    try {
      debugPrint('Refreshing widgets');
      await instance.updateAllWidgets();
    } catch (e) {
      debugPrint('Error refreshing widgets: $e');
    }
  }

  /// DEPRECATED: Periodic updates removed - now using Isar listeners
  /// This method is kept for backward compatibility but does nothing
  @Deprecated('Widget updates are now event-driven via Isar listeners')
  void startPeriodicUpdates() {
    debugPrint(
        '⚠️ startPeriodicUpdates called but is deprecated - using Isar listeners instead');
  }

  /// DEPRECATED: Periodic updates removed - now using Isar listeners
  @Deprecated('Widget updates are now event-driven via Isar listeners')
  void stopPeriodicUpdates() {
    debugPrint(
        '⚠️ stopPeriodicUpdates called but is deprecated - using Isar listeners instead');
  }

  /// DEPRECATED: Now using Isar listeners
  @Deprecated('Widget updates are now event-driven via Isar listeners')
  Future<void> schedulePeriodicUpdates() async {
    debugPrint(
        '⚠️ schedulePeriodicUpdates called but is deprecated - using Isar listeners instead');
  }

  /// Check if the app was launched from a widget
  Future<bool> wasLaunchedFromWidget() async {
    try {
      final launchData = await HomeWidget.initiallyLaunchedFromHomeWidget();
      return launchData != null;
    } catch (e) {
      debugPrint('Error checking widget launch: $e');
      return false;
    }
  }

  /// Get the data from widget launch
  Future<Map<String, dynamic>?> getWidgetLaunchData() async {
    try {
      final launchUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (launchUri != null) {
        return launchUri.queryParameters;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting widget launch data: $e');
      return null;
    }
  }

  /// Handle app launch from widget with specific route
  Future<void> handleWidgetLaunch() async {
    try {
      final launchData = await getWidgetLaunchData();
      if (launchData != null) {
        final route = launchData['route'] as String?;
        if (route != null) {
          debugPrint('App launched from widget with route: $route');
          // Handle navigation to specific route
          // This would typically be handled by the main app's navigation system
        }
      }
    } catch (e) {
      debugPrint('Error handling widget launch: $e');
    }
  }

  /// Update widgets when habits change
  Future<void> onHabitsChanged() async {
    debugPrint('🔄 onHabitsChanged called - updating all widgets');
    await updateAllWidgets();
    // Also trigger immediate Android widget update
    await _triggerAndroidWidgetUpdate();
    debugPrint('✅ Widget update completed after habit changes');
  }

  /// Update widgets when theme changes
  Future<void> onThemeChanged() async {
    await updateAllWidgets();
    // Also trigger immediate Android widget update
    await _triggerAndroidWidgetUpdate();
  }

  /// Schedule Android WorkManager updates for independent widget functionality
  ///
  /// HYBRID APPROACH: Combines event-driven updates with periodic safety net
  /// Widget updates are handled by:
  /// 1. Isar database listeners (event-driven, instant updates) - PRIMARY
  /// 2. Periodic WorkManager (every 30 minutes) - SAFETY NET for race conditions
  /// 3. Midnight reset service (daily habit resets)
  /// 4. Critical system broadcasts (DATE_CHANGED, TIMEZONE_CHANGED)
  ///
  /// The 30-minute periodic update catches any missed updates from race conditions
  /// while still being battery-friendly (only 48 wake-ups per day vs 96+).
  Future<void> _scheduleAndroidWidgetUpdates() async {
    try {
      const platform = MethodChannel('com.habittracker.habitv8/widget_update');
      await platform.invokeMethod('schedulePeriodicUpdates');
      debugPrint(
          '✅ Hybrid widget updates enabled: Isar listeners + 30-min safety net');
    } catch (e) {
      debugPrint('Error configuring Android widget updates: $e');
    }
  }

  /// Trigger immediate Android widget update
  Future<void> _triggerAndroidWidgetUpdate() async {
    try {
      // Trigger the worker immediately - the data is already saved by this point
      const platform = MethodChannel('com.habittracker.habitv8/widget_update');
      await platform.invokeMethod('triggerImmediateUpdate');
      debugPrint('Android widget immediate update triggered');
    } catch (e) {
      debugPrint('Error triggering Android widget update: $e');
    }
  }

  /// Test method to expose data preparation for debugging
  Future<Map<String, dynamic>> testPrepareData() async {
    return await _prepareWidgetData();
  }

  /// Update widgets when a habit is completed
  Future<void> onHabitCompleted() async {
    debugPrint('🔄 onHabitCompleted called - updating all widgets');
    await updateAllWidgets();
    // CRITICAL: Also trigger immediate Android widget update
    await _triggerAndroidWidgetUpdate();
    debugPrint('✅ Widget update completed after habit completion');
  }

  /// Filter habits for a specific date
  List<Habit> _filterHabitsForDate(List<Habit> habits, DateTime date) {
    final filtered =
        habits.where((habit) => _isHabitScheduledForDate(habit, date)).toList();

    debugPrint(
        'Filtering ${habits.length} habits for date ${_formatDateForWidget(date)}:');
    for (var habit in habits) {
      final isScheduled = _isHabitScheduledForDate(habit, date);
      debugPrint(
          '  - ${habit.name}: ${habit.frequency.toString()} -> ${isScheduled ? "INCLUDED" : "EXCLUDED"}');
    }
    debugPrint('Result: ${filtered.length} habits for today');

    // Sort habits chronologically by time
    filtered
        .sort((a, b) => _getHabitSortTime(a).compareTo(_getHabitSortTime(b)));

    return filtered;
  }

  /// Get habit sort time for chronological ordering
  DateTime _getHabitSortTime(Habit habit) {
    // Handle single habits with specific date/time
    if (habit.singleDateTime != null) {
      return habit.singleDateTime!;
    }

    // Handle hourly habits with multiple times
    if (habit.frequency == HabitFrequency.hourly &&
        habit.hourlyTimes.isNotEmpty) {
      // Use the earliest time from hourly times for sorting
      final earliestTime = habit.hourlyTimes.first;
      final timeParts = earliestTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    // Handle recurring habits with notification time
    if (habit.notificationTime != null) {
      // Create a DateTime with today's date and the habit's notification time
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        habit.notificationTime!.hour,
        habit.notificationTime!.minute,
      );
    }

    // If no time is set, put it at the end of the day
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59);
  }

  /// Check if habit is scheduled for a specific date
  bool _isHabitScheduledForDate(Habit habit, DateTime date) {
    // Check if habit uses RRule system
    if (habit.usesRRule && habit.rruleString != null) {
      return RRuleService.isDueOnDate(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        checkDate: date,
      );
    }

    // Legacy frequency-based logic for old habits
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        return habit.selectedWeekdays.contains(date.weekday);
      case HabitFrequency.monthly:
        // Check if the date's day matches ANY of the selected month days
        if (habit.selectedMonthDays.isEmpty) {
          return date.day == 1; // Default to 1st if none selected
        }
        return habit.selectedMonthDays.contains(date.day);
      case HabitFrequency.yearly:
        // Check if today matches any of the yearly dates
        return habit.selectedYearlyDates.any((yearlyDateString) {
          try {
            final yearlyDate = DateTime.parse(yearlyDateString);
            return date.month == yearlyDate.month && date.day == yearlyDate.day;
          } catch (e) {
            return false;
          }
        });
      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final habitDate = DateTime(
            habit.singleDateTime!.year,
            habit.singleDateTime!.month,
            habit.singleDateTime!.day,
          );
          return habitDate
              .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
        }
        return false;
      case HabitFrequency.hourly:
        return true;
    }
  }

  /// Find the next habit due
  Habit? _findNextHabit(List<Habit> habits) {
    final now = DateTime.now();
    Habit? nextHabit;
    DateTime? nextTime;

    for (final habit in habits) {
      if (_isHabitScheduledForDate(habit, now) &&
          !_isHabitCompletedToday(habit)) {
        final habitTime = _getHabitTime(habit);
        if (habitTime != null && habitTime.isAfter(now)) {
          if (nextTime == null || habitTime.isBefore(nextTime)) {
            nextTime = habitTime;
            nextHabit = habit;
          }
        }
      }
    }

    return nextHabit;
  }

  /// Get the next scheduled time for a habit
  DateTime? _getHabitTime(Habit habit) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (habit.frequency) {
      case HabitFrequency.single:
        return habit.singleDateTime;
      case HabitFrequency.hourly:
        // Find next hourly time
        for (final timeStr in habit.hourlyTimes) {
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);
            if (hour != null && minute != null) {
              final time = today.add(Duration(hours: hour, minutes: minute));
              if (time.isAfter(now)) {
                return time;
              }
            }
          }
        }
        return null;
      default:
        if (habit.notificationTime != null) {
          return today.add(Duration(
            hours: habit.notificationTime!.hour,
            minutes: habit.notificationTime!.minute,
          ));
        }
        return null;
    }
  }

  /// Check if habit is completed today
  bool _isHabitCompletedToday(Habit habit) {
    final today = DateTime.now();
    return _isHabitCompletedOnDate(habit, today);
  }

  /// Check if habit is completed on a specific date
  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    // For hourly habits, check if at least one slot is completed
    if (habit.frequency == HabitFrequency.hourly) {
      return habit.completions.any((completion) {
        return completion.year == date.year &&
            completion.month == date.month &&
            completion.day == date.day;
      });
    }

    // For other frequencies, check for any completion on the date
    return habit.completions.any((completion) {
      final completionDate =
          DateTime(completion.year, completion.month, completion.day);
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
  }

  /// Check if a specific hourly time slot is completed
  bool _isHourlySlotCompleted(
      Habit habit, DateTime date, int hour, int minute) {
    return habit.completions.any((completion) {
      return completion.year == date.year &&
          completion.month == date.month &&
          completion.day == date.day &&
          completion.hour == hour;
      // Note: We only check hour, not minute, because completions are recorded per hour
    });
  }

  /// Get habit status for a date
  String _getHabitStatus(Habit habit, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (_isHabitCompletedOnDate(habit, date)) {
      return 'Completed';
    }

    if (selectedDay.isBefore(today)) {
      return 'Missed';
    } else if (selectedDay.isAfter(today)) {
      return 'Upcoming';
    } else {
      return 'Due';
    }
  }

  /// Get time display for habit
  String _getHabitTimeDisplay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          // For hourly habits, show the next upcoming time or current time
          final now = DateTime.now();

          // Find the next time that hasn't passed yet
          String? nextTime;
          for (final timeStr in habit.hourlyTimes) {
            final timeParts = timeStr.split(':');
            final habitHour = int.parse(timeParts[0]);
            final habitMinute = int.parse(timeParts[1]);
            final habitDateTime =
                DateTime(now.year, now.month, now.day, habitHour, habitMinute);

            if (habitDateTime.isAfter(now) ||
                habitDateTime.isAtSameMomentAs(DateTime(
                    now.year, now.month, now.day, now.hour, now.minute))) {
              nextTime = timeStr;
              break;
            }
          }

          if (nextTime != null) {
            // Show next time with indicator of additional times
            if (habit.hourlyTimes.length == 1) {
              return nextTime;
            } else {
              return '$nextTime (+${habit.hourlyTimes.length - 1})';
            }
          } else {
            // All times have passed, show first time for tomorrow
            if (habit.hourlyTimes.length == 1) {
              return '${habit.hourlyTimes.first} (tomorrow)';
            } else {
              return '${habit.hourlyTimes.first} (+${habit.hourlyTimes.length - 1})';
            }
          }
        }
        return 'Hourly';

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final hour = habit.singleDateTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.singleDateTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';

      default:
        if (habit.notificationTime != null) {
          final hour = habit.notificationTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.notificationTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';
    }
  }

  /// Dispose resources and cancel listeners
  /// Called by AppLifecycleService when app is paused/stopped
  void dispose() {
    debugPrint('🔄 Disposing WidgetIntegrationService resources...');

    // Cancel Isar listener
    if (_habitWatchSubscription != null) {
      _habitWatchSubscription?.cancel();
      _habitWatchSubscription = null;
      debugPrint('✅ Cancelled habit watch subscription');
    }

    // Cancel debounce timer
    if (_debounceTimer != null) {
      _debounceTimer?.cancel();
      _debounceTimer = null;
      debugPrint('✅ Cancelled debounce timer');
    }

    debugPrint(
        '✅ WidgetIntegrationService disposed successfully - no resource leaks');
  }
}
