//
//  File.swift
//  
//
//  Created by Alexis Rodriguez on 3/19/23.
//

import Foundation


let ab_generators: [UInt] = [
    066561, 075211, 071545, 054435, 063635, 052475,
    063543, 075307, 052547, 045627, 067657, 051757
]
let ab_rate: UInt32 = UInt32(ab_generators.count)
let order: UInt32 = 15
let stateCount: UInt32 = (1 << order)
let stateMask: UInt32 = (1 << order) - 1

public func getBlockTypeGenerators(block_type: ConvBlockType) -> [UInt] {
    var generators: [UInt] = []

    if block_type == .a {
        for i in stride(from: 0, to: ab_rate/2, by: 1) {
            generators.append(ab_generators[Int(i) * 2])
        }
    } else if block_type == .b {
        for i in stride(from: 0, to: ab_rate/2, by: 1) {
            generators.append(ab_generators[Int(i) * 2 + 1])
        }
    } else {
        assert(block_type == .ab)
        generators = ab_generators
    }

    return generators
}

public func parity(_ v: UInt32) -> Int {
    var p = 0
    var value = v
    
    while value != 0 {
      p ^= (Int(value) & 1)
      value >>= 1
    }
    
    return p
  }

public func convCodeSize(blockType: ConvBlockType, msgSize: Int) -> Int {
    switch blockType {
    case .a, .b:
        return (msgSize + Int(order)) * Int(ab_rate) / 2
    case .ab:
        return (msgSize + Int(order)) * Int(ab_rate)
    @unknown default:
        fatalError("Unknown ConvBlockType")
    }
}

public func convDecodeSoft(blockType: ConvBlockType, codedBits: [Float], errorOut: UnsafeMutablePointer<Float>?) -> [Int] {
    let generators = getBlockTypeGenerators(block_type: blockType)
    let rate = generators.count
    var decodedBits = [Int]()
    
    assert(codedBits.count % rate == 0)
    
    struct StateEntry {
        var lastState: Int
        var delta: Float
        var bit: Int
    }
    
    var errorCount = [[StateEntry]]()
    let stateCount = 1 << order
    for i in stride(from: 0, to: codedBits.count + rate, by: rate) {
        errorCount.append([StateEntry](repeating: StateEntry(lastState: 0, delta: -1, bit: 0), count: stateCount))
    }
    errorCount[0][0].delta = 0
    
    var state2bits = [Float]()
    for state in 0..<stateCount {
        for p in 0..<generators.count {
            let outBit = parity(UInt32(state) & UInt32(generators[p]))
            state2bits.append(Float(outBit))
        }
    }
    
    for i in stride(from: 0, to: codedBits.count, by: rate) {
        let oldTable = errorCount[i / rate]
        var newTable = errorCount[i / rate + 1]
        
        for state in 0..<stateCount {
            if oldTable[state].delta >= 0 {
                for bit in 0..<2 {
                    let newSate = UInt32((state << 1) | bit) & stateMask
                    var delta = oldTable[state].delta
                    let sbitPos = newSate * UInt32(rate)
                    
                    for p in 0..<rate {
                        let cbit = codedBits[i + p]
                        let sbit = state2bits[Int(sbitPos) + p]
                        delta += (cbit - sbit) * (cbit - sbit)
                    }
                    
                    if delta < newTable[Int(newSate)].delta || newTable[Int(newSate)].delta < 0 {
                        newTable[Int(newSate)].delta = delta
                        newTable[Int(newSate)].lastState = state
                        newTable[Int(newSate)].bit = bit
                    }
                }
            }
        }
    }
    
    var state = 0
    if let errorOut = errorOut {
        errorOut.pointee = errorCount.last![state].delta / Float(codedBits.count)
    }
    for idx in stride(from: errorCount.count - 1, to: 0, by: -1) {
        decodedBits.append(errorCount[idx][state].bit)
        state = errorCount[idx][state].lastState
    }
    decodedBits.reverse()
    assert(decodedBits.count >= order)
    decodedBits.removeLast(Int(order))
    
    return decodedBits
}
