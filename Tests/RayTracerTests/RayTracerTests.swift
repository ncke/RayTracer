import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    static func randomMaterial() -> Material {
        let r = Double.random(in: 0..<1.0)

        if r < 0.8 {
            let albedo = Albedo(
                Double.random(in: 0..<1.0),
                Double.random(in: 0..<1.0),
                Double.random(in: 0..<1.0)
            )
            return .lambertian(albedo: albedo)

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

    static func randomSphereWorld(probability: Double) -> World {
        let world = World()

        world.addShape(
            Sphere(
                0.0, -10000.0, 0.0,
                radius: 10000.0,
                material: .lambertian(albedo: Albedo(uniform: 0.5))
            )
        )

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
             material: .lambertian(albedo: Albedo(0.4, 0.2, 0.1))
        )

        let bigSphere3 = Sphere(
            3.0, 1.0, 0.0,
            radius: 1.0,
            material: .metal(albedo: Albedo(0.7, 0.6, 0.5), fuzziness: 0.0)
        )

        world.addShapes(bigSphere1, bigSphere2, bigSphere3)

        return world
    }

    func testRayTracer() {
        let camera = Camera(
            lookFrom: (9.0, 0.1, 4.0),//1,5
            lookAt: (0.0, 1.0, 0.0),
            verticalFieldOfView: 25.0,
            pixels: (800, 600)
        )

        let world = RayTracerTests.randomSphereWorld(probability: 0.1)
        var configuration = TraceConfiguration()
        configuration.antialiasing = .off//.on(count: 20)
        configuration.maxScatters = 25
        configuration.maxConcurrentPixels = 12


        let w2 = World()
        w2.addShape(Sphere(0.0, -100.5, -1, radius: 100, material: .lambertian(albedo: Albedo(0.8, 0.8, 0.0))))
        w2.addShape(Sphere(-1,0,-1, radius: 1.0, material: .dielectric(refractiveIndex: RefractiveIndex.glass)))



        var image: ImageArray?

        let semaphore = DispatchSemaphore(value: 0)

        let worker = RayTracer.trace(
            camera: camera,
            world: w2,//world,
            configuration: configuration
        ) { imageArray in

            image = imageArray
            semaphore.signal()
        }

        semaphore.wait()

        let docs = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let filename = docs[0].appendingPathComponent("image.ppm")
        
        try! image!.asP3String.write(
            to: filename,
            atomically: true,
            encoding: .utf8
        )
    }

    static var allTests = [
        ("testRayTracer", testRayTracer),
    ]
    
}
