//
//  RandomSpheres.swift
//  
//
//  Created by Nick on 28/08/2022.
//

import Foundation
import RayTracer

// MARK: - Random Spheres Example

struct RandomSpheres: Example {

    static func world() -> World {
        let probability = 0.7

        let world = World()

        let checkerTexture = CheckerTexture(
            ConstantTexture(r: 0.2, g: 0.3, b: 0.1),
            ConstantTexture(uniform: 0.9),
            scale: 10.0
        )

        let baseSphere = Sphere(
            0.0, -10000.0, 0.0,
            radius: 10000.0,
            material: .lambertian(texture: checkerTexture)
        )

        world.addShape(baseSphere)

        for a in -11...11 {
            for b in -11...11 {

                guard Double.random(in: 0..<1.0) < probability else {
                    continue
                }

                let x = Double(a) + 0.9 * Double.random(in: 0..<1.0)
                let y = 0.2
                let z = Double(b) + 0.9 * Double.random(in: 0..<1.0)

                let sphere = Sphere(
                    x,
                    y,
                    z,
                    radius: 0.2,
                    material: randomMaterial()
                )

                world.addShape(sphere)
            }
        }

        let bigSphere1 = Sphere(
            0.0, 1.0, 0.0,
            radius: 1.0,
            material: .dielectric(refractiveIndex: RefractiveIndex.glass)
        )

        let bigSphere2 = Sphere(
            -3.0, 1.0, 0.0,
             radius: 1.0,
             material: .lambertian(
                texture: ConstantTexture(r: 0.4, g: 0.2, b: 0.1)
             )
        )

        let bigSphere3 = Sphere(
            3.0, 1.0, 0.0,
            radius: 1.0,
            material: .metal(albedo: Albedo(0.7, 0.6, 0.5), fuzziness: 0.0)
        )

        world.addShapes(bigSphere1, bigSphere2, bigSphere3)

        return world
    }

    static func camera() -> Camera {
        Camera(
            lookFrom: (6.0, 0.8, 2.5),
            lookAt: (1.0, 1.0, 0.0),
            verticalFieldOfView: 50.0,
            pixels: (800, 600)
        )
    }

    static func configuration() -> TraceConfiguration {
        var configuration = TraceConfiguration()
        configuration.ambientLightColor = (0.5, 0.7, 1.0)
        configuration.antialiasing = .on(count: 40)
        configuration.maxScatters = 50

        return configuration
    }

}

// MARK: - Random Material

extension RandomSpheres {

    static func randomMaterial() -> Material {
        let r = Double.random(in: 0..<1.0)

        if r < 0.8 {
            return .lambertian(texture: randomTexture())

        } else if r < 0.95 {
            let albedo = Albedo(
                0.5 * (1.0 + Double.random(in: 0..<1.0)),
                0.5 * (1.0 + Double.random(in: 0..<1.0)),
                0.5 * (1.0 + Double.random(in: 0..<1.0))
            )
            return .metal(
                albedo: albedo,
                fuzziness: Double.random(in: 0..<0.5)
            )

        } else {
            return .dielectric(refractiveIndex: RefractiveIndex.glass)
        }
    }

    static func randomTexture() -> Texture {
        ConstantTexture(
            r: Double.random(in: 0..<1.0),
            g: Double.random(in: 0..<1.0),
            b: Double.random(in: 0..<1.0)
        )
    }

}
