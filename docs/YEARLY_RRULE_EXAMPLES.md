# Yearly RRule Generation Examples

## Overview
The CreateHabitScreenV2 now intelligently handles multiple dates across different months for yearly habits. This document explains how the RRule generation works with various date selection patterns.

## How It Works

### Algorithm
1. **Group dates by month** to identify the pattern
2. **Check if all dates are in the same month**
   - If yes → Simple rule: `FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15,20,25`
3. **If multiple months**, check if the pattern matches a Cartesian product
   - Extract all unique months and all unique days
   - Calculate the Cartesian product (all combinations)
   - If selected dates match the product → Use combined rule
   - If not → Fall back to the month with the most dates

### RRule Cartesian Product Behavior
When you specify both `BYMONTH` and `BYMONTHDAY`, RRule creates occurrences for **every combination**:
- `FREQ=YEARLY;BYMONTH=3,6;BYMONTHDAY=15,30` creates **4 occurrences**:
  - March 15
  - March 30
  - June 15
  - June 30

## Examples

### Example 1: Single Month, Multiple Days ✅
**User Selection:**
- March 15
- March 20
- March 25

**Generated RRule:**
```
FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=15,20,25
```

**Occurrences:**
- March 15 (every year)
- March 20 (every year)
- March 25 (every year)

---

### Example 2: Multiple Months, Pattern Matches ✅
**User Selection:**
- March 15
- March 30
- June 15
- June 30
- September 15
- September 30

**Analysis:**
- Months: [3, 6, 9]
- Days: [15, 30]
- Cartesian product: 3×2 = 6 combinations
- Selected dates: 6 dates
- **Pattern matches!** ✅

**Generated RRule:**
```
FREQ=YEARLY;BYMONTH=3,6,9;BYMONTHDAY=15,30
```

**Occurrences:**
- March 15, March 30
- June 15, June 30
- September 15, September 30

---

### Example 3: Quarterly on the 1st ✅
**User Selection:**
- January 1
- April 1
- July 1
- October 1

**Analysis:**
- Months: [1, 4, 7, 10]
- Days: [1]
- Cartesian product: 4×1 = 4 combinations
- Selected dates: 4 dates
- **Pattern matches!** ✅

**Generated RRule:**
```
FREQ=YEARLY;BYMONTH=1,4,7,10;BYMONTHDAY=1
```

**Occurrences:**
- January 1, April 1, July 1, October 1 (every year)

---

### Example 4: Bi-monthly on 15th and Last Day ✅
**User Selection:**
- February 15
- February 28
- April 15
- April 30
- June 15
- June 30

**Analysis:**
- Months: [2, 4, 6]
- Days: [15, 28, 30]
- Cartesian product would create: Feb 15, Feb 28, Feb 30 (invalid), Apr 15, Apr 28, Apr 30, Jun 15, Jun 28, Jun 30
- After filtering invalid dates: 8 combinations
- Selected dates: 6 dates
- **Pattern doesn't match** ❌

**Generated RRule (Fallback):**
```
FREQ=YEARLY;BYMONTH=2;BYMONTHDAY=15,28
```
*(Uses February since it has 2 dates, same as others)*

**Warning Logged:**
```
Yearly habit has complex date pattern. Using primary month (2) only. 
Consider using Advanced Mode for full control.
```

**Recommendation:** Use Advanced Mode to create multiple RRules or use RDATE

---

### Example 5: Irregular Pattern ⚠️
**User Selection:**
- January 1
- March 15
- July 4
- December 25

**Analysis:**
- Months: [1, 3, 7, 12]
- Days: [1, 4, 15, 25]
- Cartesian product: 4×4 = 16 combinations
- Selected dates: 4 dates
- **Pattern doesn't match** ❌

**Generated RRule (Fallback):**
```
FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=1
```
*(Uses January since each month has only 1 date)*

**Warning Logged:**
```
Yearly habit has complex date pattern. Using primary month (1) only. 
Consider using Advanced Mode for full control.
```

**Recommendation:** Use Advanced Mode for full control

---

### Example 6: Every Month on 1st and 15th ✅
**User Selection:**
- All 12 months, on the 1st and 15th

**Analysis:**
- Months: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
- Days: [1, 15]
- Cartesian product: 12×2 = 24 combinations
- Selected dates: 24 dates
- **Pattern matches!** ✅

**Generated RRule:**
```
FREQ=YEARLY;BYMONTH=1,2,3,4,5,6,7,8,9,10,11,12;BYMONTHDAY=1,15
```

