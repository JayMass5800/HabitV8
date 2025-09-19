package com.habittracker.habitv8.debug

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import com.habittracker.habitv8.HabitCompactWidgetProvider as MainHabitCompactWidgetProvider

/**
 * Debug wrapper for HabitCompactWidgetProvider
 * This class delegates all calls to the main implementation in the base package
 */
class HabitCompactWidgetProvider : MainHabitCompactWidgetProvider() {
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // Delegate to parent implementation
        super.onUpdate(context, appWidgetManager, appWidgetIds, widgetData)
    }
}