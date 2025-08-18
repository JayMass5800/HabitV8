# HabitV8 Application Service/UI Interaction Map

## Overview
This map shows how services interact with each other and connect to UI components in the HabitV8 app. It is designed to help AI and developers understand the app's architecture and data flow.

---

## UI Components (lib/ui/screens & widgets)
- **Screens:**
  - home_screen.dart
  - all_habits_screen.dart
  - calendar_screen.dart
  - create_habit_screen.dart
  - edit_habit_screen.dart
  - health_integration_screen.dart
  - insights_screen.dart
  - onboarding_screen.dart
  - settings_screen.dart
  - stats_screen.dart
  - timeline_screen.dart
- **Widgets:**
  - health_habit_dashboard_widget.dart
  - calendar_selection_dialog.dart
  - category_filter_widget.dart
  - ...others

---

## Core Services (lib/services)
- **Habit Services:**
  - habit_stats_service.dart
  - comprehensive_habit_suggestions_service.dart
  - category_suggestion_service.dart
  - onboarding_service.dart
  - automatic_habit_completion_service.dart
  - health_enhanced_habit_creation_service.dart
  - health_habit_mapping_service.dart
  - health_habit_analytics_service.dart
  - health_habit_ui_service.dart
  - health_habit_initialization_service.dart
  - health_habit_integration_service.dart
  - health_service.dart
  - minimal_health_service.dart
- **Notification Services:**
  - notification_service.dart
  - notification_action_service.dart
- **Other Services:**
  - permission_service.dart
  - logging_service.dart
  - cache_service.dart
  - activity_recognition_service.dart
  - theme_service.dart
  - trend_analysis_service.dart

---

## Service Interactions
- **health_service.dart**
  - Core health data access (via platform channels/minimal_health_service.dart)
  - Used by: health_habit_mapping_service.dart, health_habit_analytics_service.dart, health_habit_ui_service.dart, automatic_habit_completion_service.dart, health_enhanced_habit_creation_service.dart
- **minimal_health_service.dart**
  - Platform channel implementation for health data
  - Used by: health_service.dart
- **health_habit_mapping_service.dart**
  - Maps health data to habits
  - Used by: create_habit_screen.dart, automatic_habit_completion_service.dart
- **automatic_habit_completion_service.dart**
  - Monitors health data and marks habits complete
  - Uses: health_service.dart, health_habit_mapping_service.dart, notification_service.dart
- **health_enhanced_habit_creation_service.dart**
  - Creates habits with health data integration
  - Used by: create_habit_screen.dart
- **notification_service.dart & notification_action_service.dart**
  - Schedule and handle notifications
  - Used by: create_habit_screen.dart, automatic_habit_completion_service.dart
- **habit_stats_service.dart, health_habit_analytics_service.dart**
  - Analyze habit and health data
  - Used by: insights_screen.dart, stats_screen.dart
- **category_suggestion_service.dart, comprehensive_habit_suggestions_service.dart**
  - Provide habit/category suggestions
  - Used by: create_habit_screen.dart
- **logging_service.dart**
  - Used by most services for logging

---

## UI-Service Connections
- **create_habit_screen.dart**
  - Uses: health_habit_mapping_service.dart, health_enhanced_habit_creation_service.dart, notification_service.dart, category_suggestion_service.dart, comprehensive_habit_suggestions_service.dart
- **insights_screen.dart, stats_screen.dart**
  - Use: habit_stats_service.dart, health_habit_analytics_service.dart
- **health_integration_screen.dart**
  - Uses: health_service.dart, health_habit_integration_service.dart
- **automatic_habit_completion_service.dart**
  - Runs in background, interacts with health_service.dart, notification_service.dart

---

## Data Flow Example
1. User creates a habit in create_habit_screen.dart
2. Service calls to health_enhanced_habit_creation_service.dart and health_habit_mapping_service.dart
3. Health data accessed via health_service.dart/minimal_health_service.dart
4. Notifications scheduled via notification_service.dart
5. Habit completion monitored by automatic_habit_completion_service.dart
6. Analytics and stats shown in insights_screen.dart and stats_screen.dart

---

## Notes
- Most services are singletons or stateless classes.
- Logging is handled globally via logging_service.dart.
- Health data is only accessed via health_service.dart for privacy and compliance.

---

This map is a high-level guide for understanding the structure and interactions in HabitV8.
