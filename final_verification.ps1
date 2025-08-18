# Final Health Permissions Verification Script
# This script will verify that our solution worked

Write-Host "=== FINAL HEALTH PERMISSIONS VERIFICATION ===" -ForegroundColor Green
Write-Host ""

# Check if AAB file exists
$aabPath = "android\app\build\outputs\bundle\release\app-release.aab"
if (-not (Test-Path $aabPath)) {
    Write-Host "❌ ERROR: AAB file not found at $aabPath" -ForegroundColor Red
    Write-Host "Please build the AAB first with: flutter build appbundle --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found AAB file: $aabPath" -ForegroundColor Green
$aabSize = (Get-Item $aabPath).Length / 1MB
Write-Host "📦 AAB Size: $([math]::Round($aabSize, 2)) MB" -ForegroundColor Cyan

# Extract AAB to temporary directory for analysis
$tempDir = "temp_final_analysis"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
    Expand-Archive -Path $aabPath -DestinationPath $tempDir -Force
    Write-Host "✅ Extracted AAB for analysis" -ForegroundColor Green
} catch {
    Write-Host "❌ ERROR: Failed to extract AAB file: $_" -ForegroundColor Red
    exit 1
}

# Find and analyze AndroidManifest.xml files
$manifestFiles = Get-ChildItem -Path $tempDir -Name "AndroidManifest.xml" -Recurse
Write-Host ""
Write-Host "📄 Found AndroidManifest.xml files:" -ForegroundColor Cyan
foreach ($manifest in $manifestFiles) {
    Write-Host "  - $manifest" -ForegroundColor White
}

# The 6 ALLOWED health permissions (exactly what we want)
$allowedPermissions = @(
    "android.permission.health.READ_STEPS",
    "android.permission.health.READ_ACTIVE_CALORIES_BURNED", 
    "android.permission.health.READ_SLEEP",
    "android.permission.health.READ_HYDRATION",
    "android.permission.health.READ_MINDFULNESS",
    "android.permission.health.READ_WEIGHT"
)

# FORBIDDEN health permissions (what Google detects and rejects)
$forbiddenPermissions = @(
    "android.permission.health.READ_HEART_RATE",
    "android.permission.health.READ_BLOOD_PRESSURE",
    "android.permission.health.READ_BLOOD_GLUCOSE",
    "android.permission.health.READ_BODY_TEMPERATURE",
    "android.permission.health.READ_OXYGEN_SATURATION",
    "android.permission.health.READ_RESPIRATORY_RATE",
    "android.permission.health.READ_NUTRITION",
    "android.permission.health.READ_EXERCISE",
    "android.permission.health.READ_DISTANCE",
    "android.permission.health.READ_ELEVATION_GAINED",
    "android.permission.health.READ_FLOORS_CLIMBED",
    "android.permission.health.READ_POWER",
    "android.permission.health.READ_SPEED",
    "android.permission.health.READ_TOTAL_CALORIES_BURNED",
    "android.permission.health.READ_VO2_MAX",
    "android.permission.health.READ_WHEELCHAIR_PUSHES",
    "android.permission.health.READ_BASAL_METABOLIC_RATE",
    "android.permission.health.READ_BODY_FAT",
    "android.permission.health.READ_BONE_MASS",
    "android.permission.health.READ_HEIGHT",
    "android.permission.health.READ_HIP_CIRCUMFERENCE",
    "android.permission.health.READ_LEAN_BODY_MASS",
    "android.permission.health.READ_WAIST_CIRCUMFERENCE",
    "android.permission.health.READ_MENSTRUATION",
    "android.permission.health.READ_INTERMENSTRUAL_BLEEDING",
    "android.permission.health.READ_OVULATION_TEST",
    "android.permission.health.READ_CERVICAL_MUCUS",
    "android.permission.health.READ_SEXUAL_ACTIVITY",
    "android.permission.health.READ_RESTING_HEART_RATE",
    "android.permission.health.READ_HEART_RATE_VARIABILITY",
    "android.permission.health.READ_BODY_WATER_MASS",
    "android.permission.health.READ_CERVICAL_POSITION",
    "android.permission.health.READ_SKIN_TEMPERATURE"
)

Write-Host ""
Write-Host "🔍 ANALYZING HEALTH PERMISSIONS..." -ForegroundColor Yellow

$foundAllowed = @()
$foundForbidden = @()
$allHealthPermissions = @()

