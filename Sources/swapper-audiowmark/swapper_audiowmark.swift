import Logging
import Foundation
import Accelerate
import AVFoundation
import Accelerate
import AudioKit

public struct swapper_audiowmark {
    
    
    public struct FFTResult {
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
    
    func decodeAndReport(wavData: WavData, origPattern: String) -> Int {
        logger.info("Decode and Report Init")
        var resultSet = ResultSet()
//        var blockDecoder = BlockDecoder()
//        blockDecoder.run(wavData: wavData, resultSet: &resultSet)
//        let time_offset = Double(first_sample) / wavData.sample_rate() / Double(wavData.n_channels())
        let time_offset = 0
        let clipDecoder = ClipDecoder()
        clipDecoder.run_padded(wav_data: wavData, result_set: resultSet, time_offset_sec: Double(time_offset))
//        resultSet.printResultSet()

//        if !origPattern.isEmpty {
//            resultSet.printMatchCount(origPattern: origPattern)
//            blockDecoder.printDebugSync()
//        }

        return 0
    }
    
    
    public func readWavIntoFloats(fname: String, ext: String) -> [Float]{
        let logger = Logger(label: "swift-audiowmark")
        do {
            logger.info("Init read of audiostring at: \(fname)")
            let url = URL(fileURLWithPath: fname)
            
            // Read the audio file into memory
            let file = try? AVAudioFile(forReading: url)
            guard let audioFile = file else { return [] }
            
            // Get the audio buffer from the file
            let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length))
            try? audioFile.read(into: buffer!)
            
            // Get the audio buffer data and cast it as a float array
            let audioData = Array(UnsafeBufferPointer(start:buffer?.floatChannelData![0], count:Int(buffer!.frameLength)))
            
        
            // Set up the FFT variables
            let log2n = UInt(10)
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
//            logger.info("Frequencies: \(frequencies)")
//            logger.info("magnitudes2 Count: \(frequencies.count)")
//            logger.info("magnitudes: \(magnitudes)")
//            logger.info("magnitudes1 count: \(magnitudes.count)")
            
            let wavData = WavData.init(samples: audioData,n_channels: audioFile.fileFormat.channelCount.hashValue, sample_rate: Int(audioFile.fileFormat.sampleRate), bit_depth: 0)
            
            decodeAndReport(wavData: wavData, origPattern:"")
            logger.info("WavData count: \(magnitudes.count)")
            return result.powers;
        
        } catch {
            logger.error("Error reading audio file: \(error)")
            return[]
        }
    }
    
    
    
    
}
