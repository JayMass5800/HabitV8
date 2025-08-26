#!/usr/bin/env python3
"""
Create placeholder sound files for the HabitV8 app.
This script generates simple audio tones for the missing sound files.
"""

import numpy as np
import wave
import os

def create_tone(frequency, duration, sample_rate=44100, amplitude=0.3):
    """Create a simple sine wave tone."""
    t = np.linspace(0, duration, int(sample_rate * duration), False)
    tone = amplitude * np.sin(2 * np.pi * frequency * t)
    return (tone * 32767).astype(np.int16)

def create_fade_tone(frequency, duration, sample_rate=44100, amplitude=0.3):
    """Create a tone with fade in and fade out."""
    t = np.linspace(0, duration, int(sample_rate * duration), False)
    tone = amplitude * np.sin(2 * np.pi * frequency * t)
    
    # Add fade in/out (10% of duration each)
    fade_samples = int(0.1 * len(tone))
    fade_in = np.linspace(0, 1, fade_samples)
    fade_out = np.linspace(1, 0, fade_samples)
    
    tone[:fade_samples] *= fade_in
    tone[-fade_samples:] *= fade_out
    
    return (tone * 32767).astype(np.int16)

def create_chord(frequencies, duration, sample_rate=44100, amplitude=0.2):
    """Create a chord from multiple frequencies."""
    t = np.linspace(0, duration, int(sample_rate * duration), False)
    chord = np.zeros_like(t)
    
    for freq in frequencies:
        chord += amplitude * np.sin(2 * np.pi * freq * t)
    
    # Add fade in/out
    fade_samples = int(0.1 * len(chord))
    fade_in = np.linspace(0, 1, fade_samples)
    fade_out = np.linspace(1, 0, fade_samples)
    
    chord[:fade_samples] *= fade_in
    chord[-fade_samples:] *= fade_out
    
    return (chord * 32767).astype(np.int16)

def create_wave_sound(duration, sample_rate=44100, amplitude=0.2):
    """Create ocean wave-like sound using filtered noise."""
    t = np.linspace(0, duration, int(sample_rate * duration), False)
    
    # Create filtered noise to simulate waves
    noise = np.random.normal(0, 1, len(t))
    
    # Apply low-pass filter effect by averaging
    window_size = 100
    filtered = np.convolve(noise, np.ones(window_size)/window_size, mode='same')
    
    # Modulate with slow sine wave to create wave-like rhythm
    wave_rhythm = 0.5 * (1 + np.sin(2 * np.pi * 0.3 * t))  # 0.3 Hz rhythm
    wave_sound = amplitude * filtered * wave_rhythm
    
    # Add fade in/out
    fade_samples = int(0.2 * len(wave_sound))
    fade_in = np.linspace(0, 1, fade_samples)
    fade_out = np.linspace(1, 0, fade_samples)
    
    wave_sound[:fade_samples] *= fade_in
    wave_sound[-fade_samples:] *= fade_out
    
    return (wave_sound * 32767).astype(np.int16)

def save_wav(filename, audio_data, sample_rate=44100):
    """Save audio data as WAV file."""
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # Mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        wav_file.writeframes(audio_data.tobytes())

def main():
    """Create all missing sound files."""
    sounds_dir = "assets/sounds"
    
    # Create sounds directory if it doesn't exist
    os.makedirs(sounds_dir, exist_ok=True)
    
    print("Creating placeholder sound files...")
    
    # 1. Zen Gong - Deep, resonant tone
    print("Creating zen_gong.wav...")
    gong_tone = create_fade_tone(220, 3.0, amplitude=0.4)  # A3 note, 3 seconds
    save_wav(os.path.join(sounds_dir, "zen_gong.wav"), gong_tone)
    
    # 2. Upbeat Melody - Major chord progression
    print("Creating upbeat_melody.wav...")
    # C major chord (C-E-G) for 2 seconds
    upbeat = create_chord([261.63, 329.63, 392.00], 2.0, amplitude=0.25)
    save_wav(os.path.join(sounds_dir, "upbeat_melody.wav"), upbeat)
    
    # 3. Soft Piano - Gentle C major scale
    print("Creating soft_piano.wav...")
    # Soft piano-like tone (sine wave with harmonics)
    piano_base = create_fade_tone(261.63, 2.5, amplitude=0.3)  # C4
    piano_harmonic = create_fade_tone(523.25, 2.5, amplitude=0.1)  # C5 (octave)
    soft_piano = piano_base + piano_harmonic
    save_wav(os.path.join(sounds_dir, "soft_piano.wav"), soft_piano)
    
    # 4. Ocean Waves - Filtered noise with wave-like rhythm
    print("Creating ocean_waves.wav...")
    ocean = create_wave_sound(4.0)  # 4 seconds of ocean sounds
    save_wav(os.path.join(sounds_dir, "ocean_waves.wav"), ocean)
    
    print("✅ All sound files created successfully!")
    print("\nCreated files:")
    print("- zen_gong.wav (3.0s)")
    print("- upbeat_melody.wav (2.0s)")
    print("- soft_piano.wav (2.5s)")
    print("- ocean_waves.wav (4.0s)")
    
    print("\nNote: These are simple placeholder sounds.")
    print("For production, consider using professional audio files.")

if __name__ == "__main__":
    main()