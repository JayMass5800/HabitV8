import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'services/notification_action_service.dart';
import 'services/alarm_manager_service.dart';
import 'services/permission_service.dart';
import 'services/theme_service.dart';
import 'services/logging_service.dart';
import 'services/onboarding_service.dart';
import 'services/midnight_habit_reset_service.dart';
import 'services/app_lifecycle_service.dart';
import 'ui/screens/timeline_screen.dart';
import 'ui/screens/all_habits_screen.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/stats_screen.dart';
import 'ui/screens/insights_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/create_habit_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'widgets/alarm_test_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge design - Updated for Android 15+ compatibility
  // The native MainActivity now handles edge-to-edge setup
  // This is kept for iOS and older Android versions
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize app lifecycle service for proper resource cleanup
  try {
    AppLifecycleService.initialize();
  } catch (e) {
    AppLogger.error('Error initializing app lifecycle service', e);
    // Continue with app startup even if lifecycle service fails
  }

  // Initialize timezone data
  try {
    tz.initializeTimeZones();
    await _setCorrectTimezone();
  } catch (e) {
    AppLogger.error('Error initializing timezone', e);
    // Continue with app startup even if timezone fails
  }

  // Initialize notification service
  try {
    await NotificationService.initialize();

    // Notification scheduling is now handled by the midnight reset service
  } catch (e) {
    AppLogger.error('Error initializing notification service', e);
    // Continue with app startup even if notifications fail
  }

  // Initialize hybrid alarm service (handles both notification and system alarms)
  try {
    await AlarmManagerService.initialize();
  } catch (e) {
    AppLogger.error('Error initializing hybrid alarm service', e);
    // Continue with app startup even if alarm service fails
  }

  // Request only essential permissions during startup (non-blocking)
  // Health permissions will be requested when user accesses health features
  _requestEssentialPermissions();

  // Create provider container and initialize notification action service
  final container = ProviderContainer();
  NotificationActionService.initialize(container);

  // Implement proper service initialization sequencing to prevent race conditions
  await _ensureServiceInitialization();

  // Set up a periodic callback check to ensure it doesn't get lost
  Timer.periodic(const Duration(minutes: 1), (timer) {
    NotificationActionService.ensureCallbackRegistered();
  });

  // Initialize midnight habit reset service (non-blocking)
  // This replaces the old calendar renewal and habit continuation systems
  _initializeMidnightReset();

  // Check for Android 15+ boot completion flag and handle notification rescheduling
  _handleBootCompletionIfNeeded();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

/// Request only essential permissions that don't require user interaction
/// Health permissions are requested later when needed
void _requestEssentialPermissions() async {
  try {
    // Request only notification permission during startup
    // Other permissions will be requested contextually when features are used
    await PermissionService.requestEssentialPermissions();
  } catch (e) {
    AppLogger.error('Error requesting essential permissions', e);
    // Don't block app startup if permission request fails
  }
}

// Calendar renewal service removed - now handled by midnight reset service

/// Initialize midnight habit reset service (non-blocking)
void _initializeMidnightReset() async {
  try {
    // Small delay to let the app finish initializing
    await Future.delayed(const Duration(seconds: 4));
    await MidnightHabitResetService.initialize();
  } catch (e) {
    AppLogger.error('Error initializing midnight habit reset service', e);
    // Don't block app startup if midnight reset fails
  }
}

// Notification scheduling function removed - now handled by midnight reset service

