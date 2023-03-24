

import Foundation

public class ResultSet {
    public enum PatternType {
        case BLOCK
        case CLIP
        case ALL
    }
    
    public struct Pattern {
        var bit_vec: [Int]
        var decode_error: Float = 0
        var type: PatternType
    }
    
    private var patterns = [Pattern]()
    
    public func add_pattern(bit_vec: [Int], decode_error: Float, pattern_type: PatternType) {
        var p = Pattern(bit_vec: bit_vec, type: pattern_type)
        p.decode_error = decode_error
        patterns.append(p)
    }
    
    public func printResultSet() {
        patterns.sort {
            let all1 = $0.type == .ALL ? 1 : 0
            let all2 = $1.type == .ALL ? 1 : 0
            if all1 != all2 {
                return all1 < all2
            }
//            else {
//                return $0.sync_score.index < $1.sync_score.index
//            }
            return false
        }
        
//        for pattern in patterns {
//            if pattern.type == .ALL {
//                let fmt = "pattern   all %s %.3f %.3f\n"
//                let str = bitVecToString(bitVec: pattern.bit_vec)
//                let sz = Int(snprintf(nil, fmt, str, pattern.sync_score.quality, pattern.decode_error))
//                var buf = [CChar](repeating: 0, count: sz+1)
//                sprintf(&buf, fmt, str, pattern.sync_score.quality, pattern.decode_error)
//                PatternStorage.getInstance().addPattern(String(cString: buf))
//                print(String(cString: buf), terminator: "")
//            }
//            else {
//                var block_str = ""
//                switch pattern.sync_score.blockType {
//                case .a:
//                    block_str = "A"
//                case .b:
//                    block_str = "B"
//                case .ab:
//                    block_str = "AB"
//                }
//
//                let fmt = "pattern %2d:%02d %s %.3f %.3f %s\n"
//                if pattern.type == .CLIP {
//                    block_str = "CLIP-" + block_str
//                }
//
//                let seconds = pattern.sync_score.index / Params.mark_sample_rate
//                let str = bit_vec_to_str(pattern.bit_vec)
//                let sz = Int(sprintf(nil, fmt, seconds / 60, seconds % 60, str, pattern.sync_score.quality, pattern.decode_error, block_str))
//                var buf = [CChar](repeating: 0, count: sz+1)
//                sprintf(&buf, fmt, seconds / 60, seconds % 60, str, pattern.sync_score.quality, pattern.decode_error, block_str)
//                PatternStorage.getInstance().addPattern(String(cString: buf))
//                debug(fmt, seconds / 60, seconds % 60, str, pattern.sync_score.quality, pattern.decode_error, block_str)
//                print(String(cString: buf), terminator: "")
//            }
//        }
    }
    
    public func printMatchCount(orig_pattern: String) {
//        var match_count = 0
//        let orig_vec = bit_str_to_vec(orig_pattern)
//        
//        for p in patterns {
//            var match = true
//            for i in 0..<p.bit_vec.count {
//                match = match && (p.bit_vec[i] == orig_vec[i % orig_vec.count])
//            }
//            
//            if match {
//                match_count += 1
//            }
//        }
//        print("match_count \(match_count) \(patterns.count)\n", terminator: "")
    }
}
