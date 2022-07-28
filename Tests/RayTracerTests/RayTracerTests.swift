import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    func testRayTracer() {
        let camera = Camera(
            origin: (0.0, 0.0, 0.0),
            size: (4.0, 2.0),
            pixels: (400, 200)
        )

        //let sphere1 = Sphere(0.0, 0.0, -4.0, 1.0)
        //let sphere2 = Sphere(1.5, 1.5, -8.0, 3.0)

        let sphere1 = Sphere(0.0, 0.0, -1.0, 0.5)
        let sphere2 = Sphere(0.0, -100.5, -1.0, 100.0)

        let scene = [sphere1, sphere2]

        let result = RayTracer.trace(
            camera: camera,
            world: scene,
            depthRange: 0.1..<1000.0,
            antialiasing: Antialiasing.on(count: 20)
        )

        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = docs[0].appendingPathComponent("image.ppm")
        try! result.write(to: filename, atomically: true, encoding: .utf8)
    }

    static var allTests = [
        ("testRayTracer", testRayTracer),
    ]
    
}
