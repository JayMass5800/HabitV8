# Script to create a junction link for Flutter APK compatibility
# This ensures Flutter can find APKs in the location it expects

$oldBuildPath = "C:\HabitV8\build"
$newBuildPath = "C:\HabitV8\android\app\build"

Write-Host "🔗 Creating APK junction link for Flutter compatibility..." -ForegroundColor Cyan

# Remove existing junction if it exists
if (Test-Path $oldBuildPath) {
    if ((Get-Item $oldBuildPath).Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "Removing existing junction link..." -ForegroundColor Yellow
        cmd /c rmdir "$oldBuildPath"
    } else {
        Write-Host "⚠️  Warning: $oldBuildPath exists but is not a junction link" -ForegroundColor Yellow
        Write-Host "Please manually remove or rename this directory" -ForegroundColor Yellow
        exit 1
    }
}

# Create junction link if the target exists
if (Test-Path $newBuildPath) {
    Write-Host "Creating junction link from $oldBuildPath to $newBuildPath" -ForegroundColor Yellow
    
    # Create the junction link
    $result = cmd /c mklink /J "$oldBuildPath" "$newBuildPath" 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Junction link created successfully!" -ForegroundColor Green
        Write-Host "Flutter will now find APKs in the expected location" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to create junction link: $result" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "❌ Target build directory does not exist: $newBuildPath" -ForegroundColor Red
    Write-Host "Please run 'flutter build apk' first to create the build directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n📋 Summary:" -ForegroundColor Cyan
Write-Host "Junction link created: $oldBuildPath -> $newBuildPath" -ForegroundColor White
Write-Host "Flutter will now find APKs in both locations:" -ForegroundColor White
Write-Host "  - Standard location: $newBuildPath\outputs\flutter-apk\" -ForegroundColor Green
Write-Host "  - Flutter expected: $oldBuildPath\app\outputs\flutter-apk\" -ForegroundColor Green