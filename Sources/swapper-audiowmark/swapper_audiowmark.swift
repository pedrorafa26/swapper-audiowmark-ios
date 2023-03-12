import Logging
import Foundation
import Accelerate
import AVFoundation
import Accelerate
import AudioKit

public struct swapper_audiowmark {
    
    
    struct FFTResult {
        let frequencies: [Float]
        let powers: [Float]
    }
    
    let MY_BUFFER_SIZE = 1024
    
    public private(set) var text = "Hello, World!"
    
    public init() {
        let logger = Logger(label: "swift-audiowmark")
        logger.info("Inicialización de Paquete")
    }

    public static func whoAreYou(){
        let logger = Logger(label: "swift-audiowmark")
        logger.info("Je suis a nouveuo package")
    }
    
    public func convertProccess() {
        
    }
    
    
    public func readWavIntoFloats(fname: String, ext: String) -> [Float]{
        let logger = Logger(label: "swift-audiowmark")
        do {
            logger.info("Init read of audiostring at: \(fname)")
            let url = URL(fileURLWithPath: fname)

    //        let url = NSBundle.mainBundle().URLForResource(fname, withExtension: "wav")
    //        let file = try! AVAudioFile(forReading: url!)
    //        let format = AVAudioFormat(commonFormat: .PCMFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)
    //
    //        let buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: 1024)
    //        try! file.readIntoBuffer(buf)
    //
    //        // this makes a copy, you might not want that
    //        let floatArray = Array(UnsafeBufferPointer(start: buf.floatChannelData[0], count:Int(buf.frameLength)))
    //
    //        print("floatArray \(floatArray)\n")
            
            
            // Second try
            
    //        let url = URL(fileURLWithPath: fname)
    //        let file = try! AVAudioFile(forReading: url)
    //        logger.info("It is possible to read file? \(file)")
    //        let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))!
    //        try! file.read(into: buffer)
    //
    //        let windowSize = 256
    //
    //        let fftSetup = vDSP_create_fftsetup(UInt(log2(Float(windowSize))), FFTRadix(kFFTRadix2))
    //        var magnitudes = [Float](repeating: 0, count: windowSize / 2)
    //
    //        for windowStart in stride(from: 0, to: Int(buffer.frameLength) - windowSize, by: windowSize / 2) {
    //            let currentWindow = buffer.floatChannelData![0][(windowStart..<windowStart + windowSize).hashValue]
    //            var complexBuffer = DSPSplitComplex(realp: &magnitudes, imagp: &magnitudes)
    //            var windowvalue = DSPComplex(real: currentWindow, imag: 0)
    //            vDSP_ctoz(windowvalue, 2, &complexBuffer, 1, vDSP_Length(windowSize / 2))
    //            vDSP_fft_zrip(fftSetup!, &complexBuffer, 1, UInt(log2(Float(windowSize))), FFTDirection(FFT_FORWARD))
    //            var powers = [Float](repeating: 0, count: windowSize / 2)
    //            vDSP_zvmags(&complexBuffer, 1, &powers, 1, vDSP_Length(windowSize / 2))
    //        }
    //        logger.info("Array of data: \(magnitudes)")
    //
    //        return magnitudes
    //
            
            //Third try
    //        let url = URL(fileURLWithPath: fname)
    //        let file = try! AVAudioFile(forReading: url)
    //        logger.info("It is possible to read file? \(file)")
    //        let frameCount = UInt32(file.length)
    //
    //        var fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(frameCount))), FFTRadix(kFFTRadix2))
    //
    //        var complexBuffer = [DSPComplex](repeating: DSPComplex(real: 0.0, imag: 0.0), count: Int(frameCount))
    //
    //        vDSP_ctoz(UnsafePointer(audioData), 2, &complexBuffer, 1, vDSP_Length(frameCount))
    //
    //        // perform FFT
    //        var fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(frameCount))), FFTRadix(kFFTRadix2))
    //
    //        complexBuffer.withUnsafeMutableBufferPointer { complexBufferPointer in
    //            vDSP_fft_zrip(fftSetup!, complexBufferPointer.baseAddress!, 1, vDSP_Length(log2(Float(frameCount))), FFTDirection(FFT_FORWARD))
    //        }
    //
    //        complexBuffer.withUnsafeMutableBufferPointer { complexBufferPointer in
    //            vDSP_fft_zrip(fftSetup!, complexBufferPointer.baseAddress!, 1, vDSP_Length(log2(Float(frameCount))), FFTDirection(FFT_FORWARD))
    //        }
    //
    //        // calculate the magnitude
    //        var magnitude = [Double](repeating: 0.0, count: Int(frameCount))
    //
    //        complexBuffer.withUnsafeBufferPointer { complexBufferPointer in
    //            vDSP_zvmags(complexBufferPointer.baseAddress!, 1, &magnitude, 1, vDSP_Length(frameCount))
    //        }
    //
    //        // get the powers for each frequency
    //        let powers = magnitude.map({ $0 * $0 })

            // calculate the magnitude
            
            //AudioKit try
//            let file = try AKAudioFile(readFileName: fname)
//            let url = URL(fileURLWithPath: fname)
//            let file = try AVAudioFile(forReading: url)
//
//            let format = file.processingFormat
//            let frameCount = UInt32(file.length)
//            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
//
//            try file.read(into: buffer!)
//
//            let player = AudioPlayer(file: file)
//            var powers = [Double]()
//
//            let fft = FFTTap(player!) { fftData in
//                powers = stride(from: 0, to: Int(fftData.count / 2), by: 1).map {
//                    let bin = fftData[$0]
//                    logger.info("bin: \(bin)")
//                    let value = (pow(bin.magnitude, 2))
//                    logger.info("value: \(value)")
//                    return Double(value)
//
//                }
//
//            }
//
//            let sampleRate = file.fileFormat.sampleRate
//            let fftSize = fft.bufferSize
//            let frequencyBins = powers.enumerated().map { (index, power) -> (Double, Double) in
//                let frequency = Double(index) * (sampleRate / Double(fftSize))
//                return (frequency, power)
//            }
//            fft.start()
//            logger.info("Frequency-power pairs: \(frequencyBins)")
//            return powers
        
        
            //Last
            
            // Read the audio file into memory
            let file = try? AVAudioFile(forReading: url)
            guard let audioFile = file else { return [] }
            
            // Get the audio buffer from the file
            let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
            try? audioFile.read(into: buffer!)
            
            // Get the audio buffer data and cast it as a float array
            let audioData = Array(UnsafeBufferPointer(start:buffer?.floatChannelData![0], count:Int(buffer!.frameLength)))
            
        
            // Set up the FFT variables
            let log2n = UInt(round(log2(Float(audioData.count))))
            let n = Int(1 << log2n)
            var complexNumbers = [DSPComplex](repeating: DSPComplex(real: 0, imag: 0), count: n/2)

            // Convert input to complex numbers
            for i in 0..<n/2 {
                if((2 * i) < audioData.count-1){
                    complexNumbers[i].real = audioData[2 * i] ?? Float(0)
                    complexNumbers[i].imag = audioData[2 * i + 1] ?? Float(0)
                }
            }
            var real = [Float](repeating: 0, count: n/2)
            var imag = [Float](repeating: 0, count: n/2)
            var splitComplex = DSPSplitComplex(realp: &real, imagp: &imag)
            
            
            // Perform the FFT
            vDSP_ctoz(complexNumbers, 2, &splitComplex, 1, vDSP_Length(n/2))
            vDSP_fft_zrip(vDSP_create_fftsetup(log2n, FFTDirection(FFT_FORWARD))!, _: &splitComplex, _: 1, _: log2n, FFTDirection(FFT_FORWARD))
            
            // Get the magnitudes of the FFT results
            var magnitudes = [Float](repeating: 0, count: n/2)
            vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(n/2))
            
            // Normalize the magnitudes
            var maxMagnitude: Float = 0
            vDSP_maxv(magnitudes, 1, &maxMagnitude, vDSP_Length(n/2))
            vDSP_vsdiv(magnitudes, 1, &maxMagnitude, &magnitudes, 1, vDSP_Length(n/2))
            
            // Get the frequencies from the magnitudes
            let frequencies = stride(from: 0, to: Float(n/2), by: 1).map { (sampleIndex) -> Float in
                return Float(sampleIndex) * Float(audioFile.processingFormat.sampleRate) / Float(n)
            }
            
            // Return the results
            let result = FFTResult(frequencies: frequencies, powers: magnitudes)
            logger.info("Frequencies: \(frequencies)")
            logger.info("magnitudes: \(magnitudes)")
            
            return result.powers;
        
        } catch {
            logger.error("Error reading audio file: \(error)")
            return[]
        }
    }
    
    
    
    
    
    
    
}
