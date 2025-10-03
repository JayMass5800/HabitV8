# 🏗️ RRule System Architecture

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                           USER INTERFACE LAYER                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │ Simple Mode      │  │ Advanced Mode    │  │ Preview Panel   │  │
│  │ ┌──────────┐     │  │ ┌──────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ [ Daily  ]     │  │ │ Frequency: ▼ │ │  │ │ Repeats     │ │  │
│  │ │ [ Weekly ]     │  │ │ Interval:  ▼ │ │  │ │ every 2     │ │  │
│  │ │ [ Monthly]     │  │ │ Days:   [✓✓] │ │  │ │ weeks on    │ │  │
│  │ │ [ Custom ]     │  │ │ Until:  [📅] │ │  │ │ Tue & Thu   │ │  │
│  │ └──────────┘     │  │ └──────────────┘ │  │ └─────────────┘ │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
│            │                    │                      ▲             │
│            └────────────────────┼──────────────────────┘             │
│                                 ▼                                    │
│                    ┌────────────────────────┐                        │
│                    │ RRuleBuilderWidget     │                        │
│                    │  - Validates input     │                        │
│                    │  - Builds RRule string │                        │
│                    │  - Shows preview       │                        │
│                    └────────────────────────┘                        │
│                                 │                                    │
└─────────────────────────────────┼────────────────────────────────────┘
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         SERVICE LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │                    RRuleService (★ CORE ★)                    │ │
│  ├───────────────────────────────────────────────────────────────┤ │
│  │                                                               │ │
│  │  📝 convertLegacyToRRule(Habit) → String                     │ │
│  │     └─ Converts old frequency system to RRule string         │ │
│  │                                                               │ │
│  │  🔨 createRRule(...) → String                                │ │
│  │     └─ Builds RRule from UI components                       │ │
│  │                                                               │ │
│  │  📅 getOccurrences(rrule, startDate, range) → List<DateTime> │ │
│  │     └─ Generates list of occurrence dates                    │ │
│  │                                                               │ │
│  │  ✅ isDueOnDate(rrule, startDate, checkDate) → bool         │ │
│  │     └─ Checks if habit is due on specific date              │ │
│  │                                                               │ │
│  │  📖 getRRuleSummary(rrule) → String                          │ │
│  │     └─ "Repeats every 2 weeks on Tuesday and Thursday"      │ │
│  │                                                               │ │
│  │  ✔️ isValidRRule(rrule) → bool                               │ │
│  │     └─ Validates RRule string format                         │ │
│  │                                                               │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                 │                                    │
│                    ┌────────────┼────────────┐                      │
│                    ▼            ▼            ▼                       │
│  ┌──────────────────┐ ┌─────────────┐ ┌──────────────────┐         │
│  │ CalendarService  │ │WidgetService│ │ AlarmService     │         │
│  │                  │ │             │ │                  │         │
│  │ Uses RRule to:   │ │Uses RRule   │ │ Uses RRule to:   │         │
│  │ - Filter habits  │ │to show      │ │ - Schedule alarms│         │
│  │ - Show due dates │ │habits in    │ │ - Set reminders  │         │
│  └──────────────────┘ │widgets      │ └──────────────────┘         │
│                       └─────────────┘                               │
│  ┌──────────────────┐ ┌─────────────┐ ┌──────────────────┐         │
│  │ StatsService     │ │WorkManager  │ │ TrendService     │         │
│  │                  │ │Service      │ │                  │         │
│  │ Uses RRule for:  │ │             │ │ Uses RRule for:  │         │
│  │ - Streaks        │ │Schedule     │ │ - Pattern detect │         │
│  │ - Completion %   │ │notifications│ │ - Analytics      │         │
│  └──────────────────┘ └─────────────┘ └──────────────────┘         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │                      Habit Model (Updated)                    │ │
│  ├───────────────────────────────────────────────────────────────┤ │
│  │                                                               │ │
│  │  // NEW FIELDS (RRule-based)                                 │ │
│  │  @HiveField(28)                                              │ │
│  │  String? rruleString;     // "FREQ=WEEKLY;BYDAY=MO,WE,FR"   │ │
│  │                                                               │ │
│  │  @HiveField(29)                                              │ │
│  │  DateTime? dtStart;       // Start date for recurrence       │ │
│  │                                                               │ │
│  │  @HiveField(30)                                              │ │
│  │  bool usesRRule = false;  // Migration flag                  │ │
│  │                                                               │ │
│  │  ─────────────────────────────────────────────────────────   │ │
│  │                                                               │ │
│  │  // LEGACY FIELDS (Deprecated, kept for backward compat)     │ │
│  │  @deprecated                                                  │ │
│  │  HabitFrequency frequency;                                    │ │
│  │                                                               │ │
│  │  @deprecated                                                  │ │
│  │  List<int> selectedWeekdays;                                 │ │
│  │                                                               │ │
│  │  @deprecated                                                  │ │
│  │  List<int> selectedMonthDays;                                │ │
│  │                                                               │ │
│  │  @deprecated                                                  │ │
│  │  List<String> selectedYearlyDates;                           │ │
│  │                                                               │ │
│  │  @deprecated                                                  │ │
│  │  List<String> hourlyTimes;                                   │ │
│  │                                                               │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                 │                                    │
│                                 ▼                                    │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │                    Hive Local Database                        │ │
│  │  ┌─────────────────────────────────────────────────────────┐ │ │
│  │  │ Box<Habit>                                              │ │ │
│  │  │                                                         │ │ │
│  │  │  Habit 1: "Gym"          (usesRRule: true)             │ │ │
│  │  │    rrule: "FREQ=WEEKLY;BYDAY=MO,WE,FR"                 │ │ │
│  │  │    dtStart: 2025-01-01                                 │ │ │
│  │  │                                                         │ │ │
│  │  │  Habit 2: "Read"         (usesRRule: false - legacy)   │ │ │
│  │  │    frequency: daily                                    │ │ │
│  │  │    selectedWeekdays: []                                │ │ │
│  │  │                                                         │ │ │
│  │  │  Habit 3: "Meditate"     (usesRRule: true)             │ │ │
│  │  │    rrule: "FREQ=DAILY"                                 │ │ │
│  │  │    dtStart: 2025-10-01                                 │ │ │
│  │  └─────────────────────────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Migration Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MIGRATION PROCESS                                 │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐
│ App Launches │
└──────┬───────┘
       │
       ▼
