import SwiftUI
import Accelerate
import AVFoundation

enum RecordingState {
    case stopped
    case running
}

class TunerEngine: ObservableObject {
    static let shared = TunerEngine()
    let engine = AVAudioEngine()
    let mixerNode = AVAudioMixerNode()
    @Published var state: RecordingState = .stopped
    @Published var stringSelection: String = "E2"
    @Published var difference:CGFloat=0.0
    @Published var detectedFrequency:CGFloat=0.0
    @Published var isonAuto:Bool=true
    private let fftSize = 16384
    private let sampleRate: Float = 48000
    private let numHarmonics = 4  // HPS levels
    private var fftSetup: FFTSetup!
    private var lastDisplayedFrequency: Float = 0
    private let frequencyChangeThreshold: Float = 1
    private let volumeThreshold: Float = 0.01 // Adjust based on testing

    func isSoundLoudEnough(buffer: AVAudioPCMBuffer) -> Bool {
        var rms: Float = 0
        vDSP_rmsqv(buffer.floatChannelData![0], 1, &rms, vDSP_Length(fftSize))
        return rms > volumeThreshold
    }
    init() {
        fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(fftSize))), FFTRadix(kFFTRadix2))
    }
    
    deinit {
        vDSP_destroy_fftsetup(fftSetup)
    }
    
    static func fft(data: UnsafeMutablePointer<Float>, fftSetup: FFTSetup, fftSize: Int) -> [Float] {
        var realParts = [Float](repeating: 0.0, count: fftSize)
        var imagParts = [Float](repeating: 0.0, count: fftSize)
        var magnitudes = [Float](repeating: 0.0, count: fftSize / 2)

        // Copy data into real part
        for i in 0..<fftSize {
            realParts[i] = data[i]
        }
        
        // Apply Hanning window
        var hanningWindow = [Float](repeating: 0.0, count: fftSize)
        vDSP_hann_window(&hanningWindow, vDSP_Length(fftSize), Int32(vDSP_HANN_NORM))
        vDSP_vmul(realParts, 1, hanningWindow, 1, &realParts, 1, vDSP_Length(fftSize))

        // Initialize imaginary part
      ///  vDSP_vclr(&imagParts, 1, vDSP_Length(fftSize))
        
        // Create DSP Split Complex
        var splitComplex = DSPSplitComplex(realp: &realParts, imagp: &imagParts)
        let log2n = vDSP_Length(log2(Float(fftSize)))

        // Perform FFT
        vDSP_fft_zip(fftSetup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

        // Compute magnitude spectrum (only take first N/2 bins)
        vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(fftSize / 2))
        
        return magnitudes
    }

    func findDominantFrequency(magnitudes: [Float]) -> Float {
        var magnitudes = magnitudes  // Change to 'var' so we can modify it
        let frequencyResolution = sampleRate / Float(fftSize)
        
        // Suppress frequencies below 60 Hz
        let minFreqIndex = Int(60.0 / frequencyResolution)
        for i in 0..<minFreqIndex {
            magnitudes[i] = 0  // Now allowed because it's a 'var'
        }
        
        // Apply Harmonic Product Spectrum (HPS)
        let hpsResult = applyHPS(magnitudes: magnitudes)
        
        // Find peak frequency
        guard let maxIndex = hpsResult.indices.max(by: { hpsResult[$0] < hpsResult[$1] }) else {
            return 0.0
        }
        let detectedFreq = Float(maxIndex) * frequencyResolution
        DispatchQueue.main.async{
            self.detectedFrequency=CGFloat(detectedFreq)
    }
        if(isonAuto)
        {  DispatchQueue.main.async{
            self.stringSelection=self.getClosestGuitarNote(for: detectedFreq)
        }
        }
       
        getDifference(for:stringSelection)
        print("Estimated Frequency: \(detectedFreq) Hz")
        return detectedFreq
    }

    // **Harmonic Product Spectrum (HPS)**
    func applyHPS(magnitudes: [Float]) -> [Float] {
        var hpsSpectrum = magnitudes  // Start with original magnitude spectrum
        let len = magnitudes.count
        
        // Multiply downsampled versions
        for h in 2...numHarmonics {
            for i in 0..<(len / h) {
                hpsSpectrum[i] *= magnitudes[i * h]
            }
        }

        return hpsSpectrum
    }
    
    private func getClosestGuitarNote(for frequency: Float) -> String {
        let notes = [
            (82.36, "E2"), (110.89, "A2"), (147.83, "D3"), (196.00, "G3"), (247.94, "B3"), (330.63, "E4")
        ]
        return notes.min(by: { abs(Float($0.0) - frequency) < abs(Float($1.0) - frequency) })?.1 ?? "Unknown"
    }
    
    private func getDifference(for StringName:String){
        let notes = [
            (82.36, "E2"), (110.89, "A2"), (147.83, "D3"), (196.00, "G3"), (247.94, "B3"), (330.63, "E4")
        ]
        let givenFreq=notes.first(where: {$0.1==StringName})?.0 ?? 0
        DispatchQueue.main.async{
            self.difference=self.detectedFrequency-givenFreq
        }
    }
    func hasHarmonics(magnitudes: [Float], frequency: Float) -> Bool {
        let frequencyResolution = sampleRate / Float(fftSize)
        let fundamentalIndex = Int(frequency / frequencyResolution)
        
        // Check if at least one harmonic exists with significant energy
        for harmonic in 2...3 {
            let harmonicIndex = fundamentalIndex * harmonic
            if harmonicIndex < magnitudes.count {
                if magnitudes[harmonicIndex] > magnitudes[fundamentalIndex] * 0.25 {
                    return true
                }
            }
        }
        return false
    }
    func processAudioBuffer(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        var note:String
        let magnitudes = TunerEngine.fft(data: channelData, fftSetup: fftSetup, fftSize: fftSize)
        let dominantFrequency = findDominantFrequency(magnitudes: magnitudes)
        if !isSoundLoudEnough(buffer: buffer){
            DispatchQueue.main.async
            {
                self.difference=0
            }
            return
        }
        if (hasHarmonics(magnitudes: magnitudes, frequency: dominantFrequency)){
        if detectedFrequency > 65{
            if abs(dominantFrequency - lastDisplayedFrequency) > frequencyChangeThreshold {
                lastDisplayedFrequency = dominantFrequency
                note = getClosestGuitarNote(for: dominantFrequency)
                print("Detected Frequency: \(dominantFrequency) Hz -> Closest Note: \(note)")
            }
        }
    }
    
    }
    
    func setup() {
        setupSession()
        let mixer = AVAudioMixerNode()
        mixer.volume = 0
        engine.attach(mixer)
            
        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        engine.connect(inputNode, to: mixer, format: inputFormat)
        let mixerFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: 1, interleaved: false)
        engine.connect(mixer, to: engine.mainMixerNode, format: mixerFormat)
        
        mixer.installTap(onBus: 0, bufferSize: UInt32(fftSize), format: nil) { [weak self] buffer, _ in
            self?.processAudioBuffer(buffer: buffer)
        }
        do {
            try engine.prepare()
        } catch {
            print(error)
        }
    }
    
    func startRecording() {
        do {
            try engine.start()
            state = .running
        } catch {
            print(error)
        }
    }
    
    func stopRecording() {
        engine.stop()
        state = .stopped
    }
    
    func toggleRecord() {
        if state == .running {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func setupSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord,mode:.measurement, options: .defaultToSpeaker)
        try? session.setPreferredSampleRate(48000)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}
