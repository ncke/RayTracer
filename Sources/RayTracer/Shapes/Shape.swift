//
//  Shape.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Shape

public protocol Shape {

    var material: Material { get }

    var emitter: Emitter? { get }

}
