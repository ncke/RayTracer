//
//  ColorVector.swift
//  Created by Nick on 22/04/2022.
//

import Foundation

// MARK: - Color Vector

struct ColorVector {
    let red: Int
    let green: Int
    let blue: Int

    var asVector3: Vector3 { Vector3(Double(red), Double(green), Double(blue)) }

    init(_ red: Int, _ green: Int, _ blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(_ red: Double, _ green: Double, _ blue: Double) {
        self.red = Int(255.99 * red)
        self.green = Int(255.99 * green)
        self.blue = Int(255.99 * blue)
    }

}
