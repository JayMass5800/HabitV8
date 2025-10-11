# Notification Issue Diagnostic Script
# Checks all critical components for notification action handling

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Notification System Diagnostics" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$packageName = "com.habittracker.habitv8"

# Check if device is connected
Write-Host "1. Device Connection" -ForegroundColor Yellow
$devices = adb devices
if ($devices -match "device$") {
    Write-Host "   ✅ Device connected" -ForegroundColor Green
} else {
    Write-Host "   ❌ No device connected" -ForegroundColor Red
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "2. App Installation" -ForegroundColor Yellow
$appInstalled = adb shell pm list packages | Select-String $packageName
if ($appInstalled) {
    Write-Host "   ✅ App is installed" -ForegroundColor Green
    
    # Get app version
    $versionInfo = adb shell dumpsys package $packageName | Select-String "versionName"
    Write-Host "   📦 $versionInfo" -ForegroundColor Gray
} else {
    Write-Host "   ❌ App is not installed" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Notification Permissions" -ForegroundColor Yellow
$notifPermission = adb shell dumpsys notification | Select-String $packageName | Select-Object -First 1
if ($notifPermission) {
    Write-Host "   ✅ Notification permission granted" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Cannot verify notification permission" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "4. Battery Optimization Status" -ForegroundColor Yellow
$batteryWhitelist = adb shell dumpsys deviceidle whitelist | Select-String $packageName
if ($batteryWhitelist) {
    Write-Host "   ✅ App is whitelisted (battery optimization disabled)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  App may be battery optimized (could affect background execution)" -ForegroundColor Yellow
    Write-Host "   💡 Recommendation: Disable battery optimization for this app" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "5. Awesome Notifications Service" -ForegroundColor Yellow
$serviceInfo = adb shell dumpsys package $packageName | Select-String "ForegroundService"
if ($serviceInfo -match "awesome_notifications") {
    Write-Host "   ✅ Awesome Notifications service is declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ Awesome Notifications service NOT found in manifest" -ForegroundColor Red
    Write-Host "   💡 This is CRITICAL - notification actions won't work in terminated state" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "6. Notification Action Receiver" -ForegroundColor Yellow
$receiverInfo = adb shell dumpsys package $packageName | Select-String "NotificationActionReceiver"
if ($receiverInfo) {
    Write-Host "   ✅ Notification action receiver is declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ Notification action receiver NOT found" -ForegroundColor Red
}

Write-Host ""
Write-Host "7. Scheduled Notifications" -ForegroundColor Yellow
Write-Host "   Checking for active notifications..." -ForegroundColor Gray
$activeNotifs = adb shell dumpsys notification | Select-String $packageName | Measure-Object
if ($activeNotifs.Count -gt 0) {
    Write-Host "   ✅ Found $($activeNotifs.Count) notification entries" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  No active notifications found" -ForegroundColor Gray
}

Write-Host ""
Write-Host "8. App State" -ForegroundColor Yellow
$appProcess = adb shell ps | Select-String $packageName
if ($appProcess) {
    Write-Host "   ✅ App is currently running" -ForegroundColor Green
    Write-Host "   📱 Process: $appProcess" -ForegroundColor Gray
} else {
    Write-Host "   ℹ️  App is not running (terminated state)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DIAGNOSTIC SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Count issues
$criticalIssues = 0
$warnings = 0

if (-not $appInstalled) { $criticalIssues++ }
if (-not ($serviceInfo -match "awesome_notifications")) { $criticalIssues++ }
if (-not $receiverInfo) { $criticalIssues++ }
if (-not $batteryWhitelist) { $warnings++ }

if ($criticalIssues -eq 0 -and $warnings -eq 0) {
    Write-Host "✅ All checks passed! System is properly configured." -ForegroundColor Green
} elseif ($criticalIssues -eq 0) {
    Write-Host "⚠️  $warnings warning(s) found. System should work but may have issues." -ForegroundColor Yellow
} else {
    Write-Host "❌ $criticalIssues critical issue(s) found. Notification actions may not work." -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "QUICK ACTIONS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To test notification actions in terminated state:" -ForegroundColor White
Write-Host "  1. Run: .\test_notification_terminated.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "To view live logs:" -ForegroundColor White
Write-Host "  2. Run: adb logcat | Select-String 'HabitV8|NotificationAction'" -ForegroundColor Cyan
Write-Host ""
Write-Host "To force stop app (simulate terminated state):" -ForegroundColor White
Write-Host "  3. Run: adb shell am force-stop $packageName" -ForegroundColor Cyan
Write-Host ""
Write-Host "To disable battery optimization manually:" -ForegroundColor White
Write-Host "  4. Settings → Apps → HabitV8 → Battery → Unrestricted" -ForegroundColor Cyan
Write-Host ""