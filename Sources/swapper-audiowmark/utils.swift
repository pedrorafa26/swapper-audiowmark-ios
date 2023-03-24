//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/12/23.
//

import Logging
import Foundation
import Accelerate
import AVFoundation
import Accelerate
import AudioKit

let logger = Logger(label: "swift-audiowmark")

public func bitVecToString(bitVec: [Int]) -> String {
    var bitStr = ""

    for pos in stride(from: 0, to: bitVec.count - 3, by: 4) { // convert only groups of 4 bits
        var nibble = 0
        for j in 0..<4 {
            if bitVec[pos + j] != 0 {
                // j == 0 has the highest value, then 1, 2, 3 (lowest)
                nibble |= 1 << (3 - j)
            }
        }
        let toHex = "0123456789abcdef"
        bitStr.append(toHex[toHex.index(toHex.startIndex, offsetBy: nibble)])
    }
    logger.info("-------bitString--------------: \(bitStr)")
    return bitStr
}

public func runFFTWithRange(audioData: Array<Float>, startIndex : Int) -> [Float] {
    // Set up the FFT variables
    let log2n = UInt(10)
    let n = Int(1 << log2n)
    var complexNumbers = [DSPComplex](repeating: DSPComplex(real: 0, imag: 0), count: n/2)

    // Convert input to complex numbers
    for i in 0..<n/2 {
        if((2 * (startIndex + i)) < audioData.count-1){
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
    
//        // Get the frequencies from the magnitudes
//        let frequencies = stride(from: 0, to: Float(n/2), by: 1).map { (sampleIndex) -> Float in
//            return Float(sampleIndex) * Float(audioFile.processingFormat.sampleRate) / Float(n)
//        }
    
    // Return the results
//        let result = FFTResult(frequencies: frequencies, powers: magnitudes)
    return magnitudes;
}
