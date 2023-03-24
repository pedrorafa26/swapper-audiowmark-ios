//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/19/23.
//

import Foundation

public enum Format: Int {
    case AUTO = 1
    case RAW = 2
}

//Create randomize_bit_order function

class Params {
    static let frameSize: UInt = 1024
    static var framesPerBit: Int = 0
    static let bandsPerFrame: UInt = 30
    static let maxBand: Int = 100
    static let minBand: Int = 20

    static var water_delta: Double = 0.0
    static var mix: Bool = false
    static var hard: Bool = false // hard decode bits? (soft decoding is better)
    static var snr: Bool = false // compute/show snr while adding watermark
    static var have_key: Int = 0

    static var payloadSize: UInt = 0 // number of payload bits for the watermark
    static var payloadShort: Bool = false

    static let syncBits: Int = 6
    static let syncFramesPerBit: Int = 85
    static let syncSearchStep: Int = 256
    static let sync_search_fine: Int = 8
    static let sync_threshold2: Double = 0.7 // minimum refined quality

    static let framesPadStart: UInt = 250 // padding at start, in case track starts with silence
    static let mark_sample_rate: Int = 44100 // watermark generation and detection sample rate

    static let limiter_block_size_ms: Double = 1000
    static let limiter_ceiling: Double = 0.99

    static var test_cut: Int = 0 // for sync test
    static var test_no_sync: Bool = false
    static var test_no_limiter: Bool = false
    static var test_truncate: Int = 0

    static var input_format: Format = .AUTO
    static var output_format: Format = .AUTO

//    static var raw_input_format: RawFormat = .none
//    static var raw_output_format: RawFormat = .none

    static var hls_bit_rate: Int = 0

    // input/output labels can be set for pretty output for videowmark add
    static var input_label: String = ""
    static var output_label: String = ""
}

public func markSyncFrameCount() -> Int {
    return Params.syncBits * Params.syncFramesPerBit
}

func markDataFrameCount() -> Int {
    return convCodeSize(blockType: ConvBlockType.a, msgSize: Int(Params.payloadSize)) * Params.framesPerBit
}

typealias UpDownArray = [Int]

class UpDownGen {
    let randomStream: Random.Stream
    let random: Random
    var bandsReorder: [Int]

    init(randomStream: Random.Stream) {
        self.randomStream = randomStream
        self.random = Random(seed: 0, stream: randomStream)
        self.bandsReorder = [Int](repeating: 0, count: Params.maxBand - Params.minBand + 1)

//        var x = UpDownArray()
//        assert(x.count == Params.bandsPerFrame)
    }

    func get(f: Int, up: inout UpDownArray, down: inout UpDownArray) {
        for i in 0..<bandsReorder.count {
            bandsReorder[i] = Params.minBand + i
        }

        random.seed(UInt64(f), randomStream)
        random.shuffle(&bandsReorder)

        assert(2 * Params.bandsPerFrame < bandsReorder.count)
        for i in 0..<Params.bandsPerFrame {
//            up[i] = bandsReorder[i]
//            down[i] = bandsReorder[Params.bandsPerFrame + i]
        }
    }
}
