//
//  RayTracer.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: [Shape],
        antialiasing: Antialiasing
    ) -> String {
        var p3str: String = "P3\n\(camera.pixels.0) \(camera.pixels.1)\n255\n"

        let intersectables = world.compactMap {
            shape in shape as? Intersectable
        }

        let antialiased = antialiasing.isOn
        let antialiasCount = antialiasing.antialiasCount ?? 1

        for pixel in camera.allPixels {
            var normals = [Vector3]()

            for _ in 0..<antialiasCount {
                let ray = camera.ray(through: pixel, antialiased: antialiased)

                guard let intersection = nearestIntersection(
                    ray: ray,
                    shapes: intersectables
                ) else {
                    continue
                }

                let target = intersection.hitPoint + intersection.normal + Sphere.unit.randomInteriorPoint

                let ray2 = Ray(origin: intersection.hitPoint, direction: target - intersection.hitPoint)

                guard let nnn = nearestIntersection(ray: ray2, shapes: intersectables) else {
                    continue
                }


                normals.append(nnn.normal)
            }

            let pixelColor = hitColor(normals: normals)
            p3str += "\(pixelColor.red) \(pixelColor.green) \(pixelColor.blue)\n"
        }

        return p3str
    }

    static func nearestIntersection(
        ray: Ray,
        shapes: [Intersectable]
    ) -> IntersectionRecord? {
        var nearest: IntersectionRecord?

        for shape in shapes {
            let intersection = shape.intersection(
                ray: ray,
                tRange: 0.0..<Double.infinity
            )

            guard let intersected = intersection else {
                continue
            }

            guard let nearestSoFar = nearest else {
                nearest = intersected
                continue
            }

            if intersected.temp < nearestSoFar.temp {
                nearest = intersected
            }
        }

        return nearest
    }

    static func hitColor(normals: [Vector3]) -> ColorVector {
        guard let average = normals.average else {
            return ColorVector(0, 0, 255)
        }

        let rgb = 0.5 * Vector3(
            average.x + 1.0,
            average.y + 1.0,
            average.z + 1.0
        )

        return ColorVector(rgb.x, rgb.y, rgb.z)
    }
    
}
