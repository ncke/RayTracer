import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    static func randomTexture() -> Texture {
        ConstantTexture(
            r: Double.random(in: 0..<1.0),
            g: Double.random(in: 0..<1.0),
            b: Double.random(in: 0..<1.0)
        )
    }

    static func randomMaterial() -> Material {
//        let e = Double.random(in: 0..<1.0)
//        if e < 0.4 {
//            return .diffuseLight(emitter: DiffuseLight(r: 4.0, g: 4.0, b: 4.0))
//        }

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

    static func randomSphereWorld(probability: Double) -> World {
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

    static func glassBallSandwichWorld() -> World {
        let world = World()

        let baseSphere = Sphere(
            0.0, -100.0, 0.0,
            radius: 100,
            material: .lambertian(
                texture: ConstantTexture(r: 0.8, g: 0.8, b: 0.0)
            )
        )

        let glassBall = Sphere(
            0.0, 1.0, 0.0,
            radius: 1.0,
            material: .dielectric(refractiveIndex: RefractiveIndex.glass)
        )

        let sphereBehind = Sphere(
            1.25, 1.0, -2.0,
            radius: 1.0,
            material: .lambertian(
                texture: ConstantTexture(r: 0.8, g: 0.2, b: 0.2)
            )
        )

        let sphereInFront = Sphere(
            -0.5, 0.5, 1.0,
            radius: 0.5,
            material: .lambertian(
                texture: ConstantTexture(r: 0.2, g: 0.3, b: 0.4)
            )
        )

        world.addShapes(baseSphere, glassBall, sphereBehind, sphereInFront)

        return world
    }

    func perlinSpheresWorld() -> World {
        let world = World()

        let baseTexture = NoiseTexture(r: 0.2, g: 0.2, b: 1.0, scale: 4.0)
        let baseSphere = Sphere(
            0.0, -1000.0, 0.0,
            radius: 1000.0,
            material: .lambertian(texture: baseTexture)
        )

        let topTexture = NoiseTexture(r: 0.2, g: 1.0, b: 0.2, scale: 8.0)
        let topSphere = Sphere(
            0.0, 2.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: topTexture)
        )

        world.addShape(baseSphere)
        world.addShape(topSphere)

        return world
    }

    func illuminatedPerlinSpheresWorld() -> (World, Camera) {
        let world = World()

        let baseTexture = NoiseTexture(r: 0.7, g: 0.7, b: 0.7, scale: 4.0)
        let baseSphere = Sphere(
            0.0, -1000.0, 0.0,
            radius: 1000.0,
            material: .lambertian(texture: baseTexture)
        )

        let centralTexture = NoiseTexture(r: 0.8, g: 0.8, b: 0.8, scale: 8.0)
        let centralSphere = Sphere(
            0.0, 2.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: centralTexture)
        )

        let litRectangle = XYRectangle(
            x0: 3.0, y0: 1.0,
            x1: 5.0, y1: 3.0,
            z: -2.0,
            material: .lambertian(texture: ConstantTexture(uniform: 4.0)),
            emitter: DiffuseLight(r: 4.0, g: 4.0, b: 4.0)
        )

        //let litSphere = Sphere(0.0, 7.0, 0.0, radius: 2.0, material: .lambertian(texture: ConstantTexture(uniform: 4.0)), emitter: DiffuseLight(r: 4.0, g: 4.0, b: 4.0))

        world.addShapes(baseSphere, centralSphere, litRectangle/*, litSphere*/)

        let camera = Camera(
            lookFrom: (12.0, 1.5, 2.5),
            lookAt: (0.0, 1.0, 0.0),
            verticalFieldOfView: 45.0,
            pixels: (800, 600)
        )

        return (world, camera)
    }

    func imageTextureSphereWorld() -> World {
        let world = World()

        let url = Bundle.module.url(
            forResource: "Earth-2048x1024",
            withExtension: "jpeg"
        )!

        let data = try! Data(contentsOf: url)
        let nsImage = NSImage(data: data)!
        let imageMap = ImageMap.fromNSImage(nsImage)!

        let earthTexture = ImageTexture(imageMap: imageMap)
        let earthSphere = Sphere(
            0.0, 2.0, 0.0,
            radius: 2.0,
            material: .lambertian(texture: earthTexture)
        )

        world.addShape(earthSphere)

        return world
    }

    func cornellBoxWorld() -> (World, Camera) {
        let redMaterial = Material.lambertian(
            texture: ConstantTexture(r: 0.65, g: 0.05, b: 0.05)
        )
        let greenMaterial = Material.lambertian(
            texture: ConstantTexture(r: 0.12, g: 0.45, b: 0.15)
        )
        let whiteMaterial = Material.lambertian(
            texture: ConstantTexture(uniform: 0.73)
        )
        let lightEmitter = DiffuseLight(r: 15.0, g: 15.0, b: 15.0)

        let greenWall = YZRectangle(
            y0: 0.0, z0: 0.0, y1: 555.0, z1: 555.0,
            x: 555.0,
            material: greenMaterial
        )
        let redWall = YZRectangle(
            y0: 0.0, z0: 0.0, y1: 555.0, z1: 555.0,
            x: 0.0,
            material: redMaterial
        )
        let floor = XZRectangle(
            x0: 0.0, z0: 0.0, x1: 555.0, z1: 555.0,
            y: 0.0,
            material: whiteMaterial
        )
        let ceiling = XZRectangle(
            x0: 0.0, z0: 0.0, x1: 555.0, z1: 555.0,
            y: 555.0,
            material: whiteMaterial
        )
        let back = XYRectangle(
            x0: 0.0, y0: 0.0, x1: 555.0, y1: 555.0,
            z: 555.0,
            material: whiteMaterial
        )
        let light = XZRectangle(
            x0: 113.0, z0: 127.0, x1: 443.0, z1: 432.0,
            y: 554.0,
            material: .nonscattering,
            emitter: lightEmitter
        )

        let world = World()
        world.addShapes(greenWall, redWall, floor, ceiling, back, light)

        let box1 = Box(p0: (130.0, 0.0, 65.0), p1: (295.0, 165.0, 230.0), material: whiteMaterial)
        let box2 = Box(p0: (265.0, 0.0, 295.0), p1: (430.0, 330.0, 460.0), material: whiteMaterial)

        world.addShapes(box1, box2)

        let camera = Camera(
            lookFrom: (278.0, 278.0, -800.0),
            lookAt: (278.0, 278.0, 0.0),
            verticalFieldOfView: 40.0,
            pixels: (600, 400)
        )

        return (world, camera)
    }

    func testRayTracer() {
//        let camera = Camera(
//            lookFrom: (9.0, 1.5, 2.5),
//            lookAt: (0.0, 1.0, 0.0),
//            verticalFieldOfView: 35.0,
//            pixels: (800, 600)
//        )

        //let world = RayTracerTests.randomSphereWorld(probability: 0.3)
        //let world = perlinSpheresWorld()
        //let world = imageTextureSphereWorld()
        let (world, camera) = cornellBoxWorld()

        var configuration = TraceConfiguration()
        configuration.antialiasing = .on(count: 20)
        configuration.maxScatters = 50
        configuration.maxConcurrentPixels = 12

        var image: ImageMap?

        let semaphore = DispatchSemaphore(value: 0)

        let startTime = Date()

        let worker = RayTracer.trace(
            camera: camera,
            world: world,
            configuration: configuration
        ) { imageArray in

            image = imageArray
            semaphore.signal()
        }

        semaphore.wait()

        let stopTime = Date()

        print("⏱ time elapsed: ", stopTime.timeIntervalSince(startTime), " secs")

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
