# Patch isar_flutter_libs to add namespace for Android Gradle Plugin 8+
$isarPath = "$env:LOCALAPPDATA\Pub\Cache\hosted\pub.dev\isar_flutter_libs-3.1.0+1\android\build.gradle"

if (Test-Path $isarPath) {
    $content = Get-Content $isarPath -Raw
    
    # Check if namespace already added
    if ($content -notmatch 'namespace\s*=') {
        Write-Host "Patching isar_flutter_libs build.gradle..."
        
        # Add namespace after 'android {' line
        $content = $content -replace '(android\s*\{)', "`$1`n    namespace 'io.isar.isar_flutter_libs'"
        
        Set-Content -Path $isarPath -Value $content -NoNewline
        Write-Host "✅ Isar package patched successfully!"
    } else {
        Write-Host "✅ Isar package already patched"
    }
} else {
    Write-Host "❌ Isar package not found at: $isarPath"
    Write-Host "Run 'flutter pub get' first"
}
