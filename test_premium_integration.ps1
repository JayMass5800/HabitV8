#!/usr/bin/env pwsh
# Integration Test Script for Premium Features
# Simulates real-world usage scenarios

Write-Host "`n╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Premium Feature Integration Test Script  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "This script will guide you through manual testing of the premium system." -ForegroundColor White
Write-Host "You'll need a physical device or emulator with Google Play Services.`n" -ForegroundColor Yellow

# Function to wait for user confirmation
function Wait-ForUser {
    param([string]$Message)
    Write-Host "`n$Message" -ForegroundColor Yellow
    Write-Host "Press ENTER when ready to continue..." -ForegroundColor Gray
    Read-Host
}

function Show-TestResult {
    param([string]$TestName, [string]$Expected, [string]$Status)
    Write-Host "`n┌─ Test: $TestName" -ForegroundColor Magenta
    Write-Host "│  Expected: $Expected" -ForegroundColor White
    Write-Host "│  Status: " -NoNewline -ForegroundColor White
    
    if ($Status -eq "PASS") {
        Write-Host "✅ PASS" -ForegroundColor Green
    } elseif ($Status -eq "FAIL") {
        Write-Host "❌ FAIL" -ForegroundColor Red
    } else {
        Write-Host "⏳ PENDING" -ForegroundColor Yellow
    }
    Write-Host "└─────────────────────────────────────────────" -ForegroundColor Gray
}

# Pre-flight checks
Write-Host "Pre-flight Checks:" -ForegroundColor Cyan
Write-Host "─────────────────`n" -ForegroundColor Gray

