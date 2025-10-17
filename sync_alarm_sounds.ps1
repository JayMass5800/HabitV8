# Sync Alarm Sounds to Android Resources
# This script copies all alarm sound files from assets/sounds to android/app/src/main/res/raw
# with proper lowercase naming required by Android

Write-Host "🔊 Syncing alarm sounds to Android resources..." -ForegroundColor Cyan

# Define paths
$sourcePath = "c:\HabitV8\assets\sounds"
$destPath = "c:\HabitV8\android\app\src\main\res\raw"

# Create raw directory if it doesn't exist
if (-not (Test-Path $destPath)) {
    Write-Host "📁 Creating raw resources directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
}

# Get all MP3 files from source
$soundFiles = Get-ChildItem -Path $sourcePath -Filter "*.mp3"

Write-Host "📋 Found $($soundFiles.Count) sound files" -ForegroundColor Green

$copiedCount = 0
$skippedCount = 0

foreach ($file in $soundFiles) {
    # Convert filename to Android resource format:
    # - Lowercase
    # - Replace spaces and hyphens with underscores
    # - Remove special characters
    $androidName = $file.Name.ToLower()
    $androidName = $androidName -replace ' ', '_'
    $androidName = $androidName -replace '-', '_'
    $androidName = $androidName -replace '[^a-z0-9_\.]', ''
    
    $destFile = Join-Path $destPath $androidName
    
    try {
        # Copy file
        Copy-Item -Path $file.FullName -Destination $destFile -Force
        Write-Host "  ✅ $($file.Name) → $androidName" -ForegroundColor Gray
        $copiedCount++
    }
    catch {
        Write-Host "  ❌ Failed to copy $($file.Name): $_" -ForegroundColor Red
        $skippedCount++
    }
}

Write-Host ""
Write-Host "✨ Sync complete!" -ForegroundColor Green
Write-Host "   Copied: $copiedCount" -ForegroundColor Green
if ($skippedCount -gt 0) {
    Write-Host "   Skipped: $skippedCount" -ForegroundColor Yellow
}

# List all files in destination
Write-Host ""
Write-Host "📁 Files in android/app/src/main/res/raw/:" -ForegroundColor Cyan
Get-ChildItem $destPath -Filter "*.mp3" | ForEach-Object {
    Write-Host "   - $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Run 'flutter clean' to clear build cache" -ForegroundColor White
Write-Host "   2. Run 'flutter pub get' to update dependencies" -ForegroundColor White
Write-Host "   3. Build and test the app" -ForegroundColor White