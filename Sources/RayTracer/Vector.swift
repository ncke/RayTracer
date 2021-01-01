//  Vector.swift
//  Created by Nick on 01/01/2021.
//

import Foundation

struct Vector {
    let x: Double
    let y: Double
    let z: Double
}

extension Vector {

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    static var zero: Vector { Vector(0.0, 0.0, 0.0) }

    static var unit: Vector { Vector(1.0, 1.0, 1.0) }

    var length: Double {
        sqrt(x * x + y * y + z * z)
    }

    var normalized: Vector {
        let length = self.length
        return Vector(x / length, y / length, z / length)
    }

}

func + (lhs: Vector, rhs: Vector) -> Vector {
    Vector(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func - (lhs: Vector, rhs: Vector) -> Vector {
    Vector(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func * (lhs: Double, rhs: Vector) -> Vector {
    Vector(lhs * rhs.x, lhs * rhs.y, lhs * rhs.z)
}

func * (lhs: Vector, rhs: Double) -> Vector {
    rhs * lhs
}

infix operator ✕
func ✕ (lhs: Vector, rhs: Vector) -> Vector {
    Vector(
        lhs.y * rhs.z - lhs.z * rhs.y,
        lhs.z * rhs.x - lhs.x * rhs.z,
        lhs.x * rhs.y - lhs.y * rhs.x
    )
}

infix operator •
func • (lhs: Vector, rhs: Vector) -> Double {
    lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}