# Analyze each manifest file
foreach ($manifestFile in $manifestFiles) {
    $fullPath = Join-Path $tempDir $manifestFile
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        
        Write-Host ""
        Write-Host "📋 Analyzing: $manifestFile" -ForegroundColor Cyan
        
        # Find all health permissions
        $healthPermissionPattern = 'android\.permission\.health\.[A-Z_]+'
        $healthMatches = [regex]::Matches($content, $healthPermissionPattern)
        
        if ($healthMatches.Count -eq 0) {
            Write-Host "  ℹ️  No health permissions found in this manifest" -ForegroundColor Gray
        }
        
        foreach ($match in $healthMatches) {
            $permission = $match.Value
            if ($allHealthPermissions -notcontains $permission) {
                $allHealthPermissions += $permission
            }
            
            if ($allowedPermissions -contains $permission) {
                if ($foundAllowed -notcontains $permission) {
                    $foundAllowed += $permission
                    Write-Host "  ✅ ALLOWED: $permission" -ForegroundColor Green
                }
            } elseif ($forbiddenPermissions -contains $permission) {
                if ($foundForbidden -notcontains $permission) {
                    $foundForbidden += $permission
                    Write-Host "  ❌ FORBIDDEN: $permission" -ForegroundColor Red
                }
            } else {
                Write-Host "  ⚠️  UNKNOWN: $permission" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""
Write-Host "📊 FINAL RESULTS" -ForegroundColor Magenta
Write-Host "=================" -ForegroundColor Magenta

Write-Host ""
Write-Host "✅ ALLOWED PERMISSIONS FOUND ($($foundAllowed.Count)/6):" -ForegroundColor Green
if ($foundAllowed.Count -eq 0) {
    Write-Host "  🎉 PERFECT! No health permissions found at all!" -ForegroundColor Green
    Write-Host "  This means Google Play Console won't detect any health features." -ForegroundColor Green
} else {
    foreach ($perm in $foundAllowed) {
        Write-Host "  ✅ $perm" -ForegroundColor Green
    }
}

if ($foundForbidden.Count -gt 0) {
    Write-Host ""
    Write-Host "❌ FORBIDDEN PERMISSIONS FOUND ($($foundForbidden.Count)):" -ForegroundColor Red
    foreach ($perm in $foundForbidden) {
        Write-Host "  ❌ $perm" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "📈 SUMMARY:" -ForegroundColor Cyan
Write-Host "  Total health permissions found: $($allHealthPermissions.Count)" -ForegroundColor White
Write-Host "  Allowed permissions: $($foundAllowed.Count)" -ForegroundColor Green
Write-Host "  Forbidden permissions: $($foundForbidden.Count)" -ForegroundColor Red

Write-Host ""
if ($foundForbidden.Count -eq 0) {
    if ($allHealthPermissions.Count -eq 0) {
        Write-Host "🎉🎉🎉 PERFECT SUCCESS! 🎉🎉🎉" -ForegroundColor Green
        Write-Host "No health permissions detected at all!" -ForegroundColor Green
        Write-Host "Google Play Console will NOT flag this app for health features!" -ForegroundColor Green
    } else {
        Write-Host "🎉 SUCCESS! No forbidden health permissions found!" -ForegroundColor Green
        Write-Host "This AAB should pass Google Play Console review." -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "✅ NEXT STEPS:" -ForegroundColor Green
    Write-Host "1. Upload this AAB to Google Play Console" -ForegroundColor White
    Write-Host "2. The health permissions warning should be gone" -ForegroundColor White
    Write-Host "3. Your app should be approved without health policy issues" -ForegroundColor White
} else {
    Write-Host "❌ FAILURE: Found $($foundForbidden.Count) forbidden health permissions!" -ForegroundColor Red
    Write-Host "Google Play Console will likely still reject this AAB." -ForegroundColor Red
    Write-Host ""
    Write-Host "🔧 ADDITIONAL STEPS NEEDED:" -ForegroundColor Yellow
    Write-Host "1. Check if any other plugins are adding health permissions" -ForegroundColor White
    Write-Host "2. Review all dependencies for health-related metadata" -ForegroundColor White
    Write-Host "3. Consider using a different approach for health data" -ForegroundColor White
}

# Check for other potential issues
Write-Host ""
Write-Host "🔍 ADDITIONAL CHECKS:" -ForegroundColor Cyan

# Check for ACTIVITY_RECOGNITION permission
$activityRecognitionFound = $false
foreach ($manifestFile in $manifestFiles) {
    $fullPath = Join-Path $tempDir $manifestFile
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        if ($content -match "android\.permission\.ACTIVITY_RECOGNITION") {
            $activityRecognitionFound = $true
            break
        }
    }
}

if ($activityRecognitionFound) {
    Write-Host "⚠️  ACTIVITY_RECOGNITION permission found - this might also trigger health policy" -ForegroundColor Yellow
} else {
    Write-Host "✅ No ACTIVITY_RECOGNITION permission found" -ForegroundColor Green
}

# Cleanup
Remove-Item $tempDir -Recurse -Force
Write-Host ""
Write-Host "🧹 Analysis complete. Temporary files cleaned up." -ForegroundColor Gray

Write-Host ""
Write-Host "📝 REPORT SUMMARY:" -ForegroundColor Magenta
Write-Host "==================" -ForegroundColor Magenta
Write-Host "AAB File: $aabPath" -ForegroundColor White
Write-Host "AAB Size: $([math]::Round($aabSize, 2)) MB" -ForegroundColor White
Write-Host "Health Permissions Found: $($allHealthPermissions.Count)" -ForegroundColor White
Write-Host "Forbidden Permissions: $($foundForbidden.Count)" -ForegroundColor White
Write-Host "Analysis Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White

if ($foundForbidden.Count -eq 0) {
    Write-Host ""
    Write-Host "🎯 RESULT: SUCCESS - Ready for Google Play Console upload!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "🎯 RESULT: NEEDS MORE WORK - Additional cleanup required" -ForegroundColor Red
}