//
//  Sphere.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Sphere

public struct Sphere: Shape {
    let center: Vector3
    let radius: Double
    public let material: Material

    public init(
        _ x: Double,
        _ y: Double,
        _ z: Double,
        radius: Double,
        material: Material
    ) {
        self.center = Vector3(x, y, z)
        self.radius = radius
        self.material = material
    }

    init(center: Vector3, radius: Double, material: Material) {
        self.center = center
        self.radius = radius
        self.material = material
    }
}

// MARK: - Intersectable

extension Sphere: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        let centerOffset = ray.origin - center

        // Calculate discriminant of the quadratic equation.
        let a = ray.direction.squareLength
        let bHalf = centerOffset ⋅ ray.direction
        let c = centerOffset.squareLength - radius * radius
        let discriminant = bHalf * bHalf - a * c

        guard discriminant >= 0.0 else {
            // The ray is not incident with the sphere.
            return nil
        }

        let sqrtd = sqrt(discriminant)

        let t1 = (-bHalf - sqrtd) / a
        if tRange.contains(t1) {
            let hitPoint = t1 * ray
            let outwardNormal = (hitPoint - center) / radius

            return Intersection(
                shape: self,
                hitDistance: t1,
                hitPoint: hitPoint,
                uvCoordinate: sphereUV(position: outwardNormal),
                outwardNormal: outwardNormal,
                incidentRay: ray
            )
        }

        let t2 = (-bHalf + sqrtd) / a
        if tRange.contains(t2) {
            let hitPoint = t2 * ray
            let outwardNormal = (hitPoint - center) / radius

            return Intersection(
                shape: self,
                hitDistance: t2,
                hitPoint: hitPoint,
                uvCoordinate: sphereUV(position: outwardNormal),
                outwardNormal: outwardNormal,
                incidentRay: ray
            )
        }

        return nil
    }

    private func sphereUV(position: Vector3) -> (Double, Double) {
        let phi = atan2(-position.z, position.x) + Double.pi
        let theta = acos(-position.y)
        let u = phi / (2.0 * Double.pi)
        let v = theta / Double.pi

        return (u, v)
    }

}

// MARK: - Bounding Boxable

extension Sphere: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        let radial = Vector3(radius, radius, radius)
        return AxisAlignedBoundingBox(center - radial, center + radial)
    }

}

// MARK: - Unit Radius

extension Sphere {

    static let unitRadius = 1.0

}

// MARK: - Random Interior Point

extension Sphere {

    static func randomInteriorPoint(radius: Double) -> Vector3 {
        while true {
            let unitRandom = Vector3(
                Double.random(in: 0.0..<1.0),
                Double.random(in: 0.0..<1.0),
                Double.random(in: 0.0..<1.0)
            )

            let unitPoint = 2.0 * unitRandom - Vector3(1.0, 1.0, 1.0)

            if unitPoint ⋅ unitPoint >= Sphere.unitRadius {
                continue
            }

            return radius * unitPoint
        }
    }

}
