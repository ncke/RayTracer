//
//  DiffuseEmitting.swift
//  
//
//  Created by Nick on 14/08/2022.
//

import Foundation

struct DiffuseEmitting {

    static func emit(
        emitter: Emitter,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray?)? {
        guard let emitter = emitter as? Emitting else {
            return nil
        }
        
        let (u, v) = intersection.uvCoordinate
        let attenuation = emitter.color(
            u: u,
            v: v,
            position: intersection.hitPoint
        )

        return (attenuation, nil)
    }

}