Future<void> _setCorrectTimezone() async {
  try {
    AppLogger.debug('Setting up timezone...');

    // Get device local time info
    final now = DateTime.now();
    final deviceOffset = now.timeZoneOffset;
    final deviceOffsetHours = deviceOffset.inHours;
    final deviceOffsetMinutes = deviceOffset.inMinutes % 60;
    final timeZoneName = now.timeZoneName;

    AppLogger.debug(
      'Device timezone offset: ${deviceOffset.toString()} (${deviceOffsetHours}h ${deviceOffsetMinutes}m)',
    );
    AppLogger.debug('Device timezone name: $timeZoneName');
    AppLogger.debug('Current date: ${now.toIso8601String()}');

    // Try to get system timezone name first
    String? detectedTimezoneName = await _getSystemTimezone();

    if (detectedTimezoneName != null && detectedTimezoneName.isNotEmpty) {
      AppLogger.debug('Using system-detected timezone: $detectedTimezoneName');
      try {
        tz.setLocalLocation(tz.getLocation(detectedTimezoneName));
        AppLogger.debug('Successfully set timezone to: $detectedTimezoneName');
      } catch (e) {
        AppLogger.debug(
          'Failed to set system timezone $detectedTimezoneName: $e',
        );
        detectedTimezoneName = null; // Fall back to offset detection
      }
    }

    if (detectedTimezoneName == null) {
      // Better fallback using more comprehensive timezone detection
      detectedTimezoneName = _detectTimezoneFromOffset(
        deviceOffsetHours,
        deviceOffsetMinutes,
      );
      AppLogger.debug('Using offset-detected timezone: $detectedTimezoneName');
      tz.setLocalLocation(tz.getLocation(detectedTimezoneName));
    }

    // Verify the timezone was set correctly
    final tzLocal = tz.local;
    final tzNow = tz.TZDateTime.now(tzLocal);
    AppLogger.debug('Final timezone set to: ${tzLocal.name}');
    AppLogger.debug('Current TZ time: $tzNow');
    AppLogger.debug('Current device time: $now');
    AppLogger.debug('TZ offset: ${tzNow.timeZoneOffset}');
    AppLogger.debug('Device offset: $deviceOffset');
    AppLogger.debug(
      'TZ offset matches device: ${tzNow.timeZoneOffset == deviceOffset}',
    );

    // Log success
    AppLogger.info('Timezone successfully set to: ${tzLocal.name}');
  } catch (e) {
    AppLogger.debug('Error setting timezone: $e');
    AppLogger.error('Error setting timezone', e);
    try {
      // Use UTC as ultimate fallback
      tz.setLocalLocation(tz.UTC);
      AppLogger.debug('Fallback to UTC timezone');
      AppLogger.warning('Timezone fallback to UTC due to error');
    } catch (fallbackError) {
      AppLogger.debug('Critical timezone error: $fallbackError');
      AppLogger.error('Fallback timezone setting failed', fallbackError);
    }
  }
}

Future<String?> _getSystemTimezone() async {
  try {
    // Try to get timezone from DateTime.now().timeZoneName
    final now = DateTime.now();
    final timeZoneName = now.timeZoneName;

    // Map common timezone abbreviations and names to IANA timezone names
    final timezoneMap = {
      'PST': 'America/Los_Angeles',
      'PDT': 'America/Los_Angeles',
      'Pacific Standard Time': 'America/Los_Angeles',
      'Pacific Daylight Time': 'America/Los_Angeles',
      'Pacific Summer Time': 'America/Los_Angeles', // Windows uses this for PDT
      'MST': 'America/Denver',
      'MDT': 'America/Denver',
      'Mountain Standard Time': 'America/Denver',
      'Mountain Daylight Time': 'America/Denver',
      'CST': 'America/Chicago',
      'CDT': 'America/Chicago',
      'Central Standard Time': 'America/Chicago',
      'Central Daylight Time': 'America/Chicago',
      'EST': 'America/New_York',
      'EDT': 'America/New_York',
      'Eastern Standard Time': 'America/New_York',
      'Eastern Daylight Time': 'America/New_York',
      'AKST': 'America/Anchorage',
      'AKDT': 'America/Anchorage',
      'Alaska Standard Time': 'America/Anchorage',
      'Alaska Daylight Time': 'America/Anchorage',
      'HST': 'Pacific/Honolulu',
      'Hawaii Standard Time': 'Pacific/Honolulu',
      'GMT': 'Europe/London',
      'UTC': 'UTC',
    };

    if (timezoneMap.containsKey(timeZoneName)) {
      AppLogger.debug(
        'Mapped timezone abbreviation $timeZoneName to ${timezoneMap[timeZoneName]}',
      );
      return timezoneMap[timeZoneName];
    }

    // If we get a full IANA name, try to use it directly
    if (timeZoneName.contains('/')) {
      AppLogger.debug('Using IANA timezone name: $timeZoneName');
      return timeZoneName;
    }

    AppLogger.debug(
      'Unknown timezone name: $timeZoneName, falling back to offset detection',
    );
    return null;
  } catch (e) {
    AppLogger.debug('Error getting system timezone: $e');
    return null;
  }
}

