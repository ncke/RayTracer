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
