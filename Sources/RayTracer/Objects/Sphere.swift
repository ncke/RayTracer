//  Sphere.swift
//  Created by Nick on 03/01/2021.

import Foundation

struct Sphere {
    let center: Point
    let radius: Double
}

extension Sphere: Object {

    func intersection(ray: Ray) -> Point? {
        let a = ray.direction • ray.direction
        let g = (ray.origin - center).asVector
        let b = (2.0 * ray.direction) • g
        let c = (g • g) - (radius * radius)
        let d = (b * b) - 4.0 * a * c

        guard d >= 0.0 else {
            return nil
        }

        let t1 = (-b + d) / (2.0 * a)
        let t2 = (-b - d) / (2.0 * a)
        let t = min(t1, t2)

        return ray.origin + t * ray.direction
    }

}
