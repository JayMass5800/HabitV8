# Deprecated Services

This directory contains services that have been deprecated and replaced by more efficient implementations.

## Archived Services

### habit_continuation_service.dart
**Deprecated:** November 7, 2025  
**Replaced by:** `MidnightHabitResetService`

**Reason for deprecation:**
- Used inefficient `Timer.periodic` polling every 12 hours
- Caused unnecessary background activity and garbage collection
- New implementation uses one-time scheduled timers at midnight instead of polling

**Migration notes:**
- All functionality has been moved to `MidnightHabitResetService`
- Service was marked with `@Deprecated('Use MidnightHabitResetService instead')`
- No active imports found in codebase at time of archival

### calendar_renewal_service.dart
**Deprecated:** November 7, 2025  
**Replaced by:** `MidnightHabitResetService` and Isar listeners

**Reason for deprecation:**
- Functionality replaced by Isar's reactive listeners
- Automatic calendar sync now handled by event-driven updates
- No longer needed with new architecture

**Migration notes:**
- Calendar sync functionality integrated into CalendarService directly
- Isar listeners provide automatic updates when data changes
- Service was marked with `@Deprecated('Use MidnightHabitResetService and Isar listeners instead')`
- No active imports found in codebase at time of archival

## Recovery

These services are preserved for reference. If you need to understand the old implementation or restore functionality, the code is available here. However, the replacement services are more efficient and should be used instead.
