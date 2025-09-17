# In-App Purchase Troubleshooting Guide

## 🚨 Immediate Fixes to Try

### Fix 1: Product State Reset
1. Go to Play Console → Products → One-time products
2. Find `premium_lifetime_access`
3. Click "Deactivate" then "Activate" again
4. Wait 10-15 minutes for propagation

### Fix 2: Version Upload
1. Run: `./fix_iap_build.ps1`
2. Upload new AAB to Internal Testing
3. Wait for processing complete
4. Try testing again

### Fix 3: Clear Play Store Data
On your test device:
1. Settings → Apps → Google Play Store
2. Storage & cache → Clear cache
3. Storage & cache → Clear storage
4. Restart device
5. Re-install your app from Play Store

### Fix 4: Test Account Verification
1. Ensure test device uses same Google account as in License testing
2. Check that license testing is set to "RESPOND_NORMALLY"
3. Test account should NOT be the developer account

## 🔍 Diagnostic Commands

Check your current setup:
```powershell
# Check app version
Get-Content .\pubspec.yaml | Select-String "version:"

# Check product ID in code
Select-String -Path "lib\ui\screens\purchase_screen.dart" -Pattern "premium_lifetime_access"

# Check Android strings
Get-Content "android\app\src\main\res\values\strings.xml" | Select-String "premium_lifetime_access"
```

## 📝 Verification Checklist

- [ ] Product ID exactly matches: `premium_lifetime_access`
- [ ] Product status is "Active" in Play Console
- [ ] App published to Internal Testing track
- [ ] AAB version includes in-app purchase code
- [ ] Test account added to License testing
- [ ] Testing on real device with Play Store
- [ ] Using release build (not debug)
- [ ] Google Play Store app is updated

## 🆘 If Still Not Working

1. **Wait**: Products can take up to 24 hours to propagate
2. **Check Logs**: Look for specific error messages in Flutter logs
3. **Contact Support**: Google Play Console support if product still not detected after 24 hours

## 📞 Error Code Reference

- **BILLING_UNAVAILABLE**: Play Store app not updated or device not supported
- **ITEM_NOT_OWNED**: Product exists but not purchased
- **ITEM_UNAVAILABLE**: Product not found in store (main issue)
- **SERVICE_DISCONNECTED**: Temporary connection issue, retry

Your configuration looks correct in the code, so this is likely a Play Console sync/timing issue.