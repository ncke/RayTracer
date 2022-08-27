//
//  XZRectangle.swift
//  
//
//  Created by Nick on 27/08/2022.
//

import Foundation

// MARK: - XZRectangle

public struct XZRectangle: Shape {
    let xRange: ClosedRange<Double>
    let zRange: ClosedRange<Double>
    let yRectangle: Double
    let flipNormal: Bool
    public let material: Material
    public let emitter: Emitter?

    public init(
        x0: Double,
        z0: Double,
        x1: Double,
        z1: Double,
        y: Double,
        material: Material,
        emitter: Emitter? = nil,
        flipNormal: Bool = false
    ) {
        xRange = x0 ... x1
        zRange = z0 ... z1
        yRectangle = y
        self.material = material
        self.emitter = emitter
        self.flipNormal = flipNormal
    }

}

// MARK: - Intersectable

extension XZRectangle: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        let t = (yRectangle - ray.origin.y) / ray.direction.y
        guard tRange.contains(t) else {
            return nil
        }

        let x = ray.origin.x + t * ray.direction.x
        let z = ray.origin.z + t * ray.direction.z
        guard xRange.contains(x), zRange.contains(z) else {
            return nil
        }

        let u = (x - xRange.lowerBound) / xRange.size
        let v = (z - zRange.lowerBound) / zRange.size

        return Intersection(
            shape: self,
            hitDistance: t,
            hitPoint: t * ray,
            uvCoordinate: (u, v),
            outwardNormal: Vector3(0.0, 1.0, 0.0),
            flipNormal: flipNormal,
            incidentRay: ray
        )
    }

}

// MARK: - Bounding Boxable

extension XZRectangle: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        let xBoxed = xRange.extended()
        let zBoxed = zRange.extended()

        let a = Vector3(
            xBoxed.lowerBound,
            yRectangle - ClosedRange.epsilon,
            zBoxed.lowerBound
        )

        let b = Vector3(
            xBoxed.upperBound,
            yRectangle + ClosedRange.epsilon,
            zBoxed.upperBound
        )

        return AxisAlignedBoundingBox(a, b)
    }

}
