# Notification Terminated State Testing Script
# This script helps test notification action handling when app is terminated

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Notification Terminated State Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if device is connected
Write-Host "1. Checking for connected devices..." -ForegroundColor Yellow
$devices = adb devices
if ($devices -match "device$") {
    Write-Host "✅ Device connected" -ForegroundColor Green
} else {
    Write-Host "❌ No device connected. Please connect a device and try again." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Building release APK..." -ForegroundColor Yellow
Write-Host "   This may take a few minutes..." -ForegroundColor Gray

# Clean and build
flutter clean | Out-Null
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful" -ForegroundColor Green
} else {
    Write-Host "❌ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Installing APK on device..." -ForegroundColor Yellow
adb install -r build\app\outputs\flutter-apk\app-release.apk

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Installation successful" -ForegroundColor Green
} else {
    Write-Host "❌ Installation failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "4. Launching app..." -ForegroundColor Yellow
adb shell am start -n com.habittracker.habitv8/.MainActivity
Start-Sleep -Seconds 2
Write-Host "✅ App launched" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MANUAL TESTING STEPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please perform the following steps on your device:" -ForegroundColor White
Write-Host ""
Write-Host "1. Create a test habit with notification enabled" -ForegroundColor White
Write-Host "2. Set notification time to 1-2 minutes from now" -ForegroundColor White
Write-Host "3. Wait for notification to appear" -ForegroundColor White
Write-Host ""
Write-Host "4. Press Enter when notification appears (DON'T tap it yet!)..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Host "5. Force stopping app to simulate terminated state..." -ForegroundColor Yellow
adb shell am force-stop com.habittracker.habitv8
Start-Sleep -Seconds 1
Write-Host "✅ App force stopped (terminated state)" -ForegroundColor Green
Write-Host "   Note: Notification should still be visible!" -ForegroundColor Gray

Write-Host ""
Write-Host "6. Starting log monitoring..." -ForegroundColor Yellow
Write-Host "   Watching for background notification handler..." -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NOW TAP THE 'COMPLETE' BUTTON!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Looking for these success indicators:" -ForegroundColor White
Write-Host "  ✅ BACKGROUND notification action received" -ForegroundColor Gray
Write-Host "  ✅ Flutter binding initialized" -ForegroundColor Gray
Write-Host "  ✅ Isar opened in background isolate" -ForegroundColor Gray
Write-Host "  ✅ Habit completed in background" -ForegroundColor Gray
Write-Host ""
Write-Host "Press Ctrl+C to stop monitoring" -ForegroundColor Yellow
Write-Host ""

# Monitor logs for notification action
adb logcat -c  # Clear logs
adb logcat | Select-String "HabitV8|NotificationAction|Isar|BACKGROUND|Flutter binding|awesome_notifications"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "VERIFICATION CHECKLIST" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Did you see these log messages?" -ForegroundColor White
Write-Host "  ✓ 'BACKGROUND notification action received (Isar)'" -ForegroundColor Gray
Write-Host "  ✓ 'Flutter binding initialized in background isolate'" -ForegroundColor Gray
Write-Host "  ✓ 'Isar opened in background isolate'" -ForegroundColor Gray
Write-Host "  ✓ 'Found habit in background'" -ForegroundColor Gray
Write-Host "  ✓ 'Habit completed in background'" -ForegroundColor Gray
Write-Host ""
Write-Host "If you saw all these messages, the fix is working! ✅" -ForegroundColor Green
Write-Host "If you didn't see these messages, check FIXES_APPLIED.md troubleshooting section" -ForegroundColor Yellow
Write-Host ""