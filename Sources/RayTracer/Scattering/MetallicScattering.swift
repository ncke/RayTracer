//
//  MetallicScattering.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

struct MetallicScattering {

    static func scatter(
        albedo: Albedo,
        fuzziness: Double,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {
        var reflected = incomingRay.direction.normalised.reflected(
            normal: intersection.normal
        )

        if fuzziness > Double.zero {
            let peturbation = Sphere.randomInteriorPoint(radius: 1.0)
            reflected += fuzziness * peturbation
        }

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: reflected
        )

        if scattered.direction ⋅ intersection.normal > Double.zero {
            let attenuation = albedo.vector
            return (attenuation, scattered)
        }

        return nil
    }

}
