# Memory & Performance Optimization Plan

## Critical Issues Identified (from error2.md logs)

### Issue #1: Excessive Notification Cancellation Logging
**Severity:** HIGH - Causes 5-6 second save delays

**Problem:**
- When saving a habit, 73 notifications are cancelled individually
- Each cancellation logs with full 10-line stack trace
- Total: ~730 log lines per save operation
- Logs show: "Cancelled 73 notifications for habit: 1759600142892 (checked 232 pending)"

**Impact:**
- Memory allocation for 730+ log objects
- String concatenation overhead
- Garbage collection pressure (53MB-113MB freed during save)

**Solution:**
1. Reduce logging verbosity - batch notification cancellations
2. Use production vs debug logging levels
3. Implement notification ID storage to avoid scanning all 232 pending notifications

### Issue #2: Widget Update Loop (Triple Refresh)
**Severity:** HIGH - Multiplies work by 3x

**Problem:**
- `onDataSetChanged` called 3 times per widget update
- Each call reloads 8 habits from SharedPreferences
- `getViewAt` called 2-3 times per position = 48-72 view creations per save
- Logs show repeated sequences:
  ```
  onDataSetChanged called - reloading habit data
  getViewAt position: 0 ... Created view for habit: Blood Pressure Med
  getViewAt position: 1 ... Created view for habit: daily advance
  ... [repeats 3 times]
  ```

**Impact:**
- 3x memory allocations for habit data parsing
- 3x JSON parsing (1521 characters × 3 = ~4.5KB parsed)
- Redundant view object creation

**Solution:**
1. Add debouncing to widget updates (300-500ms delay)
2. Implement data caching in widget service
3. Prevent simultaneous widget refresh requests

### Issue #3: Missing Production Build Optimizations
**Severity:** MEDIUM

**Problem:**
- Debug logging always enabled (methodCount: 2, errorMethodCount: 8)
- Full stack traces in production
- No conditional logging based on build mode

**Impact:**
- Unnecessary string allocations
- Logger object creation overhead
- Memory pressure on low-end devices

**Solution:**
1. Implement kDebugMode conditional logging
2. Reduce stack trace depth in release builds
3. Disable emoji/color formatting in production

### Issue #4: Notification ID Lookup Inefficiency
**Severity:** MEDIUM

**Problem:**
- `cancelHabitNotificationsByHabitId` checks ALL 232 pending notifications
- Linear search for each habit update
- No stored mapping of habit ID → notification IDs

**Impact:**
- O(n) complexity where n = total pending notifications
- Unnecessary plugin calls to get pending notifications

**Solution:**
1. Store notification IDs in SharedPreferences when scheduled
2. Direct cancellation using stored IDs (O(1) lookup)
3. Fallback to full scan only if storage missing

## Memory Metrics from Logs

### Garbage Collection Events During Single Save:
1. "freed 53MB AllocSpace bytes, 175(56MB) LOS objects" - 575ms total
2. "freed 65MB AllocSpace bytes, 231(64MB) LOS objects" - 678ms total  
3. "freed 113MB AllocSpace bytes, 406(87MB) LOS objects" - 433ms total

**Total:** ~231MB allocated and freed during one save operation
**GC Time:** ~1.7 seconds of GC pauses

### Widget Data Size:
- JSON payload: 1521 characters (~1.5KB)
- Parsed 3 times = ~4.5KB per save
- 8 habits × 3 refreshes × 2-3 views = ~500KB of view objects created

## Performance Target Goals

### Current State:
- Save operation: 5-6 seconds
- Widget updates: 3x per save
- Notification cancellation: 232 items scanned
- Log entries: ~730 per save
- GC pressure: 231MB per save

### Target State:
- Save operation: <1 second
- Widget updates: 1x per save (debounced)
- Notification cancellation: Direct lookup (10-20ms)
- Log entries: <20 per save
- GC pressure: <50MB per save

## Implementation Priority

### Phase 1: Quick Wins (Immediate - <1 hour)
1. ✅ Reduce notification cancellation logging (batch logs)
2. ✅ Add widget update debouncing
3. ✅ Implement kDebugMode conditional logging

### Phase 2: Structural Improvements (Next release)
1. Notification ID storage system
2. Widget data caching layer
3. Optimize logger configuration for release builds

### Phase 3: Advanced Optimization (Future)
1. Lazy loading for widget views
2. Incremental widget updates (changed habits only)
3. Background thread for heavy operations

## Code Changes Required

### Files to Modify:
1. `lib/services/logging_service.dart` - Conditional logging
2. `lib/services/notifications/notification_scheduler.dart` - Batch logging
3. `lib/services/widget_integration_service.dart` - Debouncing
4. `android/.../HabitTimelineWidgetService.kt` - Caching

## Testing Strategy

### Performance Benchmarks:
1. Time from "Save" button tap to navigation back
2. Widget update count per save (should be 1, not 3)
3. Memory usage before/after save (Android Profiler)
4. GC frequency during save operation

### Test Scenarios:
1. Save habit with 8 existing habits
2. Save habit with notifications enabled
3. Save habit on low-end device (2GB RAM)
4. Rapid consecutive saves (stress test)

## Monitoring

### Key Metrics to Track:
- [ ] Average save operation duration
- [ ] Widget update trigger count
- [ ] Peak memory usage during save
- [ ] GC event frequency
- [ ] Log entry count per operation

### Success Criteria:
- ✅ Save completes in <1 second
- ✅ Widget updates only once per save
- ✅ No GC events >50MB
- ✅ <50 log entries per save operation
