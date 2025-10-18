# HabitV8 Audio Reencoding Script
# Re-encodes all MP3 files to 128kbps for reduced app size
# Requires: FFmpeg (install via: choco install ffmpeg -y)

param(
    [switch]$DeleteUnused = $true,
    [int]$Bitrate = 128  # kbps
)

# Colors for output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host "❌ $args" -ForegroundColor Red }
function Write-Info { Write-Host "ℹ️  $args" -ForegroundColor Cyan }
function Write-Warning { Write-Host "⚠️  $args" -ForegroundColor Yellow }

$soundsDir = "c:\HabitV8\assets\sounds"
$ringtonesDir = "c:\HabitV8\ringtones"
$backupDir = "c:\HabitV8\assets\sounds_backup"

Write-Info "HabitV8 Audio Reencoding Tool"
Write-Info "==============================="

# Check FFmpeg
Write-Info "Checking for FFmpeg..."
try {
    ffmpeg -version 2>&1 | Out-Null
    Write-Success "✓ FFmpeg found"
} catch {
    Write-Error "FFmpeg not found. Install with: choco install ffmpeg -y (requires admin)"
    exit 1
}

# Create backup
Write-Info "Creating backup of original audio files..."
if (Test-Path $backupDir) {
    Write-Warning "Backup directory already exists. Skipping backup."
} else {
    Copy-Item -Path $soundsDir -Destination $backupDir -Recurse
    Write-Success "✓ Backup created at: $backupDir"
}

# Get file sizes before
$sizeBefore = (Get-ChildItem $soundsDir -File | Measure-Object -Property Length -Sum).Sum / 1MB

Write-Info "`nSize before: $([math]::Round($sizeBefore, 2)) MB"
Write-Info "Re-encoding all MP3 files to ${Bitrate}kbps..."

$files = @(Get-ChildItem $soundsDir -Filter "*.mp3" -File)
$count = 0

foreach ($file in $files) {
    $count++
    $filename = $file.Name
    $inputPath = $file.FullName
    $tempPath = "$($inputPath).tmp"
    
    Write-Info "[$count/$($files.Count)] Encoding: $filename"
    
    # FFmpeg command: re-encode to 128kbps MP3
    & ffmpeg -i $inputPath -codec:a libmp3lame -b:a "${Bitrate}k" -y $tempPath 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Remove-Item $inputPath
        Rename-Item $tempPath $inputPath
        $newSize = (Get-Item $inputPath).Length / 1MB
        Write-Success "  ✓ $filename ($([math]::Round($newSize, 2)) MB)"
    } else {
        Write-Error "Failed to encode: $filename"
        Remove-Item $tempPath -ErrorAction SilentlyContinue
    }
}

# Get file sizes after
$sizeAfter = (Get-ChildItem $soundsDir -File | Measure-Object -Property Length -Sum).Sum / 1MB
$reduction = $sizeBefore - $sizeAfter
$percentReduction = [math]::Round(($reduction / $sizeBefore) * 100, 1)

Write-Info "`n======== RESULTS ========"
Write-Success "✓ Re-encoding complete!"
Write-Info "Size before: $([math]::Round($sizeBefore, 2)) MB"
Write-Info "Size after:  $([math]::Round($sizeAfter, 2)) MB"
Write-Success "Reduction:  $([math]::Round($reduction, 2)) MB ($percentReduction%)"

# Delete unused ringtones folder
if ($DeleteUnused) {
    Write-Info "`nRemoving unused ringtones folder..."
    if (Test-Path $ringtonesDir) {
        Remove-Item $ringtonesDir -Recurse -Force
        Write-Success "✓ Deleted ringtones folder (8.64 MB)"
    }
}

Write-Success "`n✓ All done! App size should be reduced by approximately $([math]::Round($reduction + 8.64, 1)) MB"
Write-Info "Backup of original files saved at: $backupDir"
Write-Info "Next: Run 'flutter pub get && flutter build appbundle --release' to build"