┌─────────────────────────────────┐
│ Load Habits from Hive Database  │
└──────────┬──────────────────────┘
           │
           ▼
    ┌──────────────┐
    │ For each     │
    │ Habit        │
    └──────┬───────┘
           │
           ▼
    ┌─────────────────────────────┐
    │ Check: usesRRule == true?   │
    └──────┬──────────────┬───────┘
           │              │
       YES │              │ NO
           │              │
           ▼              ▼
    ┌──────────────┐  ┌──────────────────────────────┐
    │ Use RRule    │  │ LAZY MIGRATION               │
    │ System       │  │                              │
    └──────────────┘  │ 1. Call convertLegacyToRRule │
                      │ 2. Set rruleString           │
                      │ 3. Set dtStart               │
                      │ 4. Set usesRRule = true      │
                      │ 5. Save to database          │
                      │ 6. Log migration             │
                      └──────────────────────────────┘

ALTERNATIVE: Batch Migration on App Update
┌────────────────────────────┐
│ App Updates to New Version │
└──────────┬─────────────────┘
           │
           ▼
┌──────────────────────────────┐
│ Migration Service Runs Once  │
│                              │
│ For ALL habits:              │
│ - Convert to RRule           │
│ - Validate conversion        │
│ - Log results                │
│ - Mark as migrated           │
└──────────────────────────────┘
```

---

## Data Flow: Creating a New Habit

```
┌──────────────────────────────────────────────────────────────────────┐
│                 CREATE HABIT FLOW (NEW SYSTEM)                        │
└──────────────────────────────────────────────────────────────────────┘

1. USER INPUT
┌─────────────────────────────┐
│ User selects:               │
│ - "Every 2 weeks"           │
│ - On Tuesday & Thursday     │
│ - Starting Oct 1, 2025      │
└──────────┬──────────────────┘
           │
           ▼
