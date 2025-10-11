# Rebuild and Install Script
# Builds release APK with all fixes and installs on connected device

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "REBUILD AND INSTALL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check device
Write-Host "1. Checking device connection..." -ForegroundColor Yellow
$devices = adb devices
if ($devices -notmatch "device") {
    Write-Host "   ❌ No device connected!" -ForegroundColor Red
    exit 1
}
Write-Host "   ✅ Device connected" -ForegroundColor Green

$deviceModel = adb shell getprop ro.product.model
if ($deviceModel) {
    Write-Host "   📱 Device: $deviceModel" -ForegroundColor Gray
}

# Clean
Write-Host ""
Write-Host "2. Cleaning previous build..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "   ✅ Clean complete" -ForegroundColor Green

# Build
Write-Host ""
Write-Host "3. Building release APK..." -ForegroundColor Yellow
Write-Host "   This will take 2-3 minutes..." -ForegroundColor Gray
Write-Host "   ⚠️  This build includes the critical AndroidManifest.xml fixes!" -ForegroundColor Yellow
Write-Host ""

$buildOutput = flutter build apk --release 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

if ($buildSuccess) {
    Write-Host "   ✅ Build successful!" -ForegroundColor Green
    
    # Check if APK exists
    if (Test-Path "build\app\outputs\flutter-apk\app-release.apk") {
        $apkSize = (Get-Item "build\app\outputs\flutter-apk\app-release.apk").Length / 1MB
        Write-Host "   📦 APK size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Gray
    }
} else {
    Write-Host "   ❌ Build failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error output:" -ForegroundColor Yellow
    Write-Host $buildOutput
    exit 1
}

# Install
Write-Host ""
Write-Host "4. Installing on device..." -ForegroundColor Yellow
Write-Host "   This will replace the old version..." -ForegroundColor Gray

$installOutput = adb install -r build\app\outputs\flutter-apk\app-release.apk 2>&1
$installSuccess = $LASTEXITCODE -eq 0

if ($installSuccess) {
    Write-Host "   ✅ Installation successful!" -ForegroundColor Green
} else {
    Write-Host "   ❌ Installation failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error output:" -ForegroundColor Yellow
    Write-Host $installOutput
    exit 1
}

# Verify service declarations
Write-Host ""
Write-Host "5. Verifying service declarations..." -ForegroundColor Yellow

$foregroundService = adb shell dumpsys package com.habittracker.habitv8 | Select-String "ForegroundService"
if ($foregroundService) {
    Write-Host "   ✅ ForegroundService declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ ForegroundService NOT found!" -ForegroundColor Red
}

$actionReceiver = adb shell dumpsys package com.habittracker.habitv8 | Select-String "NotificationActionReceiver"
if ($actionReceiver) {
    Write-Host "   ✅ NotificationActionReceiver declared" -ForegroundColor Green
} else {
    Write-Host "   ❌ NotificationActionReceiver NOT found!" -ForegroundColor Red
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INSTALLATION COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($foregroundService -and $actionReceiver) {
    Write-Host "🎉 All critical services are now declared!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor White
    Write-Host "1. Run diagnostic: .\full_diagnostic.ps1" -ForegroundColor Cyan
    Write-Host "2. Run test: .\test_notification_simple.ps1" -ForegroundColor Cyan
} else {
    Write-Host "⚠️  Service declarations not detected!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This could mean:" -ForegroundColor White
    Write-Host "- The app needs to be launched once" -ForegroundColor Gray
    Write-Host "- ADB cache needs to refresh" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Try:" -ForegroundColor White
    Write-Host "1. Launch the app manually" -ForegroundColor Gray
    Write-Host "2. Run diagnostic again: .\full_diagnostic.ps1" -ForegroundColor Gray
}

Write-Host ""