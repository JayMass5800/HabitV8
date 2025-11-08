# RRule Export/Import Fix - Implementation Summary

## Problem Statement

When users exported RRule-based habits (e.g., "every two weeks") and then re-imported them after deletion, the habits would incorrectly revert to daily habits. This was caused by the export/import system not properly handling the new RRule fields introduced during the RRule refactoring.

### User-Reported Issue
> "I set a habit for every two weeks which saved correctly. I exported the habit, deleted all habits and reimported it. After being imported it registered as a daily habit due every day."

## Root Cause Analysis

### What Was Working ✅
- **Habit Model**: The Habit class correctly stored RRule fields (`rruleString`, `dtStart`, `usesRRule`)
- **JSON Export**: The `toJson()` method in the Habit model correctly exported all three RRule fields
- **Stats Service**: `habit_stats_service.dart` correctly checks `usesRRule` flag and uses RRule calculations
- **AI Service**: Doesn't depend on frequency fields, only completion data

### What Was Broken ❌

#### 1. JSON Import (`_createHabitFromJson`)
- **Missing**: Did not parse `rruleString`, `dtStart`, or `usesRRule` from JSON
- **Result**: All imported habits defaulted to `usesRRule = false`
- **Impact**: Habits fell back to legacy frequency system, causing incorrect schedules

#### 2. CSV Export (`exportToCSV`)
- **Missing**: Did not include RRule fields in CSV headers or data rows
- **Only Exported**: Legacy frequency fields (selectedWeekdays, selectedMonthDays, etc.)
- **Impact**: RRule information completely lost during CSV export

#### 3. CSV Import (`_createHabitFromCsvRow`)
- **Missing**: Did not parse RRule fields from CSV rows
- **Impact**: Imported CSV habits always used legacy frequency system

## Implementation Details

### Changes Made

#### 1. CSV Export Headers (Line ~89-118)
**Added three new columns:**
```dart
'RRule String',    // RRule recurrence pattern
'DT Start',        // RRule start date
'Uses RRule',      // Flag indicating RRule usage
```

**Before:** 26 columns ending with 'Snooze Delay (min)'  
**After:** 29 columns including RRule fields

#### 2. CSV Export Data Rows (Line ~142-154)
**Added three new data fields:**
```dart
habit.rruleString ?? '',               // Empty string if null
habit.dtStart?.toIso8601String() ?? '', // ISO8601 format or empty
habit.usesRRule.toString(),            // 'true' or 'false'
```

#### 3. JSON Import Parsing (Line ~619-631)
**Added RRule field parsing:**
```dart
// Parse RRule fields (new system)
habit.rruleString = json['rruleString'] as String?;
if (json['dtStart'] != null) {
  habit.dtStart = DateTime.parse(json['dtStart'] as String);
}
habit.usesRRule = json['usesRRule'] as bool? ?? false;
```

#### 4. CSV Import Parsing (Line ~730-744)
**Added three new case statements:**
```dart
case 'RRule String':
  habit.rruleString = value.isEmpty ? null : value;
  break;
case 'DT Start':
  if (value.isNotEmpty) {
    habit.dtStart = DateTime.parse(value);
  }
  break;
case 'Uses RRule':
  habit.usesRRule = value.toLowerCase() == 'true';
  break;
```

## Testing Instructions

### Prerequisites
1. Ensure you're on the `feature/rrule-refactoring` branch
2. Have at least one RRule-based habit (e.g., every two weeks, every Monday and Wednesday)
3. Have at least one legacy frequency habit for comparison

### Test Scenario 1: JSON Export/Import with RRule Habits
1. **Setup**: 
   - Create a habit with "Every 2 Weeks" frequency
   - Mark some completions over the past month
2. **Verify Initial State**: 
   - Go to the habit detail screen
   - Verify it shows "Every 2 Weeks" frequency
   - Note the next due date
3. **Export**: 
   - Go to Settings → Export Data → JSON
   - Save the file
   - **Verify JSON**: Open the JSON file and confirm these fields exist:
     ```json
     {
       "rruleString": "FREQ=WEEKLY;INTERVAL=2",
       "dtStart": "2024-01-15T00:00:00.000Z",
       "usesRRule": true,
       "frequency": "weekly"
     }
     ```
4. **Clear Data**: 
   - Delete all habits (or clear app data)
5. **Import**: 
   - Go to Settings → Import Data → JSON
   - Select the exported file
6. **Verify**: 
   - Go to habit detail screen
   - **Expected**: Habit still shows "Every 2 Weeks" frequency
   - **Expected**: Next due date matches the RRule pattern
   - **Expected**: Completion history is intact

### Test Scenario 2: CSV Export/Import with RRule Habits
1. **Setup**: 
   - Create a habit with "Every Monday and Wednesday" frequency
   - Mark completions on several Mondays and Wednesdays