Write-Host "1. Checking Flutter installation..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "   ✅ Flutter found" -ForegroundColor Green
} else {
    Write-Host "   ❌ Flutter not found in PATH" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. Checking connected devices..." -ForegroundColor Yellow
$devices = flutter devices
if ($devices -match "No devices detected") {
    Write-Host "   ❌ No devices connected" -ForegroundColor Red
    Write-Host "   Please connect a device or start an emulator." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "   ✅ Device(s) detected" -ForegroundColor Green
}

Write-Host "`n3. Checking for recent build..." -ForegroundColor Yellow
if (Test-Path "build\app\outputs") {
    Write-Host "   ✅ Build directory exists" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  No recent build found" -ForegroundColor Yellow
    Write-Host "   Building now..." -ForegroundColor White
    flutter build apk --debug
}

Write-Host "`n`n════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    INTEGRATION TEST SCENARIOS" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Scenario 1: Fresh Install
Write-Host "╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 1: Fresh Install - Trial Start     ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

Wait-ForUser "1. Uninstall the app completely from your device"
Wait-ForUser "2. Install and launch the app: flutter run"
Wait-ForUser "3. Check the app behavior"

Write-Host "`nWhat happened?" -ForegroundColor Yellow
Write-Host "a) Trial started, showing '30 days remaining' ✅" -ForegroundColor White
Write-Host "b) App is locked or showing error ❌" -ForegroundColor White
Write-Host "c) Other behavior" -ForegroundColor White

$result1 = Read-Host "`nEnter choice (a/b/c)"
if ($result1 -eq "a") {
    Show-TestResult -TestName "Fresh Install Trial" -Expected "Trial starts with 30 days" -Status "PASS"
} else {
    Show-TestResult -TestName "Fresh Install Trial" -Expected "Trial starts with 30 days" -Status "FAIL"
    Write-Host "`n⚠️  Check logs for initialization errors" -ForegroundColor Yellow
}

# Scenario 2: Navigation During Initialization
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 2: Race Condition Test             ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

Wait-ForUser "1. Keep app running from previous test"
Wait-ForUser "2. Immediately navigate to different screens rapidly"
Wait-ForUser "3. Try to access premium features (if any visible)"

Write-Host "`nWhat happened?" -ForegroundColor Yellow
Write-Host "a) No crashes, trial status shows correctly ✅" -ForegroundColor White
Write-Host "b) App crashed or showed wrong status ❌" -ForegroundColor White

$result2 = Read-Host "`nEnter choice (a/b)"
if ($result2 -eq "a") {
    Show-TestResult -TestName "Race Condition Handling" -Expected "No crashes, correct status" -Status "PASS"
} else {
    Show-TestResult -TestName "Race Condition Handling" -Expected "No crashes, correct status" -Status "FAIL"
    Write-Host "`n⚠️  Initialization race condition may still exist" -ForegroundColor Yellow
}

# Scenario 3: Trial Expiry
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 3: Trial Expiry - App Lock         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

Wait-ForUser "1. Go to Settings in the app"
Wait-ForUser "2. Scroll to 'Debug Tools' section"
Wait-ForUser "3. Tap 'Simulate Trial Expiry'"
Wait-ForUser "4. Restart the app (close and reopen)"

Write-Host "`nWhat happened?" -ForegroundColor Yellow
Write-Host "a) App shows lock screen with 'Trial Expired' message ✅" -ForegroundColor White
Write-Host "b) App still accessible or no lock screen ❌" -ForegroundColor White

$result3 = Read-Host "`nEnter choice (a/b)"
if ($result3 -eq "a") {
    Show-TestResult -TestName "Trial Expiry Lock" -Expected "App locked, upgrade prompt shown" -Status "PASS"
} else {
    Show-TestResult -TestName "Trial Expiry Lock" -Expected "App locked, upgrade prompt shown" -Status "FAIL"
}

# Scenario 4: Purchase Flow Access
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 4: Purchase Flow from Lock          ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

Wait-ForUser "1. From the lock screen, tap 'Upgrade to Premium'"
Wait-ForUser "2. Verify purchase screen opens"

Write-Host "`nWhat happened?" -ForegroundColor Yellow
Write-Host "a) Purchase screen opened successfully ✅" -ForegroundColor White
Write-Host "b) Navigation failed or error shown ❌" -ForegroundColor White

$result4 = Read-Host "`nEnter choice (a/b)"
if ($result4 -eq "a") {
    Show-TestResult -TestName "Purchase Screen Access" -Expected "Screen opens from lock" -Status "PASS"
} else {
    Show-TestResult -TestName "Purchase Screen Access" -Expected "Screen opens from lock" -Status "FAIL"
}

# Scenario 5: Device Loss Recovery (CRITICAL)
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║  SCENARIO 5: Device Loss Recovery (CRITICAL)  ║" -ForegroundColor Red
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Red

Write-Host "`n⚠️  NOTE: This test requires an actual purchase or test purchase" -ForegroundColor Yellow
Write-Host "Skip if you don't have a test account set up in Play Console`n" -ForegroundColor Yellow

$doPurchaseTest = Read-Host "Do you want to test purchase restoration? (y/n)"

if ($doPurchaseTest -eq "y") {
    Wait-ForUser "1. Make a test purchase (or use existing purchase)"
    Wait-ForUser "2. Verify premium access is granted"
    Wait-ForUser "3. Note: Premium features unlocked, no app lock"
    Wait-ForUser "4. Uninstall the app completely"
    Wait-ForUser "5. Reinstall: flutter run"
    Wait-ForUser "6. Wait 5-10 seconds after app loads"
    
    Write-Host "`nWhat happened?" -ForegroundColor Yellow
    Write-Host "a) Premium restored automatically, no lock screen ✅" -ForegroundColor White
    Write-Host "b) Trial expired lock shown, need manual restore ❌" -ForegroundColor White
    Write-Host "c) App crashed or other error ❌" -ForegroundColor White
    
    $result5 = Read-Host "`nEnter choice (a/b/c)"
    if ($result5 -eq "a") {
        Show-TestResult -TestName "Device Loss Recovery" -Expected "Automatic premium restoration" -Status "PASS"
        Write-Host "`n🎉 CRITICAL TEST PASSED - P0 fix working!" -ForegroundColor Green
    } else {
        Show-TestResult -TestName "Device Loss Recovery" -Expected "Automatic premium restoration" -Status "FAIL"
        Write-Host "`n⚠️  CRITICAL ISSUE - P0 fix may not be working!" -ForegroundColor Red
        Write-Host "Check logcat for 'PurchaseStreamService' and 'Global purchase update' messages" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n⏭️  Skipping purchase restoration test" -ForegroundColor Gray
}

# Scenario 6: Manual Restore
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 6: Manual Restore Purchases         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

$doManualRestore = Read-Host "Do you want to test manual restore? (y/n)"

if ($doManualRestore -eq "y") {
    Wait-ForUser "1. Ensure app is at trial expired lock screen"
    Wait-ForUser "2. Tap 'Restore Purchases' button"
    Wait-ForUser "3. Wait for restore to complete"
    
    Write-Host "`nWhat happened?" -ForegroundColor Yellow
    Write-Host "a) Premium restored, app unlocked ✅" -ForegroundColor White
    Write-Host "b) 'No purchases found' message (if no purchase) ✅" -ForegroundColor White
    Write-Host "c) Error or crash ❌" -ForegroundColor White
    
    $result6 = Read-Host "`nEnter choice (a/b/c)"
    if ($result6 -eq "a" -or $result6 -eq "b") {
        Show-TestResult -TestName "Manual Restore" -Expected "Restore works or reports no purchases" -Status "PASS"
    } else {
        Show-TestResult -TestName "Manual Restore" -Expected "Restore works or reports no purchases" -Status "FAIL"
    }
} else {
    Write-Host "`n⏭️  Skipping manual restore test" -ForegroundColor Gray
}

# Scenario 7: Log Verification
Write-Host "`n`n╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  SCENARIO 7: Log Verification                 ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`nChecking for critical log messages..." -ForegroundColor Yellow
Write-Host "(This requires the app to have been run with flutter run)`n" -ForegroundColor Gray

Write-Host "Look for these messages in the console above:" -ForegroundColor White
Write-Host "  ✅ 'PurchaseStreamService initialized successfully'" -ForegroundColor Green
Write-Host "  ✅ 'SubscriptionService initialized successfully'" -ForegroundColor Green
Write-Host "  ✅ 'Purchase restoration check completed'" -ForegroundColor Green

$seeLogs = Read-Host "`nDid you see these initialization messages? (y/n)"
if ($seeLogs -eq "y") {
    Show-TestResult -TestName "Initialization Logs" -Expected "All services initialized" -Status "PASS"
} else {
    Show-TestResult -TestName "Initialization Logs" -Expected "All services initialized" -Status "FAIL"
}

# Final Summary
Write-Host "`n`n════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    TEST SUMMARY" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Manual tests completed. Review results above." -ForegroundColor White
Write-Host "`nIf any tests failed:" -ForegroundColor Yellow
Write-Host "1. Check flutter logs for error messages" -ForegroundColor White
Write-Host "2. Verify all fixes are present: .\test_premium_fixes.ps1" -ForegroundColor White
Write-Host "3. Review PREMIUM_FIXES_DOCUMENTATION.md" -ForegroundColor White
Write-Host "4. Check logcat: adb logcat | Select-String 'PurchaseStream|Subscription'" -ForegroundColor White

Write-Host "`nFor detailed logs, run:" -ForegroundColor Yellow
Write-Host "  adb logcat -s flutter" -ForegroundColor Gray

Write-Host "`n✨ Integration testing complete!" -ForegroundColor Green
Write-Host "See PREMIUM_FIXES_SUMMARY.md for next steps.`n" -ForegroundColor White
