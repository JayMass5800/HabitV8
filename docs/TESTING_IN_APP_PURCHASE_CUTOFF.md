# Testing In-App Purchase Cutoff Functionality

This document explains how to test the in-app purchase cutoff behavior in HabitV8 using the built-in debug utilities.

## Overview

The app has a 30-day trial period where users can access all features. After the trial expires, **the entire app is locked** and users must purchase the premium version to continue using the app. This testing guide helps you verify this behavior works correctly.

## Debug Utilities Added

I've added several debug options to the Settings screen under the "Premium Version" section:

### 1. Debug Trial Info
- **Purpose**: View detailed information about the current trial status
- **Shows**: Trial start date, days remaining, subscription status, expiry date
- **Use**: Check current trial state and verify calculations

### 2. Reset Trial (Debug)
- **Purpose**: Reset the trial period back to 30 days
- **Effect**: Clears all subscription data and starts a fresh 30-day trial
- **Use**: Return to trial state for testing

### 3. Simulate Trial Expiry (Debug)
- **Purpose**: Force the trial to expire immediately
- **Effect**: Sets trial start date to 31 days ago, making it expired
- **Use**: Test premium cutoff behavior without waiting 30 days

### 4. Simulate Premium Purchase (Debug)
- **Purpose**: Grant premium access without actual purchase
- **Effect**: Creates a debug purchase token and activates premium features
- **Use**: Test premium feature access and behavior

## Testing Scenarios

### Scenario 1: Test Fresh Trial
1. Open the app (if first time, trial starts automatically)
2. Go to Settings → Premium Version
3. Tap "Debug Trial Info" to see trial status
4. Verify you have 30 days (or close to it) remaining
5. Test that premium features are accessible

### Scenario 2: Test Trial Expiry Cutoff
1. Go to Settings → Premium Version
2. Tap "Simulate Trial Expiry (Debug)"
3. Confirm the action
4. Restart the app or navigate to any main screen
5. Verify that:
   - **Entire app is locked** with a lock screen
   - Lock screen shows "Trial Period Ended" message
   - Only "Upgrade to Premium" and "Restore Purchases" buttons are available
   - Cannot access any app features until purchase

### Scenario 3: Test Premium Access
1. From expired trial state (Scenario 2)
2. Tap "Upgrade to Premium" on the lock screen
3. In the purchase screen, go back to Settings → Premium Version
4. Tap "Simulate Premium Purchase (Debug)"
5. Confirm the action
6. Verify that:
   - **App lock is removed** and full access is restored
   - Status shows "Premium Active"
   - All features are now accessible
   - No restrictions on app usage

### Scenario 4: Test Trial Reset
1. From any state (trial, expired, or premium)
2. Go to Settings → Premium Version
3. Tap "Reset Trial (Debug)"
4. Confirm the action
5. Restart the app
6. Verify that:
   - Status shows "Free Trial (30 days remaining)"
   - Premium features are accessible again
   - Fresh 30-day trial period started

## App Access Behavior

When testing cutoff behavior, verify the following access patterns:

### During Trial (30 days)
- ✅ **Full app access** - All features available
- ✅ AI Insights
- ✅ Unlimited Habits
- ✅ Advanced Analytics
- ✅ Data Export
- ✅ Custom Categories

### After Trial Expires
- ❌ **ENTIRE APP LOCKED** - Complete lockout
- ❌ Cannot access any screens except purchase
- ❌ Shows lock screen with upgrade options
- ✅ Can purchase premium access
- ✅ Can restore previous purchases

### Premium Access
- ✅ **Full app access** - All features permanently available

## App Lock Logic

The app uses `AppLockWrapper` to control access:

- **Trial users**: Have full app access with all features
- **Expired trial users**: App is completely locked with lock screen
- **Premium users**: Have full app access permanently

## Important Notes

1. **Restart Required**: After using debug utilities, restart the app to see changes take effect
2. **Debug Only**: These utilities are for testing only and should be removed before production
3. **Data Safety**: Debug utilities clear subscription data but don't affect habit data
4. **State Persistence**: Changes persist until you use another debug utility or uninstall the app

## Verification Checklist

- [ ] Fresh trial shows 30 days remaining
- [ ] Trial expiry completely locks the app
- [ ] Lock screen appears when trial expires
- [ ] Premium purchase unlocks full app access
- [ ] Trial reset restarts 30-day period
- [ ] Status display updates correctly
- [ ] App lock follows subscription rules
- [ ] Purchase flow is accessible from lock screen
- [ ] Restore purchases works from lock screen

## Troubleshooting

If debug utilities don't work:
1. Check that you're in the Settings → Premium Version section
2. Ensure you have the latest code changes
3. Try restarting the app after each debug action
4. Check the app logs for any error messages

## Cleanup

To remove debug utilities before production:
1. Remove the debug SettingsTile widgets from `settings_screen.dart`
2. Remove the debug methods from `SubscriptionService`
3. Remove this testing documentation file

This testing approach allows you to quickly verify the in-app purchase cutoff functionality without waiting for the actual trial period to expire or making real purchases.