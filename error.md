Your app uses deprecated APIs or parameters for edge-to-edge
One or more of the APIs you use or parameters that you set for edge-to-edge and window display have been deprecated in Android 15. Your app uses the following deprecated APIs or parameters:

android.view.Window.setStatusBarColor
android.view.Window.setNavigationBarDividerColor
android.view.Window.setNavigationBarColor
These start in the following places:

io.flutter.embedding.android.FlutterActivity.configureStatusBarForFullscreenFlutterExperience
io.flutter.embedding.android.FlutterFragmentActivity.configureStatusBarForFullscreenFlutterExperience
io.flutter.embedding.engine.a.n
io.flutter.plugin.platform.PlatformPlugin.setSystemChromeSystemUIOverlayStyle
To fix this, migrate away from these APIs or parameters.