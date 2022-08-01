//
//  RayTracer.swift
//  Created by Nick on 19/04/2022.
//

import Foundation

// MARK: - Ray Tracer

public typealias RayTraceCompletion = (ImageArray) -> Void

public struct RayTracer {

    public static func trace(
        camera: Camera,
        world: World,
        configuration: TraceConfiguration,
        completion: @escaping RayTraceCompletion
    ) -> RayTracerWorker {

        return RayTracerWorker(
            world: world,
            camera: camera,
            configuration: configuration,
            completion: completion
        )
    }

}

// MARK: - Ray Tracing

extension RayTracer {

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

        guard let (attenuation, scatteredRay) = intersection.shape.material.scatter(
            incomingRay: ray,
            intersection: intersection
        ) else {
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

            if intersected.hitDistance < nearestSoFar.hitDistance {
                nearest = intersected
            }
        }

        return nearest
    }

}

// MARK: - Worker

public class RayTracerWorker {
    private let imageArray: ImageArray
    private let world: World
    private let camera: Camera
    private let configuration: TraceConfiguration
    private var completion: RayTraceCompletion?

    private let traceQueue: DispatchQueue
    private let writeQueue: DispatchQueue
    private var pixels: ImageArray.PixelSequence
    private var working = 0

    init(
        world: World,
        camera: Camera,
        configuration: TraceConfiguration,
        completion: @escaping RayTraceCompletion
    ) {
        self.imageArray = ImageArray(size: camera.pixels)
        self.world = world
        self.camera = camera
        self.configuration = configuration
        self.completion = completion

        traceQueue = DispatchQueue(
            label: "com.raytracer.trace-queue",
            qos: configuration.traceQoS,
            attributes: .concurrent
        )

        writeQueue = DispatchQueue(
            label: "com.raytracer.trace-queue",
            qos: configuration.traceQoS
        )

        pixels = imageArray.allPixels

        for _ in 0..<configuration.maxConcurrentPixels {
            commit()
        }
    }

    func commit() {
        writeQueue.async {
            guard let pixel = self.pixels.next() else {
                if self.working == 0 {
                    if let completion = self.completion {
                        self.completion = nil
                        completion(self.imageArray)
                    }
                }

                return
            }

            self.working += 1

            self.traceQueue.async {
                var colors = [Vector3]()

                for _ in 0..<self.configuration.effectiveAntialiasCount() {
                    let ray = self.camera.ray(
                        through: pixel,
                        applyAntialias: self.configuration.antialiasing.isOn
                    )

                    let color = RayTracer.rayTrace(
                        ray: ray,
                        world: self.world,
                        configuration: self.configuration,
                        scatterCount: 0
                    )

                    colors.append(color)
                }

                guard let average = colors.average else {
                    fatalError()
                }

                let rgb = RGBColor(average, gamma: .gamma2)

                self.writeQueue.async {
                    self.imageArray.setPixel(at: pixel, rgb: rgb)
                    self.working -= 1

                    self.commit()
                }
            }
        }
    }

}