**Note:** This is actually better expressed as:
```
FREQ=MONTHLY;BYMONTHDAY=1,15
```
*(But that would require changing the frequency, which the user didn't select)*

---

## Edge Cases

### Invalid Dates (e.g., February 31)
The algorithm validates each date in the Cartesian product:
```dart
try {
  DateTime(2024, month, day); // Use leap year to validate
  expectedDates.add('$month-$day');
} catch (e) {
  // Invalid date (e.g., Feb 31), skip
}
```

**Example:**
- Months: [2, 4]
- Days: [30, 31]
- Cartesian product attempts: Feb 30 (invalid), Feb 31 (invalid), Apr 30 (valid), Apr 31 (invalid)
- Valid combinations: 1 (April 30)

### Leap Year Considerations
The validation uses 2024 (a leap year) to ensure February 29 is considered valid:
- If user selects Feb 29, it will be included in the RRule
- RRule will naturally skip Feb 29 in non-leap years

---

## When to Use Advanced Mode

Use Advanced Mode when:
1. **Irregular patterns** that don't fit Cartesian product logic
2. **Position-based rules** (e.g., "2nd Tuesday of March and September")
3. **Multiple separate RRules** needed
4. **RDATE** for specific arbitrary dates
5. **Complex intervals** (e.g., "every 2 years")

---

## Testing Scenarios

### Test Case 1: Same Month Pattern
```dart
// Select: March 10, March 20, March 30
// Expected: FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=10,20,30
```

### Test Case 2: Quarterly Pattern
```dart
// Select: Jan 1, Apr 1, Jul 1, Oct 1
// Expected: FREQ=YEARLY;BYMONTH=1,4,7,10;BYMONTHDAY=1
```

### Test Case 3: Bi-monthly Same Days
```dart
// Select: Feb 15, Apr 15, Jun 15, Aug 15, Oct 15, Dec 15
// Expected: FREQ=YEARLY;BYMONTH=2,4,6,8,10,12;BYMONTHDAY=15
```

### Test Case 4: Complex Grid Pattern
```dart
// Select: Jan 1, Jan 15, Jul 1, Jul 15
// Expected: FREQ=YEARLY;BYMONTH=1,7;BYMONTHDAY=1,15
```

### Test Case 5: Irregular Pattern (Fallback)
```dart
// Select: Jan 1, Feb 14, Jul 4, Dec 25
// Expected: FREQ=YEARLY;BYMONTH=1;BYMONTHDAY=1 (with warning)
```

---

## Implementation Details

### Code Location
`lib/ui/screens/create_habit_screen_v2.dart` - Lines ~1470-1544

### Key Logic
```dart
// Check if all dates are in the same month
if (monthGroups.length == 1) {
  // Simple case: single month
  final month = monthGroups.keys.first;
  final days = monthGroups[month]!.join(',');
  rruleString = 'FREQ=YEARLY;BYMONTH=$month;BYMONTHDAY=$days';
} else {
  // Complex case: multiple months
  // Calculate Cartesian product and compare with selected dates
  // If match → use combined BYMONTH and BYMONTHDAY
  // If no match → fallback to primary month with warning
}
```

### Logging
- **Success:** `AppLogger.info('✅ Generated RRule from simple mode: $rruleString')`
- **Fallback:** `AppLogger.warning('Yearly habit has complex date pattern...')`

---

## Future Enhancements

### RDATE Support
For truly arbitrary date patterns, implement RDATE:
```
DTSTART:20240101T090000Z
RRULE:FREQ=YEARLY
RDATE:20240101T090000Z,20240214T090000Z,20240704T090000Z,20241225T090000Z
```

This would allow any combination of dates without Cartesian product limitations.

### Smart Pattern Detection
Detect common patterns and suggest:
- "Looks like you want quarterly reminders. Use FREQ=MONTHLY;INTERVAL=3 instead?"
- "This pattern repeats every 2 months. Consider using FREQ=MONTHLY;INTERVAL=2"

### Visual Preview
Show the next 5-10 occurrences in the UI so users can verify the pattern before saving.

---

## Conclusion

The new yearly RRule generation intelligently handles:
- ✅ Single month, multiple days
- ✅ Multiple months with matching Cartesian product patterns
- ⚠️ Irregular patterns (with graceful fallback and warning)

This provides a great balance between simplicity and power, while guiding users to Advanced Mode when needed.