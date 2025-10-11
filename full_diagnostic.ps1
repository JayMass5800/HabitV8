# Comprehensive Notification Diagnostic Script
# Checks EVERYTHING related to notification action handling

$ErrorActionPreference = "SilentlyContinue"
$packageName = "com.habittracker.habitv8"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "COMPREHENSIVE NOTIFICATION DIAGNOSTICS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Device Connection
Write-Host "1. Device Connection" -ForegroundColor Yellow
$devices = adb devices
if ($devices -match "device") {
    Write-Host "   ✅ Device connected" -ForegroundColor Green
    # Extract device model
    $deviceModel = adb shell getprop ro.product.model
    if ($deviceModel) {
        Write-Host "   📱 Device: $deviceModel" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ No device connected" -ForegroundColor Red
    Write-Host "   Run: adb devices" -ForegroundColor Yellow
    exit 1
}

# 2. App Installation
Write-Host ""
Write-Host "2. App Installation" -ForegroundColor Yellow
$appInstalled = adb shell pm list packages | Select-String $packageName
if ($appInstalled) {
    Write-Host "   ✅ App is installed" -ForegroundColor Green
} else {
    Write-Host "   ❌ App NOT installed" -ForegroundColor Red
    Write-Host "   Run: flutter build apk --release" -ForegroundColor Yellow
    Write-Host "   Then: adb install build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Yellow
    exit 1
}

# 3. Check if it's a release build
Write-Host ""
Write-Host "3. Build Type Check" -ForegroundColor Yellow
$debugInstalled = adb shell pm list packages | Select-String "com.habittracker.habitv8.debug"
if ($debugInstalled) {
    Write-Host "   ⚠️  DEBUG build detected" -ForegroundColor Yellow
    Write-Host "   Tree-shaking only happens in RELEASE builds!" -ForegroundColor Red
    Write-Host "   Build release: flutter build apk --release" -ForegroundColor Yellow
} else {
    Write-Host "   ✅ Release build (correct for testing)" -ForegroundColor Green
}

# 4. Service Declarations
Write-Host ""
Write-Host "4. Critical Service Declarations" -ForegroundColor Yellow
$services = adb shell dumpsys package $packageName | Select-String "Service|Receiver"

$foregroundService = $services | Select-String "ForegroundService"
if ($foregroundService) {
    Write-Host "   ✅ ForegroundService declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ ForegroundService MISSING (CRITICAL!)" -ForegroundColor Red
    Write-Host "   Check AndroidManifest.xml" -ForegroundColor Yellow
}

$actionReceiver = $services | Select-String "NotificationActionReceiver"
if ($actionReceiver) {
    Write-Host "   ✅ NotificationActionReceiver declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ NotificationActionReceiver MISSING (CRITICAL!)" -ForegroundColor Red
    Write-Host "   Check AndroidManifest.xml" -ForegroundColor Yellow
}

# 5. Notification Permissions
Write-Host ""
Write-Host "5. Notification Permissions" -ForegroundColor Yellow
$notifEnabled = adb shell cmd notification allowed_listeners | Select-String $packageName
if ($notifEnabled) {
    Write-Host "   ✅ Notification permission granted" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Check notification permission manually" -ForegroundColor Yellow
    Write-Host "   Settings → Apps → HabitV8 → Notifications" -ForegroundColor Gray
}

# 6. Battery Optimization
Write-Host ""
Write-Host "6. Battery Optimization" -ForegroundColor Yellow
$batteryWhitelist = adb shell dumpsys deviceidle whitelist | Select-String $packageName
if ($batteryWhitelist) {
    Write-Host "   ✅ Battery optimization DISABLED (good!)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Battery optimization may be ENABLED" -ForegroundColor Yellow
    Write-Host "   This can prevent background execution!" -ForegroundColor Red
    Write-Host "   Fix: Settings → Apps → HabitV8 → Battery → Unrestricted" -ForegroundColor Yellow
}

# 7. Active Notifications
Write-Host ""
Write-Host "7. Active Notifications" -ForegroundColor Yellow
$activeNotifs = adb shell dumpsys notification | Select-String $packageName
if ($activeNotifs) {
    Write-Host "   ✅ App has active notifications" -ForegroundColor Green
    $count = ($activeNotifs | Measure-Object).Count
    Write-Host "   📊 Found $count notification-related entries" -ForegroundColor Gray
} else {
    Write-Host "   ℹ️  No active notifications" -ForegroundColor Gray
}

# 8. App State
Write-Host ""
Write-Host "8. App State" -ForegroundColor Yellow
$appRunning = adb shell ps | Select-String $packageName
if ($appRunning) {
    Write-Host "   ✅ App is RUNNING" -ForegroundColor Green
    Write-Host "   For terminated state test, run:" -ForegroundColor Yellow
    Write-Host "   adb shell am force-stop $packageName" -ForegroundColor Gray
} else {
    Write-Host "   ℹ️  App is TERMINATED (good for testing)" -ForegroundColor Gray
}

# 9. Recent Logs Check
Write-Host ""
Write-Host "9. Recent Notification Logs" -ForegroundColor Yellow
Write-Host "   Checking last 100 lines for notification activity..." -ForegroundColor Gray
$recentLogs = adb logcat -d -t 100 | Select-String "HabitV8|BACKGROUND|NotificationAction|awesome_notifications"
if ($recentLogs) {
    Write-Host "   ✅ Found recent notification logs:" -ForegroundColor Green
    $recentLogs | Select-Object -First 5 | ForEach-Object {
        Write-Host "      $_" -ForegroundColor Gray
    }
} else {
    Write-Host "   ℹ️  No recent notification logs" -ForegroundColor Gray
}

# 10. Exact Alarm Permission (Android 12+)
Write-Host ""
Write-Host "10. Exact Alarm Permission (Android 12+)" -ForegroundColor Yellow
$alarmPermission = adb shell dumpsys alarm | Select-String $packageName
if ($alarmPermission) {
    Write-Host "   ✅ App can schedule exact alarms" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Cannot verify exact alarm permission" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$criticalIssues = 0
$warnings = 0

if (-not $foregroundService) {
    $criticalIssues++
    Write-Host "❌ CRITICAL: ForegroundService not declared" -ForegroundColor Red
}

if (-not $actionReceiver) {
    $criticalIssues++
    Write-Host "❌ CRITICAL: NotificationActionReceiver not declared" -ForegroundColor Red
}

if ($debugInstalled) {
    $criticalIssues++
    Write-Host "❌ CRITICAL: Using DEBUG build (need RELEASE)" -ForegroundColor Red
}

if (-not $batteryWhitelist) {
    $warnings++
    Write-Host "⚠️  WARNING: Battery optimization may be enabled" -ForegroundColor Yellow
}

if ($criticalIssues -eq 0 -and $warnings -eq 0) {
    Write-Host "🎉 All checks passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ready to test! Run:" -ForegroundColor White
    Write-Host "  .\test_notification_simple.ps1" -ForegroundColor Cyan
} elseif ($criticalIssues -eq 0) {
    Write-Host "✅ No critical issues found" -ForegroundColor Green
    Write-Host "⚠️  $warnings warning(s) - may affect reliability" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "You can test, but address warnings for best results" -ForegroundColor White
} else {
    Write-Host "❌ $criticalIssues critical issue(s) found" -ForegroundColor Red
    Write-Host "⚠️  $warnings warning(s)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Fix critical issues before testing!" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "QUICK ACTIONS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Build release APK:" -ForegroundColor White
Write-Host "  flutter clean; flutter build apk --release" -ForegroundColor Gray
Write-Host ""
Write-Host "Install release APK:" -ForegroundColor White
Write-Host "  adb install build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Gray
Write-Host ""
Write-Host "Disable battery optimization:" -ForegroundColor White
Write-Host "  Settings → Apps → HabitV8 → Battery → Unrestricted" -ForegroundColor Gray
Write-Host ""
Write-Host "Force stop app:" -ForegroundColor White
Write-Host "  adb shell am force-stop $packageName" -ForegroundColor Gray
Write-Host ""
Write-Host "Monitor logs:" -ForegroundColor White
Write-Host "  adb logcat | Select-String 'HabitV8|BACKGROUND'" -ForegroundColor Gray
Write-Host ""