//
//  RayTracer.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Ray Tracer

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: World,
        configuration: TraceConfiguration
    ) -> String {
        var p3str: String = "P3\n\(camera.pixels.0) \(camera.pixels.1)\n255\n"

        for pixel in camera.allPixels {
            var colors = [Vector3]()

            for _ in 0..<configuration.effectiveAntialiasCount() {
                let ray = camera.ray(through: pixel, applyAntialias: configuration.antialiasing.isOn)
                let color = rayTrace(
                    ray: ray,
                    world: world,
                    configuration: configuration,
                    scatterCount: 0
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

    static func rayTrace(
        ray: Ray,
        world: World,
        configuration: TraceConfiguration,
        scatterCount: Int
    ) -> Vector3 {
        guard
            let intersection = nearestIntersection(
                ray: ray,
                world: world,
                depthRange: configuration.depthRange
            )
        else {
            let unitDirection = ray.direction.normalised
            let t = 0.5 * (unitDirection.y + 1.0)
            return (1.0 - t) * Vector3.unit + t * Vector3(0.5, 0.7, 1.0)
        }

        guard scatterCount < configuration.maxScatters else {
            return Vector3.zero
        }

        guard let (attenuation, scatteredRay) = intersection.shape.material.scatter(incomingRay: ray, intersection: intersection) else {
            return Vector3.zero
        }

        return attenuation * rayTrace(
            ray: scatteredRay,
            world: world,
            configuration: configuration,
            scatterCount: scatterCount + 1
        )
    }

    static func nearestIntersection(
        ray: Ray,
        world: World,
        depthRange: Range<Double>
    ) -> Intersection? {
        var nearest: Intersection?

        for shape in world.shapes {
            guard let intersectableShape = shape as? Intersectable else {
                continue
            }

            let intersection = intersectableShape.intersect(
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
