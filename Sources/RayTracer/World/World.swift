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

    public init() {
        shapes = []
    }

    public init(shapes: [Shape]) {
        self.shapes = shapes
    }

    public convenience init(_ shapes: Shape...) {
        self.init(shapes: shapes)
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

    func asIntersectableTree() -> IntersectableTree? {
        let qualifyingShapes: [Intersectable] = shapes.compactMap { shape in
            guard
                shape is BoundingBoxable,
                let intersectableShape = shape as? Intersectable
            else {
                return nil
            }

            return intersectableShape as Intersectable
        }

        return IntersectableTree.make(intersectables: qualifyingShapes)
    }

    static func nearestIntersection(
        intersectableTree: IntersectableTree,
        ray: Ray,
        depthRange: Range<Double>
    ) -> Intersection? {
        intersectableTree.intersect(ray: ray, tRange: depthRange)
    }

}
