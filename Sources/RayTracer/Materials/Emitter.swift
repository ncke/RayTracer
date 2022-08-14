//
//  Emitter.swift
//  
//
//  Created by Nick on 14/08/2022.
//

import Foundation

// MARK: - Emitter

public class Emitter {}

// MARK: - Emitting

protocol Emitting {

    func color(u: Double, v: Double, position: Vector3) -> Vector3

}
