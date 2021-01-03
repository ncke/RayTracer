import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {

    func testRayTracer() {
        let tracer = RayTracer()
        let image = tracer.trace()

        XCTAssertNotNil(image)
    }

    static var allTests = [
        ("testRayTracer", testRayTracer),
    ]
    
}
