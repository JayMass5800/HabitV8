#!/usr/bin/env pwsh
# AI Insights Diagnostic Script
# Run this after starting the app with: flutter run > app_logs.txt 2>&1

Write-Host "=== AI Insights Diagnostic ===" -ForegroundColor Cyan
Write-Host ""

# Check if app_logs.txt exists
if (Test-Path "app_logs.txt") {
    Write-Host "✓ Found app_logs.txt" -ForegroundColor Green
    Write-Host ""
    
    # Check for Gemini API requests
    Write-Host "1. Checking for Gemini API requests..." -ForegroundColor Yellow
    $geminiRequests = Select-String -Path "app_logs.txt" -Pattern "GEMINI API REQUEST" -Context 0,10
    if ($geminiRequests) {
        Write-Host "✓ Found Gemini API requests:" -ForegroundColor Green
        $geminiRequests | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "✗ No Gemini API requests found" -ForegroundColor Red
    }
    Write-Host ""
    
    # Check for habit summary
    Write-Host "2. Checking for enhanced habit summary..." -ForegroundColor Yellow
    $habitSummary = Select-String -Path "app_logs.txt" -Pattern "TEMPORAL PATTERNS|DIFFICULTY ANALYSIS|CATEGORY PERFORMANCE" -Context 0,2
    if ($habitSummary) {
        Write-Host "✓ Found enhanced habit summary:" -ForegroundColor Green
        $habitSummary | Select-Object -First 5 | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "✗ No enhanced habit summary found" -ForegroundColor Red
    }
    Write-Host ""
    
    # Check for Gemini responses
    Write-Host "3. Checking for Gemini API responses..." -ForegroundColor Yellow
    $geminiResponses = Select-String -Path "app_logs.txt" -Pattern "GEMINI API RESPONSE|Parsed.*insights" -Context 0,5
    if ($geminiResponses) {
        Write-Host "✓ Found Gemini API responses:" -ForegroundColor Green
        $geminiResponses | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "✗ No Gemini API responses found" -ForegroundColor Red
    }
    Write-Host ""
    
    # Check for parsed insights
    Write-Host "4. Checking for parsed insight titles..." -ForegroundColor Yellow
    $insightTitles = Select-String -Path "app_logs.txt" -Pattern "Insight \d+:" -Context 0,0
    if ($insightTitles) {
        Write-Host "✓ Found insight titles:" -ForegroundColor Green
        $insightTitles | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "✗ No insight titles found" -ForegroundColor Red
    }
    Write-Host ""
    
    # Check for AI configuration status
    Write-Host "5. Checking AI configuration..." -ForegroundColor Yellow
    $aiConfig = Select-String -Path "app_logs.txt" -Pattern "AI configured:|Gemini API key" -Context 0,1
    if ($aiConfig) {
        Write-Host "✓ Found AI configuration info:" -ForegroundColor Green
        $aiConfig | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "⚠ No AI configuration info found" -ForegroundColor Yellow
    }
    Write-Host ""
    
    # Summary
    Write-Host "=== Summary ===" -ForegroundColor Cyan
    Write-Host "If you see ✓ for items 1-4, the enhanced system is working!" -ForegroundColor Green
    Write-Host "If you see ✗, please share the relevant log sections." -ForegroundColor Yellow
    
} else {
    Write-Host "✗ app_logs.txt not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "To capture logs, run:" -ForegroundColor Yellow
    Write-Host "  flutter run > app_logs.txt 2>&1" -ForegroundColor White
    Write-Host ""
    Write-Host "Then navigate to the Insights screen in the app." -ForegroundColor Yellow
    Write-Host "After that, run this script again." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Alternative: Check Current Logs ===" -ForegroundColor Cyan
Write-Host "If the app is already running, check your terminal/console for:" -ForegroundColor Yellow
Write-Host "  - 'GEMINI API REQUEST'" -ForegroundColor White
Write-Host "  - 'TEMPORAL PATTERNS'" -ForegroundColor White
Write-Host "  - 'GEMINI API RESPONSE'" -ForegroundColor White
Write-Host "  - 'Parsed X insights from Gemini'" -ForegroundColor White
Write-Host "  - 'Insight 1: [Title]'" -ForegroundColor White
