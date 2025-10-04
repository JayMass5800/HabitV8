# Migration Guide: CreateHabitScreen V1 → V2

## Overview

This guide helps you migrate from `CreateHabitScreen` (V1) to `CreateHabitScreenV2` (V2) in your HabitV8 application.

## Why Migrate?

- ✅ **50% less code** - Easier to maintain
- ✅ **Better UX** - Progressive disclosure, cleaner interface
- ✅ **Consistent patterns** - Uses table_calendar throughout
- ✅ **RRule-first** - Better support for complex patterns
- ✅ **Same functionality** - No features lost

## Migration Strategies

### Strategy 1: Side-by-Side (Recommended)

Deploy both versions and gradually migrate users.

#### Step 1: Add V2 Route (Already Done)
```dart
// In main.dart
import 'ui/screens/create_habit_screen_v2.dart';

// Routes
GoRoute(
  path: '/create-habit',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateHabitScreen(prefilledData: extra); // V1
  },
),
GoRoute(
  path: '/create-habit-v2',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateHabitScreenV2(prefilledData: extra); // V2
  },
),
```

#### Step 2: Update Navigation Calls Gradually

**Before:**
```dart
context.push('/create-habit');
```

**After:**
```dart
context.push('/create-habit-v2');
```

#### Step 3: Test Both Versions
- Keep V1 as fallback
- Test V2 with subset of users
- Monitor for issues

#### Step 4: Full Migration
Once V2 is proven stable, update the main route:

```dart
GoRoute(
  path: '/create-habit',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateHabitScreenV2(prefilledData: extra); // Now using V2
  },
),
```

---

### Strategy 2: Feature Flag

Use a feature flag to control which version is shown.

#### Step 1: Create Feature Flag Service
```dart
// lib/services/feature_flag_service.dart
class FeatureFlagService {
  static const String _useV2Key = 'use_create_habit_v2';
  
  static Future<bool> shouldUseV2() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useV2Key) ?? false; // Default to V1
  }
  
  static Future<void> setUseV2(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useV2Key, value);
  }
}
```

#### Step 2: Update Navigation
```dart
// In your navigation code
Future<void> navigateToCreateHabit(BuildContext context) async {
  final useV2 = await FeatureFlagService.shouldUseV2();
  final route = useV2 ? '/create-habit-v2' : '/create-habit';
  if (context.mounted) {
    context.push(route);
  }
}
```

#### Step 3: Add Settings Toggle
```dart
// In settings screen
SwitchListTile(
  title: const Text('Use New Habit Creation Screen'),
  subtitle: const Text('Streamlined interface (Beta)'),
  value: _useV2,
  onChanged: (value) async {
    await FeatureFlagService.setUseV2(value);
    setState(() {
      _useV2 = value;
    });
  },
)
```

---

### Strategy 3: A/B Testing

Randomly assign users to V1 or V2 for testing.

#### Step 1: Create A/B Test Service
```dart
// lib/services/ab_test_service.dart
class ABTestService {
  static const String _variantKey = 'create_habit_variant';
  
  static Future<String> getVariant() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if user already has a variant assigned
    String? variant = prefs.getString(_variantKey);
    
    if (variant == null) {
      // Assign variant (50/50 split)
      variant = DateTime.now().millisecondsSinceEpoch % 2 == 0 ? 'v1' : 'v2';
      await prefs.setString(_variantKey, variant);
      
      // Log assignment for analytics
      AppLogger.info('A/B Test: User assigned to $variant');
    }
    
    return variant;
  }
  
  static Future<void> logEvent(String event, Map<String, dynamic> data) async {
    final variant = await getVariant();
    // Send to your analytics service
    AppLogger.info('A/B Test Event: $event (variant: $variant)', data);
  }
}
```

#### Step 2: Update Navigation
```dart
Future<void> navigateToCreateHabit(BuildContext context) async {
  final variant = await ABTestService.getVariant();
  final route = variant == 'v2' ? '/create-habit-v2' : '/create-habit';
  
  // Log navigation
  await ABTestService.logEvent('create_habit_screen_shown', {
    'variant': variant,
    'timestamp': DateTime.now().toIso8601String(),
  });
  
  if (context.mounted) {
    context.push(route);
  }
}
```

#### Step 3: Track Metrics
```dart
// When habit is saved
await ABTestService.logEvent('habit_created', {
  'variant': await ABTestService.getVariant(),
  'frequency': habit.frequency.toString(),
  'has_notifications': habit.notificationsEnabled,
  'time_spent_seconds': timeSpent,
});
```

