# Script to extract and analyze permissions from the built AAB file
Write-Host "=== Checking AAB Permissions ===" -ForegroundColor Green

$aabPath = "C:\HabitV8\android\app\build\outputs\bundle\release\app-release.aab"

if (Test-Path $aabPath) {
    Write-Host "Found AAB file: $aabPath" -ForegroundColor Green
    
    # Create temp directory for extraction
    $tempDir = "C:\HabitV8\temp_aab_analysis"
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    Write-Host "Extracting AAB contents..." -ForegroundColor Yellow
    
    # AAB is essentially a ZIP file, so we can extract it
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($aabPath, $tempDir)
        
        # Look for manifest in base module
        $manifestPath = "$tempDir\base\manifest\AndroidManifest.xml"
        
        if (Test-Path $manifestPath) {
            Write-Host "Found manifest in AAB: $manifestPath" -ForegroundColor Green
            
            # Read and analyze permissions
            $content = Get-Content $manifestPath -Raw
            $permissions = [regex]::Matches($content, '<uses-permission[^>]*android:name="([^"]*)"[^>]*>')
            
            Write-Host "`n=== PERMISSIONS IN AAB MANIFEST ===" -ForegroundColor Cyan
            
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
            
            Write-Host "`nHealth-related permissions:" -ForegroundColor Yellow
            foreach ($perm in $healthPermissions | Sort-Object) {
                Write-Host "  - $perm" -ForegroundColor White
            }
            
            Write-Host "`nOther permissions:" -ForegroundColor Yellow
            foreach ($perm in $otherPermissions | Sort-Object) {
                Write-Host "  - $perm" -ForegroundColor Gray
            }
            
            Write-Host "`nTotal permissions in AAB: $($permissions.Count)" -ForegroundColor Green
            Write-Host "Health permissions in AAB: $($healthPermissions.Count)" -ForegroundColor Green
            
        } else {
            Write-Host "Could not find manifest in extracted AAB" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "Error extracting AAB: $($_.Exception.Message)" -ForegroundColor Red
    } finally {
        # Clean up temp directory
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
} else {
    Write-Host "AAB file not found at: $aabPath" -ForegroundColor Red
    Write-Host "Please build the AAB first with: flutter build appbundle --release" -ForegroundColor Yellow
}

Write-Host "`n=== AAB ANALYSIS COMPLETE ===" -ForegroundColor Green