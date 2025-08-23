PS C:\HabitV8> adb logcat | findstr habitv8
08-23 13:09:11.367  1380  1886 D InstallDependencyHelper: No missing dependency for com.habittracker.habitv8.debug
08-23 13:09:11.620  1380  1670 D BackupManagerService: [UserID:0] restoreAtInstall pkg=com.habittracker.habitv8.debug token=a restoreSet=0
08-23 13:09:11.625  1380  1670 I PackageManager: installation completed for package:com.habittracker.habitv8.debug. Final code path: /data/app/~~Ya2Oh8wtA7WtRaW-ExAhRQ==/com.habittracker.habitv8.debug-cr8e5hrpdaU1j8lNL2y2Pg==
08-23 13:09:11.626  1380  1670 I AppsFilter: interaction: PackageSetting{a6342db com.google.android.microdroid.empty_payload/10294} -> PackageSetting{ef96eb com.habittracker.habitv8.debug/10354} BLOCKED
08-23 13:09:11.631  1380  2055 W BackgroundInstallControlService: Package's historical install session not found, falling back to appInfo.createTimestamp: com.habittracker.habitv8.debug
08-23 13:09:11.671  1380  2052 D ShortcutService: adding package: com.habittracker.habitv8.debug userId=0
08-23 13:09:11.717  1380  1380 I AppsFilter: interaction: PackageSetting{390805d com.google.android.microdroid.empty_payload/10294} -> PackageSetting{912dd2 com.habittracker.habitv8.debug/10354} BLOCKED
08-23 13:09:11.734  1380  2052 D ShortcutService: changing package: com.habittracker.habitv8.debug userId=0
08-23 13:09:12.051  1380  1507 D LauncherAppsService: onPackageAdded: triggering onPackageAdded for user=UserHandle{0}, packageName=com.habittracker.habitv8.debug
08-23 13:09:12.051  1380  1507 D LauncherAppsService: onPackageAdded: triggering onPackageAdded for user=UserHandle{0}, packageName=com.habittracker.habitv8.debug
08-23 13:09:12.051  1380  1507 D LauncherAppsService: onPackageAdded: Skipping - package filtered for user=UserHandle{0}, packageName=com.habittracker.habitv8.debug
08-23 13:09:12.051  1380  1507 D LauncherAppsService: onPackageAdded: triggering onPackageAdded for user=UserHandle{0}, packageName=com.habittracker.habitv8.debug
08-23 13:09:25.724  1380  5521 I ActivityTaskManager: START u0 {act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x34000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} with LAUNCH_SINGLE_TOP from uid 10100 (sr=19957017) (BAL_ALLOW_VISIBLE_WINDOW) result code=0
08-23 13:09:25.724  2129  2152 V WindowManagerShell: Transition requested (#359): android.os.BinderProxy@951d8e1 TransitionRequestInfo { type = OPEN, triggerTask = TaskInfo{userId=0 taskId=730 effectiveUid=10354 displayId=0 isRunning=true baseIntent=Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x34000000 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity } baseActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} topActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} origActivity=null realActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} numActivities=1 lastActiveTime=13047382 supportsMultiWindow=true resizeMode=1 isResizeable=true minWidth=-1 minHeight=-1 defaultMinSize=220 token=WCT{android.window.IWindowContainerToken$Stub$Proxy@6f41606} topActivityType=1 pictureInPictureParams=null shouldDockBigOverlays=false launchIntoPipHostTaskId=-1 lastParentTaskIdBeforePip=-1 displayCutoutSafeInsets=Rect(0, 149 - 0, 0) topActivityInfo=ActivityInfo{34764c7 com.habittracker.habitv8.MainActivity} launchCookies=[] positionInParent=Point(0, 0) parentTaskId=-1 isFocused=false isVisible=false isVisibleRequested=false isTopActivityNoDisplay=false isSleeping=false locusId=null displayAreaFeatureId=1 isTopActivityTransparent=false isActivityStackTransparent=false lastNonFullscreenBounds=Rect(256, 665 - 753, 1673) capturedLink=null capturedLinkTimestamp=0 requestedVisibleTypes=-9 topActivityRequestOpenInBrowserEducationTimestamp=0 appCompatTaskInfo=AppCompatTaskInfo { topActivityInSizeCompat=false eligibleForLetterboxEducation= false isLetterboxEducationEnabled= false isLetterboxDoubleTapEnabled= false eligibleForUserAspectRatioButton= false topActivityBoundsLetterboxed= false isFromLetterboxDoubleTap= false topActivityLetterboxVerticalPosition= -1 topActivityLetterboxHorizontalPosition= -1 topActivityLetterboxWidth=-1 topActivityLetterboxHeight=-1 topActivityAppBounds=Rect(0, 0 - 1008, 2244) isUserFullscreenOverrideEnabled=false isSystemFullscreenOverrideEnabled=false hasMinAspectRatioOverride=false topActivityLetterboxBounds=null cameraCompatTaskInfo=CameraCompatTaskInfo { freeformCameraCompatMode=inactive}} topActivityMainWindowFrame=null}, pipChange = null, remoteTransition = null, displayChange = null, flags = 0, debugId = 359 }
08-23 13:09:25.728  1380  5105 I AppsFilter: interaction: PackageSetting{390805d com.google.android.microdroid.empty_payload/10294} -> PackageSetting{683f025 com.habittracker.habitv8.debug/10354} BLOCKED
08-23 13:09:25.745  1380  1512 I ActivityManager: Start proc 15275:com.habittracker.habitv8.debug/u0a354 for next-top-activity {com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}
08-23 13:09:25.765  1380  1490 V WindowManager: Sent Transition (#359) createdAt=08-23 13:09:25.717 via request=TransitionRequestInfo { type = OPEN, triggerTask = TaskInfo{userId=0 taskId=730 effectiveUid=10354 displayId=0 isRunning=true baseIntent=Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x34000000 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity } baseActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} topActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} origActivity=null realActivity=ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} numActivities=1 lastActiveTime=13047382 supportsMultiWindow=true resizeMode=1 isResizeable=true minWidth=-1 minHeight=-1 defaultMinSize=220 token=WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} topActivityType=1 pictureInPictureParams=null shouldDockBigOverlays=false launchIntoPipHostTaskId=-1 lastParentTaskIdBeforePip=-1 displayCutoutSafeInsets=Rect(0, 149 - 0, 0) topActivityInfo=ActivityInfo{1a0b95a com.habittracker.habitv8.MainActivity} launchCookies=[] positionInParent=Point(0, 0) parentTaskId=-1 isFocused=false isVisible=false isVisibleRequested=false isTopActivityNoDisplay=false isSleeping=false locusId=null displayAreaFeatureId=1 isTopActivityTransparent=false isActivityStackTransparent=false lastNonFullscreenBounds=Rect(256, 665 - 753, 1673) capturedLink=null capturedLinkTimestamp=0 requestedVisibleTypes=-9 topActivityRequestOpenInBrowserEducationTimestamp=0 appCompatTaskInfo=AppCompatTaskInfo { topActivityInSizeCompat=false eligibleForLetterboxEducation= false isLetterboxEducationEnabled= false isLetterboxDoubleTapEnabled= false eligibleForUserAspectRatioButton= false topActivityBoundsLetterboxed= false isFromLetterboxDoubleTap= false topActivityLetterboxVerticalPosition= -1 topActivityLetterboxHorizontalPosition= -1 topActivityLetterboxWidth=-1 topActivityLetterboxHeight=-1 topActivityAppBounds=Rect(0, 0 - 1008, 2244) isUserFullscreenOverrideEnabled=false isSystemFullscreenOverrideEnabled=false hasMinAspectRatioOverride=false topActivityLetterboxBounds=null cameraCompatTaskInfo=CameraCompatTaskInfo { freeformCameraCompatMode=inactive}} topActivityMainWindowFrame=null}, pipChange = null, remoteTransition = null, displayChange = null, flags = 0, debugId = 359 }
08-23 13:09:25.765  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=OPEN f=NONE leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:09:26.529  1380  4725 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@702e140, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:09:27.206  1380  5521 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@c177e17, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:09:27.218  1380  5105 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:09:27.497  1380  5521 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@9cd7de1, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:09:29.401  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@4c52989, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:09:29.401  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@3909d8e, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:09:48.323  1380  4725 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@fdf5e6b, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:09:50.196  1380  4725 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:09:50.228  1380  5131 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@838b85b, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:10:09.839  1380  5131 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@b9b122a, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:10:26.672  1380  5523 D CoreBackPreview: startBackNavigation currentTask=Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}, topRunningActivity=ActivityRecord{40011415 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity t730}, callbackInfo=OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@b9b122a, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}, currentFocus=Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}
08-23 13:10:26.814  1380  5131 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@367c98c, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:10:29.841  1380  4265 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@7ebbe24, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:10:30.056  1380  4725 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@7271d8d, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:11:03.948  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=TO_FRONT f=NONE p=WCT{RemoteToken{f600967 DefaultTaskDisplayArea@235954507}} leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:11:04.065  1380  4265 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:13:00.916  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=TO_FRONT f=NONE p=WCT{RemoteToken{f600967 DefaultTaskDisplayArea@235954507}} leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:13:01.360  1380  4265 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:13:03.923  1380  4265 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@9a61250, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:13:05.273  1380  4265 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:13:05.312  1380  4265 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@3d26875, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:13:11.145  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@9f216ca, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:13:20.030  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@df64c65, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:13:21.353  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@8f87992, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:13:21.645  1380  1458 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@fc26f63, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:13:21.836  1380  4257 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@86d3cd8, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:13:22.125  1380  1887 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@61ce831, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:14:10.872  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=TO_FRONT f=NONE p=WCT{RemoteToken{f600967 DefaultTaskDisplayArea@235954507}} leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:14:11.305  1380  1945 I ImeTracker: com.habittracker.habitv8.debug:cd87a03: onRequestHide at ORIGIN_SERVER reason HIDE_SAME_WINDOW_FOCUSED_WITHOUT_EDITOR fromUser false
08-23 13:14:11.305 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:cd87a03: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
08-23 13:14:11.307  4095  4095 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1315 onStartInput(EditorInfo{EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=0, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
08-23 13:14:11.309  1380  4257 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:16:08.697  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=TO_FRONT f=NONE p=WCT{RemoteToken{f600967 DefaultTaskDisplayArea@235954507}} leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:16:09.118  1380  1945 I ImeTracker: com.habittracker.habitv8.debug:9c6b18c1: onRequestHide at ORIGIN_SERVER reason HIDE_SAME_WINDOW_FOCUSED_WITHOUT_EDITOR fromUser false
08-23 13:16:09.119 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:9c6b18c1: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
08-23 13:16:09.122  4095  4095 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1315 onStartInput(EditorInfo{EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=0, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
08-23 13:16:09.128  1380  4086 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:16:10.432 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.432 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:10.434 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.434 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:10.435 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.435 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.437 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.437 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.438 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.438 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.440 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.440 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.496  1380  1458 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@4f7a70, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:16:10.496 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:10.496 15275 15275 I flutter : Γöé #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:126:17)
08-23 13:16:10.496 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:10.496 15275 15275 I flutter : Γöé #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
08-23 13:16:10.499 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.499 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.500 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.500 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:10.500 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:10.500 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:11.330 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:9831e752: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
08-23 13:16:11.337  4095  4095 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1315 onStartInput(EditorInfo{EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=8001, inputTypeString=Normal[AutoCorrect], enableLearning=true, autoCorrection=true, autoComplete=true, imeOptions=2000006, privateImeOptions=null, actionName=DONE, actionLabel=null, initialSelStart=0, initialSelEnd=0, initialCapsMode=0, label=null, fieldId=2, fieldName=null, extras=Bundle[mParcelledData.dataSize=168], hintText=null, hintLocales=[]}}, false)  
08-23 13:16:11.339  1380  5116 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:16:11.340  4095  4095 I GoogleInputMethodService: GoogleInputMethodService.onStartInputView():1408 onStartInputView(EditorInfo{EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=8001, inputTypeString=Normal[AutoCorrect], enableLearning=true, autoCorrection=true, autoComplete=true, imeOptions=2000006, privateImeOptions=null, actionName=DONE, actionLabel=null, initialSelStart=0, initialSelEnd=0, initialCapsMode=0, label=null, fieldId=2, fieldName=null, extras=Bundle[{androidx.core.view.inputmethod.EditorInfoCompat.STYLUS_HANDWRITING_ENABLED=true}], hintText=null, hintLocales=[]}}, false)
08-23 13:16:11.342 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.342 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:11.342 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.342 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:11.343 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.343 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:11.343 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.343 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:11.343 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.343 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:11.343 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:11.343 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:11.377  4095  4095 I AndroidIME: AbstractIme.onActivate():96 LatinIme.onActivate() : EditorInfo = EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=8001, inputTypeString=Normal[AutoCorrect], enableLearning=true, autoCorrection=true, autoComplete=true, imeOptions=2000006, privateImeOptions=null, actionName=DONE, actionLabel=null, initialSelStart=0, initialSelEnd=0, initialCapsMode=0, label=null, fieldId=2, fieldName=null, extras=Bundle[{androidx.core.view.inputmethod.EditorInfoCompat.STYLUS_HANDWRITING_ENABLED=true}], hintText=null, hintLocales=[]}, IncognitoMode = false, DeviceLocked = false
08-23 13:16:11.402  1380  5116 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@bdf8cf5, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:16:11.457  4095 12602 I KeyboardEventHandler: KeyboardEventHandler.handleFieldChangedEvent():457 Handling FieldChangedEvent: fgPkg=com.habittracker.habitv8.debug, fieldType=3.3e+04, interactionType=FIELD_CHANGE [SD]
08-23 13:16:11.735 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:9831e752: onShown
08-23 13:16:12.972 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.972 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:12.972 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.972 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:12.972 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.972 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:12.972 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.972 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:12.973 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.973 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:12.973 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:12.973 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.196 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.196 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:13.196 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.196 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.197 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.197 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.197 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.197 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:13.197 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.197 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.197 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.197 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.404 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.404 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:13.404 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.404 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.405 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.405 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.405 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.405 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:13.406 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.406 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.406 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.406 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:13.588 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.588 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:13.588 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.588 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.589 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.589 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.589 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.589 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:13.589 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.589 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:13.589 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:13.589 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:17.538 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.538 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:17.539 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.539 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:17.540 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.540 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:17.540 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.540 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:17.541 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.541 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:17.542 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:17.542 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:18.880 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:ffc440e9: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
08-23 13:16:18.881  1380  4257 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@bfdea8, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:16:25.809 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.809 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:25.809 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.809 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:25.809 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.809 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:25.810 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.810 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:25.810 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.810 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:25.810 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:25.810 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:27.298 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:27.298 15275 15275 I flutter : Γöé #1   AlarmService.getSystemAlarmSounds (package:habitv8/services/alarm_service.dart:14:17)
08-23 13:16:27.300 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:27.300 15275 15275 I flutter : Γöé #1   AlarmService.getSystemAlarmSounds (package:habitv8/services/alarm_service.dart:28:19)
08-23 13:16:28.433 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.433 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:28.433 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.433 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:28.434 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.434 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:28.435 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.435 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:28.435 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.435 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:28.435 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:28.435 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:28.886  1380  1945 I ImeTracker: com.habittracker.habitv8.debug:ffc440e9: setFinished at PHASE_CLIENT_ANIMATION_CANCEL with STATUS_TIMEOUT
08-23 13:16:31.631 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.631 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:31.631 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.631 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:31.632 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.632 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:31.632 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.632 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:31.632 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.632 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:31.632 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:31.632 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:32.859 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.859 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
08-23 13:16:32.861 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.861 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:32.861 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.861 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:32.862 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.862 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:32.862 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.862 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)      
08-23 13:16:32.862 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:32.863 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #1   CalendarService.syncHabitChanges (package:habitv8/services/calendar_service.dart:254:15)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #1   CalendarService.syncHabitChanges (package:habitv8/services/calendar_service.dart:260:17)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #1   HabitService.addHabit (package:habitv8/data/database.dart:83:17)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:867:17)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.904 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:870:17)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:126:17)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:882:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.912 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1038:17)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1130:17)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1492:23)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
08-23 13:16:34.913 15275 15275 I flutter : Γöé #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1531:19)
08-23 13:16:34.953  1380  4257 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@74625eb, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:19:06.823  1380  1490 V WindowManager:         {WCT{RemoteToken{9106505 Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}}} m=TO_FRONT f=NONE p=WCT{RemoteToken{f600967 DefaultTaskDisplayArea@235954507}} leash=Surface(name=Task=730)/@0xbe4d750 sb=Rect(0, 0 - 1008, 2244) eb=Rect(0, 0 - 1008, 2244) epz=Point(1008, 2244) d=0 taskParent=-1},
08-23 13:19:07.255  1380  1945 I ImeTracker: com.habittracker.habitv8.debug:bc8612d5: onRequestHide at ORIGIN_SERVER reason HIDE_SAME_WINDOW_FOCUSED_WITHOUT_EDITOR fromUser false
08-23 13:19:07.255 15275 15275 I ImeTracker: com.habittracker.habitv8.debug:bc8612d5: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
08-23 13:19:07.256  4095  4095 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1315 onStartInput(EditorInfo{EditorInfo{packageName=com.habittracker.habitv8.debug, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=0, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
08-23 13:19:07.264  1380  5523 W PackageConfigPersister: App-specific configuration not found for packageName: com.habittracker.habitv8.debug and userId: 0
08-23 13:19:18.614  1380  2530 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@6feb06e, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:19:18.918  1380  1506 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@746d30f, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}
08-23 13:19:19.029  1380  1506 D CoreBackPreview: startBackNavigation currentTask=Task{8bf8084 #730 type=standard I=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}, topRunningActivity=ActivityRecord{40011415 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity t730}, callbackInfo=OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@746d30f, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}, currentFocus=Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}
08-23 13:19:19.173  1380  2530 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@a109f9c, mPriority=0, mIsAnimationCallback=true, mOverrideBehavior=0}
08-23 13:19:19.448  1380  5523 D CoreBackPreview: Window{62580d3 u0 com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity}: Setting back callback OnBackInvokedCallbackInfo{mCallback=android.window.IOnBackInvokedCallback$Stub$Proxy@85dada5, mPriority=-1, mIsAnimationCallback=false, mOverrideBehavior=0}





PowerShell Extension v2025.2.0
Copyright (c) Microsoft Corporation.

https://aka.ms/vscode-powershell
Type 'help' to get help.

PS C:\HabitV8> flutter logs     
Showing Pixel 9 Pro XL logs:
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:126:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Health permissions status: false
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Health permissions check result: false
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   AlarmService.getSystemAlarmSounds (package:habitv8/services/alarm_service.dart:14:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Fetching system alarm sounds
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   AlarmService.getSystemAlarmSounds (package:habitv8/services/alarm_service.dart:28:19)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Found 6 alarm sounds on Android
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:383:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.daily
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._buildFrequencySection.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:403:27)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   CalendarService.syncHabitChanges (package:habitv8/services/calendar_service.dart:254:15)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 syncHabitChanges called for habit "test", isDeleted: false
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (15275): │ #1   CalendarService.syncHabitChanges (package:habitv8/services/calendar_service.dart:260:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 🐛 Calendar sync disabled, skipping habit sync for "test"
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:83:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Synced new habit "test" to calendar
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:867:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Analyzing habit for health mapping: "test" (category: Health)
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:870:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Search text: "test "
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:126:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Health permissions status: false
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Health permissions check result: false
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:882:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Skipping MINDFULNESS mapping - not supported by current health service
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to MEDICATION with score 0.8
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to WEIGHT with score 0.7
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to HEART_RATE with score 0.7
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to STEPS with score 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to SLEEP_IN_BED with score 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category "health" matched to WATER with score 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for MEDICATION: 0.8
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for WEIGHT: 0.7
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for HEART_RATE: 0.7
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for STEPS: 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for SLEEP_IN_BED: 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Category-only match for WATER: 0.6
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1038:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Best match for habit "test": MEDICATION (score: 0.8)
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1130:17)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Created health mapping for habit "test": MEDICATION, threshold: 1.0 (moderate)
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1492:23)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Automatic health mapping found for habit: test -> MEDICATION
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15275): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15275): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1531:19)
I/flutter (15275): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15275): │ 💡 Habit created: test
I/flutter (15275): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────