//
//  Scattering.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

// MARK: - Lambertian Scattering

struct LambertianScattering {

    static func scatter(
        texture: Texture,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {

        let target = intersection.hitPoint
            + intersection.normal
            + Sphere.randomInteriorPoint(radius: Sphere.unitRadius)

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: target - intersection.hitPoint
        )

        guard let textured = texture as? Textured else {
            fatalError()
        }

        let attenuation = textured.color(u: 0.0, v: 0.0)

        return (attenuation, scattered)
    }

}
