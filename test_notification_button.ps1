# Test script to debug notification button widget updates
# This will show you EXACTLY what's happening when you press the notification button

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Widget Update Debug Test" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Instructions:" -ForegroundColor Yellow
Write-Host "1. Make sure your app is installed and running" -ForegroundColor White
Write-Host "2. Wait for a notification to appear" -ForegroundColor White
Write-Host "3. When ready, press ENTER to start monitoring" -ForegroundColor White
Write-Host "4. Then press the 'Complete' button on the notification" -ForegroundColor White
Write-Host "5. Watch the logs below" -ForegroundColor White
Write-Host ""
Read-Host "Press ENTER to start monitoring"

# Clear logs
adb logcat -c

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "MONITORING STARTED - Press Ctrl+C to stop" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""

# Monitor logs with color coding
adb logcat | ForEach-Object {
    $line = $_
    
    # Highlight critical widget update lines
    if ($line -match "Background.*Widget update task started") {
        Write-Host $line -ForegroundColor Cyan
    }
    elseif ($line -match "Found \d+ total habits, (\d+) for today") {
        if ($matches[1] -match "\d+") {
            $todayCount = $matches[1]
            Write-Host $line -ForegroundColor $(if ($todayCount -eq "0") { "Red" } else { "Green" })
        }
    }
    elseif ($line -match "All \d+ habits passed the date filter") {
        Write-Host $line -ForegroundColor Red -BackgroundColor Yellow
        Write-Host "^^^ WARNING: ALL HABITS PASSED FILTER - THIS IS THE BUG! ^^^" -ForegroundColor Red -BackgroundColor Yellow
    }
    elseif ($line -match "Filtering \d+ habits for date") {
        Write-Host $line -ForegroundColor Magenta
    }
    elseif ($line -match "INCLUDED|EXCLUDED") {
        if ($line -match "INCLUDED") {
            Write-Host $line -ForegroundColor Green
        } else {
            Write-Host $line -ForegroundColor DarkGray
        }
    }
    elseif ($line -match "Saved widget data|saveWidgetData") {
        Write-Host $line -ForegroundColor Yellow
    }
    elseif ($line -match "Widget update completed") {
        Write-Host $line -ForegroundColor Green
    }
    elseif ($line -match "ERROR|Error|error") {
        Write-Host $line -ForegroundColor Red
    }
    elseif ($line -match "widget|Widget|habit|Habit") {
        Write-Host $line -ForegroundColor White
    }
}