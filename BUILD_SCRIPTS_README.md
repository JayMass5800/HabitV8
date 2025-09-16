# Flutter Build Number & Version Management Scripts

This directory contains several PowerShell scripts to automate version management and building for your Flutter project.

## Scripts Overview

### 1. `increment_build_number.ps1` - Simple Build Number Incrementer
**Purpose**: Automatically increment the patch version and build number.

**Usage**:
```powershell
# Auto-increment patch version (8.2.0 → 8.2.1) and reset build to 10
./increment_build_number.ps1

# Set specific version and increment build number
./increment_build_number.ps1 -NewVersion "8.3.0"

# Only increment build number (no version change)
./increment_build_number.ps1 -OnlyBuild
```

**Features**:
- ✅ **Auto-increments patch version by default** (8.2.0 → 8.2.1)
- ✅ Resets build number to 10 for new versions
- ✅ Can increment only build number with `-OnlyBuild`
- ✅ Can set specific version with `-NewVersion`
- ✅ Runs `flutter pub get` automatically
- ✅ Clear success/error messages

---

### 2. `build_with_version_bump.ps1` - Complete Build & Version Manager
**Purpose**: Automatically increment patch version/build number AND build the app in one command.

**Usage**:
```powershell
# Auto-increment patch version and build APK
./build_with_version_bump.ps1

# Auto-increment patch version and build App Bundle (AAB)
./build_with_version_bump.ps1 -BuildType aab

# Set specific version and build
./build_with_version_bump.ps1 -NewVersion "8.3.0" -BuildType aab

# Only increment build number (no version change) and build
./build_with_version_bump.ps1 -OnlyBuild -BuildType aab

# Only increment version, don't build
./build_with_version_bump.ps1 -SkipBuild

# Build debug version with auto-version increment
./build_with_version_bump.ps1 -Debug
```

**Build Types Supported**:
- `apk` - Android APK
- `aab` - Android App Bundle (recommended for Play Store)
- `ios` - iOS build
- `web` - Web build

**Features**:
- ✅ **Auto-increments patch version by default** (8.2.0 → 8.2.1)
- ✅ Resets build number to 10 for new versions
- ✅ Can increment only build number with `-OnlyBuild`
- ✅ Supports all Flutter build types
- ✅ Shows build time and output file size
- ✅ Can skip building if you only want version bump
- ✅ Debug and release builds

---

### 3. `bump_version.ps1` - Simple Version Utility
**Purpose**: Quick version bump that can be called from other scripts.

**Usage**:
```powershell
# Auto-increment patch version (8.2.0 → 8.2.1) and reset build to 10
./bump_version.ps1

# Set specific version and reset build to 10
./bump_version.ps1 -Version "8.3.0"

# Only increment build number (no version change)
./bump_version.ps1 -OnlyBuild
```

**Features**:
- ✅ **Auto-increments patch version by default**
- ✅ Resets build number to 10 for new versions
- ✅ Minimal output (good for scripting)
- ✅ Returns new version string
- ✅ Can be integrated into other workflows

---

### 4. `quick_build.bat` - One-Click Windows Build
**Purpose**: Double-click to build App Bundle with incremented build number.

**Usage**: Just double-click the file in Windows Explorer.

---

## Integration with Flutter Commands

You can still use Flutter's built-in version options with your existing build commands:

```bash
# Using Flutter CLI directly (manual version management)
flutter build appbundle --build-number=12 --build-name=8.2.1

# Using our automated scripts (automatic version management)
./build_with_version_bump.ps1 -BuildType aab
```

## Example Workflows

### For Development Builds
```powershell
# Quick auto-increment patch version and APK build
./build_with_version_bump.ps1

# Debug build for testing (with version increment)
./build_with_version_bump.ps1 -Debug

# Only increment build number (no version change) for testing
./build_with_version_bump.ps1 -OnlyBuild -Debug
```

### For Release Builds
```powershell
# Release App Bundle for Play Store (auto-increment patch version)
./build_with_version_bump.ps1 -BuildType aab

# Major version update
./build_with_version_bump.ps1 -NewVersion "9.0.0" -BuildType aab

# Minor version update
./build_with_version_bump.ps1 -NewVersion "8.3.0" -BuildType aab
```

### Version Management Only
```powershell
# Auto-increment patch version (8.2.0 → 8.2.1, build reset to 10)
./increment_build_number.ps1

# Only increment build number for hotfixes
./increment_build_number.ps1 -OnlyBuild

# Major feature release
./increment_build_number.ps1 -NewVersion "9.0.0"
```

## Current Version

Your current version is displayed at the top of `pubspec.yaml`:
```yaml
version: 8.2.1+1
```

Where:
- `8.2.1` = Version name (major.minor.patch) - **displayed to users**
- `1` = Build number (versionCode) - **used by app stores**

## 🚨 **CRITICAL: Google Play Store Build Numbers**

**The Google Play Store only cares about the BUILD NUMBER (the number after +), NOT the version name!**

- ✅ **Correct**: `8.1.0+10` → `8.2.0+11` → `9.0.0+12`
- ❌ **Wrong**: `8.1.0+10` → `8.2.0+10` (Play Store rejects: "Version code 10 already used")

**Key Rules**:
1. **Build number must ALWAYS increase** across all uploads
2. **Build number can NEVER be reused**, even for different version names
3. **Version name can be anything** (users see this, stores don't care)

**Fixed Behavior**:
- Scripts now **ALWAYS increment build number** from current value
- **No more resetting** build numbers when version changes
- Ensures Play Store compatibility

**New Default Behavior**:
- Running scripts will auto-increment patch version AND increment build number: `8.2.0+11` → `8.2.1+12`
- Use `-OnlyBuild` flag to keep same version: `8.2.0+11` → `8.2.0+12`
- Use `-NewVersion "X.Y.Z"` for specific version: `8.2.0+11` → `9.0.0+12`

**Version Strategy**:
- **Patch increment** (8.2.0 → 8.2.1): Bug fixes, small updates
- **Minor increment** (8.2.0 → 8.3.0): New features, non-breaking changes  
- **Major increment** (8.2.0 → 9.0.0): Breaking changes, major releases

## Tips

1. **App Store Releases**: Use App Bundle (`.aab`) format:
   ```powershell
   ./build_with_version_bump.ps1 -BuildType aab
   ```

2. **Testing Builds**: Use debug builds for faster compilation:
   ```powershell
   ./build_with_version_bump.ps1 -Debug
   ```

3. **Version Planning**: Update version for feature releases:
   ```powershell
   ./build_with_version_bump.ps1 -NewVersion "8.3.0"
   ```

4. **CI/CD Integration**: The `bump_version.ps1` script outputs the new version string for automation.

---

## Troubleshooting

**PowerShell Execution Policy Error**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Flutter Not Found**:
Ensure Flutter is in your PATH or run from a terminal where `flutter` command works.

**Permission Errors**:
Run PowerShell as Administrator if you get file permission errors.