2. **Export**: 
   - Go to Settings → Export Data → CSV
   - Save the file
   - **Verify CSV**: Open the CSV file in a spreadsheet app
     - Confirm "RRule String" column exists and contains: `FREQ=WEEKLY;BYDAY=MO,WE`
     - Confirm "DT Start" column has an ISO8601 date
     - Confirm "Uses RRule" column shows `true`
3. **Clear Data**: 
   - Delete all habits
4. **Import**: 
   - Go to Settings → Import Data → CSV
   - Select the exported file
5. **Verify**: 
   - Habit shows correct "Every Monday and Wednesday" schedule
   - Next due date is on a Monday or Wednesday
   - Completion history preserved

### Test Scenario 3: Backward Compatibility with Legacy Habits
1. **Setup**: 
   - Create a habit using legacy frequency (before RRule refactoring)
   - Or manually create a habit with `usesRRule = false`
2. **Export**: Export to both JSON and CSV
3. **Import**: Import both files
4. **Verify**: 
   - Legacy habits import correctly
   - Frequency shows correctly (e.g., "Daily", "Weekly")
   - No errors during import

### Test Scenario 4: Mixed Export (RRule + Legacy)
1. **Setup**: 
   - Create 2-3 RRule-based habits
   - Create 2-3 legacy frequency habits
2. **Export**: Export all to JSON and CSV
3. **Import**: Import both files
4. **Verify**: 
   - All RRule habits maintain their complex schedules
   - All legacy habits maintain their simple schedules
   - No conflicts or data corruption

## Files Modified

### `lib/services/data_export_import_service.dart`
- **CSV Export Headers**: Added 'RRule String', 'DT Start', 'Uses RRule' columns
- **CSV Export Data**: Added corresponding data fields for RRule
- **JSON Import**: Added parsing for `rruleString`, `dtStart`, `usesRRule`
- **CSV Import**: Added parsing for all three RRule fields

### No Changes Required
- ✅ **`lib/domain/model/habit.dart`**: Already exports RRule fields in `toJson()`
- ✅ **`lib/services/habit_stats_service.dart`**: Already checks `usesRRule` flag
- ✅ **`lib/services/ai_service.dart`**: Doesn't use frequency data directly

## Backward Compatibility

### Old Export Files
- ✅ **Old JSON files**: Compatible - missing RRule fields default to `null`/`false`
- ✅ **Old CSV files**: Compatible - missing columns are gracefully ignored
- ✅ **Legacy habits**: Continue to work with `usesRRule = false`

### New Export Files
- ✅ **New JSON files**: Include all RRule fields for full restoration
- ✅ **New CSV files**: Include all RRule fields in dedicated columns
- ✅ **Mixed habits**: Both RRule and legacy habits export/import correctly

## Performance Considerations

- **Export**: Minimal impact - O(n) where n is number of habits
- **Import**: Minimal impact - O(n) with proper error handling
- **CSV File Size**: Three additional columns add negligible size (~50-100 bytes per habit)
- **JSON File Size**: Three additional fields add ~100-150 bytes per habit

## Known Limitations

1. **CSV Column Order**: New columns added at the end for backward compatibility
2. **RRule String Length**: Very complex RRules might be harder to read in CSV
3. **Timezone**: All dates stored in ISO8601 format (includes timezone info)

## Migration Path

### For Users
1. **No action required** - Exports now include RRule data automatically
2. **Re-export data** - Users with old backups should re-export to get RRule fields
3. **No data loss** - Old imports still work, just use legacy frequency system

### For Developers
1. **Test thoroughly** - Use all four test scenarios above
2. **Monitor logs** - Check for import errors in `AppLogger`
3. **Verify stats** - Ensure stats service uses correct frequency calculation

## Related Documentation

- **RRULE_REFACTORING_PLAN.md**: Overall RRule migration strategy
- **RRULE_ARCHITECTURE.md**: RRule system architecture
- **COMPLETION_DATA_IMPORT_FIX.md**: Previous fix for completion history import
- **GIT_BRANCHING_STRATEGY.md**: Branch strategy for RRule refactoring

## Conclusion

This fix ensures that RRule-based habits can be fully exported and imported without data loss. Users can now safely backup and restore habits with complex recurrence patterns like "every two weeks", "every Monday and Friday", or "first Tuesday of each month". The implementation maintains full backward compatibility with legacy frequency habits and old export files.

## Next Steps

1. ✅ **Update Export/Import**: COMPLETE
2. 🔄 **Test All Scenarios**: IN PROGRESS
3. ⏳ **Update User Documentation**: Add RRule export/import to user manual
4. ⏳ **Release Notes**: Document in changelog for next version
