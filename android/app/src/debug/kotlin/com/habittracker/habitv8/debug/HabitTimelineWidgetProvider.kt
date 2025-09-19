package com.habittracker.habitv8.debug

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import com.habittracker.habitv8.HabitTimelineWidgetProvider as MainHabitTimelineWidgetProvider

class HabitTimelineWidgetProvider : MainHabitTimelineWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds, widgetData)
    }
}
