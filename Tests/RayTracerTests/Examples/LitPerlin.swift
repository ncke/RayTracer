import Foundation
import RayTracer

struct LitPerlin: Example {

    static func world() -> World {
        let world = World()

        let baseTexture = NoiseTexture(r: 0.7, g: 0.7, b: 0.7, scale: 4.0)
        let baseSphere = Sphere(
            0.0, -1000.0, 0.0,
            radius: 1000.0,
            material: .lambertian(texture: baseTexture))

        let centralTexture = NoiseTexture(r: 0.8, g: 0.8, b: 0.8, scale: 8.0)
        let centralSphere = Sphere(
            0.0, 2.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: centralTexture))

        let litRectangle = XYRectangle(
            x0: 3.0, y0: 1.0,
            x1: 5.0, y1: 3.0,
            z: -2.0,
            material: .lambertian(texture: ConstantTexture(uniform: 4.0)),
            emitter: DiffuseLight(r: 4.0, g: 4.0, b: 4.0))

        world.addShapes(baseSphere, centralSphere, litRectangle)

        return world
    }

    static func camera() -> Camera {
        Camera(
            lookFrom: (12.0, 1.5, 2.5),
            lookAt: (0.0, 1.0, 0.0),
            verticalFieldOfView: 45.0,
            pixels: (800, 600))
    }

    static func configuration() -> TraceConfiguration {
        var configuration = TraceConfiguration()
        configuration.antialiasing = .on(count: 100)
        configuration.maxScatters = 50

        return configuration
    }

}
