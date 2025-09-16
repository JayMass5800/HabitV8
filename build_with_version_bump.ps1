# Advanced Flutter Build Script with Automatic Version Management
# Usage: 
#   ./build_with_version_bump.ps1                          # Auto-increment patch version and build APK
#   ./build_with_version_bump.ps1 -BuildType aab           # Auto-increment patch version and build AAB
#   ./build_with_version_bump.ps1 -NewVersion "8.3.0"      # Set specific version and build
#   ./build_with_version_bump.ps1 -OnlyBuild               # Only increment build number (no version change)
#   ./build_with_version_bump.ps1 -SkipBuild               # Only increment version, don't build

param(
    [string]$NewVersion = $null,
    [string]$BuildType = "apk",  # apk, aab, ios, web
    [string]$PubspecPath = "pubspec.yaml",
    [switch]$SkipBuild,
    [switch]$Debug,
    [switch]$OnlyBuild
)

Write-Host "🚀 Flutter Build & Version Manager" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Build Type: $BuildType" -ForegroundColor Yellow
if ($NewVersion) {
    Write-Host "New Version: $NewVersion" -ForegroundColor Yellow
}
Write-Host ""

# Function to increment build number
function Update-BuildNumber {
    param($PubspecPath, $NewVersion, $OnlyBuild)
    
    Write-Host "🔧 Updating build number..." -ForegroundColor Yellow
    
    if (-not (Test-Path $PubspecPath)) {
        Write-Host "❌ Error: pubspec.yaml not found at $PubspecPath" -ForegroundColor Red
        return $false
    }

    $content = Get-Content $PubspecPath -Raw
    $versionPattern = 'version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)'
    $match = [regex]::Match($content, $versionPattern)

    if (-not $match.Success) {
        Write-Host "❌ Error: Could not find version pattern in pubspec.yaml" -ForegroundColor Red
        return $false
    }

    $currentVersionPart = $match.Groups[1].Value
    $currentBuildNumber = [int]$match.Groups[2].Value

    Write-Host "📋 Current version: $currentVersionPart+$currentBuildNumber" -ForegroundColor Green

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

    $oldVersionString = "$currentVersionPart+$currentBuildNumber"
    $newVersionString = "$newVersionPart+$newBuildNumber"
    $newContent = $content -replace "version:\s*$([regex]::Escape($oldVersionString))", "version: $newVersionString"

    try {
        $newContent | Set-Content $PubspecPath -NoNewline
        Write-Host "✅ Successfully updated pubspec.yaml to $newVersionString" -ForegroundColor Green
        return $newVersionString
    } catch {
        Write-Host "❌ Error writing to pubspec.yaml: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Function to run Flutter build
function Invoke-FlutterBuild {
    param($BuildType, $Debug)
    
    Write-Host "`n🔄 Running flutter pub get..." -ForegroundColor Yellow
    $pubGetResult = & flutter pub get 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ flutter pub get failed" -ForegroundColor Red
        Write-Host $pubGetResult -ForegroundColor Red
        return $false
    }
    Write-Host "✅ flutter pub get completed" -ForegroundColor Green

    $buildCommand = switch ($BuildType.ToLower()) {
        "apk" {
            if ($Debug) { 
                "flutter build apk --debug" 
            } else { 
                "flutter build apk --release" 
            }
        }
        "aab" {
            if ($Debug) { 
                "flutter build appbundle --debug" 
            } else { 
                "flutter build appbundle --release" 
            }
        }
        "ios" {
            if ($Debug) { 
                "flutter build ios --debug" 
            } else { 
                "flutter build ios --release" 
            }
        }
        "web" {
            if ($Debug) { 
                "flutter build web" 
            } else { 
                "flutter build web --release" 
            }
        }
        default {
            Write-Host "❌ Unknown build type: $BuildType" -ForegroundColor Red
            return $false
        }
    }

    Write-Host "`n🏗️ Running: $buildCommand" -ForegroundColor Yellow
    $buildStartTime = Get-Date
    
    try {
        $buildResult = Invoke-Expression $buildCommand 2>&1
        $buildEndTime = Get-Date
        $buildDuration = $buildEndTime - $buildStartTime
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Build completed successfully!" -ForegroundColor Green
            Write-Host "⏱️ Build time: $($buildDuration.ToString('mm\:ss'))" -ForegroundColor Green
            
            # Show output file location
            switch ($BuildType.ToLower()) {
                "apk" {
                    $outputPath = "build\app\outputs\flutter-apk\app-release.apk"
                    if (Test-Path $outputPath) {
                        $fileSize = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
                        Write-Host "📦 APK location: $outputPath ($fileSize MB)" -ForegroundColor Cyan
                    }
                }
                "aab" {
                    $outputPath = "build\app\outputs\bundle\release\app-release.aab"
                    if (Test-Path $outputPath) {
                        $fileSize = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
                        Write-Host "📦 AAB location: $outputPath ($fileSize MB)" -ForegroundColor Cyan
                    }
                }
            }
            return $true
        } else {
            Write-Host "❌ Build failed!" -ForegroundColor Red
            Write-Host $buildResult -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host "❌ Build error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution
try {
    # Step 1: Update version/build number
    $newVersionString = Update-BuildNumber -PubspecPath $PubspecPath -NewVersion $NewVersion -OnlyBuild $OnlyBuild
    if (-not $newVersionString) {
        exit 1
    }

    # Step 2: Build if not skipped
    if (-not $SkipBuild) {
        $buildSuccess = Invoke-FlutterBuild -BuildType $BuildType -Debug $Debug
        if (-not $buildSuccess) {
            Write-Host "`n❌ Build failed. Version was still updated to $newVersionString" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "`n⏭️ Build skipped as requested" -ForegroundColor Yellow
    }

    Write-Host "`n🎉 All operations completed successfully!" -ForegroundColor Green
    Write-Host "📝 Version: $newVersionString" -ForegroundColor Green
    
    if (-not $SkipBuild) {
        Write-Host "🏗️ Build: Completed" -ForegroundColor Green
    }

} catch {
    Write-Host "`n❌ Unexpected error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}