#!/usr/bin/env pwsh

# Fix for In-App Purchase Product Detection
Write-Host "🔧 Building AAB with In-App Purchase Fix..." -ForegroundColor Yellow

# Clean build
Write-Host "1. Cleaning previous builds..." -ForegroundColor Cyan
flutter clean
flutter pub get

# Build release AAB
Write-Host "2. Building release AAB..." -ForegroundColor Cyan
flutter build appbundle --release

# Check if build was successful
$aabPath = "build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $aabPath) {
    Write-Host "✅ AAB built successfully!" -ForegroundColor Green
    Write-Host "📁 Location: $aabPath" -ForegroundColor White
    
    Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Upload this AAB to Play Console Internal Testing" -ForegroundColor White
    Write-Host "2. Wait for processing (5-10 minutes)" -ForegroundColor White
    Write-Host "3. Create/verify product 'premium_lifetime_access'" -ForegroundColor White
    Write-Host "4. Test with a test account" -ForegroundColor White
} else {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}