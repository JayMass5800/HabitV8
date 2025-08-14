# PowerShell script to verify health permissions in the built AAB
# This script will help you verify that only the 6 allowed health permissions are present

Write-Host "=== Health Permissions Verification Script ===" -ForegroundColor Green
Write-Host ""

# Check if AAB file exists
$aabPath = "build\app\outputs\bundle\release\app-release.aab"
if (-not (Test-Path $aabPath)) {
    Write-Host "ERROR: AAB file not found at $aabPath" -ForegroundColor Red
    Write-Host "Please build the AAB first with: flutter build appbundle --release" -ForegroundColor Yellow
    exit 1
}

Write-Host "Found AAB file: $aabPath" -ForegroundColor Green

# Extract AAB to temporary directory for analysis
$tempDir = "temp_aab_analysis"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# AAB files are ZIP files, so we can extract them
try {
    Expand-Archive -Path $aabPath -DestinationPath $tempDir -Force
    Write-Host "Extracted AAB for analysis" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to extract AAB file: $_" -ForegroundColor Red
    exit 1
}

# Find and analyze AndroidManifest.xml files
$manifestFiles = Get-ChildItem -Path $tempDir -Name "AndroidManifest.xml" -Recurse
Write-Host ""
Write-Host "Found AndroidManifest.xml files:" -ForegroundColor Cyan
foreach ($manifest in $manifestFiles) {
    Write-Host "  - $manifest" -ForegroundColor White
}

# Allowed health permissions (exactly what we want)
$allowedPermissions = @(
    "android.permission.health.READ_STEPS",
    "android.permission.health.READ_ACTIVE_CALORIES_BURNED", 
    "android.permission.health.READ_SLEEP",
    "android.permission.health.READ_HYDRATION",
    "android.permission.health.READ_MINDFULNESS",
    "android.permission.health.READ_WEIGHT"
)

# Forbidden health permissions (what Google detects and rejects)
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
Write-Host "=== ANALYZING HEALTH PERMISSIONS ===" -ForegroundColor Yellow

$foundAllowed = @()
$foundForbidden = @()
$allHealthPermissions = @()

# Analyze each manifest file
foreach ($manifestFile in $manifestFiles) {
    $fullPath = Join-Path $tempDir $manifestFile
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        
        Write-Host ""
        Write-Host "Analyzing: $manifestFile" -ForegroundColor Cyan
        
        # Find all health permissions
        $healthPermissionPattern = 'android\.permission\.health\.[A-Z_]+'
        $matches = [regex]::Matches($content, $healthPermissionPattern)
        
        foreach ($match in $matches) {
            $permission = $match.Value
            if ($allHealthPermissions -notcontains $permission) {
                $allHealthPermissions += $permission
            }
            
            if ($allowedPermissions -contains $permission) {
                if ($foundAllowed -notcontains $permission) {
                    $foundAllowed += $permission
                    Write-Host "  ✓ ALLOWED: $permission" -ForegroundColor Green
                }
            } elseif ($forbiddenPermissions -contains $permission) {
                if ($foundForbidden -notcontains $permission) {
                    $foundForbidden += $permission
                    Write-Host "  ✗ FORBIDDEN: $permission" -ForegroundColor Red
                }
            } else {
                Write-Host "  ? UNKNOWN: $permission" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""
Write-Host "=== FINAL RESULTS ===" -ForegroundColor Magenta

Write-Host ""
Write-Host "ALLOWED PERMISSIONS FOUND ($($foundAllowed.Count)/6):" -ForegroundColor Green
foreach ($perm in $foundAllowed) {
    Write-Host "  ✓ $perm" -ForegroundColor Green
}

if ($foundForbidden.Count -gt 0) {
    Write-Host ""
    Write-Host "FORBIDDEN PERMISSIONS FOUND ($($foundForbidden.Count)):" -ForegroundColor Red
    foreach ($perm in $foundForbidden) {
        Write-Host "  ✗ $perm" -ForegroundColor Red
    }
}

Write-Host ""
if ($foundForbidden.Count -eq 0) {
    Write-Host "🎉 SUCCESS: No forbidden health permissions found!" -ForegroundColor Green
    Write-Host "This AAB should pass Google Play Console review." -ForegroundColor Green
} else {
    Write-Host "❌ FAILURE: Found $($foundForbidden.Count) forbidden health permissions!" -ForegroundColor Red
    Write-Host "Google Play Console will likely reject this AAB." -ForegroundColor Red
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. The manifest merger may not be working correctly" -ForegroundColor White
    Write-Host "2. The health plugin may be adding permissions despite our overrides" -ForegroundColor White
    Write-Host "3. Consider downgrading the health plugin version" -ForegroundColor White
}

Write-Host ""
Write-Host "TOTAL HEALTH PERMISSIONS FOUND: $($allHealthPermissions.Count)" -ForegroundColor Cyan
Write-Host "EXPECTED: 6 allowed permissions only" -ForegroundColor Cyan

# Cleanup
Remove-Item $tempDir -Recurse -Force
Write-Host ""
Write-Host "Analysis complete. Temporary files cleaned up." -ForegroundColor Gray