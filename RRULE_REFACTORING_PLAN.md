# 🔄 HabitV8 RRule Refactoring Strategic Plan

## Executive Summary
This document outlines a comprehensive, step-by-step plan to refactor HabitV8's custom timing system to use the standardized RRule (Recurrence Rule) system based on the iCalendar specification (RFC 5545).

**Current Problem:** The existing system uses a fragmented approach with:
- `HabitFrequency` enum (hourly, daily, weekly, monthly, yearly, single)
- Multiple separate fields for different frequencies (`selectedWeekdays`, `selectedMonthDays`, `hourlyTimes`, `selectedYearlyDates`)
- Scattered logic across 20+ files checking frequency types
- Difficult to add complex patterns like "every other week" or "third Tuesday of each month"
- Maintenance nightmare with switch statements everywhere

**Solution:** Implement RRule-based system that:
- Uses a single `rrule` string field to represent any recurrence pattern
- Centralizes recurrence logic in one service
- Supports complex patterns out of the box
- Easier to maintain and extend
- Industry-standard approach

---

## 📊 Impact Analysis

### Files Affected (Estimated: 30+ files)

#### **Core Data Model** (Critical Priority)
1. `lib/domain/model/habit.dart` - Main Habit class
2. `lib/domain/model/habit.g.dart` - Hive generated code

#### **Services** (High Priority - 15 files)
3. `lib/services/work_manager_habit_service.dart` - Notification scheduling
4. `lib/services/widget_service.dart` - Widget data
5. `lib/services/widget_integration_service.dart` - Widget integration
6. `lib/services/calendar_service.dart` - Calendar integration
7. `lib/services/alarm_manager_service.dart` - Alarm scheduling
8. `lib/services/alarm_service.dart` - Alarm logic
9. `lib/services/habit_stats_service.dart` - Statistics calculation
10. `lib/services/trend_analysis_service.dart` - Trend analysis
11. `lib/services/comprehensive_habit_suggestions_service.dart` - Suggestions
12. Plus ~5 more service files

#### **UI Screens** (Medium Priority - 8 files)
13. `lib/ui/screens/create_habit_screen.dart` - Habit creation UI
14. `lib/ui/screens/edit_habit_screen.dart` - Habit editing UI
15. `lib/ui/screens/timeline_screen.dart` - Timeline display
16. `lib/ui/screens/calendar_screen.dart` - Calendar view
17. `lib/ui/screens/all_habits_screen.dart` - Habit list
18. Plus ~3 more screen files

#### **UI Widgets** (Medium Priority - 5 files)
19. `lib/ui/widgets/widget_timeline_view.dart` - Timeline widget
20. Plus ~4 more widget files

#### **Tests** (Low Priority)
21. Test files for updated services and models

---

## 🎯 Refactoring Phases

### **PHASE 0: Preparation & Research** (2-3 days)
**Goal:** Set up infrastructure and validate approach

