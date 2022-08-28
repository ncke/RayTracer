//
//  Examples.swift
//  
//
//  Created by Nick on 28/08/2022.
//

import Foundation
@testable import RayTracer

protocol Example {
    static func world() -> World
    static func camera() -> Camera
}

enum Examples {
    case randomSphere

    var example: Example.Type {
        switch self {
        case.randomSphere: return RandomSphereExample.self
        }
    }
}
