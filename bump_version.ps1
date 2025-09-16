# Simple version bump utility that can be called from other scripts
# Usage: 
#   ./bump_version.ps1                    # Auto-increment patch version and reset build to 1
#   ./bump_version.ps1 -Version "8.3.0"  # Update to specific version and reset build to 1
#   ./bump_version.ps1 -OnlyBuild         # Just increment build number (no version change)

param(
    [string]$Version = $null,
    [string]$PubspecPath = "pubspec.yaml",
    [switch]$OnlyBuild
)

# Read current version
$content = Get-Content $PubspecPath -Raw
$versionPattern = 'version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)'
$match = [regex]::Match($content, $versionPattern)

if (-not $match.Success) {
    Write-Error "Could not find version pattern in pubspec.yaml"
    exit 1
}

$currentVersionPart = $match.Groups[1].Value
$currentBuildNumber = [int]$match.Groups[2].Value

# Calculate new version
if ($Version) {
    $newVersionPart = $Version
    $newBuildNumber = 1 # Reset build number for new version
} elseif ($OnlyBuild) {
    $newVersionPart = $currentVersionPart
    $newBuildNumber = $currentBuildNumber + 1
} else {
    # Auto-increment patch version (X.Y.Z -> X.Y.Z+1)
    $versionParts = $currentVersionPart.Split('.')
    if ($versionParts.Length -eq 3) {
        $major = [int]$versionParts[0]
        $minor = [int]$versionParts[1]
        $patch = [int]$versionParts[2]
        $patch++ # Increment patch version
        $newVersionPart = "$major.$minor.$patch"
        $newBuildNumber = 1 # Reset build number for new version
    } else {
        $newVersionPart = $currentVersionPart
        $newBuildNumber = $currentBuildNumber + 1
    }
}

# Update the file
$oldVersionString = "$currentVersionPart+$currentBuildNumber"
$newVersionString = "$newVersionPart+$newBuildNumber"
$newContent = $content -replace "version:\s*$([regex]::Escape($oldVersionString))", "version: $newVersionString"

$newContent | Set-Content $PubspecPath -NoNewline

Write-Host "Updated version: $oldVersionString → $newVersionString" -ForegroundColor Green
Write-Output $newVersionString