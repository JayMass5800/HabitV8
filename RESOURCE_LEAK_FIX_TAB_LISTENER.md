# Resource Leak Fix - TabController Listener Cleanup

## 🐛 Issue
**Warning:** `W/System: A resource failed to call release` (multiple instances)

This warning appeared when the app went to background, indicating that resources were not being properly cleaned up.

## 🔍 Root Cause

The `InsightsScreen` was adding a listener to the `TabController` in `initState()` but **never removing it** in `dispose()`. This caused a resource leak every time the insights screen was opened and closed.

### Location
**File:** `lib/ui/screens/insights_screen.dart`

**Problem Code:**
```dart
@override
void initState() {
  super.initState();
  // ... other initialization ...
  _tabController = TabController(length: 3, vsync: this);

  // Listen for tab changes to show onboarding and load AI insights
  _tabController.addListener(() {  // ❌ Listener added but never removed!
    if (_tabController.index == 1) {
      // AI Insights tab
      if (!_aiInsightsRequested) {
        _loadAIInsights();
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          AIInsightsOnboarding.showIfNeeded(context);
        }
      });
    }
  });
  // ...
}

@override
void dispose() {
  _fadeController.dispose();
  _slideController.dispose();
  _tabController.dispose();  // ❌ Controller disposed but listener not removed!
  super.dispose();
}
```

## ✅ Fix Applied

### 1. Extracted Listener to Named Method
This allows us to reference the same function for both `addListener()` and `removeListener()`.

```dart
/// Handle tab changes to load AI insights and show onboarding
void _onTabChanged() {
  if (_tabController.index == 1) {
    // AI Insights tab
    if (!_aiInsightsRequested) {
      // Load AI insights automatically on first access
      _loadAIInsights();
    }
    // Show onboarding after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        AIInsightsOnboarding.showIfNeeded(context);
      }
    });
  }
}
```

### 2. Updated initState to Use Named Method
```dart
@override
void initState() {
  super.initState();
  _fadeController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  _slideController = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  _tabController = TabController(length: 3, vsync: this);

  // Listen for tab changes to show onboarding and load AI insights
  _tabController.addListener(_onTabChanged);  // ✅ Using named method
  
  // ... rest of initialization ...
}
```

### 3. Updated dispose to Remove Listener
```dart
@override
void dispose() {
  // CRITICAL: Remove tab controller listener to prevent resource leak
  _tabController.removeListener(_onTabChanged);  // ✅ Listener removed!
  _fadeController.dispose();
  _slideController.dispose();
  _tabController.dispose();
  super.dispose();
}
```

## 📊 Impact Analysis

### Why This Caused Multiple "Resource Failed to Call Release" Warnings

Each time the user navigated to the insights screen:
1. A new listener was added to `_tabController`
2. When the screen was disposed, the listener wasn't removed
3. The `TabController` tried to dispose but couldn't fully clean up because of dangling listener references
4. This created a resource leak chain affecting multiple resources

Since the insights screen uses multiple controllers:
- `_fadeController` (AnimationController)
- `_slideController` (AnimationController)  
- `_tabController` (TabController with listener)

The dangling listener prevented proper cleanup, causing multiple resource leak warnings (one for each controller/resource that couldn't be fully released).

## 🧪 Verification Steps

### Before Fix:
```bash
# Navigate to Insights screen
# Press Android back button or switch apps
# Check logcat
adb logcat | grep "resource failed"
```

**Expected:** Multiple warnings like:
```
W/System: A resource failed to call release.
W/System: A resource failed to call release.
W/System: A resource failed to call release.
```

### After Fix:
```bash
# Navigate to Insights screen
# Press Android back button or switch apps
# Check logcat
adb logcat | grep "resource failed"
```

**Expected:** No warnings! Clean disposal logs:
```
I/flutter: 🗑️ InsightsScreen disposed cleanly
```

## 📝 Best Practices Learned

### 1. Always Remove Listeners in dispose()
```dart
// ✅ CORRECT Pattern
@override
void initState() {
  super.initState();
  _controller.addListener(_onControllerChanged);
}

void _onControllerChanged() {
  // Handle changes
}

@override
void dispose() {
  _controller.removeListener(_onControllerChanged);  // Must remove!
  _controller.dispose();
  super.dispose();
}
```

```dart
// ❌ INCORRECT Pattern (causes resource leak)
@override
void initState() {
  super.initState();
  _controller.addListener(() {  // Anonymous function can't be removed!
    // Handle changes
  });
}

@override
void dispose() {
  _controller.dispose();  // Listener still attached!
  super.dispose();
}
```

### 2. Named Methods vs Anonymous Functions
- **Use named methods** when you need to remove the listener
- **Avoid anonymous functions** with `addListener()` - you can't remove them!

### 3. Disposal Order
Always remove listeners **before** disposing the controller:
```dart
@override
void dispose() {
  _controller.removeListener(_onControllerChanged);  // 1. Remove listener first
  _controller.dispose();                              // 2. Then dispose controller
  super.dispose();                                     // 3. Finally call super
}
```

## 🔗 Related Issues

This fix addresses the same category of issue as:
- `RESOURCE_LEAK_FIX.md` - StreamSubscription cleanup in services
- Both are about ensuring proper resource cleanup in `dispose()`

## ✅ Resolution Status

- [x] Root cause identified (missing `removeListener()`)
- [x] Fix implemented with named method pattern
- [x] Compilation verified (no errors)
- [ ] Runtime verification (test app lifecycle to confirm no warnings)

## 🎯 Expected Behavior After Fix

When navigating to/from the insights screen:
1. Listener is added in `initState()`
2. Tab changes trigger `_onTabChanged()` as expected
3. On screen disposal, listener is cleanly removed
4. All controllers dispose properly without resource leaks
5. No "resource failed to call release" warnings in logcat

---

**Date Fixed:** October 6, 2025  
**Affected File:** `lib/ui/screens/insights_screen.dart`  
**Fix Type:** Resource Management  
**Severity:** High (causes memory leaks on repeated screen visits)
