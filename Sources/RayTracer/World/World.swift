//
//  World.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - World

public class World {

    var shapes: [Shape]

    init() {
        shapes = []
    }

}

// MARK: - Provisioning Shapes

public extension World {

    func addShape(_ shape: Shape) {
        shapes.append(shape)
    }

    func addShapes(_ shapes: Shape...) {
        self.shapes.append(contentsOf: shapes)
    }

}

// MARK: - Intersections

extension World {

    func nearestIntersection(
        ray: Ray,
        depthRange: Range<Double>
    ) -> Intersection? {
        var nearest: Intersection?

        for shape in shapes {
            guard let intersectableShape = shape as? Intersectable else {
                continue
            }

            let intersection = intersectableShape.intersect(
                ray: ray,
                tRange: depthRange
            )

            guard let intersected = intersection else {
                continue
            }

            guard let nearestSoFar = nearest else {
                nearest = intersected
                continue
            }

            if intersected.hitDistance < nearestSoFar.hitDistance {
                nearest = intersected
            }
        }

        return nearest
    }

}