#### Tasks:
1. ✅ **Package Selection**
   - Add `rrule` package to `pubspec.yaml` (https://pub.dev/packages/rrule)
   - Verify package capabilities and limitations
   - Test basic RRule generation and parsing

2. ✅ **Prototype & Proof of Concept**
   - Create `lib/services/rrule_service.dart` 
   - Implement basic RRule conversion logic
   - Test with sample habits (daily, weekly, monthly, yearly)
   - Verify occurrence generation accuracy

3. ✅ **Data Migration Strategy**
   - Design migration script to convert existing habits
   - Create mapping from old format to RRule strings
   - Plan for backward compatibility during transition

4. ✅ **Documentation**
   - Document RRule patterns for all current frequency types
   - Create examples for complex patterns
   - Design user-facing descriptions

**Deliverables:**
- [ ] `rrule` package added and tested
- [ ] `lib/services/rrule_service.dart` with basic functionality
- [ ] `scripts/migrate_to_rrule.dart` migration script
- [ ] `RRULE_PATTERNS.md` documentation

---

### **PHASE 1: Core Data Model Update** (3-4 days)
**Goal:** Update the Habit model to support RRule while maintaining backward compatibility

#### Tasks:

1. **Update Habit Model**
   - Add new fields to `lib/domain/model/habit.dart`:
     ```dart
     @HiveField(28)
     String? rruleString; // The RRule pattern
     
     @HiveField(29)
     DateTime? dtStart; // Start date for RRule (DTSTART)
     
     @HiveField(30)
     bool usesRRule = false; // Flag to indicate RRule usage
     ```
   
2. **Maintain Legacy Fields**
   - Keep all existing frequency fields for backward compatibility
   - Old habits continue to work with current system
   - New habits use RRule system
   
3. **Add Conversion Methods**
   - `String? getRRuleString()` - Get RRule for this habit
   - `bool isRRuleBased()` - Check if using RRule
   - `RecurrenceRule? getRecurrenceRule()` - Get parsed RRule object
   
4. **Update Hive Type Adapters**
   - Run `flutter packages pub run build_runner build`
   - Update `habit.g.dart` with new fields

**Deliverables:**
- [ ] Updated `habit.dart` with RRule fields
- [ ] Backward compatibility maintained
- [ ] Regenerated `habit.g.dart`
- [ ] Unit tests for new fields

---

### **PHASE 2: RRule Service Implementation** (5-6 days)
**Goal:** Create centralized service for all RRule operations

#### Tasks:

1. **Create `lib/services/rrule_service.dart`**
   
   **Core Methods:**
   ```dart
   class RRuleService {
     // CONVERSION: Old format -> RRule
     static String convertLegacyToRRule(Habit habit);
     
     // GENERATION: Create RRule from UI inputs
     static String createRRule({
       required Frequency frequency,
       int interval = 1,
       List<int>? byWeekDays,
       List<int>? byMonthDays,
       int? bySetPos,
       DateTime? until,
       int? count,
     });
     
     // PARSING: RRule -> Occurrences
     static List<DateTime> getOccurrences({
       required String rruleString,
       required DateTime startDate,
       required DateTime rangeStart,
       required DateTime rangeEnd,
     });
     
     // CHECK: Is habit due on specific date?
     static bool isDueOnDate({
       required String rruleString,
       required DateTime startDate,
       required DateTime checkDate,
     });
     
     // DISPLAY: Human-readable summary
     static String getRRuleSummary(String rruleString);
     
     // VALIDATION
     static bool isValidRRule(String rruleString);
   }
   ```

2. **Implement Legacy Conversion Logic**
   ```dart
   static String convertLegacyToRRule(Habit habit) {
     switch (habit.frequency) {
       case HabitFrequency.hourly:
         return 'FREQ=HOURLY';
       case HabitFrequency.daily:
         return 'FREQ=DAILY';
       case HabitFrequency.weekly:
         // Convert selectedWeekdays to BYDAY
         final days = habit.selectedWeekdays.map((d) => _dayToRRule(d)).join(',');
         return 'FREQ=WEEKLY;BYDAY=$days';
       case HabitFrequency.monthly:
         // Convert selectedMonthDays to BYMONTHDAY
         final days = habit.selectedMonthDays.join(',');
         return 'FREQ=MONTHLY;BYMONTHDAY=$days';
       case HabitFrequency.yearly:
         // Convert selectedYearlyDates
         // Complex: need to parse dates and create BYMONTH+BYMONTHDAY
         return _convertYearlyDates(habit.selectedYearlyDates);
       case HabitFrequency.single:
         // Single events don't repeat
         return null;
     }
   }
   ```

3. **Comprehensive Testing**
   - Unit tests for each conversion scenario
   - Edge cases (leap years, DST, timezone issues)
   - Performance testing with large date ranges

**Deliverables:**
- [ ] Complete `rrule_service.dart`
- [ ] 100% test coverage for core methods
- [ ] Performance benchmarks
- [ ] Example usage documentation

---

### **PHASE 3: Service Layer Refactoring** (7-10 days)
**Goal:** Update all services to use RRuleService

#### Priority Order:

**3.1 High Priority Services (Days 1-3)**

1. **`habit_stats_service.dart`**
   - Update `isCompletedForCurrentPeriod()` 
   - Use RRule to determine period boundaries
   
2. **`calendar_service.dart`**
   - Replace `isHabitDueOnDate()` with RRuleService
   - Update `getHabitsForDateRange()`

3. **`widget_service.dart` & `widget_integration_service.dart`**
   - Update `_isHabitActiveOnDate()` 
   - Centralize to use RRuleService

**3.2 Medium Priority Services (Days 4-6)**

4. **`work_manager_habit_service.dart`**
   - Update notification scheduling logic
   - Generate notification dates using RRule occurrences
   - Simplify `_scheduleWeeklyContinuous`, `_scheduleMonthlyContinuous`, etc.
   - Consolidate into single `_scheduleNotifications()` method

5. **`alarm_manager_service.dart` & `alarm_service.dart`**
   - Update alarm scheduling to use RRule occurrences
   - Remove frequency-specific logic

**3.3 Low Priority Services (Days 7-10)**

6. **`trend_analysis_service.dart`**
   - Update pattern detection to work with RRule
   
7. **`comprehensive_habit_suggestions_service.dart`**
   - Update suggestions to include RRule patterns

#### Refactoring Pattern for Each Service:

**Before:**
```dart
switch (habit.frequency) {
  case HabitFrequency.daily:
    // daily logic
  case HabitFrequency.weekly:
    // weekly logic
  // ... etc
}
```

**After:**
```dart
if (habit.usesRRule && habit.rruleString != null) {
  return RRuleService.isDueOnDate(
    rruleString: habit.rruleString!,
    startDate: habit.dtStart ?? habit.createdAt,
    checkDate: date,
  );
} else {
  // Legacy fallback
  return _legacyIsDueOnDate(habit, date);
}
```

**Deliverables:**
- [ ] All services updated to support RRule
- [ ] Legacy code paths maintained
- [ ] Integration tests passing
- [ ] Performance maintained or improved

---

### **PHASE 4: UI Refactoring** (8-12 days)
**Goal:** Update all UI to work with RRule system

#### **4.1 RRule Builder Widget** (Days 1-5)

Create `lib/ui/widgets/rrule_builder_widget.dart`:

**UI Components:**

1. **Frequency Selector**
   ```
   [ Hourly ] [ Daily ] [ Weekly ] [ Monthly ] [ Yearly ]
   ```

2. **Interval Input** (shown for all frequencies)
   ```
   Repeat every [  2  ] week(s)
   ```

3. **Day Selector** (for Weekly)
   ```
   [ S ] [ M ] [ T ] [ W ] [ T ] [ F ] [ S ]
   ```

4. **Monthly Options** (for Monthly)
   ```
   ( ) On day: [ 15 ] of each month
   ( ) On the [ Third ▼ ] [ Tuesday ▼ ]
   ```

5. **Yearly Options** (for Yearly)
   ```
   On [ July ▼ ] [ 4 ]
   ```

6. **Termination Options**
   ```
   ( ) Never
   ( ) After [ 10 ] occurrences
   ( ) On date: [Pick Date]
   ```

7. **Preview Panel** (Real-time summary)
   ```
   ╔════════════════════════════════════╗
   ║  📅 Repeats every 2 weeks on      ║
   ║     Tuesday and Thursday          ║
   ║                                    ║
   ║  Next 5 occurrences:              ║
   ║  • Oct 3, 2025                    ║
   ║  • Oct 5, 2025                    ║
   ║  • Oct 17, 2025                   ║
   ║  • Oct 19, 2025                   ║
   ║  • Oct 31, 2025                   ║
   ╚════════════════════════════════════╝
   ```

**Implementation:**
```dart
class RRuleBuilderWidget extends StatefulWidget {
  final String? initialRRule;
  final DateTime? initialStartDate;
  final Function(String rrule, DateTime startDate) onRRuleChanged;
  
  // ... widget implementation
}
```

**Deliverables:**
- [ ] Complete RRule builder widget
- [ ] Real-time preview
- [ ] Input validation
- [ ] User-friendly error messages

#### **4.2 Update Habit Creation/Edit Screens** (Days 6-8)

1. **`create_habit_screen.dart`**
   - Replace current frequency selector with RRuleBuilderWidget
   - Keep simple mode for basic users (daily, weekly, etc.)
   - Add "Advanced" mode for RRule builder
   - Save `rruleString` and `dtStart` when creating habit

2. **`edit_habit_screen.dart`**
   - Same updates as create screen
   - Handle migration of old habits to RRule on edit
   - Show warning if converting from legacy format

**UI Flow:**
```
┌─────────────────────────────────┐
│  Create Habit                   │
├─────────────────────────────────┤
│  Name: [           ]            │
│  Category: [Health ▼]           │
│                                 │
│  Schedule Type:                 │
│  ( ) Simple (Daily/Weekly/etc)  │
│  (•) Advanced (Custom pattern)  │
│                                 │
│  [RRule Builder Widget]         │
│                                 │
│  [ Cancel ]  [ Create Habit ]   │
└─────────────────────────────────┘
```

**Deliverables:**
- [ ] Updated create screen
- [ ] Updated edit screen  
- [ ] Simple/Advanced mode toggle
- [ ] Migration on edit

#### **4.3 Update Display Screens** (Days 9-12)

1. **`timeline_screen.dart`**
   - Update `_getHabitTimeDisplay()` to show RRule summary
   - Use RRuleService for occurrence checking

2. **`calendar_screen.dart`**
   - Update `_isHabitScheduledForDate()` to use RRule
   - Show RRule summary in habit details

3. **`all_habits_screen.dart`**
   - Display RRule summary instead of simple frequency
   - Show next occurrence date

4. **Widget timeline views**
   - Update `widget_timeline_view.dart`
   - Use RRule for display logic

**Deliverables:**
- [ ] All display screens updated
- [ ] Consistent RRule summaries
- [ ] No regression in functionality

---

### **PHASE 5: Data Migration** (3-5 days)
**Goal:** Migrate all existing habits to RRule format

#### Tasks:

1. **Create Migration Script**
   - `scripts/migrate_habits_to_rrule.dart`
   - Batch process all habits
   - Convert using RRuleService
   - Validate conversions

2. **Migration Strategy**
   - Option A: Automatic migration on app update
   - Option B: Lazy migration (convert on first access)
   - Option C: User-triggered migration
   
   **Recommendation: Lazy Migration**
   - Less risky
   - Faster app startup
   - Individual validation

3. **Implementation**
   ```dart
   // In Habit class
   String getOrCreateRRule() {
     if (usesRRule && rruleString != null) {
       return rruleString!;
     }
     
     // Lazy migration
     rruleString = RRuleService.convertLegacyToRRule(this);
     dtStart = dtStart ?? createdAt;
     usesRRule = true;
     save(); // Save to Hive
     
     return rruleString!;
   }
   ```

4. **Validation & Rollback**
   - Create backup before migration
   - Validate each habit after conversion
   - Provide rollback mechanism
   - Log migration errors

5. **Testing**
   - Test with database of diverse habits
   - Edge cases (complex yearly patterns)
   - Performance testing with large datasets

**Deliverables:**
- [ ] Migration script
- [ ] Lazy migration in Habit class
- [ ] Backup/rollback system
- [ ] Migration report/logs

---

### **PHASE 6: Legacy Cleanup** (2-3 days)
**Goal:** Remove old frequency system (optional, after stable RRule)

#### Tasks:

1. **Deprecate Old Fields** (Mark for removal)
   ```dart
   @deprecated
   @HiveField(19)
   List<int>? selectedWeekdays = [];
   ```

2. **Remove Switch Statements**
   - Remove all `switch (habit.frequency)` blocks
   - Keep only RRule logic

3. **Simplify Enum**
   - Consider removing HabitFrequency enum entirely
   - Or keep for UI convenience (maps to simple RRules)

4. **Database Cleanup**
   - Optional: Remove deprecated fields from database
   - Requires careful migration and testing

**Deliverables:**
- [ ] Deprecated old fields
- [ ] Removed redundant code
- [ ] Simplified codebase
- [ ] Updated documentation

---

### **PHASE 7: Testing & Polish** (5-7 days)
**Goal:** Ensure rock-solid stability

#### Tasks:

1. **Comprehensive Testing**
   - Unit tests for RRuleService (100% coverage)
   - Integration tests for all services
   - UI tests for RRule builder
   - End-to-end user flows

2. **Edge Case Testing**
   - Leap years
   - Daylight saving time
   - Timezone changes
   - Invalid RRule strings
   - Very complex patterns

3. **Performance Testing**
   - Large date ranges (years)
   - Many habits (1000+)
   - Widget update performance
   - Notification scheduling speed

4. **User Testing**
   - Beta testing with real users
   - Gather feedback on UI
   - Identify confusing patterns

5. **Documentation**
   - Update user manual
   - Create RRule examples
   - Developer documentation
   - Migration guide

**Deliverables:**
- [ ] Test suite (95%+ coverage)
- [ ] Performance benchmarks
- [ ] User feedback incorporated
- [ ] Complete documentation

---

## 📋 RRule Pattern Reference

### Current Frequency Type Conversions

| Legacy Type | RRule Pattern | Example |
|-------------|--------------|---------|
| Hourly | `FREQ=HOURLY` | Every hour |
| Daily | `FREQ=DAILY` | Every day |
| Weekly (Mon, Wed, Fri) | `FREQ=WEEKLY;BYDAY=MO,WE,FR` | Every week on M/W/F |
| Monthly (15th) | `FREQ=MONTHLY;BYMONTHDAY=15` | 15th of each month |
| Yearly (July 4) | `FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=4` | Every July 4th |
| Single | (No RRule - one-time event) | Oct 3, 2025 at 2pm |

### New Complex Patterns (Enabled by RRule)

| Pattern | RRule String |
|---------|-------------|
| Every other week | `FREQ=WEEKLY;INTERVAL=2` |
| Every 3 days | `FREQ=DAILY;INTERVAL=3` |
| Third Tuesday of each month | `FREQ=MONTHLY;BYDAY=3TU` |
| Last Friday of each month | `FREQ=MONTHLY;BYDAY=-1FR` |
| Weekdays only | `FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR` |
| First and 15th of month | `FREQ=MONTHLY;BYMONTHDAY=1,15` |
| Every quarter (Jan/Apr/Jul/Oct) | `FREQ=MONTHLY;INTERVAL=3;BYMONTH=1` |

---

## 🚨 Risk Assessment & Mitigation

### High Risk Areas

1. **Data Loss During Migration**
   - **Risk:** Habits lose scheduling info
   - **Mitigation:** Backup before migration, extensive testing, lazy migration
   
2. **Performance Degradation**
   - **Risk:** RRule parsing slower than current system
   - **Mitigation:** Caching, benchmarking, optimization

3. **User Confusion**
   - **Risk:** RRule UI too complex
   - **Mitigation:** Simple/Advanced modes, good defaults, previews

4. **Backward Compatibility**
   - **Risk:** Breaking existing habits
   - **Mitigation:** Keep legacy support, gradual migration

### Medium Risk Areas

5. **Notification Scheduling**
   - **Risk:** Alarms not firing correctly
   - **Mitigation:** Extensive testing, logging, fallback logic

6. **Widget Updates**
   - **Risk:** Widgets showing wrong habits
   - **Mitigation:** Integration tests, widget test harness

### Low Risk Areas

7. **UI Polish**
   - **Risk:** Less intuitive UI
   - **Mitigation:** User testing, iteration

---

## 📈 Success Metrics

### Technical Metrics
- [ ] **Code Reduction:** 30-40% less frequency-checking code
- [ ] **Test Coverage:** 95%+ for RRule functionality
- [ ] **Performance:** No degradation in habit loading/checking
- [ ] **Bug Rate:** < 5 bugs in first month post-release

### User Metrics
- [ ] **Feature Adoption:** 20%+ users create custom RRule patterns
- [ ] **Migration Success:** 99.9%+ habits migrated successfully
- [ ] **User Satisfaction:** No increase in negative reviews
- [ ] **Support Tickets:** < 10 RRule-related issues in first month

---

## 🗓️ Timeline Estimate

| Phase | Duration | Cumulative |
|-------|----------|------------|
| Phase 0: Preparation | 2-3 days | 3 days |
| Phase 1: Data Model | 3-4 days | 7 days |
| Phase 2: RRule Service | 5-6 days | 13 days |
| Phase 3: Service Layer | 7-10 days | 23 days |
| Phase 4: UI Refactoring | 8-12 days | 35 days |
| Phase 5: Migration | 3-5 days | 40 days |
| Phase 6: Cleanup | 2-3 days | 43 days |
| Phase 7: Testing | 5-7 days | **50 days** |

**Total Estimated Time:** 7-8 weeks (50 days)

**With parallel work and optimizations:** 5-6 weeks possible

---

## 🎯 Quick Wins & MVP

### Minimal Viable Product (MVP) - 2 weeks
If you need results faster, here's an MVP approach:

**Week 1:**
- Phase 0 + Phase 1 + Phase 2 (Core RRule service)
- Support only NEW habits with RRule
- Keep legacy habits on old system

**Week 2:**
- Phase 4.1 + 4.2 (Basic UI for new habits)
- Phase 3.1 (Core services updated)

**Result:** Users can create new habits with RRule, old habits continue working

### Quick Win Features
These could be implemented early to show value:
1. "Every other week" pattern (frequently requested)
2. "Weekdays only" pattern (common use case)
3. "Last day of month" pattern (useful for monthly habits)

---

## 🔄 Rollout Strategy

### Staged Rollout (Recommended)

**Stage 1: Internal Testing (1 week)**
- Developers only
- Test all scenarios
- Fix critical bugs

**Stage 2: Beta Testing (2 weeks)**
- 50-100 beta users
- Monitor crashes, errors
- Gather feedback

**Stage 3: Gradual Rollout (3 weeks)**
- Week 1: 10% of users
- Week 2: 50% of users
- Week 3: 100% of users

**Stage 4: Legacy Cleanup (After 1 month stable)**
- Begin deprecating old system
- Full migration to RRule

---

## 📚 Dependencies & Prerequisites

### Package Dependencies
```yaml
dependencies:
  rrule: ^0.2.15  # RRule implementation
  intl: ^0.18.0   # Date formatting (already in project)
  hive: ^2.2.3    # Database (already in project)
```

### Development Tools
- Flutter SDK 3.0+
- Dart 3.0+
- Build runner (for Hive)

### Knowledge Requirements
- Understanding of RRule/iCalendar standard
- Flutter state management
- Hive database
- Android WorkManager
- Widget development

---

## 🎓 Learning Resources

### RRule Standard
- [RFC 5545](https://tools.ietf.org/html/rfc5545) - iCalendar specification
- [RRule.js Documentation](https://github.com/jakubroztocil/rrule) - Great examples
- [Dart rrule package](https://pub.dev/packages/rrule) - Official docs

### Testing Resources
- Examples of RRule patterns
- Edge cases to test
- Performance benchmarks

---

## ✅ Pre-Flight Checklist

Before starting the refactoring:

- [ ] Full backup of production database
- [ ] All current tests passing
- [ ] No critical bugs in current system
- [ ] Team alignment on approach
- [ ] Time allocated for full refactoring
- [ ] Beta testers identified
- [ ] Rollback plan documented
- [ ] Monitoring/logging in place

---

## 🎉 Expected Benefits

### For Developers
1. **Simpler Code:** One system instead of 6+ frequency types
2. **Easier Maintenance:** Centralized logic
3. **Faster Feature Development:** New patterns = just new RRule strings
4. **Better Testing:** Standard patterns, predictable behavior
5. **Industry Standard:** Well-documented, proven approach

### For Users
1. **More Flexibility:** Complex patterns now possible
2. **Better Clarity:** Human-readable summaries
3. **Reliability:** Battle-tested standard
4. **Future-Proof:** Can add any pattern without code changes

### For Product
1. **Competitive Advantage:** More flexible than competitors
2. **Reduced Support:** Fewer bugs, clearer behavior
3. **Faster Iterations:** New features easier to add
4. **Better UX:** Consistent behavior across app

---

## 📝 Next Steps

1. **Review this plan** with team
2. **Validate timeline** against available resources
3. **Prioritize phases** based on business needs
4. **Create tickets** in project management system
5. **Start Phase 0** when approved
6. **Regular check-ins** to track progress

---

## 🤝 Approval & Sign-off

- [ ] Technical Lead Review
- [ ] Product Owner Approval
- [ ] Timeline Confirmed
- [ ] Resources Allocated
- [ ] Risk Assessment Accepted
- [ ] Ready to Begin

---

**Document Version:** 1.0  
**Created:** October 3, 2025  
**Author:** GitHub Copilot  
**Status:** DRAFT - Awaiting Approval
