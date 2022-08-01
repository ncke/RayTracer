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

    static func glassBallSandwichWorld() -> World {
        let world = World()

        let earth = Sphere(
            0.0, -100.0, 0.0,
            radius: 100,
            material: .lambertian(albedo: Albedo(0.8, 0.8, 0.0))
        )

        let glassBall = Sphere(
            0.0, 1.0, 0.0,
            radius: 1.0,
            material: .dielectric(refractiveIndex: RefractiveIndex.glass)
        )

        let sphereBehind = Sphere(
            1.25, 1.0, -2.0,
            radius: 1.0,
            material: .lambertian(albedo: Albedo(0.8, 0.2, 0.2))
        )

        let sphereInFront = Sphere(
            -0.5, 0.5, 1.0,
            radius: 0.5,
            material: .lambertian(albedo: Albedo(0.2, 0.3, 0.4))
        )

        world.addShapes(earth, glassBall, sphereBehind, sphereInFront)

        return world
    }

    func testRayTracer() {
        let camera = Camera(
            lookFrom: (9.0, 0.5, 2.5),
            lookAt: (0.0, 1.0, 0.0),
            verticalFieldOfView: 25.0,
            pixels: (800, 600)
        )

        let world = RayTracerTests.randomSphereWorld(probability: 0.5)
        var configuration = TraceConfiguration()
        configuration.antialiasing = .on(count: 20)
        configuration.maxScatters = 20
        configuration.maxConcurrentPixels = 12

        var image: ImageArray?

        let semaphore = DispatchSemaphore(value: 0)

        let worker = RayTracer.trace(
            camera: camera,
            world: world,
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
