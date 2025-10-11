Context: I have a Flutter app using awesome_notifications for notification actions and Isar for a local database. The goal is to update the Isar database when the user taps an action button, even if the app is completely terminated (closed/killed). The current setup works fine when the app is in the foreground or background, but fails when terminated.

I am using a structure identical to the provided example (see code block below). Please analyze this setup and provide a detailed checklist of native configuration issues, Isar initialization pitfalls, and potential tree-shaking problems that specifically break the process in the terminated state on both Android and iOS.

My Current Implementation Code Structure:
Dart

// main.dart

// 1. Handler is top-level and marked with pragma
@pragma('vm:entry-point')
Future<void> notificationActionHandler(ReceivedAction receivedAction) async {
  // 2. Isar initialization is called INSIDE the handler
  await IsarService.initialize(); 

  if (receivedAction.buttonKeyPressed == 'TOGGLE_STATUS') {
    final String? itemIdString = receivedAction.payload?['item_id'];
    if (itemIdString != null) {
      final int itemId = int.tryParse(itemIdString) ?? 0;
      // 3. Database operation uses the initialized Isar
      await IsarService.updateItemToggledStatus(itemId, true); 
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await AwesomeNotifications().initialize(
    // ...
  );
  
  // 4. Listener is set in main()
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: notificationActionHandler,
  );
  
  // 5. (Optional) Isar initialization for the main isolate
  await IsarService.initialize(); 
  
  runApp(const MyApp());
}

// isar_service.dart

class IsarService {
  static late Isar isarInstance;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    final dir = await getApplicationSupportDirectory();
    // 6. Database opening includes all schemas
    isarInstance = await Isar.open( 
      [MyItemSchema], 
      directory: dir.path,
      inspector: false,
    );
    _isInitialized = true;
  }
  // ... updateItemToggledStatus method
}

// Notification Creation

// 7. Action uses SilentBackgroundAction
NotificationActionButton( 
  key: 'TOGGLE_STATUS',
  label: 'Mark as Done',
  actionType: ActionType.SilentBackgroundAction,
  isDangerousOption: true,
),
Critical Checklist for Claude to Verify:
Isolate & Tree-Shaking Verification:

Confirm the correct use of @pragma('vm:entry-point') on the notificationActionHandler and explain if it needs to be present on any other helper methods (like IsarService.initialize()) to prevent code stripping in Release/Terminated builds.

Isar Re-initialization in Isolate:

Verify that IsarService.initialize() is structured correctly to open the database reliably in a new, cold, and independent Isolate created by the notification action. Does the use of Isar.open need special handling (e.g., using Isar.getInstance() first) when dealing with multiple isolates, even if they are cold-starting?

Android Native Permissions/Config:

Identify any specific Android Manifest permissions or receiver/service definitions required by awesome_notifications for SilentBackgroundAction to reliably launch a service when the app is terminated (e.g., WAKE_LOCK, RECEIVE_BOOT_COMPLETED, or any service setup required in the AndroidManifest.xml).

iOS Native Setup:

Detail the essential Xcode/Info.plist background modes that must be enabled for any action to fire when the app is terminated on iOS (e.g., Background Fetch, Remote Notifications, or specific awesome_notifications requirements). Note: iOS is notoriously restrictive in the terminated state.

Manufacturer Optimizations (Android):

Since Android manufacturers are aggressive, highlight that failure in the terminated state is often due to Battery Optimization (e.g., on Xiaomi, Huawei, OnePlus) and suggest checking the device's native logs (adb logcat) for service-killing messages.

This prompt directs Claude to focus on the common, non-Dart-level issues that prevent background tasks from working in the terminated state, especially the unique requirements of Isar's isolate handling and the platform-specific native configurations.

The video below discusses the general concept of handling notifications when an app is in the terminated state, which is the core issue you're facing with your background action.

Handle Push Notifications in Terminated State | Flutter Firebase Step-by-Step Tutorial

Handle Push Notifications in Terminated State | Flutter Firebase Step-by-Step Tutorial