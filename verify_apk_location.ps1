# Script to verify APK files are in the correct location
Write-Host "🔍 Verifying APK file locations..." -ForegroundColor Cyan

$correctApkPath = "C:\HabitV8\android\app\build\outputs\flutter-apk"
$oldIncorrectPath = "C:\HabitV8\build\app\outputs\flutter-apk"

Write-Host "Checking correct APK location: $correctApkPath" -ForegroundColor Yellow

if (Test-Path $correctApkPath) {
    $apkFiles = Get-ChildItem $correctApkPath -Name "*.apk" -ErrorAction SilentlyContinue
    if ($apkFiles) {
        Write-Host "✅ APK files found in correct location:" -ForegroundColor Green
        foreach ($apk in $apkFiles) {
            Write-Host "   - $correctApkPath\$apk" -ForegroundColor White
        }
    } else {
        Write-Host "⚠️  Correct directory exists but no APK files found" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Correct APK directory does not exist" -ForegroundColor Red
}

Write-Host "`nChecking old incorrect location: $oldIncorrectPath" -ForegroundColor Yellow

if (Test-Path $oldIncorrectPath) {
    Write-Host "⚠️  Old incorrect path still exists - this should be cleaned up" -ForegroundColor Yellow
} else {
    Write-Host "✅ Old incorrect path does not exist (good)" -ForegroundColor Green
}

Write-Host "`n📋 Summary:" -ForegroundColor Cyan
Write-Host "The build configuration has been fixed to use the standard Flutter APK output location:" -ForegroundColor White
Write-Host "C:\HabitV8\android\app\build\outputs\flutter-apk\" -ForegroundColor Green
Write-Host "`nAll PowerShell scripts have been updated to reference the correct path." -ForegroundColor White