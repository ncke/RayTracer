//
//  DielectricScattering.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Dielectric Scattering

struct DielectricScattering {

    private static let unattenuated = Vector3(1.0, 1.0, 1.0)

    static func scatter(
        refractiveIndex: RefractiveIndex,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {
        let refracted = incomingRay.direction.refracted(
            normal: intersection.normal,
            refractiveIndex: refractiveIndex.index
        )

        let attenuation = DielectricScattering.unattenuated

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: refracted
        )

        return (attenuation, scattered)
    }

}
