import Foundation
import RayTracer

struct GlassBall: Example {

    static func world() -> World {
        let baseSphere = Sphere(
            0.0, -100.0, 0.0,
            radius: 100,
            material: .lambertian(
                texture: ConstantTexture(r: 0.8, g: 0.8, b: 0.0))
        )

        let glassBall = Sphere(
            0.0, 1.0, 0.0,
            radius: 1.0,
            material: .dielectric(refractiveIndex: RefractiveIndex.glass))

        let sphereBehind = Sphere(
            1.25, 1.0, -2.0,
            radius: 1.0,
            material: .lambertian(
                texture: ConstantTexture(r: 0.8, g: 0.2, b: 0.2))
        )

        let sphereInFront = Sphere(
            -0.5, 0.5, 1.0,
            radius: 0.5,
            material: .lambertian(
                texture: ConstantTexture(r: 0.2, g: 0.3, b: 0.4))
        )

        return World(baseSphere, glassBall, sphereBehind, sphereInFront)
    }

    static func camera() -> Camera {
        Camera(
            lookFrom: (9.0, 1.5, 2.5),
            lookAt: (0.0, 1.0, 0.0),
            verticalFieldOfView: 35.0,
            pixels: (800, 600))
    }

    static func configuration() -> TraceConfiguration {
        var configuration = TraceConfiguration()
        configuration.ambientLightColor = (0.5, 0.7, 1.0)
        configuration.antialiasing = .on(count: 20)
        configuration.maxScatters = 50

        return configuration
    }

}
