PS C:\HabitV8> flutter analyze  
Analyzing HabitV8...                                                    

   info - Don't invoke 'print' in production code - lib\data\database.dart:40:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\data\database.dart:41:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\data\database.dart:58:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\data\database.dart:118:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\data\database.dart:120:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:138:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:147:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:148:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:149:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:155:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:158:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:160:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:168:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:175:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:176:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:177:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:178:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:179:5 - avoid_print
   info - Unnecessary braces in a string interpolation - lib\main.dart:179:34 - unnecessary_brace_in_string_interps
   info - Don't invoke 'print' in production code - lib\main.dart:180:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:186:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:191:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:194:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:236:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:242:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:246:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:249:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:260:3 - avoid_print
   info - Unnecessary braces in a string interpolation - lib\main.dart:260:70 - unnecessary_brace_in_string_interps
   info - Don't invoke 'print' in production code - lib\main.dart:279:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\main.dart:283:9 - avoid_print
warning - Unused import: 'package:permission_handler/permission_handler.dart' - lib\services\activity_recognition_service.dart:3:8 - unused_import
  error - The getter 'name' isn't defined for the type 'String' - lib\services\automatic_habit_completion_service.dart:297:85 - undefined_getter
warning - Unused import: 'health_habit_mapping_service.dart' - lib\services\health_enhanced_habit_creation_service.dart:4:8 - unused_import
warning - The value of the local variable 'startDate' isn't used - lib\services\health_habit_analytics_service.dart:30:13 - unused_local_variable
  error - The method 'getHabitCompletions' isn't defined for the type 'HabitService' - lib\services\health_habit_analytics_service.dart:100:46 - undefined_method
  error - The method 'getCurrentStreak' isn't defined for the type 'HabitService' - lib\services\health_habit_analytics_service.dart:108:52 - undefined_method
  error - The method 'getLongestStreak' isn't defined for the type 'HabitService' - lib\services\health_habit_analytics_service.dart:109:52 - undefined_method
  error - The getter 'hasError' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_initialization_service.dart:243:18 - undefined_getter
warning - The value of the local variable 'endOfDay' isn't used - lib\services\health_habit_integration_service.dart:188:13 - unused_local_variable
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_integration_service.dart:274:65 - undefined_getter
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:386:32 - type_test_with_undefined_name
  error - A value of type 'double' can't be assigned to a variable of type 'int' - lib\services\health_habit_integration_service.dart:387:29 - invalid_assignment
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:387:45 - cast_to_non_type
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:397:32 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:398:46 - cast_to_non_type
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:408:32 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:409:45 - cast_to_non_type
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:419:32 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:420:45 - cast_to_non_type
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:430:32 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:431:51 - cast_to_non_type
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:441:66 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:442:55 - cast_to_non_type
  error - Undefined name 'healthData' - lib\services\health_habit_integration_service.dart:481:25 - undefined_identifier
  error - The getter 'dateFrom' isn't defined for the type 'HealthDataPoint' - lib\services\health_habit_integration_service.dart:519:36 - undefined_getter
  error - The getter 'dateFrom' isn't defined for the type 'HealthDataPoint' - lib\services\health_habit_integration_service.dart:519:57 - undefined_getter
  error - The getter 'dateFrom' isn't defined for the type 'HealthDataPoint' - lib\services\health_habit_integration_service.dart:519:79 - undefined_getter
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:520:28 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:522:31 - cast_to_non_type
  error - The argument type 'Map<String, dynamic>' can't be assigned to the parameter type 'List<HealthDataPoint>'.  - lib\services\health_habit_integration_service.dart:575:43 - argument_type_not_assignable
  error - The argument type 'Map<String, dynamic>' can't be assigned to the parameter type 'List<HealthDataPoint>'.  - lib\services\health_habit_integration_service.dart:579:66 - argument_type_not_assignable
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_integration_service.dart:652:37 - undefined_getter
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_integration_service.dart:666:48 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_integration_service.dart:667:47 - cast_to_non_type
  error - The operator '+' can't be unconditionally invoked because the receiver can be 'null' - lib\services\health_habit_integration_service.dart:674:59 - unchecked_use_of_nullable_value
  error - The operator '+' can't be unconditionally invoked because the receiver can be 'null' - lib\services\health_habit_integration_service.dart:675:61 - unchecked_use_of_nullable_value
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_integration_service.dart:718:24 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_integration_service.dart:829:52 - undefined_getter
warning - Unused import: 'minimal_health_service.dart' - lib\services\health_habit_mapping_service.dart:3:8 - unused_import
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:277:52 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:322:65 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:334:77 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:394:89 - undefined_getter
  error - The method 'getHealthDataFromTypes' isn't defined for the type 'HealthService' - lib\services\health_habit_mapping_service.dart:424:46 - undefined_method
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:456:74 - undefined_getter
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_mapping_service.dart:465:28 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_mapping_service.dart:466:41 - cast_to_non_type
  error - The method 'getHealthDataFromTypes' isn't defined for the type 'HealthService' - lib\services\health_habit_mapping_service.dart:643:46 - undefined_method
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_mapping_service.dart:661:28 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_mapping_service.dart:662:35 - cast_to_non_type
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:718:49 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:934:38 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_service.dart:966:39 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_test.dart:80:68 - undefined_getter
  error - The getter 'name' isn't defined for the type 'String' - lib\services\health_habit_mapping_test.dart:114:66 - undefined_getter
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\health_habit_ui_service.dart:141:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\health_habit_ui_service.dart:143:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\health_habit_ui_service.dart:353:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\health_habit_ui_service.dart:355:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\services\health_habit_ui_service.dart:370:34 - deprecated_member_use
  error - The getter 'hasError' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:510:70 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:539:33 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:542:39 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:543:39 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:551:33 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:554:28 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:555:28 - undefined_getter
  error - The getter 'predictiveInsights' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:562:28 - undefined_getter
  error - The getter 'predictiveInsights' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\services\health_habit_ui_service.dart:568:29 - undefined_getter
