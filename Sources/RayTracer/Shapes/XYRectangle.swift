//
//  XYRectangle.swift
//  
//
//  Created by Nick on 14/08/2022.
//

import Foundation

// MARK: - XYRectangle

public struct XYRectangle: Shape {
    let xRange: ClosedRange<Double>
    let yRange: ClosedRange<Double>
    let zRectangle: Double
    public let material: Material
    public let emitter: Emitter?

    public init(
        x0: Double,
        y0: Double,
        x1: Double,
        y1: Double,
        z: Double,
        material: Material,
        emitter: Emitter? = nil
    ) {
        xRange = x0 ... x1
        yRange = y0 ... y1
        zRectangle = z
        self.material = material
        self.emitter = emitter
    }

}

// MARK: - Intersectable

extension XYRectangle: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        let t = (zRectangle - ray.origin.z) / ray.direction.z
        guard tRange.contains(t) else {
            return nil
        }

        let x = ray.origin.x + t * ray.direction.x
        let y = ray.origin.y + t * ray.direction.y
        guard xRange.contains(x), yRange.contains(y) else {
            return nil
        }

        let u = (x - xRange.lowerBound) / xRange.size
        let v = (y - yRange.lowerBound) / yRange.size

        return Intersection(
            shape: self,
            hitDistance: t,
            hitPoint: t * ray,
            uvCoordinate: (u, v),
            outwardNormal: Vector3(0.0, 0.0, 1.0),
            incidentRay: ray
        )
    }

}

// MARK: - Bounding Boxable

extension XYRectangle: BoundingBoxable {

    private static let epsilon = 1E-5

    func boundingBox() -> AxisAlignedBoundingBox {
        let xBoxed = xRange.extended(by: XYRectangle.epsilon)
        let yBoxed = yRange.extended(by: XYRectangle.epsilon)

        let a = Vector3(
            xBoxed.lowerBound,
            yBoxed.lowerBound,
            zRectangle - XYRectangle.epsilon
        )

        let b = Vector3(
            xBoxed.upperBound,
            yBoxed.upperBound,
            zRectangle + XYRectangle.epsilon
        )

        return AxisAlignedBoundingBox(a, b)
    }

}

// MARK: - Range Helper

fileprivate extension ClosedRange where Bound == Double {

    var size: Double {
        self.upperBound - self.lowerBound
    }

    func extended(by epsilon: Double) -> ClosedRange<Double> {
        (self.lowerBound - epsilon) ... (self.upperBound + epsilon)
    }

}