String _detectTimezoneFromOffset(int hours, int minutes) {
  // More comprehensive timezone detection with DST awareness
  final totalMinutes = hours * 60 + minutes;
  final now = DateTime.now();
  final isDST = _isDaylightSavingTime(now);

  AppLogger.debug(
    'Detecting timezone for offset ${hours}h ${minutes}m ($totalMinutes minutes), DST: $isDST',
  );

  // Common timezone mappings with DST awareness
  switch (totalMinutes) {
    case -720:
      return 'Pacific/Wake'; // UTC-12
    case -660:
      return 'Pacific/Midway'; // UTC-11
    case -600:
      return 'Pacific/Honolulu'; // UTC-10 (no DST)
    case -540:
      return 'America/Anchorage'; // UTC-9 (AKST) or UTC-8 (AKDT)
    case -480:
      // Could be Pacific Standard Time (UTC-8) or Alaska Daylight Time (UTC-8)
      // In most cases, this is Pacific Time
      return 'America/Los_Angeles'; // UTC-8 (PST) or UTC-7 (PDT)
    case -420:
      // This is tricky - could be:
      // 1. Pacific Daylight Time (Los Angeles in summer)
      // 2. Mountain Standard Time (Denver in winter)
      // We need to make an educated guess based on the time of year
      if (isDST) {
        // During DST period, UTC-7 is more likely to be Pacific Daylight Time
        AppLogger.debug(
          'UTC-7 during DST period, assuming Pacific Time (Los Angeles)',
        );
        return 'America/Los_Angeles';
      } else {
        // During standard time, UTC-7 is Mountain Standard Time
        AppLogger.debug(
          'UTC-7 during standard time, assuming Mountain Time (Denver)',
        );
        return 'America/Denver';
      }
    case -360:
      return 'America/Chicago'; // UTC-6 (CST) or UTC-5 (CDT)
    case -300:
      return 'America/New_York'; // UTC-5 (EST) or UTC-4 (EDT)
    case -240:
      return 'America/Halifax'; // UTC-4
    case -180:
      return 'America/Sao_Paulo'; // UTC-3
    case -120:
      return 'America/Noronha'; // UTC-2
    case -60:
      return 'Atlantic/Azores'; // UTC-1
    case 0:
      return 'Europe/London'; // UTC+0
    case 60:
      return 'Europe/Paris'; // UTC+1
    case 120:
      return 'Europe/Berlin'; // UTC+2
    case 180:
      return 'Europe/Moscow'; // UTC+3
    case 240:
      return 'Asia/Dubai'; // UTC+4
    case 300:
      return 'Asia/Karachi'; // UTC+5
    case 330:
      return 'Asia/Kolkata'; // UTC+5:30
    case 360:
      return 'Asia/Dhaka'; // UTC+6
    case 420:
      return 'Asia/Bangkok'; // UTC+7
    case 480:
      return 'Asia/Shanghai'; // UTC+8
    case 540:
      return 'Asia/Tokyo'; // UTC+9
    case 570:
      return 'Australia/Adelaide'; // UTC+9:30
    case 600:
      return 'Australia/Sydney'; // UTC+10
    case 660:
      return 'Pacific/Guadalcanal'; // UTC+11
    case 720:
      return 'Pacific/Fiji'; // UTC+12
    default:
      // For unusual offsets, try to find closest match
      if (totalMinutes < -720) return 'Pacific/Wake';
      if (totalMinutes > 720) return 'Pacific/Fiji';

      // Find closest standard timezone
      final standardOffsets = [
        -720,
        -660,
        -600,
        -540,
        -480,
        -420,
        -360,
        -300,
        -240,
        -180,
        -120,
        -60,
        0,
        60,
        120,
        180,
        240,
        300,
        330,
        360,
        420,
        480,
        540,
        570,
        600,
        660,
        720,
      ];
      int closest = standardOffsets.first;
      int minDiff = (totalMinutes - closest).abs();

      for (int offset in standardOffsets) {
        int diff = (totalMinutes - offset).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closest = offset;
        }
      }

      return _detectTimezoneFromOffset(closest ~/ 60, closest % 60);
  }
}

