# Performance Optimization Verification Script
# Run this after deploying the changes to verify improvements

Write-Host "`n=== PERFORMANCE OPTIMIZATION VERIFICATION ===" -ForegroundColor Cyan
Write-Host "`nThis script will help you verify the performance improvements." -ForegroundColor White
Write-Host "Make sure you have a device connected via ADB.`n" -ForegroundColor Yellow

# Check if device is connected
Write-Host "Checking for connected device..." -ForegroundColor Cyan
$devices = adb devices
if ($devices -match "device$") {
    Write-Host "✓ Device found" -ForegroundColor Green
} else {
    Write-Host "✗ No device found. Please connect a device and try again." -ForegroundColor Red
    exit 1
}

Write-Host "`n=== TEST 1: Monitor GC Activity ===" -ForegroundColor Cyan
Write-Host "This will monitor garbage collection for 60 seconds." -ForegroundColor White
Write-Host "Expected: GC events every 15-30 seconds (not every 2-3 seconds)" -ForegroundColor Yellow
Write-Host "`nPress ENTER to start monitoring, or Ctrl+C to skip..." -ForegroundColor White
Read-Host

Write-Host "Monitoring GC for 60 seconds..." -ForegroundColor Cyan
$gcLogFile = "gc_monitoring.txt"
$job = Start-Job -ScriptBlock {
    param($logFile)
    adb logcat -s r.habitv8.debug | Select-String "GC freed" | Tee-Object -FilePath $logFile
} -ArgumentList $gcLogFile

Start-Sleep -Seconds 60
Stop-Job -Job $job
Remove-Job -Job $job

Write-Host "`nAnalyzing GC logs..." -ForegroundColor Cyan
$gcEvents = Get-Content $gcLogFile 2>$null
if ($gcEvents) {
    $gcCount = $gcEvents.Count
    Write-Host "Total GC events in 60s: $gcCount" -ForegroundColor White
    
    if ($gcCount -lt 10) {
        Write-Host "✓ EXCELLENT: Very few GC events (target: <10)" -ForegroundColor Green
    } elseif ($gcCount -lt 20) {
        Write-Host "✓ GOOD: Reasonable GC frequency (target: <20)" -ForegroundColor Green
    } else {
        Write-Host "⚠ WARNING: Still frequent GC events (expected: <20, got: $gcCount)" -ForegroundColor Yellow
    }
    
    Write-Host "`nGC log saved to: $gcLogFile" -ForegroundColor Cyan
} else {
    Write-Host "⚠ No GC events detected (might be good, or app not running)" -ForegroundColor Yellow
}

Write-Host "`n=== TEST 2: Widget Update Test ===" -ForegroundColor Cyan
Write-Host "This test requires manual verification:" -ForegroundColor White
Write-Host "  1. Make sure you have a home screen widget added" -ForegroundColor White
Write-Host "  2. Open the app" -ForegroundColor White
Write-Host "  3. Complete a habit" -ForegroundColor White
Write-Host "  4. Check if widget updates INSTANTLY (within 1 second)" -ForegroundColor White
Write-Host "`nDid the widget update instantly? (y/n): " -ForegroundColor Yellow -NoNewline
$widgetResponse = Read-Host

if ($widgetResponse -eq "y") {
    Write-Host "✓ Widget updates working correctly!" -ForegroundColor Green
} else {
    Write-Host "✗ Widget update issue - check Isar listener initialization" -ForegroundColor Red
}

Write-Host "`n=== TEST 3: Idle Behavior Test ===" -ForegroundColor Cyan
Write-Host "This will monitor app behavior when idle for 30 seconds." -ForegroundColor White
Write-Host "Expected: No periodic log messages" -ForegroundColor Yellow
Write-Host "`nPress ENTER to start monitoring, or Ctrl+C to skip..." -ForegroundColor White
Read-Host

Write-Host "Monitoring for 30 seconds (keep app in background)..." -ForegroundColor Cyan
$idleLogFile = "idle_monitoring.txt"
$job = Start-Job -ScriptBlock {
    param($logFile)
    adb logcat -s r.habitv8.debug | Tee-Object -FilePath $logFile
} -ArgumentList $idleLogFile

Start-Sleep -Seconds 30
Stop-Job -Job $job
Remove-Job -Job $job

Write-Host "`nAnalyzing idle logs..." -ForegroundColor Cyan
$idleLogs = Get-Content $idleLogFile 2>$null
if ($idleLogs) {
    # Check for problematic patterns
    $periodicMessages = $idleLogs | Select-String "periodic|timer|Performing"
    
    if ($periodicMessages.Count -eq 0) {
        Write-Host "✓ EXCELLENT: No periodic activity detected" -ForegroundColor Green
    } else {
        Write-Host "⚠ WARNING: Found $($periodicMessages.Count) periodic messages" -ForegroundColor Yellow
        Write-Host "Sample messages:" -ForegroundColor White
        $periodicMessages | Select-Object -First 3 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    }
    
    Write-Host "`nIdle log saved to: $idleLogFile" -ForegroundColor Cyan
} else {
    Write-Host "⚠ No logs captured" -ForegroundColor Yellow
}

Write-Host "`n=== TEST 4: Code Compilation ===" -ForegroundColor Cyan
Write-Host "Running flutter analyze on modified files..." -ForegroundColor White

$analyzeResult = flutter analyze --no-fatal-infos lib/services/notification_queue_processor.dart lib/services/widget_integration_service.dart lib/services/midnight_habit_reset_service.dart lib/main.dart 2>&1

if ($analyzeResult -match "No issues found") {
    Write-Host "✓ All files compile without errors" -ForegroundColor Green
} else {
    Write-Host "✗ Compilation issues found:" -ForegroundColor Red
    Write-Host $analyzeResult -ForegroundColor Gray
}

Write-Host "`n=== VERIFICATION SUMMARY ===" -ForegroundColor Cyan
Write-Host "`nPlease review the results above:" -ForegroundColor White
Write-Host "  1. GC frequency should be <10 events per minute" -ForegroundColor White
Write-Host "  2. Widgets should update instantly" -ForegroundColor White
Write-Host "  3. No periodic activity when idle" -ForegroundColor White
Write-Host "  4. All code should compile without errors" -ForegroundColor White

Write-Host "`n=== ADDITIONAL CHECKS ===" -ForegroundColor Cyan
Write-Host "`nRecommended manual checks:" -ForegroundColor White
Write-Host "  • Create a new habit - notifications should schedule" -ForegroundColor White
Write-Host "  • Wait for midnight - reset should occur" -ForegroundColor White
Write-Host "  • Monitor battery usage over 24 hours" -ForegroundColor White
Write-Host "  • Check for any crashes in logcat" -ForegroundColor White

Write-Host "`n=== DOCUMENTATION ===" -ForegroundColor Cyan
Write-Host "`nFor more details, see:" -ForegroundColor White
Write-Host "  • PERFORMANCE_OPTIMIZATION_IMPLEMENTATION.md (detailed)" -ForegroundColor White
Write-Host "  • PERFORMANCE_OPTIMIZATION_QUICK_REF.md (quick reference)" -ForegroundColor White
Write-Host "  • PERFORMANCE_ANALYSIS_GC_ISSUES.md (original analysis)" -ForegroundColor White

Write-Host "`n=== DONE ===" -ForegroundColor Green
Write-Host "Verification complete!`n" -ForegroundColor White
