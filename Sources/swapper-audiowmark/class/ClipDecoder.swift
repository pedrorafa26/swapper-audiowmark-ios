//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/23/23.
//

import Foundation
import Logging
import Accelerate



public func normalizeSoftBits(softBits: [Float]) -> [Float] {
    var normSoftBits: [Float] = []
    // Figure out average level of each bit
    var mean: Float = 0
    for value in softBits {
        mean += abs(value)
    }
    mean /= Float(softBits.count)

    // Rescale from [-mean,+mean] to [0.0,1.0]
    for value in softBits {
        normSoftBits.append(0.5 * (Float(value / mean) + 1))
    }

    return normSoftBits
}

public class ClipDecoder {
    let logger = Logger(label: "swift-audiowmark")
    
    public var frames_per_block: Int = 0
    
    init() {
        self.frames_per_block = markSyncFrameCount() + markDataFrameCount()
    }
    
//    public func mix_or_linear_decode(fft_out: inout [[DSPComplex]], n_channels: Int) -> [Float] {
//        return linearDecode(fft_out: &fft_out, n_channels: n_channels)
//    }
    
    public func run_padded(wav_data: WavData, result_set: ResultSet, time_offset_sec: Double) {
        logger.info("Init del Run_padded -----")
        let sync_finder = SyncFinder()
        let sync_scores = sync_finder.search(wavData: wav_data, mode: .clip)
//        let fft_analyzer = FFTAnalyzer(wav_data.n_channels())
        logger.info("------- sync Score --------------: \(sync_scores)")
        logger.info("------- sync Score length--------------: \(sync_scores.count)")
        for sync_score in sync_scores {
            let count = markSyncFrameCount() + markDataFrameCount()
            let index = sync_score.index
            let raw_bit_vec = [Float]()
            let fft_range_out1 = runFFTWithRange(audioData: wav_data.m_samples, startIndex: index)
            let fft_range_out2 = runFFTWithRange(audioData: wav_data.m_samples, startIndex: index + count * Int(Params.frameSize))
            if !fft_range_out1.isEmpty && !fft_range_out2.isEmpty {
            
            // Pending reorganize and generate raw bit vec per bolock
//            let raw_bit_vec1 = randomize_bit_order(mix_or_linear_decode(fft_out: &fft_range_out1, n_channels: wav_data.n_channels()), encode: false)
//            let raw_bit_vec2 = randomize_bit_order(mix_or_linear_decode(fft_out: &fft_range_out2, n_channels: wav_data.n_channels()), encode: false)
//            let bits_per_block = raw_bit_vec1.count
//            var raw_bit_vec = [Float]()
//            for i in 0..<bits_per_block {
//                if sync_score.block_type == .a {
//                    raw_bit_vec.append(raw_bit_vec1[i])
//                    raw_bit_vec.append(raw_bit_vec2[i])
//                } else {
//                    raw_bit_vec.append(raw_bit_vec2[i])
//                    raw_bit_vec.append(raw_bit_vec1[i])
//                }
//            }
            var decode_error: Float = 0
            
            let bit_vec = convDecodeSoft(blockType: .ab, codedBits: normalizeSoftBits(softBits: raw_bit_vec), errorOut: &decode_error)
            if !bit_vec.isEmpty {
                result_set.add_pattern(bit_vec: bit_vec, decode_error: decode_error, pattern_type: .CLIP)
            }
        }
    }
//            let fft_range_out1 = fft_analyzer.fft_range(wav_data.samples(), index: index, count: count)
//            let fft_range_out2 = fft_analyzer.fft_range(wav_data.samples(), index: index + count * Params.frame_size, count: count)
//            if !fft_range_out1.isEmpty && !fft_range_out2.isEmpty {
//                let raw_bit_vec1 = randomize_bit_order(mix_or_linear_decode(fft_out: &fft_range_out1, n_channels: wav_data.n_channels()), encode: false)
//                let raw_bit_vec2 = randomize_bit_order(mix_or_linear_decode(fft_out: &fft_range_out2, n_channels: wav_data.n_channels()), encode: false)
//                let bits_per_block = raw_bit_vec1.count
//                var raw_bit_vec = [Float]()
//                for i in 0..<bits_per_block {
//                    if sync_score.block_type == .a {
//                        raw_bit_vec.append(raw_bit_vec1[i])
//                        raw_bit_vec.append(raw_bit_vec2[i])
//                    } else {
//                        raw_bit_vec.append(raw_bit_vec2[i])
//                        raw_bit_vec.append(raw_bit_vec1[i])
//                    }
//                }
//
//                var decode_error: Float = 0
//                let bit_vec = code_decode_soft(.ab, normalize_soft_bits(raw_bit_vec), &decode_error)
//                if !bit_vec.isEmpty {
//                    var sync_score_nopad = sync_score
//                    sync_score_nopad.index = time_offset_sec * wav_data.sample_rate()
//                    result_set.add_pattern(sync_score_nopad, bit_vec: bit_vec, decode_error: decode_error, type: .clip)
//                }
//            }
//        }
            
    
    public enum Pos {
        case start
        case end
    }
    
//    public func runBlock(wavData: WavData, result_set: inout ResultSet, pos: Pos) {
//        let n = (frames_per_block + 5) * Params.frame_size * wavData.n_channels()
//
//        // range of samples used by clip: [first_sample, last_sample)
//        var first_sample: Int
//        var last_sample: Int
//        var pad_samples_start = n
//        var pad_samples_end = n
//
//        if pos == .start {
//            first_sample = 0
//            last_sample = min(n, wavData.n_values())
//
//            // increase padding at start for small blocks
//            // -> (available samples + padding) must always be one L-block
//            if last_sample < n {
//                pad_samples_start += n - last_sample
//            }
//        } else { // (pos == .end)
//            if wavData.n_values() <= n {
//                return
//            }
//            first_sample = wavData.n_values() - n
//            last_sample = wavData.n_values()
//        }
//
//        let time_offset = Double(first_sample) / wavData.sample_rate() / Double(wavData.n_channels())
//        let ext_samples = Array(wavData.samples()[first_sample..<last_sample])
//
//        if false {
//            print("\(pos.rawValue): \(time_offset)..\(time_offset + Double(ext_samples.count) / wavData.sample_rate() / Double(wavData.n_channels()))")
//            print("\(Double(pad_samples_start) / wavData.sample_rate() / Double(wavData.n_channels()))< >\(Double(pad_samples_end) / wavData.sample_rate() / Double(wavData.n_channels()))")
//        }
//
//        ext_samples.insert(contentsOf: Array(repeating: 0, count: pad_samples_start), at: 0)
//        ext_samples.append(contentsOf: Array(repeating: 0, count: pad_samples_end))
//
//        let l_wav_data = WavData(samples: ext_samples, nChannels: wavData.n_channels(), sampleRate: wavData.sample_rate(), bitDepth: wavData.bit_depth())
//        runPadded(l_wav_data: l_wav_data, result_set: &result_set, timeOffset: time_offset)
//    }
//
//    public func run(wavData: WavData, resultSet: ResultSet) {
//        let wavFrames = wavData.nValues() / (Params.frameSize * wavData.nChannels())
//        if wavFrames < framesPerBlock * 3.1 {
//            runBlock(wavData: wavData, resultSet: resultSet, pos: .start)
//            runBlock(wavData: wavData, resultSet: resultSet, pos: .end)
//        }
//    }
}
