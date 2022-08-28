import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    func testRayTracer() {
        let example = Examples.earth

        let world = example.world()
        let camera = example.camera()
        let configuration = example.configuration()

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
