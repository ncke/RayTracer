//
//  Intersectable.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Shape

public protocol Shape {}

// MARK: - Intersectable

protocol Intersectable {

    func intersection(ray: Ray, tRange: Range<Double>) -> IntersectionRecord?

}

// MARK: - Intersection Record

struct IntersectionRecord {
    let temp: Double
    let hitPoint: Vector3
    let normal: Vector3
}

