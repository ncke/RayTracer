//
//  Intersectable.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

public protocol Shape {}

struct IntersectionRecord {
    let temp: Double
    let hitPoint: Vector3
    let normal: Vector3
}

protocol Intersectable {

    func intersection(ray: Ray, tRange: Range<Double>) -> IntersectionRecord?

}
