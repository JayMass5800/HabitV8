# Scheduling System Diagnosis Script
# This script will help diagnose why notifications and alarms aren't firing

Write-Host "`n=== HabitV8 Scheduling Diagnosis ===" -ForegroundColor Cyan
Write-Host "Checking notification and alarm scheduling system..." -ForegroundColor Yellow

# Check if adb is available
$adb = Get-Command adb -ErrorAction SilentlyContinue
if (-not $adb) {
    Write-Host "Error: adb not found. Please ensure Android SDK is in PATH" -ForegroundColor Red
    exit 1
}

# Check if device is connected
$devices = adb devices | Select-String "device$"
if ($devices.Count -eq 0) {
    Write-Host "Error: No Android device connected" -ForegroundColor Red
    exit 1
}

Write-Host "`n1. Checking app installation..." -ForegroundColor Green
$package = adb shell pm list packages | Select-String "com.habittracker.habitv8"
if ($package) {
    Write-Host "   ✓ App is installed" -ForegroundColor Green
} else {
    Write-Host "   ✗ App is not installed" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. Checking notification permissions..." -ForegroundColor Green
$notifPerm = adb shell dumpsys notification | Select-String "com.habittracker.habitv8" -Context 0,5
Write-Host $notifPerm

Write-Host "`n3. Checking scheduled alarms..." -ForegroundColor Green
$alarms = adb shell dumpsys alarm | Select-String "com.habittracker.habitv8" -Context 2,10
if ($alarms) {
    Write-Host "   ✓ Found scheduled alarms:" -ForegroundColor Green
    Write-Host $alarms
} else {
    Write-Host "   ✗ No scheduled alarms found!" -ForegroundColor Red
}

Write-Host "`n4. Checking exact alarm permission..." -ForegroundColor Green
$exactAlarm = adb shell dumpsys alarm | Select-String "SCHEDULE_EXACT_ALARM.*habitv8"
if ($exactAlarm) {
    Write-Host "   ✓ Exact alarm permission granted" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Exact alarm permission may not be granted" -ForegroundColor Yellow
}

Write-Host "`n5. Getting app logs (last 500 lines with scheduling keywords)..." -ForegroundColor Green
$logs = adb logcat -d -s flutter:I flutter:W flutter:E | Select-String "notification|alarm|schedule|RRule" -CaseSensitive:$false | Select-Object -Last 100
if ($logs) {
    Write-Host $logs
} else {
    Write-Host "   ⚠ No relevant logs found" -ForegroundColor Yellow
}

Write-Host "`n6. Checking timezone settings..." -ForegroundColor Green
$timezone = adb shell getprop persist.sys.timezone
Write-Host "   Device timezone: $timezone" -ForegroundColor Cyan

Write-Host "`n7. Checking battery optimization..." -ForegroundColor Green
$battery = adb shell dumpsys deviceidle | Select-String "com.habittracker.habitv8"
if ($battery) {
    Write-Host $battery
} else {
    Write-Host "   No battery optimization info found" -ForegroundColor Yellow
}

Write-Host "`n8. Checking if WorkManager tasks are registered..." -ForegroundColor Green
$workManager = adb shell dumpsys jobscheduler | Select-String "com.habittracker.habitv8" -Context 1,5
if ($workManager) {
    Write-Host "   ✓ WorkManager tasks found:" -ForegroundColor Green
    Write-Host $workManager
} else {
    Write-Host "   ⚠ No WorkManager tasks found" -ForegroundColor Yellow
}

Write-Host "`n=== Diagnosis Complete ===" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Check if notifications/alarms are showing in section 3" -ForegroundColor White
Write-Host "2. Review logs in section 5 for any errors" -ForegroundColor White
Write-Host "3. If no alarms found, check if scheduling code is being called" -ForegroundColor White
Write-Host "4. Verify timezone matches device timezone" -ForegroundColor White
