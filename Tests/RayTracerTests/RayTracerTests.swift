import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    func testRayTracer() {
        let camera = Camera(
            origin: (0.0, 0.0, 0.0),
            size: (4.0, 2.0),
            pixels: (400, 200)
        )

        let sphere1 = Sphere(0.0, 0.0, -1.0, radius: 0.5, material: .lambertian(albedo: Albedo(0.8, 0.3, 0.3)))
        let sphere2 = Sphere(0.0, -100.5, -1.0, radius: 100.0, material: .lambertian(albedo: Albedo(0.8, 0.8, 0.0)))
        let sphere3 = Sphere(1.0, 0.0, -1.0, radius: 0.5, material: .metal(albedo: Albedo(0.8, 0.6, 0.2), fuzziness: 1.0))
        let sphere4 = Sphere(-1.0, 0.0, -1.0, radius: 0.5, material: .metal(albedo: Albedo(uniform: 0.8), fuzziness: 0.3))


        let world = World()
        world.addShapes(sphere1, sphere2, sphere3, sphere4)

        var configuration = TraceConfiguration()
        configuration.antialiasing = .on(count: 20)
        configuration.maxScatters = 50


        let result = RayTracer.trace(
            camera: camera,
            world: world,
            configuration: configuration
        )

        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = docs[0].appendingPathComponent("image.ppm")
        try! result.write(to: filename, atomically: true, encoding: .utf8)
    }

    static var allTests = [
        ("testRayTracer", testRayTracer),
    ]
    
}
