# Script to check dependencies that might contribute health permissions
Write-Host "=== Checking Dependencies for Health Permissions ===" -ForegroundColor Green

Set-Location "C:\HabitV8\android"

Write-Host "Generating dependency report..." -ForegroundColor Yellow

# Generate dependency report
try {
    $output = & .\gradlew.bat app:dependencies --configuration releaseRuntimeClasspath 2>&1
    
    # Look for health-related dependencies
    $healthDeps = $output | Where-Object { $_ -match "health" -or $_ -match "fitness" -or $_ -match "connect" }
    
    if ($healthDeps) {
        Write-Host "`nHealth-related dependencies found:" -ForegroundColor Yellow
        foreach ($dep in $healthDeps) {
            Write-Host "  $dep" -ForegroundColor White
        }
    } else {
        Write-Host "`nNo obvious health-related dependencies found in names" -ForegroundColor Green
    }
    
    # Also check for any androidx.health dependencies
    $androidxHealth = $output | Where-Object { $_ -match "androidx.*health" }
    if ($androidxHealth) {
        Write-Host "`nAndroidX Health dependencies:" -ForegroundColor Yellow
        foreach ($dep in $androidxHealth) {
            Write-Host "  $dep" -ForegroundColor White
        }
    }
    
} catch {
    Write-Host "Error running gradle dependencies: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== DEPENDENCY CHECK COMPLETE ===" -ForegroundColor Green