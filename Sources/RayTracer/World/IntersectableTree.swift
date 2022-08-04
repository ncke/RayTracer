//
//  IntersectableTree.swift
//  
//
//  Created by Nick on 02/08/2022.
//

import Foundation

// MARK: - Intersectable Tree

indirect enum IntersectableTree {

    case primitive(intersectable: Intersectable)

    case box(
        box: AxisAlignedBoundingBox,
        left: IntersectableTree?,
        right: IntersectableTree?
    )

}

// MARK: - Intersectable

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

        case .primitive(let intersectable):
            return intersectPrimitive(
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

    private func intersectPrimitive(
        intersectable: Intersectable,
        ray: Ray,
        tRange: Range<Double>
    ) -> Intersection? {
        return intersectable.intersect(ray: ray, tRange: tRange)
    }

}

// MARK: - Tree Construction

extension IntersectableTree {

    static func make(intersectables: [Intersectable]) -> IntersectableTree? {
        guard intersectables.count > 0 else {
            return nil
        }

        if intersectables.count == 1 {
            return .primitive(intersectable: intersectables[0])
        }

        let sorted = intersectables.sorted(by: Axis.random.comparator)

        let half = sorted.count / 2
        let leftIntersectables = sorted[0..<half]
        let leftTree = make(intersectables: Array(leftIntersectables))
        let rightIntersectables = sorted[half..<intersectables.count]
        let rightTree = make(intersectables: Array(rightIntersectables))

        guard
            let box = AxisAlignedBoundingBox.surroundingBox(
                leftTree,
                rightTree
            )
        else {
            return nil
        }

        return IntersectableTree.box(
            box: box,
            left: leftTree,
            right: rightTree
        )
    }

    private typealias
    IntersectableComparator = (Intersectable, Intersectable) -> Bool

    private enum Axis {
        case xAxis
        case yAxis
        case zAxis

        static var random: Axis {
            let r = Int.random(in: 0..<3)
            switch r {
            case 0: return xAxis
            case 1: return yAxis
            case 2: return zAxis
            default: fatalError()
            }
        }

        private var index: Int {
            switch self {
            case .xAxis: return 0
            case .yAxis: return 1
            case .zAxis: return 2
            }
        }

        var comparator: IntersectableComparator {
            return { i0, i1 in
                guard
                    let b0 = i0 as? BoundingBoxable,
                    let b1 = i1 as? BoundingBoxable
                else {
                    fatalError()
                }

                let box0 = b0.boundingBox()
                let box1 = b1.boundingBox()

                return box0.min[index] < box1.min[index]
            }
        }
    }

}

// MARK: - Bounding Boxable

extension IntersectableTree: BoundingBoxable {

    func boundingBox() -> AxisAlignedBoundingBox {
        switch self {

        case .primitive(let intersectable):
            guard let boundable = intersectable as? BoundingBoxable else {
                fatalError()
            }

            return boundable.boundingBox()

        case .box(let box, _, _):
            return box

        }
    }

}
