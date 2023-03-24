//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/23/23.
//

import Foundation

import Foundation

public class Random {
    enum Stream: Int {
        case data_up_down = 1
        case syncUpDown = 2
        case pad_up_down = 3  // unused
        case mix = 4
        case bit_order = 5
        case frame_position = 6
    }
    
//    private var aes_ctr_cipher: gcry_cipher_hd_t?
//    private var seed_cipher: gcry_cipher_hd_t?
    private var buffer = [UInt64]()
    private var buffer_pos = 0
    
//    private func die_on_error(_ funcName: String, _ error: gcry_error_t) {
//        // implementation here
//    }
    
    init(seed: UInt64, stream: Stream) {
        // implementation here
    }
    
    deinit {
        // implementation here
    }
    
    func refill_buffer() {
        // implementation here
    }
    
    func seed(_ seed: UInt64, _ stream: Stream) {
        // implementation here
    }
    
    func shuffle<T>(_ result: inout [T]) {
        // Fisher–Yates shuffle
        for i in 0..<result.count {
            let random_number = self()

            let j = i + Int(random_number % UInt64(result.count - i))
            result.swapAt(i, j)
        }
    }
    
    static func set_global_test_key(_ seed: UInt64) {
        // implementation here
    }
    
    static func load_global_key(_ key_file: String) {
        // implementation here
    }
    
    static func gen_key() -> String {
        // implementation here
        return ""
    }
    
    func callAsFunction() -> UInt64 {
        if buffer_pos == buffer.count {
            refill_buffer()
        }
        
        let result = buffer[buffer_pos]
        buffer_pos += 1
        
        return result
    }
}
