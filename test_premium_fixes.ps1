#!/usr/bin/env pwsh
# Premium Feature & Purchase Logic Test Script
# Tests all fixes for the subscription and purchase system

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Premium Feature & Purchase Logic Tests" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$testsPassed = 0
$testsFailed = 0
$warnings = 0

function Test-FileExists {
    param([string]$FilePath, [string]$Description)
    
    Write-Host "Testing: $Description" -ForegroundColor Yellow
    if (Test-Path $FilePath) {
        Write-Host "  ✅ PASS: File exists" -ForegroundColor Green
        $script:testsPassed++
        return $true
    } else {
        Write-Host "  ❌ FAIL: File not found" -ForegroundColor Red
        $script:testsFailed++
        return $false
    }
}

function Test-CodePattern {
    param(
        [string]$FilePath,
        [string]$Pattern,
        [string]$Description,
        [bool]$ShouldExist = $true
    )
    
    Write-Host "Testing: $Description" -ForegroundColor Yellow
    
    if (-not (Test-Path $FilePath)) {
        Write-Host "  ❌ FAIL: File not found" -ForegroundColor Red
        $script:testsFailed++
        return $false
    }
    
    $content = Get-Content $FilePath -Raw
    $found = $content -match $Pattern
    
    if ($ShouldExist -eq $found) {
        Write-Host "  ✅ PASS: Pattern check succeeded" -ForegroundColor Green
        $script:testsPassed++
        return $true
    } else {
        if ($ShouldExist) {
            Write-Host "  ❌ FAIL: Expected pattern not found" -ForegroundColor Red
        } else {
            Write-Host "  ❌ FAIL: Pattern should not exist but was found" -ForegroundColor Red
        }
        $script:testsFailed++
        return $false
    }
}

function Test-Warning {
    param([string]$Message)
    Write-Host "  ⚠️  WARNING: $Message" -ForegroundColor Yellow
    $script:warnings++
}

# Test 1: Verify new PurchaseStreamService exists
Write-Host "`n📦 Test 1: PurchaseStreamService Creation" -ForegroundColor Magenta
Test-FileExists -FilePath "lib\services\purchase_stream_service.dart" `
    -Description "PurchaseStreamService file exists"

# Test 2: Verify PurchaseStreamService has required methods
Write-Host "`n📦 Test 2: PurchaseStreamService Implementation" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "static Future<void> initialize\(\)" `
    -Description "PurchaseStreamService has initialize() method"

Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "_inAppPurchase\.purchaseStream\.listen" `
    -Description "PurchaseStreamService sets up purchase stream listener"

Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "_processCompletedPurchase" `
    -Description "PurchaseStreamService processes completed purchases"

# Test 3: Verify main.dart imports PurchaseStreamService
Write-Host "`n📦 Test 3: main.dart Integration" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\main.dart" `
    -Pattern "import.*purchase_stream_service\.dart" `
    -Description "main.dart imports PurchaseStreamService"

Test-CodePattern -FilePath "lib\main.dart" `
    -Pattern "await PurchaseStreamService\.initialize\(\)" `
    -Description "main.dart initializes PurchaseStreamService before restorePurchases"

# Test 4: Verify initialization order is correct
Write-Host "`n📦 Test 4: Critical Initialization Order" -ForegroundColor Magenta
$mainContent = Get-Content "lib\main.dart" -Raw

# Find positions of critical calls
$purchaseStreamInit = [regex]::Match($mainContent, "PurchaseStreamService\.initialize").Index
$restorePurchases = [regex]::Match($mainContent, "restorePurchases\(\)").Index

