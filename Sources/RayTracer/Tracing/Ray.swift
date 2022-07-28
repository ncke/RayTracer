//
//  Ray.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Ray

struct Ray {
    let origin: Vector3
    let direction: Vector3

    init(origin: Vector3, direction: Vector3) {
        self.origin = origin
        self.direction = direction
    }
}

// MARK: - Scalar Multiplication

extension Ray {

    static func * (lhs: Double, rhs: Ray) -> Vector3 {
        rhs.origin + lhs * rhs.direction
    }

    static func * (lhs: Ray, rhs: Double) -> Vector3 {
        lhs.origin + rhs * lhs.direction
    }

}
