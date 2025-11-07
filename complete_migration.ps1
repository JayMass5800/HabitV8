# Complete Migration to PreferencesService
Write-Host "Starting PreferencesService migration..." -ForegroundColor Cyan

# Define file mappings with their import paths
$fileMappings = @{
    "lib\services\subscription_service.dart" = "import 'preferences_service.dart';"
    "lib\services\achievements_service.dart" = "import 'preferences_service.dart';"
    "lib\services\theme_service.dart" = "import 'preferences_service.dart';"
    "lib\services\notifications\notification_storage.dart" = "import '../preferences_service.dart';"
    "lib\services\reliable_scheduling_service.dart" = "import 'preferences_service.dart';"
    "lib\services\alarm_service.dart" = "import 'preferences_service.dart';"
    "lib\ui\widgets\ai_insights_notification_service.dart" = "import '../../services/preferences_service.dart';"
    "lib\services\onboarding_service.dart" = "import 'preferences_service.dart';"
    "lib\main.dart" = "import 'services/preferences_service.dart';"
    "lib\services\midnight_habit_reset_service.dart" = "import 'preferences_service.dart';"
    "lib\ui\screens\settings_screen.dart" = "import '../../services/preferences_service.dart';"
    "lib\utils\notification_migration.dart" = "import '../services/preferences_service.dart';"
    "lib\ui\widgets\ai_insights_onboarding.dart" = "import '../../services/preferences_service.dart';"
    "lib\services\widget_integration_service.dart" = "import 'preferences_service.dart';"
    "lib\services\app_lifecycle_service.dart" = "import 'preferences_service.dart';"
}

$totalFixed = 0

foreach ($file in $fileMappings.Keys) {
    if (!(Test-Path $file)) {
        Write-Host "  ✗ File not found: $file" -ForegroundColor Red
        continue
    }
    
    Write-Host "`nProcessing: $file" -ForegroundColor Yellow
    $content = Get-Content $file -Raw
    $originalContent = $content
    $importStatement = $fileMappings[$file]
    
    # Step 1: Add import if missing
    if ($content -notmatch [regex]::Escape($importStatement)) {
        # Find last import line
        if ($content -match "(?s)(import [^;]+;)(\s*)(?!import)") {
            $lastImport = $matches[1]
            $whitespace = $matches[2]
            $content = $content -replace [regex]::Escape("$lastImport$whitespace"), "$lastImport`n$importStatement$whitespace"
            Write-Host "  + Added import" -ForegroundColor Green
        }
    }
    
    # Step 2: Replace all SharedPreferences.getInstance() patterns
    $replacements = 0
    
    # Pattern: final prefs = await SharedPreferences.getInstance();
    while ($content -match 'final prefs = await SharedPreferences\.getInstance\(\);\s*\n') {
        $content = $content -replace 'final prefs = await SharedPreferences\.getInstance\(\);\s*\n', ''
        $replacements++
    }
    
    # Pattern: prefs.getString('key') ?? 'default'
    $content = $content -creplace '(?<!await )prefs\.getString\(([^)]+)\)\s*\?\?\s*([^;,\)]+)', 'await PreferencesService.getStringOrDefault($1, $2)'
    $content = $content -creplace '(?<!await )prefs\.getInt\(([^)]+)\)\s*\?\?\s*([^;,\)]+)', 'await PreferencesService.getIntOrDefault($1, $2)'
    $content = $content -creplace '(?<!await )prefs\.getBool\(([^)]+)\)\s*\?\?\s*([^;,\)]+)', 'await PreferencesService.getBoolOrDefault($1, $2)'
    $content = $content -creplace '(?<!await )prefs\.getDouble\(([^)]+)\)\s*\?\?\s*([^;,\)]+)', 'await PreferencesService.getDoubleOrDefault($1, $2)'
    
    # Pattern: prefs.getString('key')
    $content = $content -creplace '(?<!await )prefs\.getString\(([^)]+)\)', 'await PreferencesService.getString($1)'
    $content = $content -creplace '(?<!await )prefs\.getInt\(([^)]+)\)', 'await PreferencesService.getInt($1)'
    $content = $content -creplace '(?<!await )prefs\.getBool\(([^)]+)\)', 'await PreferencesService.getBool($1)'
    $content = $content -creplace '(?<!await )prefs\.getDouble\(([^)]+)\)', 'await PreferencesService.getDouble($1)'
    $content = $content -creplace '(?<!await )prefs\.getStringList\(([^)]+)\)', 'await PreferencesService.getStringList($1)'
    $content = $content -creplace '(?<!await )prefs\.getKeys\(\)', 'await PreferencesService.getKeys()'
    
    # Pattern: await prefs.setString('key', value)
    $content = $content -creplace 'await prefs\.setString\(([^)]+)\)', 'await PreferencesService.setString($1)'
    $content = $content -creplace 'await prefs\.setInt\(([^)]+)\)', 'await PreferencesService.setInt($1)'
    $content = $content -creplace 'await prefs\.setBool\(([^)]+)\)', 'await PreferencesService.setBool($1)'
    $content = $content -creplace 'await prefs\.setDouble\(([^)]+)\)', 'await PreferencesService.setDouble($1)'
    $content = $content -creplace 'await prefs\.setStringList\(([^)]+)\)', 'await PreferencesService.setStringList($1)'
    $content = $content -creplace 'await prefs\.remove\(([^)]+)\)', 'await PreferencesService.remove($1)'
    $content = $content -creplace 'await prefs\.containsKey\(([^)]+)\)', 'await PreferencesService.containsKey($1)'
    
    if ($content -ne $originalContent) {
        Set-Content $file -Value $content -NoNewline
        Write-Host "  ✓ Migrated successfully" -ForegroundColor Green
        $totalFixed++
    } else {
        Write-Host "  - No changes needed" -ForegroundColor Gray
    }
}

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "Migration Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Files migrated: $totalFixed of $($fileMappings.Count)" -ForegroundColor White

Write-Host "`nRunning flutter analyze..." -ForegroundColor Cyan
flutter analyze --no-fatal-infos --no-fatal-warnings