2. UI VALIDATION
┌─────────────────────────────┐
│ RRuleBuilderWidget          │
│ - Validates inputs          │
│ - Shows preview             │
│ - Calculates next 5 dates   │
└──────────┬──────────────────┘
           │
           ▼
3. RRULE GENERATION
┌─────────────────────────────┐
│ RRuleService.createRRule()  │
│                             │
│ Input:                      │
│  frequency: WEEKLY          │
│  interval: 2                │
│  byWeekDays: [TU, TH]       │
│                             │
│ Output:                     │
│  "FREQ=WEEKLY;INTERVAL=2;   │
│   BYDAY=TU,TH"              │
└──────────┬──────────────────┘
           │
           ▼
4. CREATE HABIT OBJECT
┌─────────────────────────────┐
│ Habit.create(               │
│   name: "Gym",              │
│   rruleString: "FREQ=...",  │
│   dtStart: 2025-10-01,      │
│   usesRRule: true,          │
│ )                           │
└──────────┬──────────────────┘
           │
           ▼
5. SAVE TO DATABASE
┌─────────────────────────────┐
│ Hive: habits.add(habit)     │
│ habit.save()                │
└──────────┬──────────────────┘
           │
           ▼
6. SCHEDULE NOTIFICATIONS
┌─────────────────────────────┐
│ WorkManagerService          │
│ - Get next 30 occurrences   │
│ - Schedule notifications    │
│ - Set alarms if enabled     │
└─────────────────────────────┘
```

---

## Data Flow: Checking if Habit is Due

```
┌──────────────────────────────────────────────────────────────────────┐
│              CHECK IF HABIT DUE (TIMELINE/CALENDAR VIEW)              │
└──────────────────────────────────────────────────────────────────────┘

USER ACTION
┌─────────────────────────────┐
│ User opens Timeline screen  │
│ Date: October 3, 2025       │
└──────────┬──────────────────┘
           │
           ▼
LOAD HABITS
┌─────────────────────────────┐
│ Get all active habits       │
│ from Hive database          │
└──────────┬──────────────────┘
           │
           ▼
FOR EACH HABIT
┌─────────────────────────────────────────┐
│ Habit: "Gym"                            │
│ rruleString: "FREQ=WEEKLY;INTERVAL=2;   │
│               BYDAY=TU,TH"              │
│ dtStart: 2025-09-30                     │
│ usesRRule: true                         │
└──────────┬──────────────────────────────┘
           │
           ▼
CHECK WITH RRULE SERVICE
┌─────────────────────────────────────────┐
│ RRuleService.isDueOnDate(               │
│   rruleString: "FREQ=WEEKLY...",        │
│   startDate: 2025-09-30,                │
│   checkDate: 2025-10-03                 │
│ )                                       │
└──────────┬──────────────────────────────┘
           │
           ▼
PARSE RRULE
┌─────────────────────────────────────────┐
│ RecurrenceRule.fromString(...)          │
│ - Parse frequency: WEEKLY               │
│ - Parse interval: 2                     │
│ - Parse days: TU, TH                    │
└──────────┬──────────────────────────────┘
           │
           ▼
GENERATE OCCURRENCES
┌─────────────────────────────────────────┐
│ Get occurrences in range:               │
│ [2025-10-03 00:00 - 2025-10-03 23:59]   │
│                                         │
│ Results:                                │
│ • 2025-10-03 (Thursday) ✅              │
└──────────┬──────────────────────────────┘
           │
           ▼
