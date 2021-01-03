//  Radians.swift
//  Created by Nick on 03/01/2021.

import Foundation

typealias Radians = Double

extension Radians {

    var asDegrees: Double {
        180.0 * self / Double.pi
    }

    init(degrees: Double) {
        self.init(degrees * Double.pi / 180.0)
    }

}
