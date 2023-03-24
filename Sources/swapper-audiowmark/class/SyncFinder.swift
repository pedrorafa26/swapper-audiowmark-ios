//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/14/23.
//

import Foundation

public enum ConvBlockType {
    case a
    case b
    case ab
}

public class SyncFinder {
    public enum Mode {
        case block
        case clip
    }

    public struct Score {
        public var index: Int
        public var quality: Double
        public var blockType: ConvBlockType
    }

    private struct FrameBit {
        var frame: Int
        var up: [Int]
        var down: [Int]
    }

    private var syncBits = [[FrameBit]]()
    
    var wavDataFirst: Int = 0
    var wavDataLast: Int = 0
    
    public func search(wavData: WavData, mode: Mode) -> [Score] {
        
        
        return fakeSync(wavData, mode)
        
        //Adjust to proper sync
        
        
//        initUpDown(wavData: wavData, mode: mode)
//
//        if mode == .clip {
//            // in clip mode we optimize handling large areas of padding which is silent
//            scanSilence(wavData: wavData)
//        } else {
//            // in block mode we don't do anything special for silence at beginning/end
//            wavDataFirst = 0
//            wavDataLast = wavData.m_samples.count
//        }
//
//        var syncScores = searchApprox(wavData, mode: mode)
//
//        syncSelectByThreshold(&syncScores)
//
//        if mode == .clip {
//            syncSelectNBest(&syncScores, 5)
//        }
//
//        searchRefine(wavData: wavData, mode: mode, syncScores: &syncScores)
//
//        return syncScores
    }
    
    public func syncSelectByThreshold(_ syncScores: inout [Score]) {
        let strength = Params.water_delta * 1000
        let syncThreshold1 = strength > 7.5 ? 0.4 : 0.5
        var selectedScores = [Score]()
        
        for i in 0..<syncScores.count {
            let score = syncScores[i]
            if score.quality > syncThreshold1 {
                var qLast = -1.0
                var qNext = -1.0
                if i > 0 {
                    qLast = syncScores[i - 1].quality
                }
                if i + 1 < syncScores.count {
                    qNext = syncScores[i + 1].quality
                }
                if score.quality > qLast && score.quality > qNext {
                    selectedScores.append(score)
                }
            }
        }
        syncScores = selectedScores
    }
    
    public func frameCount(_ wavData: WavData) -> Int {
        return wavData.m_samples.count / wavData.m_n_channels / Int(Params.frameSize)
    }
    
//    public func syncDecode(wavData: WavData, startFrame: Int, fftOutDb: [Float], haveFrames: [Character], blockType: inout ConvBlockType) -> Double {
//        var syncQuality = 0.0
//
//        let nBands = Params.maxBand - Params.minBand + 1
//        var bitCount = 0
//
//        for bit in 0..<syncBits.count {
//            let frameBits = syncBits[bit]
//            var umag: Float = 0
//            var dmag: Float = 0
//
//            var frameBitCount = 0
//            for frameBit in frameBits {
//                if haveFrames[startFrame + frameBit.frame] {
//                    let index = ((startFrame + frameBit.frame) * wavData.nChannels()) * nBands
//
//                    for i in 0..<frameBit.up.count {
//                        umag += fftOutDb[index + frameBit.up[i]]
//                        dmag += fftOutDb[index + frameBit.down[i]]
//                    }
//                    frameBitCount += 1
//                }
//            }
//
//            // convert avoiding bias, raw_bit < 0 => 0 bit received; raw_bit > 0 => 1 bit received
//            let rawBit: Double
//            if umag == 0 || dmag == 0 {
//                rawBit = 0
//            } else if umag < dmag {
//                rawBit = 1 - Double(umag) / Double(dmag)
//            } else {
//                rawBit = Double(dmag) / Double(umag) - 1
//            }
//
//            let expectDataBit = bit & 1 // expect 010101
//            let q = expectDataBit != 0 ? rawBit : -rawBit
//            syncQuality += q * Double(frameBitCount)
//            bitCount += frameBitCount
//        }
//
//        if bitCount > 0 {
//            syncQuality /= Double(bitCount)
//        }
//
//        syncQuality = normalizeSyncQuality(syncQuality)
//
//        if syncQuality < 0 {
//            blockType = ConvBlockType.b
//            return -syncQuality
//        } else {
//            blockType = ConvBlockType.a
//            return syncQuality
//        }
//    }
    
