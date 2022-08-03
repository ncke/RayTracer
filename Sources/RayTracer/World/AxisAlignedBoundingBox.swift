//
//  AxisAlignedBoundingBox.swift
//  
//
//  Created by Nick on 02/08/2022.
//

import Foundation

// MARK: - Bounding Boxable

protocol BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox

}

// MARK: - Axis Aligned Bounding Box

class AxisAlignedBoundingBox {
    let min: Vector3
    let max: Vector3

    init(_ a: Vector3, _ b: Vector3) {
        min = a
        max = b
    }

}

// MARK: - Hit Testing

extension AxisAlignedBoundingBox {

    func hit(ray: Ray, depthRange: Range<Double>) -> Bool {
        var tMin = depthRange.lowerBound
        var tMax = depthRange.upperBound

        for i in 0..<3 {
            let inverseDirection = 1.0 / ray.direction[i]
            var t0 = (min[i] - ray.origin[i]) * inverseDirection
            var t1 = (max[i] - ray.origin[i]) * inverseDirection

            if inverseDirection < Double.zero {
                swap(&t0, &t1)
            }

            tMin = t0 > tMin ? t0 : tMin
            tMax = t1 < tMax ? t1 : tMax

            if tMax <= tMin {
                return false
            }
        }

        return true
    }

}

// MARK: - Surrounding Boxes

extension AxisAlignedBoundingBox {

    static func surroundingBox(
        _ box0: AxisAlignedBoundingBox,
        _ box1: AxisAlignedBoundingBox
    ) -> AxisAlignedBoundingBox {
        let sml = Vector3(
            Swift.min(box0.min.x, box1.min.x),
            Swift.min(box0.min.y, box1.min.y),
            Swift.min(box0.min.z, box1.min.z)
        )

        let big = Vector3(
            Swift.max(box0.max.x, box1.max.x),
            Swift.max(box0.max.y, box1.max.y),
            Swift.max(box0.max.z, box1.max.z)
        )

        return AxisAlignedBoundingBox(sml, big)
    }

}
