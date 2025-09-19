09-19 15:34:03.824 32687 32687 D WM-WorkerWrapper: Starting work for com.coinbase.android.widget.work.WatchlistWidgetUpdateWorker
09-19 15:34:03.916 32687   358 I WM-WorkerWrapper: Worker result SUCCESS for Work [ id=3eeb5c46-dd64-4308-92e4-bd502cc81852, tags={ com.coinbase.android.widget.work.WatchlistWidgetUpdateWorker,watchlist_widget_periodic } ]
09-19 15:34:04.595  1733  2579 D AppWidgetServiceImpl: Trying to notify widget update for package com.coinbase.android with widget id: 6
09-19 15:34:04.883  1733  2579 D AppWidgetServiceImpl: Trying to notify widget update for package com.coinbase.android with widget id: 6
09-19 15:34:05.277  1733  2579 D AppWidgetServiceImpl: Trying to notify widget update for package com.coinbase.android with widget id: 6
09-19 15:34:22.693 24250 24250 I LauncherAppWidgetHostView: App widget created with id: 35
09-19 15:34:22.699 24250 24250 I LauncherAppWidgetHostView: App widget with id: 35 loaded
09-19 15:34:22.709 24250 24250 W AppWidgetHostView: Error inflating RemoteViews
09-19 15:34:22.709 24250 24250 W AppWidgetHostView: android.widget.RemoteViews$ActionException: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4207)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:22.709 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:22.709 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Class not allowed to be inflated android.view.View
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.failNotAllowed(LayoutInflater.java:786)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:729)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:665)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:802)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at com.android.internal.policy.PhoneLayoutInflater.onCreateView(PhoneLayoutInflater.java:68)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:819)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:839)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:893)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:850)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflate(LayoutInflater.java:1012)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflateChildren(LayoutInflater.java:973)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:571)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:462)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateViewInternal(RemoteViews.java:8209)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateView(RemoteViews.java:8170)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.-$$Nest$minflateView(Unknown Source:0)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8336)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4204)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:34:22.709 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:34:44.806  1733  2579 D AppWidgetServiceImpl: Trying to notify widget removed
09-19 15:34:46.919 24250 24250 D StatsLog: LAUNCHER_WIDGETSTRAY_BUTTON_TAP_OR_LONGPRESS
09-19 15:34:51.501 24250 24250 D StatsLog: LAUNCHER_WIDGETSTRAY_APP_EXPANDED
09-19 15:34:52.651  1733  3219 I AppWidgetServiceImpl: Bound widget 36 to provider ProviderId{user:0, app:10525, cmp:ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.debug.HabitCompactWidgetProvider}}
09-19 15:34:52.658 24250 24250 I LauncherAppWidgetHostView: App widget created with id: 36
09-19 15:34:52.665  9571  9571 D DebugHabitCompactWidget: Debug wrapper onUpdate called with 1 widgets
09-19 15:34:52.665  9571  9571 D HabitCompactWidget: onUpdate called with 1 widget IDs: [36]
09-19 15:34:52.668  9571  9571 D HabitCompactWidget: SharedPreferences keys: [nextHabit, habits, home_widget.double.nextHabit, home_widget.double.selectedDate, lastUpdate, home_widget.double.themeMode, home_widget.double.primaryColor, primaryColor, themeMode, home_widget.double.lastUpdate, selectedDate, home_widget.double.habits]
09-19 15:34:52.668  9571  9571 D HabitCompactWidget: Processing widget ID: 36
09-19 15:34:52.668  9571  9571 D HabitCompactWidget: Data map has 12 entries for widget 36
09-19 15:34:52.669  9571  9571 D HabitCompactWidget: Starting compact widget content update
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Widget data keys: [nextHabit, habits, home_widget.double.nextHabit, home_widget.double.selectedDate, lastUpdate, home_widget.double.themeMode, home_widget.double.primaryColor, primaryColor, themeMode, home_widget.double.lastUpdate, selectedDate, home_widget.double.habits]
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Habits JSON: [{"id":"1758321055804","name":"fghj","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"17:30","frequency":"HabitFrequency.daily"}]
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Theme mode: light
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Primary color: -14575885
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Habits array length: 1
09-19 15:34:52.672  9571  9571 D HabitCompactWidget: Updating habits list with 1 habits
09-19 15:34:52.673  9571  9571 D HabitCompactWidget: Processing 1 habits from array
09-19 15:34:52.673  9571  9571 D HabitCompactWidget: Found 1 due habits
09-19 15:34:52.673  9571  9571 D HabitCompactWidget: Adding compact habit: fghj
09-19 15:34:52.674  9571  9571 D HabitCompactWidget: updateCompactHabitsListFromArray completed successfully
09-19 15:34:52.676  9571  9571 D HabitCompactWidget: Calling appWidgetManager.updateAppWidget for ID: 36
09-19 15:34:52.681  1733  2579 D AppWidgetServiceImpl: Trying to notify widget update for package com.habittracker.habitv8.debug with widget id: 36
09-19 15:34:52.682  9571  9571 D HabitCompactWidget: Compact widget update completed for ID: 36
09-19 15:34:52.682 24250 24250 I LauncherAppWidgetHostView: App widget with id: 36 loaded
09-19 15:34:52.701 24250 24250 W AppWidgetHostView: Error inflating RemoteViews
09-19 15:34:52.701 24250 24250 W AppWidgetHostView: android.widget.RemoteViews$ActionException: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4207)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:52.701 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Error inflating class android.view.View
09-19 15:34:52.701 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #15 in com.habittracker.habitv8.debug:layout/widget_compact_habit_item: Class not allowed to be inflated android.view.View
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.failNotAllowed(LayoutInflater.java:786)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:729)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:665)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:802)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at com.android.internal.policy.PhoneLayoutInflater.onCreateView(PhoneLayoutInflater.java:68)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:819)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:839)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:893)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:850)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflate(LayoutInflater.java:1012)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflateChildren(LayoutInflater.java:973)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:571)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:462)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateViewInternal(RemoteViews.java:8209)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateView(RemoteViews.java:8170)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.-$$Nest$minflateView(Unknown Source:0)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8336)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4204)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:34:52.701 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:34:54.005 24250 24250 D CellLayout: Adding view to ShortcutsAndWidgetsContainer: com.android.launcher3.widget.LauncherAppWidgetHostView{a36024b VFE...... R.....ID 0,0-534,507 #d9}
09-19 15:34:54.008 24250 24250 D StateManager:  at com.android.launcher3.Launcher.lambda$addAppWidgetImpl$9(go/retraceme 936c194e190d468ad7948c6bfd99e50e644ffb8c9a8622547ab992d0c5c0590d:7)
09-19 15:34:54.681 24250 24250 D StatsLog: LAUNCHER_WIDGET_RESIZE_STARTED
09-19 15:34:55.199 24250 24250 D StatsLog: LAUNCHER_WIDGET_RESIZE_COMPLETED
09-19 15:34:57.587  1733  2579 D AppWidgetServiceImpl: Trying to notify widget removed
09-19 15:34:58.693 24250 24250 D StatsLog: LAUNCHER_WIDGETSTRAY_BUTTON_TAP_OR_LONGPRESS
09-19 15:35:00.022 24250 24250 D NexusLauncherModelDelegate: notifySmartspaceEvent: SmartspaceTargetEvent{mSmartspaceTarget=SmartspaceTarget{mSmartspaceTargetId='CALENDAR-1194112698', mHeaderAction=SmartspaceAction{mId='CALENDAR', mIcon=null, mTitle=, mSubtitle=, mContentDescription=, mPendingIntent=null, mIntent=Intent { act=android.intent.action.VIEW dat= }, mUserHandle=UserHandle{0}, mExtras=Bundle[mParcelledData.dataSize=1824]}, mBaseAction=SmartspaceAction{mId='', mIcon=null, mTitle=, mSubtitle=, mContentDescription=, mPendingIntent=null, mIntent=null, mUserHandle=UserHandle{0}, mExtras=Bundle[{feedback_intent=null, explanation_intent=Supplier{VAL_PARCELABLE@88+1464}, is_gaia_linked_data=true, settings_highlight_key=smartspace_pref_upcoming_key, acceptanceStatus=ATTENDEE_STATUS_ACCEPTED}]}, mCreationTimeMillis=1758319800000, mExpiryTimeMillis=1758321900000, mScore=0.0, mActionChips=[], mIconGrid=[], mFeatureType=2, mSensitive=true, mShouldShowExpanded=false, mSourceNotificationKey='', mComponentName=ComponentInfo{package_name/class_name}, mUserHandle=UserHandle{0}, mAssociatedSmartspaceTargetId='null', mSliceUri=null, mWidget=null, mTemplateData=BaseTemplateData{mTemplateType=1, mPrimaryItem=SubItemInfo{mText=Text{mText=drink water in 5 mins, mTruncateAtType=MIDDLE, mMaxLines=1}, mIcon=null, mTapAction=SmartspaceTapAction{mId=mIntent=Intent { act=android.intent.action.VIEW flg=0x18000000 cmp=com.google.android.googlequicksearchbox/com.google.android.apps.search.assistant.verticals.ambient.smartspace.trampolineactivity.ExportedSmartspaceTrampolineActivity (has extras) }, mPendingIntent=null, mUserHandle=null, mExtras=null, mShouldShowOnLockscreen=false}, mLoggingInfo=SubItemLoggingInfo{mInstanceId=7533, mFeatureType=2, mPackageName=}}, mSubtitleItem=SubItemInfo{mText=Text{mText=3:40 PM – 4:10 PM, mTruncateAtType=END, mMaxLines=1}, mIcon=SmartspaceIcon{mIcon=Icon(typ=BITMAP size=54x54), mContentDescription=Calendar events, mShouldTint=true}, mTapAction=SmartspaceTapAction{mId=mIntent=Intent { act=android.intent.action.VIEW flg=0x18000000 cmp=com.google.android.googlequicksearchbox/com.google.android.apps.search.assistant.verticals.ambient.smartspace.trampolineactivity.ExportedSmartspaceTrampolineActivity (has extras) }, mPendingIntent=null, mUserHandle=null, mExtras=null, mShouldShowOnLockscreen=false}, mLoggingInfo=null}, mSubtitleSupplementalItem=null, mSupplementalLineItem=null, mSupplementalAlarmItem=null, mLayoutWeight=1}, mRemoteViews=null}, mSmartspaceActionId='', mEventType=3}      
09-19 15:35:00.022 24250 24250 D NexusLauncherModelDelegate: notifySmartspaceEvent: SmartspaceTargetEvent{mSmartspaceTarget=SmartspaceTarget{mSmartspaceTargetId='CALENDAR-1194112698', mHeaderAction=SmartspaceAction{mId='CALENDAR', mIcon=null, mTitle=, mSubtitle=, mContentDescription=, mPendingIntent=null, mIntent=Intent { act=android.intent.action.VIEW dat= }, mUserHandle=UserHandle{0}, mExtras=Bundle[mParcelledData.dataSize=1824]}, mBaseAction=SmartspaceAction{mId='', mIcon=null, mTitle=, mSubtitle=, mContentDescription=, mPendingIntent=null, mIntent=null, mUserHandle=UserHandle{0}, mExtras=Bundle[{feedback_intent=null, explanation_intent=Supplier{VAL_PARCELABLE@88+1464}, is_gaia_linked_data=true, settings_highlight_key=smartspace_pref_upcoming_key, acceptanceStatus=ATTENDEE_STATUS_ACCEPTED}]}, mCreationTimeMillis=1758319800000, mExpiryTimeMillis=1758321900000, mScore=0.0, mActionChips=[], mIconGrid=[], mFeatureType=2, mSensitive=true, mShouldShowExpanded=false, mSourceNotificationKey='', mComponentName=ComponentInfo{package_name/class_name}, mUserHandle=UserHandle{0}, mAssociatedSmartspaceTargetId='null', mSliceUri=null, mWidget=null, mTemplateData=BaseTemplateData{mTemplateType=1, mPrimaryItem=SubItemInfo{mText=Text{mText=drink water in 5 mins, mTruncateAtType=MIDDLE, mMaxLines=1}, mIcon=null, mTapAction=SmartspaceTapAction{mId=mIntent=Intent { act=android.intent.action.VIEW flg=0x18000000 cmp=com.google.android.googlequicksearchbox/com.google.android.apps.search.assistant.verticals.ambient.smartspace.trampolineactivity.ExportedSmartspaceTrampolineActivity (has extras) }, mPendingIntent=null, mUserHandle=null, mExtras=null, mShouldShowOnLockscreen=false}, mLoggingInfo=SubItemLoggingInfo{mInstanceId=7533, mFeatureType=2, mPackageName=}}, mSubtitleItem=SubItemInfo{mText=Text{mText=3:40 PM – 4:10 PM, mTruncateAtType=END, mMaxLines=1}, mIcon=SmartspaceIcon{mIcon=Icon(typ=BITMAP size=54x54), mContentDescription=Calendar events, mShouldTint=true}, mTapAction=SmartspaceTapAction{mId=mIntent=Intent { act=android.intent.action.VIEW flg=0x18000000 cmp=com.google.android.googlequicksearchbox/com.google.android.apps.search.assistant.verticals.ambient.smartspace.trampolineactivity.ExportedSmartspaceTrampolineActivity (has extras) }, mPendingIntent=null, mUserHandle=null, mExtras=null, mShouldShowOnLockscreen=false}, mLoggingInfo=null}, mSubtitleSupplementalItem=null, mSupplementalLineItem=null, mSupplementalAlarmItem=null, mLayoutWeight=1}, mRemoteViews=null}, mSmartspaceActionId='', mEventType=2}      
09-19 15:35:03.131 24250 24250 D StatsLog: LAUNCHER_WIDGETSTRAY_APP_EXPANDED
09-19 15:35:05.262  1733  2967 I AppWidgetServiceImpl: Bound widget 37 to provider ProviderId{user:0, app:10525, cmp:ComponentInfo{com.habittracker.habitv8.debug/com.habittracker.habitv8.HabitTimelineWidgetProvider}}
09-19 15:35:05.271 24250 24250 I LauncherAppWidgetHostView: App widget created with id: 37
09-19 15:35:05.286  9571  9571 D HabitTimelineWidget: onUpdate called with 1 widget IDs: [37]
09-19 15:35:05.288  9571  9571 D HabitTimelineWidget: SharedPreferences keys: [nextHabit, habits, home_widget.double.nextHabit, home_widget.double.selectedDate, lastUpdate, home_widget.double.themeMode, home_widget.double.primaryColor, primaryColor, themeMode, home_widget.double.lastUpdate, selectedDate, home_widget.double.habits]
09-19 15:35:05.289  9571  9571 D HabitTimelineWidget: Processing widget ID: 37
09-19 15:35:05.290  9571  9571 D HabitTimelineWidget: Data map has 12 entries for widget 37
09-19 15:35:05.290  9571  9571 D HabitTimelineWidget: Starting widget content update
09-19 15:35:05.290  9571  9571 D HabitTimelineWidget: Widget data keys: [nextHabit, habits, home_widget.double.nextHabit, home_widget.double.selectedDate, lastUpdate, home_widget.double.themeMode, home_widget.double.primaryColor, primaryColor, themeMode, home_widget.double.lastUpdate, selectedDate, home_widget.double.habits]
09-19 15:35:05.290  9571  9571 D HabitTimelineWidget: Habits JSON: [{"id":"1758321055804","name":"fghj","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"17:30","frequency":"HabitFrequency.daily"}]
09-19 15:35:05.290  9571  9571 D HabitTimelineWidget: Selected date: 2025-09-19
09-19 15:35:05.291  9571  9571 D HabitTimelineWidget: Theme mode: light
09-19 15:35:05.291  9571  9571 D HabitTimelineWidget: Primary color: -14575885
09-19 15:35:05.307  9571  9571 D HabitTimelineWidget: Formatted date: Today, headerDateId: 2131231448
09-19 15:35:05.307  9571  9571 D HabitTimelineWidget: Applying theme colors
09-19 15:35:05.311  9571  9571 D HabitTimelineWidget: Habits array length: 1
09-19 15:35:05.311  9571  9571 D HabitTimelineWidget: Has next habit: true
09-19 15:35:05.311  9571  9571 D HabitTimelineWidget: Updating habits list with 1 habits
09-19 15:35:05.311  9571  9571 D HabitTimelineWidget: Processing 1 habits from array
09-19 15:35:05.313  9571  9571 D HabitTimelineWidget: Clearing existing habits from list ID: 2131231447
09-19 15:35:05.313  9571  9571 D HabitTimelineWidget: Showing next habit: fghj
09-19 15:35:05.315  9571  9571 D HabitTimelineWidget: Processing 1 habits
09-19 15:35:05.315  9571  9571 D HabitTimelineWidget: Adding 1 habit items to widget
09-19 15:35:05.315  9571  9571 D HabitTimelineWidget: Adding habit 0: fghj
09-19 15:35:05.320  9571  9571 D HabitTimelineWidget: updateHabitsListFromArray completed successfully
09-19 15:35:05.323  9571  9571 D HabitTimelineWidget: Calling appWidgetManager.updateAppWidget for ID: 37
09-19 15:35:05.328  1733  2579 D AppWidgetServiceImpl: Trying to notify widget update for package com.habittracker.habitv8.debug with widget id: 37
09-19 15:35:05.329  9571  9571 D HabitTimelineWidget: Widget update completed for ID: 37
09-19 15:35:05.333 24250 24250 I LauncherAppWidgetHostView: App widget with id: 37 loaded
09-19 15:35:05.342 24250 24250 W AppWidgetHostView: Error inflating RemoteViews
09-19 15:35:05.342 24250 24250 W AppWidgetHostView: android.widget.RemoteViews$ActionException: android.view.InflateException: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Error inflating class android.view.View
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4207)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Error inflating class android.view.View
09-19 15:35:05.342 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Error inflating class android.view.View
09-19 15:35:05.342 24250 24250 W AppWidgetHostView: Caused by: android.view.InflateException: Binary XML file line #17 in com.habittracker.habitv8.debug:layout/widget_habit_item: Class not allowed to be inflated android.view.View
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.failNotAllowed(LayoutInflater.java:786)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:729)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createView(LayoutInflater.java:665)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:802)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at com.android.internal.policy.PhoneLayoutInflater.onCreateView(PhoneLayoutInflater.java:68)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:819)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.onCreateView(LayoutInflater.java:839)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:893)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.createViewFromTag(LayoutInflater.java:850)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflate(LayoutInflater.java:1012)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.rInflateChildren(LayoutInflater.java:973)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:571)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.view.LayoutInflater.inflate(LayoutInflater.java:462)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateViewInternal(RemoteViews.java:8209)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.inflateView(RemoteViews.java:8170)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews.-$$Nest$minflateView(Unknown Source:0)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8336)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.insertNewView(RemoteViews.java:4204)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$ViewGroupActionAdd.initActionAsync(RemoteViews.java:4195)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8351)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.widget.RemoteViews$AsyncApplyTask.doInBackground(RemoteViews.java:8298)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at android.os.AsyncTask$3.call(AsyncTask.java:396)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.FutureTask.run(FutureTask.java:317)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
09-19 15:35:05.342 24250 24250 W AppWidgetHostView:     at java.lang.Thread.run(Thread.java:1119)
09-19 15:35:06.713 24250 24250 D CellLayout: Adding view to ShortcutsAndWidgetsContainer: com.android.launcher3.widget.LauncherAppWidgetHostView{1d46dd VFE...... R.....ID 0,0-724,774 #da}
09-19 15:35:06.716 24250 24250 D StateManager:  at com.android.launcher3.Launcher.lambda$addAppWidgetImpl$9(go/retraceme 936c194e190d468ad7948c6bfd99e50e644ffb8c9a8622547ab992d0c5c0590d:7)
09-19 15:35:07.387 24250 24250 D StatsLog: LAUNCHER_WIDGET_RESIZE_STARTED