//
//  RefractiveIndex.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Refactive Index

public struct RefractiveIndex {

    let index: Double

    init(_ index: Double) {
        self.index = index
    }

}

// MARK: - Common Indices

public extension RefractiveIndex {

    static let air = RefractiveIndex(1.0)

    static let glass = RefractiveIndex(1.5)

    static let diamond = RefractiveIndex(2.4)

}
