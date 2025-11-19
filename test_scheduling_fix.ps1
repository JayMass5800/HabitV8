#!/usr/bin/env pwsh
# Quick test script to verify notification and alarm scheduling after fix

Write-Host "`n=== Notification & Alarm Scheduling Test ===" -ForegroundColor Cyan
Write-Host "Testing timezone fix implementation..." -ForegroundColor Yellow

# Check if device is connected
$devices = adb devices 2>$null | Select-String "device$"
if ($devices.Count -eq 0) {
    Write-Host "`n⚠️  No Android device connected. Please connect a device to test." -ForegroundColor Yellow
    Write-Host "`nManual Testing Steps:" -ForegroundColor Cyan
    Write-Host "1. Rebuild: flutter build apk --release" -ForegroundColor White
    Write-Host "2. Install: adb install -r build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor White
    Write-Host "3. Create notification habit with time 2-3 minutes from now" -ForegroundColor White
    Write-Host "4. Create alarm habit with time 2-3 minutes from now" -ForegroundColor White
    Write-Host "5. Wait and verify notifications/alarms fire" -ForegroundColor White
    exit 0
}

Write-Host "`n✓ Device connected" -ForegroundColor Green

# Check if app is installed
$package = adb shell pm list packages | Select-String "com.habittracker.habitv8"
if (-not $package) {
    Write-Host "⚠️  App not installed. Building and installing..." -ForegroundColor Yellow
    flutter build apk --release
    if ($LASTEXITCODE -eq 0) {
        adb install -r build/app/outputs/flutter-apk/app-release.apk
    } else {
        Write-Host "❌ Build failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✓ App is installed" -ForegroundColor Green
}

Write-Host "`n=== Test Instructions ===" -ForegroundColor Cyan
Write-Host "1. Open HabitV8 app on your device" -ForegroundColor White
Write-Host "2. Create a test notification habit:" -ForegroundColor White
Write-Host "   - Name: 'Test Notification'" -ForegroundColor Gray
Write-Host "   - Enable notifications" -ForegroundColor Gray
Write-Host "   - Set time to 2-3 minutes from now" -ForegroundColor Gray
Write-Host "3. Create a test alarm habit:" -ForegroundColor White
Write-Host "   - Name: 'Test Alarm'" -ForegroundColor Gray
Write-Host "   - Enable alarm" -ForegroundColor Gray
Write-Host "   - Set time to 2-3 minutes from now" -ForegroundColor Gray
Write-Host "4. Wait and verify both fire at scheduled time" -ForegroundColor White

Write-Host "`n=== Live Monitoring ===" -ForegroundColor Cyan
Write-Host "Monitoring app logs for scheduling activity..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop`n" -ForegroundColor Gray

# Monitor logs in real-time
adb logcat -c 2>$null # Clear logs
adb logcat -s flutter:I flutter:W flutter:E | Select-String "notification|alarm|schedule|Scheduled|✅|❌" -CaseSensitive:$false
