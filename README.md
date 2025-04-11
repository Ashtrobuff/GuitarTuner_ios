# 🎸 GuitarTuner iOS App
<img src='https://github.com/user-attachments/assets/c07a9eb7-97cb-4430-b854-ce7604b9bfe6' width=100/>

A SwiftUI-based iOS guitar tuner app that detects and displays the frequency of the played note in real time. It uses `AVAudioEngine`, `Accelerate`, and a custom **Harmonic Product Spectrum (HPS)** algorithm for accurate pitch detection.

---
<img width="448" alt="Screenshot 2025-04-11 at 6 17 35 AM" src="https://github.com/user-attachments/assets/8f0d3dfc-4213-4b51-8f62-9944197bd66b" />


## 🧠 Features

- 🎵 Real-time pitch detection
- 🎸 Auto-detects closest guitar string (E2, A2, D3, G3, B3, E4)
- 📈 Displays tuning difference from the target note
- 🎧 Uses Fast Fourier Transform (FFT) for spectral analysis
- 📊 Applies **Harmonic Product Spectrum** for robust fundamental frequency estimation
- ⚙️ Uses `AVAudioEngine` and `AVAudioSession` for low-latency audio input

---


## 🛠 Tech Stack

- **SwiftUI** for the user interface
- **AVFoundation** for audio capture
- **Accelerate/vDSP** for FFT and signal processing
- **Combine** via `@Published` to keep the UI reactive

---

## 📦 Core Components

### 🔊 `TunerEngine`

A singleton class that handles:

- Audio input with `AVAudioEngine`
- RMS-based silence detection
- Real-time frequency estimation with FFT
- HPS for harmonic suppression
- Auto-string matching for standard tuning
- Observable `@Published` values:
  - `detectedFrequency`: live frequency
  - `difference`: tuning delta vs. selected string
  - `stringSelection`: auto or manually selected string

### 🧮 FFT + HPS

- FFT is used to convert time-domain signal to frequency domain
- A Hanning window is applied to reduce spectral leakage
- HPS multiplies downsampled spectra to enhance fundamental detection
- Frequencies < 60 Hz are suppressed as noise

---

## 🚀 How to Use

1. **Clone the repo**

   ```bash
   git clone https://github.com/Ashtrobuff/GuitarTuner_ios.git