RETURN RESULT
┌─────────────────────────────────────────┐
│ isDue = true                            │
│                                         │
│ Display "Gym" on timeline for Oct 3     │
└─────────────────────────────────────────┘
```

---

## Code Organization

```
c:\HabitV8\
│
├── lib/
│   ├── domain/
│   │   └── model/
│   │       ├── habit.dart              ← Updated with RRule fields
│   │       └── habit.g.dart            ← Regenerated by Hive
│   │
│   ├── services/
│   │   ├── rrule_service.dart          ← NEW: Core RRule logic ★
│   │   │
│   │   ├── calendar_service.dart       ← UPDATED: Use RRuleService
│   │   ├── widget_service.dart         ← UPDATED: Use RRuleService
│   │   ├── alarm_manager_service.dart  ← UPDATED: Use RRuleService
│   │   ├── work_manager_habit_service.dart  ← UPDATED
│   │   ├── habit_stats_service.dart    ← UPDATED: Use RRuleService
│   │   └── ... (other services)        ← UPDATED as needed
│   │
│   └── ui/
│       ├── widgets/
│       │   └── rrule_builder_widget.dart  ← NEW: RRule UI builder ★
│       │
│       └── screens/
│           ├── create_habit_screen.dart   ← UPDATED: Use builder
│           ├── edit_habit_screen.dart     ← UPDATED: Use builder
│           ├── timeline_screen.dart       ← UPDATED: Show RRule summary
│           ├── calendar_screen.dart       ← UPDATED: Use RRuleService
│           └── all_habits_screen.dart     ← UPDATED: Display RRule
│
├── scripts/
│   └── migrate_habits_to_rrule.dart    ← NEW: Migration script
│
├── test/
│   ├── services/
│   │   └── rrule_service_test.dart     ← NEW: Comprehensive tests
│   └── ... (other test files)
│
└── docs/
    ├── RRULE_REFACTORING_PLAN.md       ← Strategic plan (this doc)
    ├── RRULE_QUICK_REFERENCE.md        ← Quick reference guide
    ├── RRULE_ARCHITECTURE.md           ← Architecture (current doc)
    └── RRULE_PATTERNS.md               ← Pattern examples
```

---

## Component Responsibilities

### RRuleService (Core Service)
**Location:** `lib/services/rrule_service.dart`

**Responsibilities:**
- Convert legacy habits to RRule format
- Generate RRule strings from UI inputs
- Parse RRule strings into occurrence dates
- Check if habit is due on specific date
- Create human-readable summaries
- Validate RRule strings

**Dependencies:**
- `rrule` package (pub.dev)
- Habit model
- DateTime utilities

**Used By:**
- All services that need to check habit scheduling
- UI components for display
- Notification scheduling
- Widget data generation

---

### RRuleBuilderWidget (UI Component)
**Location:** `lib/ui/widgets/rrule_builder_widget.dart`

**Responsibilities:**
- Present user-friendly interface for RRule creation
- Validate user inputs in real-time
- Generate preview of upcoming occurrences
- Create RRule string from user selections
- Handle simple and advanced modes

**Dependencies:**
- RRuleService for validation and preview
- Flutter Material widgets

**Used By:**
- CreateHabitScreen
- EditHabitScreen

---

### Migration Service
**Location:** `scripts/migrate_habits_to_rrule.dart` or lazy migration in Habit class

**Responsibilities:**
- Convert all existing habits to RRule format
- Validate conversions
- Log migration results
- Handle errors gracefully
- Create backups

**Dependencies:**
- RRuleService for conversion
- Hive database
- Logging system

**Used By:**
- App initialization (one-time)
- Or lazy loading (on-demand)

---

## State Management

```
┌────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT                         │
└────────────────────────────────────────────────────────────┘

HABIT STATE
┌──────────────────────────────────────┐
│ Hive Database (Source of Truth)     │
│ - Persisted on disk                 │
│ - All habit data including RRule    │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ Provider / BLoC / State Management   │
│ - Caches habits in memory           │
│ - Notifies UI of changes            │
│ - Manages habit operations          │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ UI Widgets (Consumers)              │
│ - Display habit data                │
│ - Trigger habit updates             │
│ - Show real-time changes            │
└─────────────────────────────────────┘

RRULE CACHE (Optional Performance Optimization)
┌──────────────────────────────────────┐
│ In-Memory Cache                     │
│ - Parsed RRule objects              │
│ - Generated occurrences             │
│ - TTL: 1 hour                       │
│ - Invalidate on habit edit          │
└─────────────────────────────────────┘
```

---

## Error Handling

```
┌────────────────────────────────────────────────────────────┐
│                    ERROR HANDLING STRATEGY                  │
└────────────────────────────────────────────────────────────┘

