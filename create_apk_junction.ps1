# Script to create a junction link for Flutter APK compatibility
# This ensures Flutter can find APKs in the location it expects

$flutterExpectedPath = "C:\HabitV8\build\app\outputs\flutter-apk"
$actualApkPath = "C:\HabitV8\android\app\build\outputs\flutter-apk"

Write-Host "🔗 Creating APK junction link for Flutter compatibility..." -ForegroundColor Cyan

# Remove existing junction if it exists
if (Test-Path $flutterExpectedPath) {
    if ((Get-Item $flutterExpectedPath).Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Removing existing junction link..." -ForegroundColor Yellow
        cmd /c rmdir "$flutterExpectedPath"
    } else {
        Write-Host "⚠️  Warning: $flutterExpectedPath exists but is not a junction link" -ForegroundColor Yellow
        Write-Host "Please manually remove or rename this directory" -ForegroundColor Yellow
        exit 1
    }
}

# Create parent directories if they don't exist
$parentDir = Split-Path $flutterExpectedPath -Parent
if (!(Test-Path $parentDir)) {
    Write-Host "Creating parent directories: $parentDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

# Create junction link if the target exists
if (Test-Path $actualApkPath) {
    Write-Host "Creating junction link from $flutterExpectedPath to $actualApkPath" -ForegroundColor Yellow
    
    # Create the junction link
    $result = cmd /c mklink /J "$flutterExpectedPath" "$actualApkPath" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Junction link created successfully!" -ForegroundColor Green
        Write-Host "Flutter will now find APKs in the expected location" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to create junction link: $result" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Target APK directory does not exist: $actualApkPath" -ForegroundColor Red
    Write-Host "Please run 'flutter build apk' first to create the APK directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n📋 Summary:" -ForegroundColor Cyan
Write-Host "Junction link created: $flutterExpectedPath -> $actualApkPath" -ForegroundColor White
Write-Host "Flutter will now find APKs in the expected location:" -ForegroundColor White
Write-Host "  - Actual location: $actualApkPath" -ForegroundColor Green
Write-Host "  - Flutter expected: $flutterExpectedPath" -ForegroundColor Green