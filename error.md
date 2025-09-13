I/ImeTracker( 7709): com.habittracker.habitv8.debug:7e1e794c: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController( 7709): hide(ime())
D/ImeBackDispatcher( 7709): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher( 7709): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@e0f3b4a
D/InsetsController( 7709): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter( 7709): Compat change id reported: 395521150; UID 10499; state: ENABLED
D/InputConnectionAdaptor( 7709): The input method toggled cursor monitoring off
I/ImeTracker( 7709): system_server:30ad6844: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher( 7709): Unregister received callback id=147418077

══╡ EXCEPTION CAUGHT BY GESTURE ╞═══════════════════════════════════════════════════════════════════
The following _TypeError was thrown while handling a gesture:
type 'String' is not a subtype of type 'Map<String, String>?' of 'result'

When the exception was thrown, this was the stack:
#0      LocalHistoryRoute.didPop (package:flutter/src/widgets/routes.dart:940:18)
#1      _RouteEntry.handlePop (package:flutter/src/widgets/navigator.dart:3301:16)
#2      NavigatorState._flushHistoryUpdates (package:flutter/src/widgets/navigator.dart:4454:22)
#3      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5592:7)
#4      _CreateHabitScreenState._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:1595:53)
#5      _InkResponseState.handleTap (package:flutter/src/material/ink_well.dart:1203:21)
#6      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:345:24)
#7      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:737:11)
#8      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:362:5)
#9      BaseTapGestureRecognizer.acceptGesture (package:flutter/src/gestures/tap.dart:332:7)
#10     GestureArenaManager.sweep (package:flutter/src/gestures/arena.dart:173:27)
#11     GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:534:20)
#12     GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:499:22)
#13     RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:473:11)
#14     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:437:7)
#15     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:394:5)
#16     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:341:7)
#17     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:308:9)
#18     _invoke1 (dart:ui/hooks.dart:347:13)
#19     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:467:7)
#20     _dispatchPointerDataPacket (dart:ui/hooks.dart:282:31)

Handler: "onTap"
Recognizer:
  TapGestureRecognizer#2abcf
════════════════════════════════════════════════════════════════════════════════════════════════════

Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
Another exception was thrown: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
E/flutter ( 7709): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
E/flutter ( 7709): #2      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5573:12)
E/flutter ( 7709): #3      _CreateHabitScreenState._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:1611:41)
E/flutter ( 7709): <asynchronous suspension>
E/flutter ( 7709):
E/flutter ( 7709): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
E/flutter ( 7709): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
E/flutter ( 7709): #2      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5573:12)
E/flutter ( 7709): #3      _CreateHabitScreenState._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:1611:41)
E/flutter ( 7709): <asynchronous suspension>
E/flutter ( 7709):
E/flutter ( 7709): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
E/flutter ( 7709): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
E/flutter ( 7709): #2      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5573:12)
E/flutter ( 7709): #3      _CreateHabitScreenState._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:1611:41)
E/flutter ( 7709): <asynchronous suspension>
E/flutter ( 7709):
E/flutter ( 7709): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
E/flutter ( 7709): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
E/flutter ( 7709): #2      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5573:12)
E/flutter ( 7709): #3      NavigatorState.maybePop (package:flutter/src/widgets/navigator.dart:5539:9)
E/flutter ( 7709): <asynchronous suspension>
E/flutter ( 7709):
E/flutter ( 7709): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: 'package:flutter/src/widgets/navigator.dart': Failed assertion: line 5573 pos 12: '!_debugLocked': is not true.
E/flutter ( 7709): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
E/flutter ( 7709): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
E/flutter ( 7709): #2      NavigatorState.pop (package:flutter/src/widgets/navigator.dart:5573:12)
E/flutter ( 7709): #3      NavigatorState.maybePop (package:flutter/src/widgets/navigator.dart:5539:9)
E/flutter ( 7709): <asynchronous suspension>
E/flutter ( 7709):