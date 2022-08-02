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

    case branch(left: IntersectableTree?, right: IntersectableTree?)

}

// MARK: - Hit Testing

extension IntersectableTree {

    func nearestIntersectable(
        ray: Ray,
        depthRange: Range<Double>
    ) -> Intersectable? {
        guard
            let result = hit(ray: ray, depthRange: depthRange),
            case let .leaf(intersectable) = result
        else {
            return nil
        }

        return intersectable
    }

    func hit(ray: Ray, depthRange: Range<Double>) -> IntersectableTree? {

        return nil

    }

}
