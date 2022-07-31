//
//  Albedo.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Albedo

public struct Albedo {

    let vector: Vector3

    public init(_ red: Double, _ green: Double, _ blue: Double) {
        vector = Vector3(red, green, blue)
    }

    public init(uniform: Double) {
        vector = Vector3(uniform, uniform, uniform)
    }

}

// MARK: - Colours

public extension Albedo {

    static let black = Albedo(uniform: 0.0)

    static let white = Albedo(uniform: 1.0)

}
