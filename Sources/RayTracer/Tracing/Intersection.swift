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
    let uvCoordinate: (Double, Double)
    let normal: Vector3
    let isFrontFace: Bool
}

extension Intersection {

    init(
        shape: Shape,
        hitDistance: Double,
        hitPoint: Vector3,
        uvCoordinate: (Double, Double),
        outwardNormal: Vector3,
        incidentRay: Ray
    ) {
        self.shape = shape
        self.hitDistance = hitDistance
        self.hitPoint = hitPoint
        self.uvCoordinate = uvCoordinate

        isFrontFace = (incidentRay.direction ⋅ outwardNormal) < Double.zero
        normal = isFrontFace ? outwardNormal : -outwardNormal
    }

}
