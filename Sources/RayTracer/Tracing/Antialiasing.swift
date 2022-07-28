//
//  Antialiasing.swift
//  
//
//  Created by Nick on 27/07/2022.
//

import Foundation

// MARK: - Antialiasing

public enum Antialiasing {
    case off
    case on(count: Int)
}

// MARK: - Helpers

extension Antialiasing {

    var isOn: Bool {
        switch self {
        case .on: return true
        case .off: return false
        }
    }

    var antialiasCount: Int? {
        switch self{
        case .on(let count): return max(count, 1)
        case .off: return nil
        }
    }

}
