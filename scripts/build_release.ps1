# HabitV8 Android Release Build Script
# This script builds a release APK and AAB for Google Play Store

Write-Host "🚀 Building HabitV8 for Android Release..." -ForegroundColor Green

# Check if key.properties exists
if (-not (Test-Path "android\key.properties")) {
    Write-Host "❌ Error: android\key.properties not found!" -ForegroundColor Red
    Write-Host "Please copy android\key.properties.template to android\key.properties and fill in your signing details." -ForegroundColor Yellow
    exit 1
}

# Clean previous builds
Write-Host "🧹 Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Generate code (for Hive adapters)
Write-Host "🔧 Generating code..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs

# Build AAB for Play Store
Write-Host "📱 Building Android App Bundle (AAB) for Play Store..." -ForegroundColor Yellow
flutter build appbundle --release

# Build APK for testing
Write-Host "📱 Building APK for testing..." -ForegroundColor Yellow
flutter build apk --release

Write-Host "✅ Build completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Files created:" -ForegroundColor Cyan
Write-Host "  - AAB (for Play Store): android\app\build\outputs\bundle\release\app-release.aab" -ForegroundColor White
Write-Host "  - APK (for testing): android\app\build\outputs\flutter-apk\app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Test the APK on a physical device" -ForegroundColor White
Write-Host "  2. Upload the AAB to Google Play Console" -ForegroundColor White
Write-Host "  3. Complete the Play Store listing" -ForegroundColor White