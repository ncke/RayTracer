//  Ray.swift
//  Created by Nick on 03/01/2021.

import Foundation

struct Ray {
    let origin: Point
    let direction: Vector
}

extension Ray {

    init(origin: Point, towards destination: Point) {
        let diff = destination - origin

        self.origin = origin
        self.direction = diff.asVector.normalized
    }

}
