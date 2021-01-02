//  Plane.swift
//  Created by Nick on 02/01/2021.

import Foundation

protocol Planar {
    init(normal: Vector, point: Point)
}

struct Plane {
    let h: Double
    let i: Double
    let j: Double
    let k: Double
}

extension Plane: Planar {

    init(normal: Vector, point: Point) {
        // n.x(i - p.x) + n.y(j - p.y) + n.z(k - p.z)
        // n.x*i - n.x*p.x + n.y*j - n.y*p.y + n.z*k - n.z*p.z
        i = normal.x
        j = normal.y
        k = normal.z
        h = -normal.x * point.x - normal.y * point.y - normal.z * point.z
    }

}
