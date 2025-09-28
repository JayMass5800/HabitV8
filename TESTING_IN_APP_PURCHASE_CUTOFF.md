# Testing In-App Purchase Cutoff Functionality

This document explains how to test the in-app purchase cutoff behavior in HabitV8 using the built-in debug utilities.

## Overview

The app has a 30-day trial period where users can access premium features. After the trial expires, premium features are locked until the user purchases the premium version. This testing guide helps you verify this behavior works correctly.

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
4. Restart the app
5. Verify that:
   - Status shows "Trial Expired - Upgrade to Premium"
   - Premium features are locked/disabled
   - User is prompted to purchase when accessing premium features

### Scenario 3: Test Premium Access
1. From expired trial state (Scenario 2)
2. Go to Settings → Premium Version
3. Tap "Simulate Premium Purchase (Debug)"
4. Confirm the action
5. Restart the app
6. Verify that:
   - Status shows "Premium Active"
   - All premium features are unlocked
   - No trial limitations apply

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

## Premium Features to Test

When testing cutoff behavior, verify these premium features are properly locked/unlocked:

1. **AI Insights** - Advanced habit analysis and recommendations
2. **Unlimited Habits** - Create more than the free tier limit
3. **Advanced Analytics** - Detailed statistics and trends
4. **Data Export** - Export habit data to CSV/other formats
5. **Custom Categories** - Create custom habit categories
6. **Cloud Sync** - Sync data across devices (premium only)
7. **Priority Support** - Access to premium support (premium only)

## Feature Access Logic

The app uses `SubscriptionService.isFeatureAvailable(PremiumFeature feature)` to check access:

- **Trial users**: Have access to most features (AI insights, unlimited habits, analytics, export, custom categories)
- **Expired trial users**: Have no access to premium features
- **Premium users**: Have access to all features

## Important Notes

1. **Restart Required**: After using debug utilities, restart the app to see changes take effect
2. **Debug Only**: These utilities are for testing only and should be removed before production
3. **Data Safety**: Debug utilities clear subscription data but don't affect habit data
4. **State Persistence**: Changes persist until you use another debug utility or uninstall the app

## Verification Checklist

- [ ] Fresh trial shows 30 days remaining
- [ ] Trial expiry locks premium features
- [ ] Premium purchase unlocks all features
- [ ] Trial reset restarts 30-day period
- [ ] Status display updates correctly
- [ ] Feature access follows subscription rules
- [ ] UI shows appropriate prompts for expired users
- [ ] Purchase flow is accessible from expired state

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