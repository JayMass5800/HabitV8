# Isar Android Build Fix

## Problem
Isar Flutter Libs 3.1.0+1 doesn't include a `namespace` in its Android build.gradle file, which is required by Android Gradle Plugin 8.0+.

## Error Message
```
Could not create an instance of type com.android.build.api.variant.impl.LibraryVariantBuilderImpl.
Namespace not specified. Specify a namespace in the module's build file
```

## Solution
Run the `patch_isar.ps1` script after `flutter pub get` to automatically patch the isar_flutter_libs package.

### Usage
```powershell
flutter pub get
./patch_isar.ps1
flutter build apk
```

### What the Patch Does
The script adds `namespace 'io.isar.isar_flutter_libs'` to the android block in the isar_flutter_libs build.gradle file located in your pub cache.

### When to Re-run
- After running `flutter pub get`
- After running `flutter clean`
- After upgrading Flutter or Isar packages

### Alternative Solutions
1. **Downgrade to Isar 3.0.x** (doesn't have this issue)
2. **Wait for Isar 3.1.1+** (may include the fix)
3. **Use this patch script** (current recommended approach)

## Files Modified
- Created: `patch_isar.ps1` - Automated fix script
- Modified (temporarily by script): `%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\isar_flutter_libs-3.1.0+1\android\build.gradle`

## Notes
- The patch is safe and only adds the required namespace declaration
- The patch is idempotent (can be run multiple times safely)
- The patched file is in the pub cache and will be reset if you clear cache or update the package
