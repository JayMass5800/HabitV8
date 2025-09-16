# Google Play Console Setup Guide for HabitV8 One-Time Purchase

## Overview
This guide helps you properly configure the one-time purchase product in Google Play Console to link with the HabitV8 app.

## Product Configuration Requirements

### 1. Product ID
- **Current Product ID**: `premium_lifetime_access`
- **Requirements**: 
  - Must start with a number or lowercase letter
  - Can contain: numbers (0-9), lowercase letters (a-z), underscores (_), periods (.)
  - Must be unique within your app

### 2. Product Metadata (OneTimeProductListing)

#### Title (Required)
- **Maximum Length**: 55 characters
- **Recommended**: "HabitV8 Premium - Lifetime Access"
- **Language Code**: "en-US" (or your target language)

#### Description (Required)
- **Maximum Length**: 200 characters
- **Recommended**: "One-time purchase for lifetime access to all premium features including unlimited habits, advanced analytics, AI suggestions, and custom alarms."

### 3. Purchase Option Configuration

#### Buy Option Settings
- **Type**: Buy Option (not Rent Option)
- **Legacy Compatible**: True (for backwards compatibility)
- **Multi-quantity Enabled**: False (one-time purchase)

### 4. Pricing Configuration
- Set pricing for all target countries
- Ensure pricing is in the correct currency for each region
- Consider using automatic pricing for new regions

## Step-by-Step Setup in Play Console

### Step 1: Access Products Section
1. Go to Google Play Console
2. Select your app (HabitV8)
3. Navigate to **Monetize** → **Products** → **One-time products**

### Step 2: Create Product
1. Click **Create product**
2. Enter Product ID: `premium_lifetime_access`
3. Set Title: "HabitV8 Premium - Lifetime Access"
4. Set Description: "One-time purchase for lifetime access to all premium features including unlimited habits, advanced analytics, AI suggestions, and custom alarms."

### Step 3: Configure Purchase Options
1. Add a Buy option
2. Set **Legacy Compatible** to `true`
3. Leave **Multi-quantity** as `false`

### Step 4: Set Pricing
1. Set base price (e.g., $19.99 USD)
2. Configure pricing for all target countries
3. Enable automatic pricing for new regions if desired

### Step 5: Activate Product
1. Review all settings
2. Click **Save** and then **Activate**
3. Ensure the product status shows as "Active"

## Testing Requirements

### App Publication Status
- App must be published to at least **Internal Testing** track
- Cannot test in-app purchases with an unpublished app

### Test Accounts
- Add test accounts in **Play Console** → **Setup** → **License testing**
- Test accounts can make purchases without being charged

### Device Requirements
- Device must have Google Play Store installed and updated
- Device must support Google Play Billing API
- App must be signed with release keystore (not debug)

## Common Issues and Solutions

### Product Not Found Error
- **Cause**: Product ID mismatch between code and Play Console
- **Solution**: Verify product ID exactly matches: `premium_lifetime_access`

### Product Not Available Error
- **Cause**: App not published to any testing track
- **Solution**: Publish app to Internal Testing track minimum

### Store Connection Failed
- **Cause**: Google Play Store issues or billing API problems
- **Solution**: 
  - Update Google Play Store app
  - Clear Google Play Store cache
  - Ensure device supports billing

### Purchase Validation Failed
- **Cause**: Product not activated or pricing not set
- **Solution**: Ensure product is Active and has pricing configured

## Code Integration Points

### Product ID Constant
```dart
static const String _kPremiumPurchaseId = 'premium_lifetime_access';
```

### Error Handling
The app includes detailed error messages that help diagnose Play Console configuration issues:
- Product not found errors include setup instructions
- Store connection errors provide troubleshooting steps
- Purchase failures show specific error codes

### Purchase Flow
1. App queries available products using product ID
2. User initiates purchase
3. Google Play handles payment processing
4. App receives purchase confirmation
5. App activates premium features locally

## Validation Checklist

Before releasing:
- [ ] Product created in Play Console with correct ID
- [ ] Product title and description under character limits
- [ ] Product activated and shows "Active" status
- [ ] Pricing configured for all target regions
- [ ] App published to testing track
- [ ] Test purchase successful with test account
- [ ] Purchase restoration works correctly
- [ ] Error handling tested with invalid configurations

## Support Information

If you encounter issues:
1. Check the app logs for specific error messages
2. Verify all Play Console settings match this guide
3. Ensure app is properly signed and published
4. Test with fresh Google Play Store cache
5. Verify test account configuration

## API Compliance

This setup complies with Google Play's OneTimeProduct API requirements:
- Proper JSON structure for product metadata
- Correct purchase option configuration
- Regional pricing and availability settings
- Tax and compliance configurations (handled by Play Console)