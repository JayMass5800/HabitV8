PS C:\HabitV8> adb logcat | Select-String "Notification"

10-16 23:39:42.319   932  1460 I Lyric   : zuma_be_core_driver_impl.cc:433: 
BeCore: receives context release notification
10-16 23:39:42.324   932  1458 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE] 
Received context release notification for camera 7
10-16 23:39:42.325   932  1458 I Lyric   : 
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that 
graph has stopped
10-16 23:39:42.329   932  1458 I Lyric   : zuma_fe_driver.cc:943: [ISPFE] 
Received context release notification when releasing power_context.
10-16 23:39:42.338  1474  4476 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback null
10-16 23:39:43.406  1474  2586 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@25a9879, mPriority=0, 
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:39:48.179  1474  3891 I ActivityTaskManager: START u0 
{act=ACTION_NOTIFICATION_complete flg=0x10000000 xflg=0x4 
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity 
bnds=[189,791][501,899] (has extras)} with LAUNCH_SINGLE_TOP from uid 10665 
(com.habittracker.habitv8.debug) (realCallingUid=10249) 
(BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result code=3
10-16 23:39:48.179  1474  2586 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback null
10-16 23:44:31.470  1474  5691 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@d5ddd0e, mPriority=0, 
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:44:31.641   932  1968 W Lyric   :
external_auto_focus_controller_proxy.cc:862: 3 calls in 290 sec(s): Not able to   
get shutter notification timestamp
10-16 23:44:31.641   932  1968 E Lyric   :
external_auto_focus_controller_proxy.cc:1082: 3 calls in 290 sec(s): Not able to  
get shutter notification timestamp. No actuator data is collected.
10-16 23:44:31.708   932 19257 W Lyric   : shutter_notification_manager.cc:270:   
1 calls in 290 sec(s): vsync timeout for frame 1
10-16 23:44:31.708   932 19257 I Lyric   : shutter_notification_manager.cc:312:   
1 calls in 290 sec(s): vsync_timestamp unavailable. Apply previous
vsync_sof_offset -60307
10-16 23:44:32.255   932  1961 W Lyric   : auto_focus_node.cc:1309: 4 calls in 
290 sec(s): cam7_af, frame_number: 17, shutter notification is not available.     
Update vsync with current boottime and previous offset.
10-16 23:44:32.289   932  1459 I Lyric   : zuma_be_core_driver_impl.cc:433:       
BeCore: receives context release notification
10-16 23:44:32.294   932  1460 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:44:32.295   932  1460 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:44:32.300   932  1460 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:44:32.341  1474  3481 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:46:00.123  1474  3891 I PowerGroup: Waking up power group from Dozing    
(groupId=0, uid=10665, reason=WAKE_REASON_APPLICATION,
details=HabitV8:NotificationBuilder:WakeupLock)...
10-16 23:46:00.124  1474  3891 I PowerManagerService: Waking up from Dozing       
(uid=10665, reason=WAKE_REASON_APPLICATION,
details=HabitV8:NotificationBuilder:WakeupLock)...
10-16 23:46:00.176  1474  2044 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and 
roid.window.IOnBackInvokedCallback$Stub$Proxy@eaee349, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:46:00.421  1474  1474 I AS.AudioService: shouldNotificationSoundPlay     
false: muted stream:5 attr:AudioAttributes: usage=USAGE_NOTIFICATION
content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null
10-16 23:46:00.422  1474  1474 V NotificationHistory: Attempted to add notif for  
locked/gone/disabled user 0
10-16 23:46:00.451  1474  7558 I ActivityTaskManager: START u0
{act=SELECT_NOTIFICATION flg=0x14000000 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has     
extras)} with LAUNCH_SINGLE_TOP from uid 10665 (com.habittracker.habitv8.debug)   
(realCallingUid=10249) (BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result     
code=2
10-16 23:46:10.488  1474  4910 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:46:20.200  1474  2044 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and 
roid.window.IOnBackInvokedCallback$Stub$Proxy@c7eafef, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:46:20.397   932  1964 W Lyric   : 
external_auto_focus_controller_proxy.cc:862: 3 calls in 109 sec(s): Not able to   
get shutter notification timestamp
10-16 23:46:20.397   932  1964 E Lyric   :
external_auto_focus_controller_proxy.cc:1082: 3 calls in 109 sec(s): Not able to  
get shutter notification timestamp. No actuator data is collected.
10-16 23:46:20.413   932  1814 W Lyric   : shutter_notification_manager.cc:138:   
Sensor with vsync id : 2 creating vsync sensor connection spent 35.47876ms        
10-16 23:46:21.755   932  1968 W Lyric   : auto_focus_node.cc:1309: 4 calls in    
109 sec(s): cam7_af, frame_number: 39, shutter notification is not available.     
Update vsync with current boottime and previous offset.
10-16 23:46:21.755   932 14977 W Lyric   : auto_focus_node.cc:1412: 3 calls in    
399 sec(s): cam7_af, frame_number: 39, shutter notification is not available      
10-16 23:46:21.779   932 19598 W Lyric   : shutter_notification_manager.cc:270:   
2 calls in 110 sec(s): vsync timeout for frame 40
10-16 23:46:21.779   932 19598 I Lyric   : shutter_notification_manager.cc:312:   
2 calls in 110 sec(s): vsync_timestamp unavailable. Apply previous
vsync_sof_offset -113706
10-16 23:46:21.787   932  1459 I Lyric   : zuma_be_core_driver_impl.cc:433:       
BeCore: receives context release notification
10-16 23:46:21.793   932  1458 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:46:21.795   932  1458 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:46:21.799   932  1458 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:46:22.111   932  1814 W Lyric   : shutter_notification_manager.cc:138:   
Sensor with vsync id : 2 creating vsync sensor connection spent 23.829834ms       
10-16 23:46:22.428   932 14977 W Lyric   : auto_focus_node.cc:1412: 3 calls in 1 
sec(s): cam7_af, frame_number: 8, shutter notification is not available
10-16 23:46:22.428   932  1964 W Lyric   : auto_focus_node.cc:1309: 3 calls in 1  
sec(s): cam7_af, frame_number: 8, shutter notification is not available. Update   
vsync with current boottime and previous offset.
10-16 23:46:22.466   932  1460 I Lyric   : zuma_be_core_driver_impl.cc:433:       
BeCore: receives context release notification
10-16 23:46:22.470   932  1459 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:46:22.473   932  1459 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:46:22.477   932  1459 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:46:22.484  1474  7536 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:46:23.617  1474  4910 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and 
roid.window.IOnBackInvokedCallback$Stub$Proxy@eb4dac7, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:46:24.149  1474  4914 V NotificationHistory: Attempted to add notif for  
locked/gone/disabled user 0
10-16 23:46:24.888  1474  4914 I ActivityTaskManager: START u0
{act=ACTION_NOTIFICATION_complete flg=0x10000000 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity
bnds=[189,791][501,899] (has extras)} with LAUNCH_SINGLE_TOP from uid 10665       
(com.habittracker.habitv8.debug) (realCallingUid=10249)
(BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result code=3
10-16 23:46:24.890  1474  4914 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:47:00.329  1474  1474 I AS.AudioService: shouldNotificationSoundPlay     
false: muted stream:5 attr:AudioAttributes: usage=USAGE_NOTIFICATION
content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null
10-16 23:47:00.334  1474  1474 V NotificationHistory: Attempted to add notif for  
locked/gone/disabled user 0
10-16 23:47:00.386  1474  3891 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and 
roid.window.IOnBackInvokedCallback$Stub$Proxy@95ba70a, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:47:03.486  1474  2044 I ActivityTaskManager: START u0
{act=ACTION_NOTIFICATION_complete flg=0x10000000 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity
bnds=[189,313][501,421] (has extras)} with LAUNCH_SINGLE_TOP from uid 10665       
(com.habittracker.habitv8.debug) (realCallingUid=10249)
(BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result code=2
10-16 23:47:03.949  1474  3481 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:49:54.248  1474  1998 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and 
roid.window.IOnBackInvokedCallback$Stub$Proxy@192e480, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:49:54.441 10121 10128 I pixel-thermal: Sending notification:  Type: 
USB_PORT Name: VIRTUAL-USB-UI CurrentValue: 0 ThrottlingStatus: NONE
10-16 23:49:54.441 10121 10128 I pixel-thermal: Sending notification:  Type:      
POWER_AMPLIFIER Name: cellular-emergency CurrentValue: 28.9687 ThrottlingStatus:  
NONE
10-16 23:49:54.441 10121 10128 I pixel-thermal: Sending notification:  Type:      
SKIN Name: VIRTUAL-SKIN CurrentValue: 28.9687 ThrottlingStatus: NONE
10-16 23:49:54.442 10121 10128 I pixel-thermal: Sending notification:  Type:      
BATTERY Name: battery CurrentValue: 28 ThrottlingStatus: NONE
10-16 23:49:54.442 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: VIRTUAL-SKIN-SPEAKER CurrentValue: 27.6062 ThrottlingStatus: NONE   
10-16 23:49:54.442 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: ShutdownMode CurrentValue: 28.9687 ThrottlingStatus: NONE
10-16 23:49:54.525   932  1969 W Lyric   :
external_auto_focus_controller_proxy.cc:862: 6 calls in 214 sec(s): Not able to   
get shutter notification timestamp
10-16 23:49:54.525   932  1969 E Lyric   :
external_auto_focus_controller_proxy.cc:1082: 6 calls in 214 sec(s): Not able to  
get shutter notification timestamp. No actuator data is collected.
10-16 23:49:54.529   932  1814 W Lyric   : shutter_notification_manager.cc:138:   
Sensor with vsync id : 2 creating vsync sensor connection spent 24.267741ms       
10-16 23:49:54.719   932 19884 W Lyric   : shutter_notification_manager.cc:270: 
1 calls in 213 sec(s): vsync timeout for frame 5
10-16 23:49:54.719   932 19884 I Lyric   : shutter_notification_manager.cc:312:   
1 calls in 213 sec(s): vsync_timestamp unavailable. Apply previous
vsync_sof_offset -82893
10-16 23:49:54.902  1474  1998 I InputDispatcher: Channel 9db3626
UdfpsControllerOverlay is stealing input gesture for device 3 from [3370184       
NotificationShade, [Gesture Monitor] swipe-up, [Gesture Monitor] edge-swipe]      
10-16 23:49:55.163   932  1967 W Lyric   : auto_focus_node.cc:1309: 3 calls in    
213 sec(s): cam7_af, frame_number: 18, shutter notification is not available.     
Update vsync with current boottime and previous offset.
10-16 23:49:55.199   932  1458 I Lyric   : zuma_be_core_driver_impl.cc:433: 
BeCore: receives context release notification
10-16 23:49:55.204   932  1460 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:49:55.205  1474  3573 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:49:55.206   932  1460 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:49:55.209   932  1460 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:49:55.590 17650 17650 I flutter : │ 💡 🔄 Handling app resume -
re-registering notification callbacks...
10-16 23:49:55.898 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:48:15)
10-16 23:49:55.898 17650 17650 I flutter : │ 💡 🔍 Checking notification 
callback registration...
10-16 23:49:55.899 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:49:15)
10-16 23:49:55.899 17650 17650 I flutter : │ #1   
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:50:15)
10-16 23:49:55.899 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:61:17)
10-16 23:49:55.899 17650 17650 I flutter : │ 💡 ✅ Notification action callback   
is properly registered
10-16 23:49:56.905 17650 17650 I flutter : │ #1
NotificationService.processPendingActionsManually
(package:habitv8/services/notification_service.dart:193:15)
10-16 23:49:56.905 17650 17650 I flutter : │ 🐛 Processing pending actions        
manually (no-op for awesome_notifications)
10-16 23:49:57.404 17650 17650 I flutter : │ #1
NotificationActionHandlerIsar.processPendingCompletions
(package:habitv8/services/notifications/notification_action_handler.dart:600:15)  
10-16 23:49:57.405 17650 17650 I flutter : │ 🐛 Processing pending completions    
(no-op for awesome_notifications)
10-16 23:49:57.406 17650 17650 I flutter : 🧪 FORCE UPDATE: Called from
notification completion handler
10-16 23:50:01.104  4237  4237 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener yxg@c7c1c61 was not
registered for notification class yxh
10-16 23:50:01.104  4237  4237 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener ywz@3d4224c was not
registered for notification class yxa
10-16 23:50:04.817  4237  4237 W NotificationCenter: 
NotificationCenter.unregisterListener():480 Listener lsc@2d61c6b was not
registered for notification class xcm
10-16 23:50:04.817  4237 19941 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener lxd@3f1b809 was not
registered for notification class xma
10-16 23:50:04.818  4237 19941 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener lxc@1f4cbc5 was not
registered for notification class xcm
10-16 23:50:04.818  4237  4237 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener ywz@3d4224c was not
registered for notification class yxa
10-16 23:50:10.985 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:63:15)
10-16 23:50:10.985 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:64:15)
10-16 23:50:10.986 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:73:15)
10-16 23:50:10.988 17650 17650 I flutter : │ #1
NotificationScheduler.cancelHabitNotificationsByHabitId
(package:habitv8/services/notifications/notification_scheduler.dart:619:15)       
10-16 23:50:10.989 17650 17650 I flutter : │ 🐛 🚫 Starting notification 
cancellation for habit: 1760683810937
10-16 23:50:11.000 17650 17650 I flutter : │ #1
NotificationScheduler.scheduleHabitNotifications
(package:habitv8/services/notifications/notification_scheduler.dart:164:15)       
10-16 23:50:11.000 17650 17650 I flutter : │ 🐛 Starting notification scheduling  
for habit: ufhfjfj (isNewHabit: true)
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationScheduler.scheduleHabitNotifications
(package:habitv8/services/notifications/notification_scheduler.dart:167:15)       
10-16 23:50:11.001 17650 17650 I flutter : │ 🐛 Notifications enabled: false      
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationScheduler.scheduleHabitNotifications
(package:habitv8/services/notifications/notification_scheduler.dart:171:17)       
10-16 23:50:11.001 17650 17650 I flutter : │ 🐛 Skipping notifications - disabled 
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationScheduler.scheduleHabitNotifications
(package:habitv8/services/notifications/notification_scheduler.dart:172:17)       
10-16 23:50:11.001 17650 17650 I flutter : │ 💡 Notifications disabled for        
habit: ufhfjfj
10-16 23:50:11.001 17650 17650 I flutter : │ #1   
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)  
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)  
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)  
10-16 23:50:11.001 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)  
10-16 23:50:11.002 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:44:15)  
10-16 23:50:11.002 17650 17650 I flutter : │ 💡 🔔 Checking notification 
permissions before scheduling alarm...
10-16 23:50:11.002 17650 17650 I flutter : │ #1
NotificationCore.ensureNotificationPermissions
(package:habitv8/services/notifications/notification_core.dart:242:17)
10-16 23:50:11.002 17650 17650 I flutter : │ 💡 Checking notification 
permission...
10-16 23:50:11.004 17650 17650 I flutter : │ #1
NotificationCore.ensureNotificationPermissions
(package:habitv8/services/notifications/notification_core.dart:258:19)
10-16 23:50:11.004 17650 17650 I flutter : │ 💡 Notification permission already   
granted
10-16 23:50:11.004 17650 17650 I flutter : │ #1
NotificationCore.isAndroid12Plus
(package:habitv8/services/notifications/notification_core.dart:184:17)
10-16 23:50:11.004 17650 17650 I flutter : │ #1
NotificationCore.ensureNotificationPermissions
(package:habitv8/services/notifications/notification_core.dart:280:19)
10-16 23:50:11.005 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:75:17)  
10-16 23:50:11.005 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:83:17)  
10-16 23:50:11.006 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:88:21)  
10-16 23:50:11.006 17650 17650 I flutter : │ #1
NotificationAlarmScheduler._scheduleDailyHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:134:15) 
10-16 23:50:11.031 17650 17650 I flutter : │ #1
AlarmService._scheduleNotificationAlarm
(package:habitv8/services/alarm_service.dart:389:19)
10-16 23:50:11.040 17650 17650 D Android: [Awesome Notifications]: Scheduled      
created (NotificationScheduler:228)
10-16 23:50:11.041 17650 17650 I flutter : │ #1
NotificationAlarmScheduler._scheduleDailyHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:166:17) 
10-16 23:50:11.041 17650 17650 I flutter : │ #1
NotificationAlarmScheduler.scheduleHabitAlarms
(package:habitv8/services/notifications/notification_alarm_scheduler.dart:118:17) 
10-16 23:50:11.042 17650 17650 I flutter : │ 💡 ✅ Notifications/alarms scheduled 
for: ufhfjfj
10-16 23:50:11.495 17650 17650 I flutter : │ #1   
NotificationUpdateCoordinator._updateWidgets
(package:habitv8/services/notification_update_coordinator.dart:81:17)
10-16 23:51:05.221  1474  3380 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@597c3dd, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type: 
USB_PORT Name: VIRTUAL-USB-UI CurrentValue: 0 ThrottlingStatus: NONE
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type:      
POWER_AMPLIFIER Name: cellular-emergency CurrentValue: 29.2083 ThrottlingStatus:  
NONE
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type:      
SKIN Name: VIRTUAL-SKIN CurrentValue: 29.2083 ThrottlingStatus: NONE
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type:      
BATTERY Name: battery CurrentValue: 28 ThrottlingStatus: NONE
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: VIRTUAL-SKIN-SPEAKER CurrentValue: 27.7955 ThrottlingStatus: NONE   
10-16 23:51:05.337 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: ShutdownMode CurrentValue: 29.2052 ThrottlingStatus: NONE
10-16 23:51:05.370   932  1964 W Lyric   : 
external_auto_focus_controller_proxy.cc:862: 3 calls in 71 sec(s): Not able to 
get shutter notification timestamp
10-16 23:51:05.370   932  1964 E Lyric   :
external_auto_focus_controller_proxy.cc:1082: 3 calls in 71 sec(s): Not able to   
get shutter notification timestamp. No actuator data is collected.
10-16 23:51:05.956  1474  3380 I InputDispatcher: Channel 16d9d78 
UdfpsControllerOverlay is stealing input gesture for device 3 from [3370184 
NotificationShade, [Gesture Monitor] swipe-up, [Gesture Monitor] edge-swipe]      
10-16 23:51:06.109   932  1966 W Lyric   : auto_focus_node.cc:1309: 3 calls in 
71 sec(s): cam7_af, frame_number: 20, shutter notification is not available. 
Update vsync with current boottime and previous offset.
10-16 23:51:06.109   932  1962 W Lyric   : auto_focus_node.cc:1412: 2 calls in    
284 sec(s): cam7_af, frame_number: 20, shutter notification is not available      
10-16 23:51:06.123   932  1459 I Lyric   : zuma_be_core_driver_impl.cc:433: 
BeCore: receives context release notification
10-16 23:51:06.126   932  1458 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:51:06.128   932  1458 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:51:06.132   932  1458 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:51:06.149  1474  1982 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback null
10-16 23:51:06.542 17650 17650 I flutter : │ 💡 🔄 Handling app resume - 
re-registering notification callbacks...
10-16 23:51:06.855 17650 17650 I flutter : │ #1   
NotificationActionService.ensureCallbackRegistered 
(package:habitv8/services/notification_action_service.dart:48:15)
10-16 23:51:06.855 17650 17650 I flutter : │ 💡 🔍 Checking notification 
callback registration...
10-16 23:51:06.855 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:49:15)
10-16 23:51:06.855 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:50:15)
10-16 23:51:06.855 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:61:17)
10-16 23:51:06.855 17650 17650 I flutter : │ 💡 ✅ Notification action callback   
is properly registered
10-16 23:51:07.863 17650 17650 I flutter : │ #1
NotificationService.processPendingActionsManually
(package:habitv8/services/notification_service.dart:193:15)
10-16 23:51:07.863 17650 17650 I flutter : │ 🐛 Processing pending actions        
manually (no-op for awesome_notifications)
10-16 23:51:08.360 17650 17650 I flutter : │ #1
NotificationActionHandlerIsar.processPendingCompletions
(package:habitv8/services/notifications/notification_action_handler.dart:600:15)  
10-16 23:51:08.361 17650 17650 I flutter : │ 🐛 Processing pending completions    
(no-op for awesome_notifications)
10-16 23:51:08.362 17650 17650 I flutter : 🧪 FORCE UPDATE: Called from
notification completion handler
10-16 23:51:10.923  2519  2519 I NotificationListener: Handling notification      
state refresh for com.huami.watch.hmwatchmanager#0
10-16 23:51:11.649  2519  2519 I NotificationListener: Handling notification      
state refresh for com.huami.watch.hmwatchmanager#0
10-16 23:51:51.587  1474  1474 I AS.AudioService: shouldNotificationSoundPlay 
false: muted stream:5 attr:AudioAttributes: usage=USAGE_NOTIFICATION 
content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null
10-16 23:51:51.588  1474  1474 D FlashNotifController: 
requestStartFlashNotification
10-16 23:51:51.588  1474  1474 I FlashNotifController: startFlashNotification: 
type=1, tag=android
10-16 23:51:51.588  1474  1474 D FlashNotifController: Flash notification is 
disabled
10-16 23:51:51.604  1474  1474 V NotificationHistory: Attempted to add notif for 
locked/gone/disabled user 0
10-16 23:51:51.617  4263  5750 I AiAiEcho: SmartspaceNotificationPredictor no 
parser can handle this notification or notification is invalid
10-16 23:51:51.626  2519  2519 I NotificationListener: received notification 
posted event - alerts.growagarden.com#UserHandle{0},category=-1
10-16 23:51:51.626  4516  6673 E music   : Blocked onNotificationPosted 
StatusBarNotification(pkg=alerts.growagarden.com user=UserHandle{0} id=0 
tag=FCM-Notification:3266982 
key=0|alerts.growagarden.com|0|FCM-Notification:3266982|10655: 
Notification(channel=high_importance_channel shortcut=null contentView=null 
vibrate=null sound=null defaults=0 flags=AUTO_CANCEL color=0xff4caf50 
vis=PRIVATE))
10-16 23:51:51.928 20154 20154 I flutter : 📢 Notification channel created: 
high_importance_channel
10-16 23:51:51.929 20154 20154 I flutter : 📱 Local notification service 
initialized successfully
10-16 23:52:00.141  1474  5609 I PowerGroup: Waking up power group from Dozing 
(groupId=0, uid=10665, reason=WAKE_REASON_APPLICATION, 
details=HabitV8:NotificationBuilder:WakeupLock)...
10-16 23:52:00.143  1474  5609 I PowerManagerService: Waking up from Dozing 
(uid=10665, reason=WAKE_REASON_APPLICATION, 
details=HabitV8:NotificationBuilder:WakeupLock)...
10-16 23:52:00.175  1474  5609 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@17cb2e7, mPriority=0, 
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:52:00.257 17650 17650 I flutter : │ #1   onNotificationDisplayed 
(package:habitv8/services/notifications/notification_action_handler.dart:192:15)
10-16 23:52:00.257 17650 17650 I flutter : │ 💡 🔔 Notification displayed: 
14943426
10-16 23:52:00.258 17650 17650 I flutter : │ #1   onNotificationDisplayed 
(package:habitv8/services/notifications/notification_action_handler.dart:193:15)
10-16 23:52:00.259 17650 17650 I flutter : │ #1   onNotificationDisplayed
(package:habitv8/services/notifications/notification_action_handler.dart:194:15)  
10-16 23:52:00.259 17650 17650 I flutter : │ 💡    Category:
NotificationCategory.Alarm
10-16 23:52:00.405  1474  1474 I AS.AudioService: shouldNotificationSoundPlay 
false: muted stream:5 attr:AudioAttributes: usage=USAGE_NOTIFICATION 
content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null
10-16 23:52:00.406  1474  1474 D FlashNotifController:
requestStartFlashNotification
10-16 23:52:00.406  1474  1474 I FlashNotifController: startFlashNotification:    
type=1, tag=android
10-16 23:52:00.406  1474  1474 D FlashNotifController: Flash notification is      
disabled
10-16 23:52:00.410  1474  1474 V NotificationHistory: Attempted to add notif for  
locked/gone/disabled user 0
10-16 23:52:00.416  2519  2519 I NotificationListener: received notification      
posted event - com.habittracker.habitv8.debug#UserHandle{0},category=-1
10-16 23:52:00.417  4516  6673 E music   : Blocked onNotificationPosted
StatusBarNotification(pkg=com.habittracker.habitv8.debug user=UserHandle{0}       
id=14943426 tag=null key=0|com.habittracker.habitv8.debug|14943426|null|10665:    
Notification(channel=habit_alarm_alarm_4 shortcut=null contentView=null
vibrate=null sound=null tick defaults=0
flags=SHOW_LIGHTS|ONGOING_EVENT|INSISTENT|NO_CLEAR|HIGH_PRIORITY
color=0xffff0000 category=alarm actions=2 vis=PRIVATE))
10-16 23:52:00.421  4263  5750 I AiAiEcho: SmartspaceNotificationPredictor no     
parser can handle this notification or notification is invalid
10-16 23:52:00.444  1474  1982 I ActivityTaskManager: START u0 
{act=SELECT_NOTIFICATION flg=0x14000000 xflg=0x4
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has     
extras)} with LAUNCH_SINGLE_TOP from uid 10665 (com.habittracker.habitv8.debug)   
(realCallingUid=10249) (BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result     
code=2
10-16 23:52:00.445 17650 17650 D MainActivity: onNewIntent called with action:    
SELECT_NOTIFICATION
10-16 23:52:00.445 17650 17650 I MainActivity: Notification interaction -
preserving alarm service and continuing normally
10-16 23:52:00.476 17650 17650 I flutter : │ #1   
onBackgroundNotificationActionIsar 
(package:habitv8/services/notifications/notification_action_handler.dart:35:15)   
10-16 23:52:00.476 17650 17650 I flutter : │ 💡 🔔 BACKGROUND notification        
action received (Isar)
10-16 23:52:00.477 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:36:15)   
10-16 23:52:00.480 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:37:15)   
10-16 23:52:00.481 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:50:15)   
10-16 23:52:00.483 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:59:21)   
10-16 23:52:00.484 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:63:21)   
10-16 23:52:00.485 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:73:23)   
10-16 23:52:00.486 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:83:15)
10-16 23:52:00.486 17650 17650 I flutter : │ 💡 🎯 _handleNotificationAction      
called
10-16 23:52:00.487 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:84:15)
10-16 23:52:00.488 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:85:15)
10-16 23:52:00.490  2215  2796 V EmphasizedNotificationButton: iconSize = 45px,   
initialDrawablePadding = 14px
10-16 23:52:00.490  2215  2796 V EmphasizedNotificationButton: iconSize = 45px,   
initialDrawablePadding = 14px
10-16 23:52:00.492 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:86:15)
10-16 23:52:00.496 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:94:15)
10-16 23:52:00.496 17650 17650 I flutter : │ 💡 🚀 Processing notification        
action:  for habit: 1760683810937
10-16 23:52:00.498 17650 17650 I flutter : │ #1   
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:118:21)
10-16 23:52:00.498 17650 17650 I flutter : │ ⚠️ Unknown notification action:      
10-16 23:52:00.501 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:103:15)  
10-16 23:52:00.502 17650 17650 I flutter : │ 💡 ✅ Background notification action 
processed
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
onRtlPropertiesChanged: layoutDirection = 0, gluedLayoutDirection = -1
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
glueIconAndLabelIfNeeded: glue not pending; doing nothing
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
onRtlPropertiesChanged: layoutDirection = 0, gluedLayoutDirection = -1
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
glueIconAndLabelIfNeeded: glue not pending; doing nothing
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
onRtlPropertiesChanged: layoutDirection = 0, gluedLayoutDirection = -1
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
glueIconAndLabelIfNeeded: glue not pending; doing nothing
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
onRtlPropertiesChanged: layoutDirection = 0, gluedLayoutDirection = -1
10-16 23:52:00.505  2215  2215 V EmphasizedNotificationButton:
glueIconAndLabelIfNeeded: glue not pending; doing nothing
10-16 23:52:10.483  1474  2044 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback null
10-16 23:52:11.263  4237  4237 W NotificationCenter: 
NotificationCenter.unregisterListener():480 Listener grj@61664ca was not 
registered for notification class ywh
10-16 23:52:11.263  4237  4237 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener gts@df5b440 was not
registered for notification class ywh
10-16 23:52:34.899  1474  5609 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@ed7967, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type: 
USB_PORT Name: VIRTUAL-USB-UI CurrentValue: 0 ThrottlingStatus: NONE
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type:      
POWER_AMPLIFIER Name: cellular-emergency CurrentValue: 29.3668 ThrottlingStatus:  
NONE
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type:      
SKIN Name: VIRTUAL-SKIN CurrentValue: 29.3668 ThrottlingStatus: NONE
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type:      
BATTERY Name: battery CurrentValue: 28.1 ThrottlingStatus: NONE
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: VIRTUAL-SKIN-SPEAKER CurrentValue: 27.8652 ThrottlingStatus: NONE   
10-16 23:52:35.179 10121 10128 I pixel-thermal: Sending notification:  Type:      
UNKNOWN Name: ShutdownMode CurrentValue: 29.3668 ThrottlingStatus: NONE
10-16 23:52:35.241   932  1965 W Lyric   : 
external_auto_focus_controller_proxy.cc:862: 3 calls in 90 sec(s): Not able to 
get shutter notification timestamp
10-16 23:52:35.241   932  1965 E Lyric   :
external_auto_focus_controller_proxy.cc:1082: 3 calls in 90 sec(s): Not able to   
get shutter notification timestamp. No actuator data is collected.
10-16 23:52:36.125  1474  3891 I InputDispatcher: Channel e439989 
UdfpsControllerOverlay is stealing input gesture for device 3 from [3370184 
NotificationShade, [Gesture Monitor] swipe-up, [Gesture Monitor] edge-swipe]      
10-16 23:52:36.398   932  1966 W Lyric   : auto_focus_node.cc:1412: 1 calls in 
90 sec(s): cam7_af, frame_number: 33, shutter notification is not available
10-16 23:52:36.398   932  1964 W Lyric   : auto_focus_node.cc:1309: 4 calls in    
90 sec(s): cam7_af, frame_number: 33, shutter notification is not available.      
Update vsync with current boottime and previous offset.
10-16 23:52:36.421   932  1458 I Lyric   : zuma_be_core_driver_impl.cc:433: 
BeCore: receives context release notification
10-16 23:52:36.427   932  1459 I Lyric   : zuma_fe_driver.cc:1437: [ISPFE]        
Received context release notification for camera 7
10-16 23:52:36.430   932  1459 I Lyric   :
unified_zuma_front_end_controller.cc:488: [CAM7] Received notification that       
graph has stopped
10-16 23:52:36.436   932  1459 I Lyric   : zuma_fe_driver.cc:943: [ISPFE]
Received context release notification when releasing power_context.
10-16 23:52:36.443  1474  4914 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:52:36.852 17650 17650 I flutter : │ 💡 🔄 Handling app resume - 
re-registering notification callbacks...
10-16 23:52:36.866  4237  4237 W NotificationCenter:
NotificationCenter.unregisterListener():480 Listener gts@68fde1b was not
registered for notification class ywh
10-16 23:52:37.157 17650 17650 I flutter : │ #1   
NotificationActionService.ensureCallbackRegistered 
(package:habitv8/services/notification_action_service.dart:48:15)
10-16 23:52:37.157 17650 17650 I flutter : │ 💡 🔍 Checking notification 
callback registration...
10-16 23:52:37.157 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:49:15)
10-16 23:52:37.157 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:50:15)
10-16 23:52:37.157 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:61:17)
10-16 23:52:37.158 17650 17650 I flutter : │ 💡 ✅ Notification action callback   
is properly registered
10-16 23:52:38.142  1474  4914 D CoreBackPreview: Window{3370184 u0 
NotificationShade}: Setting back callback OnBackInvokedCallbackInfo{mCallback=and
roid.window.IOnBackInvokedCallback$Stub$Proxy@f39d570, mPriority=0,
mIsAnimationCallback=false, mOverrideBehavior=0}
10-16 23:52:38.159 17650 17650 I flutter : │ #1   
NotificationService.processPendingActionsManually
(package:habitv8/services/notification_service.dart:193:15)
10-16 23:52:38.159 17650 17650 I flutter : │ 🐛 Processing pending actions        
manually (no-op for awesome_notifications)
10-16 23:52:38.662 17650 17650 I flutter : │ #1   
NotificationActionHandlerIsar.processPendingCompletions 
(package:habitv8/services/notifications/notification_action_handler.dart:600:15)  
10-16 23:52:38.662 17650 17650 I flutter : │ 🐛 Processing pending completions    
(no-op for awesome_notifications)
10-16 23:52:38.663 17650 17650 I flutter : 🧪 FORCE UPDATE: Called from
notification completion handler
10-16 23:52:39.311  1474  1982 I ActivityTaskManager: START u0 
{act=ACTION_NOTIFICATION_complete flg=0x10000000 xflg=0x4 
cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity
bnds=[189,791][501,899] (has extras)} with LAUNCH_SINGLE_TOP from uid 10665       
(com.habittracker.habitv8.debug) (realCallingUid=10249)
(BAL_ALLOW_NON_APP_VISIBLE_WINDOW [realCaller]) result code=3
10-16 23:52:39.312  1474  3380 D CoreBackPreview: Window{3370184 u0
NotificationShade}: Setting back callback null
10-16 23:52:39.315 17650 17650 D MainActivity: onNewIntent called with action:    
ACTION_NOTIFICATION_complete
10-16 23:52:39.331  2519  2519 I NotificationListener: received notification 
removed event - com.habittracker.habitv8.debug#UserHandle{0},category=-1
10-16 23:52:39.341 17650 17650 I flutter : │ #1   
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:35:15)   
10-16 23:52:39.341 17650 17650 I flutter : │ 💡 🔔 BACKGROUND notification        
action received (Isar)
10-16 23:52:39.342 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:36:15)   
10-16 23:52:39.342 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:37:15)   
10-16 23:52:39.343 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:44:17)   
10-16 23:52:39.343 17650 17650 I flutter : │ 💡 ✅ Alarm action received -        
notification auto-dismissing
10-16 23:52:39.343 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:50:15)   
10-16 23:52:39.343 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:59:21)   
10-16 23:52:39.343 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:63:21)   
10-16 23:52:39.344 17650 17650 I flutter : │ #1   
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:73:23)   
10-16 23:52:39.344 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:83:15)
10-16 23:52:39.344 17650 17650 I flutter : │ 💡 🎯 _handleNotificationAction 
called
10-16 23:52:39.344 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:84:15)
10-16 23:52:39.345 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:85:15)
10-16 23:52:39.345 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:86:15)
10-16 23:52:39.345 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:94:15)
10-16 23:52:39.345 17650 17650 I flutter : │ 💡 🚀 Processing notification        
action: complete for habit: 1760683810937
10-16 23:52:39.345 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:101:21)
10-16 23:52:39.346 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:132:17)
10-16 23:52:39.346 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:152:17)
10-16 23:52:39.346 17650 17650 I flutter : │ #1
onBackgroundNotificationActionIsar
(package:habitv8/services/notifications/notification_action_handler.dart:103:15)  
10-16 23:52:39.346 17650 17650 I flutter : │ 💡 ✅ Background notification action 
processed
10-16 23:52:39.349 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:157:19)
10-16 23:52:39.357 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:166:19)
10-16 23:52:39.362 17650 17650 I flutter : │ 💡 🔄 Handling app resume -
re-registering notification callbacks...
10-16 23:52:39.369 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:213:19)
10-16 23:52:39.370 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:217:21)
10-16 23:52:39.370 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:219:21)
10-16 23:52:39.370 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:220:21)
10-16 23:52:39.394 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:63:15)
10-16 23:52:39.394 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:64:15)
10-16 23:52:39.395 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._onHabitsChanged
(package:habitv8/services/notification_update_coordinator.dart:73:15)
10-16 23:52:39.396 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction 
(package:habitv8/services/notification_action_service.dart:231:21)
10-16 23:52:39.396 17650 17650 I flutter : │ 💡 ✅ SUCCESS: Habit marked as       
complete from notification: ufhfjfj for today
10-16 23:52:39.401 17650 17650 I flutter : │ #1
NotificationUpdateCoordinator._updateWidgets
(package:habitv8/services/notification_update_coordinator.dart:81:17)
10-16 23:52:39.422 17650 17650 I flutter : │ #1   
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:239:25)
10-16 23:52:39.422 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:246:27)
10-16 23:52:39.526 17650 17650 I flutter : │ #1   
NotificationActionService._handleCompleteAction 
(package:habitv8/services/notification_action_service.dart:260:21)
10-16 23:52:39.528 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:266:23)
10-16 23:52:39.528 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:271:23)
10-16 23:52:39.528 17650 17650 I flutter : │ #1
NotificationActionService._triggerImmediateUIUpdate
(package:habitv8/services/notification_action_service.dart:454:17)
10-16 23:52:39.529 17650 17650 I flutter : │ 💡 🚀 Triggering immediate UI        
update for notification completion
10-16 23:52:39.529 17650 17650 I flutter : │ #1
NotificationActionService._triggerImmediateUIUpdate
(package:habitv8/services/notification_action_service.dart:460:19)
10-16 23:52:39.530 17650 17650 I flutter : │ #1
NotificationActionService._handleCompleteAction
(package:habitv8/services/notification_action_service.dart:282:23)
10-16 23:52:39.530 17650 17650 I flutter : │ 💡 🔄 Updating widgets after
notification completion...
10-16 23:52:39.530 17650 17650 I flutter : │ #1
NotificationActionService._sendWidgetUpdateBroadcast
(package:habitv8/services/notification_action_service.dart:71:17)
10-16 23:52:39.536 17650 17650 I flutter : │ #1
NotificationActionService._sendWidgetUpdateBroadcast
(package:habitv8/services/notification_action_service.dart:74:17)
10-16 23:52:39.536 17650 17650 I flutter : 🧪 FORCE UPDATE: Called from
notification completion handler
10-16 23:52:39.669 17650 17650 I flutter : │ #1   
NotificationActionService.ensureCallbackRegistered 
(package:habitv8/services/notification_action_service.dart:48:15)
10-16 23:52:39.669 17650 17650 I flutter : │ 💡 🔍 Checking notification 
callback registration...
10-16 23:52:39.669 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:49:15)
10-16 23:52:39.669 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:50:15)
10-16 23:52:39.670 17650 17650 I flutter : │ #1
NotificationActionService.ensureCallbackRegistered
(package:habitv8/services/notification_action_service.dart:61:17)
10-16 23:52:39.670 17650 17650 I flutter : │ 💡 ✅ Notification action callback   
is properly registered
10-16 23:52:39.745 17650 17650 I flutter : │ #1   
NotificationActionService._handleCompleteAction 
(package:habitv8/services/notification_action_service.dart:292:23)
10-16 23:52:39.745 17650 17650 I flutter : │ #1
NotificationActionService._handleNotificationAction
(package:habitv8/services/notification_action_service.dart:105:21)
10-16 23:52:39.837  4516  6673 E music   : Blocked onNotificationRemoved 
StatusBarNotification(pkg=com.habittracker.habitv8.debug user=UserHandle{0} 
id=14943426 tag=null key=0|com.habittracker.habitv8.debug|14943426|null|10665:    
Notification(channel=habit_alarm_alarm_4 shortcut=null contentView=null
vibrate=null sound=null tick defaults=0
flags=SHOW_LIGHTS|ONGOING_EVENT|INSISTENT|NO_CLEAR|HIGH_PRIORITY
color=0xffff0000 category=alarm actions=2 vis=PRIVATE))-state=2
10-16 23:52:40.676 17650 17650 I flutter : │ #1   
NotificationService.processPendingActionsManually 
(package:habitv8/services/notification_service.dart:193:15)
10-16 23:52:40.676 17650 17650 I flutter : │ 🐛 Processing pending actions        
manually (no-op for awesome_notifications)
10-16 23:52:41.175 17650 17650 I flutter : │ #1   
NotificationActionHandlerIsar.processPendingCompletions 
(package:habitv8/services/notifications/notification_action_handler.dart:600:15)  
10-16 23:52:41.175 17650 17650 I flutter : │ 🐛 Processing pending completions    
(no-op for awesome_notifications)
10-16 23:52:41.176 17650 17650 I flutter : 🧪 FORCE UPDATE: Called from
notification completion handler
10-16 23:53:32.763  2519  2519 I NotificationListener: received notification 
posted event - com.huami.watch.hmwatchmanager#UserHandle{0},category=-1
10-16 23:53:32.764  4516  6673 E music   : Blocked onNotificationPosted
StatusBarNotification(pkg=com.huami.watch.hmwatchmanager user=UserHandle{0} id=4  
tag=null key=0|com.huami.watch.hmwatchmanager|4|null|10345:
Notification(channel=c shortcut=null contentView=null vibrate=null sound=null     
defaults=0 flags=ONGOING_EVENT|NO_CLEAR|FOREGROUND_SERVICE color=0xff007baf       
vis=PRIVATE))
10-16 23:53:32.770  4263  5750 I AiAiEcho: SmartspaceNotificationPredict