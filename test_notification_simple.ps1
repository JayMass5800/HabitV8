# Simple Notification Test Script
# Tests notification action handling in terminated state

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Simple Notification Terminated Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check device
Write-Host "Checking device connection..." -ForegroundColor Yellow
$devices = adb devices
if ($devices -notmatch "device") {
    Write-Host "❌ No device connected!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Device connected" -ForegroundColor Green
$deviceModel = adb shell getprop ro.product.model
if ($deviceModel) {
    Write-Host "📱 Device: $deviceModel" -ForegroundColor Gray
}
Write-Host ""

# Check if app is installed
Write-Host "Checking if app is installed..." -ForegroundColor Yellow
$installed = adb shell pm list packages | Select-String "com.habittracker.habitv8"
if ($installed) {
    Write-Host "✅ App is installed" -ForegroundColor Green
} else {
    Write-Host "❌ App not installed. Run: flutter build apk --release" -ForegroundColor Red
    Write-Host "   Then: adb install build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Launch app
Write-Host "Launching app..." -ForegroundColor Yellow
adb shell am start -n com.habittracker.habitv8/.MainActivity
Start-Sleep -Seconds 3
Write-Host "✅ App launched" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MANUAL STEPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "On your device:" -ForegroundColor White
Write-Host "1. Create a habit with notification" -ForegroundColor White
Write-Host "2. Set time to 1-2 minutes from now" -ForegroundColor White
Write-Host "3. Wait for notification to appear" -ForegroundColor White
Write-Host ""
Write-Host "When notification appears:" -ForegroundColor Yellow
Write-Host "- DON'T tap it yet!" -ForegroundColor Red
Write-Host "- Come back here and press Enter" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter when notification is visible"

Write-Host ""
Write-Host "Force stopping app..." -ForegroundColor Yellow
adb shell am force-stop com.habittracker.habitv8
Start-Sleep -Seconds 2
Write-Host "✅ App terminated" -ForegroundColor Green
Write-Host ""

Write-Host "Clearing old logs..." -ForegroundColor Yellow
adb logcat -c
Start-Sleep -Seconds 1
Write-Host "✅ Logs cleared" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NOW TAP 'COMPLETE' BUTTON!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Monitoring logs for 30 seconds..." -ForegroundColor Yellow
Write-Host "Looking for:" -ForegroundColor White
Write-Host "  • BACKGROUND notification action received" -ForegroundColor Gray
Write-Host "  • Flutter binding initialized" -ForegroundColor Gray
Write-Host "  • Isar opened in background" -ForegroundColor Gray
Write-Host "  • Habit completed in background" -ForegroundColor Gray
Write-Host ""
Write-Host "Press Ctrl+C to stop early" -ForegroundColor Yellow
Write-Host ""

# Start monitoring with timeout
$job = Start-Job -ScriptBlock {
    adb logcat | Select-String "HabitV8|BACKGROUND|NotificationAction|Isar|awesome_notifications|Flutter binding"
}

# Wait for 30 seconds or until user presses Ctrl+C
$timeout = 30
$elapsed = 0
try {
    while ($elapsed -lt $timeout) {
        Start-Sleep -Seconds 1
        $elapsed++
        
        # Check if job has output
        $output = Receive-Job -Job $job
        if ($output) {
            Write-Host $output
        }
    }
} finally {
    Stop-Job -Job $job
    Remove-Job -Job $job
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Did you see these messages above?" -ForegroundColor White
Write-Host ""
Write-Host "✅ BACKGROUND notification action received" -ForegroundColor Gray
Write-Host "✅ Flutter binding initialized" -ForegroundColor Gray
Write-Host "✅ Isar opened in background isolate" -ForegroundColor Gray
Write-Host "✅ Habit completed in background" -ForegroundColor Gray
Write-Host ""
Write-Host "If YES to all:" -ForegroundColor Yellow
Write-Host "  🎉 The fix is WORKING!" -ForegroundColor Green
Write-Host ""
Write-Host "If NO:" -ForegroundColor Yellow
Write-Host "  Run: .\diagnose_notification_issue.ps1" -ForegroundColor White
Write-Host "  Check battery optimization settings" -ForegroundColor White
Write-Host "  Try: Settings → Apps → HabitV8 → Battery → Unrestricted" -ForegroundColor White
Write-Host ""

# Check if notification is still visible
Write-Host "Checking active notifications..." -ForegroundColor Yellow
$notifications = adb shell dumpsys notification | Select-String "com.habittracker.habitv8"
if ($notifications) {
    Write-Host "⚠️  Notification still visible (action may not have fired)" -ForegroundColor Yellow
} else {
    Write-Host "✅ Notification was dismissed (action likely fired)" -ForegroundColor Green
}
Write-Host ""

Write-Host "Test complete!" -ForegroundColor Cyan