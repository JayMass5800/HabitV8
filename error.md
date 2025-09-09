/flutter (31183): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@d7f0643
D/WindowOnBackDispatcher(31183): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@10d8e5a

══╡ EXCEPTION CAUGHT BY GESTURE ╞═══════════════════════════════════════════════════════════════════
The following assertion was thrown while handling a gesture:
You have popped the last page off of the stack, there are no pages left to show
'package:go_router/src/delegate.dart':
Failed assertion: line 175 pos 7: 'currentConfiguration.isNotEmpty'

When the exception was thrown, this was the stack:
#2      GoRouterDelegate._debugAssertMatchListNotEmpty (package:go_router/src/delegate.dart:175:7)
#3      GoRouterDelegate._completeRouteMatch (package:go_router/src/delegate.dart:196:5)
#4      GoRouterDelegate._handlePopPageWithRouteMatch (package:go_router/src/delegate.dart:154:7)
#5      _CustomNavigatorState._handlePopPage (package:go_router/src/builder.dart:440:42)
#6      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5580:28)
#7      Navigator.pop (package:flutter/src/widgets/navigator.dart:2774:27)
#8      _SettingsScreenState._colorOption.<anonymous closure> (package:habitv8/ui/screens/settings_screen.dart:397:19)
#9      _InkResponseState.handleTap (package:flutter/src/material/ink_well.dart:1203:21)
#10     GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:345:24)
#11     TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:737:11)
#12     BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:362:5)
#13     BaseTapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:293:7)
#14     PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:706:9)
#15     PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:97:12)
#16     PointerRouter._dispatchEventToRoutes.<anonymous closure> (package:flutter/src/gestures/pointer_router.dart:143:9)
#17     _LinkedHashMapMixin.forEach (dart:_compact_hash:764:13)
#18     PointerRouter._dispatchEventToRoutes (package:flutter/src/gestures/pointer_router.dart:141:18)
#19     PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:131:7)
#20     GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:530:19)
#21     GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:499:22)
#22     RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:473:11)
#23     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:437:7)
#24     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:394:5)
#25     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:341:7)
#26     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:308:9)
#27     _invoke1 (dart:ui/hooks.dart:347:13)
#28     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:467:7)
#29     _dispatchPointerDataPacket (dart:ui/hooks.dart:282:31)
(elided 2 frames from class _AssertionError)

Handler: "onTap"
Recognizer:
  TapGestureRecognizer#46b43
════════════════════════════════════════════════════════════════════════════════════════════════════

Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 4064 pos 12: '!_debugLocked': is not true.
I/flutter (31183): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (31183): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (31183): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:61:15)