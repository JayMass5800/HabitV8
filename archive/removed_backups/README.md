# Removed Backup Files

This directory contains backup files that were removed from the active codebase during cleanup on November 7, 2025.

## Files Archived

### Service Backups
- `notification_service_monolithic.dart.bak` - Old monolithic notification service (replaced by modular system)
- `notification_service_old_backup.dart.bak` - Another backup of old notification service
- `permission_service.dart.bak` - Backup of permission service
- `notification_action_handler_isar.dart.bak` - Backup of notification action handler
- `notification_action_handler.dart.backup` - Another backup of notification action handler

### Screen Backups
- `settings_screen.dart.bak` - Backup of settings screen
- `create_habit_screen_backup.dart` - Backup of create habit screen (old version)

### Widget Backups
- `rrule_builder_widget_old.dart.bak` - Old version of RRule builder widget

### Database Backups
- `database_hive_backup.dart.bak` - Backup from Hive to Isar migration

## Reason for Removal

These files were backup copies that:
1. Are not referenced anywhere in the active codebase
2. Were explicitly marked as not to be used in project documentation
3. Created confusion and clutter in the codebase
4. Were superseded by newer implementations

## Recovery

If you need to recover any of these files, they are preserved here and can be restored if necessary. However, it's recommended to use the current implementations which have been tested and are actively maintained.
