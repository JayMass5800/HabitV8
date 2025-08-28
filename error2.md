C:\HabitV8\.dart_tool\package_config.json does not exist.
Did you run this command from the same directory as your pubspec.yaml file?
Error:
lib/services/permission_service.dart:231:42: Error: Member not found: 'MinimalHealthChannel.startBackgroundMonitoring'.
              await MinimalHealthChannel.startBackgroundMonitoring();
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/ui/screens/insights_screen.dart:2624:38: Error: Member not found: 'MinimalHealthChannel.runNativeHealthConnectDiagnostics'.
          await MinimalHealthChannel.runNativeHealthConnectDiagnostics();
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:474:38: Error: Member not found: 'MinimalHealthChannel.startBackgroundMonitoring'.
          await MinimalHealthChannel.startBackgroundMonitoring();
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:498:40: Error: Member not found: 'MinimalHealthChannel.isBackgroundMonitoringActive'.
            await MinimalHealthChannel.isBackgroundMonitoringActive();
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:504:42: Error: Member not found: 'MinimalHealthChannel.startBackgroundMonitoring'.
              await MinimalHealthChannel.startBackgroundMonitoring();
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:658:38: Error: Member not found: 'MinimalHealthChannel.getTotalCaloriesToday'.
          await MinimalHealthChannel.getTotalCaloriesToday();
                                     ^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:688:38: Error: Member not found: 'MinimalHealthChannel.getSleepHoursLastNight'.
          await MinimalHealthChannel.getSleepHoursLastNight();
                                     ^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:780:57: Error: Member not found: 'MinimalHealthChannel.getWaterIntakeToday'.
      final double waterMl = await MinimalHealthChannel.getWaterIntakeToday();
                                                        ^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:797:38: Error: Member not found: 'MinimalHealthChannel.getMindfulnessMinutesToday'.
          await MinimalHealthChannel.getMindfulnessMinutesToday();
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:815:57: Error: Member not found: 'MinimalHealthChannel.getLatestWeight'.
      final double? weight = await MinimalHealthChannel.getLatestWeight();
                                                        ^^^^^^^^^^^^^^^
lib/services/health_service.dart:868:60: Error: Member not found: 'MinimalHealthChannel.getLatestHeartRate'.
      final double? heartRate = await MinimalHealthChannel.getLatestHeartRate();
                                                           ^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:984:38: Error: Member not found: 'MinimalHealthChannel.getRestingHeartRateToday'.
          await MinimalHealthChannel.getRestingHeartRateToday();
                                     ^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:1010:54: Error: Too many positional arguments: 0 allowed, but 2 found.
Try removing the extra positional arguments.
          await MinimalHealthChannel.getHeartRateData(startDate, endDate);
                                                     ^
lib/services/minimal_health_channel.dart:440:45: Context: Found this candidate, but the arguments don't match.
  static Future<List<Map<String, dynamic>>> getHeartRateData({
                                            ^^^^^^^^^^^^^^^^
lib/services/health_service.dart:1941:41: Error: Member not found: 'MinimalHealthChannel.hasBackgroundHealthDataAccess'.
      return await MinimalHealthChannel.hasBackgroundHealthDataAccess();
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:1959:40: Error: Member not found: 'MinimalHealthChannel.isBackgroundMonitoringActive'.
            await MinimalHealthChannel.isBackgroundMonitoringActive(),
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:1961:52: Error: Member not found: 'MinimalHealthChannel.getSupportedDataTypes'.
        'supportedDataTypes': MinimalHealthChannel.getSupportedDataTypes(),
                                                   ^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:1963:47: Error: Member not found: 'MinimalHealthChannel.getServiceStatus'.
        'channelStatus': MinimalHealthChannel.getServiceStatus(),
                                              ^^^^^^^^^^^^^^^^
lib/services/health_service.dart:2428:45: Error: Member not found: 'MinimalHealthChannel.getServiceStatus'.
      'channelStatus': MinimalHealthChannel.getServiceStatus(),
                                            ^^^^^^^^^^^^^^^^
lib/services/health_service.dart:2568:40: Error: Member not found: 'MinimalHealthChannel.getTotalCaloriesToday'.
            await MinimalHealthChannel.getTotalCaloriesToday();
                                       ^^^^^^^^^^^^^^^^^^^^^
lib/services/health_service.dart:2682:38: Error: Member not found: 'MinimalHealthChannel.getSleepHoursLastNight'.
          await MinimalHealthChannel.getSleepHoursLastNight();