# Script to clean and rebuild the app with the new permissions

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

Write-Host "Building the app with new permissions..." -ForegroundColor Cyan
flutter build apk --release

Write-Host "Build completed. Check the APK for the new permissions." -ForegroundColor Green
Write-Host "APK location: C:\HabitV8\android\app\build\outputs\flutter-apk\app-release.apk" -ForegroundColor Yellow