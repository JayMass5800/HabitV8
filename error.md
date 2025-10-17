D/AudioSystem(32635): onNewServiceWithAdapter: media.audio_flinger service obtained 0xb400007d9704fe80
D/AudioSystem(32635): getService: checking for service media.audio_flinger: 0xb400007ce6fd5720
V/MediaPlayer(32635): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(32635): cleanDrmObj: mDrmObj=null mDrmSessionId=null
E/MediaPlayerNative(32635): error (1, -2147483648)
E/MediaPlayer(32635): Error (1,-2147483648)
I/flutter (32635): AudioPlayers Exception: AudioPlayerException(
I/flutter (32635):      AssetSource(path: ringtones/04_Morning_Dew.mp3, mimeType: null),
I/flutter (32635):      PlatformException(AndroidAudioError, Failed to set source. For troubleshooting, see: https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, MEDIA_ERROR_UNKNOWN {what:1}, MEDIA_ERROR_SYSTEM, null)
E/flutter (32635): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: PlatformException(AndroidAudioError, Failed to set source. For troubleshooting, see: https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, MEDIA_ERROR_UNKNOWN {what:1}, MEDIA_ERROR_SYSTEM, null)
E/flutter (32635):
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ PlatformException(AndroidAudioError, Failed to set source. For troubleshooting, see: https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, MEDIA_ERROR_UNKNOWN {what:1}, MEDIA_ERROR_SYSTEM, null)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview (package:habitv8/services/alarm_service.dart:369:17)
I/flutter (32635): │ #2   <asynchronous suspension>
I/flutter (32635): │ #3   _CreateHabitScreenV2State._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen_v2.dart:2085:45)
I/flutter (32635): │ #4   <asynchronous suspension>
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔ ❌ Failed to play alarm sound preview: ringtones/04_Morning_Dew.mp3
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview (package:habitv8/services/alarm_service.dart:370:17)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔ ❌ Error details: PlatformException(AndroidAudioError, Failed to set source. For troubleshooting, see: https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, MEDIA_ERROR_UNKNOWN {what:1}, MEDIA_ERROR_SYSTEM, null)
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview (package:habitv8/services/alarm_service.dart:371:17)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔ ❌ Stack trace:
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview (package:habitv8/services/alarm_service.dart:372:17)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ PlatformException(AndroidAudioError, Failed to set source. For troubleshooting, see: https://github.com/bluefireteam/audioplayers/blob/main/troubleshooting.md, MEDIA_ERROR_UNKNOWN {what:1}, MEDIA_ERROR_SYSTEM, null)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   _CreateHabitScreenV2State._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen_v2.dart:2111:55)
I/flutter (32635): │ #2   <asynchronous suspension>
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔ ❌ UI: Failed to play preview
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (32635): │ #1   _CreateHabitScreenV2State._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen_v2.dart:2114:55)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ ⛔ Stack trace:
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview.<anonymous closure> (package:habitv8/services/alarm_service.dart:350:19)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ 💡 🎵 Playback completed normally
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview.<anonymous closure> (package:habitv8/services/alarm_service.dart:330:21)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ 💡 🎵 Player state changed: PlayerState.completed
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (32635): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (32635): │ #1   AlarmService.playAlarmSoundPreview.<anonymous closure> (package:habitv8/services/alarm_service.dart:340:23)
I/flutter (32635): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (32635): │ 💡 ✅ Player completed successfully
I/flutter (32635): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
