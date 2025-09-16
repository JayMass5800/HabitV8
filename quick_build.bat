@echo off
REM Quick batch file to increment build number and build release APK
echo Building HabitV8 with incremented build number...
powershell.exe -ExecutionPolicy Bypass -File "build_with_version_bump.ps1" -BuildType "aab"
pause