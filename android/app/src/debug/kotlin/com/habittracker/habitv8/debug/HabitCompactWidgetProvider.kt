package com.habittracker.habitv8.debug

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import com.habittracker.habitv8.HabitCompactWidgetProvider as MainHabitCompactWidgetProvider

class HabitCompactWidgetProvider : MainHabitCompactWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        android.util.Log.d("DebugHabitCompactWidget", "Debug wrapper onUpdate called with ${appWidgetIds.size} widgets")
        super.onUpdate(context, appWidgetManager, appWidgetIds, widgetData)
    }
}
