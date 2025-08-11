# Android Deployment Guide for HabitV8

This guide will help you deploy your HabitV8 app to the Google Play Store.

## Prerequisites

1. **Android Studio** installed with Android SDK
2. **Flutter** installed and configured
3. **Google Play Console** developer account ($25 one-time fee)
4. **Java Development Kit (JDK)** 11 or higher

## Step 1: Create a Signing Key

### Generate Upload Keystore

Run this command in your terminal (from the project root):

```powershell
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Important Notes:**
- Use a **strong password** and remember it
- Keep the keystore file **secure** - if you lose it, you can't update your app
- The alias name should be memorable (e.g., "upload" or "habitv8")
- Fill in the certificate details when prompted

### Create key.properties File

1. Copy `android/key.properties.template` to `android/key.properties`
2. Fill in your actual values:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD  
keyAlias=upload
storeFile=../upload-keystore.jks
```

**⚠️ NEVER commit key.properties to version control!**

## Step 2: Update App Information

### Update pubspec.yaml

```yaml
name: habitv8
description: "Track your habits and build better routines with HabitV8"
version: 1.0.0+1  # Update version as needed
```

### Update App Name and Icon

1. **App Name**: Already set to "HabitV8" in AndroidManifest.xml
2. **App Icon**: Update `ic_launcher.PNG` and run:
   ```powershell
   flutter pub run flutter_launcher_icons:main
   ```

## Step 3: Build Release Version

### Option A: Use the Build Script
```powershell
.\scripts\build_release.ps1
```

### Option B: Manual Build
```powershell
# Clean and get dependencies
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Build for Play Store (AAB format)
flutter build appbundle --release

# Build APK for testing
flutter build apk --release
```

## Step 4: Test Your Release Build

1. **Install the APK** on a physical device:
   ```powershell
   adb install build\app\outputs\flutter-apk\app-release.apk
   ```

2. **Test all features** thoroughly:
   - [ ] Habit creation and editing
   - [ ] Notifications
   - [ ] Calendar sync
   - [ ] Health data integration
   - [ ] Data export/import
   - [ ] Theme changes
   - [ ] All permissions work correctly

## Step 5: Prepare for Google Play Store

### Required Assets

Create these assets for your Play Store listing:

1. **App Icon**: 512x512 PNG
2. **Feature Graphic**: 1024x500 PNG
3. **Screenshots**: 
   - Phone: 16:9 or 9:16 aspect ratio
   - Tablet: 16:10 or 10:16 aspect ratio
   - At least 2, up to 8 screenshots

### App Store Listing Information

Prepare these details:

- **App Title**: "HabitV8 - Habit Tracker"
- **Short Description**: 80 characters max
- **Full Description**: 4000 characters max
- **Category**: Health & Fitness
- **Content Rating**: Complete the questionnaire
- **Privacy Policy**: Required (create one)
- **Target Age Group**: Determine appropriate rating

### Privacy Policy Requirements

Your app collects sensitive data, so you MUST have a privacy policy covering:
- Health data collection and usage
- Calendar access
- Location data (if used)
- Notification data
- Data storage and sharing practices

## Step 6: Upload to Google Play Console

1. **Create App**: Go to Google Play Console → Create App
2. **Upload AAB**: Use the `app-release.aab` file from `build\app\outputs\bundle\release\`
3. **Complete Store Listing**: Add descriptions, screenshots, etc.
4. **Set Up Pricing**: Free or paid
5. **Configure Release**: 
   - Internal testing first
   - Then closed testing (optional)
   - Finally production release

## Step 7: App Review Process

### Google Play Requirements

Ensure your app meets these requirements:

- [ ] **Target API Level**: Currently targeting API 36 ✅
- [ ] **64-bit Support**: Flutter handles this ✅
- [ ] **App Bundle Format**: Using AAB ✅
- [ ] **Privacy Policy**: Required for health apps
- [ ] **Permissions Justification**: Health permissions need explanation
- [ ] **Data Safety**: Complete in Play Console

### Health Permissions Compliance

Your app requests sensitive health permissions. Ensure:

1. **Clear Usage Description**: Explain why each permission is needed
2. **Minimal Permissions**: Only request what you actually use
3. **User Control**: Allow users to deny permissions gracefully
4. **Data Handling**: Follow health data best practices

## Step 8: Post-Launch

### Version Updates

To update your app:

1. Increment version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # 1.0.1 is version name, 2 is version code
   ```

2. Build new AAB:
   ```powershell
   flutter build appbundle --release
   ```

3. Upload to Play Console as new release

### Monitoring

- Monitor crash reports in Play Console
- Check user reviews and ratings
- Monitor app performance metrics
- Update regularly with bug fixes and features

## Troubleshooting

### Common Issues

1. **Signing Errors**: Check key.properties file paths and passwords
2. **Permission Errors**: Ensure all required permissions are in AndroidManifest.xml
3. **Build Failures**: Run `flutter clean` and try again
4. **Upload Rejected**: Check Google Play policy compliance

### Getting Help

- Flutter documentation: https://docs.flutter.dev/deployment/android
- Google Play Console Help: https://support.google.com/googleplay/android-developer
- Android Developer Documentation: https://developer.android.com/

## Security Checklist

- [ ] keystore file is secure and backed up
- [ ] key.properties is not in version control
- [ ] App uses HTTPS for any network requests
- [ ] Sensitive data is properly encrypted
- [ ] Permissions are minimal and justified
- [ ] Privacy policy is comprehensive and accurate

## Files Created/Modified

This setup created or modified these files:
- `android/app/build.gradle.kts` - Updated with signing configuration
- `android/key.properties.template` - Template for signing credentials
- `android/app/src/main/AndroidManifest.xml` - Updated app name and security settings
- `.gitignore` - Added signing files to ignore list
- `scripts/build_release.ps1` - Automated build script
- `ANDROID_DEPLOYMENT_GUIDE.md` - This guide

Remember: Keep your signing keys secure and never share them publicly!