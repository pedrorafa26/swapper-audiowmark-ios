//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/23/23.
//

import Foundation
import Accelerate

public func linearDecode(fftOut: inout [[DSPComplex]], nChannels: Int) -> [Float] {
//    let upDownGen = UpDownGen(Random.Stream.dataUpDown)
    var rawBitVec = [Float]()
    
//    let frameCount = markDataFrameCount()
//    var umag: Double = 0
//    var dmag: Double = 0
//    
//    for f in 0..<frameCount {
//        for ch in 0..<nChannels {
//            let index = dataFramePos(f) * nChannels + ch
//            var up: UpDownArray = []
//            var down: UpDownArray = []
//            upDownGen.get(f, &up, &down)
//            
//            let minDb: Double = -96
//            for u in up {
//                umag += dbFromFactor(abs(fftOut[index][u]), minDb)
//            }
//            
//            for d in down {
//                dmag += dbFromFactor(abs(fftOut[index][d]), minDb)
//            }
//        }
//        
//        if (f % Params.framesPerBit) == (Params.framesPerBit - 1) {
//            rawBitVec.append(Float(umag - dmag))
//            umag = 0
//            dmag = 0
//        }
//    }
    
    return rawBitVec
}
