package com.example.habitv8

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class TestWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val layoutId = context.resources.getIdentifier("widget_compact", "layout", context.packageName)
                if (layoutId != 0) {
                    val views = RemoteViews(context.packageName, layoutId)
                    
                    // Set a simple static message
                    val emptyStateId = context.resources.getIdentifier("compact_empty_state", "id", context.packageName)
                    if (emptyStateId != 0) {
                        views.setViewVisibility(emptyStateId, android.view.View.VISIBLE)
                        views.setTextViewText(emptyStateId, "Test Widget Working!")
                    }
                    
                    appWidgetManager.updateAppWidget(widgetId, views)
                }
            } catch (e: Exception) {
                // Create even simpler fallback
            }
        }
    }
}