if ($purchaseStreamInit -gt 0 -and $restorePurchases -gt 0) {
    if ($purchaseStreamInit -lt $restorePurchases) {
        Write-Host "  ✅ PASS: PurchaseStreamService.initialize() called BEFORE restorePurchases()" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "  ❌ FAIL: PurchaseStreamService.initialize() called AFTER restorePurchases() - CRITICAL BUG!" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "  ❌ FAIL: Could not verify initialization order" -ForegroundColor Red
    $testsFailed++
}

# Test 5: Verify SubscriptionService has initialization completer
Write-Host "`n📦 Test 5: SubscriptionService Race Condition Fix" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "Completer<void>\?" `
    -Description "SubscriptionService has initialization completer"

Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "_ensureInitialized" `
    -Description "SubscriptionService has _ensureInitialized() method"

Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "await _ensureInitialized\(\)" `
    -Description "getSubscriptionStatus() waits for initialization"

# Test 6: Verify trial days calculation fix
Write-Host "`n📦 Test 6: Trial Days Calculation Improvement" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "hoursSinceTrialStart.*inHours" `
    -Description "Trial calculation uses hours instead of days for precision"

Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "\(hoursSinceTrialStart / 24\)\.floor\(\)" `
    -Description "Days calculated from hours with proper rounding"

# Test 7: Verify timestamp validation relaxation
Write-Host "`n📦 Test 7: Purchase Timestamp Validation Fix" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\ui\screens\purchase_screen.dart" `
    -Pattern "timeDifference\.inDays > 30" `
    -Description "Timestamp validation changed to 30 days (was 24 hours)"

Test-CodePattern -FilePath "lib\ui\screens\purchase_screen.dart" `
    -Pattern "timeDifference\.inHours > 24" `
    -Description "Old 24-hour check removed" `
    -ShouldExist $false

# Test 8: Verify duplicate restorePurchases call removed
Write-Host "`n📦 Test 8: Duplicate restorePurchases() Removal" -ForegroundColor Magenta
$purchaseScreenContent = Get-Content "lib\ui\screens\purchase_screen.dart" -Raw
$restoreCount = ([regex]::Matches($purchaseScreenContent, "restorePurchases\(\)")).Count

Write-Host "Testing: Count of restorePurchases() calls in purchase_screen.dart" -ForegroundColor Yellow
if ($restoreCount -le 1) {
    Write-Host "  ✅ PASS: Only 1 or fewer restorePurchases() calls found (expected: 1 in _handleRestore)" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  ⚠️  WARNING: Found $restoreCount restorePurchases() calls (expected: 1)" -ForegroundColor Yellow
    Test-Warning "Multiple restorePurchases() calls may cause unnecessary API requests"
}

# Test 9: Verify build compiles without errors
Write-Host "`n📦 Test 9: Dart Analysis" -ForegroundColor Magenta
Write-Host "Running: flutter analyze" -ForegroundColor Yellow

$analyzeOutput = flutter analyze 2>&1
$analyzeExitCode = $LASTEXITCODE

if ($analyzeExitCode -eq 0) {
    Write-Host "  ✅ PASS: No analysis errors" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  ❌ FAIL: Analysis found issues" -ForegroundColor Red
    Write-Host $analyzeOutput -ForegroundColor Gray
    $testsFailed++
}

# Test 10: Check for any TODO or FIXME comments related to purchase logic
Write-Host "`n📦 Test 10: Code Quality Check" -ForegroundColor Magenta
Write-Host "Testing: Checking for unresolved TODOs in modified files" -ForegroundColor Yellow

$todoFiles = @(
    "lib\services\subscription_service.dart",
    "lib\services\purchase_stream_service.dart",
    "lib\ui\screens\purchase_screen.dart",
    "lib\ui\widgets\premium_feature_guard.dart"
)

$todosFound = 0
foreach ($file in $todoFiles) {
    if (Test-Path $file) {
        $todos = Select-String -Path $file -Pattern "TODO|FIXME" -CaseSensitive
        if ($todos) {
            $todosFound += $todos.Count
        }
    }
}

if ($todosFound -eq 0) {
    Write-Host "  ✅ PASS: No unresolved TODOs or FIXMEs" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  ⚠️  INFO: Found $todosFound TODO/FIXME comments" -ForegroundColor Yellow
    Test-Warning "Review TODO/FIXME comments to ensure nothing critical is pending"
}

# Test 11: Verify imports are correct
Write-Host "`n📦 Test 11: Import Verification" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "import.*in_app_purchase" `
    -Description "PurchaseStreamService imports in_app_purchase"

Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "import.*subscription_service" `
    -Description "PurchaseStreamService imports SubscriptionService"

# Test 12: Verify error handling
Write-Host "`n📦 Test 12: Error Handling" -ForegroundColor Magenta
Test-CodePattern -FilePath "lib\services\purchase_stream_service.dart" `
    -Pattern "try\s*\{[\s\S]*catch" `
    -Description "PurchaseStreamService has error handling"

Test-CodePattern -FilePath "lib\services\subscription_service.dart" `
    -Pattern "_initializationCompleter!\.completeError" `
    -Description "SubscriptionService handles initialization errors"

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Tests Passed: $testsPassed" -ForegroundColor Green
Write-Host "❌ Tests Failed: $testsFailed" -ForegroundColor Red
Write-Host "⚠️  Warnings: $warnings" -ForegroundColor Yellow
Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "🎉 All tests passed! The fixes are correctly implemented." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Run: flutter test (if unit tests exist)" -ForegroundColor White
    Write-Host "2. Build and test on device: flutter run" -ForegroundColor White
    Write-Host "3. Test purchase restoration scenario:" -ForegroundColor White
    Write-Host "   - Install app and make purchase" -ForegroundColor Gray
    Write-Host "   - Uninstall app" -ForegroundColor Gray
    Write-Host "   - Reinstall and verify premium is restored automatically" -ForegroundColor Gray
    Write-Host ""
    exit 0
} else {
    Write-Host "⚠️  Some tests failed. Please review the issues above." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
