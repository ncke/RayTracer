//
//  RayTracer.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: [Shape],
        depthRange: Range<Double>,
        antialiasing: Antialiasing
    ) -> String {
        var p3str: String = "P3\n\(camera.pixels.0) \(camera.pixels.1)\n255\n"

        let intersectables = world.compactMap {
            shape in shape as? Intersectable
        }

        let antialiased = antialiasing.isOn
        let antialiasCount = antialiasing.antialiasCount ?? 1

        for pixel in camera.allPixels {
            var colors = [Vector3]()

            for _ in 0..<antialiasCount {
                let ray = camera.ray(through: pixel, antialiased: antialiased)
                let color = colorVector(
                    ray: ray,
                    shapes: intersectables,
                    depthRange: depthRange
                )

                colors.append(color)
            }

            guard let average = colors.average else {
                fatalError()
            }

            let rgb = RGBColor(average, gamma: .gamma2)
            p3str += "\(rgb.red) \(rgb.green) \(rgb.blue)\n"
        }

        return p3str
    }

    static func colorVector(
        ray: Ray,
        shapes: [Intersectable],
        depthRange: Range<Double>
    ) -> Vector3 {
        guard
            let intersection = nearestIntersection(
                ray: ray,
                shapes: shapes,
                depthRange: depthRange
            )
        else {
            let unitDirection = ray.direction.normalised
            let t = 0.5 * (unitDirection.y + 1.0)
            return (1.0 - t) * Vector3.unit + t * Vector3(0.5, 0.7, 1.0)
        }

        let target = intersection.hitPoint
            + intersection.normal
            + Sphere.unit.randomInteriorPoint

        let outgoingRay = Ray(
            origin: intersection.hitPoint,
            direction: target - intersection.hitPoint
        )

        return 0.5 * colorVector(
            ray: outgoingRay,
            shapes: shapes,
            depthRange: depthRange
        )
    }

    static func nearestIntersection(
        ray: Ray,
        shapes: [Intersectable],
        depthRange: Range<Double>
    ) -> IntersectionRecord? {
        var nearest: IntersectionRecord?

        for shape in shapes {
            let intersection = shape.intersection(
                ray: ray,
                tRange: depthRange
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

}
