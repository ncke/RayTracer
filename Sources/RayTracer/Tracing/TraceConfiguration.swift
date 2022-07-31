//
//  TraceConfiguration.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Trace Configuration

public struct TraceConfiguration {

    var antialiasing = Antialiasing.off

    var depthRange = 0.001..<Double.greatestFiniteMagnitude

    var maxScatters = 50

}

// MARK: - Antialiasing

extension TraceConfiguration {

    func effectiveAntialiasCount() -> Int {
        switch self.antialiasing {
        case .off: return 1
        case .on(let count): return max(count, 1)
        }
    }

}
