lib/services/health_service.dart:1022:23: Error: 'openHealthConnectSettings' is already declared in this scope.
  static Future<bool> openHealthConnectSettings() async {
                      ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:905:23: Context: Previous declaration of 'openHealthConnectSettings'.
  static Future<bool> openHealthConnectSettings() async {
                      ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/ui/widgets/health_habit_dashboard_widget.dart:6:1: Error: 'HabitCompletionResult' is imported from both 'package:Habitv8/services/health_habit_integration_service.dart' and 'package:Habitv8/services/health_habit_mapping_service.dart'.
import '../../services/health_habit_mapping_service.dart';
^^^^^^^^^^^^^^^^^^^^^
lib/services/calendar_renewal_service.dart:114:24: Error: Method not found: 'HabitDatabase'.
      final database = HabitDatabase();
                       ^^^^^^^^^^^^^
lib/services/health_habit_initialization_service.dart:36:9: Error: No named parameter with the name 'success'.
        success: _isInitialized,
        ^^^^^^^
lib/services/health_habit_initialization_service.dart:519:7: Context: The class 'HealthHabitInitializationResult' has a constructor that takes no arguments.
class HealthHabitInitializationResult {
      ^
lib/services/health_habit_initialization_service.dart:43:9: Error: No named parameter with the name 'success'.
        success: true,
        ^^^^^^^
lib/services/health_habit_initialization_service.dart:519:7: Context: The class 'HealthHabitInitializationResult' has a constructor that takes no arguments.
class HealthHabitInitializationResult {
      ^
lib/ui/screens/settings_screen.dart:354:41: Error: The method '_toggleAutoCompletion' isn't defined for the class '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:Habitv8/ui/screens/settings_screen.dart' ('lib/ui/screens/settings_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named '_toggleAutoCompletion'.
                  onChanged: (value) => _toggleAutoCompletion(value),
                                        ^^^^^^^^^^^^^^^^^^^^^
lib/ui/screens/settings_screen.dart:364:46: Error: The method '_setAutoCompletionInterval' isn't defined for the class '_SettingsScreenState'.
 - '_SettingsScreenState' is from 'package:Habitv8/ui/screens/settings_screen.dart' ('lib/ui/screens/settings_screen.dart').
Try correcting the name to the name of an existing method, or defining a method named '_setAutoCompletionInterval'.
                      onSelected: (value) => _setAutoCompletionInterval(value),
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/ui/screens/settings_screen.dart:1097:47: Error: Can't use 'openHealthConnectSettings' because it is declared more than once.
      final bool opened = await HealthService.openHealthConnectSettings();
                                              ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:550:59: Error: A value of type 'num' can't be returned from a function with return type 'double'.
    return math.max(0, 1 - (standardDeviation / average)).clamp(0, 1);
                                                          ^
lib/services/health_habit_analytics_service.dart:799:64: Error: The argument type 'num' can't be assigned to the parameter type 'double'.
          relevantData.add((point.value as NumericHealthValue).numericValue);
                                                               ^
lib/services/health_habit_mapping_service.dart:408:55: Error: A value of type 'num' can't be assigned to a variable of type 'double'.
          value = (point.value as NumericHealthValue).numericValue;
                                                      ^
lib/ui/widgets/health_habit_dashboard_widget.dart:293:32: Error: The getter 'habitName' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'habitName'.
                    completion.habitName,
                               ^^^^^^^^^
lib/ui/widgets/health_habit_dashboard_widget.dart:297:32: Error: The getter 'healthValue' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'healthValue'.
                if (completion.healthValue != null)
                               ^^^^^^^^^^^
lib/ui/widgets/health_habit_dashboard_widget.dart:299:35: Error: The getter 'healthValue' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'healthValue'.
                    '${completion.healthValue!.round()}',
                                  ^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:56:44: Error: The method 'compareTo' isn't defined for the class 'HabitPriority'.
 - 'HabitPriority' is from 'package:Habitv8/services/health_enhanced_habit_creation_service.dart' ('lib/services/health_enhanced_habit_creation_service.dart').
Try correcting the name to the name of an existing method, or defining a method named 'compareTo'.
        final priorityCompare = b.priority.compareTo(a.priority);
                                           ^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:86:9: Error: No named parameter with the name 'id'.
        id: _generateHabitId(),
        ^^
lib/domain/model/habit.dart:78:3: Context: Found this candidate, but the arguments don't match.
  Habit() {
  ^^^^^
lib/services/health_enhanced_habit_creation_service.dart:641:56: Error: Member not found: '_healthMappings'.
      final defaultMapping = HealthHabitMappingService._healthMappings[healthDataType];
                                                       ^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:789:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:793:55: Error: 'NumericHealthValue' isn't a type.
          healthByType[typeName]!.add((point.value as NumericHealthValue).numericValue);
                                                      ^^^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.