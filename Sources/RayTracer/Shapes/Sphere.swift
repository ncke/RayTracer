//
//  Sphere.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Sphere

public struct Sphere: Shape {
    let center: Vector3
    let radius: Double

    public init(_ x: Double, _ y: Double, _ z: Double, _ radius: Double) {
        self.center = Vector3(x, y, z)
        self.radius = radius
    }

    init(center: Vector3, radius: Double) {
        self.center = center
        self.radius = radius
    }
}

// MARK: - Intersectable

extension Sphere: Intersectable {

    func intersection(ray: Ray, tRange: Range<Double>) -> IntersectionRecord? {
        let centerOffset = ray.origin - center

        // Discriminant of the quadratic equation.
        let a = ray.direction ⋅ ray.direction
        let b = 2.0 * centerOffset ⋅ ray.direction
        let c = centerOffset ⋅ centerOffset - radius * radius
        let discriminant = b * b - 4.0 * a * c

        guard discriminant >= 0.0 else {
            // The ray is not incident with the sphere.
            return nil
        }

        let t1 = (-b - sqrt(discriminant)) / (2.0 * a)
        if tRange.contains(t1) {
            let hitPoint = t1 * ray
            return IntersectionRecord(
                temp: t1,
                hitPoint: hitPoint,
                normal: (hitPoint - center) / radius
            )
        }

        let t2 = (-b + sqrt(discriminant)) / (2.0 * a)
        if tRange.contains(t2) {
            let hitPoint = t2 * ray
            return IntersectionRecord(
                temp: t2,
                hitPoint: hitPoint,
                normal: (hitPoint - center) / radius
            )
        }

        return nil
    }

}

// MARK: - Unit Sphere at Origin

extension Sphere {

    static let unit = Sphere(center: Vector3.zero, radius: 1.0)

}

// MARK: - Random Interior Point

extension Sphere {

    var randomInteriorPoint: Vector3 {
        while true {
            let unitRandom = Vector3(
                Double.random(in: 0.0..<1.0),
                Double.random(in: 0.0..<1.0),
                Double.random(in: 0.0..<1.0)
            )

            let unitPoint = 2.0 * unitRandom - Vector3(1.0, 1.0, 1.0)

            if unitPoint ⋅ unitPoint >= 1.0 {
                continue
            }

            return radius * unitPoint
        }
    }

}
