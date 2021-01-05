//
//  File.swift
//  
//
//  Created by Nick on 01/01/2021.
//

import Foundation

struct Point {
    let x: Double
    let y: Double
    let z: Double
}

extension Point {

    static let zero = Point(0.0, 0.0, 0.0)

    var asVector: Vector { Vector(x, y, z) }

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    func distance(to point: Point) -> Double {
        let dx = point.x - self.x
        let dy = point.y - self.y
        let dz = point.z - self.z

        return sqrt((dx * dx) + (dy * dy) + (dz * dz))
    }

}

func + (lhs: Point, rhs: Point) -> Point {
    Point(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func - (lhs: Point, rhs: Point) -> Point {
    Point(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

func + (lhs: Point, rhs: Vector) -> Point {
    Point(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}