---

### Strategy 4: User Segment Based

Show V2 to new users, V1 to existing users.

#### Step 1: Track User Type
```dart
// lib/services/user_service.dart
class UserService {
  static const String _isNewUserKey = 'is_new_user';
  static const String _firstLaunchKey = 'first_launch_date';
  
  static Future<bool> isNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if this is first launch
    if (!prefs.containsKey(_firstLaunchKey)) {
      await prefs.setString(
        _firstLaunchKey,
        DateTime.now().toIso8601String(),
      );
      await prefs.setBool(_isNewUserKey, true);
      return true;
    }
    
    // User is "new" for first 7 days
    final firstLaunch = DateTime.parse(prefs.getString(_firstLaunchKey)!);
    final daysSinceFirstLaunch = DateTime.now().difference(firstLaunch).inDays;
    
    return daysSinceFirstLaunch < 7;
  }
}
```

#### Step 2: Update Navigation
```dart
Future<void> navigateToCreateHabit(BuildContext context) async {
  final isNewUser = await UserService.isNewUser();
  final route = isNewUser ? '/create-habit-v2' : '/create-habit';
  
  if (context.mounted) {
    context.push(route);
  }
}
```

---

## Code Changes Required

### 1. Update Import Statements

**Before:**
```dart
import 'ui/screens/create_habit_screen.dart';
```

**After:**
```dart
import 'ui/screens/create_habit_screen_v2.dart';
```

### 2. Update Navigation Calls

**Before:**
```dart
// Simple navigation
context.push('/create-habit');

// With data
context.push('/create-habit', extra: prefilledData);
```

**After:**
```dart
// Simple navigation
context.push('/create-habit-v2');

// With data
context.push('/create-habit-v2', extra: prefilledData);
```

### 3. Update Widget References

**Before:**
```dart
return CreateHabitScreen(prefilledData: data);
```

**After:**
```dart
return CreateHabitScreenV2(prefilledData: data);
```

---

## Testing Checklist

Before fully migrating, test these scenarios:

### Basic Functionality
- [ ] Create daily habit
- [ ] Create weekly habit with multiple days
- [ ] Create monthly habit with multiple days
- [ ] Create yearly habit with multiple dates
- [ ] Create hourly habit with multiple times
- [ ] Create single (one-time) habit

### Advanced Mode
- [ ] Switch to advanced mode for daily habit
- [ ] Create "every other day" pattern
- [ ] Create "every 2 weeks" pattern
- [ ] Create "2nd Tuesday of each month" pattern
- [ ] Create "last Friday of each month" pattern

### Notifications
- [ ] Enable notifications for daily habit
- [ ] Enable notifications for weekly habit
- [ ] Verify notification time selection
- [ ] Verify hourly habit notifications

### Prefilled Data
- [ ] Create habit from recommendation
- [ ] Verify all prefilled fields are populated
- [ ] Verify time parsing (various formats)
- [ ] Verify category color assignment

### Edge Cases
- [ ] Create habit without notification time
- [ ] Create habit with all fields empty (validation)
- [ ] Create habit with invalid data
- [ ] Cancel habit creation
- [ ] Navigate back without saving

### UI/UX
- [ ] Verify responsive layout
- [ ] Test on different screen sizes
- [ ] Test dark mode
- [ ] Test light mode
- [ ] Verify color selection
- [ ] Verify calendar interactions

---

## Rollback Plan

If issues arise, you can quickly rollback:

### Option 1: Route Change
```dart
// Change route back to V1
GoRoute(
  path: '/create-habit',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateHabitScreen(prefilledData: extra); // Back to V1
  },
),
```

### Option 2: Feature Flag
```dart
// Disable V2 via feature flag
await FeatureFlagService.setUseV2(false);
```

### Option 3: A/B Test
```dart
// Stop assigning new users to V2
class ABTestService {
  static Future<String> getVariant() async {
    // Force everyone to V1
    return 'v1';
  }
}
```

---

## Common Issues and Solutions

### Issue 1: Prefilled Data Not Working

**Problem:** Prefilled data from recommendations not showing up

**Solution:** Verify the data structure matches:
```dart
context.push('/create-habit-v2', extra: {
  'name': 'Habit Name',           // Required
  'description': 'Description',   // Optional
  'category': 'Health',           // Must match existing category
  'difficulty': 'easy',           // 'easy', 'medium', or 'hard'
  'suggestedTime': '9:00 AM',     // Various formats supported
});
```

