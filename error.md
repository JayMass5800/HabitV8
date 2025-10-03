PS C:\HabitV8> adb logcat | Select-String -Pattern "AlarmService|AlarmReceiver"

10-02 20:04:00.158  1439  4765 I ActivityManager: Background started FGS: Allowed [callingPackage: com.habittracker.habitv8.debug; callingUid: 10581; uidState: RCVR; uidBFSL: n/a; intent: Intent { xflg=0x4 
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService (has extras) }; code:ALARM_MANAGER_WHILE_IDLE; tempAllowListReason:<13da4be Intent { flg=0x10 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmReceiver (has extras) }/u0,reasonCode:ALARM_MANAGER_WHILE_IDLE,duration:10000,callingUid:10581>; allowWiu:-1; targetSdkVersion:36; callerTargetSdkVersion:36; startForegroundCount:0;    
bindFromPackage:null: isBindService:false]
10-02 20:04:00.236  1439  4765 W ActivityManager: Foreground service started from background can not have location/camera/microphone access: service com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService
10-02 20:06:00.051  1439  4225 I ActivityManager: Background started FGS: Allowed [callingPackage: com.habittracker.habitv8.debug; callingUid: 10581; uidState: RCVR; uidBFSL: n/a; intent: Intent { xflg=0x4 
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService (has extras) }; code:ALARM_MANAGER_WHILE_IDLE; tempAllowListReason:<9f5acde Intent { flg=0x10 xflg=0x4 
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmReceiver (has extras) }/u0,reasonCode:ALARM_MANAGER_WHILE_IDLE,duration:10000,callingUid:10581>; allowWiu:-1; targetSdkVersion:36; callerTargetSdkVersion:36; startForegroundCount:0;    
bindFromPackage:null: isBindService:false]
10-02 20:06:00.075  1439  4225 W ActivityManager: Foreground service started from background can not have location/camera/microphone access: service com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService
10-02 20:11:54.371 18620 18620 I flutter : │ #1   NativeAlarmService.scheduleAlarm (package:habitv8/native_alarm_service.dart:20:17)
10-02 20:11:54.383 18620 18620 I flutter : │ #1   NativeAlarmService.scheduleAlarm (package:habitv8/native_alarm_service.dart:32:19)
10-02 20:11:55.249 18620 18620 I flutter : │ #1   NativeAlarmService.cancelAlarm (package:habitv8/native_alarm_service.dart:47:17)
10-02 20:11:55.253 18620 18620 I flutter : │ #1   NativeAlarmService.cancelAlarm (package:habitv8/native_alarm_service.dart:54:19)
10-02 20:11:55.265 18620 18620 I flutter : │ #1   NativeAlarmService.scheduleAlarm (package:habitv8/native_alarm_service.dart:20:17)
10-02 20:11:55.267 18620 18620 I flutter : │ #1   NativeAlarmService.scheduleAlarm (package:habitv8/native_alarm_service.dart:32:19)
10-02 20:13:00.049 18620 18620 I AlarmReceiver: Alarm received: null
10-02 20:13:00.049 18620 18620 I AlarmReceiver: Processing alarm for: fghjhk (ID: 11490698)
10-02 20:13:00.062  1439  4219 I ActivityManager: Background started FGS: Allowed [callingPackage: com.habittracker.habitv8.debug; callingUid: 10581; uidState: RCVR; uidBFSL: n/a; intent: Intent { xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService (has extras) }; code:ALARM_MANAGER_WHILE_IDLE; tempAllowListReason:<f0fef42 Intent { flg=0x10 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmReceiver (has extras) }/u0,reasonCode:ALARM_MANAGER_WHILE_IDLE,duration:10000,callingUid:10581>; allowWiu:-1; targetSdkVersion:36; callerTargetSdkVersion:36; startForegroundCount:0;    
bindFromPackage:null: isBindService:false]
10-02 20:13:00.068 18620 18620 I AlarmReceiver: ✅ AlarmService started for: fghjhk
10-02 20:13:00.075 18620 18620 I AlarmService: AlarmService onCreate
10-02 20:13:00.085 18620 18620 I AlarmService: AlarmService onStartCommand
10-02 20:13:00.085 18620 18620 D AlarmService: Service started with action: null
10-02 20:13:00.086 18620 18620 I AlarmService: Starting alarm service for: fghjhk (ID: 11490698, Habit ID: 1759461113849)
10-02 20:13:00.086 18620 18620 D AlarmService: 📢 Creating notification channel...
10-02 20:13:00.086 18620 18620 D AlarmService: 📺 Creating notification channel: habit_alarm_service
10-02 20:13:00.088 18620 18620 I AlarmService: ✅ Notification channel created/verified: habit_alarm_service (Importance: 4)
10-02 20:13:00.088 18620 18620 D AlarmService: 🚀 Starting foreground service with notification...
10-02 20:13:00.088 18620 18620 D AlarmService: 📱 Creating notification for habit: fghjhk (Alarm ID: 11490698, Habit ID: 1759461113849)
10-02 20:13:00.089 18620 18620 D AlarmService: 📢 Notifications enabled for app: true
10-02 20:13:00.093 18620 18620 D AlarmService: 🔗 Created pending intent for app launch
10-02 20:13:00.095 18620 18620 D AlarmService: ✅ Created action pending intents (complete & snooze)
10-02 20:13:00.107 18620 18620 I AlarmService: ✅ Notification built successfully with 2 action buttons
10-02 20:13:00.111  1439  1520 W ActivityManager: Foreground service started from background can not have location/camera/microphone access: service com.habittracker.habitv8.debug/com.habittracker.habitv8.AlarmService
10-02 20:13:00.115 18620 18620 I AlarmService: ✅ Foreground service started with notification ID: 1001
10-02 20:13:00.115 18620 18620 I AlarmService: Playing alarm sound:
10-02 20:13:00.216 18620 18620 I AlarmService: MediaPlayer started successfully
10-02 20:13:00.223 18620 18620 I AlarmService: Vibration pattern started
10-02 20:13:01.219 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:02.220 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:03.222 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:04.223 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:05.225 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:06.227 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:07.230 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:08.233 18620 18620 D AlarmService: Volume increased to %
10-02 20:13:14.256 18620 18620 I AlarmService: AlarmService onDestroy
10-02 20:13:14.275 18620 18620 I AlarmService: MediaPlayer stopped and released
10-02 20:13:14.275 18620 18620 I AlarmService: All alarm sounds stopped
10-02 20:13:14.276 18620 18620 I AlarmService: Vibration stopped
10-02 20:13:14.277 18620 18620 I AlarmService: Wake lock released