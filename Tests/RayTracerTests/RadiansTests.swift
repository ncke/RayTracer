//  Radians.swift
//  Created by Nick on 03/01/2021.

import Foundation

import XCTest
@testable import RayTracer

class RadiansTests: RayTracerTestCase {

    func testDegreesInitialiser() {
        let r1 = Radians(degrees: 0.0)
        XCTAssertEqual(
            r1,
            Radians.zero,
            accuracy: Self.epsilon
        )

        let r2 = Radians(degrees: 45.0)
        XCTAssertEqual(
            r2,
            Double.pi / 4.0,
            accuracy: Self.epsilon
        )

        let r3 = Radians(degrees: 120.0)
        XCTAssertEqual(
            r3,
            2.0 * Double.pi / 3.0,
            accuracy: Self.epsilon
        )
    }

    func testAsDegrees() {
        let d1 = Radians(0.0).asDegrees
        XCTAssertEqual(
            d1,
            Double.zero,
            accuracy: Self.epsilon
        )

        let d2 = Radians(2.0 * Double.pi / 3.0).asDegrees
        XCTAssertEqual(
            d2,
            120.0,
            accuracy: Self.epsilon
        )

        let d3 = Radians(4.0 * Double.pi / 3.0).asDegrees
        XCTAssertEqual(
            d3,
            240.0,
            accuracy: Self.epsilon)
    }

    static var allTests = [
        ("testDegreesInitialiser", testDegreesInitialiser),
        ("testAsDegrees", testAsDegrees)
    ]

}
