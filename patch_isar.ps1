# Patch isar_flutter_libs to add namespace for Android Gradle Plugin 8+
$isarGradlePath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\isar_flutter_libs-3.1.0+1\android\build.gradle"
$isarManifestPath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\isar_flutter_libs-3.1.0+1\android\src\main\AndroidManifest.xml"

# Patch build.gradle to add namespace and update compileSdk
if (Test-Path $isarGradlePath) {
    $content = Get-Content $isarGradlePath -Raw
    
    $patched = $false
    
    # Check if namespace already added
    if ($content -notmatch 'namespace\s*=') {
        Write-Host "Patching isar_flutter_libs build.gradle (adding namespace)..."
        
        # Add namespace after 'android {' line
        $content = $content -replace '(android\s*\{)', "`$1`n    namespace 'io.isar.isar_flutter_libs'"
        $patched = $true
    }
    
    # Update compileSdk to 34 (to support lStar attribute)
    if ($content -match 'compileSdkVersion\s+\d+' -and $content -notmatch 'compileSdkVersion\s+(34|35|36)') {
        Write-Host "Patching isar_flutter_libs build.gradle (updating compileSdk to 34)..."
        $content = $content -replace 'compileSdkVersion\s+\d+', 'compileSdkVersion 34'
        $patched = $true
    }
    
    if ($patched) {
        Set-Content -Path $isarGradlePath -Value $content -NoNewline
        Write-Host "✅ Isar package build.gradle patched successfully!"
    } else {
        Write-Host "✅ Isar package build.gradle already patched"
    }
} else {
    Write-Host "❌ Isar package not found at: $isarGradlePath"
    Write-Host "Run 'flutter pub get' first"
}

# Patch AndroidManifest.xml to remove package attribute
if (Test-Path $isarManifestPath) {
    $manifestContent = Get-Content $isarManifestPath -Raw
    
    # Check if package attribute exists
    if ($manifestContent -match 'package="dev\.isar\.isar_flutter_libs"') {
        Write-Host "Patching isar_flutter_libs AndroidManifest.xml..."
        
        # Remove package attribute from manifest tag
        $manifestContent = $manifestContent -replace '\s*package="dev\.isar\.isar_flutter_libs"', ''
        
        Set-Content -Path $isarManifestPath -Value $manifestContent -NoNewline
        Write-Host "✅ Isar package AndroidManifest.xml patched successfully!"
    } else {
        Write-Host "✅ Isar package AndroidManifest.xml already patched"
    }
} else {
    Write-Host "⚠️ AndroidManifest.xml not found at: $isarManifestPath"
}

Write-Host "`n🎉 All Isar patches applied successfully!"
