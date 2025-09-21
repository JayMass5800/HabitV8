09-20 16:02:28.571  1733  2340 I AppWidgetServiceImpl: Bound widget 83 to provider ProviderId{user:0, app:10549, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitCompactWidgetProvider}}
09-20 16:03:07.253  1733  6734 I AppWidgetServiceImpl: Bound widget 84 to provider ProviderId{user:0, app:10549, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitTimelineWidgetProvider}}
09-20 16:11:30.432  1733  5436 I AppWidgetServiceImpl: Bound widget 85 to provider ProviderId{user:0, app:10550, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitCompactWidgetProvider}}
09-20 16:11:30.453  1733  1889 I ActivityManager: Start proc 12913:com.habittracker.habitv8/u0a550 for broadcast {com.habittracker.habitv8/com.habittracker.habitv8.HabitCompactWidgetProvider}
09-20 16:12:17.026  1733  5448 I AppWidgetServiceImpl: Bound widget 86 to provider ProviderId{user:0, app:10550, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitCompactWidgetProvider}}
09-20 16:12:29.322  1733  2340 I AppWidgetServiceImpl: Bound widget 87 to provider ProviderId{user:0, app:10550, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitTimelineWidgetProvider}}
09-20 16:12:29.334 12913 12913 D HabitTimelineWidget: onUpdate called with 1 widget IDs
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget: Error updating widget 87
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.setupListView(Unknown Source:47)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onUpdate(Unknown Source:64)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onReceive(Unknown Source:10)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loop(Looper.java:349)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at java.lang.reflect.Method.invoke(Native Method)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:12:29.337 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:16:45.136  1733  1947 I AppWidgetServiceImpl: Bound widget 88 to provider ProviderId{user:0, app:10550, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitTimelineWidgetProvider}}
09-20 16:16:45.150 12913 12913 D HabitTimelineWidget: onUpdate called with 1 widget IDs
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget: Error updating widget 88
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.setupListView(Unknown Source:47)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onUpdate(Unknown Source:64)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onReceive(Unknown Source:10)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loop(Looper.java:349)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at java.lang.reflect.Method.invoke(Native Method)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:16:45.155 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:17:08.417  1733  4107 I AppWidgetServiceImpl: Bound widget 89 to provider ProviderId{user:0, app:10550, cmp:ComponentInfo{com.habittracker.habitv8/com.habittracker.habitv8.HabitCompactWidgetProvider}}
09-20 16:17:08.426 12913 12913 D HabitCompactWidget: onUpdate called with 1 widget IDs
09-20 16:17:08.427 12913 12913 E HabitCompactWidget: Error updating widget 89
09-20 16:17:08.427 12913 12913 E HabitCompactWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.setupListView(Unknown Source:41)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onUpdate(Unknown Source:74)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onReceive(Unknown Source:10)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.os.Looper.loop(Looper.java:349)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at java.lang.reflect.Method.invoke(Native Method)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:17:08.427 12913 12913 E HabitCompactWidget:    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:17:17.724 12913 12913 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
09-20 16:17:17.832 12913 12913 I flutter : Widget HabitTimelineWidgetProvider update completed
09-20 16:17:17.832 12913 12913 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
09-20 16:17:17.836 12913 12913 D HabitTimelineWidget: onUpdate called with 1 widget IDs
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget: Error updating widget 88
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.setupListView(Unknown Source:47)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onUpdate(Unknown Source:64)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onReceive(Unknown Source:10)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loop(Looper.java:349)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at java.lang.reflect.Method.invoke(Native Method)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:17:17.837 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:17:17.945 12913 12913 I flutter : Widget HabitCompactWidgetProvider update completed
09-20 16:17:17.946 12913 12913 D HabitCompactWidget: onUpdate called with 1 widget IDs
09-20 16:17:17.947 12913 12913 E HabitCompactWidget: Error updating widget 89
09-20 16:17:17.947 12913 12913 E HabitCompactWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.setupListView(Unknown Source:41)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onUpdate(Unknown Source:74)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onReceive(Unknown Source:10)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.os.Looper.loop(Looper.java:349)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at java.lang.reflect.Method.invoke(Native Method)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:17:17.947 12913 12913 E HabitCompactWidget:    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:17:18.496 12913 12913 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
09-20 16:17:18.605 12913 12913 I flutter : Widget HabitTimelineWidgetProvider update completed
09-20 16:17:18.605 12913 12913 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
09-20 16:17:18.606 12913 12913 D HabitTimelineWidget: onUpdate called with 1 widget IDs
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget: Error updating widget 88
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.setupListView(Unknown Source:47)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onUpdate(Unknown Source:64)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at com.habittracker.habitv8.HabitTimelineWidgetProvider.onReceive(Unknown Source:10)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.os.Looper.loop(Looper.java:349)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at java.lang.reflect.Method.invoke(Native Method)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:17:18.607 12913 12913 E HabitTimelineWidget:   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
09-20 16:17:18.712 12913 12913 I flutter : Widget HabitCompactWidgetProvider update completed
09-20 16:17:18.716 12913 12913 D HabitCompactWidget: onUpdate called with 1 widget IDs
09-20 16:17:18.716 12913 12913 E HabitCompactWidget: Error updating widget 89
09-20 16:17:18.716 12913 12913 E HabitCompactWidget: java.lang.ClassCastException: java.lang.Long cannot be cast to java.lang.Integer
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.app.SharedPreferencesImpl.getInt(SharedPreferencesImpl.java:329)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.setupListView(Unknown Source:41)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onUpdate(Unknown Source:74)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at es.antonborri.home_widget.HomeWidgetProvider.onUpdate(SourceFile:2)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.appwidget.AppWidgetProvider.onReceive(AppWidgetProvider.java:71)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at com.habittracker.habitv8.HabitCompactWidgetProvider.onReceive(Unknown Source:10)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.handleReceiver(ActivityThread.java:5090)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.-$$Nest$mhandleReceiver(Unknown Source:0)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2584)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.os.Handler.dispatchMessage(Handler.java:110)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.os.Looper.dispatchMessage(Looper.java:315)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.os.Looper.loopOnce(Looper.java:251)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.os.Looper.loop(Looper.java:349)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at android.app.ActivityThread.main(ActivityThread.java:9041)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at java.lang.reflect.Method.invoke(Native Method)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
09-20 16:17:18.716 12913 12913 E HabitCompactWidget:    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)