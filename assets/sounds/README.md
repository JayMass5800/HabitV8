# Alarm Sounds

This directory contains custom alarm sounds for the HabitV8 app.

## Sound Files

- `gentle_chime.mp3` - A soft, pleasant chime sound
- `morning_bell.mp3` - A clear morning bell sound  
- `nature_birds.mp3` - Gentle bird sounds for a natural wake-up
- `digital_beep.mp3` - Classic digital alarm beep
- `zen_gong.mp3` - Peaceful gong sound
- `upbeat_melody.mp3` - Energetic melody to motivate
- `soft_piano.mp3` - Gentle piano notes
- `ocean_waves.mp3` - Calming ocean sounds

## Usage

These sounds are used by the AlarmService to provide variety in alarm notifications.
Users can preview and select their preferred alarm sound from the habit creation/editing screens.

## Adding New Sounds

To add new alarm sounds:
1. Add the audio file (MP3, WAV, or OGG format) to this directory
2. Update the `getAvailableAlarmSounds()` method in `AlarmService`
3. Ensure the file size is reasonable (< 1MB recommended)