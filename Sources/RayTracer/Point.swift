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

    var asVector: Vector { Vector(x, y, z) }

    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
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