/// Simple DST detection based on date
/// This is a rough approximation - DST typically runs from March to November in the US
bool _isDaylightSavingTime(DateTime dateTime) {
  final month = dateTime.month;
  final day = dateTime.day;

  // DST in the US typically runs from the second Sunday in March to the first Sunday in November
  // This is a simplified check - not 100% accurate but good enough for timezone detection
  if (month < 3 || month > 11) return false; // Definitely standard time
  if (month > 3 && month < 11) return true; // Definitely daylight time

  // March and November need more careful checking, but for simplicity:
  if (month == 3) return day > 10; // Rough approximation
  if (month == 11) return day < 7; // Rough approximation

  return false;
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'HabitV8',
      theme: themeState.lightTheme,
      darkTheme: themeState.darkTheme,
      themeMode: themeState.themeMode,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) {
    AppLogger.error('Navigation error', state.error);
    // Return to main screen on navigation errors
    return const AllHabitsScreen();
  },
  routes: [
    // Onboarding route
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Main app shell with navigation
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/timeline',
          builder: (context, state) => const TimelineScreen(),
        ),
        GoRoute(path: '/', builder: (context, state) => const AppWrapper()),
        GoRoute(
          path: '/all-habits',
          builder: (context, state) => const AllHabitsScreen(),
        ),
        GoRoute(
          path: '/calendar',
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsScreen(),
        ),
        GoRoute(
          path: '/insights',
          builder: (context, state) => const InsightsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/create-habit',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CreateHabitScreen(prefilledData: extra);
      },
    ),
    GoRoute(
      path: '/alarm-test',
      builder: (context, state) => const AlarmTestWidget(),
    ),
  ],
);

class MainNavigationShell extends StatefulWidget {
  final Widget child;