    public func searchApprox(_ wavData: WavData, mode: Mode) -> [Score] {
        var fftDb = [Float]()
        var haveFrames = [Bool]()
        var syncScores = [Score]()
        
        let nBands = Params.maxBand - Params.minBand + 1
        var totalFrameCount = markSyncFrameCount() + markDataFrameCount()
        if mode == .clip {
            totalFrameCount *= 2
        }
        
        let syncSearchStep = Params.syncSearchStep
        let frameCount = self.frameCount(wavData)
        for syncShift in stride(from: 0, to: Params.frameSize, by: syncSearchStep) {
//            syncFft(wavData: wavData, index: Int(syncShift), frameCount: frameCount - 1, fftOutDb: &fftDb, haveFrames: &haveFrames, wantFrames: [])
            for startFrame in 0..<frameCount {
                let syncIndex = UInt(startFrame) * Params.frameSize + syncShift
                if (startFrame + totalFrameCount) * wavData.m_n_channels * nBands < fftDb.count {
                    var blockType : ConvBlockType
//                    let quality = syncDecode(wavData, startFrame: startFrame, fftDb: fftDb, haveFrames: haveFrames, blockType: &blockType)
//                    syncScores.append(Score(index: syncIndex, quality: quality, blockType: blockType))
                }
            }
        }
        
        syncScores.sort(by: { $0.index < $1.index })
        return syncScores
    }
    
//    public func syncFft(wavData: WavData, index: Int, frameCount: Int, fftOutDb: inout [Float], haveFrames: inout [Bool], wantFrames: [Bool]) {
//        fftOutDb.removeAll()
//        haveFrames.removeAll()
//
//        // read past end? -> fail
//        if wavData.nValues < (index + frameCount * Params.frameSize) * wavData.nChannels {
//            return
//        }
//
//        let fftAnalyzer = FFTAnalyzer(channels: wavData.nChannels)
//        let samples = wavData.samples
//        let nBands = Params.maxBand - Params.minBand + 1
//        var outPos = 0
//
//        fftOutDb = Array(repeating: 0, count: wavData.nChannels * nBands * frameCount)
//        haveFrames = Array(repeating: false, count: frameCount)
//
//        let wavDataFirst = 0
//        let wavDataLast = wavData.nValues - 1
//
//        for f in 0..<frameCount {
//            let fFirst = (index + f * Params.frameSize) * wavData.nChannels
//            let fLast = (index + (f + 1) * Params.frameSize) * wavData.nChannels
//
//            if (wantFrames.count != 0 && !wantFrames[f]) || fLast < wavDataFirst || fFirst > wavDataLast {
//                // frame not wanted? OR frame in silence before/after input?
//                outPos += nBands * wavData.nChannels
//            } else {
//                let minDb = -96.0
//
//                let frameResult = fftAnalyzer.run_fft(samples, index + f * Params.frameSize)
//
//                // computing db-magnitude is expensive, so we better do it here
//                for ch in 0..<wavData.nChannels {
//                    for i in Params.minBand...Params.maxBand {
//                        fftOutDb[outPos] = db_from_factor(abs(frameResult[ch][i]), minDb)
//                        outPos += 1
//                    }
//                }
//
//                haveFrames[f] = true
//            }
//        }
//    }
    
    public func fakeSync(_ wav_data: WavData, _ mode: Mode) -> [Score] {
        var result_scores: [Score] = []

        if mode == .block {
            let expect0 = Int(Params.framesPadStart * Params.frameSize)
            let expect_step = (markSyncFrameCount() + markDataFrameCount()) * Int(Params.frameSize)
            let expect_end = frameCount(wav_data) * Int(Params.frameSize)

            var ab = 0
            for expect_index : Int in stride(from: expect0, to: expect_end - expect_step, by: expect_step) {
                let blockType: ConvBlockType = ((ab &+ 1) == 0) ? .a : .b
                result_scores.append(Score(index: expect_index, quality: 1.0, blockType: blockType))
           }
        }

        return result_scores
    }
    
    public func scanSilence(wavData: WavData) {
        let samples = wavData.m_samples

        // find first non-zero sample
        var wavDataFirst = 0
        while wavDataFirst < samples.count && samples[wavDataFirst] == 0 {
            wavDataFirst += 1
        }

        // search wavDataLast to get [wavDataFirst, wavDataLast) range
        var wavDataLast = samples.count
        while wavDataLast > wavDataFirst && samples[wavDataLast - 1] == 0 {
            wavDataLast -= 1
        }
    }
    
//    public func initUpDown(wavData: WavData, mode: Mode) {
//        syncBits.removeAll()
//
//        let firstBlockEnd = markSyncFrameCount() + markDataFrameCount()
//        let blockCount = (mode == .clip) ? 2 : 1
//        let nBands = Params.maxBand - Params.minBand + 1
//
//        let upDownGen = UpDownGen(randomStream: .syncUpDown)
//        for bit in 0..<Params.syncBits {
//            var frameBits = [FrameBit]()
//            for f in 0..<Params.syncFramesPerBit {
//                let (frameUp, frameDown) = upDownGen.get(frame: f + bit * Params.syncFramesPerBit)
//
//                for block in 0..<blockCount {
//                    var frameBit = FrameBit()
//                    frameBit.frame = syncFramePos(frame: f + bit * Params.syncFramesPerBit) + block * firstBlockEnd
//                    for ch in 0..<wavData.nChannels() {
//                        if block == 0 {
//                            for u in frameUp {
//                                frameBit.up.append(u - Params.minBand + nBands * ch)
//                            }
//                            for d in frameDown {
//                                frameBit.down.append(d - Params.minBand + nBands * ch)
//                            }
//                        } else {
//                            for u in frameUp {
//                                frameBit.down.append(u - Params.minBand + nBands * ch)
//                            }
//                            for d in frameDown {
//                                frameBit.up.append(d - Params.minBand + nBands * ch)
//                            }
//                        }
//                    }
//                    frameBit.up.sort()
//                    frameBit.down.sort()
//                    frameBits.append(frameBit)
//                }
//            }
//            frameBits.sort { $0.frame < $1.frame }
//            syncBits.append(frameBits)
//        }
//    }
}
