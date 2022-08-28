//
//  DiffuseLight.swift
//  
//
//  Created by Nick on 10/08/2022.
//

import Foundation

// MARK: - DiffuseLight

public class DiffuseLight: Emitter {

    let emitColor: Vector3

    public init(r: Double, g: Double, b: Double) {
        emitColor = Vector3(r, g, b)
    }

}

// MARK: - Emitting

extension DiffuseLight: Emitting {

    func color(u: Double, v: Double, position: Vector3) -> Vector3 {
        return emitColor
    }

}
