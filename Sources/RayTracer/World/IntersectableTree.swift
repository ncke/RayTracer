//
//  IntersectableTree.swift
//  
//
//  Created by Nick on 02/08/2022.
//

import Foundation

// MARK: - Intersectable Tree

indirect enum IntersectableTree {

    case leaf(intersectable: Intersectable)

    case box(
        box: AxisAlignedBoundingBox,
        left: IntersectableTree?,
        right: IntersectableTree?
    )

}

// MARK: - Hit Testing

extension IntersectableTree: Intersectable {

    func intersect(ray: Ray, tRange: Range<Double>) -> Intersection? {
        switch self {

        case .box(let box, let left, let right):
            return intersectBox(
                ray: ray,
                tRange: tRange,
                box: box,
                left: left,
                right: right
            )

        case .leaf(let intersectable):
            return intersectLeaf(
                intersectable: intersectable,
                ray: ray,
                tRange: tRange
            )
        }
    }

    private func intersectBox(
        ray: Ray,
        tRange: Range<Double>,
        box: AxisAlignedBoundingBox,
        left: IntersectableTree?,
        right: IntersectableTree?
    ) -> Intersection? {
        guard box.hit(ray: ray, depthRange: tRange) else {
            return nil
        }

        let intersectionLeft = left?.intersect(ray: ray, tRange: tRange)
        let intersectionRight = right?.intersect(ray: ray, tRange: tRange)

        if let iLeft = intersectionLeft, let iRight = intersectionRight {
            return iLeft.hitDistance < iRight.hitDistance ? iLeft : iRight
        }

        if let iLeft = intersectionLeft {
            return iLeft
        }

        if let iRight = intersectionRight {
            return iRight
        }

        return nil
    }

    private func intersectLeaf(
        intersectable: Intersectable,
        ray: Ray,
        tRange: Range<Double>
    ) -> Intersection? {
        return intersectable.intersect(ray: ray, tRange: tRange)
    }

}
