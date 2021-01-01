//  VectorTests.swift
//  Created by Nick on 01/01/2021.

import XCTest
@testable import RayTracer

final class VectorTests: XCTestCase {

    /// Tolerance (+/-) for floating point tests.
    static let epsilon = 1E-9

    func AssertEqualVector(_ u: Vector, _ v: Vector) {
        XCTAssertEqual(u.x, v.x, accuracy: VectorTests.epsilon)
        XCTAssertEqual(u.y, v.y, accuracy: VectorTests.epsilon)
        XCTAssertEqual(u.z, v.z, accuracy: VectorTests.epsilon)
    }

    func testZero() {
        let expected = Vector(0.0, 0.0, 0.0)
        AssertEqualVector(Vector.zero, expected)
    }

    func testUnit() {
        let expected = Vector(1.0, 1.0, 1.0)
        AssertEqualVector(Vector.unit, expected)
    }

    func testLength() {
        let u = Vector(4.0, 2.0, 4.0)
        XCTAssertEqual(u.length, 6.0, accuracy: VectorTests.epsilon)
    }

    func testNormalized() {
        let u = Vector(4.0, 2.0, 4.0).normalized
        let expected = Vector(2.0/3.0, 1.0/3.0, 2.0/3.0)
        AssertEqualVector(u, expected)

    }

    func testAddition() {
        let u = Vector(1.0, 2.5, 9.2)
        let v = Vector(-3.2, 1.0, 2.1)
        let expected = Vector(-2.2, 3.5, 11.3)

        AssertEqualVector(u + v, expected)
        AssertEqualVector(v + u, expected)
    }

    func testSubtraction() {
        let u = Vector(9.5, 0.2, 5.9)
        let v = Vector(-0.1, 2.3, 8.3)
        let expected = Vector(9.6, -2.1, -2.4)

        AssertEqualVector(u - v, expected)
    }

    func testScalarMultiplication() {
        let u = Vector(2.5, 1.2, -0.2)
        let s = 3.0
        let expected = Vector(7.5, 3.6, -0.6)

        AssertEqualVector(s * u, expected)
        AssertEqualVector(u * s, expected)
    }

    func testCrossProduct() {
        let u = Vector(4.0, 6.0, 8.0)
        let v = Vector(3.0, 2.0, 5.0)
        let expected = Vector(14.0, 4.0, -10.0)

        AssertEqualVector(u ✕ v, expected)
    }

    func testDotProduct() {
        let u = Vector(4.0, 6.0, 8.0)
        let v = Vector(3.0, 2.0, 5.0)
        let expected = 64.0

        XCTAssertEqual(u • v, expected, accuracy: VectorTests.epsilon)
    }

    static var allTests = [
        ("testLength", testLength),
        ("testNormalized", testNormalized),
        ("testAddition", testAddition),
        ("testSubtraction", testSubtraction),
        ("testScalarMultiplication", testScalarMultiplication),
        ("testCrossProduct", testCrossProduct),
        ("testDotProduct", testDotProduct),
    ]
    
}
