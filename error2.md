
1) HabitCompactWidgetProvider (main)
Path: c:\HabitV8\android\app\src\main\kotlin\com\habittracker\habitv8\HabitCompactWidgetProvider.kt

Empty-state crash risk: You call removeAllViews(compact_habits_list) before you know if there are any due habits. If there are none, compact_empty_state (which is a child of compact_habits_list) has already been removed, and calling setViewVisibility/setTextViewText on it can throw and prevent rendering.
Default color alpha: primaryColor default 0x6366F1 has no alpha (AA=0x00), resulting in invisible colors for backgrounds (e.g., color indicator). Use an ARGB value with 0xFF alpha.
Recommended fix:

// In updateCompactHabitsList(...)

val habitsArray = JSONArray(habitsJson)

// DO NOT clear children yet
val habitsListId = getResourceId(context, "compact_habits_list", "id")

// Filter first
val dueHabits = mutableListOf<JSONObject>()
for (i in 0 until habitsArray.length()) {
    val habit = habitsArray.getJSONObject(i)
    val status = habit.optString("status", "Due")
    val isCompleted = habit.optBoolean("isCompleted", false)
    if (status == "Due" && !isCompleted) {
        dueHabits.add(habit)
        if (dueHabits.size >= 3) break
    }
}

if (dueHabits.isEmpty()) {
    // Keep the empty-state view intact
    showCompactEmptyState(context, views)
} else {
    val emptyStateId = getResourceId(context, "compact_empty_state", "id")
    views.setViewVisibility(emptyStateId, View.GONE)

    // Now clear and add items
    views.removeAllViews(habitsListId)
    dueHabits.forEach { habit ->
        addCompactHabitItem(context, views, habit, themeMode, primaryColor)
    }

    // More habits indicator unchanged...
}
And for the color default:

// In updateCompactWidgetContent(...)
val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0xFF6366F1.toInt()
2) HabitTimelineWidgetProvider (main)
Path: c:\HabitV8\android\app\src\main\kotlin\com\habittracker\habitv8\HabitTimelineWidgetProvider.kt

Missing ID mappings cause error paths to fail:
showErrorState() calls getResourceId("header_title", "id"), but getResourceId() doesn’t map "header_title", so it returns 0. Using id 0 in setTextViewText throws.
setupClickHandlers() uses getResourceId("refresh_button", "id"), but "refresh_button" isn’t mapped either, so refresh click won’t be attached.
Add missing mappings:

// In getResourceId(...), resourceType == "id"
"header_title" -> R.id.header_title,
"refresh_button" -> R.id.refresh_button,
"timeline_icon" -> R.id.timeline_icon,
"habits_container" -> R.id.habits_container,
"add_habit_button" -> R.id.add_habit_button,
Default color alpha: Same issue as above. Use ARGB:
// In updateWidgetContent(...)
val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0xFF6366F1.toInt()
3) Debug providers (FYI)
Paths:

c:\HabitV8\android\app\src\debug\kotlin\com\habittracker\habitv8\debug\HabitCompactWidgetProvider.kt

c:\HabitV8\android\app\src\debug\kotlin\com\habittracker\habitv8\debug\HabitTimelineWidgetProvider.kt

No fatal errors found, but:

Debug Compact sets a click intent on android.R.id.background, which doesn’t exist in the widget layouts. It’s in a try/catch, so it’s just a no-op; consider targeting a real root view if you want a background click.
primaryColor handling differs: debug expects a hex string and parses it; main expects Int. Not a crash (main uses safe cast), but theming will be inconsistent. Consider standardizing.
Layouts and manifest
Layout IDs and structures look consistent with code.
Widget provider entries in manifests (debug/main) are correct.