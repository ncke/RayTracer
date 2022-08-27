//
//  YZRectangle.swift
//  
//
//  Created by Nick on 27/08/2022.
//

import Foundation

// MARK: - YZRectangle

public struct YZRectangle: Shape {
    let yRange: ClosedRange<Double>
    let zRange: ClosedRange<Double>
    let xRectangle: Double
    let flipNormal: Bool
    public let material: Material
    public let emitter: Emitter?

    public init(
        y0: Double,
        z0: Double,
        y1: Double,
        z1: Double,
        x: Double,
        material: Material,
        emitter: Emitter? = nil,
        flipNormal: Bool = false
    ) {
        yRange = y0 ... y1
        zRange = z0 ... z1
        xRectangle = x
        self.material = material
        self.emitter = emitter
        self.flipNormal = flipNormal
    }

}

// MARK: - Intersectable

extension YZRectangle: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        let t = (xRectangle - ray.origin.x) / ray.direction.x
        guard tRange.contains(t) else {
            return nil
        }

        let y = ray.origin.y + t * ray.direction.y
        let z = ray.origin.z + t * ray.direction.z
        guard yRange.contains(y), zRange.contains(z) else {
            return nil
        }

        let v = (y - yRange.lowerBound) / yRange.size
        let u = (z - zRange.lowerBound) / zRange.size

        return Intersection(
            shape: self,
            hitDistance: t,
            hitPoint: t * ray,
            uvCoordinate: (u, v),
            outwardNormal: Vector3(1.0, 0.0, 0.0),
            flipNormal: flipNormal,
            incidentRay: ray
        )
    }

}

// MARK: - Bounding Boxable

extension YZRectangle: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        let yBoxed = yRange.extended()
        let zBoxed = zRange.extended()

        let a = Vector3(
            xRectangle - ClosedRange.epsilon,
            yBoxed.lowerBound,
            zBoxed.lowerBound
        )

        let b = Vector3(
            xRectangle + ClosedRange.epsilon,
            yBoxed.upperBound,
            zBoxed.upperBound
        )

        return AxisAlignedBoundingBox(a, b)
    }

}
