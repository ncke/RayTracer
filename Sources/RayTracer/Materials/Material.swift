//
//  Material.swift
//  
//
//  Created by Nick on 29/07/2022.
//

import Foundation

// MARK: - Material

public enum Material {
    case lambertian(albedo: Albedo)
    case metal(albedo: Albedo, fuzziness: Double)
}

// MARK: - Scattering

extension Material {

    func scatter(
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {

        switch self {

        case .lambertian(let albedo):
            return LambertianScattering.scatter(
                albedo: albedo,
                incomingRay: incomingRay,
                intersection: intersection
            )

        case .metal(let albedo, let fuzziness):
            return MetallicScattering.scatter(
                albedo: albedo,
                fuzziness: fuzziness,
                incomingRay: incomingRay,
                intersection: intersection
            )
        }

    }

}