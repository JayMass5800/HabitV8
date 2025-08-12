import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';
import 'services/notification_action_service.dart';
import 'services/permission_service.dart';
import 'services/theme_service.dart';
import 'services/logging_service.dart';
import 'services/onboarding_service.dart';
import 'services/calendar_renewal_service.dart';
import 'ui/screens/timeline_screen.dart';
import 'ui/screens/all_habits_screen.dart';
import 'ui/screens/calendar_screen.dart';
import 'ui/screens/stats_screen.dart';
import 'ui/screens/insights_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/create_habit_screen.dart';
import 'ui/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge design
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
  } catch (e) {
    AppLogger.error('Error initializing notification service', e);
    // Continue with app startup even if notifications fail
  }

  // Request only essential permissions during startup (non-blocking)
  // Health permissions will be requested when user accesses health features
  _requestEssentialPermissions();

  // Create provider container and initialize notification action service
  final container = ProviderContainer();
  NotificationActionService.initialize(container);

  // Initialize calendar renewal service (non-blocking)
  _initializeCalendarRenewal();

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
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

/// Initialize calendar renewal service (non-blocking)
void _initializeCalendarRenewal() async {
  try {
    // Small delay to let the app finish initializing
    await Future.delayed(const Duration(seconds: 5));
    await CalendarRenewalService.initialize();
  } catch (e) {
    AppLogger.error('Error initializing calendar renewal service', e);
    // Don't block app startup if calendar renewal fails
  }
}

Future<void> _setCorrectTimezone() async {
  try {
    print('DEBUG: Setting up timezone...');
    
    // Get device local time info
    final now = DateTime.now();
    final deviceOffset = now.timeZoneOffset;
    final deviceOffsetHours = deviceOffset.inHours;
    final deviceOffsetMinutes = deviceOffset.inMinutes % 60;
    
    print('DEBUG: Device timezone offset: ${deviceOffset.toString()} (${deviceOffsetHours}h ${deviceOffsetMinutes}m)');
    
    // Try to get system timezone name first
    String? timezoneName = await _getSystemTimezone();
    
    if (timezoneName != null && timezoneName.isNotEmpty) {
      print('DEBUG: Using system timezone: $timezoneName');
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } else {
      // Better fallback using more comprehensive timezone detection
      timezoneName = _detectTimezoneFromOffset(deviceOffsetHours, deviceOffsetMinutes);
      print('DEBUG: Using detected timezone: $timezoneName');
      tz.setLocalLocation(tz.getLocation(timezoneName));
    }
    
    // Verify the timezone was set correctly
    final tzLocal = tz.local;
    final tzNow = tz.TZDateTime.now(tzLocal);
    print('DEBUG: Timezone set to: ${tzLocal.name}');
    print('DEBUG: Current TZ time: $tzNow');
    print('DEBUG: Current device time: $now');
    print('DEBUG: TZ offset matches device: ${tzNow.timeZoneOffset == deviceOffset}');
    
  } catch (e) {
    print('DEBUG: Error setting timezone: $e');
    AppLogger.error('Error setting timezone', e);
    try {
      // Use UTC as ultimate fallback
      tz.setLocalLocation(tz.UTC);
      print('DEBUG: Fallback to UTC timezone');
    } catch (fallbackError) {
      print('DEBUG: Critical timezone error: $fallbackError');
      AppLogger.error('Fallback timezone setting failed', fallbackError);
    }
  }
}

Future<String?> _getSystemTimezone() async {
  try {
    // This would require platform-specific implementation
    // For now, return null to use the fallback method
    return null;
  } catch (e) {
    return null;
  }
}

String _detectTimezoneFromOffset(int hours, int minutes) {
  // More comprehensive timezone detection
  final totalMinutes = hours * 60 + minutes;
  
  // Common timezone mappings with better accuracy
  switch (totalMinutes) {
    case -720: return 'Pacific/Wake'; // UTC-12
    case -660: return 'Pacific/Midway'; // UTC-11
    case -600: return 'Pacific/Honolulu'; // UTC-10
    case -540: return 'America/Anchorage'; // UTC-9
    case -480: return 'America/Los_Angeles'; // UTC-8
    case -420: return 'America/Denver'; // UTC-7
    case -360: return 'America/Chicago'; // UTC-6
    case -300: return 'America/New_York'; // UTC-5
    case -240: return 'America/Halifax'; // UTC-4
    case -180: return 'America/Sao_Paulo'; // UTC-3
    case -120: return 'America/Noronha'; // UTC-2
    case -60: return 'Atlantic/Azores'; // UTC-1
    case 0: return 'Europe/London'; // UTC+0
    case 60: return 'Europe/Paris'; // UTC+1
    case 120: return 'Europe/Berlin'; // UTC+2
    case 180: return 'Europe/Moscow'; // UTC+3
    case 240: return 'Asia/Dubai'; // UTC+4
    case 300: return 'Asia/Karachi'; // UTC+5
    case 330: return 'Asia/Kolkata'; // UTC+5:30
    case 360: return 'Asia/Dhaka'; // UTC+6
    case 420: return 'Asia/Bangkok'; // UTC+7
    case 480: return 'Asia/Shanghai'; // UTC+8
    case 540: return 'Asia/Tokyo'; // UTC+9
    case 570: return 'Australia/Adelaide'; // UTC+9:30
    case 600: return 'Australia/Sydney'; // UTC+10
    case 660: return 'Pacific/Guadalcanal'; // UTC+11
    case 720: return 'Pacific/Fiji'; // UTC+12
    default:
      // For unusual offsets, try to find closest match
      if (totalMinutes < -720) return 'Pacific/Wake';
      if (totalMinutes > 720) return 'Pacific/Fiji';
      
      // Find closest standard timezone
      final standardOffsets = [-720, -660, -600, -540, -480, -420, -360, -300, -240, -180, -120, -60, 0, 60, 120, 180, 240, 300, 330, 360, 420, 480, 540, 570, 600, 660, 720];
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
        GoRoute(
          path: '/',
          builder: (context, state) => const AppWrapper(),
        ),
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
      body: widget.child,
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_shouldShowOnboarding) {
      // This should not be reached as we navigate to /onboarding
      // But keeping as fallback
      return const OnboardingScreen();
    }

    return const AllHabitsScreen();
  }
}