  const MainNavigationShell({super.key, required this.child});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 1; // Default fallback to All Habits (index 1)

  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.timeline_outlined),
      selectedIcon: Icon(Icons.timeline),
      label: 'Timeline',
    ),
    const NavigationDestination(
      icon: Icon(Icons.list_alt_outlined),
      selectedIcon: Icon(Icons.list_alt),
      label: 'All Habits',
    ),
    const NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: 'Calendar',
    ),
    const NavigationDestination(
      icon: Icon(Icons.analytics_outlined),
      selectedIcon: Icon(Icons.analytics),
      label: 'Stats',
    ),
    const NavigationDestination(
      icon: Icon(Icons.insights_outlined),
      selectedIcon: Icon(Icons.insights),
      label: 'Insights',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  final List<String> _routes = [
    '/timeline',
    '/',
    '/calendar',
    '/stats',
    '/insights',
    '/settings',
  ];

  // Map screen names to route indices
  final Map<String, int> _screenNameToIndex = {
    'Timeline': 0,
    'All Habits': 1,
    'Calendar': 2,
    'Stats': 3,
    'Insights': 4,
    'Settings': 5,
  };

  @override
  void initState() {
    super.initState();
    _loadDefaultScreen();
  }

  Future<void> _loadDefaultScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultScreen = prefs.getString('default_screen') ?? 'All Habits';
      final index = _screenNameToIndex[defaultScreen] ?? 1;

      setState(() {
        _selectedIndex = index;
      });

      // Navigate to the default screen after initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(_routes[index]);
        }
      });
    } catch (e) {
      AppLogger.error('Error loading default screen', e);
      setState(() {
        _selectedIndex = 1; // Fallback to All Habits
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Handle system insets for edge-to-edge display
      body: SafeArea(
        top: true,
        bottom: false, // Let the navigation bar handle bottom insets
        child: widget.child,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          context.go(_routes[index]);
        },
        destinations: _destinations,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "main_shell_fab",
        onPressed: () {
          context.push('/create-habit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoading = true;
  bool _shouldShowOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final isCompleted = await OnboardingService.isOnboardingCompleted();
      setState(() {
        _shouldShowOnboarding = !isCompleted;
        _isLoading = false;
      });

      // Navigate to onboarding if needed
      if (!isCompleted && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/onboarding');
        });
      }
    } catch (e) {
      AppLogger.error('Error checking onboarding status', e);
      setState(() {
        _shouldShowOnboarding = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_shouldShowOnboarding) {
      // This should not be reached as we navigate to /onboarding
      // But keeping as fallback
      return const OnboardingScreen();
    }

    return const AllHabitsScreen();
  }
}

/// Ensure proper service initialization sequencing to prevent race conditions
Future<void> _ensureServiceInitialization() async {
  int attempt = 0;
  const maxAttempts = 5;
  const delay = Duration(milliseconds: 500);

  while (attempt < maxAttempts) {
    try {
      // Register callback and verify it's working
      NotificationActionService.ensureCallbackRegistered();

      // Wait a bit for registration to complete
      await Future.delayed(delay);

      // Verify callback is actually registered
      if (NotificationService.onNotificationAction != null) {
        AppLogger.info(
            '✅ Notification callback successfully registered on attempt ${attempt + 1}');

        // Process any pending actions now that callback is registered
        NotificationService.processPendingActionsManually();
        return;
      }

      attempt++;
      AppLogger.warning(
          '⚠️ Notification callback not registered, attempt $attempt/$maxAttempts');
    } catch (e) {
      attempt++;
      AppLogger.error(
          '❌ Error in service initialization attempt $attempt/$maxAttempts', e);
    }

    if (attempt < maxAttempts) {
      await Future.delayed(delay);
    }
  }

  AppLogger.error(
      '❌ Failed to properly initialize services after $maxAttempts attempts');
}

/// Handle Android 15+ boot completion flag for notification rescheduling
/// This replaces the restricted BOOT_COMPLETED foreground service approach
Future<void> _handleBootCompletionIfNeeded() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final needsReschedule = prefs.getBool('needs_notification_reschedule_after_boot') ?? false;
    
    if (needsReschedule) {
      AppLogger.info('🔄 Detected boot completion flag - rescheduling notifications');
      
      // Clear the flag
      await prefs.setBool('needs_notification_reschedule_after_boot', false);
      
      // Get boot timestamp for logging
      final bootTimestamp = prefs.getInt('boot_completion_timestamp') ?? 0;
      if (bootTimestamp > 0) {
        final bootTime = DateTime.fromMillisecondsSinceEpoch(bootTimestamp);
        AppLogger.info('📱 Device boot detected at: $bootTime');
      }
      
      // Trigger notification rescheduling without starting foreground services
      // This runs in the background and doesn't violate Android 15+ restrictions
      _rescheduleNotificationsAfterBoot();
    }
  } catch (e) {
    AppLogger.error('Error handling boot completion flag', e);
  }
}

/// Reschedule notifications after boot completion
/// This runs asynchronously to avoid blocking app startup
Future<void> _rescheduleNotificationsAfterBoot() async {
  try {
    AppLogger.info('🔄 Starting notification rescheduling after boot');
    
    // Use the midnight reset service which is already designed for this
    await MidnightHabitResetService.forceReset();
    
    AppLogger.info('✅ Notification rescheduling completed after boot');
  } catch (e) {
    AppLogger.error('❌ Error rescheduling notifications after boot', e);
  }
}
