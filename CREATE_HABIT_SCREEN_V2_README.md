# Create Habit Screen V2 - Streamlined Version

## Overview

The `CreateHabitScreenV2` is a streamlined, cleaner version of the habit creation screen that provides a more intuitive user experience while maintaining all the powerful features of the original.

## Key Features

### 1. **RRule Integration for Daily-Yearly Frequencies**
- Uses the standardized RRule (RFC 5545) format for daily, weekly, monthly, and yearly habits
- Provides better flexibility and future-proofing for complex scheduling patterns
- Automatically generates RRule strings from simple user selections

### 2. **Legacy Hourly System**
- Keeps the existing hourly habit system intact
- Allows users to select multiple times throughout the day
- Requires weekday selection for hourly habits

### 3. **Consistent table_calendar Usage**
- Uses `table_calendar` package consistently across all calendar-based selections
- Monthly habits: Calendar view for selecting days of the month
- Yearly habits: Calendar view with month navigation for selecting specific dates

### 4. **Conditional UI Based on Frequency**
- Shows only relevant options based on selected frequency
- Cleaner, less cluttered interface
- Reduces cognitive load for users

### 5. **Advanced Mode Toggle**
- Simple mode by default for quick habit creation
- Advanced mode available for complex patterns (e.g., "every other week", "2nd Tuesday of each month")
- Advanced mode only shown for frequencies that support it (not for hourly or single habits)

## Frequency-Specific UI

### Hourly
- **Simple Mode Only** (no advanced mode)
- Time selector: Add multiple times throughout the day
- Weekday selector: Choose which days the hourly habit applies
- Uses legacy system (not RRule)

### Daily
- **Simple Mode**: Shows confirmation that habit repeats every day
- **Advanced Mode**: Access to RRule builder for complex patterns (e.g., every other day)
- Generates: `FREQ=DAILY`

### Weekly
- **Simple Mode**: Weekday selector (Mon-Sun chips)
- **Advanced Mode**: RRule builder for patterns like "every 2 weeks on Monday and Wednesday"
- Generates: `FREQ=WEEKLY;BYDAY=MO,WE,FR` (example)

### Monthly
- **Simple Mode**: Calendar view to select days of the month (1-31)
- **Advanced Mode**: RRule builder for patterns like "2nd Tuesday of each month"
- Generates: `FREQ=MONTHLY;BYMONTHDAY=1,15,30` (example)

### Yearly
- **Simple Mode**: Calendar view with month navigation to select specific dates
- **Advanced Mode**: RRule builder for complex yearly patterns
- Generates: `FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15` (example)

### Single (One-time)
- **Simple Mode Only** (no advanced mode)
- Date and time picker for one-time habits
- Does not use RRule

## Architecture

### State Management
- Uses Riverpod for dependency injection
- Maintains separate state for:
  - Simple mode selections (`_simpleWeekdays`, `_simpleMonthDays`, `_simpleYearlyDates`)
  - Advanced mode RRule (`_rruleString`, `_rruleStartDate`)
  - Hourly mode selections (`_hourlyTimes`, `_selectedWeekdays`)

### RRule Generation
- **Advanced Mode**: Uses `RRuleBuilderWidget` to generate RRule strings
- **Simple Mode**: Automatically converts simple selections to RRule format on save
  - Daily: `FREQ=DAILY`
  - Weekly: `FREQ=WEEKLY;BYDAY=MO,TU,WE...`
  - Monthly: `FREQ=MONTHLY;BYMONTHDAY=1,15,30...`
  - Yearly: `FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15`

### Validation
- Frequency-specific validation ensures required fields are filled
- Clear error messages guide users to complete missing information
- Validates notification time when notifications are enabled

## Usage

### Navigation
```dart
// Navigate to the new V2 screen
context.push('/create-habit-v2');

// With prefilled data (from recommendations)
context.push('/create-habit-v2', extra: {
  'name': 'Drink Water',
  'category': 'Health',
  'difficulty': 'easy',
  'suggestedTime': '9:00 AM',
});
```

### Switching from V1 to V2
To use V2 as the default create habit screen:

1. **Option A: Update the route** (in `main.dart`)
```dart
GoRoute(
  path: '/create-habit',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return CreateHabitScreenV2(prefilledData: extra); // Changed from CreateHabitScreen
  },
),
```

2. **Option B: Keep both and choose per use case**
```dart
// Use V1 for power users who need all options upfront
context.push('/create-habit');

// Use V2 for new users or quick habit creation
context.push('/create-habit-v2');
```

