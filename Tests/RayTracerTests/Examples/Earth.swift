#if canImport(AppKit)
import AppKit
#endif
import Foundation
import RayTracer

struct Earth: Example {

    static func world() -> World {
        let world = World()

        #if canImport(AppKit)
        let url = Bundle.module.url(
            forResource: "Earth-2048x1024",
            withExtension: "jpeg")!
        #else
        fatalError("Requires AppKit")
        #endif

        let data = try! Data(contentsOf: url)
        let nsImage = NSImage(data: data)!
        let imageMap = ImageMap.fromNSImage(nsImage)!

        let earthTexture = ImageTexture(imageMap: imageMap)
        let earthSphere = Sphere(
            0.0, 0.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: earthTexture))

        world.addShape(earthSphere)

        return world
    }

    static func camera() -> Camera {
        Camera(
            lookFrom: (6.0, 2.0, 3.0),
            lookAt: (0.0, 0.0, 0.0),
            verticalFieldOfView: 35.0,
            pixels: (800, 600))
    }

    static func configuration() -> TraceConfiguration {
        var configuration = TraceConfiguration()
        configuration.ambientLightColor = (0.5, 0.7, 1.0)
        configuration.antialiasing = .off
        configuration.maxScatters = 50

        return configuration
    }

}
