# Enhanced Flutter build script that ensures APKs are found in the correct location
param(
    [string]$BuildType = "debug",
    [switch]$Release
)

if ($Release) {
    $BuildType = "release"
}

Write-Host "🚀 Building Flutter app ($BuildType)..." -ForegroundColor Green

# Clean and build
Write-Host "Cleaning previous build..." -ForegroundColor Yellow
flutter clean

Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "Building APK ($BuildType)..." -ForegroundColor Yellow
if ($BuildType -eq "release") {
    flutter build apk --release
} else {
    flutter build apk --debug
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Build completed successfully!" -ForegroundColor Green

# Create junction link for Flutter compatibility
Write-Host "`n🔗 Creating APK junction link for Flutter compatibility..." -ForegroundColor Cyan

$oldBuildPath = "C:\HabitV8\build"
$newBuildPath = "C:\HabitV8\android\app\build"

# Remove existing junction if it exists
if (Test-Path $oldBuildPath) {
    if ((Get-Item $oldBuildPath).Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Removing existing junction link..." -ForegroundColor Yellow
        cmd /c rmdir "$oldBuildPath" 2>$null
    }
}

# Create junction link
if (Test-Path $newBuildPath) {
    $result = cmd /c mklink /J "$oldBuildPath" "$newBuildPath" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Junction link created successfully!" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Could not create junction link, but build was successful" -ForegroundColor Yellow
    }
}

# Show APK locations
Write-Host "`n📱 APK Files Created:" -ForegroundColor Cyan
$apkFiles = Get-ChildItem "C:\HabitV8\android\app\build\outputs" -Recurse -Name "*.apk" -ErrorAction SilentlyContinue
if ($apkFiles) {
    foreach ($apk in $apkFiles) {
        Write-Host "  - C:\HabitV8\android\app\build\outputs\$apk" -ForegroundColor Green
    }
} else {
    Write-Host "  - No APK files found" -ForegroundColor Red
}

Write-Host "`n🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "  - APKs are now available in the standard Flutter location" -ForegroundColor White
Write-Host "  - Flutter run should now find APKs correctly" -ForegroundColor White
Write-Host "  - Junction link ensures compatibility with Flutter's expectations" -ForegroundColor White