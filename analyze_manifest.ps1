# Script to analyze merged manifest for permission issues
Write-Host "=== Analyzing Android Manifest for Permission Issues ===" -ForegroundColor Green

# Build paths
$buildDir = "C:\HabitV8\android\app\build"
$mergedManifestPath = "$buildDir\intermediates\merged_manifests\release\AndroidManifest.xml"
$bundleManifestPath = "$buildDir\intermediates\bundle_manifest\release\AndroidManifest.xml"

Write-Host "`nLooking for merged manifest files..." -ForegroundColor Yellow

# Check if merged manifest exists
if (Test-Path $mergedManifestPath) {
    Write-Host "Found merged manifest: $mergedManifestPath" -ForegroundColor Green
    
    # Extract all permissions
    Write-Host "`n=== PERMISSIONS IN MERGED MANIFEST ===" -ForegroundColor Cyan
    $content = Get-Content $mergedManifestPath -Raw
    $permissions = [regex]::Matches($content, '<uses-permission[^>]*android:name="([^"]*)"[^>]*>')
    
    $healthPermissions = @()
    $otherPermissions = @()
    
    foreach ($match in $permissions) {
        $permission = $match.Groups[1].Value
        if ($permission -like "*health*") {
            $healthPermissions += $permission
        } else {
            $otherPermissions += $permission
        }
    }
    
    Write-Host "`nHealth-related permissions found:" -ForegroundColor Yellow
    foreach ($perm in $healthPermissions | Sort-Object) {
        Write-Host "  - $perm" -ForegroundColor White
    }
    
    Write-Host "`nOther permissions found:" -ForegroundColor Yellow
    foreach ($perm in $otherPermissions | Sort-Object) {
        Write-Host "  - $perm" -ForegroundColor Gray
    }
    
    Write-Host "`nTotal permissions: $($permissions.Count)" -ForegroundColor Green
    Write-Host "Health permissions: $($healthPermissions.Count)" -ForegroundColor Green
    
} else {
    Write-Host "Merged manifest not found at: $mergedManifestPath" -ForegroundColor Red
}

# Check bundle manifest if it exists
if (Test-Path $bundleManifestPath) {
    Write-Host "`nFound bundle manifest: $bundleManifestPath" -ForegroundColor Green
    # Similar analysis for bundle manifest
} else {
    Write-Host "`nBundle manifest not found at: $bundleManifestPath" -ForegroundColor Yellow
}

# Check for dependency manifests that might contribute permissions
Write-Host "`n=== CHECKING DEPENDENCY MANIFESTS ===" -ForegroundColor Cyan
$dependencyManifests = Get-ChildItem -Path "$buildDir\intermediates" -Recurse -Filter "AndroidManifest.xml" -ErrorAction SilentlyContinue

foreach ($manifest in $dependencyManifests) {
    if ($manifest.FullName -ne $mergedManifestPath) {
        $content = Get-Content $manifest.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -and $content -match 'health') {
            Write-Host "Found health-related content in: $($manifest.FullName)" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n=== ANALYSIS COMPLETE ===" -ForegroundColor Green