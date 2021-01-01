import XCTest
@testable import RayTracer

final class RayTracerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RayTracer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
