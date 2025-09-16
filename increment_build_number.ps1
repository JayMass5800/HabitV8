# PowerShell script to automatically increment the build number in pubspec.yaml
# Usage: ./increment_build_number.ps1                    # Auto-increment patch version + build
# Optional: ./increment_build_number.ps1 -NewVersion "8.3.0"  # Set specific version + build
# Optional: ./increment_build_number.ps1 -OnlyBuild     # Only increment build number

param(
    [string]$NewVersion = $null,
    [string]$PubspecPath = "pubspec.yaml",
    [switch]$OnlyBuild
)

Write-Host "🔧 Flutter Build Number Incrementer" -ForegroundColor Cyan
Write-Host "=====================================`n" -ForegroundColor Cyan

# Check if pubspec.yaml exists
if (-not (Test-Path $PubspecPath)) {
    Write-Host "❌ Error: pubspec.yaml not found at $PubspecPath" -ForegroundColor Red
    exit 1
}

# Read the current pubspec.yaml content
$content = Get-Content $PubspecPath -Raw
Write-Host "📖 Reading $PubspecPath..." -ForegroundColor Yellow

# Extract current version using regex
$versionPattern = 'version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)'
$match = [regex]::Match($content, $versionPattern)

if (-not $match.Success) {
    Write-Host "❌ Error: Could not find version pattern in pubspec.yaml" -ForegroundColor Red
    Write-Host "Expected format: version: X.Y.Z+BuildNumber" -ForegroundColor Red
    exit 1
}

$currentVersionPart = $match.Groups[1].Value
$currentBuildNumber = [int]$match.Groups[2].Value

Write-Host "📋 Current version: $currentVersionPart+$currentBuildNumber" -ForegroundColor Green

# Determine new version and build number
if ($NewVersion) {
    $newVersionPart = $NewVersion
    $newBuildNumber = 10 # Start at build 10 for new version
    Write-Host "🆙 Updating to version: $newVersionPart+$newBuildNumber" -ForegroundColor Cyan
} elseif ($OnlyBuild) {
    $newVersionPart = $currentVersionPart
    $newBuildNumber = $currentBuildNumber + 1
    Write-Host "🔢 Incrementing build number only: $currentBuildNumber → $newBuildNumber" -ForegroundColor Cyan
} else {
    # Auto-increment patch version (X.Y.Z -> X.Y.Z+1)
    $versionParts = $currentVersionPart.Split('.')
    if ($versionParts.Length -eq 3) {
        $major = [int]$versionParts[0]
        $minor = [int]$versionParts[1]
        $patch = [int]$versionParts[2]
        $patch++ # Increment patch version
        $newVersionPart = "$major.$minor.$patch"
        $newBuildNumber = 10 # Reset build number to 10 for new version
        Write-Host "🆙 Auto-incrementing patch version: $currentVersionPart → $newVersionPart (build reset to 10)" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️ Warning: Cannot parse version parts, only incrementing build number" -ForegroundColor Yellow
        $newVersionPart = $currentVersionPart
        $newBuildNumber = $currentBuildNumber + 1
    }
}

# Create the new version string
$oldVersionString = "$currentVersionPart+$currentBuildNumber"
$newVersionString = "$newVersionPart+$newBuildNumber"

# Replace the version in the content
$newContent = $content -replace "version:\s*$([regex]::Escape($oldVersionString))", "version: $newVersionString"

# Write the updated content back to the file
try {
    $newContent | Set-Content $PubspecPath -NoNewline
    Write-Host "✅ Successfully updated pubspec.yaml" -ForegroundColor Green
    Write-Host "📝 New version: $newVersionString" -ForegroundColor Green
    
    # Optional: Run flutter pub get to update dependencies
    Write-Host "`n🔄 Running flutter pub get..." -ForegroundColor Yellow
    $pubGetResult = & flutter pub get 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ flutter pub get completed successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Warning: flutter pub get failed" -ForegroundColor Yellow
        Write-Host $pubGetResult -ForegroundColor Yellow
    }
    
    Write-Host "`n🎉 Build number increment completed!" -ForegroundColor Green
    Write-Host "You can now run: flutter build appbundle --release" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Error writing to pubspec.yaml: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}