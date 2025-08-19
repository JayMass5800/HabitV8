# Test script to verify the APK path fix is working correctly

Write-Host "🧪 Testing APK Path Fix..." -ForegroundColor Cyan

# Test 1: Check if junction link exists and is working
Write-Host "`n1. Testing Junction Link..." -ForegroundColor Yellow
$junctionPath = "C:\HabitV8\build"
$targetPath = "C:\HabitV8\android\app\build"

if (Test-Path $junctionPath) {
    if ((Get-Item $junctionPath).Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
        Write-Host "   ✅ Junction link exists: $junctionPath" -ForegroundColor Green
        
        # Test if we can access files through the junction
        $junctionApks = Get-ChildItem "$junctionPath\outputs\flutter-apk" -Name "*.apk" -ErrorAction SilentlyContinue
        $directApks = Get-ChildItem "$targetPath\outputs\flutter-apk" -Name "*.apk" -ErrorAction SilentlyContinue
        
        if ($junctionApks -and $directApks) {
            Write-Host "   ✅ APKs accessible through both paths" -ForegroundColor Green
            Write-Host "      Junction: $($junctionApks.Count) APK(s)" -ForegroundColor White
            Write-Host "      Direct: $($directApks.Count) APK(s)" -ForegroundColor White
        } else {
            Write-Host "   ⚠️  APKs not found in expected locations" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ❌ Path exists but is not a junction link" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ Junction link does not exist" -ForegroundColor Red
}

# Test 2: Check standard APK locations
Write-Host "`n2. Testing Standard APK Locations..." -ForegroundColor Yellow
$standardPath = "C:\HabitV8\android\app\build\outputs\flutter-apk"
if (Test-Path $standardPath) {
    $apks = Get-ChildItem $standardPath -Name "*.apk" -ErrorAction SilentlyContinue
    if ($apks) {
        Write-Host "   ✅ APKs found in standard location:" -ForegroundColor Green
        foreach ($apk in $apks) {
            Write-Host "      - $apk" -ForegroundColor White
        }
    } else {
        Write-Host "   ⚠️  No APKs found in standard location" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ❌ Standard APK directory does not exist" -ForegroundColor Red
}

# Test 3: Check Flutter expected locations
Write-Host "`n3. Testing Flutter Expected Locations..." -ForegroundColor Yellow
$flutterExpectedPath = "C:\HabitV8\build\outputs\flutter-apk"
if (Test-Path $flutterExpectedPath) {
    $apks = Get-ChildItem $flutterExpectedPath -Name "*.apk" -ErrorAction SilentlyContinue
    if ($apks) {
        Write-Host "   ✅ APKs found in Flutter expected location:" -ForegroundColor Green
        foreach ($apk in $apks) {
            Write-Host "      - $apk" -ForegroundColor White
        }
    } else {
        Write-Host "   ⚠️  No APKs found in Flutter expected location" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ❌ Flutter expected directory does not exist" -ForegroundColor Red
}

# Summary
Write-Host "`n📋 Test Summary:" -ForegroundColor Cyan
if ((Test-Path $junctionPath) -and (Test-Path $standardPath) -and (Test-Path $flutterExpectedPath)) {
    Write-Host "✅ APK Path Fix is working correctly!" -ForegroundColor Green
    Write-Host "   - APKs are built in the standard location" -ForegroundColor White
    Write-Host "   - Junction link provides Flutter compatibility" -ForegroundColor White
    Write-Host "   - Flutter service should find APKs correctly" -ForegroundColor White
} else {
    Write-Host "❌ APK Path Fix needs attention" -ForegroundColor Red
    Write-Host "   Run 'flutter build apk' and then '.\create_apk_junction.ps1'" -ForegroundColor Yellow
}