## Comparison: V1 vs V2

| Feature | V1 (Original) | V2 (Streamlined) |
|---------|---------------|------------------|
| **UI Complexity** | All options visible | Conditional UI based on frequency |
| **Advanced Mode** | Always visible toggle | Only shown when relevant |
| **RRule Usage** | Optional, with auto-generation | Primary for daily-yearly, with simple mode |
| **Calendar Views** | Mixed implementations | Consistent table_calendar usage |
| **Hourly Habits** | Mixed with RRule | Separate legacy system |
| **Code Size** | ~2800 lines | ~1400 lines |
| **Learning Curve** | Steeper | Gentler |
| **Flexibility** | High | High (via advanced mode) |

## Benefits of V2

1. **Cleaner Code**: ~50% reduction in code size while maintaining functionality
2. **Better UX**: Users only see options relevant to their selected frequency
3. **Easier Maintenance**: Clear separation between simple and advanced modes
4. **Consistent Patterns**: Uses table_calendar consistently for all calendar-based selections
5. **Future-Proof**: RRule-first approach makes it easier to add complex patterns later
6. **Progressive Disclosure**: Simple mode for beginners, advanced mode for power users

## Migration Path

### For Users
- No migration needed - both screens create compatible habits
- Users can switch between V1 and V2 at any time
- All existing habits work with both screens

### For Developers
1. **Phase 1**: Deploy V2 alongside V1 (current state)
2. **Phase 2**: A/B test to compare user engagement and completion rates
3. **Phase 3**: Gradually migrate users to V2 based on feedback
4. **Phase 4**: Deprecate V1 once V2 is proven stable

## Testing Checklist

- [ ] Daily habit creation (simple mode)
- [ ] Daily habit creation (advanced mode)
- [ ] Weekly habit with multiple days (simple mode)
- [ ] Weekly habit with complex pattern (advanced mode)
- [ ] Monthly habit with multiple days (simple mode)
- [ ] Monthly habit with position pattern (advanced mode)
- [ ] Yearly habit with multiple dates (simple mode)
- [ ] Yearly habit with complex pattern (advanced mode)
- [ ] Hourly habit with multiple times
- [ ] Single habit with date/time
- [ ] Notification scheduling
- [ ] Prefilled data from recommendations
- [ ] Validation error messages
- [ ] Color selection
- [ ] Category selection

## Known Limitations

1. **Yearly Habits**: Simple mode currently only generates RRule for the first selected date when multiple dates span different months. Future enhancement needed for multiple dates across months.

2. **Hourly Habits**: Does not use RRule due to limitations in the RRule spec for multiple times per day. Uses legacy system instead.

3. **Advanced Mode Complexity**: While powerful, advanced mode may still be complex for some users. Consider adding more examples or a wizard in future iterations.

## Future Enhancements

1. **Smart Defaults**: Pre-select common patterns based on habit category
2. **Templates**: Save and reuse frequency patterns
3. **Natural Language Input**: "Every Monday and Wednesday" → Auto-configure
4. **Visual Preview**: Show next 5 occurrences in simple mode too
5. **Yearly Multi-Date**: Support multiple dates across different months in simple mode
6. **Guided Wizard**: Step-by-step wizard for complex patterns

## Technical Details

### Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `table_calendar`: Calendar views
- `RRuleBuilderWidget`: Advanced mode RRule creation
- `RRuleService`: RRule parsing and generation

### File Structure
```
lib/
  ui/
    screens/
      create_habit_screen.dart       # Original V1
      create_habit_screen_v2.dart    # New streamlined V2
    widgets/
      rrule_builder_widget.dart      # Advanced mode RRule builder
  services/
    rrule_service.dart               # RRule utilities
```

### Key Methods

#### `_buildSimpleModeUI()`
Returns frequency-specific UI based on `_selectedFrequency`

#### `_buildAdvancedModeUI()`
Shows RRule builder widget for complex patterns

#### `_generateRRuleFromSimpleMode(Habit habit)`
Converts simple mode selections to RRule format

#### `_validateFrequencyRequirements()`
Ensures all required fields are filled based on frequency

## Support

For questions or issues:
1. Check the original `create_habit_screen.dart` for reference implementation
2. Review `rrule_builder_widget.dart` for advanced mode details
3. Consult `rrule_service.dart` for RRule generation logic

## License

Same as the main HabitV8 project.