INVALID RRULE STRING
┌──────────────────────────────────────┐
│ User edits habit manually            │
│ RRule string becomes invalid         │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ RRuleService.isValidRRule() = false │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ FALLBACK STRATEGIES                 │
│                                     │
│ 1. Use legacy frequency fields      │
│ 2. Convert legacy to RRule          │
│ 3. Default to FREQ=DAILY            │
│ 4. Show error to user               │
│ 5. Log error for debugging          │
└─────────────────────────────────────┘

MIGRATION FAILURE
┌──────────────────────────────────────┐
│ Habit fails to convert              │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ RECOVERY STRATEGIES                 │
│                                     │
│ 1. Log the failure                  │
│ 2. Keep habit on legacy system      │
│ 3. Mark for manual review           │
│ 4. Continue with other habits       │
│ 5. Alert user of issues             │
└─────────────────────────────────────┘

PARSING ERROR
┌──────────────────────────────────────┐
│ RRule parsing throws exception      │
└──────────┬───────────────────────────┘
           │
           ▼
┌──────────────────────────────────────┐
│ ERROR HANDLING                      │
│                                     │
│ try {                               │
│   RRule.fromString(...)             │
│ } catch (e) {                       │
│   logger.error('RRule parse: $e')  │
│   return _useLegacyLogic(habit)    │
│ }                                   │
└─────────────────────────────────────┘
```

---

## Performance Considerations

### Optimization Strategies

1. **Caching**
   ```dart
   // Cache parsed RRule objects
   Map<String, RecurrenceRule> _rruleCache = {};
   
   RecurrenceRule _getOrParseRRule(String rruleString) {
     if (_rruleCache.containsKey(rruleString)) {
       return _rruleCache[rruleString]!;
     }
     final rule = RecurrenceRule.fromString(rruleString);
     _rruleCache[rruleString] = rule;
     return rule;
   }
   ```

2. **Limit Date Ranges**
   ```dart
   // Don't generate 1000s of occurrences
   List<DateTime> occurrences = rrule.getOccurrences(
     start: today,
     end: today.add(Duration(days: 90)), // Limit to 90 days
   );
   ```

3. **Lazy Evaluation**
   ```dart
   // Generate occurrences only when needed
   bool isDue = RRuleService.isDueOnDate(
     // Only checks single date, not entire range
   );
   ```

4. **Index Optimization**
   ```dart
   // Index habits by RRule pattern for quick lookup
   Map<String, List<Habit>> _habitsByRRule = {};
   ```

---

## Security Considerations

1. **Input Validation**
   - Always validate RRule strings before parsing
   - Prevent injection attacks via malformed strings
   - Sanitize user inputs

2. **Data Integrity**
   - Validate conversions during migration
   - Log all data changes
   - Maintain backup before migration

3. **Privacy**
   - RRule strings don't contain sensitive data
   - Safe to log for debugging
   - Can be exported without privacy concerns

---

## Backward Compatibility

```
┌────────────────────────────────────────────────────────────┐
│           BACKWARD COMPATIBILITY STRATEGY                   │
└────────────────────────────────────────────────────────────┘

OLD HABIT (Pre-RRule)
┌──────────────────────────────────────┐
│ Habit {                             │
│   frequency: HabitFrequency.weekly  │
│   selectedWeekdays: [1, 3, 5]       │
│   usesRRule: false                  │
│   rruleString: null                 │
│ }                                   │
└──────────┬───────────────────────────┘
           │
           ▼
ACCESS PATTERN
┌──────────────────────────────────────┐
│ habit.getOrCreateRRule()            │
│   ↓                                 │
│ if (usesRRule) return rruleString   │
│ else convertAndSave()               │
└──────────┬───────────────────────────┘
           │
           ▼
LAZY MIGRATION
┌──────────────────────────────────────┐
│ 1. Convert using legacy fields      │
│ 2. Set rruleString                  │
│ 3. Set usesRRule = true             │
│ 4. Keep legacy fields for rollback  │
│ 5. Save to database                 │
└─────────────────────────────────────┘

