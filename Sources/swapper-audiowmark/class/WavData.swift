
import Foundation

public class WavData {
    var m_samples: [Float] = []
    var m_n_channels: Int = 0
    var m_sample_rate: Int = 0
    var m_bit_depth: Int = 0
    
    public init() {}
    
    public init(samples: [Float], n_channels: Int, sample_rate: Int, bit_depth: Int) {
        m_samples = samples
        m_n_channels = n_channels
        m_sample_rate = sample_rate
        m_bit_depth = bit_depth
    }
    
    public func sampleRate() -> Int {
        return m_sample_rate
    }
    
    public func bitDepth() -> Int {
        return m_bit_depth
    }
    
    public func setSamples(samples: [Float]) {
        m_samples = samples
    }
}
