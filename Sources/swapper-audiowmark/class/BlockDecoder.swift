
import Foundation

class BlockDecoder {
    var debugSyncFrameCount: Int = 0
    var syncScores: [SyncFinder.Score] = [] // stored here for sync debugging

//    func run(wavData: WavData, resultSet: inout ResultSet) {
//        var total_count = 0
//        var sync_finder = SyncFinder()
//        var sync_scores = sync_finder.search(wavData: wavData, mode: .block)
//        var raw_bit_vec_all = [Float](repeating: 0, count: code_size(blockType: .ab, payloadSize: Params.payload_size))
//        var raw_bit_vec_norm = [Int](repeating: 2, count: 0)
//        var score_all = SyncFinder.Score(quality: 0, index: 0)
//        var score_ab = SyncFinder.Score(quality: 0, index: 0, blockType: .ab)
//        var last_block_type = ConvBlockType.b
//        var ab_raw_bit_vec = [[Float]](repeating: [Float](repeating: 0, count: code_size(blockType: .a, payloadSize: Params.payload_size)), count: 2)
//        var ab_quality = [Float](repeating: 0, count: 2)
//        var fft_analyzer = FFTAnalyzer(wavData.n_channels())
//    }
    
}
