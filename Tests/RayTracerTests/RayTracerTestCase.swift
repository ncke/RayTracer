//  RayTracerTestCase.swift
//  Created by Nick on 03/01/2021.

import XCTest
@testable import RayTracer

class RayTracerTestCase: XCTestCase {

    /// Tolerance (+/-) for floating point tests.
    static let epsilon = 1E-9

    func AssertEqualVector(_ u: Vector, _ v: Vector) {
        XCTAssertEqual(u.x, v.x, accuracy: Self.epsilon)
        XCTAssertEqual(u.y, v.y, accuracy: Self.epsilon)
        XCTAssertEqual(u.z, v.z, accuracy: Self.epsilon)
    }

    func AssertEqualPoint(_ a: Point, _ b: Point) {
        XCTAssertEqual(a.x, b.x, accuracy: Self.epsilon)
        XCTAssertEqual(a.y, b.y, accuracy: Self.epsilon)
        XCTAssertEqual(a.z, b.z, accuracy: Self.epsilon)
    }

    func AssertEqualRay(_ a: Ray, _ b: Ray) {
        AssertEqualPoint(a.origin, b.origin)
        AssertEqualVector(a.direction, b.direction)
    }

}
