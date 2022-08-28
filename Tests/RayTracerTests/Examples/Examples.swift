//
//  Examples.swift
//  
//
//  Created by Nick on 28/08/2022.
//

import Foundation
import RayTracer

// MARK: - Example Protocol

protocol Example {
    static func world() -> World
    static func camera() -> Camera
    static func configuration() -> TraceConfiguration
}

// MARK: - Available Examples

enum Examples {
    case cornellBox
    case earth
    case glassBall
    case litPerlin
    case perlinSphere
    case randomSpheres
}

// MARK: - Properties

extension Examples {

    func world() -> World {
        example.world()
    }

    func camera() -> Camera {
        example.camera()
    }

    func configuration() -> TraceConfiguration {
        example.configuration()
    }

    private var example: Example.Type {
        switch self {
        case .cornellBox: return CornellBox.self
        case .earth: return Earth.self
        case .glassBall: return GlassBall.self
        case .litPerlin: return LitPerlin.self
        case .perlinSphere: return PerlinSphere.self
        case .randomSpheres: return RandomSpheres.self
        }
    }
    
}
