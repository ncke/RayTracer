import Foundation
import RayTracer

struct PerlinSphere: Example {

    static func world() -> World {
        let baseTexture = NoiseTexture(r: 0.2, g: 0.2, b: 1.0, scale: 4.0)
        let baseSphere = Sphere(
            0.0, -1000.0, 0.0,
            radius: 1000.0,
            material: .lambertian(texture: baseTexture))

        let topTexture = NoiseTexture(r: 0.2, g: 1.0, b: 0.2, scale: 8.0)
        let topSphere = Sphere(
            0.0, 2.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: topTexture))

        return World(baseSphere, topSphere)
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