### Issue 2: Advanced Mode Not Showing

**Problem:** Advanced mode toggle not visible

**Solution:** Advanced mode is only shown for daily, weekly, monthly, and yearly frequencies. It's hidden for hourly and single habits.

### Issue 3: RRule Not Generated

**Problem:** Habit created without RRule

**Solution:** Check that:
1. Frequency is not hourly or single
2. Required selections are made (e.g., weekdays for weekly)
3. Check logs for RRule generation errors

### Issue 4: Calendar Not Responding

**Problem:** Calendar taps not registering

**Solution:** Ensure `table_calendar` package is up to date:
```yaml
dependencies:
  table_calendar: ^3.0.9
```

---

## Performance Considerations

### V1 Performance
- Renders all widgets upfront
- Higher initial memory usage
- More rebuilds on state changes

### V2 Performance
- Conditional rendering
- Lower memory footprint
- Fewer unnecessary rebuilds

### Optimization Tips
1. Use `const` constructors where possible
2. Avoid rebuilding entire screen on small changes
3. Use `ListView.builder` for long lists
4. Profile with Flutter DevTools

---

## Analytics and Monitoring

Track these metrics during migration:

### User Engagement
- Time spent on screen
- Completion rate (habits created vs. abandoned)
- Advanced mode usage rate
- Error rate

### Technical Metrics
- Screen load time
- Memory usage
- Crash rate
- Navigation errors

### Example Analytics Implementation
```dart
class HabitCreationAnalytics {
  static DateTime? _screenOpenTime;
  
  static void trackScreenOpened(String version) {
    _screenOpenTime = DateTime.now();
    // Send to analytics service
    AppLogger.info('Habit creation screen opened', {
      'version': version,
      'timestamp': _screenOpenTime!.toIso8601String(),
    });
  }
  
  static void trackHabitCreated(Habit habit, String version) {
    final timeSpent = _screenOpenTime != null
        ? DateTime.now().difference(_screenOpenTime!).inSeconds
        : 0;
    
    // Send to analytics service
    AppLogger.info('Habit created', {
      'version': version,
      'frequency': habit.frequency.toString(),
      'uses_rrule': habit.usesRRule,
      'has_notifications': habit.notificationsEnabled,
      'time_spent_seconds': timeSpent,
    });
  }
  
  static void trackScreenAbandoned(String version) {
    final timeSpent = _screenOpenTime != null
        ? DateTime.now().difference(_screenOpenTime!).inSeconds
        : 0;
    
    // Send to analytics service
    AppLogger.info('Habit creation abandoned', {
      'version': version,
      'time_spent_seconds': timeSpent,
    });
  }
}
```

---

## Timeline

### Week 1: Preparation
- [ ] Review V2 code
- [ ] Set up feature flags
- [ ] Prepare analytics
- [ ] Create test plan

### Week 2: Soft Launch
- [ ] Deploy V2 alongside V1
- [ ] Enable for 10% of users
- [ ] Monitor metrics
- [ ] Gather feedback

### Week 3: Expansion
- [ ] Increase to 50% of users
- [ ] Address any issues
- [ ] Refine based on feedback

### Week 4: Full Migration
- [ ] Enable for 100% of users
- [ ] Monitor for issues
- [ ] Prepare to deprecate V1

### Week 5+: Cleanup
- [ ] Remove V1 code (optional)
- [ ] Update documentation
- [ ] Archive old code

---

## Support and Resources

### Documentation
- `CREATE_HABIT_SCREEN_V2_README.md` - Feature documentation
- `CREATE_HABIT_SCREEN_COMPARISON.md` - V1 vs V2 comparison
- `create_habit_screen_v2_example.dart` - Usage examples

### Code Files
- `lib/ui/screens/create_habit_screen.dart` - Original V1
- `lib/ui/screens/create_habit_screen_v2.dart` - New V2
- `lib/ui/widgets/rrule_builder_widget.dart` - Advanced mode

### Getting Help
1. Check documentation files
2. Review example code
3. Check logs for errors
4. Test with different scenarios

---

## Conclusion

Migrating to V2 provides significant benefits:
- Cleaner, more maintainable code
- Better user experience
- Same functionality with better organization

Choose the migration strategy that best fits your needs:
- **Side-by-Side**: Safest, allows gradual migration
- **Feature Flag**: Good for controlled rollout
- **A/B Testing**: Best for data-driven decisions
- **User Segment**: Good for protecting existing users

Remember: You can always rollback if needed!