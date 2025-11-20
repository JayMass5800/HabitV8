#!/usr/bin/env pwsh
# Live log monitoring for HabitV8 app
# Shows real-time logs with scheduling-related keywords highlighted

Write-Host "`n=== HabitV8 Live Log Monitor ===" -ForegroundColor Cyan
Write-Host "Monitoring logs for scheduling activity..." -ForegroundColor Yellow
Write-Host "Keywords: notification, alarm, schedule, RRule, Scheduling, occurrence, dtStart" -ForegroundColor Gray
Write-Host "Press Ctrl+C to stop`n" -ForegroundColor Gray

# Clear old logs first
adb logcat -c 2>$null

# Monitor live logs with filtering
adb logcat -v time flutter:I flutter:W flutter:E AndroidRuntime:E *:S | Where-Object {
    $_ -match "notification|alarm|schedule|RRule|Scheduling|occurrence|dtStart|✅|❌|🔔|⚠️|habit.*added|habit.*created" -or
    $_ -match "Fatal|FATAL|Error|ERROR" -or
    $_ -match "awesome_notifications|AwesomeNotifications"
}
