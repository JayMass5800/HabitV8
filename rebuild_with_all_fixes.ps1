# Script to clean and rebuild the app with all permission fixes

Write-Host "Cleaning the project..." -ForegroundColor Cyan
Set-Location "c:\HabitV8"
flutter clean

Write-Host "Removing build artifacts..." -ForegroundColor Cyan
if (Test-Path "c:\HabitV8\android\app\build") {
    Remove-Item -Recurse -Force "c:\HabitV8\android\app\build"
}
if (Test-Path "c:\HabitV8\android\.gradle") {
    Remove-Item -Recurse -Force "c:\HabitV8\android\.gradle"
}

Write-Host "Getting dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "Building the app with all permission fixes..." -ForegroundColor Cyan
flutter build apk --debug

Write-Host "Build completed. Check the APK for the fixed permissions." -ForegroundColor Green
Write-Host "APK location: c:\HabitV8\build\app\outputs\flutter-apk\app-debug.apk" -ForegroundColor Yellow

Write-Host "Summary of fixes:" -ForegroundColor Cyan
Write-Host "1. Fixed release AndroidManifest.xml - removed heart rate permission removal" -ForegroundColor Yellow
Write-Host "2. Added heart rate and background health data permissions to all manifests" -ForegroundColor Yellow
Write-Host "3. Updated MinimalHealthPlugin.kt to handle background health data access" -ForegroundColor Yellow
Write-Host "4. Updated health_service.dart to properly request all permissions" -ForegroundColor Yellow
Write-Host "5. Updated minimal_health_channel.dart to check background health data access" -ForegroundColor Yellow
Write-Host "6. Updated permission_service.dart to start background monitoring" -ForegroundColor Yellow

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Install the app on a device" -ForegroundColor Yellow
Write-Host "2. Use the debug info helper to check permission status" -ForegroundColor Yellow
Write-Host "3. Force request permissions if needed" -ForegroundColor Yellow
Write-Host "4. Check if heart rate and background health data permissions are granted" -ForegroundColor Yellow