# Google Play Health Permissions Issue - Root Cause and Solution

## Root Cause Analysis

The issue is **NOT** that the health plugin is adding extra permissions to your manifest. The merged manifest shows only the 7 health permissions you declared.

The real issue is that **Google Play Console's static analysis** detects:

1. **HealthDataSdkService** - An exported service that can bind to Health Connect
2. **Health Plugin Code** - Contains references to all possible health data types
3. **Metadata Analysis** - The health_permissions array and service declarations suggest broader access capability

Even though you only declare 6 specific permissions, Google Play sees your app has the **infrastructure** to potentially access much more health data.

## The Solution

### 1. Limit Health Permissions Array (DONE)
- Removed background health access from the health_permissions array
- This array tells Google Play what permissions your app might request

### 2. Add Explicit Permission Removal (DONE)
- Added `tools:node="remove"` for unwanted health permissions
- This prevents any transitive dependencies from adding permissions

### 3. Additional Steps You Should Take

#### A. Update Your Google Play Console Submission

When submitting to Google Play Console:

1. **In the "App Content" section**, go to "Data Safety"
2. **Explicitly declare** only the 6 health data types you use:
   - Steps
   - Active calories burned
   - Sleep duration
   - Water intake
   - Mindfulness/meditation
   - Weight

3. **In the permission declaration**, provide clear justification:
   ```
   This app only accesses 6 specific health data types for habit tracking:
   - Steps: To auto-complete walking/running habits
   - Active calories: To auto-complete exercise habits  
   - Sleep: To auto-complete sleep habits
   - Water: To auto-complete hydration habits
   - Mindfulness: To auto-complete meditation habits
   - Weight: To auto-complete weight tracking habits
   
   All data is processed locally on device for habit completion only.
   No health data is transmitted to servers or third parties.
   ```

#### B. Consider Using a More Limited Health Plugin

The current `health` plugin (13.1.1) includes infrastructure for all health data types. Consider:

1. **Downgrading** to an earlier version that has less comprehensive health support
2. **Using a custom implementation** that only supports your 6 data types
3. **Forking the health plugin** and removing unused health data type support

#### C. Build and Test

After making these changes:

1. **Clean build**: `flutter clean && flutter pub get`
2. **Build new AAB**: `flutter build appbundle --release`
3. **Test the new AAB** in Google Play Console's pre-launch report
4. **Check permissions** in the Play Console before publishing

## Expected Result

With these changes, Google Play Console should:
- Only detect the 6 health permissions you actually declare
- Not flag your app for requesting excessive health permissions
- Allow you to publish without additional health permission approvals

## If the Issue Persists

If Google Play still flags excessive permissions, the issue is likely:
1. **The HealthDataSdkService** - This exported service suggests broad health access capability
2. **Code analysis** - Google's static analysis detects unused health data type references in the plugin code

In that case, you may need to:
1. Use a different health plugin with more limited scope
2. Implement custom health data access for only your 6 required data types
3. Contact Google Play support to clarify that you only access the declared permissions

## Files Modified

1. `AndroidManifest.xml` - Added tools namespace and explicit permission removal
2. `health_permissions.xml` - Limited to only essential permissions
3. `build.gradle.kts` - Added manifest placeholder for health permissions control

The key insight is that Google Play Console analyzes not just what permissions you declare, but what permissions your app **could potentially** request based on its code and service declarations.