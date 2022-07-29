//
//  Material.swift
//  
//
//  Created by Nick on 29/07/2022.
//

import Foundation

// MARK: - Material

public enum Material {
    case diffuse(albedo: (Double, Double, Double))
    case metal(albedo: (Double, Double, Double))
}

// MARK: - Scattering

extension Material {

    func scatter(
        incomingRay: Ray,
        intersection: IntersectionRecord
    ) -> (Bool, Vector3?, Ray?) {

        switch self {

        case .diffuse(let albedo):
            let target = intersection.hitPoint
                + intersection.normal
                + Sphere.unit.randomInteriorPoint

            let scatter = Ray(
                origin: intersection.hitPoint,
                direction: target - intersection.hitPoint
            )

            let attenuation = Vector3(albedo)

            return (true, attenuation, scatter)


        case .metal(let albedo):
            let reflected = incomingRay.direction.normalised.reflected(
                normal: intersection.normal
            )

            let scatter = Ray(intersection.hitPoint, reflected)

            if scatter.direction ⋅ intersection.normal > 0.0 {
                let attenuation = Vector3(albedo)
                return (true, attenuation, scatter)
            }

            return (false, nil, nil)
        }

    }

}
