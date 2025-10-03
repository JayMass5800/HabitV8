# Monitor all alarm-related logs including snooze/complete actions
Write-Host "=== Monitoring Alarm Logs (press Ctrl+C to stop) ===" -ForegroundColor Cyan
Write-Host "Waiting for alarm events..." -ForegroundColor Yellow
Write-Host ""

adb logcat -c  # Clear logs first

adb logcat | Select-String -Pattern "AlarmReceiver|AlarmActionReceiver|MainActivity.*alarm|MainActivity.*Snooze|flutter.*snooze|flutter.*Alarm snoozed|flutter.*Rescheduling"
