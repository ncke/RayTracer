//
//  AxisAlignedBoundingBox.swift
//  
//
//  Created by Nick on 02/08/2022.
//

import Foundation

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

    func intersection(ray: Ray, depthRange: Range<Double>) -> Bool {
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

// MARK: - Bounding Boxable

protocol BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox

}

extension AxisAlignedBoundingBox: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        return self
    }
}

// MARK: - Surrounding Boxes

extension AxisAlignedBoundingBox {

    static func surroundingBox(
        _ boxable0: BoundingBoxable?,
        _ boxable1: BoundingBoxable?
    ) -> AxisAlignedBoundingBox? {
        if let boxable0 = boxable0, boxable1 == nil {
            return boxable0.boundingBox()
        }

        if boxable0 == nil, let boxable1 = boxable1 {
            return boxable1.boundingBox()
        }

        guard let boxable0 = boxable0, let boxable1 = boxable1 else {
            return nil
        }

        let box0 = boxable0.boundingBox()
        let box1 = boxable1.boundingBox()

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

    static func augmentedBox(
        _ boxable0: BoundingBoxable,
        _ boxable1: BoundingBoxable
    ) -> AxisAlignedBoundingBox {
        surroundingBox(boxable0, boxable1)!
    }

}
