import Foundation
import RayTracer

struct CornellBox: Example {

    static func world() -> World {
        let red = Material.lambertian(
            texture: ConstantTexture(r: 0.65, g: 0.05, b: 0.05))

        let green = Material.lambertian(
            texture: ConstantTexture(r: 0.12, g: 0.45, b: 0.15))

        let white = Material.lambertian(
            texture: ConstantTexture(uniform: 0.73))

        let diffuseLight = DiffuseLight(r: 15.0, g: 15.0, b: 15.0)

        let greenWall = YZRectangle(
            y0: 0.0, z0: 0.0, y1: 555.0, z1: 555.0,
            x: 555.0,
            material: green)

        let redWall = YZRectangle(
            y0: 0.0, z0: 0.0, y1: 555.0, z1: 555.0,
            x: 0.0,
            material: red)

        let floor = XZRectangle(
            x0: 0.0, z0: 0.0, x1: 555.0, z1: 555.0,
            y: 0.0,
            material: white)

        let ceiling = XZRectangle(
            x0: 0.0, z0: 0.0, x1: 555.0, z1: 555.0,
            y: 555.0,
            material: white)

        let back = XYRectangle(
            x0: 0.0, y0: 0.0, x1: 555.0, y1: 555.0,
            z: 555.0,
            material: white)

        let light = XZRectangle(
            x0: 213.0, z0: 227.0, x1: 343.0, z1: 332.0,
            y: 554.0,
            material: .nonscattering,
            emitter: diffuseLight)

        let world = World(greenWall, redWall, floor, ceiling, back, light)

        let box1 = Box(
            oppositeCorners: (130.0, 0.0, 65.0), (295.0, 165.0, 230.0),
            material: white)

        let box2 = Box(
            oppositeCorners: (265.0, 0.0, 295.0), (430.0, 330.0, 460.0),
            material: white)

        world.addShapes(box1, box2)

        return world
    }

    static func camera() -> Camera {
        Camera(
            lookFrom: (278.0, 278.0, -800.0),
            lookAt: (278.0, 278.0, 0.0),
            verticalFieldOfView: 40.0,
            pixels: (600, 400))
    }

    static func configuration() -> TraceConfiguration {
        var configuration = TraceConfiguration()
        configuration.antialiasing = .on(count: 100)
        configuration.maxScatters = 50

        return configuration
    }

}