warning - The value of the local variable 'healthSummary' isn't used - lib\services\health_habit_ui_service.dart:769:13 - unused_local_variable
  error - Undefined name 'healthData' - lib\services\health_habit_ui_service.dart:785:27 - undefined_identifier
  error - The name 'NumericHealthValue' isn't defined, so it can't be used in an 'is' expression - lib\services\health_habit_ui_service.dart:787:28 - type_test_with_undefined_name
  error - The name 'NumericHealthValue' isn't a type, so it can't be used in an 'as' expression - lib\services\health_habit_ui_service.dart:791:55 - cast_to_non_type
warning - The value of the local variable 'avgValue' isn't used - lib\services\health_habit_ui_service.dart:800:17 - unused_local_variable
warning - The operand can't be 'null', so the condition is always 'true' - lib\services\notification_service.dart:82:79 - unnecessary_null_comparison
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:213:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:214:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:215:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:216:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:217:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:232:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:237:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:246:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:254:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:255:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:262:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:267:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:273:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:277:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:281:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:285:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:291:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:300:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:304:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:310:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:315:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:319:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:322:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:335:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:343:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:347:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:509:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:510:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:511:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:512:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:513:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:514:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:518:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:519:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:527:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:529:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:541:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:543:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:553:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:557:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:558:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:559:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:563:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:566:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:587:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:589:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:721:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:722:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:723:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:726:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:732:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:740:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:752:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:754:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:760:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:763:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:767:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:772:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:777:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:782:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:787:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:792:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:796:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:799:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:807:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:811:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:812:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:817:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:819:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:830:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:832:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:936:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:960:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:962:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\services\notification_service.dart:968:7 - avoid_print
warning - The operand can't be 'null', so the condition is always 'true' - lib\services\notification_service.dart:1335:90 - unnecessary_null_comparison
warning - Unused import: 'dart:io' - lib\services\permission_service.dart:1:8 - unused_import
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check - lib\ui\home_screen.dart:36:40 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check - lib\ui\home_screen.dart:48:40 - use_build_context_synchronously
warning - The value of the field '_enableHealthIntegration' isn't used - lib\ui\screens\create_habit_screen.dart:38:8 - unused_field
warning - The value of the field '_selectedHealthDataType' isn't used - lib\ui\screens\create_habit_screen.dart:39:11 - unused_field
warning - The value of the field '_customThreshold' isn't used - lib\ui\screens\create_habit_screen.dart:40:11 - unused_field
warning - The value of the field '_thresholdLevel' isn't used - lib\ui\screens\create_habit_screen.dart:41:10 - unused_field
warning - The value of the field '_healthSuggestions' isn't used - lib\ui\screens\create_habit_screen.dart:42:36 - unused_field
warning - The value of the field '_loadingSuggestions' isn't used - lib\ui\screens\create_habit_screen.dart:43:8 - unused_field
   info - Don't invoke 'print' in production code - lib\ui\screens\create_habit_screen.dart:318:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\ui\screens\create_habit_screen.dart:336:17 - avoid_print
   info - Don't invoke 'print' in production code - lib\ui\screens\create_habit_screen.dart:342:23 - avoid_print
   info - Don't invoke 'print' in production code - lib\ui\screens\create_habit_screen.dart:1142:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\ui\screens\create_habit_screen.dart:1159:9 - avoid_print
