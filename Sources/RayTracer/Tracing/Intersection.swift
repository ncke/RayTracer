//
//  Intersection.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Intersection

struct Intersection {
    let shape: Shape
    let hitDistance: Double
    let hitPoint: Vector3
    let normal: Vector3
    let isFrontFace: Bool
}

extension Intersection {

    init(
        shape: Shape,
        hitDistance: Double,
        hitPoint: Vector3,
        outwardNormal: Vector3,
        incidentRay: Ray
    ) {
        self.shape = shape
        self.hitDistance = hitDistance
        self.hitPoint = hitPoint

        isFrontFace = (incidentRay.direction ⋅ outwardNormal) < Double.zero
        normal = isFrontFace ? outwardNormal : -outwardNormal
    }

}
