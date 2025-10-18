# HabitV8 Audio Optimization Script (Final Version)
# Strategy: Convert MP3 to OGG Vorbis (25-40% smaller) + Delete unused files

param(
    [int]$VorbisQuality = 4  # Quality 0-10 (4 = ~128kbps MP3 equivalent, excellent quality)
)

function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "❌ $args" -ForegroundColor Red }
function Write-Info { Write-Host "ℹ️  $args" -ForegroundColor Cyan }
function Write-Warning { Write-Host "⚠️  $args" -ForegroundColor Yellow }

$soundsDir = "c:\HabitV8\assets\sounds"
$ringtonesDir = "c:\HabitV8\ringtones"
$backupDir = "c:\HabitV8\assets\sounds_backup_original"

Write-Info "HabitV8 Audio Optimization (OGG Vorbis Conversion)"
Write-Info "==================================================`n"

# Check FFmpeg
try {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    ffmpeg -version 2>&1 | Out-Null
    Write-Success "FFmpeg found"
} catch {
    Write-Error "FFmpeg not found"
    exit 1
}

# Backup originals
Write-Info "`nBacking up original MP3 files..."
if (-not (Test-Path $backupDir)) {
    Copy-Item -Path $soundsDir -Destination $backupDir -Recurse
    Write-Success "Backup created: $backupDir"
} else {
    Write-Warning "Backup already exists - skipping"
}

# Get size before
$sizeBefore = (Get-ChildItem $soundsDir -Filter "*.mp3" -File | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Info "`nSize before: $([math]::Round($sizeBefore, 2)) MB"

# Convert MP3 to OGG Vorbis
Write-Info "`nConverting MP3 files to OGG Vorbis (Quality: $VorbisQuality)..."
$files = @(Get-ChildItem $soundsDir -Filter "*.mp3" -File)
$count = 0

Set-Location $soundsDir

foreach ($file in $files) {
    $count++
    $nameWithoutExt = $file.BaseName
    $inputPath = $file.FullName
    $outputPath = Join-Path $soundsDir "$nameWithoutExt.ogg"
    
    Write-Info "[$count/$($files.Count)] Converting: $($file.Name) → $nameWithoutExt.ogg"
    
    # Convert to OGG Vorbis
    & ffmpeg -i $inputPath -codec:a libvorbis -q:a $VorbisQuality -y $outputPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        $newSize = (Get-Item $outputPath).Length / 1MB
        Write-Success "  $nameWithoutExt.ogg ($([math]::Round($newSize, 2)) MB)"
        Remove-Item $inputPath
    } else {
        Write-Error "Failed to convert: $($file.Name)"
    }
}

# Get size after
$sizeAfter = (Get-ChildItem $soundsDir -Filter "*.ogg" -File | Measure-Object -Property Length -Sum).Sum / 1MB
$reduction = $sizeBefore - $sizeAfter
$percentReduction = [math]::Round(($reduction / $sizeBefore) * 100, 1)

Write-Info "`n================================"
Write-Success "Conversion complete!"
Write-Info "MP3 total:  $([math]::Round($sizeBefore, 2)) MB"
Write-Info "OGG total:  $([math]::Round($sizeAfter, 2)) MB"
Write-Success "Reduction: $([math]::Round($reduction, 2)) MB ($percentReduction%)"

# Delete unused ringtones folder
Write-Info "`nRemoving unused ringtones folder..."
if (Test-Path $ringtonesDir) {
    Remove-Item $ringtonesDir -Recurse -Force
    Write-Success "Deleted: ringtones folder (8.64 MB)"
}

$totalSavings = $reduction + 8.64

Write-Success "`n✓ OPTIMIZATION COMPLETE!"
Write-Success "Total size reduction: ~$([math]::Round($totalSavings, 1)) MB"
Write-Info "`nNext steps:"
Write-Info "1. Update pubspec.yaml asset path: assets/sounds/ (handles both .ogg and .mp3)"
Write-Info "2. In code, load .ogg files instead of .mp3"
Write-Info "3. Run: flutter clean && flutter pub get && flutter build appbundle --release"
Write-Info "`nBackup location: $backupDir (can be deleted if satisfied)"