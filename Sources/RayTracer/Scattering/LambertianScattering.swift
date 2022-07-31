//
//  Scattering.swift
//  
//
//  Created by Nick on 31/07/2022.
//

import Foundation

struct LambertianScattering {

    static func scatter(
        albedo: Albedo,
        incomingRay: Ray,
        intersection: Intersection
    ) -> (Vector3, Ray)? {

        let target = intersection.hitPoint
            + intersection.normal
            + Sphere.randomInteriorPoint(radius: 1.0)

        let scattered = Ray(
            origin: intersection.hitPoint,
            direction: target - intersection.hitPoint
        )

        let attenuation = albedo.vector

        return (attenuation, scattered)
    }

}