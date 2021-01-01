import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RayTracerTests.allTests),
        testCase(VectorTests.allTests)
    ]
}
#endif