warning - The declaration '_applySuggestion' isn't referenced - lib\ui\screens\create_habit_screen.dart:1198:8 - unused_element
  error - The getter 'hasError' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:209:76 - undefined_getter
  error - The getter 'hasError' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:365:76 - undefined_getter
  error - The getter 'predictiveInsights' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:379:30 - undefined_getter
  error - The getter 'predictiveInsights' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:383:30 - undefined_getter
  error - The getter 'optimizationRecommendations' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:397:30 - undefined_getter
  error - The getter 'optimizationRecommendations' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:401:30 - undefined_getter
  error - The getter 'benchmarkComparisons' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:424:30 - undefined_getter
  error - The getter 'benchmarkComparisons' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:425:51 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:456:39 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:459:34 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:460:34 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:466:33 - undefined_getter
  error - The getter 'overallScore' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:473:47 - undefined_getter
  error - The getter 'habitAnalyses' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:484:20 - undefined_getter
  error - The getter 'habitAnalyses' isn't defined for the type 'HealthHabitAnalyticsReport' - lib\ui\screens\health_integration_screen.dart:490:21 - undefined_getter
  error - The name 'BenchmarkComparison' isn't a type, so it can't be used as a type argument - lib\ui\screens\health_integration_screen.dart:561:45 - non_type_as_type_argument
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\health_integration_screen.dart:626:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\health_integration_screen.dart:628:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\health_integration_screen.dart:645:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\health_integration_screen.dart:1143:46 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\health_integration_screen.dart:1144:53 - deprecated_member_use
warning - The declaration '_buildHealthCard' isn't referenced - lib\ui\screens\insights_screen.dart:340:10 - unused_element
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\insights_screen.dart:363:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\insights_screen.dart:464:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\insights_screen.dart:466:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\insights_screen.dart:934:95 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\insights_screen.dart:950:99 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps - lib\ui\screens\settings_screen.dart:190:32 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps - lib\ui\screens\settings_screen.dart:199:32 - use_build_context_synchronously
warning - The declaration '_testNotifications' isn't referenced - lib\ui\screens\settings_screen.dart:809:16 - unused_element
warning - The declaration '_debugCalendarSync' isn't referenced - lib\ui\screens\settings_screen.dart:995:16 - unused_element
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check - lib\ui\screens\settings_screen.dart:1040:46 - use_build_context_synchronously
warning - The declaration '_manageHealthPermissions' isn't referenced - lib\ui\screens\settings_screen.dart:1070:16 - unused_element
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check - lib\ui\screens\settings_screen.dart:1114:40 - use_build_context_synchronously
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\timeline_screen.dart:270:60 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\timeline_screen.dart:285:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\timeline_screen.dart:302:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\screens\timeline_screen.dart:335:67 - deprecated_member_use
warning - The value of the local variable 'anniversaryDate' isn't used - lib\ui\screens\timeline_screen.dart:385:17 - unused_local_variable
   info - Don't invoke 'print' in production code - lib\ui\widgets\health_education_dialog.dart:167:7 - avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:120:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:122:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:184:36 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:186:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:221:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:223:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:237:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:262:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:264:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:318:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:321:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:355:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:357:57 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:440:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:631:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:634:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\ui\widgets\health_habit_dashboard_widget.dart:645:36 - deprecated_member_use
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:9:3 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:13:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:15:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:18:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:20:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:23:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:25:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:28:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:30:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:32:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:36:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:38:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:42:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:46:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:48:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:50:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:51:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:52:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:53:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:54:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:55:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:58:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:61:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:76:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:79:7 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:80:28 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:81:25 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:82:39 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:86:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:87:5 - avoid_print
   info - Don't invoke 'print' in production code - test_calendar_integration.dart:90:3 - avoid_print
   info - Don't invoke 'print' in production code - test_health_mapping.dart:4:3 - avoid_print
   info - Don't invoke 'print' in production code - test_health_mapping.dart:14:3 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:6:3 - avoid_print
  error - The named parameter 'id' isn't defined - test_variable_step_detection.dart:12:7 - undefined_named_parameter
  error - The named parameter 'name' isn't defined - test_variable_step_detection.dart:13:7 - undefined_named_parameter
  error - The named parameter 'description' isn't defined - test_variable_step_detection.dart:14:7 - undefined_named_parameter
  error - The named parameter 'category' isn't defined - test_variable_step_detection.dart:15:7 - undefined_named_parameter
  error - The named parameter 'frequency' isn't defined - test_variable_step_detection.dart:16:7 - undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined - test_variable_step_detection.dart:17:7 - undefined_named_parameter
  error - The named parameter 'id' isn't defined - test_variable_step_detection.dart:20:7 - undefined_named_parameter
  error - The named parameter 'name' isn't defined - test_variable_step_detection.dart:21:7 - undefined_named_parameter
  error - The named parameter 'description' isn't defined - test_variable_step_detection.dart:22:7 - undefined_named_parameter
  error - The named parameter 'category' isn't defined - test_variable_step_detection.dart:23:7 - undefined_named_parameter
  error - The named parameter 'frequency' isn't defined - test_variable_step_detection.dart:24:7 - undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined - test_variable_step_detection.dart:25:7 - undefined_named_parameter
  error - The named parameter 'id' isn't defined - test_variable_step_detection.dart:28:7 - undefined_named_parameter
  error - The named parameter 'name' isn't defined - test_variable_step_detection.dart:29:7 - undefined_named_parameter
  error - The named parameter 'description' isn't defined - test_variable_step_detection.dart:30:7 - undefined_named_parameter
  error - The named parameter 'category' isn't defined - test_variable_step_detection.dart:31:7 - undefined_named_parameter
  error - The named parameter 'frequency' isn't defined - test_variable_step_detection.dart:32:7 - undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined - test_variable_step_detection.dart:33:7 - undefined_named_parameter
  error - The named parameter 'id' isn't defined - test_variable_step_detection.dart:38:7 - undefined_named_parameter
  error - The named parameter 'name' isn't defined - test_variable_step_detection.dart:39:7 - undefined_named_parameter
  error - The named parameter 'description' isn't defined - test_variable_step_detection.dart:40:7 - undefined_named_parameter
  error - The named parameter 'category' isn't defined - test_variable_step_detection.dart:41:7 - undefined_named_parameter
  error - The named parameter 'frequency' isn't defined - test_variable_step_detection.dart:42:7 - undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined - test_variable_step_detection.dart:43:7 - undefined_named_parameter
  error - The named parameter 'id' isn't defined - test_variable_step_detection.dart:46:7 - undefined_named_parameter
  error - The named parameter 'name' isn't defined - test_variable_step_detection.dart:47:7 - undefined_named_parameter
  error - The named parameter 'description' isn't defined - test_variable_step_detection.dart:48:7 - undefined_named_parameter
  error - The named parameter 'category' isn't defined - test_variable_step_detection.dart:49:7 - undefined_named_parameter
  error - The named parameter 'frequency' isn't defined - test_variable_step_detection.dart:50:7 - undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined - test_variable_step_detection.dart:51:7 - undefined_named_parameter
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:56:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:57:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:61:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:67:7 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:68:7 - avoid_print
  error - The getter 'name' isn't defined for the type 'String' - test_variable_step_detection.dart:68:55 - undefined_getter
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:69:7 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:70:7 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:71:7 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:73:7 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:76:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:80:3 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:87:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:88:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:89:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:90:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:91:5 - avoid_print
   info - Don't invoke 'print' in production code - test_variable_step_detection.dart:92:5 - avoid_print

336 issues found. (ran in 2.4s)