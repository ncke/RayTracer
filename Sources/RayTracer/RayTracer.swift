//
//  RayTracer.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Ray Tracer

public typealias RayTraceCompletion = (TraceImage) -> Void

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: World,
        configuration: TraceConfiguration,
        progressDelegate: RayTracerProgressDelegate? = nil,
        completion: @escaping RayTraceCompletion
    ) -> RayTracerWorker {

        return RayTracerWorker(
            world: world,
            camera: camera,
            configuration: configuration,
            progressDelegate: progressDelegate,
            completion: completion
        )
    }

}

// MARK: - Ray Tracing

extension RayTracer {

    static func rayTrace(
        ray: Ray,
        tree: IntersectableTree?,
        configuration: TraceConfiguration,
        scatterCount: Int
    ) -> Vector3 {
        guard
            let tree = tree,
            let intersection = World.nearestIntersection(
                intersectableTree: tree,
                ray: ray,
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

        guard
            let (attenuation, scatteredRay) = intersection.shape.material.scatter(
                incomingRay: ray,
                intersection: intersection
            )
        else {
            return Vector3.zero
        }

        return attenuation * rayTrace(
            ray: scatteredRay,
            tree: tree,
            configuration: configuration,
            scatterCount: scatterCount + 1
        )
    }

}