ROLLBACK CAPABILITY
┌──────────────────────────────────────┐
│ If RRule system fails:              │
│ - Legacy fields still present       │
│ - Can fall back to old logic        │
│ - No data loss                      │
└─────────────────────────────────────┘
```

---

## Testing Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    TESTING PYRAMID                          │
└────────────────────────────────────────────────────────────┘

                    ▲
                   / \
                  /   \
                 /  E2E \          ← End-to-End Tests
                /_______\            (5% of tests)
               /         \
              / Integration\        ← Integration Tests
             /______________\         (20% of tests)
            /                \
           /   Unit Tests     \     ← Unit Tests
          /____________________\      (75% of tests)


UNIT TESTS (lib/test/services/rrule_service_test.dart)
┌─────────────────────────────────────────────────────┐
│ • convertLegacyToRRule()                           │
│   - Daily → FREQ=DAILY                             │
│   - Weekly → FREQ=WEEKLY;BYDAY=...                 │
│   - Monthly → FREQ=MONTHLY;BYMONTHDAY=...          │
│   - Yearly → FREQ=YEARLY;BYMONTH=...;BYMONTHDAY=...│
│                                                     │
│ • isDueOnDate()                                    │
│   - Check various RRule patterns                   │
│   - Edge cases (leap year, DST, etc.)              │
│                                                     │
│ • getOccurrences()                                 │
│   - Generate correct dates                         │
│   - Handle long ranges                             │
│   - Performance tests                              │
│                                                     │
│ • getRRuleSummary()                                │
│   - Human-readable output                          │
│   - All frequency types                            │
└─────────────────────────────────────────────────────┘

INTEGRATION TESTS
┌─────────────────────────────────────────────────────┐
│ • Service integration                              │
│   - RRuleService + CalendarService                 │
│   - RRuleService + WidgetService                   │
│   - RRuleService + AlarmService                    │
│                                                     │
│ • Database integration                             │
│   - Save/load habits with RRule                    │
│   - Migration process                              │
│   - Data integrity                                 │
└─────────────────────────────────────────────────────┘

E2E TESTS
┌─────────────────────────────────────────────────────┐
│ • User flows                                       │
│   - Create habit with custom RRule                 │
│   - Edit habit, change RRule                       │
│   - View habit on timeline                         │
│   - Complete habit                                 │
│   - Receive notification                           │
└─────────────────────────────────────────────────────┘
```

---

## Deployment Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT PHASES                        │
└────────────────────────────────────────────────────────────┘

PHASE 1: DEV
┌──────────────────────────────────────┐
│ • Local testing                     │
│ • Developer devices                 │
│ • 100% RRule features enabled       │
└──────────┬───────────────────────────┘
           │
           ▼
PHASE 2: INTERNAL BETA
┌──────────────────────────────────────┐
│ • Internal testers (10 users)       │
│ • Firebase App Distribution         │
│ • Feature flag: 100% RRule          │
└──────────┬───────────────────────────┘
           │
           ▼
PHASE 3: PUBLIC BETA
┌──────────────────────────────────────┐
│ • Opt-in beta testers (100 users)   │
│ • Google Play Beta track            │
│ • Feature flag: 100% RRule          │
│ • Monitor crash reports             │
└──────────┬───────────────────────────┘
           │
           ▼
PHASE 4: GRADUAL ROLLOUT
┌──────────────────────────────────────┐
│ Week 1: 10% of users                │
│ Week 2: 25% of users                │
│ Week 3: 50% of users                │
│ Week 4: 100% of users               │
└──────────┬───────────────────────────┘
           │
           ▼
PHASE 5: FULL PRODUCTION
┌──────────────────────────────────────┐
│ • 100% of users                     │
│ • Feature flag: ON                  │
│ • Legacy code: Deprecated           │
└─────────────────────────────────────┘

FEATURE FLAGS
┌──────────────────────────────────────┐
│ bool enableRRule = RemoteConfig.get(│
│   'enable_rrule_system',            │
│   defaultValue: false               │
│ );                                  │
│                                     │
│ if (enableRRule) {                  │
│   // Use RRule system               │
│ } else {                            │
│   // Use legacy system              │
│ }                                   │
└─────────────────────────────────────┘
```

---

**Document Version:** 1.0  
**Last Updated:** October 3, 2025  
**Status:** Architecture Reference
